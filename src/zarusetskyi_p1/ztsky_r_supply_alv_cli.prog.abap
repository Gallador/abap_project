*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUPPLY_ALV_CLI
*&---------------------------------------------------------------------*
CLASS lcl_main IMPLEMENTATION.

  METHOD start_of_selection.

    IF go_main IS NOT BOUND.
      go_main = NEW #( ).
    ENDIF.

    go_main->get_data( ).

  ENDMETHOD.

  METHOD end_of_selection.

    CHECK go_main IS BOUND.

    IF go_main->mt_outtab IS NOT INITIAL.
      go_main->show_data( ).
    ELSE.
      MESSAGE TEXT-t01 TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.

  ENDMETHOD.

  METHOD get_data.
    DATA: ls_outtab   LIKE LINE OF mt_outtab,
          mo_read_dao TYPE REF TO zcl_read_dao.

    CREATE OBJECT mo_read_dao.

    CLEAR mt_outtab.

    CALL METHOD mo_read_dao->get_supply
      IMPORTING
        et_supply = rt_supply.

    IF sy-subrc = 0.
      LOOP AT rt_supply ASSIGNING FIELD-SYMBOL(<ls_supply>).
        ls_outtab = CORRESPONDING #( <ls_supply> ).
        APPEND ls_outtab TO mt_outtab.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD show_data.

    IF mo_view IS NOT BOUND.
      mo_view = NEW #( ).
    ENDIF.

    CALL SCREEN 0100.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_view IMPLEMENTATION.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.

    IF mo_grid IS NOT BOUND.
      CREATE OBJECT mo_container
        EXPORTING
          container_name              = mc_cont_name
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CREATE OBJECT mo_grid
        EXPORTING
          i_parent          = mo_container
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

* Generate fieldcatalog
      prepare_fcat( ).

* Prepare layout structure
      prepare_layout( ).

* Handling events of ALV grid object
      CREATE OBJECT mo_controller.
      SET HANDLER: mo_controller->handle_hotspot_click FOR mo_grid.

* Display data
      CALL METHOD mo_grid->set_table_for_first_display
        EXPORTING
          is_layout                     = ms_layout
        CHANGING
          it_outtab                     = go_main->mt_outtab
          it_fieldcatalog               = mt_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ELSE.
      CALL METHOD mo_grid->refresh_table_display
        EXPORTING
          is_stable = mc_s_stable
        EXCEPTIONS
          finished  = 1
          OTHERS    = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

  ENDMETHOD.                                                "pbo_0100

  METHOD pai_0100.

    CASE gv_0100_ucomm.
      WHEN gc_ucomm-back OR gc_ucomm-cancel.
        LEAVE TO SCREEN 0.
      WHEN gc_ucomm-exit.
        LEAVE PROGRAM.
    ENDCASE.

  ENDMETHOD.

  METHOD prepare_fcat.

* generating the fieldcatalog from dictionary structure name
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = mc_struc_name
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = mt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc = 0.
      LOOP AT mt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
        CASE <ls_fcat>-fieldname.
          WHEN 'ID_SUPPLY'.
            <ls_fcat>-emphasize = 'C300'.
          WHEN 'ID_PRODUCT'.
            <ls_fcat>-hotspot = abap_true.
          WHEN 'PRODUCT_NAME'.
            <ls_fcat>-hotspot = abap_true.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD. "prepare_fcat

  METHOD prepare_layout.

    ms_layout-cwidth_opt = abap_true. "Columns optimization

  ENDMETHOD.
                                                            "pai_0100
ENDCLASS.

CLASS lcl_controller IMPLEMENTATION.

  METHOD handle_hotspot_click.
* In case of clicking on the total/subtotal line
    CHECK es_row_no-row_id IS NOT INITIAL.
    READ TABLE go_main->mt_outtab ASSIGNING FIELD-SYMBOL(<ls_outtab>) INDEX es_row_no-row_id. "Index of the row
    CHECK sy-subrc = 0.

    SELECT SINGLE p~id_product,                         "#EC CI_NOORDER
                  pt~product_name,
                  p~product_balance,
                  mt~measurment_name
      FROM ztsky_d_product AS p
        JOIN ztsky_d_prod_t AS pt
          ON p~id_product = pt~id_product
        JOIN ztsky_d_meas AS m
          ON p~id_measurment = m~id_measurment
        JOIN ztsky_d_meas_t AS mt
          ON m~id_measurment = mt~id_measurment
      INTO @DATA(ls_product_properties)
      WHERE p~id_product = @<ls_outtab>-id_product
      AND pt~langu = @sy-langu
      AND mt~langu = @sy-langu.

    IF sy-subrc = 0.
      CALL FUNCTION 'ENQUEUE_EZTSKY_PRODUCT'
        EXPORTING
          mode_ztsky_d_product = 'E'
          mode_ztsky_d_prod_t  = 'E'
          mandt                = sy-mandt
          id_product           = <ls_outtab>-id_product
          langu                = sy-langu
          x_id_product         = ' '
          x_langu              = ' '
          _scope               = '1'
          _wait                = ' '
          _collect             = ' '
        EXCEPTIONS
          foreign_lock         = 1
          system_failure       = 2
          OTHERS               = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'ISM_POPUP_SHOW_DATA'
        EXPORTING
          struc_name = 'ZTSKY_S_PRODUCT_PROPERTIES'
          struc_data = ls_product_properties.
    ENDIF.

    CASE sy-ucomm.
      WHEN 'CANC' OR 'FURT'.
        CALL FUNCTION 'DEQUEUE_EZTSKY_PRODUCT'
          EXPORTING
            mode_ztsky_d_product = 'E'
            mode_ztsky_d_prod_t  = 'E'
            mandt                = sy-mandt
            id_product           = <ls_outtab>-id_product
            langu                = sy-langu
            x_id_product         = ' '
            x_langu              = ' '
            _scope               = '3'
            _synchron            = ' '
            _collect             = ' '.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
