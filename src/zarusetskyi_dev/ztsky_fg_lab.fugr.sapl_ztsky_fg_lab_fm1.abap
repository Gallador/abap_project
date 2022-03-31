FUNCTION sapl_ztsky_fg_lab_fm1 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DATE) TYPE  DATUM
*"     REFERENCE(IV_CARRID) TYPE  S_CARR_ID OPTIONAL
*"  EXCEPTIONS
*"      WRONG_DATE
*"      ANY_EXCEPTION
*"----------------------------------------------------------------------



  IF iv_date >= sy-datum.
    RAISE wrong_date.
  ENDIF.

    MESSAGE |Today is { iv_date }| TYPE 'I'.



  ENDFUNCTION.
