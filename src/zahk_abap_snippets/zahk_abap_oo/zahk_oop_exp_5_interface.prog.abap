*&---------------------------------------------------------------------*
*& Report ZAHK_OOP_EXP_5_INTERFACE
*&---------------------------------------------------------------------*
*& Interface
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_5_interface.

INTERFACE lif_animal.
  METHODS:
    get_number_of_legs RETURNING VALUE(rv_legs) TYPE i,
    get_number_of_arms RETURNING VALUE(rv_arms) TYPE i.

  DATA: mv_legs TYPE i,
        mv_arms TYPE i.
ENDINTERFACE.

CLASS lcl_cat DEFINITION.
  PUBLIC SECTION.
    "Introducing the interface to the class
    "every method defined in interface MUST be used in the class
    "usage of variables defined in interface is up to the developer, not a must
    INTERFACES: lif_animal.

    METHODS:
      constructor.
ENDCLASS.

CLASS lcl_cat IMPLEMENTATION.
  METHOD constructor.
    "usage of variables defined in interface is up to the developer, not a must
    lif_animal~mv_legs = 4.
    lif_animal~mv_arms = 0.
  ENDMETHOD.

  METHOD lif_animal~get_number_of_legs.
    rv_legs = lif_animal~mv_legs.
  ENDMETHOD.

  METHOD lif_animal~get_number_of_arms.
    rv_arms = lif_animal~mv_arms.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA(lo_cat) = NEW lcl_cat( ).

  WRITE:/ 'Legs of Cat: ', lo_cat->lif_animal~get_number_of_legs(  ).
  WRITE:/ 'Arms of Cat: ', lo_cat->lif_animal~get_number_of_arms(  ).
