*&---------------------------------------------------------------------*
*& Include          Z34_PRACT_OOALV_D
*&---------------------------------------------------------------------*

TABLES: MARA.

DATA: lt_temp TYPE TABLE OF Z34TY_TEMPDATA,
      go_container TYPE REF TO cl_gui_custom_container,
      go_grid TYPE REF TO cl_gui_alv_grid,
      gs_layout TYPE lvc_s_layo.
