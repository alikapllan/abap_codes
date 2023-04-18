*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXP_1_CONSTRUCTOR
*&---------------------------------------------------------------------*
*&  CONSTRUCTOR
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_1_constructor.

CLASS lcl_main DEFINITION DEFERRED.
DATA: go_main TYPE REF TO lcl_main.

PARAMETERS: p_num1 TYPE int4,
            p_num2 TYPE int4.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS:
*      constructor,
      constructor IMPORTING iv_num1 TYPE int4
                            iv_num2 TYPE int4,
      sum_numbers.

    DATA: mv_num1 TYPE i,
          mv_num2 TYPE i,
          mv_sum  TYPE i.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD constructor.
*    mv_num1 = p_num1.
*    mv_num2 = p_num2.
    mv_num1 = iv_num1.
    mv_num2 = iv_num2.
  ENDMETHOD.

  METHOD sum_numbers.
    mv_sum = mv_num1 + mv_num2.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

*  go_main = NEW #( ).
  go_main = NEW #( iv_num1 = p_num1
                   iv_num2 = p_num2 ).

  go_main->sum_numbers( ).
  WRITE:/ 'Sum:' , go_main->mv_sum.
