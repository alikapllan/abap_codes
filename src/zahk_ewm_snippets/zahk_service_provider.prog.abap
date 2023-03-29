*&---------------------------------------------------------------------*
*& Report ZAHK_SERVICE_PROVIDER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_service_provider.

DATA: service_provider TYPE REF TO /scdl/cl_sp_prd_out,
      message_box      TYPE REF TO /scdl/cl_sp_message_box,
      rejected         TYPE abap_bool,
      return_codes     TYPE /scdl/t_sp_return_code,
      lt_ahead         TYPE /scdl/t_sp_a_head.

PARAMETERS: plgnum  TYPE /scwm/lgnum,
            pdlvno  TYPE /scdl/dl_docno_int,
            phead   RADIOBUTTON GROUP slct,
            pstatus RADIOBUTTON GROUP slct.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).

START-OF-SELECTION.
  /scwm/cl_dlv_management_prd=>get_instance(  )->map_docno_to_docid(
                EXPORTING it_docno = VALUE #( ( docno  = pdlvno
                                                doccat = /scdl/if_dl_doc_c=>sc_doccat_out_prd ) )
                IMPORTING et_mapping = DATA(docno_2_docid_map) ).

  IF docno_2_docid_map IS INITIAL.
    MESSAGE 'Die DOCID für die angegebene Liefernummer konnte nicht abgerufen werden. Sicher, dass es existiert?'
        TYPE 'E'.
  ENDIF.

  message_box = NEW #( ).

  service_provider = NEW #( io_message_box = message_box
                            iv_doccat      = /scdl/if_dl_doc_c=>sc_doccat_out_prd
                            iv_mode        = /scdl/cl_sp=>sc_mode_classic ).

  DATA(lt_inkeys_head) = VALUE /scdl/t_sp_k_head( ( docid = docno_2_docid_map[ 1 ]-docid ) ).
  service_provider->lock(
    EXPORTING
      inkeys       =  lt_inkeys_head
      aspect       =  /scdl/if_sp_c=>sc_asp_head
      lockmode     =  /scdl/if_sp1_locking=>sc_exclusive_lock
    IMPORTING
      rejected     =  rejected
      return_codes =  return_codes
  ).

  READ TABLE return_codes TRANSPORTING NO FIELDS WITH KEY failed = abap_true.
  IF sy-subrc = 0 OR rejected = abap_true .
    RETURN.
  ENDIF.
  service_provider->select(
      EXPORTING
        inkeys       = lt_inkeys_head
        aspect       = /scdl/if_sp_c=>sc_asp_head
      IMPORTING
        outrecords   = lt_ahead
        rejected     = rejected
        return_codes = return_codes ).
  READ TABLE return_codes TRANSPORTING NO FIELDS WITH KEY failed = abap_true.
  IF sy-subrc = 0 OR rejected = abap_true.
    " Handle error here
    RETURN.
  ENDIF.
  cl_demo_output=>display( data = lt_ahead ).
