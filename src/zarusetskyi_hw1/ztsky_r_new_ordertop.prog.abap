*&---------------------------------------------------------------------*
*& Include ZTSKY_R_NEW_ORDERTOP                     - Report ZTSKY_R_NEW_ORDER
*&---------------------------------------------------------------------*
REPORT ztsky_r_new_order.

TABLES:
  sscrfields.

TYPES:
  BEGIN OF gty_s_order_items,
    mandt          TYPE ztsky_d_order-mandt,
    id_order       TYPE ztsky_d_order-id_order,
    id_pizza       TYPE ztsky_d_order-id_pizza,
    id_size        TYPE ztsky_d_order-id_size,
    order_quantity TYPE ztsky_d_order-order_quantity,
    order_date     TYPE ztsky_d_order-order_date,
    order_time     TYPE ztsky_d_order-order_time,
  END OF gty_s_order_items.

DATA:
  gt_pizza_values   TYPE vrm_values,
  gt_size_values    TYPE vrm_values,
  gty_t_order_items TYPE TABLE OF gty_s_order_items.
