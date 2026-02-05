```
FUNCTION z_34hp_ci_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      FINAL_TABLE TYPE  Z34_HP_CI_TT_MARA_MARD
*"      SO_MATNR TYPE  Z34_HP_CI_TT_SO
*"----------------------------------------------------------------------

  SELECT a~matnr
         a~ernam
         a~laeda
         a~aenam
         a~vpsta
         a~pstat
         a~lvorm
         a~kunnr
         b~werks
         b~lgort
    INTO TABLE final_table
    FROM mara AS a
    INNER JOIN mard AS b
    ON b~matnr = a~matnr
    WHERE a~matnr IN so_matnr.

ENDFUNCTION.
```