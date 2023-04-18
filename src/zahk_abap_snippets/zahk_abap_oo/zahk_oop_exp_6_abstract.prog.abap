*&---------------------------------------------------------------------*
*& Report zahk_oop_exp_6_abstract
*&---------------------------------------------------------------------*
*& Abstract
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_6_abstract.

"Abstraction
CLASS lcl_animal DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      "If a method is abstract, this method cannot have any logic in this class itself
      "rather has to be implemented in subclass(es) which inherits the parent class lcl_animal
      get_number_of_legs ABSTRACT RETURNING VALUE(rv_legs) TYPE i, "-> like INTERFACE
      get_number_of_arms RETURNING VALUE(rv_arms) TYPE i.          "->      INHERITANCE

    DATA: mv_legs TYPE i,
          mv_arms TYPE i.
ENDCLASS.

CLASS lcl_animal IMPLEMENTATION.
  "as get_number_of_legs is defined as ABSTRACT, it cannot be used in this class itself,
  "rather has to be used in classes, which inherits this class
*  METHOD get_number_of_legs.
*    rv_legs = me->mv_legs.
*  ENDMETHOD.

  METHOD get_number_of_arms.
    rv_arms = me->mv_arms.
  ENDMETHOD.
ENDCLASS.

*Inheriting
CLASS lcl_cat DEFINITION INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS:
      constructor,
      "Abstract Method has to be written as shown -> REDEFINITION
      get_number_of_legs REDEFINITION.
ENDCLASS.

CLASS lcl_cat IMPLEMENTATION.
  METHOD constructor.
    "if variables from parent class want to be used, parents constructor should be called via SUPER
    super->constructor(  ).
    mv_legs = 4.
    mv_arms = 0.
  ENDMETHOD.

  "Usage of Abstract Method
  METHOD get_number_of_legs.
    rv_legs = me->mv_legs.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA(lo_cat) = NEW lcl_cat( ).

  WRITE:/ 'Legs of Cat: ', lo_cat->get_number_of_legs(  ).
  WRITE:/ 'Arms of Cat: ', lo_cat->get_number_of_arms(  ).
