*&---------------------------------------------------------------------*
*& Report ZTSKY_R_CREATE_SUPPLY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_create_supply.

TABLES: ztsky_s_supply_data.

CLASS lcl_new_supply_view DEFINITION DEFERRED.

DATA:
    go_lcl_new_supply_view TYPE REF TO lcl_new_supply_view.

*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_CREATE_SUPPLY_CLD
*&---------------------------------------------------------------------*

CLASS lcl_new_supply_view DEFINITION FINAL.

  PUBLIC SECTION.

    DATA:
      gv_ucomm_0100 TYPE sy-ucomm.

    METHODS:
      pai
        RAISING
          zcx_supply_exceptions,
      pbo.

  PRIVATE SECTION.

    DATA:
      mo_supply     TYPE REF TO zcl_supply.

    METHODS:
      init,
      create_dynp_status,
      update_supply_from_ui.

ENDCLASS.

CREATE OBJECT go_lcl_new_supply_view.

START-OF-SELECTION.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_CREATE_SUPPLY_CLI
*&---------------------------------------------------------------------*

CLASS lcl_new_supply_view IMPLEMENTATION.

  METHOD pbo.

    me->create_dynp_status( ).
    me->init( ).

  ENDMETHOD.

  METHOD pai.

    CASE gv_ucomm_0100.
      WHEN 'BACK' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN 'SAVE'.
        COMMIT WORK AND WAIT.
        MESSAGE TEXT-t03 TYPE 'S'.
      WHEN 'ADD_ITEM'.
        IF ztsky_s_supply_data-id_product IS INITIAL
          OR ztsky_s_supply_data-supply_amount IS INITIAL
          OR ztsky_s_supply_data-supply_deliver IS INITIAL.
          RAISE EXCEPTION TYPE zcx_supply_exceptions
            EXPORTING
              textid = zcx_supply_exceptions=>supply_fields_empty.
        ELSEIF ztsky_s_supply_data-supply_amount <= 0.
          RAISE EXCEPTION TYPE zcx_supply_exceptions
            EXPORTING
              textid = zcx_supply_exceptions=>invalid_value.
        ELSE.
          me->update_supply_from_ui( ).
          MESSAGE TEXT-t01 TYPE 'S'.
        ENDIF.
      WHEN 'ADD_SUPPLY'.
        TRY.
            mo_supply->complete_supply( ).
            MESSAGE TEXT-t02 TYPE 'S'.
          CATCH zcx_supply_exceptions INTO DATA(lx_supply).
            DATA(lv_message_text) = lx_supply->get_text( ).
            MESSAGE: lv_message_text TYPE 'S' DISPLAY LIKE 'E'.
        ENDTRY.
    ENDCASE.
    CLEAR gv_ucomm_0100.

  ENDMETHOD.

  METHOD init.

    IF mo_supply IS NOT INITIAL.
      RETURN.
    ENDIF.

    CREATE OBJECT mo_supply.

    mo_supply->get_supply_data( ).

  ENDMETHOD.

  METHOD create_dynp_status.
    SET PF-STATUS 'STATUS'.
    SET TITLEBAR 'TITLE'.
  ENDMETHOD.

  METHOD update_supply_from_ui.

    CALL METHOD mo_supply->add_supply_item
      EXPORTING
        iv_product_id     = ztsky_s_supply_data-id_product
        iv_supply_amount  = ztsky_s_supply_data-supply_amount
        iv_supply_deliver = ztsky_s_supply_data-supply_deliver.

  ENDMETHOD.

ENDCLASS. "lcl_new_supply_view IMPLEMENTATION

MODULE pbo OUTPUT.

  go_lcl_new_supply_view->pbo( ).

ENDMODULE.

MODULE pai INPUT.

  TRY.
      go_lcl_new_supply_view->pai( ).
    CATCH zcx_supply_exceptions INTO DATA(lx_supply).
      DATA(lv_message_text) = lx_supply->get_text( ).
      MESSAGE: lv_message_text TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.

ENDMODULE.
