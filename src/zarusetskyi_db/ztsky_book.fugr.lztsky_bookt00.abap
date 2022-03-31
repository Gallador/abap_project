*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 14.11.2021 at 14:02:26
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTSKY_D_BOOK....................................*
DATA:  BEGIN OF STATUS_ZTSKY_D_BOOK                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSKY_D_BOOK                  .
CONTROLS: TCTRL_ZTSKY_D_BOOK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTSKY_D_BOOK                  .
TABLES: ZTSKY_D_BOOK                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
