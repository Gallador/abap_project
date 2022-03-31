*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_CREATE_SUPPLY_CLI
*&---------------------------------------------------------------------*

CLASS lcl_controller IMPLEMENTATION.

  METHOD pbo.

    me->create_dynp_status( ).
    me->init( ).
    me->update_ui_from_model( ).

  ENDMETHOD.

  METHOD pai.

*    CREATE OBJECT mo_supply.

    CASE sy-ucomm.
      WHEN 'BACK' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN 'SAVE'.
        COMMIT WORK AND WAIT.
        MESSAGE: 'Supply has been saved!' TYPE 'S'.
      WHEN 'ADD_ITEM'.
*        CALL METHOD mo_supply->add_supply_item
*          EXPORTING
*            iv_product_id     = ztsky_s_supply_data-id_product
*            iv_supply_amount  = ztsky_s_supply_data-supply_amount
*            iv_supply_deliver = ztsky_s_supply_data-supply_deliver.
        MESSAGE: 'Item was succsessfuly added!' TYPE 'S'.
      WHEN 'ADD_SUPPLY'.
        mo_supply->complete_supply( ).
        MESSAGE: 'Supply was succsessfuly added!' TYPE 'S'.
    ENDCASE.
*    CLEAR gv_ucomm_0100.

  ENDMETHOD.

  METHOD init.

    IF mo_supply IS NOT INITIAL
      OR mo_read_data IS NOT INITIAL
      OR mo_write_data IS NOT INITIAL.
      RETURN.
    ENDIF.

    CREATE OBJECT mo_supply.
    CREATE OBJECT mo_read_data.
    CREATE OBJECT mo_write_data.

    mo_supply->get_supply_data( ).

  ENDMETHOD.

  METHOD create_dynp_status.
    SET PF-STATUS 'STATUS'.
    SET TITLEBAR 'TITLE'.
  ENDMETHOD.

  METHOD update_model_from_ui.

    mo_read_data->zif_supply_dao~mv_product = ztsky_s_supply_data-id_product.
    mo_read_data->zif_supply_dao~mv_supply_amount = ztsky_s_supply_data-supply_amount.
    mo_read_data->zif_supply_dao~mv_supply_deliver = ztsky_s_supply_data-supply_deliver.

  ENDMETHOD.

  METHOD update_ui_from_model.

  ENDMETHOD.

  METHOD free.



  ENDMETHOD.

ENDCLASS. "lcl_controller IMPLEMENTATION
