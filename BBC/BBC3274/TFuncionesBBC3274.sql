/*
  2(CF): CF_CORRESPONDENT
  4(CF): CF_CURRENCY
  6(CF): CF_BRANCH
  8(CF): CF_ACCOUNTING_ACCOUNTS
  11(CF):Q_historicos_creditos.CF_DESCRIPTION_4
  12(BD): Q_historicos_creditos.detail_hist_cr 
  13(BD): Q_historicos_cebitos.TXN_ENTRY_DATE
  14(BD): Q_historicos_creditos.DOCUMENT_NBR
  15(BD): Q_hisotricos_creditos.
  16(SUMA)
  17(CF): Q_historicos.debitos.CF_DESCRIPTION_2
  18(BD): Q_historicos_debitos.detail_hist_db
  19(BD): Q_historicos_debitos.TXN_ENTRY_DATE
  20(BD): Q_historicos_debitos.DOCUMENT_NBR
  21(BD): Q_historicos_debitos.AMOUNT
  22(SUMA)
  23(CF): CF_ACCORDING_BANK
  24(CF): CF_BOOKS_BALANCE
  25(BD): Q_extractos_creditos.DESCRIPTION
  26(BD): Q_extractos_creditos.statement_date_cr
  27(BD): Q_extractos_creditos.DOCUMENT_NBR
  28(BD): Q_extractos_creditos.AMOUNT
  29(SUMA)
  30(BD): Q_cr_dif_conciliacion.detail_cr_dif
  31(BD): Q_cr_dif_conciliacion.TXN_ENTRY_DATE
  32(BD): Q_cr_dif_conciliacion.DOCUMENT_NBR
  33(BD): Q_cr_dif_conciliacion.AMOUNT
  34(SUMA)
  35(BD): Q_extractos_debitos.DESCRIPTION
  36(BD): Q_db_dif_conciliacion.date_db_dif
  37(BD): Q_extractos_debitos.doc_nbr_db_dif
  38(BD): Q_extractos_debitos.amount_db_dif
  39(SUMA)
  41(CF): CF_ACCOUNTING_BALANCE
  42(CF): CF_BANK_DIFFERENCE
  43(CF): CF_USER
*/


-- Functions:

-- F_desc_corresponsal1
-- CF_corresponsal
-- Parameters:
--   1. :p_codigo_CORRESPONSAL AS :p_correspondent_code - Correspondent branch code filter
FUNCTION CF_CORRESPONDENT RETURN VARCHAR2 IS
  lv_bank    VARCHAR2(80);
BEGIN
  SELECT BRANCH_NAME
    INTO lv_bank
    FROM MG_BRANCHES_GENERAL
   WHERE BRANCH_CODE = :p_correspondent_code;

  RETURN(lv_bank);

  RETURN NULL;
EXCEPTION 
  WHEN OTHERS THEN
    RETURN NULL;
END;


-- F_moneda1
-- CF_moneda:
-- Parameters:
--   1. :P_codigo_MONEDA AS :p_currency_code - Currency code filter
FUNCTION CF_CURRENCY RETURN VARCHAR2 IS
  lv_currencies VARCHAR2(30);
BEGIN
  BEGIN
    SELECT DESCRIPTION
      INTO lv_currencies
      FROM MG_CURRENCY
     WHERE CURRENCY_CODE = :p_currency_code;
  EXCEPTION 
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  
  RETURN(lv_currencies);
END;


-- F_agencia
-- CF_AGENCIA:
-- Parameters:
--   1. :cf_conciliacion_global AS :cf_global_reconciliation - Global reconciliation flag
--   2. :p_codigo_agencia AS :p_branch_code - Branch code
--   3. :cp_agencia_conciliacion AS :cp_reconciliation_branch - Reconciliation branch code
FUNCTION CF_BRANCH RETURN CHAR IS
  lv_branch_name VARCHAR2(40) := NULL;
  ln_branch      NUMBER;
BEGIN
  IF nvl(:cf_global_reconciliation, 'N') = 'N' THEN
    ln_branch := :p_branch_code;
  ELSE
    ln_branch := :cp_reconciliation_branch;
  END IF;

  SELECT BRANCH_NAME 
    INTO lv_branch_name
    FROM MG_BRANCHES_GENERAL
   WHERE BRANCH_CODE = ln_branch;
   
  RETURN(lv_branch_name);
EXCEPTION
  WHEN no_data_found THEN
    RETURN(lv_branch_name);
END;


-- F_numero_cuenta2
-- CF_CUENTAS_CONT:
-- Parameters:
--   1. :cf_conciliacion_global AS :cf_global_reconciliation - Global reconciliation flag
--   2. :p_codigo_agencia AS :p_branch_code - Branch code
--   3. :cp_agencia_conciliacion AS :cp_reconciliation_branch - Reconciliation branch code
--   4. :p_empresa AS :p_company - Company code
--   5. :P_codigo_corresponsal AS :p_correspondent_code - Correspondent branch code
--   6. :P_codigo_moneda AS :p_currency_code - Currency code
--   7. :P_numero_cuenta AS :p_account_nbr - Account number
FUNCTION CF_ACCOUNTING_ACCOUNTS RETURN VARCHAR2 IS
  lv_format  VARCHAR2(39);
  lv_level_1 VARCHAR2(4);
  lv_level_2 VARCHAR2(4);
  lv_level_3 VARCHAR2(4);
  lv_level_4 VARCHAR2(4);
  lv_level_5 VARCHAR2(4);
  lv_level_6 VARCHAR2(4);
  lv_level_7 VARCHAR2(4);
  lv_level_8 VARCHAR2(4);
  ln_branch  NUMBER;
BEGIN
  IF nvl(:cf_global_reconciliation, 'N') = 'N' THEN
    ln_branch := :p_branch_code;
  ELSE
    ln_branch := :cp_reconciliation_branch;
  END IF;

  BEGIN
    SELECT a.ACCOUNT_LEVEL_1,
           a.ACCOUNT_LEVEL_2,
           a.ACCOUNT_LEVEL_3,
           a.ACCOUNT_LEVEL_4,
           a.ACCOUNT_LEVEL_5,
           a.ACCOUNT_LEVEL_6,
           a.ACCOUNT_LEVEL_7,
           a.ACCOUNT_LEVEL_8
      INTO lv_level_1,
           lv_level_2,
           lv_level_3,
           lv_level_4,
           lv_level_5,
           lv_level_6,
           lv_level_7,
           lv_level_8
      FROM BC_CORRESPONDENT_BALANCES a
     WHERE a.COMPANY_CODE              = :p_company
       AND a.BRANCH_CODE               = ln_branch
       AND a.CORRESPONDENT_BRANCH_CODE = :p_correspondent_code 
       AND a.CURRENCY_CODE             = :p_currency_code
       AND a.ACCOUNT_NBR               = :p_account_nbr 
       AND a.BALANCE_TYPE              = 1;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN('Does not exist');
  END;
 
  GM_P_DESPLEGAR_R(
    lv_level_1, lv_level_2, lv_level_3,
    lv_level_4, lv_level_5, lv_level_6,
    lv_level_7, lv_level_8, :p_company, lv_format);
    
  RETURN(lv_format);  
END;


-- F_descripcion4
-- cf_desc_cpto_cr
-- Parameters:
--   1. :apl_cr AS :apl_cr - Credit application code
--   2. :trn_cr AS :trn_cr - Credit transaction type code
FUNCTION CF_DESCRIPTION_4 RETURN VARCHAR2 IS
  ln_description VARCHAR2(100) := NULL;
BEGIN
  SELECT DESCRIPTION
    INTO ln_description
    FROM MG_TRANSACTION_TYPES
   WHERE APPLICATION_CODE       = :apl_cr
     AND TXN_TYPE_CODE          = :trn_cr;

  RETURN(ln_description);
END;


-- F_descripcion2
-- cf_desc_cpto_db
-- Parameters:
--   1. :apl_db AS :apl_db - Debit application code
--   2. :trn_db AS :trn_db - Debit transaction type code
FUNCTION CF_DESCRIPTION_2 RETURN VARCHAR2 IS
  ln_description VARCHAR2(100) := NULL;
BEGIN
  SELECT DESCRIPTION
    INTO ln_description
    FROM MG_TRANSACTION_TYPES
   WHERE APPLICATION_CODE       = :apl_db
     AND TXN_TYPE_CODE          = :trn_db;

  RETURN(ln_description);
END;


-- F_segunbanco
-- CF_segun_banco
-- Parameters:
--   1. :cp_saldo_final AS :cp_final_balance - Final balance
--   2. :cs_hist_credito AS :cs_hist_credit - Historical credit
--   3. :cs_hist_debito AS :cs_hist_debit - Historical debit
FUNCTION CF_ACCORDING_BANK RETURN NUMBER IS
  ln_balance NUMBER;
BEGIN
  ln_balance := 0;
  ln_balance := nvl(:cp_final_balance, 0) + 
                nvl(:cs_hist_credit, 0) + 
                nvl(:cs_hist_debit, 0);
                -- + nvl(:cs_mon_db_dif, 0) + nvl(:cs_mon_cr_dif, 0);
  RETURN(ln_balance);
END;


-- F_saldo_final1
-- CF_saldoslibros:
-- Parameters:
--   1. :cf_conciliacion_global AS :cf_global_reconciliation - Global reconciliation flag
--   2. :p_numero_cuenta AS :p_account_nbr - Account number
--   3. :p_codigo_agencia AS :p_branch_code - Branch code
--   4. :p_codigo_corresponsal AS :p_correspondent_code - Correspondent branch code
--   5. :p_codigo_moneda AS :p_currency_code - Currency code
--   6. :p_empresa AS :p_company - Company code
--   7. :p_fecha AS :p_date - Date for balance calculation
FUNCTION CF_BOOKS_BALANCE RETURN NUMBER IS
  ln_total_balance NUMBER;
  ln_diff_amount   NUMBER;
  ln_branch        NUMBER;
  ln_day_1         NUMBER; ln_day_2  NUMBER; ln_day_3  NUMBER;
  ln_day_4         NUMBER; ln_day_5  NUMBER; ln_day_6  NUMBER;
  ln_day_7         NUMBER; ln_day_8  NUMBER; ln_day_9  NUMBER;
  ln_day_10        NUMBER; ln_day_11 NUMBER; ln_day_12 NUMBER;
  ln_day_13        NUMBER; ln_day_14 NUMBER; ln_day_15 NUMBER;
  ln_day_16        NUMBER; ln_day_17 NUMBER; ln_day_18 NUMBER;
  ln_day_19        NUMBER; ln_day_20 NUMBER; ln_day_21 NUMBER;
  ln_day_22        NUMBER; ln_day_23 NUMBER; ln_day_24 NUMBER;
  ln_day_25        NUMBER; ln_day_26 NUMBER; ln_day_27 NUMBER;
  ln_day_28        NUMBER; ln_day_29 NUMBER; ln_day_30 NUMBER; ln_day_31 NUMBER;
BEGIN
  IF nvl(:cf_global_reconciliation, 'N') = 'N' THEN
  ln_day_1  := 0; ln_day_2  := 0; ln_day_3  := 0; ln_day_4  := 0; ln_day_5  := 0;
  ln_day_6  := 0; ln_day_7  := 0; ln_day_8  := 0; ln_day_9  := 0; ln_day_10 := 0;
  ln_day_11 := 0; ln_day_12 := 0; ln_day_13 := 0; ln_day_14 := 0; ln_day_15 := 0;
  ln_day_16 := 0; ln_day_17 := 0; ln_day_18 := 0; ln_day_19 := 0; ln_day_20 := 0;
  ln_day_21 := 0; ln_day_22 := 0; ln_day_23 := 0; ln_day_24 := 0; ln_day_25 := 0;
  ln_day_26 := 0; ln_day_27 := 0; ln_day_28 := 0; ln_day_29 := 0; ln_day_30 := 0; ln_day_31 := 0;

  BEGIN
    -- NOTE: bc_saldos_diarios table not found in LADONWARE-TABLES.SQL
    -- Using original Spanish table name until English mapping is provided
    SELECT SUM(nvl(dia_1, 0)),  SUM(nvl(dia_2, 0)),  SUM(nvl(dia_3, 0)),  SUM(nvl(dia_4, 0)),
           SUM(nvl(dia_5, 0)),  SUM(nvl(dia_6, 0)),  SUM(nvl(dia_7, 0)),  SUM(nvl(dia_8, 0)),
           SUM(nvl(dia_9, 0)),  SUM(nvl(dia_10, 0)), SUM(nvl(dia_11, 0)), SUM(nvl(dia_12, 0)),
           SUM(nvl(dia_13, 0)), SUM(nvl(dia_14, 0)), SUM(nvl(dia_15, 0)), SUM(nvl(dia_16, 0)),
           SUM(nvl(dia_17, 0)), SUM(nvl(dia_18, 0)), SUM(nvl(dia_19, 0)), SUM(nvl(dia_20, 0)),
           SUM(nvl(dia_21, 0)), SUM(nvl(dia_22, 0)), SUM(nvl(dia_23, 0)), SUM(nvl(dia_24, 0)),
           SUM(nvl(dia_25, 0)), SUM(nvl(dia_26, 0)), SUM(nvl(dia_27, 0)), SUM(nvl(dia_28, 0)),
           SUM(nvl(dia_29, 0)), SUM(nvl(dia_30, 0)), SUM(nvl(dia_31, 0))
      INTO ln_day_1,  ln_day_2,  ln_day_3,  ln_day_4,  ln_day_5,
           ln_day_6,  ln_day_7,  ln_day_8,  ln_day_9,  ln_day_10,
           ln_day_11, ln_day_12, ln_day_13, ln_day_14, ln_day_15,
           ln_day_16, ln_day_17, ln_day_18, ln_day_19, ln_day_20,
           ln_day_21, ln_day_22, ln_day_23, ln_day_24, ln_day_25,
           ln_day_26, ln_day_27, ln_day_28, ln_day_29, ln_day_30, ln_day_31
      FROM BC_BALANCES_DAILY
     WHERE ACCOUNT_NBR               = :p_account_nbr
       AND BRANCH_CODE              = :p_branch_code
       AND CORRESPONDENT_BRANCH_CODE = :p_correspondent_code
       AND CURRENCY_CODE               = :p_currency_code
       AND COMPANY_CODE              = :p_company
       AND YEAR                         = to_number(to_char(:p_date, 'YYYY'))
       AND MONTH                         = to_number(to_char(:p_date, 'MM'));
  EXCEPTION
    WHEN no_data_found THEN
      ln_total_balance := 0;
  END;
  
  ELSE
    BEGIN
      -- NOTE: bc_saldos_diarios table not found in LADONWARE-TABLES.SQL
      -- Using original Spanish table name until English mapping is provided
      SELECT SUM(nvl(dia_1, 0)),  SUM(nvl(dia_2, 0)),  SUM(nvl(dia_3, 0)),  SUM(nvl(dia_4, 0)),
             SUM(nvl(dia_5, 0)),  SUM(nvl(dia_6, 0)),  SUM(nvl(dia_7, 0)),  SUM(nvl(dia_8, 0)),
             SUM(nvl(dia_9, 0)),  SUM(nvl(dia_10, 0)), SUM(nvl(dia_11, 0)), SUM(nvl(dia_12, 0)),
             SUM(nvl(dia_13, 0)), SUM(nvl(dia_14, 0)), SUM(nvl(dia_15, 0)), SUM(nvl(dia_16, 0)),
             SUM(nvl(dia_17, 0)), SUM(nvl(dia_18, 0)), SUM(nvl(dia_19, 0)), SUM(nvl(dia_20, 0)),
             SUM(nvl(dia_21, 0)), SUM(nvl(dia_22, 0)), SUM(nvl(dia_23, 0)), SUM(nvl(dia_24, 0)),
             SUM(nvl(dia_25, 0)), SUM(nvl(dia_26, 0)), SUM(nvl(dia_27, 0)), SUM(nvl(dia_28, 0)),
             SUM(nvl(dia_29, 0)), SUM(nvl(dia_30, 0)), SUM(nvl(dia_31, 0))
        INTO ln_day_1,  ln_day_2,  ln_day_3,  ln_day_4,  ln_day_5,
             ln_day_6,  ln_day_7,  ln_day_8,  ln_day_9,  ln_day_10,
             ln_day_11, ln_day_12, ln_day_13, ln_day_14, ln_day_15,
             ln_day_16, ln_day_17, ln_day_18, ln_day_19, ln_day_20,
             ln_day_21, ln_day_22, ln_day_23, ln_day_24, ln_day_25,
             ln_day_26, ln_day_27, ln_day_28, ln_day_29, ln_day_30, ln_day_31
        FROM BC_BALANCES_DAILY a,
             BC_ACCOUNTS_RELATED c
       WHERE a.ACCOUNT_NBR              = c.ACCOUNT_NBR
         AND a.BRANCH_CODE             = c.ACCOUNT_BRANCH_CODE
         AND a.CORRESPONDENT_BRANCH_CODE = c.CORRESPONDENT_BRANCH_CODE
         AND a.CURRENCY_CODE              = c.CURRENCY_CODE
         AND a.COMPANY_CODE             = c.COMPANY_CODE
         AND c.ACCOUNT_NBR                = :p_account_nbr
         AND c.CORRESPONDENT_BRANCH_CODE  = :p_correspondent_code
         AND c.CURRENCY_CODE              = :p_currency_code
         AND c.COMPANY_CODE               = :p_company
         AND a.YEAR                        = to_number(to_char(:p_date, 'YYYY'))
         AND a.MONTH                        = to_number(to_char(:p_date, 'MM'));
    EXCEPTION
      WHEN no_data_found THEN
        ln_total_balance := 0;
    END;
  END IF;
 
  IF to_number(to_char(:p_date, 'DD')) = 1 THEN
    ln_total_balance := ln_day_1;
  ELSIF to_number(to_char(:p_date, 'DD')) = 2 THEN
    ln_total_balance := ln_day_2;
  ELSIF to_number(to_char(:p_date, 'DD')) = 3 THEN
    ln_total_balance := ln_day_3;
  ELSIF to_number(to_char(:p_date, 'DD')) = 4 THEN
    ln_total_balance := ln_day_4;
  ELSIF to_number(to_char(:p_date, 'DD')) = 5 THEN
    ln_total_balance := ln_day_5;
  ELSIF to_number(to_char(:p_date, 'DD')) = 6 THEN
    ln_total_balance := ln_day_6;
  ELSIF to_number(to_char(:p_date, 'DD')) = 7 THEN
    ln_total_balance := ln_day_7;
  ELSIF to_number(to_char(:p_date, 'DD')) = 8 THEN
    ln_total_balance := ln_day_8;
  ELSIF to_number(to_char(:p_date, 'DD')) = 9 THEN
    ln_total_balance := ln_day_9;
  ELSIF to_number(to_char(:p_date, 'DD')) = 10 THEN
    ln_total_balance := ln_day_10;
  ELSIF to_number(to_char(:p_date, 'DD')) = 11 THEN
    ln_total_balance := ln_day_11;
  ELSIF to_number(to_char(:p_date, 'DD')) = 12 THEN
    ln_total_balance := ln_day_12;
  ELSIF to_number(to_char(:p_date, 'DD')) = 13 THEN
    ln_total_balance := ln_day_13;
  ELSIF to_number(to_char(:p_date, 'DD')) = 14 THEN
    ln_total_balance := ln_day_14;
  ELSIF to_number(to_char(:p_date, 'DD')) = 15 THEN
    ln_total_balance := ln_day_15;
  ELSIF to_number(to_char(:p_date, 'DD')) = 16 THEN
    ln_total_balance := ln_day_16;
  ELSIF to_number(to_char(:p_date, 'DD')) = 17 THEN
    ln_total_balance := ln_day_17;
  ELSIF to_number(to_char(:p_date, 'DD')) = 18 THEN
    ln_total_balance := ln_day_18;
  ELSIF to_number(to_char(:p_date, 'DD')) = 19 THEN
    ln_total_balance := ln_day_19;
  ELSIF to_number(to_char(:p_date, 'DD')) = 20 THEN
    ln_total_balance := ln_day_20;
  ELSIF to_number(to_char(:p_date, 'DD')) = 21 THEN
    ln_total_balance := ln_day_21;
  ELSIF to_number(to_char(:p_date, 'DD')) = 22 THEN
    ln_total_balance := ln_day_22;
  ELSIF to_number(to_char(:p_date, 'DD')) = 23 THEN
    ln_total_balance := ln_day_23;
  ELSIF to_number(to_char(:p_date, 'DD')) = 24 THEN
    ln_total_balance := ln_day_24;
  ELSIF to_number(to_char(:p_date, 'DD')) = 25 THEN
    ln_total_balance := ln_day_25;
  ELSIF to_number(to_char(:p_date, 'DD')) = 26 THEN
    ln_total_balance := ln_day_26;
  ELSIF to_number(to_char(:p_date, 'DD')) = 27 THEN
    ln_total_balance := ln_day_27;
  ELSIF to_number(to_char(:p_date, 'DD')) = 28 THEN
    ln_total_balance := ln_day_28;
  ELSIF to_number(to_char(:p_date, 'DD')) = 29 THEN
    ln_total_balance := ln_day_29;
  ELSIF to_number(to_char(:p_date, 'DD')) = 30 THEN
    ln_total_balance := ln_day_30;
  ELSIF to_number(to_char(:p_date, 'DD')) = 31 THEN
    ln_total_balance := ln_day_31;
  END IF;

  RETURN(ln_total_balance);
END;


-- F_saldo_contabilidad1
-- CF_saldo_contabilidad:
-- Parameters:
--   1. :p_numero_cuenta AS :p_account_nbr - Account number filter
--   2. :cf_saldoslibros AS :cf_books_balance - Books balance (computed column)
--   3. :cs_extracto_credito AS :cs_statement_credit - Statement credit amount
--   4. :cs_extracto_debito AS :cs_statement_debit - Statement debit amount
FUNCTION CF_ACCOUNTING_BALANCE RETURN NUMBER IS
  ln_balance     NUMBER;
  ln_diff_amount NUMBER;
BEGIN
  /* Amount by difference */
  BEGIN
    SELECT SUM(DIFFERENCEVALUE)
      INTO ln_diff_amount
      FROM BC_HISTORICAL_DAILY_RECONCILIATION
     WHERE DIFFERENCEVALUE IS NOT NULL
       AND ACCOUNT_NBR = :p_account_nbr; -- CRAGE-2022-00157 filter by account
  EXCEPTION
    WHEN no_data_found THEN
      ln_diff_amount := 0;
  END;
  
  ln_balance := nvl(ln_diff_amount, 0) + 
                nvl(:cf_books_balance, 0) +
                nvl(:cs_statement_credit, 0) + 
                nvl(:cs_statement_debit, 0);
                
  RETURN(ln_balance);
END;


-- F_difbancos1
-- CF_diferencia_bancos:
-- Parameters:
--   1. :cf_segun_banco AS :cf_according_bank - Balance according to bank (computed column)
--   2. :cf_saldo_contabilidad AS :cf_accounting_balance - Accounting balance (computed column)
FUNCTION CF_BANK_DIFFERENCE RETURN NUMBER IS
  ln_difference NUMBER;
BEGIN
  ln_difference := :cf_according_bank - :cf_accounting_balance;
  
  RETURN(ln_difference);
END;

-- F_hecho_por1
-- CF_USER:
-- Parameters:
--   1. :P_USER_REP AS :p_user_rep - User who generated the report
function CF_USER return VARCHAR2 is
begin
return(:P_USER_REP);  
end;
