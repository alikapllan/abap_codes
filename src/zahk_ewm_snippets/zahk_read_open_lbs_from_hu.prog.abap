*&---------------------------------------------------------------------*
*& Report ZAHK_READ_OPEN_LBS_FROM_HU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zahk_read_open_lbs_from_hu.

DATA: lt_huheader          TYPE /scwm/tt_huhdr_int,
      lt_open_lb_src       TYPE /scwm/tt_ordim_o,
      lt_quitted_lb_src    TYPE /scwm/tt_ordim_c,
      obj_splitter_main    TYPE REF TO cl_gui_splitter_container,
      obj_container_top    TYPE REF TO cl_gui_container,
      obj_container_buttom TYPE REF TO cl_gui_container.

PARAMETERS: phu    TYPE /scwm/huident,
            plgnum TYPE /scwm/lgnum.

INITIALIZATION.
  GET PARAMETER ID '/SCWM/LGN' FIELD plgnum.
  plgnum = COND #( WHEN plgnum IS INITIAL THEN 'WU02' ELSE plgnum ).

START-OF-SELECTION.

  /scwm/cl_tm=>set_lgnum( iv_lgnum = plgnum ).

  CALL FUNCTION '/SCWM/TO_READ_HU'
    EXPORTING
      iv_lgnum       = plgnum
      iv_huident     = phu
    IMPORTING
      et_ordim_o_src = lt_open_lb_src
      et_ordim_c_src = lt_quitted_lb_src
    EXCEPTIONS
      OTHERS         = 99.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  "------------------------------------Splitting Container preparations---------------------------------
  obj_splitter_main = NEW #(
          parent = cl_gui_container=>default_screen
          no_autodef_progid_dynnr = abap_true
          rows = 2
          columns = 1
   ).

  "set height of container
  obj_splitter_main->set_row_height( id = 1 height = 40 ).

  "set positions of containers
  obj_container_top = obj_splitter_main->get_container( row = 1 column = 1 ).
  obj_container_buttom = obj_splitter_main->get_container( row = 2 column = 1 ).

  "creating alv for top view
  DATA: obj_salv_top TYPE REF TO cl_salv_table.

  cl_salv_table=>factory(
    EXPORTING
      r_container = obj_container_top
    IMPORTING
      r_salv_table = obj_salv_top
    CHANGING
      t_table = lt_open_lb_src
  ).

  "settings for top container
  obj_salv_top->get_functions( )->set_all( abap_true ).
  obj_salv_top->get_columns( )->set_optimize( abap_true ).
  obj_salv_top->get_display_settings( )->set_list_header( 'Offene Lageraufgaben von' ).
  obj_salv_top->get_display_settings( )->set_striped_pattern( abap_true ).
  obj_salv_top->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
  "set column headers
  LOOP AT obj_salv_top->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<so>) .
    DATA(obj_col_top) = <so>-r_column.
    obj_col_top->set_short_text( || ).
    obj_col_top->set_medium_text( || ).
    obj_col_top->set_long_text( |{ obj_col_top->get_columnname( ) }| ).
  ENDLOOP.

  "showing alv top
  obj_salv_top->display( ).
  "creating a second alv
  DATA: obj_salv_buttom TYPE REF TO cl_salv_table.

  cl_salv_table=>factory( EXPORTING
                            r_container = obj_container_buttom
                          IMPORTING
                            r_salv_table = obj_salv_buttom
                          CHANGING
                            t_table = lt_quitted_lb_src ).
  " settings for buttom container
  obj_salv_buttom->get_functions( )->set_all( abap_true ).
  obj_salv_buttom->get_columns( )->set_optimize( abap_true ).
  obj_salv_buttom->get_display_settings( )->set_list_header( 'Offene Lageraufgaben nach' ).
  obj_salv_buttom->get_display_settings( )->set_striped_pattern( abap_true ).
  obj_salv_buttom->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

" set column headers
  LOOP AT obj_salv_buttom->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<su>).
    DATA(obj_col_buttom) = <su>-r_column.
    obj_col_buttom->set_short_text( || ).
    obj_col_buttom->set_medium_text( || ).
    obj_col_buttom->set_long_text( |{ obj_col_buttom->get_columnname( ) }| ).
  ENDLOOP.
" show alv
  obj_salv_buttom->display( ).
  " don't show empty toolbar
  cl_abap_list_layout=>suppress_toolbar( ).

  WRITE: space.
