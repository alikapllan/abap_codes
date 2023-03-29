*&---------------------------------------------------------------------*
*& Report ZAHK_READ_STOCK_ON_BIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& This report demonstrates how to read the stock of a specific storage place.
*&
*& To read the stock, this report uses the /scwm/cstock_monitor class.
*&
*& Disclaimer: This is a demo report and therefore does not necessarily
*& display the proper & perfect use of Exception-, Database- and Transaction-Handling.
*& It merely rudimentary implements the, for the process in question, required handling.
*& Please make sure to adjust and implement them to _your_ needs.

REPORT zahk_read_stock_on_bin.

DATA: stock_monitor TYPE REF TO /scwm/cl_mon_stock,
      stock_of_bin  TYPE /scwm/tt_stock_mon.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.


PARAMETERS: p_lgnum TYPE /scwm/lgnum,
            p_lgpla TYPE /scwm/lgpla DEFAULT '0020-01-02-C',
            p_lgtyp TYPE /scwm/lgtyp DEFAULT '0020'.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD p_lgnum.
  p_lgnum = COND #( WHEN p_lgnum IS INITIAL THEN 'WU02' ELSE p_lgnum ). "default back to EW1 system dummy lgnum
  input = 'Demo Input Data'.
  info = 'Dieser Report liest alle Stocks eines bestimmten Lagerplatzes.'.

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = p_lgnum ).

  "set warehouse number where storage place is located.
  stock_monitor = NEW #( iv_lgnum = p_lgnum ).
  DATA(bin_types) = VALUE /scwm/tt_lgtyp_r( (  sign   = wmegc_sign_inclusive
                                               option = wmegc_option_eq
                                               low    = p_lgtyp ) ).

  DATA(bins) = VALUE /scwm/tt_lgpla_r( (  sign   = wmegc_sign_inclusive
                                          option = wmegc_option_eq
                                          low    = p_lgpla ) ).

  stock_monitor->get_physical_stock( EXPORTING it_lgpla_r       = bins
                                             it_lgtyp_r       = bin_types
                                             iv_skip_resource = abap_true
                                             iv_skip_tu       = abap_true
                                   IMPORTING et_stock_mon     = stock_of_bin ).

  cl_demo_output=>display( data = stock_of_bin ).
