```
*&---------------------------------------------------------------------*
*& Include          Z34HOMEPRACT_CI_F
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form fetch_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .
  CALL FUNCTION 'Z_34HP_CI_FM'
    TABLES
      final_table = git_final
      so_matnr    = so_matnr[].
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .
  LOOP AT git_final INTO gwa_final.
    WRITE: / gwa_final-matnr UNDER 'MATNR',
             gwa_final-ernam UNDER 'ERNAM',
             gwa_final-laeda UNDER 'LAEDA',
             gwa_final-aenam UNDER 'AENAM',
             gwa_final-vpsta UNDER 'VPSTA',
             gwa_final-pstat UNDER 'PSTAT',
             gwa_final-kunnr UNDER 'KUNNR',
             gwa_final-werks UNDER 'WEKRS' HOTSPOT,
             gwa_final-lgort UNDER 'LGORT'.
    CLEAR gwa_final.
  ENDLOOP.
  ULINE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_line_selection
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM handle_line_selection.

  TYPES: BEGIN OF ty_plant,
           matnr TYPE mard-matnr,
           werks TYPE mard-werks,
           lgort TYPE mard-lgort,
           pstat TYPE mard-pstat,
           lvorm TYPE mard-lvorm,
         END OF ty_plant.

  DATA: it_plant TYPE STANDARD TABLE OF ty_plant,
        wa_plant TYPE ty_plant.

  DATA: fname TYPE char30,
        fval  TYPE char30.

  GET CURSOR FIELD fname VALUE fval.

  IF fname = 'GWA_FINAL-WERKS'.
    SELECT matnr
           werks
           lgort
           pstat
           lvorm
      INTO TABLE it_plant
      FROM mard
      WHERE werks = fval.

    IF sy-subrc IS INITIAL.
      WRITE: / 'MATNR' COLOR 1,
             25 'WERKS' COLOR 2,
             40 'LGORT' COLOR 3,
             55 'PSTAT' COLOR 4,
             70 'LVORM' COLOR 5.
      ULINE.

      LOOP AT it_plant INTO wa_plant.
        WRITE: / wa_plant-matnr UNDER 'MATNR',
                 wa_plant-werks UNDER 'WERKS',
                 wa_plant-lgort UNDER 'LGORT',
                 wa_plant-pstat UNDER 'PSTAT',
                 wa_plant-lvorm UNDER 'LVORM'.
        CLEAR wa_plant.
      ENDLOOP.
      ULINE.
    ENDIF.
  ELSE.
    MESSAGE: 'PLEASE CLICK ON A VALUE IN THE "WERKS" FIELD.' TYPE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form validation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM validation .
  IF so_matnr IS INITIAL.
    MESSAGE: 'PLEASE ENTER MATERIAL NUMBER VALUES.' TYPE 'E'.
  ENDIF.
ENDFORM.
```