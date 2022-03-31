*&---------------------------------------------------------------------*
*& Report ZTSKY_R_SEL_SCR_SIMPL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_sel_scr_simpl.

PARAMETERS: p_en   RADIOBUTTON GROUP gr1 DEFAULT 'X',
            p_de   RADIOBUTTON GROUP gr1,
            p_rows TYPE i.

START-OF-SELECTION.

  IF p_en = 'X'.
    DATA(gv_sprsl) = 'E'.
  ELSE.
    gv_sprsl = 'D'.
  ENDIF.

  SELECT *
    FROM t100
    INTO TABLE @DATA(gt_t100)
    UP TO @p_rows ROWS
    WHERE sprsl = @gv_sprsl.

  cl_salv_table=>factory(   IMPORTING r_salv_table = DATA(go_salv)
                            CHANGING  t_table = gt_t100   ).
  go_salv->display( ).
