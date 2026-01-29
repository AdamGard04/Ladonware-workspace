-- ========================================
-- PARAMETERS LIST (P / P_):
-- ========================================
-- P_BREAK_LEVEL1      - Break level for account grouping (1-8)
-- P_COMPANY_CODE      - Company code
-- P_LEVEL_1           - Account level 1 start range
-- P_LEVEL_1_TO         - Account level 1 end range
-- P_LEVEL_2           - Account level 2 start range
-- P_LEVEL_2_TO         - Account level 2 end range
-- P_LEVEL_3           - Account level 3 start range
-- P_LEVEL_3_TO         - Account level 3 end range
-- P_LEVEL_4           - Account level 4 start range
-- P_LEVEL_4_TO         - Account level 4 end range
-- P_LEVEL_5           - Account level 5 start range
-- P_LEVEL_5_TO         - Account level 5 end range
-- P_LEVEL_6           - Account level 6 start range
-- P_LEVEL_6_TO         - Account level 6 end range
-- P_LEVEL_7           - Account level 7 start range
-- P_LEVEL_7_TO         - Account level 7 end range
-- P_LEVEL_8           - Account level 8 start range
-- P_LEVEL_8_TO         - Account level 8 end range
-- P_REPORT_DATE       - Report date for transaction filtering
-- PRIOR_BALANCE       - Previous balance amount
-- ========================================
-- COMPUTED PARAMETERS (CP_):
-- ========================================
-- CP_DEBIT            - Total debit amount (W_DEBITO)
-- CP_CREDIT           - Total credit amount (W_CREDITO)
-- ========================================

-- Q_ACCOUNTS:

SELECT   DECODE(P_BREAK_LEVEL1,1,a.level_1,2,a.level_2, 3,a.level_3, 4,a.level_4, 5,a.level_5, 6,a.level_6, 7,a.level_7,8, a.level_8) break_level1,
 a.level_1, a.level_2, a.level_3, a.level_4, a.level_5, a.level_6, a.level_7, a.level_8, DECODE(P_BREAK_LEVEL1,1,d.digit_quantity_level_1,2,d.digit_quantity_level_2, 3,d.digit_quantity_level_3, 4,d.digit_quantity_level_4, 5,d.digit_quantity_level_5, 6,d.digit_quantity_level_6, 7,d.digit_quantity_level_7,8, d.digit_quantity_level_8) digit_quantity,
nvl(balance_current,0) prior_balance,
a.description  account_desc,e.symbol
FROM    GM_ACCOUNT_BALANCE a, 
              GM_CATALOGS c, 
              GM_PARAMETER_ACCOUNTS_STRUCTURE D,
              GM_ACCOUNT_TYPES e
WHERE  a.company_code  = P_COMPANY_CODE
AND a.level_1 BETWEEN nvl(P_LEVEL_1,a.level_1) 
and   DECODE(P_LEVEL_1_TO,NULL,DECODE(P_LEVEL_1,NULL,a.level_1,P_LEVEL_1),P_LEVEL_1_TO) 
AND a.level_2 BETWEEN nvl(P_LEVEL_2,a.level_2) 
AND DECODE(P_LEVEL_2_TO,NULL,DECODE(P_LEVEL_2,NULL,a.level_2,P_LEVEL_2),P_LEVEL_2_TO) 
AND a.level_3 BETWEEN nvl(P_LEVEL_3,a.level_3) 
AND   DECODE(P_LEVEL_3_TO,NULL,DECODE(P_LEVEL_3,NULL,a.level_3,P_LEVEL_3),P_LEVEL_3_TO) 
 AND a.level_4 BETWEEN nvl(P_LEVEL_4,a.level_4) 
AND   DECODE(P_LEVEL_4_TO,NULL,DECODE(P_LEVEL_4,NULL,a.level_4,P_LEVEL_4),P_LEVEL_4_TO) 
AND  a.level_5 BETWEEN nvl(P_LEVEL_5,a.level_5)
 AND   DECODE(P_LEVEL_5_TO,NULL,DECODE(P_LEVEL_5,NULL,a.level_5,P_LEVEL_5),P_LEVEL_5_TO)
 AND a.level_6  BETWEEN nvl(P_LEVEL_6,a.level_6) 
AND   DECODE(P_LEVEL_6_TO,NULL,DECODE(P_LEVEL_6,NULL,a.level_6,P_LEVEL_6),P_LEVEL_6_TO) 
 AND a.level_7 BETWEEN nvl(P_LEVEL_7,a.level_7) 
AND   DECODE(P_LEVEL_7_TO,NULL,DECODE(P_LEVEL_7,NULL,a.level_7,P_LEVEL_7),P_LEVEL_7_TO)
AND a.level_8 BETWEEN nvl(P_LEVEL_8,a.level_8)
AND   DECODE(P_LEVEL_8_TO,NULL,DECODE(P_LEVEL_8,NULL,a.level_8,P_LEVEL_8),P_LEVEL_8_TO) 
AND c.company_code = a.company_code
AND c.level_1 = a.level_1
AND c.level_2 = a.level_2
AND c.level_3 = a.level_3
AND c.level_4 = a.level_4
AND c.account_class NOT IN('ENC', 'SUM')
and d.company_code              = a.company_code
AND e.company_code     = a.company_code
and e.type_code                      = c.type_code
AND A.txn_entry_received ='S' 
AND (a.balance_current != 0
or  0 != ( select nvl(sum(abs(txn_entry_amount)),0)
                       from GM_TXN_ENTRIES_DETAIL m
                     where m.company_code = a.company_code
                         and m.level_1               = a.level_1
                        and m.level_2               = a.level_2
                        and m.level_3               = a.level_3
                        and m.level_4               = a.level_4
                        and m.level_5               = a.level_5
                        and m.level_6               = a.level_6
                        and m.level_7               = a.level_7
                        and m.level_8               = a.level_8
                        and m.txn_entry_date <= P_REPORT_DATE)
     )

Order by a.company_code, 
A.ACCOUNT


-- FUNCTIONS:

-- F_Etiqueta1
function CF_Label1 return VARCHAR2 is
Lv_Label	GM_PARAMETER_ACCOUNTS_STRUCTURE.level_1_description%TYPE := NULL;
begin
  SELECT DECODE(P_BREAK_LEVEL1, 1, level_1_description, 2, level_2_description, 
		3, nivel_3_descripcion, 4, nivel_4_description,
		5, level_5_description, 6, level_6_description,
		7, nivel_7_descripcion, 8, level_8_description)
  INTO Lv_Label
  FROM GM_PARAMETER_ACCOUNTS_STRUCTURE
  WHERE company_code = TO_NUMBER(P_COMPANY_CODE);
  RETURN (INITCAP(Lv_Label)||':');
  RETURN NULL; EXCEPTION
  WHEN NO_DATA_FOUND THEN
  return(NULL);
  WHEN TOO_MANY_ROWS THEN
  RETURN(NULL);
  WHEN OTHERS THEN
  RETURN(NULL);
end;


-- F_Descripcion1
function CF_DESCRIPTION return VARCHAR2 is
BEGIN
  DECLARE
    Lv_BranchName  MG_BRANCHES_GENERAL.branch_name%TYPE := ' ';
    Lv_ErrorMessage   VARCHAR2(200);
  BEGIN
    MG_P_NOMBRE_AGENCIA(P_COMPANY_CODE,Q_ACCOUNTS.BREAK_LEVEL1,Lv_BranchName,Lv_ErrorMessage);
    IF Lv_ErrorMessage IS NULL 
    THEN
       RETURN(Lv_BranchName);
    ELSE
       RETURN(NULL);
    END IF;
  END;
RETURN NULL; END;


-- F_CF_Formula1
function CF_ACCOUNT_FORMAT return VARCHAR2 is
Pv_Format VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(Q_ACCOUNTS.LEVEL_1, Q_ACCOUNTS.LEVEL_2, Q_ACCOUNTS.LEVEL_3, Q_ACCOUNTS.LEVEL_4, Q_ACCOUNTS.LEVEL_5,
      Q_ACCOUNTS.LEVEL_6, Q_ACCOUNTS.LEVEL_7, Q_ACCOUNTS.LEVEL_8, P_COMPANY_CODE, Pv_Format);
  RETURN(Pv_Format);
end;



-- PU_P_TOTALES
FUNCTION CF_TOTALS (
  Pn_CompanyCode   IN NUMBER,
  Pv_Level1        IN VARCHAR2,
  Pv_Level2        IN VARCHAR2,
  Pv_Level3        IN VARCHAR2,
  Pv_Level4        IN VARCHAR2,
  Pv_Level5        IN VARCHAR2,
  Pv_Level6        IN VARCHAR2,
  Pv_Level7        IN VARCHAR2,
  Pv_Level8        IN VARCHAR2,
  Pd_Date          IN DATE,
  Pn_PriorBalance  IN NUMBER
) RETURN NUMBER IS

  Lv_AccountNature   VARCHAR2(1);
  Lv_Error           VARCHAR2(200);

  Ln_TotalDb         NUMBER := 0;
  Ln_TotalCr         NUMBER := 0;
  Ln_CurrentBalance  NUMBER := 0;

BEGIN
  SELECT
    SUM(
      DECODE(credit_debit,
             'D',
             DECODE(A.currency_code,
                    C.local_currency_code,
                    ABS(NVL(txn_entry_amount,0)),
                    ABS(NVL(txn_entry_local_amount,0))),
             0)
    ),
    SUM(
      DECODE(credit_debit,
             'C',
             DECODE(A.currency_code,
                    C.local_currency_code,
                    ABS(NVL(txn_entry_amount,0)),
                    ABS(NVL(txn_entry_local_amount,0))),
             0)
    )
  INTO Ln_TotalDb, Ln_TotalCr
  FROM GM_TXN_ENTRIES_DETAIL A,
       GM_TXN_ENTRIES_HEADER B,
       GM_SETTINGS C
  WHERE level_1 = Pv_Level1
    AND level_2 = Pv_Level2
    AND level_3 = Pv_Level3
    AND level_4 = Pv_Level4
    AND level_5 = Pv_Level5
    AND level_6 = Pv_Level6
    AND level_7 = Pv_Level7
    AND level_8 = Pv_Level8
    AND B.username         = A.username
    AND B.txn_entry_nbr    = A.txn_entry_nbr
    AND B.txn_entry_date   = A.txn_entry_date
    AND B.effective_date <= Pd_Date
    AND B.updated          = 'N'
    AND A.company_code     = C.company_code;

  Lv_Error := GM_F_NATURALEZA_CUENTA(
                Pn_CompanyCode,
                Pv_Level1,
                Pv_Level2,
                Pv_Level3,
                Pv_Level4,
                Pv_Level5,
                Pv_Level6,
                Lv_AccountNature
              );

  IF Lv_AccountNature = 'D' THEN
     Ln_CurrentBalance :=
       NVL(Pn_PriorBalance,0)
       + ABS(NVL(Ln_TotalDb,0))
       - ABS(NVL(Ln_TotalCr,0));
  ELSIF Lv_AccountNature = 'C' THEN
     Ln_CurrentBalance :=
       NVL(Pn_PriorBalance,0)
       - ABS(NVL(Ln_TotalDb,0))
       + ABS(NVL(Ln_TotalCr,0));
  END IF;

  IF Ln_TotalCr < 0 THEN
     Ln_TotalCr := ABS(Ln_TotalCr);
  END IF;

  RETURN Ln_CurrentBalance;

EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END CF_TOTALS;



-- CF_SALDO_ACTUAL
function CF_CURRENT_BALANCE return Number is
Ln_Balance  NUMBER(20,2);
begin
  CF_TOTALS(To_Number(P_COMPANY_CODE), Q_ACCOUNTS.LEVEL_1, Q_ACCOUNTS.LEVEL_2,Q_ACCOUNTS.LEVEL_3, Q_ACCOUNTS.LEVEL_4,
		 Q_ACCOUNTS.LEVEL_5, Q_ACCOUNTS.LEVEL_6,Q_ACCOUNTS.LEVEL_7, Q_ACCOUNTS.LEVEL_8,P_REPORT_DATE,
		 :Saldo_Anterior, CP_DEBIT, CP_CREDIT, Ln_Balance);
  RETURN(Ln_Balance);
end; --CORREGIR Saldo_Anterior: IDENTIFICAR DE DONDE VIENE



-- F_Saldo_Anterior1
function CF_PRIOR_BALANCE_CALC return Number is


  Lv_Account_Nature VARCHAR2(1);
  Lv_ErrorCode       VARCHAR2(200):=NULL ;
begin  
  Lv_ErrorCode := GM_F_NATURALEZA_CUENTA(P_COMPANY_CODE,
					Q_ACCOUNTS.LEVEL_1, 
					Q_ACCOUNTS.LEVEL_2,
					Q_ACCOUNTS.LEVEL_3,
					Q_ACCOUNTS.LEVEL_4,
					Q_ACCOUNTS.LEVEL_5,
					Q_ACCOUNTS.LEVEL_6,
					Lv_Account_Nature);
  IF  ( Lv_Account_Nature = 'D')
  THEN
    RETURN (Q_ACCOUNTS.PRIOR_BALANCE);
  ELSIF ( Lv_Account_Nature = 'C') THEN
    RETURN ((Q_ACCOUNTS.PRIOR_BALANCE) * -1 );
  END IF;
RETURN NULL; end;


-- F_CF_MovDB1 o W_DEBITO = CP_DEBITO



-- F_CF_MovCR1 o W_CREDITO = CP_CREDITO



-- F_CF_Saldo_Dia2 o CP_SALDO_DEU



-- F_CF_Saldo_Dia1 o CP_SALDO_ACR



-- F_CS_Total_Reg_Suc1
function CF_TOTAL_RECORDS return Number is
    Ln_CurrentBalance NUMBER;
begin
    Ln_CurrentBalance := CF_CURRENT_BALANCE;

  if NVL(CP_CREDIT,0) = 0 
  and NVL(CP_DEBIT,0) = 0 
  AND NVL(Ln_CurrentBalance,0) = 0 
  AND NVL(Q_ACCOUNTS.PRIOR_BALANCE,0) = 0 THEN
  return (0);
  ELSE 
   RETURN(1);
  END IF;  
RETURN NULL; end;


-- -- F_CS_Saldo_Anterior_Suc1
-- function CF_PRIOR_BALANCE_SUC return Number is

--   Lv_Account_Nature VARCHAR2(1);
--   Lv_ErrorCode       VARCHAR2(200):=NULL ;
-- begin  
--   Lv_ErrorCode := GM_F_NATURALEZA_CUENTA(P_COMPANY_CODE,
-- 					Q_ACCOUNTS.LEVEL_1, 
-- 					Q_ACCOUNTS.LEVEL_2,
-- 					Q_ACCOUNTS.LEVEL_3,
-- 					Q_ACCOUNTS.LEVEL_4,
-- 					Q_ACCOUNTS.LEVEL_5,
-- 					Q_ACCOUNTS.LEVEL_6,
-- 					Lv_Account_Nature);
--   IF  ( Lv_Account_Nature = 'D')
--   THEN
--     RETURN (Q_ACCOUNTS.PRIOR_BALANCE);
--   ELSIF ( Lv_Account_Nature = 'C') THEN
--     RETURN ((Q_ACCOUNTS.PRIOR_BALANCE) * -1 );
--   END IF;
RETURN NULL; end;



-- F_CS_total_registros1



--F_CS_Saldo_Dia_Suc2
