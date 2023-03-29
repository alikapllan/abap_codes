*&---------------------------------------------------------------------*
*& Report ZAHK_CREATE_HU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_create_hu.

DATA: ls_hu_new   TYPE /scwm/s_huhdr_int,
      ls_lagp     TYPE /scwm/lagp,
      ls_lagp_int TYPE /scwm/s_lagp_int,
      lt_quan     TYPE /lime/t_query_quan,
      lt_bapiret  TYPE bapiret2_t,
      lv_severity TYPE bapi_mtype,
      ls_quan     TYPE /scwm/s_quan,
      ls_quan_es  TYPE /scwm/s_quan,
      lt_guid     TYPE /scwm/tt_guid_hu,
      lt_hutree   TYPE /scwm/tt_hutree,
      lt_huhdr    TYPE /scwm/tt_huhdr_int,
      lt_huitm    TYPE /scwm/tt_huitm_int.

PARAMETERS:
  plgnum   TYPE /scwm/lgnum,
  pmatpack TYPE /scwm/de_matnr DEFAULT '80000061', "80000061 : europalette
  "Durch das Material (die Palette) findet das System
  "das passende Nummerkreisobjekt (Durch die Packmittelart/Customizing) .
  pdest    TYPE /scwm/lgpla DEFAULT '0020-01-02-D',
  pmat     TYPE /scwm/de_matnr DEFAULT 'EDDING_Schwarz'.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  "default back to EW1 system dummy lgnum

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).
  /scwm/cl_wm_packing=>get_instance( IMPORTING eo_instance = DATA(packing_api) ).

  packing_api->init(
    EXPORTING
     iv_lgnum = plgnum
    EXCEPTIONS
      OTHERS = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA(ui_stock_helper) = NEW /scwm/cl_ui_stock_fields( ).
  "one of the billion ways to convert matids

  packing_api->/scwm/if_pack_bas~create_hu(
    EXPORTING
      iv_pmat      = ui_stock_helper->get_matid_by_no( iv_matnr = pmatpack ) " Material GUID16 with Conversion Exit
      i_location   = pdest
    RECEIVING
      es_huhdr     = ls_hu_new " Internal Structure for Processing the HU Header
    EXCEPTIONS
      OTHERS       = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "saving hu
  packing_api->/scwm/if_pack_bas~save(
    EXPORTING
      iv_commit = abap_true
      iv_wait   = abap_true
    EXCEPTIONS
      OTHERS    = 99
  ).
  COMMIT WORK.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  "HU ist kreiert und jetzt ist sie zu erfüllen.
  "Lagerplatz und Lagerplatzstruktur auslesen
  CALL FUNCTION '/SCWM/LAGP_READ_SINGLE'
    EXPORTING
      iv_lgnum    = plgnum
      iv_lgpla    = pdest
      iv_enqueue  = abap_false
    IMPORTING
      es_lagp     = ls_lagp
      es_lagp_int = ls_lagp_int
    EXCEPTIONS
      OTHERS      = 99.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA(lv_mat) = ui_stock_helper->get_matid_by_no( iv_matnr = pmat ).

  CALL FUNCTION '/SCWM/STOCK_PER_BIN_READ'
    EXPORTING
      iv_lgnum    = plgnum " Lagernummer/Lagerkomplex
      iv_lgpla    = pdest  " Lagerplatz
      iv_matid    = lv_mat " Material GUID16  mit Konvertierungsexit
*     iv_owner    =        " Eigentümer
*     iv_entitled =        " Verfügungsberechtigter
    IMPORTING
      et_quan     = lt_quan    " Ergebnismengen
      et_bapiret  = lt_bapiret " Returntabelle
      ev_severity = lv_severity. " Meldungstyp: S Success, E Error, W Warning, I Info, A Abort

  IF lv_severity CA wmegc_severity_eax(3).
    "prüfen im Fall von Error
  ENDIF.

  "new hu is in ls_hu_new
  READ TABLE lt_quan INTO DATA(ls_quant) INDEX 1.
  ls_quan-quan = 1.
  ls_quan-unit = 'ST'.

  lt_guid = VALUE #( ( guid_hu = ls_quant-guid_parent )
                     ( guid_hu = ls_hu_new-guid_hu ) ).

  packing_api->init_pack(
    EXPORTING
      iv_badi_appl  = wmegc_huappl_wme " Handling Unit Application
      it_guid_hu    = lt_guid          " Table with HU GUIDs
*      iv_loc_type   =
*      iv_loc_index  =                 " Sequence Number of Key Table
*      iv_no_refresh =
      iv_lgnum      = plgnum
*      iv_lock       = space           " Single-Character Flag
    IMPORTING
      et_hutree     =  lt_hutree      " Table with HU Hierarchy Entries
      et_huhdr      =  lt_huhdr       " Table Type for HU Headers in the Internal Structure
      et_huitm      =  lt_huitm       " Material Items in the HU
    EXCEPTIONS
      OTHERS        = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  packing_api->/scwm/if_pack_bas~repack_stock(
    EXPORTING
      iv_dest_hu    = ls_hu_new-guid_hu    " Unique Internal Identification of a Handling Unit
      iv_source_hu  = ls_quant-guid_parent " Unique Internal Identification of a Handling Unit
      iv_stock_guid = ls_quant-guid_stock  " GUID Stock Item
      is_quantity   = ls_quan              " Quantity Structure
    IMPORTING
      es_quantity   = ls_quan_es           " Quantity Structure
    EXCEPTIONS
      OTHERS        = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  packing_api->/scwm/if_pack_bas~save(
    EXPORTING
      iv_commit = 'X'
      iv_wait   = 'X'
    EXCEPTIONS
      OTHERS    = 99
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  WRITE: / 'Due Hu wurde mit folgender IDnummer angelegt-> ', ls_hu_new-huident.
  /scwm/cl_tm=>cleanup( ).
