*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp.

CLASS lcl_main DEFINITION DEFERRED.
DATA: go_main         TYPE REF TO lcl_main,
      gv_sum          TYPE int4,
      gv_changing_num TYPE int4.

PARAMETERS: p_num1 TYPE int4,
            p_num2 TYPE int4.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS: sum_numbers,
      sum_numbers_v2 IMPORTING iv_num1 TYPE int4
                               iv_num2 TYPE int4
                     EXPORTING ev_sum  TYPE int4,
      sub_numbers    IMPORTING iv_num1 TYPE int4
                     CHANGING  cv_num2 TYPE int4,
      sum_numbers_v3 IMPORTING iv_num1       TYPE int4
                               iv_num2       TYPE int4
                     RETURNING VALUE(rv_sum) TYPE int4.

    DATA: mv_sum TYPE int4.
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD sum_numbers.
    mv_sum = p_num1 + p_num2.
  ENDMETHOD.

  METHOD sum_numbers_v2.
    ev_sum = iv_num1 + iv_num2.
  ENDMETHOD.

  METHOD sub_numbers.
    cv_num2 = iv_num1 - cv_num2.
  ENDMETHOD.

  METHOD sum_numbers_v3.
    rv_sum = iv_num1 + iv_num2.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  go_main = NEW #( ).
*  go_main->sum_numbers( ).
*  WRITE: go_main->mv_sum.

  go_main->sum_numbers_v2( EXPORTING
                               iv_num1 = p_num1
                               iv_num2 = p_num2
                           IMPORTING
                               ev_sum = gv_sum ).
  WRITE:/ 'Sum: ' , gv_sum.

  gv_changing_num = p_num2.
  go_main->sub_numbers(
    EXPORTING
      iv_num1 = p_num1
    CHANGING
      cv_num2 = gv_changing_num ).

  WRITE:/ 'Sub: ' , gv_changing_num.

  DATA(lv_recv_sum) = go_main->sum_numbers_v3( iv_num1 = p_num1
                                               iv_num2 = p_num2 ).
  WRITE:/ 'Returning Value: ', lv_recv_sum.
