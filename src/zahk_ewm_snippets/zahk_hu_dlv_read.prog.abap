*&---------------------------------------------------------------------*
*& Report ZAHK_HU_DLV_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*& This report demonstrates the process of simply reading the huheader from an inbound delivery.
*& It is also possible to use the following examples for outbound deliverys.
*&
*& The HU header contains important informations like:
*& Name of HU creator, guid hu, max height/width/lenght, storage place etc.
*& This report shows three ways to read an hu from a delivery.
*& You can choose the case which is most suitable for your specific need.

REPORT zahk_hu_dlv_read.

DATA: huheaders           TYPE /scwm/tt_huhdr_int,
      delivery_service_hu TYPE REF TO /scwm/if_dlv_service_hu.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.
PARAMETERS: pdoccat TYPE /scwm/de_doccat DEFAULT 'PDI', "PDI = Inbound Delivery
            pdocno  TYPE /scdl/dl_docno_int DEFAULT '310000001318',
            popt1   RADIOBUTTON GROUP slct,
            popt2   RADIOBUTTON GROUP slct,
            popt3   RADIOBUTTON GROUP slct.
SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  input = 'Demo Input Data'.
  info = 'Report zeigt, wie eine Lieferung auszulesen ist.'.

START-OF-SELECTION.

  "Here we want to retrieve the more unique identifier, the DOCID by handing in our user friendly, readable, DOCNO.
  /scwm/cl_dlv_management_prd=>get_instance(  )->map_docno_to_docid( EXPORTING it_docno = VALUE #( ( docno  = pdocno
                                                                                                     doccat = pdoccat ) )
                                                                     IMPORTING et_mapping = DATA(docno_2_docid_map) ).
  IF docno_2_docid_map IS INITIAL.
    WRITE: 'keine Docid konnte gefunden werden.'.
    RETURN.
  ENDIF.
  " Initialize and fill the required table of docid's which is neccessary for the following function module.
  DATA(doc_ids) = VALUE /scwm/tt_docid( ( docid = docno_2_docid_map[ 1 ]-docid ) ).

  CASE abap_true.
    WHEN popt1.
      " This function module delivers all the hu's of the delivery. In this case all hu's of the Inbound delivery.
      " Therefore we need to pass the table with docids, we have read before.
      CALL FUNCTION '/SCWM/DLV_GET_HUS_FOR_DLV_HEAD'
        EXPORTING
          it_docid = doc_ids
        IMPORTING
          et_huhdr = huheaders
        EXCEPTIONS
          OTHERS   = 99.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN popt2.
      " In this case we use the interface /scwm/if_dlv_service_hu,
      " more specific the method '/SCWM/DLV_GET_HUS_FOR_DELIVERY' to read all hus from a delivery.
      " To use this, we first need to create an instance of it.
      CALL FUNCTION '/SCWM/DLV_GET_HUS_FOR_DELIVERY'
        EXPORTING
          iv_doccat = pdoccat
          it_docid  = doc_ids
        IMPORTING
          et_huhdr  = huheaders
        EXCEPTIONS
          OTHERS    = 99.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN popt3.
      " Use delivery service class to read delivery head
      " In this case we use the method dlv_get_hu_assignment from the interface /scwm/if_dlv_service_hu.
      " First we need to append all ids we read previously to the table of doc ids.
      /scwm/cl_dlv_service=>get_instance_direct( IMPORTING eo_service = delivery_service_hu ).
      delivery_service_hu->dlv_get_hu_assignment(
        EXPORTING
          it_docid = VALUE #( ( docid  = docno_2_docid_map[ 1 ]-docid
                                doccat = docno_2_docid_map[ 1 ]-doccat ) )
        IMPORTING
          et_huhdr = huheaders
        EXCEPTIONS
          OTHERS   = 99 ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

  ENDCASE.

  IF huheaders IS INITIAL.
    WRITE: 'Nichts aus der HU konnte gelesen werden.'.
  ENDIF.
