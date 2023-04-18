*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXP_2_STATIC_INSTANCE
*&---------------------------------------------------------------------*
*& Static & Instance
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_2_static_instance.

CLASS lcl_main DEFINITION DEFERRED.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    "static methods
    CLASS-METHODS:
      class_constructor.
    METHODS:
      constructor,
      do_process IMPORTING iv_pers_id   TYPE char10
                           iv_pers_name TYPE char20
                           iv_pers_age  TYPE numc2.
    "instance variables
    DATA: mv_pers_id   TYPE char10,
          mv_pers_name TYPE char20.

    "static variables
    CLASS-DATA: mv_pers_age TYPE numc2,
                mv_ttl_num  TYPE i VALUE 0.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD class_constructor.
    "when an object is created, static constructor gets called first and only once
    mv_ttl_num = mv_ttl_num + 1.
    WRITE:/ 'class constructor has been called ', mv_ttl_num.
    "when creating other objects, normal(instance) constructor gets called first
  ENDMETHOD.

  METHOD constructor.
    "when an object is created, static constructor gets called second
    mv_ttl_num = mv_ttl_num + 1.
    WRITE:/ 'constructor has been called ', mv_ttl_num.
  ENDMETHOD.

  METHOD do_process.
    mv_pers_id   = iv_pers_id   .
    mv_pers_name = iv_pers_name .
    mv_pers_age  = iv_pers_age  .
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(go_main1) = NEW lcl_main( ).
  go_main1->do_process( iv_pers_id   = '1000000001'
                        iv_pers_name = 'Ali'
                        iv_pers_age  = '23' ).


  DATA(go_main2) = NEW lcl_main( ).
  go_main2->do_process( iv_pers_id   = '1000000002'
                        iv_pers_name = 'Burak'
                        iv_pers_age  = '23' ).

  DATA(go_main3) = NEW lcl_main( ).
  go_main3->do_process( iv_pers_id   = '1000000003'
                        iv_pers_name = 'Selin'
                        iv_pers_age  = '23' ).

  WRITE:/ go_main1->mv_pers_name, go_main2->mv_pers_name, go_main3->mv_pers_name.
