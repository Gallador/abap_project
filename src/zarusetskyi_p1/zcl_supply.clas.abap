class ZCL_SUPPLY definition
  public
  create public .

public section.

  methods GET_SUPPLY_DATA
    returning
      value(IS_SUPPLY_DATA) type VRM_VALUES .
  methods ADD_SUPPLY_ITEM
    importing
      !IV_PRODUCT_ID type ZTSKY_ID_PRODUCT
      !IV_SUPPLY_AMOUNT type ZTSKY_SUPPLY_AMOUNT
      !IV_SUPPLY_DELIVER type ZTSKY_SUPPLY_DELIVER
    exporting
      !EV_PRODUCT_ID type ZTSKY_ID_PRODUCT
      !EV_SUPPLY_AMOUNT type ZTSKY_SUPPLY_AMOUNT
    returning
      value(RV_SUPPLY_ID) type ZTSKY_ID_SUPPLY .
  methods COMPLETE_SUPPLY
    raising
      ZCX_SUPPLY_EXCEPTIONS .
protected section.
private section.

  data MO_READ_DAO type ref to ZCL_READ_DAO .
  data MO_WRITE_DAO type ref to ZCL_WRITE_DAO .
  data MS_SUPPLY_ITEMS type ZTSKY_S_SUPPLY_DATA .
  data MT_SUPPLY type ZTSKY_TT_SUPPLY_DATA .
  data MV_SUPPLY_ID type ZTSKY_ID_SUPPLY .
  data MT_PRODUCT type ZTSKY_T_PRODUCT .

  methods INCREASE_PRODUCT_BALANCE
    importing
      !IV_PRODUCT_ID type ZTSKY_ID_PRODUCT
      !IV_SUPPLY_AMOUNT type ZTSKY_SUPPLY_AMOUNT
    exporting
      !EV_PRODUCT_ID type ZTSKY_ID_PRODUCT
    returning
      value(RS_PRODUCT_DATA) type ZTSKY_S_PRODUCT .
ENDCLASS.



CLASS ZCL_SUPPLY IMPLEMENTATION.


  METHOD add_supply_item.

    CREATE OBJECT mo_read_dao.

    IF mv_supply_id IS INITIAL.

      CALL METHOD mo_read_dao->get_supply_id
        IMPORTING
          ev_supply_id = rv_supply_id.

      mv_supply_id = rv_supply_id + 1.

    ENDIF.

    ms_supply_items-mandt = sy-mandt.
    ms_supply_items-id_supply = mv_supply_id.
    ms_supply_items-id_product = iv_product_id.
    ms_supply_items-supply_amount = iv_supply_amount.
    ms_supply_items-supply_deliver = iv_supply_deliver.
    ms_supply_items-supply_date = sy-datum.

    INSERT ms_supply_items INTO TABLE mt_supply.

    ev_product_id = iv_product_id.
    ev_supply_amount = iv_supply_amount.

    CALL METHOD me->increase_product_balance
      EXPORTING
        iv_product_id = ev_product_id
        iv_supply_amount = ev_supply_amount.

  ENDMETHOD.


  METHOD complete_supply.

    IF mt_supply IS INITIAL.
      RAISE EXCEPTION TYPE zcx_supply_exceptions
        EXPORTING
          textid = zcx_supply_exceptions=>no_items.
    ELSE.
      CREATE OBJECT mo_write_dao.

      CALL METHOD mo_write_dao->write_new_supply
        EXPORTING
          it_supply = mt_supply.

      CALL METHOD mo_write_dao->update_product_balance
        EXPORTING
          it_product = mt_product.

      CLEAR: mt_product, mt_supply.

      mv_supply_id = mv_supply_id + 1.
    ENDIF.

  ENDMETHOD.


  METHOD GET_SUPPLY_DATA.

    CREATE OBJECT mo_read_dao.

    CALL METHOD mo_read_dao->get_supply_data
      IMPORTING
        es_supply_data = is_supply_data.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id              = 'ztsky_s_supply_data-id_product'
        values          = is_supply_data
      EXCEPTIONS
        id_illegal_name = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
*      implement suitable error handling here
    ENDIF.

  ENDMETHOD.


  METHOD increase_product_balance.

    CREATE OBJECT mo_read_dao.

    ev_product_id = iv_product_id.

    CALL METHOD mo_read_dao->get_product_data
      EXPORTING
        iv_product_id   = ev_product_id
      IMPORTING
        es_product_data = rs_product_data.

    rs_product_data-product_balance = rs_product_data-product_balance + iv_supply_amount.

    INSERT rs_product_data INTO TABLE mt_product.

  ENDMETHOD.
ENDCLASS.
