```
*&---------------------------------------------------------------------*
*& Report ZRP_CALC_CHECK_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRP_CALC_CHECK_34.

DATA: p_result(8) TYPE c,
      validate_i TYPE i.

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE text-100.

  SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-010.
    PARAMETERS: p_num1 TYPE char4 OBLIGATORY.
    PARAMETERS: p_num2 TYPE char4 OBLIGATORY.
    PARAMETERS: p_date TYPE datum.
  SELECTION-SCREEN: END OF BLOCK b1.


  SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE text-020.
    SELECTION-SCREEN: BEGIN OF LINE.
      SELECTION-SCREEN: POSITION 21.
      PARAMETERS: p_check1 AS CHECKBOX.
      SELECTION-SCREEN: COMMENT 23(10) text-021 FOR FIELD p_check1.

      SELECTION-SCREEN: POSITION 35.
      PARAMETERS: p_check3 AS CHECKBOX.
      SELECTION-SCREEN: COMMENT 51(10) text-023 FOR FIELD p_check3.
    SELECTION-SCREEN: END OF LINE.

    SELECTION-SCREEN: BEGIN OF LINE.
      SELECTION-SCREEN: POSITION 21.
      PARAMETERS: p_check2 AS CHECKBOX.
      SELECTION-SCREEN: COMMENT 23(10) text-022 FOR FIELD p_check2.

      SELECTION-SCREEN: POSITION 35.
      PARAMETERS: p_check4 AS CHECKBOX.
      SELECTION-SCREEN: COMMENT 51(10) text-024 FOR FIELD p_check4.
    SELECTION-SCREEN: END OF LINE.
  SELECTION-SCREEN: END OF BLOCK b2.

SELECTION-SCREEN: END OF BLOCK b0.

INITIALIZATION.
  p_date = sy-datum.

AT SELECTION-SCREEN.
  IF p_num1 NA '0123456789' AND p_num2 NA '0123456789'.
    MESSAGE 'Input should be of type numeric only.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.

  IF p_check1 = 'X'.
    p_result = p_num1 + p_num2.
    WRITE: / 'Addition of them is : ', p_result.
  ENDIF.

  IF p_check2 = 'X'.
    IF p_num1 > p_num2.
      p_result = p_num1 - p_num2.
      WRITE: / 'Subtraction num1-num2 them is : ', p_result.
    ELSE.
      p_result = p_num2 - p_num1.
      WRITE: / 'Subtraction of num2-num1 is : ', p_result.
    ENDIF.
  ENDIF.

  IF p_check3 = 'X'.
    IF p_num1 = 0 OR p_num2 = 0.
      MESSAGE 'Exception0: Multiplication by 0 is Not Allowed.' TYPE 'E'.
    ELSE.
      p_result = p_num1 * p_num2.
      WRITE: / 'Multiplication of them is : ', p_result.
    ENDIF.
  ENDIF.

  IF p_check4 = 'X'.
    IF p_num1 = 0 OR p_num2 = 0.
      MESSAGE 'Exception0: Division by 0 is Not Allowed.' TYPE 'E'.
    ELSE.
      p_result = p_num1 / p_num2.
      WRITE: / 'Division of them is : ', p_result.
    ENDIF.
  ENDIF.
```