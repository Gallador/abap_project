*&---------------------------------------------------------------------*
*& Include ZTSKY_R_NEW_SUPPLYTOP                    - Module Pool      ZTSKY_R_NEW_SUPPLY
*&---------------------------------------------------------------------*
PROGRAM ztsky_r_new_supply.

TABLES:
  sscrfields.

TYPES:
  BEGIN OF gty_s_supply_items,
    mandt          TYPE ztsky_d_supply-mandt,
    id_supply      TYPE ztsky_d_supply-id_supply,
    id_product     TYPE ztsky_d_supply-id_product,
    supply_amount  TYPE ztsky_d_supply-supply_amount,
    supply_deliver TYPE ztsky_d_supply-supply_deliver,
    supply_date    TYPE ztsky_d_supply-supply_date,
  END OF gty_s_supply_items.



DATA:
  gt_supply_values   TYPE vrm_values,
  gty_t_supply_items TYPE TABLE OF gty_s_supply_items.


*  gt_supply_items  TYPE gty_t_supply_items.
*
*FIELD-SYMBOLS:
*      <gs_supply_items> TYPE gty_s_supply_items.
