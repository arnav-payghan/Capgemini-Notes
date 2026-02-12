```
*&---------------------------------------------------------------------*
*& Include          Z34_FEB10_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form validate
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM validate.

  " Check for Personnel Number Input Data by User.
  IF s_pernr IS NOT INITIAL.
    SELECT pernr
      FROM z34_org
      INTO gv_check
      WHERE pernr IN s_pernr.
    ENDSELECT.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE: e001(zmc_feb9_34).
    ENDIF.
  ENDIF.

  " Check for End Date Input Data by User.
  IF s_endda IS NOT INITIAL.
    SELECT endda
      FROM z34_org
      INTO gv_datecheck
      WHERE endda IN s_endda.
    ENDSELECT.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE: e002(zmc_feb9_34).
    ENDIF.
  ENDIF.

  " Check for Begin Date Input Data by User.
  IF s_begda IS NOT INITIAL.
    SELECT begda
      FROM z34_org
      INTO gv_datecheck
      WHERE begda IN s_begda.
    ENDSELECT.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE: e003(zmc_feb9_34).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fetch_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_data .
  CALL FUNCTION 'ZFM34_FETCH_DATA'
    EXPORTING
      iv_s_pernr    = s_pernr[]
      iv_s_endda    = s_endda[]
      iv_s_begda    = s_begda[]
      iv_rb_org     = p_rb_org
      iv_rb_per     = p_rb_per
      iv_rb_emp     = p_rb_emp
    IMPORTING
      et_34org      = git_org[]
      et_34prd      = git_prd[]
      et_34adr      = git_adr[]
      et_34egrp     = git_egrp[]
      et_34subegrp  = git_subegrp[]
      et_34employee = git_employee[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_ci_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_ci_data .
  IF p_rb_org IS NOT INITIAL.
    " HEADERS
    WRITE: /  'PERNR' COLOR 1 , 10 '|',
           12 'ENDDA' COLOR 1 , 25 '|',
           27 'BEGDA' COLOR 1 , 40 '|',
           42 'WERKS' COLOR 1 , 55 '|',
           57 'PERSG' COLOR 1 , 70 '|',
           72 'PERSK' COLOR 1 , 85 '|',
           87 'VDSK1' COLOR 1 , 110'|',
          112 'GSBER' COLOR 1 , 125 '|'.
    ULINE.
    LOOP AT git_org INTO gwa_org.
      WRITE: / gwa_org-pernr UNDER 'PERNR' HOTSPOT, 10 '|',
               gwa_org-endda UNDER 'ENDDA', 25 '|',
               gwa_org-begda UNDER 'BEGDA', 40 '|',
               gwa_org-werks UNDER 'WERKS', 55 '|',
               gwa_org-persg UNDER 'PERSG', 70 '|',
               gwa_org-persk UNDER 'PERSK', 85 '|',
               gwa_org-vdsk1 UNDER 'VDSK1', 110'|',
               gwa_org-gsber UNDER 'GSBER', 125 '|'.
      CLEAR gwa_org.
      ULINE.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_subroutine
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_subroutine USING fname   TYPE char8
                          tname   TYPE char8
                          seltext TYPE char40.

  gs_fieldcat-fieldname = fname.
  gs_fieldcat-tabname   = tname.
  gs_fieldcat-seltext_m = seltext.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_data .
  IF p_rb_org IS NOT INITIAL.
    " LIST ALV
    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
        i_structure_name = 'ZSC34_ORG'
      TABLES
        t_outtab         = git_org.

    " GRID ALV
*    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*      EXPORTING
*        i_structure_name = 'ZSC34_ORG'
*      TABLES
*        t_outtab         = git_org.

    " Blocked ALV
*    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
*      EXPORTING
*        i_callback_program = sy-repid.
*
*    PERFORM alv_subroutine USING 'PERNR' 'GIT_ORG' 'Personnel Number.'.
*    PERFORM alv_subroutine USING 'ENDDA' 'GIT_ORG' 'End Date.'.
*    PERFORM alv_subroutine USING 'BEGDA' 'GIT_ORG' 'Begin Date.'.
*    PERFORM alv_subroutine USING 'WERKS' 'GIT_ORG' 'Work Area.'.
*    PERFORM alv_subroutine USING 'PERSG' 'GIT_ORG' 'Employee SubGroup.'.
*    PERFORM alv_subroutine USING 'PERSK' 'GIT_ORG' 'Employee Group.'.
*    PERFORM alv_subroutine USING 'VDSK1' 'GIT_ORG' 'Location.'.
*    PERFORM alv_subroutine USING 'GSBER' 'GIT_ORG' 'GSBER.'.
*
*    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND' " ORG
*      EXPORTING
*        is_layout          = gs_layout
*        it_fieldcat        = gt_fieldcat
*        it_events          = it_event1
*        i_tabname          = 'GIT_ORG'
*      TABLES
*        t_outtab           = git_org
*      EXCEPTIONS
*        program_error      = 1
*        OTHERS             = 2.
*
*    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND' " PRD
*      EXPORTING
*        is_layout          = gs_layout
*        it_fieldcat        = gt_fieldcat
*        it_events          = it_event1
*        i_tabname          = 'GIT_ORG'
*      TABLES
*        t_outtab           = git_org
*      EXCEPTIONS
*        program_error      = 1
*        OTHERS             = 2.
*
*    CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'.

    " Hierarchial ALV
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ci_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ci_screen .
  GET CURSOR FIELD gname VALUE gval.

  IF gname = 'GWA_ORG-PERNR'.
    IF sy-subrc IS INITIAL.
      SELECT pernr
             endda
             begda
             werks
             persg
             persk
             vdsk1
        FROM z34_org
        INTO TABLE git_org
        WHERE pernr = gval.
      " HEADERS
      WRITE: /  'PERNR' COLOR 1 , 10 '|',
             12 'ENDDA' COLOR 1 , 25 '|',
             27 'BEGDA' COLOR 1 , 40 '|',
             42 'WERKS' COLOR 1 , 55 '|',
             57 'PERSG' COLOR 1 , 70 '|',
             72 'PERSK' COLOR 1 , 85 '|',
             87 'VDSK1' COLOR 1 , 110'|'.
      ULINE.
      LOOP AT git_org INTO gwa_org.
        WRITE: / gwa_org-pernr UNDER 'PERNR', 10 '|',
                 gwa_org-endda UNDER 'ENDDA', 25 '|',
                 gwa_org-begda UNDER 'BEGDA', 40 '|',
                 gwa_org-werks UNDER 'WERKS', 55 '|',
                 gwa_org-persg UNDER 'PERSG', 70 '|',
                 gwa_org-persk UNDER 'PERSK', 85 '|',
                 gwa_org-vdsk1 UNDER 'VDSK1', 110'|'.
        CLEAR gwa_org.
        ULINE.
      ENDLOOP.
    ELSE.
      MESSAGE: 'query issue.' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
```
