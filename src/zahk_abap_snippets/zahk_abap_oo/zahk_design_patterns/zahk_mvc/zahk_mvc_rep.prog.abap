*&---------------------------------------------------------------------*
*& Report ZAHK_MVC_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_mvc_rep.

PARAMETERS: scarrid TYPE s_carr_id.

DATA(o_control) = NEW zcl_ahk_sflight_control( ).

START-OF-SELECTION.

  o_control->o_model->get_flight_data( carrid = scarrid ).
  DATA(table_to_display) = o_control->o_model->flight_t.

  o_control->o_view->display_flight_data( table_to_display = table_to_display ).
