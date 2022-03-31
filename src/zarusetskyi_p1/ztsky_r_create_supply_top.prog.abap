*&---------------------------------------------------------------------*
*& Include ZTSKY_R_CREATE_SUPPLY_TOP                - Report ZTSKY_R_CREATE_SUPPLY
*&---------------------------------------------------------------------*

TABLES: ztsky_s_supply_data.

CLASS lcl_controller DEFINITION DEFERRED.

DATA:
    go_lcl_controller TYPE REF TO lcl_controller.

START-OF-SELECTION.

  CALL SCREEN 100.
