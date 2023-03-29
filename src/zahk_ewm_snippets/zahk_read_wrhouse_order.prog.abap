*&---------------------------------------------------------------------*
*& Report ZAHK_READ_WRHOUSE_ORDER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& This report shows how to read a specific warehouse order.
*&
*& In this example the warehouse order will be read with the function modules
*& '/SCWM/WHO_SELECT' and '/SCWM/WHO_GET'. Hint: Reading the who with function
*& module '/SCWM/WHO_SELECT' is more efficient.
REPORT zahk_read_wrhouse_order.

DATA: who TYPE /scwm/s_who_int.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.
PARAMETERS: plgnum TYPE /scwm/lgnum,
            pwho   TYPE /scwm/de_who DEFAULT '602063',
            popt1  RADIOBUTTON GROUP sel,
            popt2  RADIOBUTTON GROUP sel.
SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.

  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ). "
  input = 'Demo Input Data'.
  info = 'This report shows how to read a specific warehouse order'.

START-OF-SELECTION.
  CASE abap_true.

    WHEN popt1.
      CALL FUNCTION '/SCWM/WHO_SELECT'
        EXPORTING
          iv_lgnum = plgnum
          iv_who   = pwho
        IMPORTING
          es_who   = who.

    WHEN popt2.
      CALL FUNCTION '/SCWM/WHO_GET'
        EXPORTING
          iv_lgnum = plgnum
          iv_whoid = pwho
        IMPORTING
          es_who   = who.
  ENDCASE.

  IF who IS INITIAL.
    RETURN.
  ENDIF.

  cl_demo_output=>display( data = who ).
