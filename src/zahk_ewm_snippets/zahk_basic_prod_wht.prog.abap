*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_PROD_WHT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*& This report demonstrates the very basic of creating a product warehouse task.
*& To create a product warehouse task a few things will be needed. First we need the source
*& bin and the destination bin as well as the material id and the bin type. Furthermore the information
*& about the product warehouse task which should be created must be passed to the function module '/SCWM/TO_CREATE'.
*& In this report we use the class /scwm/cl_mon_stock to get the missing information like altme, entitled, owner etc.


REPORT zahk_basic_prod_wht.

DATA: whts_to_create TYPE /scwm/tt_to_create_int,
      tanum          TYPE /scwm/tanum,
      severity       TYPE bapi_mtype,
      return_info    TYPE bapirettab,
      stock_monitor  TYPE REF TO /scwm/cl_mon_stock,
      stocks_of_bin  TYPE /scwm/tt_stock_mon.
CONSTANTS: procity TYPE /scwm/de_procty VALUE 9999.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.
PARAMETERS: plgp    TYPE /scwm/lgpla DEFAULT '0020-01-02-D',
            pdest   TYPE /scwm/de_lgpla DEFAULT '0020-01-01-D',
            plgnum  TYPE /scwm/lgnum,
            plgtyp  TYPE /scwm/lgtyp DEFAULT '0020',
            pmat    TYPE /scwm/de_matnr DEFAULT 'EDDING_SCHWARZ',
            pamount TYPE i DEFAULT 1,
            pquit   AS CHECKBOX DEFAULT abap_true.
"defined if warehousetask should be open or confirmed
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.

  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  input  = 'Demo Input Data'.
  info   = 'Dieser Report erstellt eine einfache Produktlageraufgabe.'.
  DATA(ui_stock_helper) = NEW /scwm/cl_ui_stock_fields( ). "billion ways to convert matids ... choose your preferred one

START-OF-SELECTION.

  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).

  stock_monitor = NEW #( iv_lgnum = plgnum ).
  DATA(storage_types) = VALUE /scwm/tt_lgtyp_r( ( sign = wmegc_sign_inclusive
                                                  option = wmegc_option_eq
                                                  low =  plgtyp ) ).
  DATA(bins)          = VALUE /scwm/tt_lgpla_r( ( sign = wmegc_sign_inclusive
                                                  option = wmegc_option_eq
                                                  low = plgp ) ).
  DATA(mat_numbers)   = VALUE /scwm/tt_matnr_r( ( sign = wmegc_sign_inclusive
                                                  option = wmegc_option_eq
                                                  low = pmat ) ).
  "Firstly we should read the stock of the source bin to get more information.
  stock_monitor->get_physical_stock( EXPORTING
                                        it_lgpla_r = bins
                                        it_lgtyp_r = storage_types
                                        iv_skip_resource = abap_true
                                        it_matnr_r = mat_numbers
                                     IMPORTING
                                        et_stock_mon = stocks_of_bin ).
  DATA(stock) = stocks_of_bin[ 1 ].
  DATA(wht_to_create) = VALUE /scwm/s_to_create_int( BASE CORRESPONDING #( stock )
                                                        procty = procity
                                                        nlpla  = pdest
                                                        vlpla  = plgp
                                                        anfme  = pamount
                                                        matid  = ui_stock_helper->get_matid_by_no( iv_matnr = pmat )
                                                        squit  = pquit ).
  "all important values must be passed to the whts_to_create which provides the infos
  "to create product warehouse task with the func. module beneath
  APPEND wht_to_create TO whts_to_create.

  "This function module creates a product warehouse task.
  CALL FUNCTION '/SCWM/TO_CREATE'
    EXPORTING
      iv_lgnum       = plgnum
      iv_commit_work = abap_true
      iv_bname       = sy-uname
      it_create      = whts_to_create
    IMPORTING
      ev_tanum       = tanum
      et_bapiret     = return_info
      ev_severity    = severity.
  IF severity CA wmegc_severity_eax(3).
    WRITE: 'Produktlageraufgabe konnte nicht erstellt werden.'.
  ENDIF.

  /scwm/cl_tm=>cleanup( iv_lgnum = plgnum ).
