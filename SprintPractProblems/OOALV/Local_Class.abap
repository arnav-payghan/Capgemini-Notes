*&---------------------------------------------------------------------*
*& Include          Z34_PRACT_OOALV_C
*&---------------------------------------------------------------------*

" Main Class Declaration
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS: fetch_data,
      display_data.
ENDCLASS.

" Main Class Implementation
CLASS lcl_main IMPLEMENTATION.
  METHOD fetch_data.
    SELECT mara~matnr, " material number
           marc~werks, " plant
           makt~maktx " material description
      FROM mara
      INNER JOIN marc ON mara~matnr = marc~matnr
      INNER JOIN makt ON mara~matnr = makt~matnr
      WHERE mara~matnr IN @so_matnr AND makt~spras = @sy-langu
      INTO TABLE @lt_temp.
  ENDMETHOD.

  METHOD display_data.
    IF go_container IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name              = 'CC_ALV'                 " Name of the Screen CustCtrl Name to Link Container To
        EXCEPTIONS
          cntl_error                  = 1                " CNTL_ERROR
          cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
          create_error                = 3                " CREATE_ERROR
          lifetime_error              = 4                " LIFETIME_ERROR
          lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
          OTHERS                      = 6.
      IF sy-subrc <> 0.
        MESSAGE: 'Error in Container Instantiation.' TYPE 'E'.
      ENDIF.
    ENDIF.
    CHECK go_container IS NOT INITIAL.

    IF go_grid IS INITIAL.
      CREATE OBJECT go_grid
        EXPORTING
          i_parent          = go_container                 " Parent Container
        EXCEPTIONS
          error_cntl_create = 1                " Error when creating the control
          error_cntl_init   = 2                " Error While Initializing Control
          error_cntl_link   = 3                " Error While Linking Control
          error_dp_create   = 4                " Error While Creating DataProvider Control
          OTHERS            = 5.
      IF sy-subrc <> 0.
        MESSAGE: 'Error in Grid Instantiation.' TYPE 'E'.
      ENDIF.
    ENDIF.
    CHECK go_grid IS NOT INITIAL.

    gs_layout-zebra = abap_true.

    " Display Data
    go_grid->set_table_for_first_display(
      EXPORTING
        i_structure_name              = 'Z34TY_TEMPDATA'                 " Internal Output Table Structure Name
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = lt_temp[]                 " Output Table
      EXCEPTIONS
        invalid_parameter_combination = 1                " Wrong Parameter
        program_error                 = 2                " Program Errors
        too_many_lines                = 3                " Too many Rows in Ready for Input Grid
        OTHERS                        = 4
    ).
    IF sy-subrc <> 0.
      MESSAGE: 'Error in Table Display.' TYPE 'E'.
    ENDIF.


  ENDMETHOD.
ENDCLASS.

DATA: obj TYPE REF TO lcl_main.
