class ZCL_AHK_SFLIGHT_MODEL definition
  public
  final
  create public .

public section.

  data:
    flight_t TYPE STANDARD TABLE OF sflight .

  methods GET_FLIGHT_DATA
    importing
      !CARRID type S_CARR_ID .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AHK_SFLIGHT_MODEL IMPLEMENTATION.


  METHOD GET_FLIGHT_DATA.

    SELECT * FROM sflight
      WHERE carrid = @carrid
      INTO TABLE @flight_t.

    IF sy-subrc <> 0.
      MESSAGE |No data found| TYPE 'E'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
