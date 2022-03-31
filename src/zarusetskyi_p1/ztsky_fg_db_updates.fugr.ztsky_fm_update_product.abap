FUNCTION ztsky_fm_update_product.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_PRODUCT) TYPE  ZTSKY_D_PRODUCT
*"----------------------------------------------------------------------

  UPDATE ztsky_d_product FROM is_product.

  IF sy-subrc <> 0.
    MESSAGE TEXT-t01 TYPE 'A'.
  ENDIF.

ENDFUNCTION.
