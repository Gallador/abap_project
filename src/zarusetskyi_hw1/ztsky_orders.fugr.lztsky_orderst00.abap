*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 06.12.2021 at 19:33:14
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTSKY_V_ORDER...................................*
TABLES: ZTSKY_V_ORDER, *ZTSKY_V_ORDER. "view work areas
CONTROLS: TCTRL_ZTSKY_V_ORDER
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZTSKY_V_ORDER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZTSKY_V_ORDER.
* Table for entries selected to show on screen
DATA: BEGIN OF ZTSKY_V_ORDER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZTSKY_V_ORDER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZTSKY_V_ORDER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZTSKY_V_ORDER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZTSKY_V_ORDER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZTSKY_V_ORDER_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSKY_D_ORDER                  .
TABLES: ZTSKY_D_PIZZA                  .
TABLES: ZTSKY_D_PIZZA_T                .
TABLES: ZTSKY_D_SIZE                   .
TABLES: ZTSKY_D_SIZE_T                 .
