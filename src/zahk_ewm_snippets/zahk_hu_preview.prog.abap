*&---------------------------------------------------------------------*
*& Report ZAHK_HU_PREVIEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_hu_preview.

DATA: lt_huheader TYPE /scwm/tt_huhdr_int,
      lt_guid_hu  TYPE /scwm/tt_guid_hu,
      ls_guid_hu  TYPE /scwm/s_guid_hu.

PARAMETERS:
  phu    TYPE /scwm/huident,
  plgnum TYPE /scwm/lgnum DEFAULT 'WU02'.

FIELD-SYMBOLS: <ls_header>    TYPE /scwm/s_huhdr_int.

INITIALIZATION.
  GET PARAMETER ID 'SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  "default back to EW1 system dumy lgnum

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
      OTHERS      = 1.
  IF sy-subrc <> 0.
    MESSAGE 'Handling Unit Kopf konnte nicht gelesen werden!' TYPE 'E'.
  ENDIF.

  LOOP AT lt_huheader ASSIGNING <ls_header>.
    ls_guid_hu-guid_hu = <ls_header>-guid_hu.
    APPEND ls_guid_hu TO lt_guid_hu.
  ENDLOOP.

  CALL FUNCTION '/SCWM/HU_DISPLAY'
    EXPORTING
      iv_lgnum   = plgnum
      it_guid_hu = lt_guid_hu
    EXCEPTIONS
      OTHERS     = 99.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
