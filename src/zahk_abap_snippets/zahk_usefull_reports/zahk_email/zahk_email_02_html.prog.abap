*&---------------------------------------------------------------------*
*& Report ZAHK_EMAIL_02_HTML
*&---------------------------------------------------------------------*
*& EMAIL w HTML
*&---------------------------------------------------------------------*
REPORT zahk_email_02_html.

DATA: go_gbt       TYPE REF TO cl_gbt_multirelated_service,
      go_bcs       TYPE REF TO cl_bcs,
      go_doc_bcs   TYPE REF TO cl_document_bcs,
      go_recipient TYPE REF TO if_recipient_bcs,
      gt_soli      TYPE STANDARD TABLE OF soli,
      gs_soli      TYPE soli,
      gv_status    TYPE bcs_rqst,
      gv_content   TYPE string.

DATA: gt_scarr TYPE STANDARD TABLE OF scarr,
      gs_scarr TYPE scarr.


START-OF-SELECTION.

  go_gbt = NEW #( ).

  SELECT * FROM scarr
    INTO TABLE gt_scarr.

  gv_content = '<!DOCTYPE html>'
            &&  '<html>                                     '
            &&  '                                           '
            &&  '	<head>                                    '
            &&  '    	<meta charset="utf-8">                '
            &&  '    	<style>                               '
            &&  '        	th {                              '
            &&  '            	background-color : lightgreen '
            &&  '                border : 2px solid;        '
            &&  '            }                              '
            &&  '                                           '
            &&  '            td{                            '
            &&  '            	background-color : lightblue; '
            &&  '                border : 1px solid;        '
            &&  '            }                              '
            &&  '        </style>                           '
            &&  '	</head>                                   '
            &&  '                                           '
            &&  '	<body>                                    '
            &&  '    	<table>                               '
            &&  '          <tr>                             '
            &&  '              <th>Kurzbezeichnung der Fluggesellschaft</th>           '
            &&  '              <th>Name einer Fluggesellschaft</th>           '
            &&  '              <th>Hauswährung der Fluggesellschaft</th>           '
            &&  '              <th>URL einer Fluggesellschaft</th>           '
            &&  '          </tr>                            '.


  LOOP AT gt_scarr INTO gs_scarr.

    gv_content = gv_content &&  '<tr>                          '
                &&  '              <td>' &&  gs_scarr-carrid && '</td>   '
                &&  '              <td>' &&  gs_scarr-carrname && '</td> '
                &&  '              <td>' &&  gs_scarr-currcode && '</td> '
                &&  '              <td>' &&  gs_scarr-url && '</td>      '
                &&  '            </tr>                                   '.
     ENDLOOP.

gv_content = gv_content &&  '        </table>                           '
                        &&  '	   </body>                                '
                        &&  '</html>                                    '.


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
