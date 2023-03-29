*&---------------------------------------------------------------------*
*& Report ZAHK_01_INLINE_DECLARATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_01_inline_declaration.

*&--------------------------------------*
*& Table bkpf only exists in ERP System
*&--------------------------------------*

TABLES: bkpf.

TYPES: BEGIN OF tp_bkpf,
         bukrs TYPE bkpf-bukrs,
         belnr TYPE bkpf-belnr,
         gjahr TYPE bkpf-gjahr,
       END OF tp_bkpf.

DATA: gt_bkpf  TYPE STANDARD TABLE OF tp_bkpf,
      gs_bkpf  TYPE tp_bkpf,
      gt_bkpf1 TYPE STANDARD TABLE OF bkpf,
      gs_bkpf1 TYPE bkpf,
      gt_bseg  TYPE STANDARD TABLE OF bseg,
      gs_bseg  TYPE bseg.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs,
                s_belnr FOR bkpf-belnr,
                s_gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "limited columns
  SELECT bukrs belnr gjahr FROM bkpf INTO TABLE gt_bkpf
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND gjahr IN s_gjahr.

  "select all fields
  SELECT * FROM bkpf INTO TABLE gt_bkpf1
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND gjahr IN s_gjahr.

  "line item data
  IF gt_bkpf1[] IS NOT INITIAL.
    SORT gt_bkpf1 BY bukrs belnr gjahr.

    SELECT * FROM bseg INTO TABLE gt_bseg
      FOR ALL ENTRIES IN gt_bkpf1
      WHERE bukrs = gt_bkpf1-bukrs
        AND belnr = gt_bkpf1-belnr
        AND gjahr = gt_bkpf1-gjahr.
  ENDIF.

  cl_demo_output=>write( gt_bkpf ).
  cl_demo_output=>write( gt_bkpf1 ).
  cl_demo_output=>display( gt_bseg ).

END-OF-SELECTION.
