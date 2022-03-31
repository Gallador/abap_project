
REPORT ztsky_r_sel_screen.

TABLES: zkai_d_book, zkai_d_author_t, zkai_d_author, t005t,
        sscrfields.

SELECT-OPTIONS:
so_book FOR zkai_d_book-book_id,
so_auth FOR zkai_d_book-author_id.

PARAMETERS:
  p_lang TYPE zkai_d_author_t-langu,
  p_add  AS CHECKBOX USER-COMMAND add.
.
SELECTION-SCREEN BEGIN OF BLOCK bn1 WITH FRAME TITLE TEXT-t01.
SELECT-OPTIONS:
   so_a_fn  FOR zkai_d_author_t-author_first_name MODIF ID id1,
   so_a_ln  FOR zkai_d_author_t-author_last_name MODIF ID id1,
   so_s_bd  FOR zkai_d_author-birth_date MODIF ID id1,
   so_a_c   FOR zkai_d_author-country MODIF ID id1,
   so_a_cn  FOR t005t-landx MODIF ID id1,
   so_bn    FOR zkai_d_book-book_name MODIF ID id1.
SELECTION-SCREEN END OF BLOCK bn1.

*Data definition
SELECTION-SCREEN PUSHBUTTON 10(15) pb1 USER-COMMAND inf VISIBLE LENGTH 30.



INITIALIZATION.
  pb1 = 'Information'(001). "TEXT-001
  p_lang = sy-langu.

*When: Process before output
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'ID1' AND p_add EQ 'X'.
      screen-active = '1'.
      MODIFY SCREEN.
      CONTINUE.
    ELSEIF screen-group1 = 'ID1' AND p_add NE 'X'.
      screen-active = '0'.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.
  ENDLOOP.


* When: Process after input / After user input data /
* Popuse of using: Check what user press, filled
AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'INF'.
      CALL TRANSACTION 'ZKI_ADD_INFO'.
  ENDCASE.


START-OF-SELECTION.
*Select all books for defined selection criteria
  SELECT zkai_d_author_t~author_first_name,
    zkai_d_author_t~author_last_name,
    zkai_d_author~birth_date,
    zkai_d_author~country,
    t005t~landx,
    zkai_d_book~book_name
  FROM zkai_d_author INNER JOIN zkai_d_author_t
    ON zkai_d_author~author_id = zkai_d_author_t~author_id
    AND zkai_d_author_t~langu = @p_lang
    INNER JOIN zkai_d_book ON zkai_d_author~author_id = zkai_d_book~author_id
    INNER JOIN t005t ON zkai_d_author~country = t005t~land1
    AND t005t~spras = @p_lang
    INTO TABLE @DATA(gt_data)
    WHERE zkai_d_author_t~author_first_name   IN @so_a_fn
    AND zkai_d_author_t~author_last_name      IN @so_a_ln
    AND zkai_d_author~birth_date              IN @so_s_bd
    AND zkai_d_author~country                 IN @so_a_c
    AND t005t~landx                           IN @so_a_cn
    AND zkai_d_book~book_id                   IN @so_book
    AND zkai_d_book~author_id                 IN @so_auth

    ORDER BY zkai_d_author_t~author_first_name,
             zkai_d_author_t~author_last_name.

END-OF-SELECTION.
  cl_salv_table=>factory(   IMPORTING r_salv_table = DATA(go_salv)   CHANGING  t_table = gt_data ).
  go_salv->display( ).
