*&---------------------------------------------------------------------*
*& Report ZASSIGN3_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zassign3_34.

* SELECTION SCREEN AND ITS USER-INTERFACE.
SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-100.
  TABLES: vbap, vbak, kna1.

  " Selection of Requirement.
  SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-010.
    PARAMETERS: rb_sales RADIOBUTTON GROUP rg_1. " RadioButton for Sales Document.
    PARAMETERS: rb_cust RADIOBUTTON GROUP rg_1.  " RadioButton for Customer Sales Document.
  SELECTION-SCREEN: END OF BLOCK b1.

  " Number of Rows Required.
  SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-020.
    SELECT-OPTIONS so_sales FOR vbap-vbeln.   " Range selection of sales document number.
    SELECT-OPTIONS so_cust FOR kna1-kunnr.   " Range selection of customer id.
  SELECTION-SCREEN: END OF BLOCK b2.

  "
  SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-030.
    PARAMETERS: p_rows TYPE char10.   " Number of rows selection.
  SELECTION-SCREEN: END OF BLOCK b3.

SELECTION-SCREEN: END OF BLOCK b0.

* DATA DEFINITIONS
TYPES: BEGIN OF ty_sales,
         vbeln TYPE vbak-vbeln,  " Sales Document (Primary Key)
         kunnr TYPE vbak-kunnr,  " Customer ID
         erdat TYPE vbak-erdat,  " Created data on
         bnddt TYPE vbak-bnddt,  " Date until which bid/quotation is binding (valid-to-date)
         auart TYPE vbak-auart,  " Sales Document Type
         posnr TYPE vbap-posnr,  " Sales Document Item
         matnr TYPE vbap-matnr,  " Material Number
         matkl TYPE vbap-matkl,  " Material Group
         arktx TYPE vbap-arktx,  " Short Text
       END OF ty_sales,

       BEGIN OF ty_cust,
         kunnr TYPE kna1-kunnr,  " Customer ID
         name1 TYPE kna1-name1,  " Name 1
         name2 TYPE kna1-name2,  " Name 2
         land1 TYPE kna1-land1,  " Region/country key
         regio TYPE kna1-regio,  " Region (State, Province, etc)
         stras TYPE kna1-stras,  " Street Address
         telf1 TYPE kna1-telf1,  " Telephone
         telfx TYPE kna1-telfx,  " Fax Number
       END OF ty_cust.


DATA: it_vbap_vbak TYPE TABLE OF ty_sales,
      wa_vbap_vbak TYPE ty_sales.



* INITIALIZATIONS IF REQUIRED.
INITIALIZATION.


* VALIDATION USING AT-SCREEN-SELECTION.
AT SELECTION-SCREEN.

  " Number of Rows Validation.
  IF rb_sales = 'X'.
    IF p_rows IS INITIAL AND so_sales IS INITIAL.
      MESSAGE: 'Please Select the Number of Rows.' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF rb_cust = 'X'.
    IF p_rows IS INITIAL AND so_cust IS INITIAL.
      MESSAGE: 'Please Select the Number of Rows.' TYPE 'E'.
    ENDIF.
  ENDIF.



* BEGIN OF OUTPUT LOGIC.
START-OF-SELECTION.

  IF rb_sales = 'X'.
    IF p_rows IS NOT INITIAL AND so_sales IS INITIAL.
      SELECT vbak~vbeln
        vbak~kunnr
        vbak~erdat
        vbak~bnddt
        vbak~auart
        vbap~posnr
        vbap~matnr
        vbap~matkl
        vbap~arktx
        INTO TABLE it_vbap_vbak UP TO p_rows ROWS
        FROM vbak
        INNER JOIN vbap
          ON vbak~vbeln = vbap~vbeln.
        WRITE: /6 'VBELN' COLOR 1, '|',
          19 'KUNNR' COLOR 1, '|',
          32 'ERDAT' COLOR 1, '|',
          45 'BNDDT' COLOR 1, '|',
          52 'AUART' COLOR 1, '|',
          61 'POSNR' COLOR 1, '|',
          104 'MATNR' COLOR 1, '|',
          116 'MATKL' COLOR 1, '|',
          159 'ARKTX' COLOR 1, '|'.
        ULINE.

      IF sy-subrc IS INITIAL.
        LOOP AT it_vbap_vbak INTO wa_vbap_vbak.
          WRITE: / wa_vbap_vbak-vbeln, '|',
            wa_vbap_vbak-kunnr, '|',
            wa_vbap_vbak-erdat, '|',
            wa_vbap_vbak-bnddt, '|',
            wa_vbap_vbak-auart, '|',
            wa_vbap_vbak-posnr, '|',
            wa_vbap_vbak-matnr, '|',
            wa_vbap_vbak-matkl, '|',
            wa_vbap_vbak-arktx, '|'.

          CLEAR wa_vbap_vbak.
          ULINE.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.