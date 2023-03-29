*&---------------------------------------------------------------------*
*& Report ZAHK_06_VALUE_OPERATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_06_value_operator.

*&--------------------------------------*
*& Table BSAD only exists in ERP System
*&--------------------------------------*

TYPES: BEGIN OF tp_itab,
         bukrs TYPE bsad-bukrs,
         kunnr TYPE bsad-kunnr,
         blart TYPE bsad-blart,
       END  OF tp_itab.

DATA: gs_itab TYPE tp_itab,
      gt_itab TYPE TABLE OF tp_itab.

DATA(gs_bsad) = VALUE tp_itab( bukrs = '1204'
                               kunnr = '750000000'
                               blart = 'RV' ).

cl_demo_output=>write( gs_bsad ).

gt_itab = VALUE #( ( bukrs = '1204' kunnr = '750000001' blart = 'RV' )
                   ( bukrs = '1204' kunnr = '750000001' blart = 'JV' )
                   ( bukrs = '1204' kunnr = '750000001' blart = 'AB' ) ).

cl_demo_output=>display( gt_itab ).
