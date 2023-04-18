*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXP_4_ENCAPSULATION
*&---------------------------------------------------------------------*
*& Encapsulation
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_4_encapsulation.

CLASS lcl_animal DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_number_of_legs RETURNING VALUE(rv_legs) TYPE i.
    DATA: mv_legs TYPE i.

  PROTECTED SECTION.
    METHODS:
      get_number_of_arms RETURNING VALUE(rv_arms) TYPE i.

  PRIVATE SECTION.
    DATA: mv_arms TYPE i.
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

    "as mv_arms is defined as PRIVATE, can only be used in its class
*    me->mv_arms = 0.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA(lo_animal) = NEW lcl_animal( ).
  DATA(lo_cat)    = NEW lcl_cat( ).

  WRITE:/ lo_animal->get_number_of_legs(  ).

*  Cannot be used, because protected methods, or variables can only be used in subclasses
*  no access outside of the class or subclass(es)
*  WRITE:/ lo_animal->get_number_of_arms(  ).
  WRITE:/ lo_animal->mv_legs.

*  Cannot be used, because PRIVATE methods, or variables can be used only within the class where defined
*  no access outside of the class itself
*  WRITE:/ lo_animal->mv_arms.

  WRITE:/ lo_cat->get_number_of_legs(  ).

*  Cannot be used, because PROTECTED methods, or variables can only be used in subclasses
*  no access outside of the class or subclass(es)
*  WRITE:/ lo_cat->get_number_of_arms(  ).
  WRITE:/ lo_cat->mv_legs.

*  Cannot be used, because PRIVATE methods, or variables can be used only within the class where defined
*  no access outside of the class itself
*  WRITE:/ lo_cat->mv_arms.
