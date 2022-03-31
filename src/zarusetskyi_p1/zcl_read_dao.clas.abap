class ZCL_READ_DAO definition
  public
  final
  create public .

public section.

  interfaces ZIF_SUPPLY_DAO .

  methods GET_SUPPLY_DATA
    exporting
      !ES_SUPPLY_DATA type VRM_VALUES .
  methods GET_SUPPLY_ID
    exporting
      !EV_SUPPLY_ID type ZTSKY_ID_SUPPLY .
  methods GET_PRODUCT_DATA
    importing
      !IV_PRODUCT_ID type ZTSKY_ID_PRODUCT
    exporting
      !ES_PRODUCT_DATA type ZTSKY_S_PRODUCT .
  methods GET_SUPPLY
    exporting
      !ET_SUPPLY type ZTSKY_TT_SUPPLY .
protected section.
private section.
ENDCLASS.



CLASS ZCL_READ_DAO IMPLEMENTATION.


  METHOD get_product_data.

    SELECT SINGLE *
      FROM ztsky_d_product
      WHERE id_product = @iv_product_id
      INTO @es_product_data.

  ENDMETHOD.


  METHOD get_supply.

    SELECT s~id_supply,
       s~id_product,
       pt~product_name,
       s~supply_amount,
       s~supply_deliver,
       s~supply_date
      FROM ztsky_d_supply      AS s
      JOIN ztsky_d_product     AS p
        ON s~id_product = p~id_product
      JOIN ztsky_d_prod_t      AS pt
        ON p~id_product = pt~id_product
      WHERE pt~langu = @sy-langu
      ORDER BY s~id_supply
      INTO TABLE @et_supply.

  ENDMETHOD.


  METHOD get_supply_data.

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
    INTO TABLE @es_supply_data.

  ENDMETHOD.


  METHOD get_supply_id.

    SELECT MAX( id_supply )                             "#EC CI_NOWHERE
      FROM ztsky_d_supply
      INTO @ev_supply_id.

  ENDMETHOD.
ENDCLASS.
