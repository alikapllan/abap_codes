*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXP_3_INHERITANCE
*&---------------------------------------------------------------------*
*& Inheritance
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_3_inheritance.

CLASS lcl_animal DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_number_of_legs RETURNING VALUE(rv_legs) TYPE i,
      get_number_of_arms RETURNING VALUE(rv_arms) TYPE i.

    DATA: mv_legs TYPE i,
          mv_arms TYPE i.
ENDCLASS.

CLASS lcl_animal IMPLEMENTATION.
  METHOD get_number_of_legs.
    rv_legs = mv_legs.
  ENDMETHOD.

  METHOD get_number_of_arms.
    rv_arms = mv_arms.
  ENDMETHOD.
ENDCLASS.

*&-----Inherited-----&*
CLASS lcl_cat DEFINITION INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS:
      constructor.
ENDCLASS.

CLASS lcl_cat IMPLEMENTATION.
  METHOD constructor.
    "if variables from parent class want to be used, parents constructor should be called via SUPER
    super->constructor(  ).
    me->mv_legs = 4.
    me->mv_arms = 0.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA(lo_cat) = NEW lcl_cat( ).

  WRITE:/ 'Legs of Cat: ', lo_cat->get_number_of_legs(  ),
          'Arms of Cat: '. lo_cat->get_number_of_arms(  ).
