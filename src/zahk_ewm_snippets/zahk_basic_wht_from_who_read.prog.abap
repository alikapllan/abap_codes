*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_WHT_FROM_WHO_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& This report demonstrates how to read the warehouse tasks from a warehouse order.
*&
*& To read the warehouse tasks, we use the function module '/SCWM/TO_READ_WHO'.

REPORT zahk_basic_wht_from_who_read.

DATA: open_whts      TYPE /scwm/tt_ordim_o,
      confirmed_whts TYPE /scwm/tt_ordim_c.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS: pwho   TYPE /scwm/de_who DEFAULT '602063',
            plgnum TYPE /scwm/lgnum.

SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  input = 'Demo Input Data'.
  info = 'Auslesen der Lageraufgaben eines Lagerauftrages'.

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( iv_lgnum = plgnum ).

  CALL FUNCTION '/SCWM/TO_READ_WHO'
    EXPORTING
      iv_lgnum   = plgnum
      iv_who     = pwho
    IMPORTING
      et_ordim_o = open_whts
      et_ordim_c = confirmed_whts
    EXCEPTIONS
      OTHERS     = 99.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  cl_demo_output=>new( )->begin_section('Open Warehouse tasks'
    )->write_data( open_whts
  )->next_section('Confirmed Warehouse tasks'
    )->write_data( confirmed_whts
    )->display( ).
