FUNCTION zahk_webservice_city.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IV_CITY_ID) TYPE  NUMC2
*"     VALUE(IV_CITY_NAME) TYPE  CHAR30
*"  EXPORTING
*"     VALUE(EV_SUCCESS) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------

  DATA: ls_city TYPE zahk_city_list.

  ls_city-city_id   = iv_city_id.
  ls_city-city_name = iv_city_name.
  ls_city-uname     = sy-uname.
  ls_city-datum     = sy-datum.
  ls_city-uzeit     = sy-uzeit.

  SELECT COUNT(*)
    FROM zahk_city_list
    WHERE city_id = iv_city_id.

  IF sy-subrc = 0.
    ev_success = abap_false.
    ev_message = 'City exists already.'.
  ELSE.

    INSERT zahk_city_list FROM ls_city.

    IF sy-subrc = 0.
      COMMIT WORK.
      ev_success = abap_true.
      ev_message = 'Data has been successfully saved.'.
    ELSE.
      ROLLBACK WORK.
      ev_success = abap_false.
      ev_message = 'Inserting data was not successfull.'.
    ENDIF.

  ENDIF.

ENDFUNCTION.
