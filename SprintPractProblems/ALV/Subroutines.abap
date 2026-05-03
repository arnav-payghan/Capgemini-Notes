*&---------------------------------------------------------------------*
*& Include          Z34_PRACT_ALV_F
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
  SELECT mara~matnr, marc~werks, makt~maktx
    FROM mara
    INNER JOIN marc ON mara~matnr = marc~matnr
    INNER JOIN makt ON mara~matnr = makt~matnr
    INTO TABLE @lt_data
    WHERE mara~matnr IN @so_matnr AND makt~spras = @sy-langu.
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
  " Field Cataloging using MERGE
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
   EXPORTING
     I_PROGRAM_NAME               = sy-cprog
     I_INTERNAL_TABNAME           = 'LT_DATA' " NOT NEEDED
     I_STRUCTURE_NAME             = 'Z34TY_TEMPDATA'
    CHANGING
      ct_fieldcat                  = lt_fcat
   EXCEPTIONS
     INCONSISTENT_INTERFACE       = 1
     PROGRAM_ERROR                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
    MESSAGE 'Error while ALV FC MERGE.' TYPE 'E'.
  ENDIF.

  " Display using ALV GRID
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     I_STRUCTURE_NAME                  = 'Z34TY_TEMPDATA'
*     IS_LAYOUT                         =
     IT_FIELDCAT                       = lt_fcat
    TABLES
      t_outtab                          = lt_data[]
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Error in Display ALV GRID.' TYPE 'E'.
  ENDIF.



ENDFORM.
