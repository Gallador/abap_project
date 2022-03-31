*&---------------------------------------------------------------------*
*& Report ZL1PB_R_ABAPSTATEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_sel_scr_simple.

TABLES: sscrfields, zpb_d_person.

TYPES:
  BEGIN OF ts_name,
    firstname   TYPE char20,
    surname     TYPE char20,
    dateofbirth TYPE datum,
  END OF ts_name.

DATA:
  gv_fname  TYPE zl1pb_firstname,
  gs_person TYPE zl1pb_person_flat,
  gt_addr   TYPE zl1pb_t_address.

CONSTANTS:
  gc_date TYPE dats VALUE '20180101'.

FIELD-SYMBOLS:
  <gs_person> TYPE zl1pb_person_deep.

SELECT-OPTIONS: s_fname FOR zpb_d_person-first_name.

PARAMETERS: p_add AS CHECKBOX
USER-COMMAND add
.

SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01.

SELECT-OPTIONS:
    s_mname FOR zpb_d_person-middle_name MODIF ID gr1,
    s_lname FOR zpb_d_person-last_name   MODIF ID gr1,
    s_age   FOR zpb_d_person-age         MODIF ID gr1,
    s_salary FOR zpb_d_person-salary     MODIF ID gr1.

SELECTION-SCREEN END OF BLOCK bn1.

SELECTION-SCREEN PUSHBUTTON 10(20) pb1 USER-COMMAND psb.

INITIALIZATION.
  pb1 = TEXT-001.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'GR1' AND p_add EQ 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
    ELSEIF screen-group1 = 'GR1'.
      screen-active = '0'.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'PSB'.
      CALL TRANSACTION 'ZPB_D_PERSON'.
  ENDCASE.

START-OF-SELECTION.

  SELECT *
    FROM zpb_d_person
    INTO TABLE @DATA(gt_zpb_d_person)
    WHERE first_name  IN @s_fname
      AND middle_name IN @s_mname
      AND last_name   IN @s_lname
      AND age         IN @s_age
      AND salary      IN @s_salary.

END-OF-SELECTION.

  cl_salv_table=>factory(   IMPORTING r_salv_table = DATA(go_salv)   CHANGING  t_table = gt_zpb_d_person   ).
  go_salv->display( ).
