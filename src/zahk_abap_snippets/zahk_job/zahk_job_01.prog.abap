*&---------------------------------------------------------------------*
*& Report ZAHK_JOB_01
*&---------------------------------------------------------------------*
*& JOB
*&---------------------------------------------------------------------*
REPORT zahk_job_01.

DATA: ls_material TYPE zahk_t0001.

PARAMETERS: p_matnr TYPE matnr.

START-OF-SELECTION.

  WAIT UP TO 10 SECONDS.

  ls_material = VALUE #( zguid = cl_system_uuid=>create_uuid_c32_static( )
                         matnr = p_matnr
                         uname = sy-uname
                         datum = sy-datum
                         uzeit = sy-uzeit ).

  INSERT zahk_t0001 FROM ls_material.

  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.
