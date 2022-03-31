*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_NEW_ORDERF01
*&---------------------------------------------------------------------*

FORM sel_screen_pbo.

ENDFORM.

FORM init_pizza_param CHANGING ct_pizza_values TYPE vrm_values.

  SELECT p~id_pizza AS key, pt~pizza_name AS name
    FROM ztsky_d_pizza AS p
    JOIN ztsky_d_pizza_t AS pt
    ON pt~id_pizza = p~id_pizza
    WHERE pt~langu = @sy-langu
    INTO TABLE @ct_pizza_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'p_pizza'
      values          = ct_pizza_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM init_size_param CHANGING ct_size_values TYPE vrm_values.

  SELECT s~id_size AS key, st~size_name AS name
    FROM ztsky_d_size AS s
    JOIN ztsky_d_size_t AS st
    ON st~id_size = s~id_size
    WHERE st~langu = @sy-langu
    INTO TABLE @ct_size_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'p_size'
      values          = ct_size_values
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
    WHEN 'PBO'.
      PERFORM add_order.
    WHEN 'PBOI'.
      PERFORM add_order_item.
    WHEN 'PBMP'.
      CALL TRANSACTION 'ZTSKY_MAIN_PAGE'.

  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_ORDER_ITEM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_order_item .

  DATA:
    ls_order_item TYPE gty_s_order_items,
    lv_order_id   TYPE ztsky_d_order-id_order.

  IF p_pizza IS INITIAL OR p_size IS INITIAL OR p_qty IS INITIAL.

    MESSAGE 'Please fill all required fields!' TYPE 'E'.

  ELSE.

    IF lv_order_id IS INITIAL.

      SELECT MAX( id_order )
      FROM ztsky_d_order
      INTO @lv_order_id.

    ENDIF.

    ls_order_item-mandt = sy-mandt.
    ls_order_item-id_order = lv_order_id.
    ls_order_item-id_pizza = p_pizza.
    ls_order_item-id_size = p_size.
    ls_order_item-order_quantity = p_qty.
    ls_order_item-order_date = sy-datum.
    ls_order_item-order_time = sy-uzeit.

    INSERT ls_order_item INTO TABLE gty_t_order_items.

    IF sy-subrc = 0.
      MESSAGE 'Order item was successfully added' TYPE 'I'.
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
FORM add_order .

  DATA:
    ls_order    TYPE ztsky_d_order,
    ls_product1 TYPE ztsky_d_product,
    ls_product2 TYPE ztsky_d_product,
    ls_product3 TYPE ztsky_d_product,
    ls_product4 TYPE ztsky_d_product,
    ls_product5 TYPE ztsky_d_product,
    ls_size     TYPE ztsky_d_size,
    ls_grammar1 TYPE ztsky_d_grammar,
    ls_grammar2 TYPE ztsky_d_grammar,
    ls_grammar3 TYPE ztsky_d_grammar,
    ls_grammar4 TYPE ztsky_d_grammar,
    ls_grammar5 TYPE ztsky_d_grammar.

  FIELD-SYMBOLS:
                 <gs_order_items> TYPE gty_s_order_items.

  IF gty_t_order_items IS INITIAL.
    MESSAGE 'Order is empty!' TYPE 'E'.

  ELSE.

    LOOP AT gty_t_order_items ASSIGNING <gs_order_items>.

      ls_order-id_order = <gs_order_items>-id_order.
      ls_order-id_pizza = <gs_order_items>-id_pizza.
      ls_order-id_size = <gs_order_items>-id_size.
      ls_order-order_quantity = <gs_order_items>-order_quantity.
      ls_order-order_date = <gs_order_items>-order_date.
      ls_order-order_time = <gs_order_items>-order_time.

      SELECT
        s~size_index,
        g~grammar_basic_amount,
        pr~product_balance,
        pr~id_product,
        pr~id_measurment
        FROM ztsky_d_pizza AS p
        JOIN ztsky_d_product AS pr
              ON p~product_1 = pr~id_product
        JOIN ztsky_d_grammar AS g
              ON g~id_product = pr~id_product
        JOIN ztsky_d_size AS s
              ON s~id_size = g~id_size
        WHERE p~id_pizza = @p_pizza
        AND s~id_size = @p_size
        INTO TABLE @DATA(lt_pizza_product1).

      SELECT
        s~size_index,
        g~grammar_basic_amount,
        pr~product_balance,
        pr~id_product,
        pr~id_measurment
        FROM ztsky_d_pizza AS p
        JOIN ztsky_d_product AS pr
              ON p~product_2 = pr~id_product
        JOIN ztsky_d_grammar AS g
              ON g~id_product = pr~id_product
        JOIN ztsky_d_size AS s
              ON s~id_size = g~id_size
        WHERE p~id_pizza = @p_pizza
        AND s~id_size = @p_size
        INTO TABLE @DATA(lt_pizza_product2).

      SELECT
        s~size_index,
        g~grammar_basic_amount,
        pr~product_balance,
        pr~id_product,
        pr~id_measurment
        FROM ztsky_d_pizza AS p
        JOIN ztsky_d_product AS pr
              ON p~product_3 = pr~id_product
        JOIN ztsky_d_grammar AS g
              ON g~id_product = pr~id_product
        JOIN ztsky_d_size AS s
              ON s~id_size = g~id_size
        WHERE p~id_pizza = @p_pizza
        AND s~id_size = @p_size
        INTO TABLE @DATA(lt_pizza_product3).

      SELECT
        s~size_index,
        g~grammar_basic_amount,
        pr~product_balance,
        pr~id_product,
        pr~id_measurment
        FROM ztsky_d_pizza AS p
        JOIN ztsky_d_product AS pr
              ON p~product_4 = pr~id_product
        JOIN ztsky_d_grammar AS g
              ON g~id_product = pr~id_product
        JOIN ztsky_d_size AS s
              ON s~id_size = g~id_size
        WHERE p~id_pizza = @p_pizza
        AND s~id_size = @p_size
        INTO TABLE @DATA(lt_pizza_product4).

      SELECT
        s~size_index,
        g~grammar_basic_amount,
        pr~product_balance,
        pr~id_product,
        pr~id_measurment
        FROM ztsky_d_pizza AS p
        JOIN ztsky_d_product AS pr
              ON p~product_5 = pr~id_product
        JOIN ztsky_d_grammar AS g
              ON g~id_product = pr~id_product
        JOIN ztsky_d_size AS s
              ON s~id_size = g~id_size
        WHERE p~id_pizza = @p_pizza
        AND s~id_size = @p_size
        INTO TABLE @DATA(lt_pizza_product5).


      LOOP AT lt_pizza_product1 ASSIGNING FIELD-SYMBOL(<ls_pizza_product1>).
        ls_product1-id_product = <ls_pizza_product1>-id_product.
        ls_product1-product_balance = <ls_pizza_product1>-product_balance.
        ls_product1-id_measurment = <ls_pizza_product1>-id_measurment.
        ls_grammar1-grammar_basic_amount = <ls_pizza_product1>-grammar_basic_amount.
        ls_size-size_index = <ls_pizza_product1>-size_index.
      ENDLOOP.

      LOOP AT lt_pizza_product2 ASSIGNING FIELD-SYMBOL(<ls_pizza_product2>).
        ls_product2-id_product = <ls_pizza_product2>-id_product.
        ls_product2-product_balance = <ls_pizza_product2>-product_balance.
        ls_product2-id_measurment = <ls_pizza_product2>-id_measurment.
        ls_grammar2-grammar_basic_amount = <ls_pizza_product2>-grammar_basic_amount.
      ENDLOOP.

      LOOP AT lt_pizza_product3 ASSIGNING FIELD-SYMBOL(<ls_pizza_product3>).
        ls_product3-id_product = <ls_pizza_product3>-id_product.
        ls_product3-product_balance = <ls_pizza_product3>-product_balance.
        ls_product3-id_measurment = <ls_pizza_product3>-id_measurment.
        ls_grammar3-grammar_basic_amount = <ls_pizza_product3>-grammar_basic_amount.
      ENDLOOP.

      LOOP AT lt_pizza_product4 ASSIGNING FIELD-SYMBOL(<ls_pizza_product4>).
        ls_product4-id_product = <ls_pizza_product4>-id_product.
        ls_product4-product_balance = <ls_pizza_product4>-product_balance.
        ls_product4-id_measurment = <ls_pizza_product4>-id_measurment.
        ls_grammar4-grammar_basic_amount = <ls_pizza_product4>-grammar_basic_amount.
      ENDLOOP.

      LOOP AT lt_pizza_product5 ASSIGNING FIELD-SYMBOL(<ls_pizza_product5>).
        ls_product5-id_product = <ls_pizza_product5>-id_product.
        ls_product5-product_balance = <ls_pizza_product5>-product_balance.
        ls_product5-id_measurment = <ls_pizza_product5>-id_measurment.
        ls_grammar5-grammar_basic_amount = <ls_pizza_product5>-grammar_basic_amount.
      ENDLOOP.

      ls_product1-product_balance = ls_product1-product_balance - p_qty * ( ls_grammar1-grammar_basic_amount * ls_size-size_index ).
      ls_product2-product_balance = ls_product2-product_balance - p_qty * ( ls_grammar2-grammar_basic_amount * ls_size-size_index ).
      ls_product3-product_balance = ls_product3-product_balance - p_qty * ( ls_grammar3-grammar_basic_amount * ls_size-size_index ).
      ls_product4-product_balance = ls_product4-product_balance - p_qty * ( ls_grammar4-grammar_basic_amount * ls_size-size_index ).
      ls_product5-product_balance = ls_product5-product_balance - p_qty * ( ls_grammar5-grammar_basic_amount * ls_size-size_index ).

      CALL FUNCTION 'Z_TSKY_FG_PIZZA_FME'
        EXPORTING
          iv_prod1     = ls_product1-product_balance
          iv_prod2     = ls_product2-product_balance
          iv_prod3     = ls_product3-product_balance
          iv_prod4     = ls_product4-product_balance
          iv_prod5     = ls_product5-product_balance
        EXCEPTIONS
          out_of_stock = 1
          OTHERS       = 2.
      IF sy-subrc <> 0.

        CASE sy-subrc.
          WHEN 1.
            MESSAGE 'Pizza is out of stock!' TYPE 'E'.
        ENDCASE.
      ELSE.
        INSERT INTO ztsky_d_order VALUES ls_order.

        UPDATE ztsky_d_product FROM ls_product1.
        UPDATE ztsky_d_product FROM ls_product2.
        UPDATE ztsky_d_product FROM ls_product3.
        UPDATE ztsky_d_product FROM ls_product4.
        UPDATE ztsky_d_product FROM ls_product5.
      ENDIF.





*      ENDIF.

    ENDLOOP.

    IF sy-subrc = 0.

      MESSAGE 'Order was successfully added' TYPE 'I'.
    ELSE.
      MESSAGE 'Error!' TYPE 'W'.
    ENDIF.

  ENDIF.

  CALL TRANSACTION 'ZTSKY_MAIN_PAGE'.

ENDFORM.
