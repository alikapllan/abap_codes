class ZCL_AHK_LOG definition
  public
  final
  create public .

public section.

  data LOG type ref to /SCWM/CL_LOG .

  methods CONSTRUCTOR
    importing
      !IV_BAL_OBJ type BALOBJ_D
      !IV_BAL_SUBOBJ type BALSUBOBJ .
  methods SAVE .
  methods ADD_MESSAGE_TO_LOG
    importing
      !IM_MSGTY type SYMSGTY optional
      !IM_MSGID type SYMSGID optional
      !IM_MSGNO type SYMSGNO optional
      !IM_MSGV1 type SYMSGV optional
      !IM_MSGV2 type SYMSGV optional
      !IM_MSGV3 type SYMSGV optional
      !IM_MSGV4 type SYMSGV optional
      !IM_MSG type BAPI_MSG optional .
protected section.
private section.

  data A_BAL_OBJ type BALOBJ_D .
  data A_LOG_HANDLE type BALLOGHNDL .
ENDCLASS.



CLASS ZCL_AHK_LOG IMPLEMENTATION.


  METHOD ADD_MESSAGE_TO_LOG.

    DATA: ls_msg TYPE bal_s_msg.
    " Definition data of message for the application log.
    ls_msg-msgty = COND #( WHEN im_msgty IS NOT INITIAL THEN im_msgty ELSE sy-msgty ).
    ls_msg-msgid = COND #( WHEN im_msgid IS NOT INITIAL THEN im_msgty ELSE sy-msgid ).
    ls_msg-msgno = COND #( WHEN im_msgno IS NOT INITIAL THEN im_msgty ELSE sy-msgno ).
    ls_msg-msgv1 = COND #( WHEN im_msgv1 IS NOT INITIAL THEN im_msgty ELSE sy-msgv1 ).
    ls_msg-msgv2 = COND #( WHEN im_msgv2 IS NOT INITIAL THEN im_msgty ELSE sy-msgv2 ).
    ls_msg-msgv3 = COND #( WHEN im_msgv3 IS NOT INITIAL THEN im_msgty ELSE sy-msgv3 ).
    ls_msg-msgv4 = COND #( WHEN im_msgv4 IS NOT INITIAL THEN im_msgty ELSE sy-msgv4 ).

    "Prüfung die Nachrichttypen
    CASE im_msgty.
      WHEN 'S' OR 'I' .
        ls_msg-probclass = '4'.
      WHEN 'W' .
        ls_msg-probclass = '3'.
      WHEN 'E' .
        ls_msg-probclass = '2'.
      WHEN 'A' .
        ls_msg-probclass = '1'.
      WHEN OTHERS.
        ls_msg-probclass = '4'.
    ENDCASE.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle  = a_log_handle
        i_s_msg       = ls_msg
      EXCEPTIONS
        log_not_found = 0
        OTHERS        = 99.
    IF sy-subrc <> 0.
      " Implement suitable error handling here
    ENDIF.
  ENDMETHOD.


  METHOD CONSTRUCTOR.

    DATA: ls_log TYPE bal_s_log.
    a_bal_obj = iv_bal_obj.

    log = NEW #( iv_nolog        = ''
                 iv_created_date = sy-datum
                 iv_created_time = sy-uzeit
                 iv_balobj       = iv_bal_obj
                 iv_balsubobj    = iv_bal_subobj ).

    "Definition einige Header-Data von der Application Log
    ls_log-object    = iv_bal_obj.
    ls_log-subobject = iv_bal_subobj.
    ls_log-aluser    = sy-uname.
    ls_log-altcode   = sy-tcode.
    ls_log-alprog    = sy-repid.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = ls_log
      IMPORTING
        e_log_handle = a_log_handle
      EXCEPTIONS
        OTHERS       = 99.
    IF sy-subrc <> 0.
* Implement suitable error handling here
      EXIT.
    ENDIF.

  ENDMETHOD.


  METHOD SAVE.

    DATA: it_log_handle TYPE bal_t_logh.

    APPEND a_log_handle TO it_log_handle.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_in_update_task = abap_true
        I_T_LOG_HANDLE   = it_log_handle
      EXCEPTIONS
        OTHERS           = 99.

    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
