*&---------------------------------------------------------------------*
*& Report ZAHK_SHOW_HU_ON_BIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*& This report demonstrates the process of reading all HU's placed on a storage place.
*&
*& This report uses the /scwm/cl_mon_stock class to get all HU's placed on a specific storage place .
*&
*& Disclaimer: This is a demo report and therefore does not necessarily
*& display the proper & perfect use of Exception-, Database- and Transaction-Handling.
*& It merely rudimentary implements the, for the process in question, required handling.
*& Please make sure to adjust and implement them to _your_ needs.

REPORT zahk_show_hu_on_bin.

DATA: stock_monitor TYPE REF TO /scwm/cl_mon_stock,
      lt_hu_on_lagp TYPE /scwm/tt_huhdr_mon.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS:
  p_lgnum TYPE /scwm/lgnum,
  p_lgpla TYPE /scwm/lgpla DEFAULT '0020-01-02-C',
  p_lgtyp TYPE /scwm/lgtyp DEFAULT '0020'.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD p_lgnum.
  p_lgnum = COND #( WHEN p_lgnum IS INITIAL THEN 'WU02' ELSE p_lgnum ).
  input = 'Demo Input Data'.
  info  = 'Dieser Report zeigt alle Hus in einem bestimmten Lagerplatz.'.

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( iv_lgnum = p_lgnum ).
  "set warehouse number where storage place is located
  stock_monitor = NEW #( iv_lgnum = p_lgnum ).

  DATA(bin_types) = VALUE /scwm/tt_lgtyp_r( (
                                         sign   = wmegc_sign_inclusive
                                         option = wmegc_option_eq
                                         low    = p_lgtyp
  ) ).
  DATA(bins) = VALUE /scwm/tt_lgpla_r( (
                 sign   = wmegc_sign_exclusive
                 option = wmegc_option_eq
                 low    = p_lgpla
   ) ).
  TRY.
      "read all HUs on bin
      " Before using this (or other methods of the /scwm/cl_mon_stock class) check if the methods are sufficient
      " for your specific purposes.
      "The performance of these methods relies strongly on selection conditions beeing used by the caller. That means, the
      " better you restrict the number of hits on a selection, the faster a method provides the result.
      "To increase the performance, it could be helpful to create new indices
      " for the selections. Avoid developing your own selections on the database tables.

      stock_monitor->get_hu( EXPORTING
                               it_lgpla_r = bins
                               it_lgtyp_r = bin_types
                             IMPORTING
                               et_hu_mon  = lt_hu_on_lagp ).
      cl_demo_output=>display( data = lt_hu_on_lagp ).
    CATCH /scwm/cx_md.
      MESSAGE 'Materalien konnten nicht gelesen werden' TYPE 'E'.
  ENDTRY.
