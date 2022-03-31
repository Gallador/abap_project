*&---------------------------------------------------------------------*
*& Report ZTSKY_R_LOOP_COND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_loop_cond_train.

PARAMETERS: p_cntr TYPE t005-land1.

START-OF-SELECTION.

  TYPES:
    BEGIN OF gty_s_cntr_auth,
      country           TYPE ztsky_d_author-country,
      author_first_name TYPE ztsky_d_author_t-author_first_name,
      author_last_name  TYPE ztsky_d_author_t-author_last_name,
    END OF gty_s_cntr_auth,

    BEGIN OF gty_s_auth_fl,
      author_first_name TYPE ztsky_d_author_t-author_first_name,
      author_last_name  TYPE ztsky_d_author_t-author_last_name,
    END OF gty_s_auth_fl,

    BEGIN OF gty_s_lnd,
      land1 TYPE t005t-land1,
      landx TYPE t005t-landx,
      count TYPE i,
    END OF gty_s_lnd,

    BEGIN OF gty_s_book,
      book_name      TYPE ztsky_d_book-book_name,
      booking_status TYPE ztsky_d_booking-booking_status,
    END OF gty_s_book,

    BEGIN OF gty_s_auth,
      author_first_name TYPE ztsky_d_author_t-author_first_name,
      author_last_name  TYPE ztsky_d_author_t-author_last_name,
    END OF gty_s_auth,
    gty_t_auth TYPE TABLE OF gty_s_auth WITH KEY author_first_name,

    BEGIN OF gty_s_lnd_auth,
      land1 TYPE t005t-land1,
      landx TYPE t005t-landx,
      BEGIN OF gty_s_authr,
        auth TYPE gty_t_auth,
      END OF gty_s_authr,
    END OF gty_s_lnd_auth,

    gty_t_cntr_auth TYPE TABLE OF gty_s_cntr_auth,
    gty_t_land      TYPE STANDARD TABLE OF gty_s_lnd,
    gty_t_book      TYPE STANDARD TABLE OF gty_s_book,
    gty_t_lnd_auth  TYPE STANDARD TABLE OF gty_s_lnd_auth.

  DATA: gt_author   TYPE gty_t_cntr_auth,
        gs_auth_fl  TYPE gty_s_auth_fl,
        gt_land     TYPE gty_t_land,
        gt_book     TYPE gty_t_book,
        gt_lnd_auth TYPE gty_t_lnd_auth.

  FIELD-SYMBOLS:
    <gs_land>   TYPE gty_s_lnd,
    <gs_author> TYPE gty_s_cntr_auth,
    <gs_book>   TYPE gty_s_book.
*   <gs_book2>  TYPE gty_s_book.

* Task 1

  SELECT t~author_first_name, t~author_last_name, a~country
    FROM ztsky_d_author AS a
    JOIN ztsky_d_author_t AS t
      ON a~author_id = t~author_id
    INTO TABLE @gt_author
  WHERE langu = 'E'.


  SELECT t~land1, t~landx, COUNT(*) AS count
    FROM t005t AS t
    JOIN ztsky_d_author AS a
      ON t~land1 = a~country
    INTO TABLE @gt_land
    WHERE spras = @sy-langu
  GROUP BY t~land1, t~landx.

* Task 2

  SELECT b~book_name, g~booking_status
    FROM ztsky_d_booking AS g
    JOIN ztsky_d_book AS b
      ON g~book_id = b~book_id
    INTO TABLE @gt_book
  ORDER BY g~booking_status.

* Write Task 1

  LOOP AT gt_land ASSIGNING <gs_land>.

    APPEND INITIAL LINE TO gt_lnd_auth ASSIGNING FIELD-SYMBOL(<gs_lnd_auth>).
    MOVE-CORRESPONDING <gs_land> TO <gs_lnd_auth>.

    LOOP AT gt_author ASSIGNING <gs_author>
       WHERE country = <gs_land>-land1.

      MOVE-CORRESPONDING <gs_author> TO gs_auth_fl.
      APPEND gs_auth_fl TO <gs_lnd_auth>-gty_s_authr-auth.

    ENDLOOP.

  ENDLOOP.
  SKIP.
  ULINE.
  SKIP.

  SORT gt_land.
  READ TABLE gt_land
    WITH KEY land1 = p_cntr
    ASSIGNING <gs_land>
    BINARY SEARCH.

  DATA lv_message TYPE char50.
  lv_message = <gs_land>-count.
  MESSAGE lv_message TYPE 'I'.

*  SORT gt_land BY land1.
*  LOOP AT gt_author ASSIGNING <gs_author>.
*
*    READ TABLE gt_land
*      WITH KEY land1 = <gs_author>-country
*      ASSIGNING <gs_land>
*      BINARY SEARCH.
*
*    IF sy-subrc <> 0.
*      MESSAGE 'Error' TYPE 'E'.
*    ENDIF.
*
*    WRITE: /,
*            <gs_author>-author_first_name,
*            <gs_author>-author_last_name,
*            <gs_land>-landx.
*
*   ENDLOOP.

* Write Task 2

*  WRITE: 'Сейчас читают:'.
*  LOOP AT gt_book ASSIGNING <gs_book1>
*    WHERE booking_status = '2'.
*    WRITE:  /,
*            <gs_book1>-book_name.
*  ENDLOOP.
*  SKIP.
*  ULINE.
*  SKIP.
*  WRITE: 'Уже вернули:'.
*  LOOP AT gt_book ASSIGNING <gs_book2>
*    WHERE booking_status = '1'.
*    WRITE:  /,
*            <gs_book2>-book_name.
*
