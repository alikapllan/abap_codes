*&---------------------------------------------------------------------*
*& Report zahk_oop_exp_7_polymorphism
*&---------------------------------------------------------------------*
*& Polymorphism
*&---------------------------------------------------------------------*
REPORT zahk_oop_exp_7_polymorphism.

CLASS lcl_animal DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      get_type ABSTRACT,
      speak    ABSTRACT.
ENDCLASS.

"No Implementation is needed, as ABSTRACT Methods cannot have any logic in this class itself
"rather has to be defined in the class, which inherits this class

"----------------------------------------------------"
"Inherits the ABSTRACT Class
CLASS lcl_dog DEFINITION INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS: get_type REDEFINITION,
      speak    REDEFINITION.

ENDCLASS.

CLASS lcl_dog IMPLEMENTATION.
  METHOD get_type.
    WRITE: 'DOG'.
  ENDMETHOD.

  METHOD speak.
    WRITE: 'Bark'.
  ENDMETHOD.
ENDCLASS.
"----------------------------------------------------"
"Inherits the ABSTRACT Class
CLASS lcl_cat DEFINITION INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS: get_type REDEFINITION,
      speak    REDEFINITION.

ENDCLASS.

CLASS lcl_cat IMPLEMENTATION.
  METHOD get_type.
    WRITE: 'CAT'.
  ENDMETHOD.

  METHOD speak.
    WRITE: 'Meow'.
  ENDMETHOD.
ENDCLASS.
"----------------------------------------------------"
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS:                   "Referring to the ABSTRACT Class
      play IMPORTING io_animal TYPE REF TO lcl_animal.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  "method parameter is all same type but being fed by subclasses
  "its possible, because parent class is ABSTRACT and methods inside as well and-
  "all abstract methods have to be defined in classes, which inherits the ABSTRACT class
  METHOD play.
    WRITE: 'The'.
    io_animal->get_type(  ).
    WRITE: 'says'.
    io_animal->speak( ).
    NEW-LINE.
  ENDMETHOD.
ENDCLASS.
"----------------------------------------------------"

START-OF-SELECTION.

  DATA(lo_dog)  = NEW lcl_dog( ).
  DATA(lo_cat)  = NEW lcl_cat( ).
  DATA(lo_main) = NEW lcl_main( ).

  lo_main->play( io_animal = lo_dog ).
  lo_main->play( io_animal = lo_cat ).
