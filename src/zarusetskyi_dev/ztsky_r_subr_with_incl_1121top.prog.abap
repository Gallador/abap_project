*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUBR_WITH_INCL_1121TOP
*&---------------------------------------------------------------------*

TABLES:
  zpb_d_lab,
  zpb_d_person.

TYPES:
  ty_t_zpb_t_person TYPE STANDARD TABLE OF zpb_d_person,
  tt_zpb_t_person   TYPE STANDARD TABLE OF zpb_d_person.

DATA:
  gt_data  TYPE ty_t_zpb_t_person,
  gv_count TYPE i VALUE 2.
