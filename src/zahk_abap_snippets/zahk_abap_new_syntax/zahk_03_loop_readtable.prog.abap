*&---------------------------------------------------------------------*
*& Report ZAHK_03_LOOP_READTABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_03_loop_readtable.

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

  SELECT * FROM bkpf INTO TABLE @DATA(gt_bkpf1)
                             WHERE bukrs IN @s_bukrs
                               AND belnr IN @s_belnr
                               AND gjahr IN @s_gjahr.

  SORT gt_bkpf1 BY bukrs belnr gjahr.

  "how to read particular field value ?
  TRY.
      DATA(gv_bukrs) = gt_bkpf1[ 1 ]-bukrs.
    CATCH cx_root.
  ENDTRY.

  WRITE gv_bukrs.


*  IF gt_bkpf1[] IS NOT INITIAL.
*
*    LOOP AT gt_bkpf1 INTO DATA(gs_bkpf1).
*
*      SELECT * FROM bseg INTO TABLE @DATA(gt_bseg) FOR ALL ENTRIES IN @gt_bkpf1
*        WHERE bukrs = @gt_bkpf1-bukrs
*          AND belnr = @gt_bkpf1-belnr
*          AND gjahr = @gt_bkpf1-gjahr.
*
*      TRY.
*          DATA(gs_bseg) = gt_bseg[ bukrs = gs_bkpf1-bukrs
*                                   belnr = gs_bkpf1-belnr
*                                   gjahr = gs_bkpf1-gjahr ].
*      CATCH cx_root.
*      ENDTRY.
*
*      CLEAR: gs_bkpf1.
*    ENDLOOP.
*  ENDIF.

*  READ TABLE gt_bkpf1 INTO DATA(gs_bkpf1) INDEX 1.
*  READ TABLE gt_bkpf1 INTO DATA(gs_bkpf1) WITH KEY gjahr = s_gjahr-low.

  "new syntax -->
*  IF gt_bkpf1[] IS NOT INITIAL.   "WITH IF -> DUMP
*    DATA(gs_bkpf1) = gt_bkpf1[ 1 ].
*  ENDIF.
*  TRY.
*      DATA(gs_bkpf1) = gt_bkpf1[ 1 ].
*    CATCH  cx_root.  "cx_sy_itab_line_not_found.
*      WRITE: / 'Record not found'.
*  ENDTRY.

*  DATA(gs_bkpf2) = VALUE #( gt_bkpf1[ 1 ] OPTIONAL ).
*  cl_demo_output=>display( gs_bkpf2 ).

  "how to get the last record ?
**  DESCRIBE TABLE gt_bkpf1 LINES DATA(gv_lines).
*  DATA(gv_lines) = lines( gt_bkpf1 ).
*  DATA(gs_bkpf2) = VALUE #( gt_bkpf1[ gv_lines ] OPTIONAL ).
*  cl_demo_output=>display( gs_bkpf2 ).


*  cl_demo_output=>display( gs_bkpf1 ).

*  "loop
*  LOOP AT gt_bkpf1 INTO DATA(gs_bkpf1).
*    EXIT.
*  ENDLOOP.
*
*  cl_demo_output=>write( gs_bkpf1 ).
*
*  "field symbol
*  LOOP AT gt_bkpf1 ASSIGNING FIELD-SYMBOL(<fs1>).
*    EXIT.
*  ENDLOOP.
*
*  cl_demo_output=>write( <fs1> ).
