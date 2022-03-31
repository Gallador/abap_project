FUNCTION ztsky_fm_create_supply.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_SUPPLY) TYPE  ZTSKY_D_SUPPLY
*"----------------------------------------------------------------------

  INSERT INTO ztsky_d_supply VALUES is_supply.

  IF sy-subrc <> 0.
    MESSAGE TEXT-t01 TYPE 'A'.
  ENDIF.

ENDFUNCTION.
