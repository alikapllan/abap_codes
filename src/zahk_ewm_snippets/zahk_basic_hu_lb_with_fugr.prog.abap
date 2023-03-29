*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_HU_LB_WITH_FUGR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_basic_hu_lb_with_fugr.

PARAMETERS:
  phu     TYPE /scwm/huident,
  plgnum  TYPE /scwm/lgnum,
  plgp    TYPE /scwm/de_lgpla DEFAULT '0020-01-02-C',
  pprocty TYPE /scwm/de_procty DEFAULT '9999',
  p_quit  AS CHECKBOX DEFAULT abap_true. "Define if lb should be confirmed or open

DATA: lo_packing   TYPE REF TO /scwm/cl_wm_packing,
      ls_huheader  TYPE /scwm/s_huhdr_int,
      lt_huheader  TYPE /scwm/tt_huhdr_int,
      lt_guid_hu   TYPE /scwm/tt_guid_hu,
      ls_guid_hu   TYPE /scwm/s_guid_hu,
      lt_hu_create TYPE /scwm/tt_to_crea_hu,
      ls_hu_create TYPE /scwm/s_to_crea_hu,
      lv_tanum     TYPE /scwm/tanum,
      lv_severity  TYPE bapi_mtype,
      lt_bapiret   TYPE bapirettab.

INITIALIZATION.

  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).

  CALL FUNCTION '/SCWM/HUHEADER_READ'
    EXPORTING
      iv_appl     = wmegc_huappl_wme
      iv_huident  = phu
      iv_nobuff   = abap_false
    IMPORTING
      es_huheader = ls_huheader
      et_huheader = lt_huheader
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "To ensure the HU will be moved to the right place, the data must be saved into the table beneath. We need to pass the values guid_hu, huident, nlpla, procty and squit.
  "While guid_hu and huident are values to indicate the correct hu, the npla variable define on which storage place the HU should be stored at the end of the moving process.
  "Procty is the warehouse process type which is needed. The importing value squit defines if the lb should be confirmed or not.

  LOOP AT lt_huheader ASSIGNING FIELD-SYMBOL(<ls_header>).
    lt_hu_create = VALUE #( (
                    guid_hu = <ls_header>-guid_hu
                    huident = <ls_header>-huident
                    nlpla = plgp
                    procty = pprocty
                    squit = p_quit
     ) ).
  ENDLOOP.

  "Creating a warehouse task
  CALL FUNCTION '/SCWM/TO_CREATE_MOVE_HU'
    EXPORTING
      iv_lgnum       = plgnum
      iv_update_task = abap_false
      iv_commit_work = abap_true
      it_create_hu   = lt_hu_create
    IMPORTING
      ev_tanum       = lv_tanum
      ev_severity    = lv_severity
      et_bapiret     = lt_bapiret.

  IF  lv_severity CA wmegc_severity_eax(3).
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
