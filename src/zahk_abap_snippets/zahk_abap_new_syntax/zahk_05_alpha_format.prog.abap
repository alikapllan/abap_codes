*&---------------------------------------------------------------------*
*& Report ZAHK_05_ALPHA_FORMAT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_05_alpha_format.

*&--------------------------------------*
*& Table MARA only exists in ERP System
*&--------------------------------------*

DATA: gv_matnr TYPE matnr,
      gv_msg   TYPE string.

SELECT SINGLE matnr FROM mara INTO gv_matnr.

"old fm
"output
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING
*    input  = gv_matnr
*  IMPORTING
*    output = gv_matnr.
*
*CONCATENATE 'Material ID -> ' gv_matnr INTO gv_msg SEPARATED BY space.
*MESSAGE gv_msg TYPE 'I'.
*
*ULINE.
*
*"input
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    input  = gv_matnr
*  IMPORTING
*    output = gv_matnr.
*CONCATENATE 'Material ID -> ' gv_matnr INTO gv_msg SEPARATED BY space.
*MESSAGE gv_msg TYPE 'I'.

"NEW SYNTAX
"OUTPUT
gv_matnr = | { gv_matnr ALPHA = OUT } |.

gv_msg = |Material ID -> { gv_matnr }|.

MESSAGE gv_msg TYPE 'I'.

"INPUT
gv_matnr = | { gv_matnr ALPHA = IN } |.

gv_msg = |Material ID -> { gv_matnr }|.

MESSAGE gv_msg TYPE 'I'.
