*&---------------------------------------------------------------------*
*& Report ZAHK_10_FILTER_OPERATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_10_filter_operator.

*&--------------------------------------*
*& Table BSIK only exists in ERP System
*&--------------------------------------*

DATA: gt_bsik      TYPE TABLE OF bsik WITH NON-UNIQUE SORTED KEY blart COMPONENTS blart,
      gt_bsik_rt   TYPE TABLE OF bsik,
      gt_bsik_rall TYPE TABLE OF bsik.

SELECT * FROM bsik INTO TABLE gt_bsik UP TO 1000 ROWS WHERE gjahr = '2022'.

"doc type RT
gt_bsik_rt = FILTER #( gt_bsik USING KEY blart WHERE blart = 'RT' ).

"non rt doc type
gt_bsik_rall = FILTER #( gt_bsik EXCEPT USING KEY blart WHERE blart = 'RT' ).

BREAK-POINT.
