*&---------------------------------------------------------------------*
*& Report Z34_PRACT_OOALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z34_PRACT_OOALV.

INCLUDE: Z34_PRACT_OOALV_D, " Data Declarations
         Z34_PRACT_OOALV_S, " Selection Screen
         Z34_PRACT_OOALV_C. " Classes and Methods
INCLUDE z34_pract_ooalv_user_commani01.
INCLUDE z34_pract_ooalv_status_0100o01.

INITIALIZATION.
CREATE OBJECT obj.

START-OF-SELECTION.
obj->fetch_data( ).
CALL SCREEN 0100.
