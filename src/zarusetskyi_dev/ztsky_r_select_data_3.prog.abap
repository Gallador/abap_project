*&---------------------------------------------------------------------*
*& Report ZTSKY_R_SELECT_DATA_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_select_data_3.

START-OF-SELECTION.

  TYPES:
    BEGIN OF gty_s_auth_bd,
      author_first_name TYPE ztsky_d_author_t-author_first_name,
      author_last_name  TYPE ztsky_d_author_t-author_last_name,
      birth_date        TYPE ztsky_d_author-birth_date,
    END OF gty_s_auth_bd,

    gty_t_auth_bd TYPE TABLE OF gty_s_auth_bd.

  DATA:
    gt_auth_bd   TYPE gty_t_auth_bd,
    lv_lines     TYPE i,
    lv_year_sum  TYPE i,
    lv_month_sum TYPE i,
    lv_date_sum  TYPE i.

  FIELD-SYMBOLS:
    <gs_author_bd1> TYPE gty_s_auth_bd,
    <gs_author_bd2> TYPE gty_s_auth_bd,
    <gs_year_avg>   TYPE gty_s_auth_bd,
    <gs_month_avg>  TYPE gty_s_auth_bd,
    <gs_date_avg>   TYPE gty_s_auth_bd.

  SELECT t~author_first_name, t~author_last_name, a~birth_date
    FROM ztsky_d_author AS a
    JOIN ztsky_d_author_t AS t
      ON a~author_id = t~author_id
    INTO TABLE @gt_auth_bd.

  SORT gt_auth_bd BY birth_date.
  DESCRIBE TABLE gt_auth_bd LINES lv_lines.
  READ TABLE gt_auth_bd INDEX lv_lines
    ASSIGNING <gs_author_bd1>.

  READ TABLE gt_auth_bd INDEX 1
    ASSIGNING <gs_author_bd2>.

  WRITE: 'Youngest author:', /,
        <gs_author_bd1>-author_first_name,
        <gs_author_bd1>-author_last_name,
        <gs_author_bd1>-birth_date,

        /, 'Oldest author:', /,
        <gs_author_bd2>-author_first_name,
        <gs_author_bd2>-author_last_name,
        <gs_author_bd2>-birth_date.

  LOOP AT gt_auth_bd ASSIGNING <gs_year_avg>.
    lv_year_sum = lv_year_sum + <gs_year_avg>-birth_date+0(4).
  ENDLOOP.

*BREAK-POINT.

  lv_year_sum = lv_year_sum / lv_lines.

  WRITE:  /, 'Average birtday year = ', lv_year_sum.

  LOOP AT gt_auth_bd ASSIGNING <gs_month_avg>.
    lv_month_sum = lv_month_sum + <gs_month_avg>-birth_date+4(2).
  ENDLOOP.
*
*BREAK-POINT.

  lv_month_sum = lv_month_sum / lv_lines.

  WRITE:  /, 'Average birtday month = ', lv_month_sum.

*BREAK-POINT.

  LOOP AT gt_auth_bd ASSIGNING <gs_date_avg>.
    lv_date_sum = lv_date_sum + <gs_date_avg>-birth_date+6(2).
  ENDLOOP.
*
*BREAK-POINT.

  lv_date_sum = lv_date_sum / lv_lines.

  WRITE:  /, 'Average birtday date = ', lv_date_sum.
