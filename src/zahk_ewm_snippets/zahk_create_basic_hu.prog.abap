*&---------------------------------------------------------------------*
*& Report ZAHK_CREATE_BASIC_HU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_create_basic_hu.

DATA: new_huh_dr TYPE /scwm/s_huhdr_int.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(78) info.

PARAMETERS: plgnum TYPE /scwm/lgnum,
            plocat TYPE /scwm/lgpla DEFAULT 'GR-ZONE',
            ppmat  TYPE /sapapo/matnr DEFAULT 'ZRFR_PACK'.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  GET PARAMETER ID 'SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ).
  input  = 'Demo Input Data'.
  info   = 'This demonstrates how to create basic Handling Unit'.

START-OF-SELECTION.
  "Set-Up everything & Initialize the required classes.
  "/SCWM/CL_TM is the general transaction manager for clean and proper transaction handling in EWM
  /scwm/cl_tm=>set_lgnum( iv_lgnum = plgnum ).
  /scwm/cl_wm_packing=>get_instance( IMPORTING eo_instance = DATA(packing_api) ).
  DATA(ui_stock_helper) = NEW /scwm/cl_ui_stock_fields( ).

  "Do the internal init to set everything up.
  packing_api->create_hu(
    EXPORTING
      iv_pmat      = ui_stock_helper->get_matid_by_no( iv_matnr = ppmat )" Material GUID16 with Conversion Exit
*      iv_huident   =                  " Handling Unit Identification
*      is_hu_create =
*      iv_nohuident =                  " Single-Character Indicator
      i_location   = plocat
*      iv_loghu     =                  " Handling Unit Identification
    RECEIVING
      es_huhdr     = new_huh_dr        " Internal Structure for Processing the HU Header
    EXCEPTIONS
      OTHERS       = 99 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  "Finally we actually create it (persist it to the DB).
  "You could decide to manually take care of the COMMIT & ROLLBACK (DB handling)
  packing_api->save( EXCEPTIONS OTHERS = 1 ).
  IF sy-subrc <> 0.
    ROLLBACK WORK.
    /scwm/cl_tm=>cleanup( ).
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
