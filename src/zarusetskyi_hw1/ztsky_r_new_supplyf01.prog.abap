*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_NEW_SUPPLYF01
*&---------------------------------------------------------------------*

FORM sel_screen_pbo.

ENDFORM.

FORM init_param CHANGING ct_supply_values TYPE vrm_values.

  SELECT d~id_product AS key, concat_with_space( t~product_name, mt~measurment_name, 3 ) AS name
    FROM ztsky_d_product AS d
    JOIN ztsky_d_prod_t AS t
    ON d~id_product = t~id_product
    JOIN ztsky_d_meas AS m
    ON d~id_measurment = m~id_measurment
    JOIN ztsky_d_meas_t AS mt
    ON m~id_measurment = mt~id_measurment
    WHERE t~langu = @sy-langu
    AND mt~langu = @sy-langu
    INTO TABLE @ct_supply_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'p_prod'
      values          = ct_supply_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SEL_SCREEN_PAI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sel_screen_pai .

  CASE sscrfields-ucomm.
    WHEN 'PBS'.
      PERFORM add_supply.
    WHEN 'PBSI'.
      PERFORM add_supply_item.
    WHEN 'PBMP'.
      CALL TRANSACTION 'ZTSKY_MAIN_PAGE'.

  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_SUPPLY_ITEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_supply_item .

  DATA:
    ls_supply_item      TYPE gty_s_supply_items,
    lv_supply_id        TYPE ztsky_d_supply-id_supply.

  IF p_prod IS INITIAL OR p_amount IS INITIAL OR p_del IS INITIAL.

    IF p_amount <= 0.
      MESSAGE 'Invalid value!' TYPE 'E'.
    ELSE.
      MESSAGE 'Please fill all required fields!' TYPE 'E'.
    ENDIF.

  ELSE.

    IF lv_supply_id IS INITIAL.

      SELECT MAX( id_supply )
      FROM ztsky_d_supply
      INTO @lv_supply_id.

    ENDIF.

    ls_supply_item-mandt = sy-mandt.
    ls_supply_item-id_supply = lv_supply_id + 1.  "--lv_number_range
    ls_supply_item-id_product = p_prod.
    ls_supply_item-supply_amount = p_amount.
    ls_supply_item-supply_deliver = p_del.
    ls_supply_item-supply_date = sy-datum.

    INSERT ls_supply_item INTO TABLE gty_t_supply_items.

    IF sy-subrc = 0.
      MESSAGE 'Supply item was successfully added' TYPE 'I'.
    ELSE.
      MESSAGE 'Error!' TYPE 'W'.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_SUPPLY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_supply .

  DATA:

    ls_supply       TYPE ztsky_d_supply,
    ls_supply_items TYPE gty_s_supply_items,
    ls_product      TYPE ztsky_d_product.

  FIELD-SYMBOLS:
         <gs_supply_items> TYPE gty_s_supply_items.

  IF gty_t_supply_items IS INITIAL.
     MESSAGE 'Supply is empty' TYPE 'E'.
  ELSE.

    LOOP AT gty_t_supply_items ASSIGNING <gs_supply_items>.

      ls_supply-id_supply = <gs_supply_items>-id_supply.
      ls_supply-id_product = <gs_supply_items>-id_product.
      ls_supply-supply_amount = <gs_supply_items>-supply_amount.
      ls_supply-supply_deliver = <gs_supply_items>-supply_deliver.
      ls_supply-supply_date = <gs_supply_items>-supply_date.

      SELECT *
      FROM ztsky_d_product
      INTO TABLE @DATA(lt_product_amount)
      WHERE id_product = @ls_supply-id_product.

      LOOP AT lt_product_amount ASSIGNING FIELD-SYMBOL(<ls_product_amount>).
        ls_product-id_product = <ls_product_amount>-id_product.
        ls_product-id_measurment = <ls_product_amount>-id_measurment.
        ls_product-product_balance = <ls_product_amount>-product_balance.
      ENDLOOP.

      ls_product-product_balance = ls_product-product_balance + ls_supply-supply_amount.

      INSERT INTO ztsky_d_supply VALUES ls_supply.

      UPDATE ztsky_d_product FROM ls_product.

    ENDLOOP.

    IF sy-subrc = 0.
      MESSAGE 'Supply was successfully added' TYPE 'I'.
    ELSE.
      MESSAGE 'Error!' TYPE 'W'.
    ENDIF.

  ENDIF.

  CALL TRANSACTION 'ZTSKY_MAIN_PAGE'.

ENDFORM.
