*&---------------------------------------------------------------------*
*& Report ZTSKY_R_MAIN_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_main_screen.

TABLES: sscrfields.

SELECTION-SCREEN PUSHBUTTON /2(20) pbs USER-COMMAND pbs.
SELECTION-SCREEN PUSHBUTTON /2(20) pbsi USER-COMMAND pbsi.

INITIALIZATION.
  pbs = TEXT-t01.
  pbsi = TEXT-t04.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'PBS'.
      CALL TRANSACTION 'ZTSKY_SUPPLY'.                   "#EC CI_CALLTA
    WHEN 'PBSI'.
      CALL TRANSACTION 'ZTSKY_SUPPLY_ALV'.               "#EC CI_CALLTA
  ENDCASE.
