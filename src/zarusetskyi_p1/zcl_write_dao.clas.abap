class ZCL_WRITE_DAO definition
  public
  create public .

public section.

  interfaces ZIF_SUPPLY_DAO .

  methods WRITE_NEW_SUPPLY
    importing
      !IT_SUPPLY type ZTSKY_TT_SUPPLY_DATA .
  methods UPDATE_PRODUCT_BALANCE
    importing
      !IT_PRODUCT type ZTSKY_T_PRODUCT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WRITE_DAO IMPLEMENTATION.


  METHOD update_product_balance.

    DATA:
          ls_product TYPE ztsky_d_product.

    LOOP AT it_product ASSIGNING FIELD-SYMBOL(<is_product>).
      ls_product-mandt = <is_product>-mandt.
      ls_product-id_product = <is_product>-id_product.
      ls_product-id_measurment = <is_product>-id_measurment.
      ls_product-product_balance = <is_product>-product_balance.

      CALL FUNCTION 'ZTSKY_FM_UPDATE_PRODUCT' IN UPDATE TASK
        EXPORTING
          is_product = ls_product.

    ENDLOOP.

  ENDMETHOD.


  METHOD write_new_supply.

    DATA:
      ls_supply  TYPE ztsky_d_supply.

    LOOP AT it_supply ASSIGNING FIELD-SYMBOL(<is_supply>).
      ls_supply-mandt = sy-mandt.
      ls_supply-id_supply = <is_supply>-id_supply.
      ls_supply-id_product = <is_supply>-id_product.
      ls_supply-supply_amount = <is_supply>-supply_amount.
      ls_supply-supply_deliver = <is_supply>-supply_deliver.
      ls_supply-supply_date = <is_supply>-supply_date.

      CALL FUNCTION 'ZTSKY_FM_CREATE_SUPPLY' IN UPDATE TASK
        EXPORTING
          is_supply = ls_supply.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
