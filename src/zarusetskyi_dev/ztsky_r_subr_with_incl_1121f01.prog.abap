*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUBR_WITH_INCL_1121F01
*&---------------------------------------------------------------------*

FORM get_data  CHANGING ct_data TYPE ty_t_zpb_t_person.

  DATA:
    lv1 TYPE char10,
    lv2 TYPE char10,
    lv3 TYPE char10.

  IF p_count = gv_count.
    EXIT.
  ENDIF.

  SELECT *
      FROM zpb_d_person
      APPENDING TABLE @ct_data
    WHERE first_name IN @s_fname.

  gv_count = gv_count + 1.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_DATA
*&---------------------------------------------------------------------*
FORM show_data  USING ut_data TYPE ty_t_zpb_t_person.

  DATA:

    lv3 TYPE numc3,
    lv4 TYPE char10.

  cl_salv_table=>factory(   IMPORTING r_salv_table = DATA(lo_salv)
                            CHANGING  t_table = ut_data   ).
  lo_salv->display( ).

ENDFORM.
