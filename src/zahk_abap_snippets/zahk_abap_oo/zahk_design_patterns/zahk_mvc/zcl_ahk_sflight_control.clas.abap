CLASS zcl_ahk_sflight_control DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA o_model TYPE REF TO zcl_ahk_sflight_model.
    DATA o_view TYPE REF TO zcl_ahk_sflight_view.

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AHK_SFLIGHT_CONTROL IMPLEMENTATION.


  METHOD constructor.
    TRY.
        o_model = NEW #( ).
        o_view  = NEW #( ).

      CATCH cx_sy_create_object_error INTO DATA(obj_error).

        MESSAGE |{ obj_error->get_text( ) }| TYPE 'E'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
