FUNCTION z_tsky_fg_pizza_fme.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PROD1) TYPE  ZTSKY_PRODUCT_BALANCE
*"     REFERENCE(IV_PROD2) TYPE  ZTSKY_PRODUCT_BALANCE
*"     REFERENCE(IV_PROD3) TYPE  ZTSKY_PRODUCT_BALANCE
*"     REFERENCE(IV_PROD4) TYPE  ZTSKY_PRODUCT_BALANCE
*"     REFERENCE(IV_PROD5) TYPE  ZTSKY_PRODUCT_BALANCE
*"  EXCEPTIONS
*"      OUT_OF_STOCK
*"----------------------------------------------------------------------

  IF iv_prod1 <= 0 OR
    iv_prod2 <= 0 OR
    iv_prod3 <= 0 OR
    iv_prod4 <= 0 OR
    iv_prod5 <= 0.

    RAISE out_of_stock.

  ENDIF.



ENDFUNCTION.
