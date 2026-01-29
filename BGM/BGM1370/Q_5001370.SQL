
-- ============================================
-- PARÁMETROS DE ENTRADA (P_) - En orden de uso
-- ============================================
-- P_REPORT_DATE        -- Fecha inicial del reporte (usado en effdate >= y cálculo de saldo anterior)
-- P_END_DATE           -- Fecha final del reporte (usado en effdate <=)
-- P_COMPANY_CODE       -- Código de compañía
-- P_LEVEL_1_FROM             -- Nivel 1 de cuenta (rango desde)
-- P_LEVEL_1_TO           -- Nivel 1 de cuenta (rango hasta)
-- P_LEVEL_2_FROM             -- Nivel 2 de cuenta (rango desde)
-- P_LEVEL_2_TO           -- Nivel 2 de cuenta (rango hasta)
-- P_LEVEL_3_FROM             -- Nivel 3 de cuenta (rango desde)
-- P_LEVEL_3_TO           -- Nivel 3 de cuenta (rango hasta)
-- P_LEVEL_4_FROM             -- Nivel 4 de cuenta (rango desde)
-- P_LEVEL_4_TO           -- Nivel 4 de cuenta (rango hasta)
-- P_LEVEL_5_FROM             -- Nivel 5 de cuenta (rango desde)
-- P_LEVEL_5_TO           -- Nivel 5 de cuenta (rango hasta)
-- P_LEVEL_6_FROM             -- Nivel 6 de cuenta (rango desde)
-- P_LEVEL_6_TO           -- Nivel 6 de cuenta (rango hasta)
-- P_LEVEL_7_FROM             -- Nivel 7 de cuenta (rango desde)
-- P_LEVEL_7_TO           -- Nivel 7 de cuenta (rango hasta)
-- P_LEVEL_8_FROM             -- Nivel 8 de cuenta (rango desde)
-- P_LEVEL_8_TO           -- Nivel 8 de cuenta (rango hasta)
-- P_AUXILIARY_CODE     -- Código auxiliar
-- P_USER               -- Usuario
-- P_AUXILIARY_REF      -- Referencia auxiliar
-- P_CURRENCY_CODE             -- Código de moneda

-- ============================================
-- PARÁMETROS DE SALIDA/COLUMNAS (CP_) - En orden de uso
-- ============================================
-- CP_COMPANY_CODE      -- Código de compañía (usado en funciones CF_ACCOUNT, CF_BALANCE_RUN)
-- CP_DESC_CUENTA       -- Descripción de la cuenta (asignado en CF_ACCOUNT)
-- CP_DEBIT_BALANCE     -- Saldo deudor acumulado (asignado en CF_BALANCE_RUN)
-- CP_CREDIT_BALANCE    -- Saldo acreedor acumulado (asignado en CF_BALANCE_RUN)

-- Q_MOV_ACCOUNTS
SELECT
    a.level_1 level_1,
    a.level_2 level_2,
    a.level_3 level_3,
    a.level_4 level_4,
    a.level_5 level_5,
    a.level_6 level_6,
    a.level_7 level_7,
    a.level_8 level_8,
    a.credit_debit credit_debit,
    DECODE(a.credit_debit, 'D', a.txn_entry_amount) debit_amount,
    DECODE(a.credit_debit, 'C', ABS(a.txn_entry_amount)) credit_amount,
    a.txn_entry_amount txn_entry_amount,
    a.auxiliary_code auxiliary_code,
    a.effdate effdate,
    DECODE(
        a.currency_code,
        e.local_currency_code,
        a.txn_entry_amount,
        a.txn_entry_local_amount
    ) amount,
    a.username username,
    a.txn_entry_nbr txn_entry_nbr,
    a.unit_code unit_code,
    a.txn_entry_date txn_entry_date,
    a.currency_code currency_code,
    a.description_detail detail_description,
    a.exchange_rate exchange_rate,
    a.txn_entry_local_amount txn_entry_local_amount,
    e.local_currency_code local_currency_code,
    a.reference reference,
    a.ref_auxiliary_code ref_auxiliary_code,
    a.presupuesto_code presupuesto_code,
    a.presupuesto_class presupuesto_class
    

FROM
    GM_ANNUAL_TXN_ENTRIES_DETAIL a,
    GM_SETTINGS e
WHERE
    a.effdate >= P_REPORT_DATE
    AND a.effdate <= P_END_DATE
    AND a.level_1 BETWEEN NVL(P_LEVEL_1_FROM, a.level_1)
    AND DECODE(P_LEVEL_1_TO, NULL, DECODE(P_LEVEL_1_FROM, NULL, a.level_1, P_LEVEL_1_FROM), P_LEVEL_1_TO)
    AND a.level_2 BETWEEN NVL(P_LEVEL_2_FROM, a.level_2)
    AND DECODE(P_LEVEL_2_TO, NULL, DECODE(P_LEVEL_2_FROM, NULL, a.level_2, P_LEVEL_2_FROM), P_LEVEL_2_TO)
    AND a.level_3 BETWEEN NVL(P_LEVEL_3_FROM, a.level_3)
    AND DECODE(P_LEVEL_3_TO, NULL, DECODE(P_LEVEL_3_FROM, NULL, a.level_3, P_LEVEL_3_FROM), P_LEVEL_3_TO)
    AND a.level_4 BETWEEN NVL(P_LEVEL_4_FROM, a.level_4)
    AND DECODE(P_LEVEL_4_TO, NULL, DECODE(P_LEVEL_4_FROM, NULL, a.level_4, P_LEVEL_4_FROM), P_LEVEL_4_TO)
    AND a.level_5 BETWEEN NVL(P_LEVEL_5_FROM, a.level_5)
    AND DECODE(P_LEVEL_5_TO, NULL, DECODE(P_LEVEL_5_FROM, NULL, a.level_5, P_LEVEL_5_FROM), P_LEVEL_5_TO)
    AND a.level_6 BETWEEN NVL(P_LEVEL_6_FROM, a.level_6)
    AND DECODE(P_LEVEL_6_TO, NULL, DECODE(P_LEVEL_6_FROM, NULL, a.level_6, P_LEVEL_6_FROM), P_LEVEL_6_TO)
    AND a.level_7 BETWEEN NVL(P_LEVEL_7_FROM, a.level_7)
    AND DECODE(P_LEVEL_7_TO, NULL, DECODE(P_LEVEL_7_FROM, NULL, a.level_7, P_LEVEL_7_FROM), P_LEVEL_7_TO)
    AND a.level_8 BETWEEN NVL(P_LEVEL_8_FROM, a.level_8)
    AND DECODE(P_LEVEL_8_TO, NULL, DECODE(P_LEVEL_8_FROM, NULL, a.level_8, P_LEVEL_8_FROM), P_LEVEL_8_TO)
    AND a.company_code = P_COMPANY_CODE
    AND (a.auxiliary_code = NVL(P_AUXILIARY_CODE, a.auxiliary_code) OR a.auxiliary_code IS NULL)
    AND a.username = NVL(P_USER, a.username)
    AND (a.ref_auxiliary_code = P_AUXILIARY_REF OR P_AUXILIARY_REF IS NULL)
    AND a.currency_code = NVL(P_CURRENCY_CODE, a.currency_code)
    AND e.company_code = a.company_code
ORDER BY
    a.level_1,
    a.level_2,
    a.level_3,
    a.level_4,
    a.level_5,
    a.level_6,
    a.level_7,
    a.level_8,
    a.currency_code,
    a.effdate,
    a.txn_entry_date,
    a.username,
    a.txn_entry_nbr,
    a.line_seq;


-- FUNCIONES:
-- F_CF_Cuenta
function CF_ACCOUNT return VARCHAR2 is
  LV_ACCOUNT VARCHAR2(39);
  LV_DESCRIPTION Varchar2(80) := Null;
BEGIN
	
  GM_P_DESPLEGAR_R(
    Q_MOV_ACCOUNTS.LEVEL_1,
    Q_MOV_ACCOUNTS.LEVEL_2,
    Q_MOV_ACCOUNTS.LEVEL_3,
    Q_MOV_ACCOUNTS.LEVEL_4,
    Q_MOV_ACCOUNTS.LEVEL_5,
    Q_MOV_ACCOUNTS.LEVEL_6,
    Q_MOV_ACCOUNTS.LEVEL_7,
    Q_MOV_ACCOUNTS.LEVEL_8,
    CP_COMPANY_CODE,
    LV_ACCOUNT
  );

begin
  Select DESCRIPTION
    Into LV_DESCRIPTION
    From GM_ACCOUNT_BALANCE
   Where COMPANY_CODE = CP_COMPANY_CODE
     and LEVEL_1        = Q_MOV_ACCOUNTS.LEVEL_1
     and LEVEL_2        = Q_MOV_ACCOUNTS.LEVEL_2
     and LEVEL_3        = Q_MOV_ACCOUNTS.LEVEL_3
     and LEVEL_4        = Q_MOV_ACCOUNTS.LEVEL_4
     and LEVEL_5        = Q_MOV_ACCOUNTS.LEVEL_5
     and LEVEL_6        = Q_MOV_ACCOUNTS.LEVEL_6
     and LEVEL_7        = Q_MOV_ACCOUNTS.LEVEL_7
     and LEVEL_8        = Q_MOV_ACCOUNTS.LEVEL_8;
Exception
	When No_data_Found Then
	  LV_DESCRIPTION :=  'No Accounting Account Exists';
	When Others Then
	  LV_DESCRIPTION :=  '';
end;
  CP_DESC_CUENTA := LV_DESCRIPTION;
  RETURN(LV_ACCOUNT);
END;


-- F_INICIO_MES
function CF_BF_BALANCE return Number is

 LN_BF_BALANCE  Number(17,2) := 0;
 LN_DAY		      NUMBER(2) := 0;
 LN_MONTH       NUMBER(2) := 0;
 LN_YEAR        NUMBER(4) := 0;

BEGIN

  LN_DAY    := TO_CHAR(P_REPORT_DATE, 'DD');
  LN_MONTH  := TO_CHAR(P_REPORT_DATE, 'MM');
  LN_YEAR   := TO_CHAR(P_REPORT_DATE, 'YYYY');
 
  IF LN_DAY = 1 and LN_MONTH != 1 THEN 
     LN_MONTH := LN_MONTH - 1;

  SELECT TO_NUMBER( SUBSTR (to_char(LAST_DAY (ADD_MONTHS (P_REPORT_DATE, -1) ), 'DDMMYYY'), 1, 2) )
  INTO  LN_DAY
  FROM DUAL;
 
  ELSIF LN_DAY = 1 and LN_MONTH = 1 THEN
     LN_YEAR := LN_YEAR - 1;
     LN_MONTH := 12;

    SELECT TO_NUMBER( SUBSTR (to_char(LAST_DAY (ADD_MONTHS (P_REPORT_DATE, -1) ), 'DDMMYYY'), 1, 2) )
    INTO  LN_DAY
    FROM DUAL;

  ELSE
      LN_DAY := LN_DAY - 1;
  END IF;
   
   BEGIN
      SELECT Decode(
        LN_DAY,1,nvl(DAY_1_BALANCE,0),2,nvl(DAY_2_BALANCE,0),3,nvl(DAY_3_BALANCE,0),4,nvl(DAY_4_BALANCE,0),
        5,nvl(DAY_5_BALANCE,0),6,nvl(DAY_6_BALANCE,0),7,nvl(DAY_7_BALANCE,0),8,nvl(DAY_8_BALANCE,0),
        9,nvl(DAY_9_BALANCE,0),10,nvl(DAY_10_BALANCE,0),11,nvl(DAY_11_BALANCE,0),12,nvl(DAY_12_BALANCE,0),
        13,nvl(DAY_13_BALANCE,0),14,nvl(DAY_14_BALANCE,0),15,nvl(DAY_15_BALANCE,0),16,nvl(DAY_16_BALANCE,0),
        17,nvl(DAY_17_BALANCE,0),18,nvl(DAY_18_BALANCE,0),19,nvl(DAY_19_BALANCE,0),20,nvl(DAY_20_BALANCE,0),
        21,nvl(DAY_21_BALANCE,0),22,nvl(DAY_22_BALANCE,0),23,nvl(DAY_23_BALANCE,0),24,nvl(DAY_24_BALANCE,0),
        25,nvl(DAY_25_BALANCE,0),26,nvl(DAY_26_BALANCE,0),27,nvl(DAY_27_BALANCE,0),28,nvl(DAY_28_BALANCE,0),
        29,nvl(DAY_29_BALANCE,0),30,nvl(DAY_30_BALANCE,0),31,nvl(DAY_31_BALANCE,0)) 

      INTO   LN_BF_BALANCE
      FROM   GM_BALANCES_DAILY
      WHERE  COMPANY_CODE = CP_COMPANY_CODE
      AND    LEVEL_1      =  Q_MOV_ACCOUNTS.LEVEL_1
      AND    LEVEL_2      =  Q_MOV_ACCOUNTS.LEVEL_2
      AND    LEVEL_3      =  Q_MOV_ACCOUNTS.LEVEL_3
      AND    LEVEL_4      =  Q_MOV_ACCOUNTS.LEVEL_4
      AND    LEVEL_5      =  Q_MOV_ACCOUNTS.LEVEL_5
      AND    LEVEL_6      =  Q_MOV_ACCOUNTS.LEVEL_6
      AND    LEVEL_7      =  Q_MOV_ACCOUNTS.LEVEL_7
      AND    LEVEL_8      =  Q_MOV_ACCOUNTS.LEVEL_8
      AND    YEAR         =  LN_YEAR
      AND    MONTH        =  LN_MONTH;
	    Return NVL(LN_BF_BALANCE, 0);
    EXCEPTION
    WHEN no_data_found THEN
      RETURN(0);    
    WHEN OTHERS THEN
      RETURN(0);
    END;

    RETURN 0; 
END;



--F_codigo_moneda

function CF_CURRENCY_CODE return Number is
 LN_CURRENCY_CODE NUMBER;
begin
 IF Q_MOV_ACCOUNTS.CURRENCY_CODE IS NULL THEN
    BEGIN
      SELECT G.LOCAL_CURRENCY_CODE
      INTO   LN_CURRENCY_CODE
      FROM   GM_SETTINGS G;
    EXCEPTION 
       WHEN OTHERS THEN 
      RETURN 0;
    END;
 ELSE
   LN_CURRENCY_CODE := Q_MOV_ACCOUNTS.CURRENCY_CODE;
 END IF;
 RETURN NVL(LN_CURRENCY_CODE, 0);
end;



-- F_desc_moneda
function CF_DESC_CURRENCY return VARCHAR2 is
  LV_CURRENCY VARCHAR2(200);
begin
  IF Q_MOV_ACCOUNTS.CURRENCY_CODE IS NOT NULL THEN
     BEGIN
        SELECT C.DESCRIPTION
        INTO   LV_CURRENCY
        FROM   MG_CURRENCY C
        WHERE  C.CURRENCY_CODE = Q_MOV_ACCOUNTS.CURRENCY_CODE;
     EXCEPTION 
        WHEN OTHERS THEN 
        RETURN '';
     END;
  END IF;
  RETURN NVL(LV_CURRENCY, '');
end;



-- F_tasa
FUNCTION CF_EXCHANGE_RATE return Number is
BEGIN
  IF Q_MOV_ACCOUNTS.CURRENCY_CODE != 1 THEN
    RETURN( ABS(Q_MOV_ACCOUNTS.EXCHANGE_RATE) );
ELSE 
    RETURN(0);
END IF;  
  RETURN 0; 
END;


-- F_1
FUNCTION CF_RUN_AMOUNT return Number is
BEGIN

  RETURN nvl(ABS(Q_MOV_ACCOUNTS.TXN_ENTRY_AMOUNT), 0);

END;


-- F_monto_debito
function CF_MOV_DEBIT return Number is
BEGIN
  IF Q_MOV_ACCOUNTS.CREDIT_DEBIT = 'D' THEN
    IF Q_MOV_ACCOUNTS.CURRENCY_CODE = Q_MOV_ACCOUNTS.LOCAL_CURRENCY_CODE THEN
      RETURN(Q_MOV_ACCOUNTS.TXN_ENTRY_AMOUNT);
    ELSE
      RETURN(Q_MOV_ACCOUNTS.TXN_ENTRY_LOCAL_AMOUNT);
    END IF;
 ELSE
    RETURN(0);
 END IF;
  RETURN 0; 
end;


-- F_monto_credito
function CF_MOV_CREDIT return Number is
begin
IF Q_MOV_ACCOUNTS.CREDIT_DEBIT = 'C' THEN
    IF Q_MOV_ACCOUNTS.CURRENCY_CODE = Q_MOV_ACCOUNTS.LOCAL_CURRENCY_CODE THEN
       RETURN(Q_MOV_ACCOUNTS.TXN_ENTRY_AMOUNT);
    ELSE
      RETURN(Q_MOV_ACCOUNTS.TXN_ENTRY_LOCAL_AMOUNT);
    END IF;
  ELSE
      RETURN(0);   
  END IF;
  RETURN 0; 
end;

function CF_RUN2_BALANCE return Number is
begin
  IF Q_MOV_ACCOUNTS.CURRENCY_CODE = Q_MOV_ACCOUNTS.LOCAL_CURRENCY_CODE THEN
     IF Q_MOV_ACCOUNTS.CREDIT_DEBIT = 'D' THEN
      RETURN(ABS(Q_MOV_ACCOUNTS.TXN_ENTRY_AMOUNT)); --txn_entry_amount
     ELSE
       RETURN(ABS(Q_MOV_ACCOUNTS.TXN_ENTRY_AMOUNT) * (-1));
     END IF;
  ELSE
     IF Q_MOV_ACCOUNTS.CREDIT_DEBIT = 'D' THEN
      RETURN(ABS(Q_MOV_ACCOUNTS.TXN_ENTRY_LOCAL_AMOUNT));
     ELSE
       RETURN(ABS(Q_MOV_ACCOUNTS.TXN_ENTRY_LOCAL_AMOUNT) * (-1));
     END IF;
  END IF;
  RETURN 0; 
end;



function CF_BALANCE_RUN return Number is
Lv_ErrorCode            VARCHAR2(100);
Lv_Nature_Cta	          varchar2(1);
Current_Balance		      NUMBER(17,2);
begin
 Lv_ErrorCode := GM_F_NATURALEZA_CUENTA(P_COMPANY_CODE,
					Q_MOV_ACCOUNTS.level_1, 
					Q_MOV_ACCOUNTS.level_2,   
					Q_MOV_ACCOUNTS.level_3,
					Q_MOV_ACCOUNTS.level_4,
					Q_MOV_ACCOUNTS.level_5,
					Q_MOV_ACCOUNTS.level_6,
					Lv_Nature_Cta);
  IF  (Lv_Nature_Cta = 'D')  THEN
    Current_Balance := CF_BF_BALANCE + CS_SALDO_RUN;

    if Current_Balance < 0 then
     CP_CREDIT_BALANCE := abs(Current_Balance);
     CP_DEBIT_BALANCE   :=0;
    elsif Current_Balance > 0 then
     CP_DEBIT_BALANCE    := abs(Current_Balance);
     CP_CREDIT_BALANCE  := 0;
    else
     CP_DEBIT_BALANCE := 0;
     CP_CREDIT_BALANCE := 0;
    end if;

  ELSIF (Lv_Nature_Cta = 'C')  THEN  
    Current_Balance:= CF_BF_BALANCE - CS_SALDO_RUN;
   if Current_Balance   > 0 then
     CP_CREDIT_BALANCE := abs(Current_Balance);
     CP_DEBIT_BALANCE   :=0;
    elsif Current_Balance < 0 then
     CP_DEBIT_BALANCE    := abs(Current_Balance);
     CP_CREDIT_BALANCE  := 0;
    else
     CP_DEBIT_BALANCE := 0;
     CP_CREDIT_BALANCE := 0;
    end if;

  END IF;

  RETURN(Current_Balance);
end;