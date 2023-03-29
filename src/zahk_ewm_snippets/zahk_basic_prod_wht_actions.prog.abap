*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_PROD_WHT_ACTIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*& This report demonstrates the very basic of confirming or canceling an open warehouse task.
*&
*& To confirm an open warehouse task the function module '/SCWM/TO_CONFIRM' is used. For canceling
*& an product wht we use the function group '/SCWM/TO_CANCEL'.

REPORT zahk_basic_prod_wht_actions.

DATA: return_information TYPE bapirettab.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS: ptanum   TYPE /scwm/tanum,
            plgnum   TYPE /scwm/lgnum,
            pconfirm RADIOBUTTON GROUP slct, "confirm prouct wht
            pcancel  RADIOBUTTON GROUP slct.    "cancel product wht

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  input = 'Demo Input Data'.
  info = 'Zeigt sich, wie eine offene Produktlageraufgabe zu quittieren/stornieren ist.'.

  DATA(ui_stock_helper) = NEW /scwm/cl_ui_stock_fields( ).
  "billion ways to convert matids ... choose your preferred one

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).
  CASE abap_true.
    WHEN pconfirm.
      DATA(whts_to_confirm) = VALUE /scwm/to_conf_tt( ( tanum = ptanum
                                                        squit = abap_true ) ).

      "This function module confirmes the given warehouse task.
      CALL FUNCTION '/SCWM/TO_CONFIRM'
        EXPORTING
          iv_lgnum       = plgnum
          iv_qname       = sy-uname
          iv_update_task = abap_true
          iv_commit_work = abap_true
          it_conf        = whts_to_confirm
        IMPORTING
          et_bapiret     = return_information.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN pcancel. " Cancel the wht
      DATA(whts_to_cancel) = VALUE /scwm/tt_cancl( ( tanum = ptanum ) ).
      CALL FUNCTION '/SCWM/TO_CANCEL'
        EXPORTING
          iv_lgnum       = plgnum
          iv_update_task = abap_true
          iv_commit_work = abap_true
          it_cancl       = whts_to_cancel
        IMPORTING
          et_bapiret     = return_information.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
  ENDCASE.
