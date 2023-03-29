*&---------------------------------------------------------------------*
*& Report ZAHK_02_INLINE_DECLARATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_02_inline_declaration.

*&--------------------------------------*
*& Table bkpf only exists in ERP System
*&--------------------------------------*

TABLES: bkpf.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs,
                s_belnr FOR bkpf-belnr,
                s_gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "inline structure
  SELECT SINGLE * FROM bkpf INTO @DATA(gs_bkpf)
                   WHERE bukrs IN @s_bukrs
                     AND belnr IN @s_belnr
                     AND gjahr IN @s_gjahr.
*  cl_demo_output=>display( gs_bkpf ).

  "single variable
  SELECT SINGLE bukrs FROM bkpf INTO @DATA(gv_bukrs)
                   WHERE bukrs IN @s_bukrs
                     AND belnr IN @s_belnr
                     AND gjahr IN @s_gjahr.

  "at select multiple single variable
  SELECT SINGLE bukrs, belnr, gjahr FROM bkpf
     INTO (@DATA(gv_bukrs1), @DATA(gv_belnr1), @DATA(gv_gjahr1))
                   WHERE bukrs IN @s_bukrs
                     AND belnr IN @s_belnr
                     AND gjahr IN @s_gjahr.

  BREAK-POINT.

*  "limited no. columns
*  SELECT bukrs, belnr, gjahr FROM bkpf INTO TABLE @DATA(gt_bkpf)
*                             WHERE bukrs IN @s_bukrs
*                               AND belnr IN @s_belnr
*                               AND gjahr IN @s_gjahr.
*  "all columns
*  SELECT * FROM bkpf INTO TABLE @DATA(gt_bkpf1)
*                             WHERE bukrs IN @s_bukrs
*                               AND belnr IN @s_belnr
*                               AND gjahr IN @s_gjahr.
*  IF gt_bkpf1[] IS NOT INITIAL.
*    SORT gt_bkpf1 BY bukrs belnr gjahr.
*    "line items data
*    SELECT * FROM bseg INTO TABLE @DATA(gt_bseg) FOR ALL ENTRIES IN @gt_bkpf1
*                       WHERE bukrs = @gt_bkpf1-bukrs
*                         AND belnr = @gt_bkpf1-belnr
*                         AND gjahr = @gt_bkpf1-gjahr.
*  ENDIF.
*
*  cl_demo_output=>write( gt_bkpf ).
*  cl_demo_output=>write( gt_bkpf1 ).
*  cl_demo_output=>display( gt_bseg ).

END-OF-SELECTION.
