*&---------------------------------------------------------------------*
*& Report ZTSKY_R_MAIN_PAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_main_page.

TABLES: sscrfields.

SELECTION-SCREEN PUSHBUTTON /2(20) pbs USER-COMMAND pbs.
SELECTION-SCREEN PUSHBUTTON /2(20) pbo USER-COMMAND pbo.
SELECTION-SCREEN PUSHBUTTON /2(20) pboi USER-COMMAND pboi.
SELECTION-SCREEN PUSHBUTTON /2(20) pbsi USER-COMMAND pbsi.

INITIALIZATION.
  pbs = TEXT-t01.
  pbo = TEXT-t02.
  pboi = TEXT-t03.
  pbsi = TEXT-t04.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'PBS'.
      CALL FUNCTION 'ZTSKY_FM_MVC'.

*      CALL TRANSACTION 'ZTSKY_NEW_SUPPLY'.
    WHEN 'PBO'.
      CALL TRANSACTION 'ZTSKY_NEW_ORDER'.
    WHEN 'PBOI'.
      CALL TRANSACTION 'ZTSKY_ORDERS_MAINT'.
    WHEN 'PBSI'.
      CALL TRANSACTION 'ZTSKY_SUPPLY_MAINT'.
  ENDCASE.
