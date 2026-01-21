-- Q_MOVIMIENTOS --> Q_MOVEMENTS 

-- HAY QUE MODIFICAR ESTE REPORTE MAS ADELANTE
SELECT
    h.CLIENT_CODE AS CLIENT_CODE,
    h.RELATION_Y_O AS RELATION_Y_O,
    d.CLIENT_CODE,
    b.BANK_NAME AS BANK_NAME,
    (
        A.BRANCH_CODE || '-' || A.SUBAPPLICATION_CODE || '-' || A.DEPOSIT_NBR
    ) AS DEPOSIT_NBR,
    A.EFFECTIVE_DATE AS EFFECTIVE_DATE,
    A.DUE_DATE AS DUE_DATE,
    B.VALUE AS VALUE,
    A.ADDED_BY AS ADDED_BY,
    A.VALUE_DATE AS VALUE_DATE,
    A.DEPOSIT_NBR AS DEPOSIT_NBR,
    A.BRANCH_CODE AS BRANCH_CODE,
    A.SUBAPPLICATION_CODE AS SUBAPPLICATION_CODE,
    A.APPLICATION_CODE AS APPLICATION_CODE,
    B.PAYMENT_TYPE_CODE AS PAYMENT_TYPE_CODE,
    B.CONTRA_BRANCH_CODE AS CONTRA_BRANCH_CODE,
    B.SUBAPPLICATION_QUANTITYER_CODE AS SUBAPPLICATION_QUANTITYER_CODE,
    B.CONTRA_ACCOUNT_CODE AS CONTRA_ACCOUNT_CODE,
    E.DESCRIPTION AS DESCRIPTION,
    F.ADDRESS_CODE AS ADDRESS_CODE,
    A.MAIN_OWNER_CODE AS MAIN_OWNER_CODE,
    F.ZONE || F.DISTRICT || F.STREET AS ADDRESS,
    G.VALUE AS NEW_BALANCE,
    G.VALUE - A.VALUE AS PREVIOUS_BALANCE,
    B.REFERENCE_CHECK_NBR AS REFERENCE_CHECK_NBR,
    DECODE (
        A.MATHEMATICAL_OPERATOR,
        '-',
        (A.RATE_VALUE - NVL (A.SPREAD, 0)),
        '+',
        (A.RATE_VALUE + NVL (A.SPREAD, 0))
    ) AS RATE_VALUE,
    M.ABBREVIATION
FROM
    DP_TXN_ENTRIES_DAILY A,
    DP_TXN_ENTRIES_BREAKDOWN B,
    MG_CLIENTS D,
    MG_DISBURSEMENT_PAYMENT_METHODS E,
    MG_ADDRESSES F,
    DP_ACCT_BALANCES G,
    MG_SUBAPPLICATIONS S,
    MG_CURRENCY M,
    DP_OWNERS h
WHERE
    (
        A.DEPOSIT_NBR = P_DEPOSIT_NBR
        OR P_DEPOSIT_NBR IS NULL
    )
    AND (
        A.TXN_ENTRY_NBR = P_TXN_ENTRY_NBR
        OR P_TXN_ENTRY_NBR IS NULL
    )
    AND (
        A.BRANCH_CODE = P_BRANCH_CODE
        OR P_BRANCH_CODE IS NULL
    )
    AND (
        A.ADDED_BY = P_USER_CODE
        OR P_USER_CODE IS NULL
    )
    AND A.TXN_ENTRY_NBR = B.TXN_ENTRY_NBR
    AND A.BRANCH_CODE = B.BRANCH_CODE
    AND A.SUBAPPLICATION_CODE = B.SUBAPPLICATION_CODE
    AND A.DEPOSIT_NBR = B.DEPOSIT_NBR
    AND A.COMPANY_CODE = B.COMPANY_CODE
    AND A.MAIN_OWNER_CODE = D.CLIENT_CODE
    AND D.CLIENT_CODE = F.CLIENT_CODE (+)
    AND D.CLIENT_CODE = H.CLIENT_CODE
    AND A.TRANSACTION_TYPE_CODE = 17
    AND B.PAYMENT_TYPE_CODE = E.PAYMENT_TYPE_CODE
    AND B.APPLICATION_CODE = E.APPLICATION_CODE
    AND A.DEPOSIT_NBR = G.DEPOSIT_NBR
    AND A.SUBAPPLICATION_CODE = G.SUBAPPLICATION_CODE
    AND A.BRANCH_CODE = G.BRANCH_CODE
    AND A.COMPANY_CODE = G.COMPANY_CODE
    AND G.BALANCE_TYPE_CODE = 1
    AND A.STATE <> 5
    AND A.SUBAPPLICATION_CODE = S.SUBAPPLICATION_CODE
    AND A.APPLICATION_CODE = S.APPLICATION_CODE
    AND S.CURRENCY_CODE = M.CURRENCY_CODE

    
    -- Q_PROPIETARIOS --> Q_OWNERS
SELECT
    CLIENT_CODE AS CLIENT_CODE,
    ACCOUNT_CODE AS DEPOSIT_NBR,
    BRANCH_CODE AS BRANCH_CODE,
    SUBAPPLICATION_CODE AS SUBAPPLICATION_CODE,
    APPLICATION_CODE AS APPLICATION_CODE,
    RELATION_Y_O AS RELATION_Y_O
FROM
    DP_OWNERS

-- funciones:
-- F_FECHA_HOY 10
function CF_CURRENT_DATE return Date is
Ld_CurrentDate date;
begin
  SELECT TODAY_DATE INTO Ld_CurrentDate
  FROM MG_SCHEDULE
  WHERE COMPANY_CODE    = P_COMPANY_CODE
  AND   APPLICATION_CODE = 'BDP';
  RETURN Ld_CurrentDate;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;


-- F_DESCRIPCION 30
function CF_DESCRIPTION return VARCHAR2 is
Ln_description       varchar2(80);
begin

   if Q_MOVEMENTS.PAYMENT_TYPE_CODE in (1,2,3,4) then
      ln_description :=  Q_MOVEMENTS.DESCRIPTION||' '||to_char(Q_MOVEMENTS.CONTRA_BRANCH_CODE)||'-'||
  		         to_char(Q_MOVEMENTS.SUBAPPLICATION_QUANTITYER_CODE)||'-'||
			 to_char(Q_MOVEMENTS.CONTRA_ACCOUNT_CODE);
   end if;
 
   if Q_MOVEMENTS.PAYMENT_TYPE_CODE in (14,15) then
      ln_description := Q_MOVEMENTS.BANK_NAME||' '||Q_MOVEMENTS.REFERENCE_CHECK_NBR;
   end if;
   if Q_MOVEMENTS.PAYMENT_TYPE_CODE in (8,16,19) then
      ln_description := Q_MOVEMENTS.DESCRIPTION||' '||Q_MOVEMENTS.REFERENCE_CHECK_NBR;
   end if;

   if Q_MOVEMENTS.PAYMENT_TYPE_CODE = 13 then
      ln_description := Q_MOVEMENTS.DESCRIPTION||' '||Q_MOVEMENTS.REFERENCE_CHECK_NBR||' '||'Acct. '||
                        to_char(Q_MOVEMENTS.CONTRA_BRANCH_CODE)||'-'||
  		        to_char(Q_MOVEMENTS.SUBAPPLICATION_QUANTITYER_CODE)||'-'||
			to_char(Q_MOVEMENTS.CONTRA_ACCOUNT_CODE);
   end if;
   return(ln_description);
      
end;


-- F_VALOR_MONTO 40
function CF_VALUE return VARCHAR2 is
 Lv_amount    varchar2(25);
begin
Lv_amount := Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(Q_MOVEMENTS.VALUE,0),'999,999,999,999,990.00')); 
  return(Lv_amount);
end;


-- F_saldoanterior 80
function CF_PREVIOUS_BALANCE return VARCHAR2 is
Ln_Total_Balance_Prev   number(18,2);
Lv_PreviousBalance     varchar2(30);
begin
  Ln_Total_Balance_Prev := nvl(cf_total_balance,0) - nvl(cs_sum_amount,0); 
  Lv_PreviousBalance :=  Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(Ln_Total_Balance_Prev,0),'999,999,999,999,990.00')); 
  RETURN(Lv_PreviousBalance);
end;


-- F_nuevo_saldo 90
function CF_NEW_BALANCE return VARCHAR2 is
Lv_total_balance   varchar2(30);
begin
  Lv_total_balance :=  Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(cf_total_balance,0),'999,999,999,999,990.00')); 
  RETURN(Lv_total_balance);
end;


-- F_amento_capital 100
function CF_CAPITAL_INCREASE return VARCHAR2 is
 Lv_amount    varchar2(25);
begin
Lv_amount := Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(CS_SUM_AMOUNT,0),'999,999,999,999,990.00')); 
  return(Lv_amount);
end;


-- F_CLIENTE
function CF_CLIENT return VARCHAR2 is
Gv_ClientName       varchar2(130);
Gv_ErrorCode         varchar2(80);
begin
  DP_P_OBTIENE_NOMBRE_CLIENTE(Q_MOVEMENTS.MAIN_OWNER_CODE,
		               Gv_ClientName,
                               Gv_ErrorCode);
   IF Gv_ErrorCode <> null THEN
      NULL;
   END IF;
   return (Gv_ClientName);
end;


-- F_1
function CF_OWNERS return VARCHAR2 is
Gv_ClientName       varchar2(130);
Gv_ErrorCode         varchar2(80);
begin
  DP_P_OBTIENE_NOMBRE_CLIENTE(Q_OWNERS.CLIENT_CODE,
		               Gv_ClientName,
                               Gv_ErrorCode);
   IF Gv_ErrorCode <> null THEN
      NULL;
   END IF;
   return (Gv_ClientName);
end;


-- F_DIRECCION 140
function CF_ADDRESS return VARCHAR2 is
Gv_Address     varchar2(200);
Gv_ErrorCode   varchar2(200);
   
BEGIN
     CF_GET_ADDRESS(Q_MOVEMENTS.MAIN_OWNER_CODE,cf_correspondence,  
		           Gv_Address, Gv_ErrorCode);
     return(Gv_Address);
     if Gv_ErrorCode is not null then
        null;
     end if;
RETURN NULL; end;

--CF_OBTIENE_DIRECCION
PROCEDURE CF_GET_ADDRESS (Gn_ClientCode in number,
                                  Gf_CorrespondenceType in number,
                                  GV_ADDRESS OUT VARCHAR2,
                                  GV_ERROR_CODE IN OUT VARCHAR2) IS
LV_ADDRESS  VARCHAR2(200);
BEGIN
SELECT
SUBSTR(NOMENCLATURE,1,40) CLIENT_ADDRESS1
INTO LV_ADDRESS
 
FROM   MG_ADDRESSES  
WHERE   CLIENT_CODE = Gn_ClientCode
AND     ADDRESS_CODE = Gf_CorrespondenceType;
 
 GV_ADDRESS := LV_ADDRESS;
 EXCEPTION
	WHEN NO_DATA_FOUND THEN
		GV_ERROR_CODE := mg_k_ctrl_error.mg_f_armar_codigo_error(1223,'MG_ADDRESSES Table',NULL);
	  return;  
 	WHEN others THEN
	  GV_ERROR_CODE := mg_k_ctrl_error.mg_f_armar_codigo_error(00000,sqlerrm,'PU_P_GET_ADDRESS');
	  return;  
  
END;


-- cf_saldototalFormula:
function CF_TOTAL_BALANCE return Number is
Ln_Total_Balance number(18,2);
Ln_Retained_Balance number(18,2);
begin
 Select nvl(VALUE,0) 
 into Ln_Retained_Balance 
 FROM DP_ACCT_BALANCES 
 WHERE DEPOSIT_NBR = Q_MOVEMENTS.DEPOSIT_NBR and
       BRANCH_CODE  = Q_MOVEMENTS.BRANCH_CODE  and
       SUBAPPLICATION_CODE = Q_MOVEMENTS.SUBAPPLICATION_CODE and
       APPLICATION_CODE     = 'BDP' and
       BALANCE_TYPE_CODE     = 10;
 --
       Ln_Total_Balance := Q_MOVEMENTS.NEW_BALANCE;
 --
       RETURN(Ln_Total_Balance);
RETURN NULL; Exception When Others Then 
	Ln_Retained_Balance := 0;
        Ln_Total_Balance    := nvl(Ln_Retained_Balance,0) + nvl(Q_MOVEMENTS.NEW_BALANCE,0);     
        RETURN(Ln_Total_Balance);
end;

-- CF_correspondenciaFormula:
function CF_CORRESPONDENCE return Number is
Ln_correspondence   number(2);
begin
  select CORRESPONDENCE_TYPE_CODE
  into   Ln_correspondence
  from   DP_TERMS_DEPOSITS
  where  DEPOSIT_NBR = Q_MOVEMENTS.DEPOSIT_NBR
  and    BRANCH_CODE = Q_MOVEMENTS.BRANCH_CODE
  and    SUBAPPLICATION_CODE = Q_MOVEMENTS.SUBAPPLICATION_CODE
  and    APPLICATION_CODE = Q_MOVEMENTS.APPLICATION_CODE
  and    COMPANY_CODE = P_COMPANY_CODE;
  return(Ln_correspondence);
RETURN NULL; exception
  when no_data_found then
       null;
  RETURN NULL; when others then 
       null;
RETURN NULL; end;
