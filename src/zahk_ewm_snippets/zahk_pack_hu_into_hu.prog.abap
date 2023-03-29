*&---------------------------------------------------------------------*
*& Report ZAHK_PACK_HU_INTO_HU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_pack_hu_into_hu.

DATA: hu_headers TYPE /scwm/tt_huhdr_int.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE input.
SELECTION-SCREEN COMMENT /1(79) info.

PARAMETERS: phu_dest TYPE /scwm/huident,
            phu_src  TYPE /scwm/huident,
            plgnum   TYPE /scwm/lgnum.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  "This global paraemter is usually set by SAP Standard transactions such as
  " /SCWM/MON or /SCWM/PRDO (check FM '/SCWM/CALL_PRD', line ~60)
  "it identifies the LGNUM to be used on a global level based on your user and what you have pre-selected
  "in some default configs. It is used to reduce repetetive work for the user and have defaults to open up certain
  "transactions, without the need to always enter your desired warehouse number.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).
  input  = 'Demo Input Data'.
  info   = 'This report demonstrates how to pack a hu into another hu.'.

START-OF-SELECTION.
  /scwm/cl_tm=>set_lgnum(
    EXPORTING
      iv_lgnum         = plgnum " Warehouse Number/Warehouse Complex

  ).
  /scwm/cl_wm_packing=>get_instance( IMPORTING eo_instance = DATA(packing_api) ).
  packing_api->init( EXPORTING iv_lgnum = plgnum EXCEPTIONS OTHERS = 99 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  " The packing class works with core elements of EWM such as Warehouse Tasks or HUs.
  " These core elements are implemented using function groups and therefore rely on global state as well as a proper
  " lifecycle management of such state. As we want to repack stock from one HU to another we need to load the HU
  " information into the global state of the HU core so that this can later on be retrieved (within the class) and worked with.
  "It is necessary to read the header of the hus's to get the guid_hu, which is needed to pack one hu into the other.
  packing_api->/scwm/if_pack_bas~hu_gt_fill( EXPORTING it_huident   = VALUE /scwm/tt_huident( ( huident = phu_src )
                                                                                              ( huident = phu_dest ) )
                                             IMPORTING et_huhdr     = hu_headers
                                             EXCEPTIONS OTHERS      = 99 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  TRY.
      DATA(source_hu_item) = hu_headers[ 1 ].
      DATA(target_hu_item) = hu_headers[ 2 ].
    CATCH cx_sy_itab_line_not_found.
      MESSAGE 'Well ... that did not work. Seems like we are missing one of the HUs or rather its items' TYPE 'E'.
  ENDTRY.

  "The method beneath uses the guids to pack one hu into the other one.
  "Packing one hu into another is only possible if there are no open warehouse tasks within this hu.
  packing_api->pack_hu(
    EXPORTING
      iv_source_hu = hu_headers[ 2 ]-guid_hu
      iv_dest_hu   = hu_headers[ 1 ]-guid_hu
    EXCEPTIONS
      OTHERS       = 1
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  packing_api->save( EXCEPTIONS OTHERS = 99 ).
  IF sy-subrc <> 0.
    /scwm/cl_tm=>cleanup( ).
    ROLLBACK WORK.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    /scwm/cl_tm=>cleanup( ).
    MESSAGE 'Successfully packed source hu into destination hu!' TYPE 'S'.
  ENDIF.
