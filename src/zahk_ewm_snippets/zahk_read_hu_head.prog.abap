*&---------------------------------------------------------------------*
*& Report ZAHK_READ_HU_HEAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_read_hu_head.

DATA: lo_alv      TYPE REF TO cl_salv_table,
      lt_huheader TYPE /scwm/tt_huhdr_int,
      lt_hu_show  TYPE zahk_tt_hu_header.

PARAMETERS: phu    TYPE /scwm/huident,
            plgnum TYPE /scwm/lgnum.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  "default back to EW1 system dummy lgnum

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).

  CALL FUNCTION '/SCWM/HUHEADER_READ'
    EXPORTING
      iv_appl     = wmegc_huappl_wme
      iv_huident  = phu
      iv_nobuff   = abap_false
    IMPORTING
      et_huheader = lt_huheader
    EXCEPTIONS
      OTHERS      = 99.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_huheader ASSIGNING FIELD-SYMBOL(<ls_hu_head>).
    lt_hu_show = VALUE #(
      ( huident    = <ls_hu_head>-huident
        created_by = <ls_hu_head>-created_by
        lgpla      = <ls_hu_head>-lgpla
        matid      = <ls_hu_head>-pmat_guid )
    ).
  ENDLOOP.


  " Show HU ident., creator, product and storage place
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_hu_show
      ).
      lo_alv->display( ).
    CATCH cx_root.

  ENDTRY.
