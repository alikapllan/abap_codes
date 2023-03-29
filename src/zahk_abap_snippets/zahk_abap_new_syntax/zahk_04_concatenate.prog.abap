*&---------------------------------------------------------------------*
*& Report ZAHK_04_CONCATENATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_04_concatenate.

*&--------------------------------------*
*& Table bkpf only exists in ERP System
*&--------------------------------------*

"OLD
DATA: gv_str1(200).

SELECT SINGLE * FROM bkpf INTO @DATA(gs_bkpf).

CONCATENATE 'Account key' gs_bkpf-bukrs gs_bkpf-belnr gs_bkpf-gjahr
                          INTO gv_str1 SEPARATED BY space.

WRITE: gv_str1.

ULINE.
"NEW
DATA(gv_str_new) = |New Syntax --> Accounting key { gs_bkpf-bukrs } { gs_bkpf-belnr } { gs_bkpf-gjahr }|.
WRITE: gv_str_new.

ULINE.
DATA(gv_str2) = |Accounting key | && gs_bkpf-bukrs && gs_bkpf-belnr && gs_bkpf-gjahr
                && | created successfully |.
WRITE: gv_str2.
