*&---------------------------------------------------------------------*
*& Report ZSAPLAB_PATTERN_RANGES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztsky_r_ranges.
TABLES ztsky_d_book.

SELECT-OPTIONS:
so_book FOR ztsky_d_book-book_id,
so_auth FOR ztsky_d_book-author_id.

*Types definition

TYPES:
  BEGIN OF qty_book,
    book_id           TYPE ztsky_book_id,
    book_name         TYPE ztsky_book_name,
    author_first_name TYPE ztsky_first_name,
    author_last_name  TYPE ztsky_last_name,
    copy_qty          TYPE ztsky_copy_qty,
    booked_qty        TYPE int2,
    in_stock_qty      TYPE int2,
  END OF qty_book.

*Data definition

DATA:
  gt_book1 TYPE TABLE OF qty_book,
  gt_book2 TYPE TABLE OF qty_book.

*Select all books for defined ids and authors

SELECT book_id book_name author_first_name author_last_name
  FROM ztsky_d_book AS b
  JOIN ztsky_d_author_t AS a
    ON b~author_id = a~author_id
  INTO TABLE gt_book1
  WHERE b~book_id IN so_book
  AND a~author_id IN so_auth
  AND a~langu = sy-langu.

*Select all books for defined ids and authors and their total and booked quantity

SELECT b~book_id book_name author_first_name author_last_name copy_qty COUNT(*) AS booked_qty
  FROM ztsky_d_book AS b
  JOIN ztsky_d_author_t AS a
    ON b~author_id = a~author_id
  JOIN ztsky_d_booking AS c
    ON b~book_id = c~book_id
  INTO TABLE gt_book2
  WHERE b~book_id IN so_book
  AND a~author_id IN so_auth
  AND booking_status = '2'
  GROUP BY b~book_id book_name author_first_name author_last_name copy_qty.


*Write data 1

LOOP AT gt_book1 ASSIGNING FIELD-SYMBOL(<gs_book>).
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name.
ENDLOOP.

SKIP.
ULINE.
SKIP.

*Write data 2

LOOP AT gt_book2 ASSIGNING <gs_book>.
  <gs_book>-in_stock_qty = <gs_book>-copy_qty - <gs_book>-booked_qty.
  WRITE: / <gs_book>-book_id,
           <gs_book>-book_name,
           <gs_book>-author_first_name,
           <gs_book>-author_last_name,
           <gs_book>-in_stock_qty.
ENDLOOP.
