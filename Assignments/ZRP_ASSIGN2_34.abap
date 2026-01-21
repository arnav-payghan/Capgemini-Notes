*&---------------------------------------------------------------------*
*& Report ZRP_ASSIGN2_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrp_assign2_34.

*----------------------------------------------------------------------*
* DEFINING MY STRUCTURE TYPES FOR MARA AND VBAK.
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
DATA: mara_table TYPE TABLE OF ty_mara, "INTERNAL TABLE FOR MARA"
      vbak_table TYPE TABLE OF ty_vbak, "INTERNAL TABLE FOR VBAK"
      wa_mara    TYPE ty_mara,          "WORK AREA FOR MARA"
      wa_vbak    TYPE ty_vbak.          "WORK AREA FOR VBAK"

* MAIN SCREEN FOR UI *
SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-100.

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
    TABLES: mara, vbak.
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

INITIALIZATION.

AT SELECTION-SCREEN.
  IF p_rows > 999.
    MESSAGE: 'Error. Please choose Number of Rows equal to or below 999. Thank you.' TYPE 'E'.
  ELSEIF p_rows <= 0.
    MESSAGE: 'Error. Please choose Number of Rows greater than or equal to 1. Thank you.' TYPE 'E'.
  ENDIF.


START-OF-SELECTION.

* SELECT-OPTION KAISE KARU CALCULATE??? *

  IF p_rb1 = 'X'.
    SELECT matnr
           ersda
           created_at_time
           ernam
           laeda
           aenam
           vpsta
           pstat
           lvorm
           mtart
    FROM mara
    INTO TABLE mara_table UP TO p_rows ROWS.

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
    SELECT vbeln
           erdat
           erzet
           ernam
           angdt
           bnddt
           audat
           vbtyp
           trvog
           auart
    FROM vbak
    INTO TABLE vbak_table UP TO p_rows ROWS.

    IF sy-subrc IS INITIAL.
      LOOP AT vbak_table INTO wa_vbak.
        WRITE: / wa_vbak-vbeln, '|',
              wa_vbak-erdat, '|',
              wa_vbak-erzet, '|',
              wa_vbak-ernam, '|',
              wa_vbak-angdt, '|',
              wa_vbak-bnddt, '|',
              wa_vbak-audat, '|',
              wa_vbak-vbtyp, '|',
              wa_vbak-trvog, '|',
              wa_vbak-auart, '|'.

        CLEAR wa_mara.
        ULINE.
      ENDLOOP.
    ENDIF.
  ENDIF.