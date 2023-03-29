*&---------------------------------------------------------------------*
*& Report ZAHK_BASIC_GLOBAL_MAT_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& This report demonstrates the very basic process of reading
*& the global information of a material.
*&
*& There are several ways to get information about a material. In this report
*& we use the function group '/SCWM/MATERIAL_READ_SINGLE'.
*& It is also possible to read multiple materials with the function group
*& '/SCWM/MATERIAL_READ_MULTIPLE'.

REPORT zahk_basic_global_mat_info.

DATA: glob_mat_struct TYPE /scwm/s_material_global.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.
PARAMETERS:
  plgnum TYPE  /scwm/lgnum,
  pmat   TYPE /scwm/de_matnr DEFAULT 'EDDING_SCHWARZ'.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ). "default back to EW1 system dummy lgnum
  input = 'Demo Input Data'.
  info = 'Zeigt sich die globalen Infos eines Materials'.

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum( iv_lgnum = plgnum ).
  DATA(ui_stock_helper) = NEW /scwm/cl_ui_stock_fields( ). "billion ways to convert matids
  DATA(material_to_read) = ui_stock_helper->get_matid_by_no( iv_matnr = pmat ).

  TRY.
      CALL FUNCTION '/SCWM/MATERIAL_READ_SINGLE'
        EXPORTING
          iv_matid      = material_to_read
          iv_lgnum      = plgnum
        IMPORTING
          es_mat_global = glob_mat_struct.

      cl_demo_output=>display( glob_mat_struct ).

    CATCH /scwm/cx_md.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
      RAISING error.
  ENDTRY.
