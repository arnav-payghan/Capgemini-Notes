*&---------------------------------------------------------------------*
*& Report Z34_PRACT_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z34_PRACT_ALV.

INCLUDE: Z34_PRACT_ALV_D, " Data Declaraions
         Z34_PRACT_ALV_S, " Selection Screen
         Z34_PRACT_ALV_F. " Subroutines

START-OF-SELECTION.

PERFORM fetch_data.
PERFORM display_data.
