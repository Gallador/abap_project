*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 06.12.2021 at 20:23:25
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTSKY_V_SUPPLY..................................*
TABLES: ZTSKY_V_SUPPLY, *ZTSKY_V_SUPPLY. "view work areas
CONTROLS: TCTRL_ZTSKY_V_SUPPLY
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZTSKY_V_SUPPLY. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZTSKY_V_SUPPLY.
* Table for entries selected to show on screen
DATA: BEGIN OF ZTSKY_V_SUPPLY_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZTSKY_V_SUPPLY.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZTSKY_V_SUPPLY_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZTSKY_V_SUPPLY_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZTSKY_V_SUPPLY.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZTSKY_V_SUPPLY_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSKY_D_PRODUCT                .
TABLES: ZTSKY_D_PROD_T                 .
TABLES: ZTSKY_D_SUPPLY                 .
