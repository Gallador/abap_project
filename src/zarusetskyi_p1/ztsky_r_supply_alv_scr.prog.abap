*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUPPLY_ALV_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.

SELECT-OPTIONS: s_supply   FOR ztsky_d_supply-id_supply,
                s_prod     FOR ztsky_d_supply-id_product,
                s_del      FOR ztsky_d_supply-supply_deliver NO INTERVALS,
                s_date     FOR ztsky_d_supply-supply_date.
SELECTION-SCREEN END OF BLOCK b01.
