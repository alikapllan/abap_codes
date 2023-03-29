*&---------------------------------------------------------------------*
*& Report ZAHK_08_REDUCE_OPERATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_08_reduce_operator.

*&--------------------------------------*
*& Table BSID only exists in ERP System
*&--------------------------------------*

DATA: lv_kunnr TYPE bsid-kunnr.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_kunnr FOR lv_kunnr.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_display_data.

END-OF-SELECTION.

FORM get_display_data.
  SELECT bukrs, kunnr, umsks, umskz, augdt, augbl, zuonr, gjahr, belnr, buzei, shkzg, blart,
    CASE shkzg WHEN 'H' THEN ( dmbtr * -1 ) ELSE dmbtr END AS amount FROM bsid
    INTO TABLE @DATA(gt_bsid)
    WHERE kunnr IN @s_kunnr.

  IF gt_bsid[] IS NOT INITIAL.
    SELECT kunnr, CAST( 0 AS DEC ) AS amount FROM kna1 INTO TABLE @DATA(gt_kna1)
                  WHERE kunnr IN @s_kunnr.

    LOOP AT gt_kna1 ASSIGNING FIELD-SYMBOL(<fs1>).

      <fs1>-amount = REDUCE i( INIT i TYPE dmbtr FOR wa IN gt_bsid WHERE ( kunnr = <fs1>-kunnr )
                             NEXT i = i + wa-amount ).
    ENDLOOP.

    cl_demo_output=>display( gt_kna1 ).
  ENDIF.

  BREAK-POINT.
ENDFORM.
