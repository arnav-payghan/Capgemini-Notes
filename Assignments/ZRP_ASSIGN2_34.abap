*&---------------------------------------------------------------------*
*& Report ZRP_ASSIGN2_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrp_assign2_34.

*----------------------------------------------------------------------*
* DEFINING MY STRUCTURE TYPES FOR MARA AND VBAK.
*----------------------------------------------------------------------*

* MAIN SCREEN FOR UI *
SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-100.
  TABLES: mara, vbak.

  "RADIO BUTTONS TO CHOOSE MARA OR VBAK."
  SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-010.

    SELECTION-SCREEN: BEGIN OF LINE.

      SELECTION-SCREEN: COMMENT 10(10) TEXT-001 FOR FIELD p_rb1.
      SELECTION-SCREEN: POSITION 23.
      PARAMETERS: p_rb1 RADIOBUTTON GROUP rg_1. "MARA RADIOBUTTON"

      SELECTION-SCREEN: COMMENT 30(10) TEXT-002 FOR FIELD p_rb2.
      SELECTION-SCREEN: POSITION 43.
      PARAMETERS: p_rb2 RADIOBUTTON GROUP rg_1. "VBAK RADIOBUTTON"

    SELECTION-SCREEN: END OF LINE.
  SELECTION-SCREEN: END OF BLOCK b1.

  "SELECT OPTIONS FOR MATNR OR SALES DOC NUMBER."
  SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-020.
    SELECT-OPTIONS so_matnr FOR mara-matnr. "MATERIAL NUMBER SELECT OPTIONS."
    SELECT-OPTIONS so_vbeln FOR vbak-vbeln. "SALES DOCUMENT NUMBER SELECT OPTIONS."
  SELECTION-SCREEN: END OF BLOCK b2.

  "NUMBER OF ROWS"
  SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-030.
    PARAMETERS: p_rows TYPE char4.
  SELECTION-SCREEN: END OF BLOCK b3.

SELECTION-SCREEN: END OF BLOCK b0.

*----------------------------------------------------------------------*
* BACKEND LOGIC
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_mara,
         matnr           TYPE mara-matnr,
         ersda           TYPE mara-ersda,
         created_at_time TYPE mara-created_at_time,
         ernam           TYPE mara-ernam,
         laeda           TYPE mara-laeda,
         aenam           TYPE mara-aenam,
         vpsta           TYPE mara-vpsta,
         pstat           TYPE mara-pstat,
         lvorm           TYPE mara-lvorm,
         mtart           TYPE mara-mtart,
       END OF ty_mara,

       BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         erzet TYPE vbak-erzet,
         ernam TYPE vbak-ernam,
         angdt TYPE vbak-angdt,
         bnddt TYPE vbak-bnddt,
         audat TYPE vbak-audat,
         vbtyp TYPE vbak-vbtyp,
         trvog TYPE vbak-trvog,
         auart TYPE vbak-auart,
       END OF ty_vbak.


* DEFINING MY DATA
DATA: mara_table TYPE TABLE OF ty_mara, "INTERNAL TABLE FOR MARA
      vbak_table TYPE TABLE OF ty_vbak, "INTERNAL TABLE FOR VBAK
      wa_mara    TYPE ty_mara,          "WORK AREA FOR MARA
      wa_vbak    TYPE ty_vbak,          "WORK AREA FOR VBAK
      wa_matnr   LIKE LINE OF so_matnr,
      wa_vbeln   LIKE LINE OF so_vbeln,
      lv_test    TYPE CHAR40.

INITIALIZATION.

AT SELECTION-SCREEN.
  IF so_matnr IS INITIAL AND so_vbeln IS INITIAL.
    IF p_rows > 999. "USE CONSTANTS"
      MESSAGE: 'Error. Please choose Number of Rows equal to or below 999. Thank you.' TYPE 'E'.
    ELSEIF p_rows <= 0.
      MESSAGE: 'Error. Please choose Number of Rows greater than or equal to 1. Thank you.' TYPE 'E'.
    ENDIF.
  ELSEIF p_rows IS INITIAL.
    IF p_rb1 = 'X'.
      IF so_matnr IS INITIAL.
        MESSAGE: 'Error. Please choose proper range.' TYPE 'E'.
      ENDIF.
    ELSEIF p_rb2 = 'X'.
      IF so_vbeln IS INITIAL.
        MESSAGE: 'Error. Please choose proper range.' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.
  IF p_rb1 = 'X' AND so_vbeln IS NOT INITIAL.
    MESSAGE: 'WRONG FIELD ENTERED ERROR - You Have Filled VBAK Field as well.' TYPE 'E'.
  ELSEIF p_rb2 = 'X' AND so_matnr IS NOT INITIAL.
    MESSAGE: 'WRONG FIELD ENTERED - You Have Filled MARA Field as well.' TYPE 'E'.
  ENDIF.

  IF p_rb1 IS NOT INITIAL.
    READ TABLE so_matnr INTO wa_matnr.
    SELECT matnr
      FROM mara
      INTO lv_test
      WHERE matnr = wa_matnr-low.
    ENDSELECT.
    IF sy-subrc <> 0.
      MESSAGE: 'LOW VALUE: Material Number Does Not Exist.' TYPE 'E'.
    ENDIF.

    SELECT matnr
      FROM mara
      INTO lv_test
      WHERE matnr = wa_matnr-high.
    ENDSELECT.
    IF sy-subrc <> 0.
      MESSAGE: 'HIGH VALUE: Material Number Does Not Exist.' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF p_rb2 IS NOT INITIAL.
    READ TABLE so_vbeln INTO wa_vbeln.
    SELECT vbeln
      FROM vbak
      INTO lv_test
      WHERE vbeln = wa_vbeln-low.
    ENDSELECT.

    IF sy-subrc <> 0.
      MESSAGE: 'LOW VALUE: Sales Doc Number Does Not Exist.' TYPE 'E'.
    ENDIF.

    SELECT vbeln
      FROM vbak
      INTO lv_test
      WHERE vbeln = wa_vbeln-high.
    ENDSELECT.

    IF sy-subrc <> 0.
      MESSAGE: 'HIGH VALUE: Sale Doc Number Does Not Exist.' TYPE 'E'.
    ENDIF.
  ENDIF.

START-OF-SELECTION.

  IF p_rb1 = 'X'.
    IF p_rows IS INITIAL AND so_matnr IS NOT INITIAL.
      SELECT matnr ersda created_at_time ernam laeda aenam vpsta pstat lvorm mtart
      FROM mara
      INTO CORRESPONDING FIELDS OF TABLE mara_table
      WHERE matnr IN so_matnr.
      WRITE: / 'MATNR' COLOR 1, '|',
       10 'ERSDA' COLOR 1, '|',
       20 'CREATED_AT_TIME' COLOR 1, '|',
       30 'ERNAM' COLOR 1, '|',
       40 'LAEDA' COLOR 1, '|',
       50 'AENAM' COLOR 1, '|',
       60 'VPSTA' COLOR 1, '|',
       70 'PSTAT' COLOR 1, '|',
       80 'LVORM' COLOR 1, '|',
       90 'MTART' COLOR 1, '|'.
    ULINE.
    ELSE.
      SELECT matnr ersda created_at_time ernam laeda aenam vpsta pstat lvorm mtart
      FROM mara
      INTO TABLE mara_table UP TO p_rows ROWS.
      WRITE: / 'MATNR' COLOR 1, '|',
       10 'ERSDA' COLOR 1, '|',
       20 'CREATED_AT_TIME' COLOR 1, '|',
       30 'ERNAM' COLOR 1, '|',
       40 'LAEDA' COLOR 1, '|',
       50 'AENAM' COLOR 1, '|',
       60 'VPSTA' COLOR 1, '|',
       70 'PSTAT' COLOR 1, '|',
       80 'LVORM' COLOR 1, '|',
       90 'MTART' COLOR 1, '|'.
    ULINE.
    ENDIF.

    IF sy-subrc IS INITIAL.
      LOOP AT mara_table INTO wa_mara.
        WRITE: / wa_mara-matnr, '|',
           wa_mara-ersda, '|',
           wa_mara-created_at_time, '|',
           wa_mara-ernam, '|',
           wa_mara-laeda, '|',
           wa_mara-aenam, '|',
           wa_mara-vpsta, '|',
           wa_mara-pstat, '|',
           wa_mara-lvorm, '|',
           wa_mara-mtart, '|'.

        CLEAR wa_mara.
        ULINE.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF p_rb2 = 'X'.
    IF p_rows IS INITIAL AND so_vbeln IS NOT INITIAL.
      SELECT vbeln erdat erzet ernam angdt bnddt audat vbtyp trvog auart
      FROM vbak
      INTO CORRESPONDING FIELDS OF TABLE vbak_table
      WHERE vbeln IN so_vbeln.
      WRITE: / 'VBELN' COLOR 1, '|',
         10 'ERDAT' COLOR 1, '|',
         20 'ERZET' COLOR 1, '|',
         30 'ERNAM' COLOR 1, '|',
         40 'ANGDT' COLOR 1, '|',
         50 'BNDDT' COLOR 1, '|',
         60 'AUDAT' COLOR 1, '|',
         70 'VBTYP' COLOR 1, '|',
         80 'TRVOG' COLOR 1, '|',
         90 'AURAT' COLOR 1, '|'.
    ULINE.
    ELSE.
      SELECT vbeln erdat erzet ernam angdt bnddt audat vbtyp trvog auart
      FROM vbak
      INTO TABLE vbak_table UP TO p_rows ROWS.
      WRITE: / 'VBELN' COLOR 1, '|',
         10 'ERDAT' COLOR 1, '|',
         20 'ERZET' COLOR 1, '|',
         30 'ERNAM' COLOR 1, '|',
         40 'ANGDT' COLOR 1, '|',
         50 'BNDDT' COLOR 1, '|',
         60 'AUDAT' COLOR 1, '|',
         70 'VBTYP' COLOR 1, '|',
         80 'TRVOG' COLOR 1, '|',
         90 'AURAT' COLOR 1, '|'.
      ULINE.
    ENDIF.

    IF sy-subrc IS INITIAL.
      LOOP AT vbak_table INTO wa_vbak.
        WRITE: / wa_vbak-vbeln  COLOR 1, '|',
              wa_vbak-erdat COLOR 2, '|',
              wa_vbak-erzet COLOR 3, '|',
              wa_vbak-ernam COLOR 4, '|',
              wa_vbak-angdt COLOR 5, '|',
              wa_vbak-bnddt COLOR 6, '|',
              wa_vbak-audat COLOR 7, '|',
              wa_vbak-vbtyp COLOR 1, '|',
              wa_vbak-trvog COLOR 2, '|',
              wa_vbak-auart COLOR 3, '|'.

        CLEAR wa_vbak.
        ULINE.
      ENDLOOP.
    ENDIF.
 ENDIF.