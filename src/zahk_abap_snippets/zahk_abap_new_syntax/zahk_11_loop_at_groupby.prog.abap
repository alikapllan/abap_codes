*&---------------------------------------------------------------------*
*& Report ZAHK_LOOP_AT_GROUPBY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_11_loop_at_groupby.

*&--------------------------------------*
*& Tables EKKO EKPO only exist in ERP System
*&--------------------------------------*

TABLES : ekko.

SELECT-OPTIONS: s_ebeln FOR ekko-ebeln.

START-OF-SELECTION.

  SELECT a~ebeln, a~lifnr, a~aedat,
         b~ebelp, b~matnr, b~txz01, b~menge, b~netpr
    FROM ekko AS a
    INNER JOIN ekpo AS b
      ON a~ebeln = b~ebeln
    INTO TABLE @DATA(gt_po) UP TO 30 ROWS
    WHERE matnr <> ' '.

  LOOP AT gt_po ASSIGNING FIELD-SYMBOL(<fs1>)
                GROUP BY <fs1>-ebeln ASCENDING.

    WRITE: <fs1>-ebeln COLOR 5.

    LOOP AT GROUP <fs1> ASSIGNING FIELD-SYMBOL(<fs2>).
      WRITE:/ ' ', <fs2>-ebelp, <fs2>-matnr, <fs2>-txz01,
                   <fs2>-menge, <fs2>-netpr.
    ENDLOOP.
    ULINE.
  ENDLOOP.

END-OF-SELECTION.
