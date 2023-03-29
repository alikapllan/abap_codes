*&---------------------------------------------------------------------*
*& Report ZAHK_06_CONV_OPERATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_07_conv_operator.

*&--------------------------------------*
*& Typ MAXBT -> Personalabrechnung: Betrag in ERP
*&--------------------------------------*

*DATA: gv_amount_words(250),
*      gv_amount       TYPE maxbt.
*
*PARAMETERS: p_amount TYPE dmbtr.
*
*START-OF-SELECTION.
*  "type conversion
*  gv_amount = p_amount.
*
*  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
*    EXPORTING
**     amt_in_num         = p_amount
*      amt_in_num         = gv_amount
*    IMPORTING
*      amt_in_words       = gv_amount_words
*    EXCEPTIONS
*      data_type_mismatch = 1
*      OTHERS             = 2.
*
*  WRITE : / gv_amount_words.
*
*END-OF-SELECTION.

"" NEW ""
DATA: gv_amount_words(250).

PARAMETERS: p_amount TYPE dmbtr.

CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
  EXPORTING
    amt_in_num         = CONV maxbt( p_amount )
  IMPORTING
    amt_in_words       = gv_amount_words
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.

WRITE : / gv_amount_words.
