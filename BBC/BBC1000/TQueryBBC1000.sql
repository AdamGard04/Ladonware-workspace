-- Q_CHEQUES --> Q_CHECKS
SELECT DISTINCT
    (A.CORRESPONDENT_BRANCH_CODE) AS BRANCH,
    A.COMPANY_CODE AS COMPANY,
    A.CURRENCY_CODE AS CURRENCY,
    A.ACCOUNT_NBR AS ACCOUNT,
    C.COUNTRY_CODE AS COUNTRY,
    A.ACCOUNT_LEVEL_1 AS LEVEL_1,
    A.ACCOUNT_LEVEL_2 AS LEVEL_2,
    A.ACCOUNT_LEVEL_3 AS LEVEL_3,
    A.ACCOUNT_LEVEL_4 AS LEVEL_4,
    A.ACCOUNT_LEVEL_5 AS LEVEL_5,
    A.ACCOUNT_LEVEL_6 AS LEVEL_6,
    A.ACCOUNT_LEVEL_7 AS LEVEL_7,
    A.ACCOUNT_LEVEL_8 AS LEVEL_8,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        1,
        SUM(D.DAY_1),
        0
    ) AS BALANCE_DAY_1,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        2,
        SUM(D.DAY_2),
        0
    ) BALANCE_DAY_2,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        3,
        SUM(D.DAY_3),
        0
    ) BALANCE_DAY_3,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        4,
        SUM(D.DAY_4),
        0
    ) BALANCE_DAY_4,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        5,
        SUM(D.DAY_5),
        0
    ) BALANCE_DAY_5,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        6,
        SUM(D.DAY_6),
        0
    ) BALANCE_DAY_6,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        7,
        SUM(D.DAY_7),
        0
    ) BALANCE_DAY_7,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        8,
        SUM(D.DAY_8),
        0
    ) BALANCE_DAY_8,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        9,
        SUM(D.DAY_9),
        0
    ) BALANCE_DAY_9,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        10,
        SUM(D.DAY_10),
        0
    ) BALANCE_DAY_10,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        11,
        SUM(D.DAY_11),
        0
    ) BALANCE_DAY_11,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        12,
        SUM(D.DAY_12),
        0
    ) BALANCE_DAY_12,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        13,
        SUM(D.DAY_13),
        0
    ) BALANCE_DAY_13,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        14,
        SUM(D.DAY_14),
        0
    ) BALANCE_DAY_14,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        15,
        SUM(D.DAY_15),
        0
    ) BALANCE_DAY_15,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        16,
        SUM(D.DAY_16),
        0
    ) BALANCE_DAY_16,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        17,
        SUM(D.DAY_17),
        0
    ) BALANCE_DAY_17,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        18,
        SUM(D.DAY_18),
        0
    ) BALANCE_DAY_18,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        19,
        SUM(D.DAY_19),
        0
    ) BALANCE_DAY_19,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        20,
        SUM(D.DAY_20),
        0
    ) BALANCE_DAY_20,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        21,
        SUM(D.DAY_21),
        0
    ) BALANCE_DAY_21,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        22,
        SUM(D.DAY_22),
        0
    ) BALANCE_DAY_22,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        23,
        SUM(D.DAY_23),
        0
    ) BALANCE_DAY_23,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        24,
        SUM(D.DAY_24),
        0
    ) BALANCE_DAY_24,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        25,
        SUM(D.DAY_25),
        0
    ) BALANCE_DAY_25,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        26,
        SUM(D.DAY_26),
        0
    ) BALANCE_DAY_26,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        27,
        SUM(D.DAY_27),
        0
    ) BALANCE_DAY_27,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        28,
        SUM(D.DAY_28),
        0
    ) BALANCE_DAY_28,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        29,
        SUM(D.DAY_29),
        0
    ) BALANCE_DAY_29,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        30,
        SUM(D.DAY_30),
        0
    ) BALANCE_DAY_30,
    DECODE (
        TO_NUMBER (TO_CHAR (P_DATE, 'DD')),
        31,
        SUM(D.DAY_31),
        0
    ) BALANCE_DAY_31
FROM
    BC_CORRESPONDENT_BALANCES A,
    BC_CORRESPONDENT_ACCOUNTS B,
    MG_BRANCHES_GENERAL C,
    BC_BALANCES_DAILY D
WHERE
    A.COMPANY_CODE = B.COMPANY_CODE
    AND A.BRANCH_CODE = B.BRANCH_CODE
    AND A.CORRESPONDENT_BRANCH_CODE = B.CORRESPONDENT_BRANCH_CODE
    AND A.CURRENCY_CODE = B.CURRENCY_CODE
    AND A.ACCOUNT_NBR = B.ACCOUNT_NBR
    AND A.BALANCE_TYPE = D.BALANCE_TYPE
    AND A.ACCOUNT_NBR = D.ACCOUNT_NBR
    AND A.CORRESPONDENT_BRANCH_CODE = D.CORRESPONDENT_BRANCH_CODE
    AND A.CURRENCY_CODE = D.CURRENCY_CODE
    AND A.BRANCH_CODE = D.BRANCH_CODE
    AND A.COMPANY_CODE = D.COMPANY_CODE
    AND B.ACCOUNT_STATE != 3
    AND A.CORRESPONDENT_BRANCH_CODE = C.BRANCH_CODE
    AND C.COUNTRY_CODE = nvl (P_COUNTRY, c.COUNTRY_CODE)
    AND D.MONTH = TO_NUMBER (TO_CHAR (P_DATE, 'MM'))
    AND D.YEAR = TO_NUMBER (TO_CHAR (P_DATE, 'YYYY'))
GROUP BY
    A.CORRESPONDENT_BRANCH_CODE,
    A.CURRENCY_CODE,
    A.ACCOUNT_NBR,
    C.COUNTRY_CODE,
    A.COMPANY_CODE,
    A.ACCOUNT_LEVEL_1,
    A.ACCOUNT_LEVEL_2,
    A.ACCOUNT_LEVEL_3,
    A.ACCOUNT_LEVEL_4,
    A.ACCOUNT_LEVEL_5,
    A.ACCOUNT_LEVEL_6,
    A.ACCOUNT_LEVEL_7,
    A.ACCOUNT_LEVEL_8
ORDER BY
    C.COUNTRY_CODE,
    A.CORRESPONDENT_BRANCH_CODE,
    A.ACCOUNT_NBR,
    A.CURRENCY_CODE


-- funciones:
-- F_MONEDA1
function CF_Currency_Desc return VARCHAR2 is
  Lv_Currency  VARCHAR(80);
begin
	begin
    SELECT DESCRIPTION
    INTO Lv_Currency
    FROM MG_CURRENCY
    WHERE CURRENCY_CODE = Q_CHECKS.CURRENCY;
	exception
		when others then Lv_Currency := null;
	end;
	
	RETURN(Lv_Currency);
end;



-- F_BANCO1
function CF_Branch_Desc return VARCHAR2 is
  Lv_Branch varchar(80);
begin
	begin
    SELECT BRANCH_NAME 
    INTO Lv_Branch
    FROM MG_BRANCHES_GENERAL
    WHERE BRANCH_CODE = Q_CHECKS.BRANCH;
	EXCEPTION 
		 WHEN OTHERS THEN Lv_Branch:= NULL;
	end;
	
	  RETURN(Lv_Branch);
end;



-- F_Saldo_Mayor
function CF_Ledger_Balance return Number is
  Ln_CurrentBalance NUMBER;
  Ln_LocalBalance  NUMBER;
  Ln_LedgerBalance NUMBER;
begin
  PU_P_AccountingBalanceDate(P_Company_Code,
                          Q_CHECKS.LEVEL_1,
                          Q_CHECKS.LEVEL_2,
                          Q_CHECKS.LEVEL_3,
                          Q_CHECKS.LEVEL_4,
                          Q_CHECKS.LEVEL_5,
                          Q_CHECKS.LEVEL_6,
                          Q_CHECKS.LEVEL_7,
                          Q_CHECKS.LEVEL_8,
                          Q_CHECKS.CURRENCY,
                          Q_CHECKS.P_Local_Currency,
                          Q_CHECKS.CF_Today_Date,
                          Ln_CurrentBalance,
                          Ln_LocalBalance);
  Ln_LedgerBalance := Ln_CurrentBalance;
  RETURN(Ln_LedgerBalance);
end;



-- F_Saldo_Mayor_MN
function CF_Ledger_Balance_MN return Number is
  Ln_CurrentBalance    NUMBER;
  Ln_LocalBalance     NUMBER;
  Ln_LedgerBalance_LC NUMBER;
begin
  PU_P_AccountingBalanceDate(Q_CHECKS.P_COMPANY_CODE,
                          Q_CHECKS.LEVEL_1,
                          Q_CHECKS.LEVEL_2,
                          Q_CHECKS.LEVEL_3,
                          Q_CHECKS.LEVEL_4,
                          Q_CHECKS.LEVEL_5,
                          Q_CHECKS.LEVEL_6,
                          Q_CHECKS.LEVEL_7,
                          Q_CHECKS.LEVEL_8,
                          Q_CHECKS.CURRENCY,
                          Q_CHECKS.P_Local_Currency,
                          Q_CHECKS.CF_Today_Date,
                          Ln_CurrentBalance,
                          Ln_LocalBalance);
  Ln_LedgerBalance_LC := Ln_LocalBalance;
  RETURN(Ln_LedgerBalance_LC);
end;



-- F_Saldo_Auxiliar
function CF_Auxiliary_Balance return Number is
  Ln_Day NUMBER;
begin
  Ln_Day := to_number(to_char(Q_CHECKS.P_DATE,'DD'));
  IF Ln_Day = 1 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_1);
  ELSIF Ln_Day = 2 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_2);
  ELSIF Ln_Day = 3 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_3);
  ELSIF Ln_Day = 4 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_4);
  ELSIF Ln_Day = 5 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_5);
  ELSIF Ln_Day = 6 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_6);
  ELSIF Ln_Day = 7 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_7);
  ELSIF Ln_Day = 8 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_8);
  ELSIF Ln_Day = 9 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_9);
  ELSIF Ln_Day = 10 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_10);
  ELSIF Ln_Day = 11 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_11);
  ELSIF Ln_Day = 12 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_12);
  ELSIF Ln_Day = 13 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_13);
  ELSIF Ln_Day = 14 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_14);
  ELSIF Ln_Day = 15 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_15);
  ELSIF Ln_Day = 16 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_16);
  ELSIF Ln_Day = 17 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_17);
  ELSIF Ln_Day = 18 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_18);
  ELSIF Ln_Day = 19 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_19);
  ELSIF Ln_Day = 20 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_20);
  ELSIF Ln_Day = 21 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_21);
  ELSIF Ln_Day = 22 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_22);
  ELSIF Ln_Day = 23 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_23);
  ELSIF Ln_Day = 24 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_24);
  ELSIF Ln_Day = 25 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_25);
  ELSIF Ln_Day = 26 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_26);
  ELSIF Ln_Day = 27 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_27);
  ELSIF Ln_Day = 28 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_28);
  ELSIF Ln_Day = 29 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_29);
  ELSIF Ln_Day = 30 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_30);
  ELSIF Ln_Day = 31 THEN
  	RETURN(Q_CHECKS.BALANCE_DAY_31);
  END IF;
end;



-- F_Saldo_Auxiliar_MN
function CF_Auxiliary_Balance_MN return Number is
  ExchangeRateOrigin      NUMBER(16,8);
  ExchangeRateDestination     NUMBER(16,8);
  ExchangeDifference      NUMBER(16,6);
  ProfitLoss       NUMBER(19,6);
  ExchangeRateDate       DATE;
  ExchangeRateValue       NUMBER;
  Lv_ErrorMessage       VARCHAR2(2000);
  Ln_WithoutOverdraftLC     NUMBER(19,6);
begin
  
  If Q_CHECKS.P_LOCAL_CURRENCY != Q_CHECKS.CURRENCY THEN
    Mg_P_CurrencyExchange ( Q_CHECKS.P_COMPANY_CODE,
                				Q_CHECKS.CURRENCY,
	                      Q_CHECKS.P_LOCAL_CURRENCY,
	                      1, -- AccountingType
	                      ExchangeRateDate,
                        Q_CHECKS.CF_TODAY_DATE,
 		                    ExchangeRateOrigin,
		                    ExchangeRateDestination,
                        ExchangeRateValue,
	                      Q_CHECKS.CF_Auxiliary_Balance,
                        Ln_WithoutOverdraftLC,
                        ExchangeDifference,
	                      ProfitLoss,
	                      Lv_ErrorMessage);
  Else
  	Ln_WithoutOverdraftLC := Q_CHECKS.CF_Auxiliary_Balance;
	End If;

  --:CP_OVERDRAFT_LC := Ln_OverdraftLC;
  RETURN(Ln_WithoutOverdraftLC);
end;



-- F_Diferencia
function CF_Difference return Number is
begin
  RETURN(CF_Ledger_Balance - CF_Auxiliary_Balance);
end;