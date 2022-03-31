*&---------------------------------------------------------------------*
*& Include          ZTSKY_R_CREATE_SUPPLY_CLD
*&---------------------------------------------------------------------*

CLASS lcl_controller DEFINITION.

  PUBLIC SECTION.

    DATA:
      mo_supply     TYPE REF TO zcl_supply,
      mo_read_data  TYPE REF TO zcl_read_dao,
      mo_write_data TYPE REF TO zcl_write_dao.

    METHODS: pai,
      pbo,
      init,
      create_dynp_status,
      update_model_from_ui,
      update_ui_from_model,
      free.

ENDCLASS.
