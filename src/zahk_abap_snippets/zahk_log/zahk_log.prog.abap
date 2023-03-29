*&---------------------------------------------------------------------*
*& Report ZAHK_LOG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_log.

DATA lv_message TYPE string.

DATA(log) = NEW zcl_ahk_log( iv_bal_obj    = 'ZAHK'
                             iv_bal_subobj = 'ZAHK' ).

MESSAGE e000(zahk_log_mes) INTO lv_message.
log->add_message_to_log( ).
log->save( ).

MESSAGE i001(zahk_log_mes) INTO lv_message.
log->add_message_to_log( ).
log->save( ).

MESSAGE i002(zahk_log_mes) INTO lv_message.
log->add_message_to_log( ).
log->save( ).
