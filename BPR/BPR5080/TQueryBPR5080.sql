-- Q_COMP_AUX_MAYOR_BPR
select a.COMPANY_CODE, 
           decode(p.QUANTITY_BY_BRANCH,'S',a.BRANCH_CODE,p.BASE_BRANCH_CODE) BRANCH_CODE,
           decode(p.QUANTITY_BY_SUBAPPLICATION,'S',a.SUBAPPLICATION_CODE,p.BASE_SUBAPPLICATION_CODE) SUBAPPLICATION_CODE,
          CURRENCY_CODE,
          nvl(SUM(round(VALUE,2)),0) CAPITAL
 FROM    PR_LOANS A,                
               PR_LOAN_BALANCES C, 
               PR_PORTFOLIO_PARAMETERS P,
               PR_BALANCE_TYPES D,
               MG_SUBAPPLICATIONS S,
               MG_SCHEDULE b
 WHERE a.STATE = 1
  and  nvl(A.TYPE_CODE,0)                     !=   3
  and  a.COMPANY_CODE = p.COMPANY_CODE
  AND S.COMPANY_CODE                = A.COMPANY_CODE
  AND  S.APPLICATION_CODE                  = A.APPLICATION_CODE
  AND S.SUBAPPLICATION_CODE         = A.SUBAPPLICATION_CODE
  AND S.CURRENCY_CODE                        = NVL(P_CURRENCY,S.CURRENCY_CODE) 
/********************/
  AND C.LOAN_NBR             = A.LOAN_NBR
  AND C.SUBAPPLICATION_CODE     = A.SUBAPPLICATION_CODE
  AND C.BRANCH_CODE                    = A.BRANCH_CODE
  AND C.COMPANY_CODE                  = A.COMPANY_CODE
  AND C.BALANCE_TYPE_CODE             = D.BALANCE_TYPE_CODE
  AND D.REPAYMENT_TYPE = 'C'
/********************/
  AND  B.APPLICATION_CODE              =  'BPR'
 GROUP BY  a.COMPANY_CODE, 
           decode(p.QUANTITY_BY_BRANCH,'S',a.BRANCH_CODE,p.BASE_BRANCH_CODE) ,
           decode(p.QUANTITY_BY_SUBAPPLICATION,'S',a.SUBAPPLICATION_CODE,p.BASE_SUBAPPLICATION_CODE) ,
          CURRENCY_CODE

-- -- Funciones:
-- F_CF_nom_agen
function CF_NAME_AGENT return VARCHAR2 is
  name MG_BRANCHES_GENERAL.BRANCH_NAME%type;
begin
  begin
   Select BRANCH_NAME into name from MG_BRANCHES_GENERAL
   where BRANCH_CODE = Q_COMP_AUX_MAYOR_BPR.BRANCH_CODE
   and COMPANY_CODE = Q_COMP_AUX_MAYOR_BPR.COMPANY_CODE;
   exception
     when others then null;
  end;
  return(name);
end;
return '';

-- F_CF_NOM_SUBAPLI
function CF_NAME_SUBAPLI return VARCHAR2 is
  name MG_SUBAPPLICATIONS.DESCRIPTION%type;
begin
   begin
      Select DESCRIPTION into name from MG_SUBAPPLICATIONS
      Where APPLICATION_CODE     = 'BPR'
      And   SUBAPPLICATION_CODE = Q_COMP_AUX_MAYOR_BPR.SUBAPPLICATION_CODE;
     exception
       when others then null;
   end;
  return(name);
end;
return '';

-- F_Capital
function CF_CAPITAL return Number is
  LN_CREDIT        NUMBER;
  LN_CREDIT2       NUMBER;
  capital           number;
  ExchangeRateDate   Date;
  SourceExchangeRate  Number;
  DestinationExchangeRate Number;
  ExchangeRate        Number;
  ExchangeDifference  Number;
  ProfitLoss   Number;
  Ln_DestinationAmount   Number;
  Lv_Message        Varchar2(2000);
  Ln_ForeignAmount Number;
begin

  Ln_DestinationAmount := :capital ;--+ LN_CREDIT;
	
	If Q_COMP_AUX_MAYOR_BPR.CURRENCY_CODE != :P_LOCAL_CURRENCY Then
		Ln_ForeignAmount := Ln_DestinationAmount ;
	 
		Ln_DestinationAmount    := 0;
    Mg_P_CambioMoneda ( :CP_COMPANY_CODE,
                 				Q_COMP_AUX_MAYOR_BPR.CURRENCY_CODE,
		                :P_LOCAL_CURRENCY,
		                   1, -- TipoContable
		                ExchangeRateDate,
		                :P_PROCESS_DATE,
		  		              SourceExchangeRate,
		  		              DestinationExchangeRate,
		                ExchangeRate,
		                Ln_ForeignAmount,
		                Ln_DestinationAmount,
		                ExchangeDifference,
		                ProfitLoss,
		                Lv_Message);	
				 
End If;
	:cp_foreign_balance := Ln_ForeignAmount;
  RETURN(Ln_DestinationAmount);  
  
  
  -- F_CF_mayor
function CF_LEDGERBALANCE return Number is
  LedgerBalance Number;
begin
  begin
  select  nvl(SUM(NVL(F.BALANCE_CURRENT,0)),0) 
  Into LedgerBalance
  FROM    GM_ACCOUNT_BALANCE  F
  WHERE F.ACCOUNT  IN
               (SELECT DISTINCT
                   E.ACCOUNT_CONT_LEVEL_1||E.ACCOUNT_CONT_LEVEL_2||E.ACCOUNT_CONT_LEVEL_3||
                   E.ACCOUNT_CONT_LEVEL_4||E.ACCOUNT_CONT_LEVEL_5||E.ACCOUNT_CONT_LEVEL_6||
                   E.ACCOUNT_CONT_LEVEL_7||E.ACCOUNT_CONT_LEVEL_8
                FROM PR_ACCOUNTING_PARAMETER_DETAIL E, PR_BALANCE_TYPES B,PR_PORTFOLIO_PARAMETERS
                WHERE E.BALANCE_TYPE_CODE         = B.BALANCE_TYPE_CODE
                AND   B.REPAYMENT_TYPE                = 'C'
                and   e.TYPE_CODE != 3
                AND   B.BALANCE_TYPE                IS NOT NULL
                AND   E.COMPANY_CODE            = Q_COMP_AUX_MAYOR_BPR.COMPANY_CODE
                AND   E.BRANCH_CODE            = Q_COMP_AUX_MAYOR_BPR.BRANCH_CODE
                AND   E.SUBAPPLICATION_CODE     = Q_COMP_AUX_MAYOR_BPR.SUBAPPLICATION_CODE )
  AND   F.COMPANY_CODE            = :company_code;

 exception 
  when others then null;
 end;
 return(LedgerBalance);
end;
return '';

-- F_1
function CF_DIF return Number is
  LedgerBalance Number;
  difference number;
begin
 difference := (CF_LEDGERBALANCE - CF_CAPITAL);
 return(difference);
end;
