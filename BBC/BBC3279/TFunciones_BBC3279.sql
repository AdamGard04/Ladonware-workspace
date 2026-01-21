/*
  Listado de campos:
    Encabezado:
          1 (CF): ENCABEZADO.CG$C_USER
          2 (CF): ENCABEZADO.CF_COMPANY_NAME
          3 (?): ENCABEZADO.F_Nth1
          4 (?): ENCABEZADO.F_fecha_sistema
          5 (FC): ENCABEZADO.CF_today_date
          6 (CF): ENCABEZADO.CP_beneficiary
          7 (FC): ENCABEZADO.CF_today_date
          8 (FC): ENCABEZADO.CP_number_check
    Cuerpo:
        1(CF): Q.DETALLE.account_balance
        2(BD): Q.DETALLE.accounting_desc_balance
        3(CF): Q.DETALLE.DB_2
        4(CF): Q.DETALLE.CR_2
        5(CF): Q.DESGLOSE.account_breakdown
        6(BD): Q.DESGLOSE.accounting_desc_breakdown
        7(BD): Q.DESGLOSE.breakdown_amount
        8(CF): Q.CHEQUES.account_concept
        9(CF): Q.CHEQUES.account_description
        10(CF): Q.CHEQUES.DB_1
        11(CF): Q.CHEQUES.CR_1
        12(CF): Q.CHEQUES.total_db
        13(CF): Q.CHEQUES.total_cr
*/ 

-- cuenta_saldo 1 (CF): 
--Encabezado Reporte:
-- 1 (CF): CG$C_USER
        function CG$C_USER return VARCHAR2 is
        begin
            return(:P_USER_REP);
        end;

-- 2 (CF): F_COMPANY_NAME
        function CF_COMPANY_NAME return VARCHAR2 is
            lv_company VARCHAR2(30);
        begin
            SELECT NAME
            INTO   lv_company
            FROM   MG_COMPANIES
            WHERE  COMPANY_CODE = :P_COMPANY_CODE;
            RETURN(lv_company);
        EXCEPTION WHEN OTHERS THEN
            RETURN NULL;
        end;

-- 5 (FC): F_FECHA_HOY2
function CF_today_date return Date is
ld_today date;
begin
  SELECT TODAY_DATE INTO ld_today
  FROM MG_SCHEDULE
  WHERE COMPANY_CODE    = :P_COMPANY_CODE
  AND   APPLICATION_CODE = 'BBC';
  RETURN ld_today;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;

-- 6 (CF): F_BENEFICIARIO_2= VACÍO
function CP_beneficiary return Char is
begin
  
end;

-- 7 (FC): F_FECHA_HOY1 -- MISMO QUE EL 5
function CF_today_date return Date is
ld_today date;
begin
  SELECT TODAY_DATE INTO ld_today
  FROM MG_SCHEDULE
  WHERE COMPANY_CODE    = :P_COMPANY_CODE
  AND   APPLICATION_CODE = 'BBC';
  RETURN ld_today;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;

-- 8 (FC): F_NUMERO_CHEQUE_2 = VACÍO
function CP_number_check return Char is
begin
  
end;

-- Cuerpo Reporte:        
FUNCTION account_balance RETURN CHAR IS
    lv_account VARCHAR2(40);
BEGIN
    IF :level_1_balance IS NOT NULL THEN
        lv_account := :level_1_balance || '-' || :level_2_balance || '-' || :level_3_balance || '-' || 
                      :level_4_balance || '-' || :level_5_balance || '-' || :level_6_balance || '-' || 
                      :level_7_balance || '-' || :level_8_balance;
    END IF;
    
    RETURN(lv_account);
END;


-- DB_2 3 (CF)
FUNCTION DB_2 RETURN NUMBER IS
BEGIN
    IF :debit_credit_2 = 'Dr' THEN
        RETURN (:value);
    ELSE
        RETURN (NULL);
    END IF;
END;



-- CR_2 4 (CF)
FUNCTION CR_2 RETURN NUMBER IS
BEGIN
    IF :debit_credit_2 = 'Cr' THEN
        RETURN (-:value);
    ELSE
        RETURN (NULL);
    END IF;
END;



-- CF_cuenta_desglose 5 (CF)
FUNCTION account_breakdown RETURN CHAR IS
    lv_account VARCHAR2(40);
BEGIN
    IF :level_1_breakdown IS NOT NULL THEN
        lv_account := :level_1_breakdown || '-' || :level_2_breakdown || '-' || :level_3_breakdown || '-' || 
                      :level_4_breakdown || '-' || :level_5_breakdown || '-' || :level_6_breakdown || '-' || 
                      :level_7_breakdown || '-' || :level_8_breakdown;
    END IF;
    
    RETURN(lv_account);
END;





-- cuenta_concepto  8 (CF)
FUNCTION account_concept RETURN CHAR IS
    lv_account         VARCHAR2(40);
    ln_branch_level    NUMBER;
    lv_level_1         VARCHAR2(4);
    lv_level_2         VARCHAR2(4);
    lv_level_3         VARCHAR2(4);
    lv_level_4         VARCHAR2(4);
    lv_level_5         VARCHAR2(4);
    lv_level_6         VARCHAR2(4);
    lv_level_7         VARCHAR2(4);
    lv_level_8         VARCHAR2(4);
BEGIN
    lv_level_1 := :level_1;
    lv_level_2 := :level_2;
    lv_level_3 := :level_3;
    lv_level_4 := :level_4;
    lv_level_5 := :level_5;
    lv_level_6 := :level_6;
    lv_level_7 := :level_7;
    lv_level_8 := :level_8;
    
    BEGIN
        SELECT nivel_agencia
        INTO   ln_branch_level
        FROM   gm_parametros
        WHERE  codigo_empresa = :p_company_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ln_branch_level := NULL;
    END;
    
    GM_P_CAMBIA_AGENCIA_A_CTA_CONT(:origin_branch_code,
                                    ln_branch_level,
                                    lv_level_1, lv_level_2, lv_level_3, lv_level_4,
                                    lv_level_5, lv_level_6, lv_level_7, lv_level_8,
                                    :p_company_code);
    
    IF :level_1 IS NOT NULL THEN
        lv_account := lv_level_1 || '-' || lv_level_2 || '-' || lv_level_3 || '-' || lv_level_4 || '-' || 
                      lv_level_5 || '-' || lv_level_6 || '-' || lv_level_7 || '-' || lv_level_8;
    END IF;
    
    RETURN(lv_account);
END;


-- F_desc_contable4 9 (CF)
FUNCTION account_description RETURN CHAR IS
    lv_description VARCHAR2(80);
BEGIN
    IF :level_1 IS NOT NULL THEN
        BEGIN
            SELECT description
            INTO   lv_description
            FROM   GM_ACCOUNT_BALANCE gm
            WHERE  gm.company_code = :accounting_company_code
            AND    gm.level_1      = :level_1
            AND    gm.level_2      = :level_2
            AND    gm.level_3      = :level_3
            AND    gm.level_4      = :level_4
            AND    gm.level_5      = :level_5
            AND    gm.level_6      = :level_6
            AND    gm.level_7      = :level_7
            AND    gm.level_8      = :level_8;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                lv_description := 'ACCOUNT DOES NOT EXIST';
            WHEN OTHERS THEN
                lv_description := 'THIS ACCOUNT HAS A PROBLEM';
        END;
    ELSE
        lv_description := 'NO ACCOUNT DEFINED - VERIFY';
    END IF;
    
    RETURN(lv_description);
END;


-- F_2: DB_1 10(CF)
FUNCTION DB_1 RETURN NUMBER IS
BEGIN
    IF :debit_credit_1 = 'Db' THEN
        RETURN (:check_amount);
    ELSE
        RETURN (NULL);
    END IF;
END;


-- F_1: CR_1 11(CF)
FUNCTION CR_1 RETURN NUMBER IS
BEGIN
    IF :debit_credit_1 = 'Cr' THEN
        RETURN (-:check_amount);
    ELSE
        RETURN (NULL);
    END IF;
END;


-- F_total_db: total_db 12(CF)
FUNCTION total_db RETURN NUMBER IS
    ln_amount NUMBER;
BEGIN
    IF :cs_breakdown_sum >= 1 THEN
        ln_amount := NVL(:cs_db_2, 0) + NVL(:cs_total_breakdown, 0);
    ELSE
        ln_amount := NVL(:cs_db_1, 0) + NVL(:cs_db_2, 0);
    END IF;
    
    RETURN(ln_amount);
END;



-- F_total_cr: total_cr 13(CF)
FUNCTION total_cr RETURN NUMBER IS
    ln_amount NUMBER;
BEGIN
    ln_amount := NVL(:cs_cr_1, 0) + NVL(:cs_cr_2, 0);
    
    RETURN(ln_amount);
END;




 