*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUPPLY_ALV_PBO
**&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CHECK go_main IS BOUND.
  go_main->mo_view->pbo_0100( ).

ENDMODULE.
