*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_HU_LB_WITH_PACK
*&---------------------------------------------------------------------*
*&
*& This report demonstrates the very basic hu creating process of a HU LB.
*&
*& There are several ways to create a handling unit warehouse task. This report
*& shows how to create a HU warehouse task by using the packing class.
*& Hint: This solution creates only confirmed HU-LB's.
*&
*& Disclaimer: This is a demo report and therefore does not necessarily
*& display the proper & perfect use of Exception-, Database- and Transaction-Handling.
*& It merely rudimentary implements the, for the process in question, required handling.
*& Please make sure to adjust and implement them to _your_ needs.

*&---------------------------------------------------------------------*
REPORT zahk_basic_hu_lb_with_pack.

PARAMETERS: phu    TYPE /scwm/huident,
            plgnum TYPE /scwm/lgnum DEFAULT 'WU02',
            plgp   TYPE /scwm/de_lgpla DEFAULT '0020-01-02-C'.

DATA: packing_api TYPE REF TO /scwm/cl_wm_packing,
      ls_hu       TYPE /scwm/s_huhdr_int,
      ls_huheader TYPE /scwm/s_huhdr_int.

INITIALIZATION.
  " This global parameter is usually set by SAP Standard transactions such as /SCWM/MON or /SCWM/PRDO (check FM '/SCWM/CALL_PRD', line ~60)
  " it identifies the LGNUM to be used on a global level based on your user and what you have pre-selected
  " in some default configs. It is used to reduce repetetive work for the user and have defaults to open up certain
  " transactions, without the need to always enter your desired warehouse number.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).

START-OF-SELECTION.
  " Set-Up everything & Initialize the required classes.
  " /SCWM/CL_TM is the general transaction manager for clean and proper transaction handling in EWM
  " more info can be seen here: https://wiki.scn.sap.com/wiki/download/attachments/451060111/EWM_Transaction_Handling.pdf?api=v2
  " (although there is a newer version, 2013 somewhere as well)

  /scwm/cl_tm=>set_lgnum( EXPORTING iv_lgnum = plgnum ).
  "First we need to get the guid of the given hu. Therefore the header data have to be read.
  CALL FUNCTION '/SCWM/HUHEADER_READ'
    EXPORTING
      iv_appl     = wmegc_huappl_wme
      iv_huident  = phu
      iv_nobuff   = abap_false
    IMPORTING
      es_huheader = ls_huheader
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  /scwm/cl_wm_packing=>get_instance(
    IMPORTING
      eo_instance = packing_api
  ).

  packing_api->init( EXPORTING iv_lgnum = plgnum EXCEPTIONS OTHERS = 99 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "Move hu to the preferred storing place by using the guid. This method can only create confirmed lb's.
  packing_api->/scwm/if_pack_bas~move_hu(
    EXPORTING
      iv_hu  =  ls_huheader-guid_hu " Unique Internal Identification of a Handling Unit
      iv_bin =  plgp                " Storage Bin for Stock Transfer
    EXCEPTIONS
      OTHERS = 1
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD packing_api->/scwm/if_pack_bas~save
    EXPORTING
      iv_commit = abap_true
    EXCEPTIONS
      OTHERS    = 1.
  IF sy-subrc <> 0 .
    ROLLBACK WORK.
  ENDIF.
