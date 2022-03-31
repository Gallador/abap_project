*&---------------------------------------------------------------------*
*& Report ZPB_SQL_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_subr_with_incl_1121.

INCLUDE ztsky_r_subr_with_incl_1121top.
INCLUDE ztsky_r_subr_with_incl_1121sel.
INCLUDE ztsky_r_subr_with_incl_1121f01.

START-OF-SELECTION.
*
*  PERFORM get_data  CHANGING gt_data.
*  gv_count = 0.
*
*END-OF-SELECTION.
*
*  PERFORM show_data USING gt_data.

  CALL FUNCTION 'SAPL_ZTSKY_FG_LAB_FM1'
    EXPORTING
      iv_date       = sy-datum
*     IV_CARRID     =
    EXCEPTIONS
      wrong_date    = 1
      any_exception = 2
      OTHERS        = 3.
  IF sy-subrc <> 0.

    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Future date' TYPE 'E'.
    ENDCASE.

  ENDIF.
