*&---------------------------------------------------------------------*
*& Report ZTSKY_R_LOOP_COND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_loop_cond.

* Task 1

SELECT t~author_first_name, t~author_last_name, a~country
  FROM ztsky_d_author AS a
  JOIN ztsky_d_author_t AS t
    ON a~author_id = t~author_id
  INTO TABLE @DATA(gt_author)
  WHERE langu = 'E'.


SELECT t~land1, t~landx, COUNT(*) AS count
  FROM t005t AS t
  JOIN ztsky_d_author AS a
    ON t~land1 = a~country
  INTO TABLE @DATA(gt_land)
  WHERE spras = @sy-langu
  GROUP BY t~land1, t~landx.

* Task 2

SELECT b~book_name, g~booking_status
  FROM ztsky_d_booking AS g
  JOIN ztsky_d_book AS b
    ON g~book_id = b~book_id
  INTO TABLE @DATA(gt_book)
  ORDER BY g~booking_status.

* Write Task 1

LOOP AT gt_land ASSIGNING FIELD-SYMBOL(<gs_land>).

  WRITE: /,
         <gs_land>-landx,
         <gs_land>-count.

  LOOP AT gt_author ASSIGNING FIELD-SYMBOL(<gs_author>)
    WHERE country = <gs_land>-land1.

    WRITE: /,
           <gs_author>-author_first_name,
           <gs_author>-author_last_name.

  ENDLOOP.

ENDLOOP.

SKIP.
ULINE.
SKIP.

* Write Task 2

WRITE: 'Сейчас читают:'.

LOOP AT gt_book ASSIGNING FIELD-SYMBOL(<gs_book1>)
  WHERE booking_status = '2'.

  WRITE:  /,
          <gs_book1>-book_name.

ENDLOOP.

SKIP.
ULINE.
SKIP.

WRITE: 'Уже вернули:'.

LOOP AT gt_book ASSIGNING FIELD-SYMBOL(<gs_book2>)
  WHERE booking_status = '1'.

  WRITE:  /,
          <gs_book2>-book_name.

ENDLOOP.
