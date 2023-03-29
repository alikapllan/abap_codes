*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_PACKSPEC_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& This report demonstrates the process of simply reading different things from a packspec by providing a material.
*&
*& In this example we search the packspec for a given material. After finding a packspec-key with the function group
*& '/SCWM/API_PACKSPEC_GETLIST' the function module '/SCWM/API_PACKSPEC_READ' is used to get information
*& about the specific packspec.

REPORT zahk_basic_packspec_read.

DATA: severity    TYPE bapi_mtype,
      packspecs   TYPE /scwm/tt_ps_object,
      return_info TYPE bapirettab,
      header_keys TYPE /scwm/tt_ps_header_key.
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS: pmat     TYPE /scwm/de_matnr DEFAULT 'SCHRAUBE_7',
            phead    RADIOBUTTON GROUP sel,
            pcontent RADIOBUTTON GROUP sel.

SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  input = 'Demo Input Data'.
  info = 'Report liest die Kopf/Inhalt einer Packspezifikation'.
  "reading the packspec-key of a given material from the database.

START-OF-SELECTION.
  CALL FUNCTION '/SCWM/API_PACKSPEC_GETLIST'
    EXPORTING
      is_content_query = VALUE /scwm/s_ps_content_query( matnr_rng = VALUE #( ( sign   = wmegc_sign_inclusive
                                                                                option = wmegc_option_eq
                                                                                low    = pmat ) ) )
      it_status_rng    = VALUE rseloption( ( sign   = wmegc_sign_inclusive
                                             option = wmegc_option_eq
                                             low    = /scwm/cl_ppelipak_cntl_const=>gc_status_active ) )
    IMPORTING
      et_ps_keys       = header_keys
      ev_severity      = severity
      et_return        = return_info.

  IF severity CA wmegc_severity_eax.
    WRITE: 'Was not able to find an active packspec for the given material.'.
    WRITE: 'Gefunden werden konnte keine aktive Packspezifikation für angegebenes Material!'.
  ENDIF.
  "reading the packspec from database by providing the packspec-keys.
  CALL FUNCTION '/SCWM/API_PACKSPEC_READ'
    EXPORTING
      it_ps_id    = header_keys
    IMPORTING
      et_object   = packspecs
      ev_severity = severity
      et_return   = return_info.

  IF severity CA wmegc_severity_eax.
    WRITE: 'Gefunden werden konnte irgendeine INfo über angegebene Packspec!'.
  ENDIF.

  IF packspecs IS INITIAL.
    RETURN.
  ENDIF.

  CASE abap_true.
    WHEN phead.
      cl_demo_output=>display( data = packspecs[ 1 ]-header ).
    WHEN pcontent.
      cl_demo_output=>display( data = packspecs[ 1 ]-contents ).
  ENDCASE.
