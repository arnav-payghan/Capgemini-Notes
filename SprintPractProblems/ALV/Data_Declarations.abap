*&---------------------------------------------------------------------*
*& Include          Z34_PRACT_ALV_D
*&---------------------------------------------------------------------*

TABLES: mara.

TYPES: BEGIN OF ty_data,
         matnr TYPE mara-matnr,
         werks TYPE marc-werks,
         maktx TYPE makt-maktx,
       END OF ty_data.

DATA: lt_data TYPE TABLE OF ty_data,
      lt_fcat TYPE slis_t_fieldcat_alv.
