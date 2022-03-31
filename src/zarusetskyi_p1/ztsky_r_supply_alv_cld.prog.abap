*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_SUPPLY_ALV_CLD
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      start_of_selection,
      end_of_selection.

    DATA: mo_view   TYPE REF TO lcl_view,
          mt_outtab TYPE TABLE OF ztsky_s_supply.

  PRIVATE SECTION.
    METHODS:
      get_data
        RETURNING
          VALUE(rt_supply) TYPE ztsky_tt_supply,
      show_data.
ENDCLASS.

CLASS lcl_view DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      pbo_0100,
      pai_0100.

  PRIVATE SECTION.
    METHODS:
      prepare_fcat,
      prepare_layout.

    CONSTANTS: mc_cont_name  TYPE scrfname   VALUE 'ALV_CONT',
               mc_struc_name TYPE typename   VALUE 'ZTSKY_S_SUPPLY',
               mc_s_stable   TYPE lvc_s_stbl VALUE 'XX'.

    DATA: mo_container  TYPE REF TO cl_gui_custom_container,
          mo_grid       TYPE REF TO cl_gui_alv_grid,
          mo_controller TYPE REF TO lcl_controller,
          mt_fcat       TYPE lvc_t_fcat,
          ms_layout     TYPE lvc_s_layo.

ENDCLASS.

CLASS lcl_controller DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          es_row_no e_column_id.

ENDCLASS.
