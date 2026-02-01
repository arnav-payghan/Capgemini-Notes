```
*&---------------------------------------------------------------------*
*& Report Z34_CLASSICAL_INTERACTIVE1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z34_CLASSICAL_INTERACTIVE1.

" INCLUDE FORMAT - T S F.

INCLUDE: Z34HOMEPRACT_CI_T,    " Data Declarations
         Z34HOMEPRACT_CI_S,    " Selection Screen
         Z34HOMEPRACT_CI_F.    " Subroutines

*INITIALIZATION.

AT SELECTION-SCREEN.
  PERFORM validation.

START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM display_data.

AT LINE-SELECTION.
  PERFORM handle_line_selection.

TOP-OF-PAGE.
  WRITE: 'MARA and MARD JOIN'.
  WRITE: / 'MATNR' COLOR 1,
        25 'ERNAM' COLOR 2,
        40 'LAEDA' COLOR 3,
        55 'AENAM' COLOR 4,
        70 'VPSTA' COLOR 5,
        85 'PSTAT' COLOR 6,
       100 'KUNNR' COLOR 7,
       115 'WEKRS' COLOR 1,
       130 'LGORT' COLOR 2.
  ULINE.
```