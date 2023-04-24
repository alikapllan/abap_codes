*&---------------------------------------------------------------------*
*& Report ZAHK_EMAIL_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_email_01.

DATA: go_gbt       TYPE REF TO cl_gbt_multirelated_service,
      go_bcs       TYPE REF TO cl_bcs,
      go_doc_bcs   TYPE REF TO cl_document_bcs,
      go_recipient TYPE REF TO if_recipient_bcs,
      gt_soli      TYPE STANDARD TABLE OF soli,
      gs_soli      TYPE soli,
      gv_status    TYPE bcs_rqst,
      gv_content   TYPE string.


START-OF-SELECTION.

  go_gbt = NEW #( ).

  gv_content = 'This is a test mail!'.

  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  go_gbt->set_main_html( EXPORTING content = gt_soli ).

  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
                                 i_subject = 'Test Email Subject'
                                 i_multirel_service = go_gbt ).

  go_recipient = cl_cam_address_bcs=>create_internet_address(
                   i_address_string = 'alihkaplan44@hotmail.com' ).

  go_bcs = cl_bcs=>create_persistent( ).
  go_bcs->set_document( i_document = go_doc_bcs ).
  go_bcs->add_recipient( i_recipient = go_recipient ).

  gv_status = 'N'.

  go_bcs->set_status_attributes( EXPORTING i_requested_status = gv_status ).

  go_bcs->send( ).
  COMMIT WORK.
