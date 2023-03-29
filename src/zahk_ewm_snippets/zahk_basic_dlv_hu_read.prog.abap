*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_DLV_HU_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*&
*& This report shows how to get the delivery by using the huident.
*&
REPORT zahk_basic_dlv_hu_read.

DATA: delivery_service     TYPE REF TO /scwm/if_dlv_service_hu,
      delivery_assignments TYPE /scwm/dlv_docid_item_tab,
      huheader             TYPE /scwm/s_huhdr_int,
      doc_ids              TYPE /scdl/t_sp_k_item,
      hu_data              TYPE /scwm/tt_huitm_int.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS: phu    TYPE /scwm/huident DEFAULT 8000071,
            plgnum TYPE /scwm/lgnum,
            popt1  RADIOBUTTON GROUP slct,
            popt2  RADIOBUTTON GROUP slct,
            popt3  RADIOBUTTON GROUP slct.

SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  input = 'Demo Input Data'.
  info = 'This report show cases to read the delivery of a hu'.
START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).
  CASE abap_true.
    WHEN popt1. " get delivery by using the function module '/SCWM/HU_SELECT_PDO'
      DATA(hu_idents) = VALUE rseloption( ( sign = wmegc_sign_inclusive
                                            option = wmegc_option_eq
                                            low =  phu ) ).

      CALL FUNCTION '/SCWM/HU_SELECT_PDO'
        EXPORTING
          iv_lgnum   = plgnum
          ir_huident = hu_idents
        IMPORTING
          et_docid   = doc_ids
        EXCEPTIONS
          OTHERS     = 99.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    WHEN popt2. " get delivery by using the function module '/SCWM/HU_READ'
      CALL FUNCTION '/SCWM/HU_READ'
        EXPORTING
          iv_appl    = wmegc_huappl_wme
          iv_lgnum   = plgnum
          iv_huident = phu
        IMPORTING
          et_huitm   = hu_data
        EXCEPTIONS
          OTHERS     = 99.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      doc_ids = VALUE #( ( docid = hu_data[ 1 ]-qdocid
                            itemid = hu_data[ 1 ]-qitmid
                         ) ).
    WHEN popt3.
      " get delivery by using the function module '/SCWM/HUHEADER_READ'
      " and the class /scwm/cl_dlv_service
      CALL FUNCTION '/SCWM/HUHEADER_READ'
        EXPORTING
          iv_appl     = wmegc_huappl_wme
          iv_huident  = phu
          iv_nobuff   = abap_false
        IMPORTING
          es_huheader = huheader
        EXCEPTIONS
          OTHERS      = 99.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      /scwm/cl_dlv_service=>get_instance_direct( IMPORTING eo_service = delivery_service ).

      delivery_service->hu_get_dlv_assignment(
        EXPORTING
          iv_tw_direction   = /scwm/if_dlv_service_hu=>sc_hu_outbound_process
          iv_lgnum          = plgnum
          iv_guid_hu        = huheader-guid_hu
          iv_huident        = phu
        IMPORTING
          et_dlv_assignment = delivery_assignments
        EXCEPTIONS
          OTHERS            = 99 ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      doc_ids = VALUE #( ( docid = delivery_assignments[ 1 ]-docid
                            itemid = delivery_assignments[ 1 ]-itemid
                         ) ).
  ENDCASE.
  IF NOT doc_ids IS INITIAL.
    cl_demo_output=>display( data = doc_ids ).
  ENDIF.
