*&---------------------------------------------------------------------*
*& Report ZASSIGN4_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zassign4_34.

*------------------------------------------------------------------------------------*
* DISPLAY SELECTION SCREEN.
*------------------------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-100.
  TABLES: mara, marc, vbak, vbap, ekko, ekpo.

  " USER DATA - Which User is using and when.

  SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-010.
    PARAMETERS: p_user TYPE char12,   " sy-uname
                p_date TYPE dats,     " sy-datum
                p_time TYPE time.     " sy-uzeit
  SELECTION-SCREEN: END OF BLOCK b1.

  " RADIOBUTTONS (6 Tables)

  SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-020.
    SELECTION-SCREEN: BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 18(4) TEXT-021 FOR FIELD rb_mara.
      SELECTION-SCREEN POSITION 24.
      PARAMETERS: rb_mara RADIOBUTTON GROUP rg_1 USER-COMMAND rbc.   " MARA RADIOBUTTON
      SELECTION-SCREEN COMMENT 37(4) TEXT-022 FOR FIELD rb_marc.
      SELECTION-SCREEN POSITION 43.
      PARAMETERS: rb_marc RADIOBUTTON GROUP rg_1.   " MARC RADIOBUTTON
    SELECTION-SCREEN: END OF LINE.

    SELECTION-SCREEN: BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 18(4) TEXT-023 FOR FIELD rb_vbak.
      SELECTION-SCREEN POSITION 24.
      PARAMETERS: rb_vbak RADIOBUTTON GROUP rg_1.   " VBAK RADIOBUTTON
      SELECTION-SCREEN COMMENT 37(4) TEXT-024 FOR FIELD rb_vbap.
      SELECTION-SCREEN POSITION 43.
      PARAMETERS: rb_vbap RADIOBUTTON GROUP rg_1.   " VBAP RADIOBUTTON
    SELECTION-SCREEN: END OF LINE.

    SELECTION-SCREEN: BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 18(4) TEXT-025 FOR FIELD rb_ekko.
      SELECTION-SCREEN POSITION 24.
      PARAMETERS: rb_ekko RADIOBUTTON GROUP rg_1.   " EKKO RADIOBUTTON
      SELECTION-SCREEN COMMENT 37(4) TEXT-026 FOR FIELD rb_ekpo.
      SELECTION-SCREEN POSITION 43.
      PARAMETERS: rb_ekpo RADIOBUTTON GROUP rg_1.   " EKPO RADIOBUTTON
    SELECTION-SCREEN: END OF LINE.

    PARAMETERS: ch_mara AS CHECKBOX,
                ch_vbak AS CHECKBOX,
                ch_ekko AS CHECKBOX.

  SELECTION-SCREEN: END OF BLOCK b2.

  " FIELDS

  SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-030.
    SELECT-OPTIONS: so_matnr FOR mara-matnr MODIF ID m0.    " Material Number for MARA, MARC, VBAP, EKPO
    SELECT-OPTIONS: so_ersda FOR mara-ersda MODIF ID m1.    " Created On for MARA
    SELECT-OPTIONS: so_werks FOR marc-werks MODIF ID m2.    " Plant for MARC.
    SELECT-OPTIONS: so_vbeln FOR vbak-vbeln MODIF ID m3.    " Sales Doc Number for VBAK & VBAP
    SELECT-OPTIONS: so_auart FOR vbak-auart MODIF ID m4.    " Sales Doc Type for VBAK
    SELECT-OPTIONS: so_ebeln FOR ekko-ebeln MODIF ID m5.    " Purchase Doc Number for EKKO, EKPO
    SELECT-OPTIONS: so_bsart FOR ekko-bsart MODIF ID m6.    " Purchase Doc Type for EKKO
  SELECTION-SCREEN: END OF BLOCK b3.

SELECTION-SCREEN: END OF BLOCK b0.

*------------------------------------------------------------------------------------*
* STRUCTURES, INTERNAL TABLES AND WORK AREAS.
*------------------------------------------------------------------------------------*

TYPES: BEGIN OF ty_mara_marc,           " INNER JOIN OF MARA AND MARC
         matnr TYPE mara-matnr,      " Material Number
         ersda TYPE mara-ersda,      " Created On
         mtart TYPE mara-mtart,      " Material Type
         matkl TYPE mara-matkl,      " Material Group
         werks TYPE marc-werks,      " Plant
         ausdt TYPE marc-ausdt,      " Effective-Out Date
         herbl TYPE marc-herbl,      " State of Manufacture
         " objid     TYPE marc-objid,      " Object ID
       END OF ty_mara_marc,

       BEGIN OF ty_vbak_vbap,            " INNER JOIN OF VBAK AND VBAP
         vbeln TYPE vbak-vbeln,      " Sales Document
         erdat TYPE vbak-erdat,      " Record Created On
         erzet TYPE vbak-erzet,      " Entry Time
         auart TYPE vbak-auart,      " Sales Document Type
         posnr TYPE vbap-posnr,      " Sales Document Item
         bname TYPE vbak-bname,      " Name of orderer
         telf1 TYPE vbak-telf1,      " Telephone Number
         matnr TYPE vbap-matnr,      " Material Number
       END OF ty_vbak_vbap,

       BEGIN OF ty_ekko_ekpo,            " INNER JOIN OF EKKO AND EKPO
         ebeln TYPE ekko-ebeln,      " Sales Document
         matnr TYPE ekpo-matnr,      " Material Number
         bukrs TYPE ekko-bukrs,      " Company Code
         bsart TYPE ekko-bsart,      " Purchase Doc Type
         bstyp TYPE ekko-bstyp,      " Purchase Doc Category
         ebelp TYPE ekpo-ebelp,      " Purchasing Document Number
         aedat TYPE ekpo-aedat,      " Purchasing Document Item Change Date
         txz01 TYPE ekpo-txz01,      " Short Text
       END OF ty_ekko_ekpo,

       BEGIN OF ty_mara,                 " STRUCT OF MARA
         matnr TYPE mara-matnr,      " Material Number
         ersda TYPE mara-ersda,      " Created On
         mtart TYPE mara-mtart,      " Material Type
         matkl TYPE mara-matkl,      " Material Group
         " objid     TYPE marc-objid,      " Object ID
       END OF ty_mara,

       BEGIN OF ty_marc,                 " STRUCT OF MARC
         matnr TYPE marc-matnr,      " Material Number
         werks TYPE marc-werks,      " Plant
         ausdt TYPE marc-ausdt,      " Effective-Out Date
         herbl TYPE marc-herbl,      " State of Manufacture
         " objid     TYPE marc-objid,      " Object ID
       END OF ty_marc,

       BEGIN OF ty_vbak,                 " STRUCT OF VBAK
         vbeln TYPE vbak-vbeln,      " Sales Document
         erdat TYPE vbak-erdat,      " Record Created On
         erzet TYPE vbak-erzet,      " Entry Time
         auart TYPE vbak-auart,      " Sales Document Type
         bname TYPE vbak-bname,      " Name of orderer
         telf1 TYPE vbak-telf1,      " Telephone Number
       END OF ty_vbak,

       BEGIN OF ty_vbap,                 " STRUCT OF VBAP
         vbeln TYPE vbap-vbeln,      " Sales Document
         posnr TYPE vbap-posnr,      " Sales Document Item
         charg TYPE vbap-charg,      " Batch Number
         arktx TYPE vbap-arktx,      " Short Text for sales order item
         matnr TYPE vbap-matnr,      " Material Number
       END OF ty_vbap,

       BEGIN OF ty_ekko,                 " STRUCT OF EKKO
         ebeln TYPE ekko-ebeln,      " Sales Document
         bukrs TYPE ekko-bukrs,      " Company Code
         bsart TYPE ekko-bsart,      " Purchase Doc Type
         bstyp TYPE ekko-bstyp,      " Purchase Doc Category
       END OF ty_ekko,

       BEGIN OF ty_ekpo,                 " STRUCT OF EKPO
         matnr TYPE ekpo-matnr,      " Material Number
         ebeln TYPE ekpo-ebeln,      " Purchasing Document Number
         aedat TYPE ekpo-aedat,      " Purchasing Document Item Change Date
         txz01 TYPE ekpo-txz01,      " Short Text
       END OF ty_ekpo.

*------------------------------------------------------------------------------------*
* DATA DEFINITIONS
*------------------------------------------------------------------------------------*

DATA: it_mara      TYPE TABLE OF ty_mara,
      it_marc      TYPE TABLE OF ty_marc,
      it_vbak      TYPE TABLE OF ty_vbak,
      it_vbap      TYPE TABLE OF ty_vbap,
      it_ekko      TYPE TABLE OF ty_ekko,
      it_ekpo      TYPE TABLE OF ty_ekpo,
      it_mara_marc TYPE TABLE OF ty_mara_marc,
      it_vbak_vbap TYPE TABLE OF ty_vbak_vbap,
      it_ekko_ekpo TYPE TABLE OF ty_ekko_ekpo,

      wa_mara      TYPE ty_mara,
      wa_marc      TYPE ty_marc,
      wa_vbak      TYPE ty_vbak,
      wa_vbap      TYPE ty_vbap,
      wa_ekko      TYPE ty_ekko,
      wa_ekpo      TYPE ty_ekpo,
      wa_mara_marc TYPE ty_mara_marc,
      wa_vbak_vbap TYPE ty_vbak_vbap,
      wa_ekko_ekpo TYPE ty_ekko_ekpo,

      wa_matnr     LIKE LINE OF so_matnr,
      wa_ersda     LIKE LINE OF so_ersda,
      wa_werks     LIKE LINE OF so_werks,
      wa_vbeln     LIKE LINE OF so_vbeln,
      wa_auart     LIKE LINE OF so_auart,
      wa_ebeln     LIKE LINE OF so_ebeln,
      wa_bsart     LIKE LINE OF so_bsart,

      lv_test      TYPE char40,
      lv_date      TYPE dats.

DATA p_rows TYPE int3 VALUE 999.

*------------------------------------------------------------------------------------*
* INITIALIZING
*------------------------------------------------------------------------------------*

INITIALIZATION.

  p_user = sy-uname.
  p_date = sy-datum.
  p_time = sy-uzeit.


*------------------------------------------------------------------------------------*
* OUTPUT SCREEN MODIFICATIONS
*------------------------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    " USER INFORMATION
    IF screen-name = 'P_USER' OR screen-name = 'P_DATE' OR screen-name = 'P_TIME'.
      screen-input = 0.
    ENDIF.

    " FIELDS VISIBILITY
    IF screen-group1 = 'M0' OR screen-group1 = 'M1' OR
       screen-group1 = 'M2' OR screen-group1 = 'M3' OR
       screen-group1 = 'M4' OR screen-group1 = 'M5' OR
       screen-group1 = 'M6'.
      screen-active = 0.
      screen-invisible = 1.
    ENDIF.

    " RADIOBUTTONS FIELD CONNECTIVITY
    IF rb_mara = 'X'.
      IF screen-group1 = 'M0' OR screen-group1 = 'M1'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ELSEIF rb_marc = 'X'.
      IF screen-group1 = 'M0' OR screen-group1 = 'M2'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ELSEIF rb_vbak = 'X'.
      IF screen-group1 = 'M3' OR screen-group1 = 'M4'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ELSEIF rb_vbap = 'X'.
      IF screen-group1 = 'M3' OR screen-group1 = 'M0'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ELSEIF rb_ekko = 'X'.
      IF screen-group1 = 'M5' OR screen-group1 = 'M6'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ELSEIF rb_ekpo = 'X'.
      IF screen-group1 = 'M5' OR screen-group1 = 'M0'.
        screen-active = 1.
        screen-invisible = 0.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.

*------------------------------------------------------------------------------------*
* SELECTION SCREEN VALIDATION.
*------------------------------------------------------------------------------------*

AT SELECTION-SCREEN.

  IF sy-ucomm = 'ONLI'.

    IF rb_mara = 'X' AND ( ch_vbak = 'X' OR ch_ekko = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of MARA & MARC.' TYPE 'E'.
    ELSEIF rb_marc = 'X' AND ( ch_vbak = 'X' OR ch_ekko = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of MARA & MARC.' TYPE 'E'.
    ELSEIF rb_vbak = 'X' AND ( ch_mara = 'X' OR ch_ekko = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of VBAK & VBAP.' TYPE 'E'.
    ELSEIF rb_vbap = 'X' AND ( ch_mara = 'X' OR ch_ekko = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of VBAK & VBAP.' TYPE 'E'.
    ELSEIF rb_ekko = 'X' AND ( ch_mara = 'X' OR ch_vbak = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of EKKO & EKPO.' TYPE 'E'.
    ELSEIF rb_ekpo = 'X' AND ( ch_mara = 'X' OR ch_vbak = 'X' ).
      MESSAGE: 'Please Select Valid CheckBox of EKKO & EKPO.' TYPE 'E'.
    ENDIF.

    " VALIDATION INPUT LOW OF MATNR
    IF rb_mara IS NOT INITIAL OR rb_marc IS NOT INITIAL OR
       rb_vbap IS NOT INITIAL OR rb_ekpo IS NOT INITIAL.
      IF so_matnr IS NOT INITIAL.
        READ TABLE so_matnr INTO wa_matnr.
        SELECT matnr
          FROM mara
          INTO lv_test
          WHERE matnr = wa_matnr-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN MATERIAL NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.
      IF so_matnr IS NOT INITIAL.
        SELECT matnr
          FROM mara
          INTO lv_test
          WHERE matnr = wa_matnr-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN MATERIAL NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    " VALIDATION INPUT LOW OF ERSDA (MARA)
    IF rb_mara IS NOT INITIAL.
      READ TABLE so_ersda INTO wa_ersda.
      IF so_ersda IS NOT INITIAL.
        SELECT ersda
          FROM mara
          INTO lv_date
          WHERE ersda = wa_ersda-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN CREATED ON.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_ersda IS NOT INITIAL.
        SELECT ersda
          FROM mara
          INTO lv_date
          WHERE ersda = wa_ersda-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN CREATED ON.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    " LOW VALUE ERROR FOR WERKS (MARC).
    IF rb_marc IS NOT INITIAL.
      READ TABLE so_werks INTO wa_werks.
      IF so_werks IS NOT INITIAL.
        SELECT werks
          FROM marc
          INTO lv_test
          WHERE werks = wa_werks-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN PLANT.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_werks IS NOT INITIAL.
        SELECT werks
          FROM marc
          INTO lv_test
          WHERE werks = wa_werks-high.
        ENDSELECT.

        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN PLANT.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    " LOW VALUE ERROR FOR VBELN (VBAK and VBAP)
    IF rb_vbak IS NOT INITIAL OR rb_vbap IS NOT INITIAL.
      READ TABLE so_vbeln INTO wa_vbeln.
      IF so_vbeln IS NOT INITIAL.
        SELECT vbeln
          FROM vbak
          INTO lv_test
          WHERE vbeln = wa_vbeln-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN SALES DOCUMENT NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_vbeln IS NOT INITIAL.
        SELECT vbeln
          FROM vbak
          INTO lv_test
          WHERE vbeln = wa_vbeln-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN SALES DOCUMENT NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    " LOW VALUE ERROR FOR AUART (VBAK)
    IF rb_vbak IS NOT INITIAL.
      READ TABLE so_auart INTO wa_auart.
      IF so_auart IS NOT INITIAL.
        SELECT auart
          FROM vbak
          INTO lv_test
          WHERE auart = wa_auart-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN SALES DOCUMENT TYPE.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_auart IS NOT INITIAL.
        SELECT auart
          FROM vbak
          INTO lv_test
          WHERE auart = wa_auart-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN SALES DOCUMENT TYPE.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

    " LOW VALUE ERROR FOR EBELN (EKKO AND EKPO)
    IF rb_ekko IS NOT INITIAL OR rb_ekpo IS NOT INITIAL.
      READ TABLE so_ebeln INTO wa_ebeln.
      IF so_ebeln IS NOT INITIAL.
        SELECT ebeln
          FROM ekko
          INTO lv_test
          WHERE ebeln = wa_ebeln-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN PURCHASING DOCUMENT NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_ebeln IS NOT INITIAL.
        SELECT ebeln
          FROM ekko
          INTO lv_test
          WHERE ebeln = wa_ebeln-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN PURCHASING DOCUMENT NUMBER.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.


    " LOW VALUE ERROR FOR BSART (EKKO)
    IF rb_ekko IS NOT INITIAL.
      READ TABLE so_bsart INTO wa_bsart.
      IF so_bsart IS NOT INITIAL.
        SELECT bsart
          FROM ekko
          INTO lv_test
          WHERE bsart = wa_bsart-low.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'LOW VALUE ERROR IN PURCHASING DOCUMENT TYPE.' TYPE 'E'.
        ENDIF.
      ENDIF.

      IF so_bsart IS NOT INITIAL.
        SELECT bsart
          FROM ekko
          INTO lv_test
          WHERE bsart = wa_bsart-high.
        ENDSELECT.
        IF sy-subrc <> 0.
          MESSAGE: 'HIGH VALUE ERROR IN PURCHASING DOCUMENT TYPE.' TYPE 'E'.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

*------------------------------------------------------------------------------------*
* SELECTION SCREEN LOGIC
*------------------------------------------------------------------------------------*

START-OF-SELECTION.

  WRITE: / 'EXECUTED BY: ', p_user.
  WRITE: / 'EXECUTED ON: ', p_date.
  WRITE: / 'EXECUTED AT: ', p_time .
  WRITE: /.
  ULINE.

  " MARA ONLY
  IF rb_mara = 'X' AND ch_mara = ''.
    " INTERNAL TABLE OF MARA.
    IF so_matnr IS NOT INITIAL OR so_ersda IS NOT INITIAL.
      SELECT matnr ersda mtart matkl
        FROM mara
        INTO CORRESPONDING FIELDS OF TABLE it_mara
        WHERE matnr IN so_matnr AND ersda IN so_ersda.
      WRITE: /36 'MATNR' COLOR 1, '|',
       49 'ERSDA' COLOR 1, '|',
       56 'MTART' COLOR 1, '|',
       68 'MATKL' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_mara INTO wa_mara.
          WRITE: / wa_mara-matnr COLOR 3, '|',
            wa_mara-ersda COLOR 5, '|',
            wa_mara-mtart COLOR 6, '|',
            wa_mara-matkl COLOR 7, '|'.

          CLEAR wa_mara.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " MARA AND CHECKBOX
  ELSEIF rb_mara = 'X' AND ch_mara = 'X'.
    IF so_matnr IS NOT INITIAL OR so_ersda IS NOT INITIAL.
      SELECT mara~matnr mara~ersda mara~mtart mara~matkl marc~werks marc~ausdt marc~herbl
        INTO TABLE it_mara_marc
        FROM mara
        INNER JOIN marc
        ON mara~matnr = marc~matnr
        WHERE mara~matnr IN so_matnr AND mara~ersda IN so_ersda.
      WRITE: / 'MATNR' COLOR 1, '|',
            'ERSDA' COLOR 1, '|',
            'MTART' COLOR 1, '|',
            'MATKL' COLOR 1, '|',
            'WERKS' COLOR 1, '|',
            'AUSDT' COLOR 1, '|',
            'HERBL' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_mara_marc INTO wa_mara_marc.
          WRITE: / wa_mara_marc-matnr COLOR 2, '|',
                  wa_mara_marc-ersda COLOR 3, '|',
                  wa_mara_marc-mtart COLOR 4, '|',
                  wa_mara_marc-matkl COLOR 5, '|',
                  wa_mara_marc-werks COLOR 6, '|',
                  wa_mara_marc-ausdt COLOR 7, '|',
                  wa_mara_marc-herbl COLOR 2, '|'.
          CLEAR wa_mara_marc.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " MARC ONLY
  ELSEIF rb_marc = 'X' AND ch_mara IS INITIAL.
    IF so_matnr IS NOT INITIAL OR so_werks IS NOT INITIAL.
      SELECT matnr werks ausdt herbl
        FROM marc
        INTO CORRESPONDING FIELDS OF TABLE it_marc
        WHERE matnr IN so_matnr AND werks IN so_werks.
      WRITE: /36 'MATNR' COLOR 1, '|',
       43 'WERKS' COLOR 1, '|',
       56 'AUSDT' COLOR 1, '|',
       63 'HERBL' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_marc INTO wa_marc.
          WRITE: / wa_marc-matnr COLOR 3, '|',
            wa_marc-werks COLOR 5, '|',
            wa_marc-ausdt COLOR 6, '|',
            wa_marc-herbl COLOR 7, '|'.

          CLEAR wa_marc.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " MARC AND CHECKBOX
  ELSEIF rb_marc = 'X' AND ch_mara = 'X'.
    IF so_matnr IS NOT INITIAL OR so_werks IS NOT INITIAL.
      SELECT marc~matnr mara~ersda mara~mtart mara~matkl marc~werks marc~ausdt marc~herbl
        INTO TABLE it_mara_marc
        FROM mara
        INNER JOIN marc
        ON mara~matnr = marc~matnr
        WHERE marc~matnr IN so_matnr AND marc~werks IN so_werks.
      WRITE: / 'MATNR' COLOR 1, '|',
            'ERSDA' COLOR 1, '|',
            'MTART' COLOR 1, '|',
            'MATKL' COLOR 1, '|',
            'WERKS' COLOR 1, '|',
            'AUSDT' COLOR 1, '|',
            'HERBL' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_mara_marc INTO wa_mara_marc.
          WRITE: / wa_mara_marc-matnr COLOR 2, '|',
                  wa_mara_marc-ersda COLOR 3, '|',
                  wa_mara_marc-mtart COLOR 4, '|',
                  wa_mara_marc-matkl COLOR 5, '|',
                  wa_mara_marc-werks COLOR 2, '|',
                  wa_mara_marc-ausdt COLOR 6, '|',
                  wa_mara_marc-herbl COLOR 7, '|'.
          CLEAR wa_mara_marc.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " VBAK ONLY
  ELSEIF rb_vbak = 'X' AND ch_vbak IS INITIAL.
    IF so_vbeln IS NOT INITIAL OR so_auart IS NOT INITIAL.
      SELECT vbeln erdat erzet auart bname telf1
        FROM vbak
        INTO CORRESPONDING FIELDS OF TABLE it_vbak
        WHERE vbeln IN so_vbeln AND auart IN so_auart.
      WRITE: /6 'VBELN' COLOR 1, '|',
        'ERDAT' COLOR 1, '|',
        'ERZET' COLOR 1, '|',
        'AUART' COLOR 1, '|',
        'BNAME' COLOR 1, '|',
        'TELF1' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_vbak INTO wa_vbak.
          WRITE: / wa_vbak-vbeln COLOR 3, '|',
            wa_vbak-erdat COLOR 5, '|',
            wa_vbak-erzet COLOR 6, '|',
            wa_vbak-bname COLOR 2, '|',
            wa_vbak-telf1 COLOR 4, '|',
            wa_vbak-auart COLOR 7, '|'.

          CLEAR wa_vbak.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " VBAK AND CHECKBOX
  ELSEIF rb_vbak = 'X' AND ch_vbak = 'X'.
    IF so_vbeln IS NOT INITIAL OR so_auart IS NOT INITIAL.
      SELECT vbak~vbeln vbak~erdat vbak~erzet vbak~auart vbap~posnr vbak~bname vbak~telf1 vbap~matnr
        INTO TABLE it_vbak_vbap
        FROM vbak
        INNER JOIN vbap
        ON vbak~vbeln = vbap~vbeln
        WHERE vbak~vbeln IN so_vbeln AND vbak~auart IN so_auart.
      WRITE: / 'VBELN' COLOR 1, '|',
            'ERDAT' COLOR 1, '|',
            'ERZET' COLOR 1, '|',
            'AUART' COLOR 1, '|',
            'POSNR' COLOR 1, '|',
            'BNAME' COLOR 1, '|',
            'TELF1' COLOR 1, '|',
            'MATNR' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_vbak_vbap INTO wa_vbak_vbap.
          WRITE: / wa_vbak_vbap-vbeln COLOR 2, '|',
                  wa_vbak_vbap-erdat COLOR 3, '|',
                  wa_vbak_vbap-erzet COLOR 4, '|',
                  wa_vbak_vbap-auart COLOR 5, '|',
                  wa_vbak_vbap-posnr COLOR 6, '|',
                  wa_vbak_vbap-bname COLOR 7, '|',
                  wa_vbak_vbap-telf1 COLOR 2, '|',
                  wa_vbak_vbap-matnr COLOR 3, '|'.
          CLEAR wa_vbak_vbap.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " VBAP ONLY
  ELSEIF rb_vbap = 'X' AND ch_vbak IS INITIAL.
    IF so_vbeln IS NOT INITIAL OR so_matnr IS NOT INITIAL.
      SELECT vbeln posnr charg arktx matnr
        FROM vbap
        INTO CORRESPONDING FIELDS OF TABLE it_vbap
        WHERE vbeln IN so_vbeln AND matnr IN so_matnr.
      WRITE: / 'VBELN' COLOR 1, '|',
        'POSNR' COLOR 1, '|',
        'CHARG' COLOR 1, '|',
        'ARKTX' COLOR 1, '|',
        'MATNR' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_vbap INTO wa_vbap.
          WRITE: / wa_vbap-vbeln COLOR 3, '|',
            wa_vbap-posnr COLOR 5, '|',
            wa_vbap-charg COLOR 6, '|',
            wa_vbap-arktx COLOR 7, '|',
            wa_vbap-matnr COLOR 4, '|'.

          CLEAR wa_vbap.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " VBAP AND CHECKBOX
  ELSEIF rb_vbap = 'X' AND ch_vbak = 'X'.
    IF so_vbeln IS NOT INITIAL OR so_matnr IS NOT INITIAL.
      SELECT vbak~vbeln vbak~erdat vbak~erzet vbak~auart vbap~posnr vbak~bname vbak~telf1 vbap~matnr
        INTO TABLE it_vbak_vbap
        FROM vbak
        INNER JOIN vbap
        ON vbak~vbeln = vbap~vbeln
        WHERE vbak~vbeln IN so_vbeln AND vbap~matnr IN so_matnr.
      WRITE: / 'VBELN' COLOR 1, '|',
            'ERDAT' COLOR 1, '|',
            'ERZET' COLOR 1, '|',
            'AUART' COLOR 1, '|',
            'POSNR' COLOR 1, '|',
            'BNAME' COLOR 1, '|',
            'TELF1' COLOR 1, '|',
            'MATNR' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_vbak_vbap INTO wa_vbak_vbap.
          WRITE: / wa_vbak_vbap-vbeln COLOR 2, '|',
                  wa_vbak_vbap-erdat COLOR 3, '|',
                  wa_vbak_vbap-erzet COLOR 4, '|',
                  wa_vbak_vbap-auart COLOR 5, '|',
                  wa_vbak_vbap-posnr COLOR 6, '|',
                  wa_vbak_vbap-bname COLOR 7, '|',
                  wa_vbak_vbap-telf1 COLOR 2, '|',
                  wa_vbak_vbap-matnr COLOR 3, '|'.
          CLEAR wa_vbak_vbap.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " EKKO ONLY
  ELSEIF rb_ekko = 'X' AND ch_ekko IS INITIAL.
    IF so_ebeln IS NOT INITIAL OR so_bsart IS NOT INITIAL.
      SELECT ebeln bukrs bsart bstyp
        FROM ekko
        INTO CORRESPONDING FIELDS OF TABLE it_ekko
        WHERE ebeln IN so_ebeln AND bsart IN so_bsart.
      WRITE: / 'EBELN' COLOR 1, '|',
        'BUKRS' COLOR 1, '|',
        'BSART' COLOR 1, '|',
        'BSTYP' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_ekko INTO wa_ekko.
          WRITE: / wa_ekko-ebeln COLOR 3, '|',
            wa_ekko-bukrs COLOR 5, '|',
            wa_ekko-bsart COLOR 6, '|',
            wa_ekko-bstyp COLOR 7, '|'.

          CLEAR wa_ekko.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " EKKO AND CHECKBOX
  ELSEIF rb_ekko = 'X' AND ch_ekko = 'X'.
    IF so_ebeln IS NOT INITIAL OR so_bsart IS NOT INITIAL.
      SELECT ekko~ebeln ekpo~matnr ekko~bukrs ekko~bsart ekko~bstyp ekpo~ebelp ekpo~aedat ekpo~txz01
        INTO TABLE it_ekko_ekpo
        FROM ekko
        INNER JOIN ekpo
        ON ekko~ebeln = ekpo~ebeln
        WHERE ekko~ebeln IN so_ebeln AND ekko~bsart IN so_bsart.
      WRITE: / 'EBELN' COLOR 1, '|',
            'MATNR' COLOR 1, '|',
            'BUKRS' COLOR 1, '|',
            'BSART' COLOR 1, '|',
            'BSTYP' COLOR 1, '|',
            'EBELP' COLOR 1, '|',
            'AEDAT' COLOR 1, '|',
            'TXZ01' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_ekko_ekpo INTO wa_ekko_ekpo.
          WRITE: / wa_ekko_ekpo-ebeln COLOR 2, '|',
                  wa_ekko_ekpo-matnr COLOR 3, '|',
                  wa_ekko_ekpo-bukrs COLOR 4, '|',
                  wa_ekko_ekpo-bsart COLOR 5, '|',
                  wa_ekko_ekpo-bstyp COLOR 6, '|',
                  wa_ekko_ekpo-ebelp COLOR 7, '|',
                  wa_ekko_ekpo-aedat COLOR 2, '|',
                  wa_ekko_ekpo-txz01 COLOR 3, '|'.
          CLEAR wa_ekko_ekpo.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  " EKPO ONLY
  ELSEIF rb_ekpo = 'X' AND ch_ekko IS INITIAL.
    IF so_ebeln IS NOT INITIAL OR so_matnr IS NOT INITIAL.
      SELECT matnr ebeln aedat txz01
        FROM ekpo
        INTO CORRESPONDING FIELDS OF TABLE it_ekpo
        WHERE ebeln IN so_ebeln AND matnr IN so_matnr.
      WRITE: / 'MATNR' COLOR 1, '|',
        'EBELN' COLOR 1, '|',
        'AEDAT' COLOR 1, '|',
        'TXZ01' COLOR 1, '|'.
      ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_ekpo INTO wa_ekpo.
          WRITE: / wa_ekpo-matnr COLOR 3, '|',
            wa_ekpo-ebeln COLOR 5, '|',
            wa_ekpo-aedat COLOR 6, '|',
            wa_ekpo-txz01 COLOR 7, '|'.

          CLEAR wa_ekpo.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.


  " EKPO AND CHECKBOX
  ELSEIF rb_ekpo = 'X' AND ch_ekko = 'X'.
    IF so_ebeln IS NOT INITIAL OR so_matnr IS NOT INITIAL.
      SELECT ekko~ebeln ekpo~matnr ekko~bukrs ekko~bsart ekko~bstyp ekpo~ebelp ekpo~aedat ekpo~txz01
        INTO TABLE it_ekko_ekpo
        FROM ekko
        INNER JOIN ekpo
        ON ekko~ebeln = ekpo~ebeln
        WHERE ekko~ebeln IN so_ebeln AND ekpo~matnr IN so_matnr.
      WRITE: / 'EBELN' COLOR 1, '|',
            'MATNR' COLOR 1, '|',
            'BUKRS' COLOR 1, '|',
            'BSART' COLOR 1, '|',
            'BSTYP' COLOR 1, '|',
            'EBELP' COLOR 1, '|',
            'AEDAT' COLOR 1, '|',
            'TXZ01' COLOR 1, '|'.
      ULINE.
      IF sy-subrc IS INITIAL.
        LOOP AT it_ekko_ekpo INTO wa_ekko_ekpo.
          WRITE: / wa_ekko_ekpo-ebeln COLOR 2, '|',
                  wa_ekko_ekpo-matnr COLOR 3, '|',
                  wa_ekko_ekpo-bukrs COLOR 4, '|',
                  wa_ekko_ekpo-bsart COLOR 5, '|',
                  wa_ekko_ekpo-bstyp COLOR 6, '|',
                  wa_ekko_ekpo-ebelp COLOR 7, '|',
                  wa_ekko_ekpo-aedat COLOR 2, '|',
                  wa_ekko_ekpo-txz01 COLOR 3, '|'.
          CLEAR wa_ekko_ekpo.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDIF.