*&---------------------------------------------------------------------*
*& Report ZTSKY_R_SELECT_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_select_data.

*Task 1

SELECT author_first_name, author_last_name
  FROM ztsky_d_author_t
  INTO TABLE @DATA(gt_author_t)
  WHERE author_last_name LIKE 'H%'
  AND langu LIKE 'E'.

*Task 2

SELECT SINGLE person_first_name, person_last_name, birth_date
  FROM ztsky_d_reader INNER JOIN ztsky_d_reader_t
  ON ztsky_d_reader~person_id = ztsky_d_reader_t~person_id
  INTO @DATA(gs_reader)
  WHERE birth_date EQ ( SELECT MAX( birth_date ) FROM ztsky_d_reader ).

*Task 3

SELECT person_first_name, person_last_name, COUNT(*) AS number
  FROM ztsky_d_reader_t INNER JOIN ztsky_d_reader
  ON ztsky_d_reader~person_id = ztsky_d_reader_t~person_id
  INNER JOIN ztsky_d_booking ON ztsky_d_reader~person_id = ztsky_d_booking~person_id
  INTO TABLE @DATA(gt_booking)
  WHERE booking_status = '2'
  AND langu = 'E'
  GROUP BY ztsky_d_booking~person_id, person_first_name, person_last_name.

*Task 4

SELECT country, COUNT(*) AS number
  FROM ztsky_d_author
  GROUP BY country
  ORDER BY country ASCENDING
  INTO TABLE @DATA(gt_country).


*Write for Task 1

  LOOP AT gt_author_t ASSIGNING FIELD-SYMBOL(<gs_author_t>).
    WRITE:/ <gs_author_t>-author_first_name, <gs_author_t>-author_last_name.
  ENDLOOP.

  SKIP.

*Write for Task 2

  WRITE:/ gs_reader.

  SKIP.

*Write for Task 3

  LOOP AT gt_booking ASSIGNING FIELD-SYMBOL(<gt_booking>).
    WRITE:/ <gt_booking>-person_first_name, <gt_booking>-person_last_name, <gt_booking>-number.
  ENDLOOP.

  SKIP.

*Write for Task 4

LOOP AT gt_country ASSIGNING FIELD-SYMBOL(<gs_country>).
  WRITE:/ <gs_country>-country, <gs_country>-number.
ENDLOOP.

  SKIP.
