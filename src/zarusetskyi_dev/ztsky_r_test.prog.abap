*&---------------------------------------------------------------------*
*& Report ZTSKY_R_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTSKY_R_TEST.

SELECT carrid, connid, countryfr
  from spfli
  where ( carrid = 'LH' and connid = '0400' ) or countryfr = 'US'
  into table @data(gt_table).
  BREAK-POINT.
