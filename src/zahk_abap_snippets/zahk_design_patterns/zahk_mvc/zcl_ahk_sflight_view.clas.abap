class ZCL_AHK_SFLIGHT_VIEW definition
  public
  final
  create public .

public section.

  methods DISPLAY_FLIGHT_DATA
    importing
      !TABLE_TO_DISPLAY type FLIGHTTAB .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AHK_SFLIGHT_VIEW IMPLEMENTATION.


  METHOD DISPLAY_FLIGHT_DATA.

    DATA: table_to_display_changing TYPE STANDARD TABLE OF sflight.

    INSERT LINES OF table_to_display INTO TABLE table_to_display_changing.

    TRY.
        cl_salv_table=>factory(
              IMPORTING
                r_salv_table   = DATA(o_alv)
              CHANGING
                t_table        = table_to_display_changing
            ).

        o_alv->display( ).
      CATCH cx_salv_msg INTO DATA(error_mes).
        MESSAGE |{ error_mes->get_text( ) }| TYPE 'E'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
