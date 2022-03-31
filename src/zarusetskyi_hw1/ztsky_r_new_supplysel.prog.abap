*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_NEW_SUPPLYSEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

PARAMETERS:
  p_prod   TYPE ztsky_d_supply-id_product AS LISTBOX VISIBLE LENGTH 15,
  p_amount TYPE ztsky_d_supply-supply_amount,
  p_del    TYPE ztsky_d_supply-supply_deliver.

SELECTION-SCREEN PUSHBUTTON /2(20) pbsi USER-COMMAND pbsi.

SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN PUSHBUTTON /2(20) pbs USER-COMMAND pbs.
SELECTION-SCREEN PUSHBUTTON /2(20) pbmp USER-COMMAND pbmp.

INITIALIZATION.
  pbs = TEXT-t02.
  pbsi = TEXT-t03.
  pbmp = TEXT-t04.
  PERFORM init_param CHANGING gt_supply_values.


AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.
  PERFORM sel_screen_pai.
