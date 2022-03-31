*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_NEW_ORDERSEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

PARAMETERS:
  p_pizza   TYPE ztsky_d_order-id_pizza AS LISTBOX VISIBLE LENGTH 15,
  p_size TYPE ztsky_d_order-id_size AS LISTBOX VISIBLE LENGTH 15,
  p_qty    TYPE ztsky_d_order-order_quantity.

SELECTION-SCREEN PUSHBUTTON /2(20) pboi USER-COMMAND pboi.

SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN PUSHBUTTON /2(20) pbo USER-COMMAND pbo.
SELECTION-SCREEN PUSHBUTTON /2(20) pbmp USER-COMMAND pbmp.

INITIALIZATION.
  pbo = TEXT-t02.
  pbmp = TEXT-t03.
  pboi = TEXT-t04.
  PERFORM init_pizza_param CHANGING gt_pizza_values.
  PERFORM init_size_param CHANGING gt_size_values.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.
  PERFORM sel_screen_pai.
