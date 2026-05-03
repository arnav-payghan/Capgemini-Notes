*&---------------------------------------------------------------------*
*& Include          Z34_PRACT_ALV_S
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE text-100.
  SELECT-OPTIONS: so_matnr FOR mara-matnr.
SELECTION-SCREEN: END OF BLOCK b0.
