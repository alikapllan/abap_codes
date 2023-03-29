*&---------------------------------------------------------------------*
*& Report ZAHK_DELETE_HU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_delete_hu.

*Lege mit dem Programm aus Aufgabenstellung Eins eine weitere Handling Unit an.
*Diese soll nun gelöscht werden.
*Das Löschen einer HU kann mithilfe der Packing Klasse realisiert werden.

DATA: lo_packing  TYPE REF TO /scwm/cl_wm_packing,
      ls_hu       TYPE /scwm/s_huhdr_int,
      ls_huheader TYPE /scwm/s_huhdr_int.

PARAMETERS:
  plgnum TYPE /scwm/lgnum,
  phu    TYPE /scwm/huident.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  "default back to EW1 system dummy lgnum

START-OF-SELECTION.

  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).

  CALL FUNCTION '/SCWM/HUHEADER_READ'
    EXPORTING
      iv_appl     = wmegc_huappl_wme " Handling Unit Applikation
*     iv_guid_hu  =                  " eindeutige interne Identifikation einer Handling Unit
      iv_huident  = phu                " Handling Unit Identifikation
*     iv_ident    =                  " alternative Handling Unit Identifikation
*     iv_db_select = 'X'             " ggf. von Datenbank selektieren
      iv_nobuff   = abap_false            " nicht aus Puffer lesen (kein Append)
*     iv_lock     = space            " Exclusive Sperre
*     iv_wait     = space            " Sperrparemter
    IMPORTING
      es_huheader = ls_huheader      " interne Struktur zur Bearbeitung des HU-Kopfes
*     et_huref    =                  " Tabelle mit HU-Referenzen
*     et_huident  =                  " Tabelle mit HU Identifikationen
*     et_huheader =                  " Tabellentype für HU-Köpfe in interner Struktur
    EXCEPTIONS
*     not_found   = 1                " HU ist nicht vorhanden
*     input       = 2                " Fehler in den Inputdaten
*     error       = 3                " allgemeiner Fehler
*     deleted     = 4                " HU wurde gelöscht
      OTHERS      = 99.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.

  /scwm/cl_wm_packing=>get_instance(
    IMPORTING
      eo_instance = lo_packing
  ).

  lo_packing->init(
    EXPORTING
      iv_lgnum = plgnum
    EXCEPTIONS
      OTHERS = 99
  ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION '/SCWM/TO_INIT_NEW'
    EXPORTING
      iv_lgnum = plgnum.
  lo_packing->delete_hu(
    EXPORTING
      iv_hu  = ls_huheader-guid_hu  " Unique Internal Identification of a Handling Unit
    EXCEPTIONS
*     error  = 1                   " error
     OTHERS = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  lo_packing->/scwm/if_pack_bas~save(
    EXPORTING
      iv_commit = abap_true
      iv_wait   = abap_true
    EXCEPTIONS
      OTHERS    = 2
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
