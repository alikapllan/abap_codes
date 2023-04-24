*&---------------------------------------------------------------------*
*& Report ZAHK_JOB_02_TRIGGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_job_02_trigger.

DATA: gv_jobname  TYPE tbtcjob-jobname,
      gv_jobcount TYPE tbtcjob-jobcount.

DATA: gv_matnr TYPE matnr.

START-OF-SELECTION.

  gv_jobname = 'JOB_TRIGGER_02'.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = gv_jobname
    IMPORTING
      jobcount         = gv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  "Triggering programm zahk_job_01 via JOB
  SUBMIT zahk_job_01
    WITH p_matnr = gv_matnr
    VIA JOB gv_jobname NUMBER gv_jobcount
    AND RETURN.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount  = gv_jobcount
      jobname   = gv_jobname
      strtimmed = abap_true
    EXCEPTIONS
      OTHERS    = 99.

  WRITE : 'Job has been triggered.'.
