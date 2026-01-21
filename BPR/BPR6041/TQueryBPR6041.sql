-- Q_1:
select
p.TYPE_CODE AS TYPE_CODE_T,
s.CURRENCY_CODE AS CURRENCY_CODE_T ,
'TOTAL IN '||m.DESCRIPTION AS currency_desc_t,
SUM(decode(t.REPAYMENT_TYPE,'C',a.VALUE,0)) AS balance_t
from 
PR_LOANS p,
PR_LOAN_BALANCES a,
MG_SUBAPPLICATIONS s,
MG_CURRENCY m,
PR_LOAN_CLASS_CD l,
PR_BALANCE_TYPES t,
MG_BOARDS z
where p.LOAN_NBR = a.LOAN_NBR
and p.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
and p.BRANCH_CODE = a.BRANCH_CODE
and p.COMPANY_CODE = a.COMPANY_CODE
and p.REVISION_DATE_INT between nvl(P_DATE_FROM,p.REVISION_DATE_INT) and nvl(P_DATE_TO,p.REVISION_DATE_INT)
and a.BALANCE_TYPE_CODE = t.BALANCE_TYPE_CODE
and t.REPAYMENT_TYPE in ('C','I')
----------------------------------------------------------------
and s.COMPANY_CODE = p.COMPANY_CODE
and s.APPLICATION_CODE = 'BPR'
and s.SUBAPPLICATION_CODE = p.SUBAPPLICATION_CODE
------------------------------------------------------
and s.CURRENCY_CODE = m.CURRENCY_CODE
and s.CURRENCY_CODE = nvl(P_CURRENCY,s.CURRENCY_CODE)
------------------------------------------------------
and p.BANCA_CODE = z.BANCA_CODE
and z.BANK_TYPE = nvl(P_BANKING,z.BANK_TYPE)
and p.TYPE_CODE = l.TYPE_CODE
and p.TYPE_CODE =  nvl(P_LOAN_CLASS,p.TYPE_CODE)
------------------------------------------------------
and p.TASA_TYPE <> '0'
and p.STATE = '1'
------------------- Fideicomiso ---------------
and p.BANCA_CODE = nvl(P_BOARD_CODE,p.BANCA_CODE)
and nvl(p.PRODUCT_ID,0) = nvl(P_PRODUCT_KEY,nvl(p.PRODUCT_ID,0))
and p.SUBAPPLICATION_CODE = nvl(P_SUBAPPLICATION,p.SUBAPPLICATION_CODE)
-------------------------------------------------------
group by
p.TYPE_CODE,
s.CURRENCY_CODE ,
'TOTAL IN '||m.DESCRIPTION


-- Q_2:
select
z.BANCA_CODE AS board_code, 
z.BANK_TYPE AS bank_type,
z.DESCRIPTION AS board_desc,
p.COMPANY_CODE AS company_code, 
p.BRANCH_CODE AS branch_code, 
p.SUBAPPLICATION_CODE AS subapplication_code, 
p.CONTRACT_NBR AS contract_number,
p.LOAN_NBR AS loan_number,
p.BASE_CURRENT_INT_RATE AS base_current_rate,
p.MATHEMATICAL_RELATION_1 AS math_relation_1,
p.CURRENT_SPREAD_1 AS current_spread_1,
p.MATHEMATICAL_RELATION_2 AS math_relation_2,
p.CURRENT_SPREAD_2 AS current_spread_2,
p.TOTAL_QUANTITY AS total_rate,
P.FLOOR_RATE AS floor_rate,
P.CHANGE_RATE_CUTOFF_DATE AS rate_change_deadline,
P.PROMOTION_CODE AS promotion_code, 
p.REVISION_FREQUENCY_TYPE AS rate_review_frequency,
p.PERIOD_RATE AS rate_period,
p.REVISION_DATE_INT AS rate_review_date_int,
p.DATE_INTEREST_RATE_LAST_REVISION AS last_rate_review_date,
p.TYPE_CODE AS loan_class_code,
nvl(l.DESCRIPTION,'LOAN CLASS NOT DEFINED') AS loan_class_desc,
s.CURRENCY_CODE AS currency_code,
m.DESCRIPTION AS currency_desc,
p.PORTFOLIO_RATE_VALUE_CODE AS rate_group_code,
r.DESCRIPTION AS rate_group_desc,
p.AMORTIZATION_TYPE_CODE AS amortization_type_code,
n.DESCRIPTION AS amortization_desc,
d.CREDIT_LINE_CODE AS credit_line_code,
d.LC_BRANCH_CODE AS credit_line_branch,
d.SUBAPPLICATION_CODE_LC AS credit_line_subapp,
d.COMPANY_LC_CODE AS credit_line_company,
'   '||c.COMPLETE_NAME AS client_name,
SUM(decode(t.REPAYMENT_TYPE,'C',a.VALUE,0)) AS balance
from 
PR_LOANS p,
PR_CONTRACTS d,
PR_LOAN_BALANCES a,
MG_SUBAPPLICATIONS s,
MG_CURRENCY m,
MG_RATE_GROUPS r,
PR_AMORTIZATION_TYPES n,
PR_LOAN_CLASS_CD l,
PR_BALANCE_TYPES t,
PR_SUBAPPLICATION_BALANCE_TYPE o,
MG_CLIENTS c,
MG_BOARDS z
where p.CONTRACT_NBR= d.CONTRACT_NBR
and p.SUBAPPLICATION_CODE = d.SUBAPPLICATION_CODE
and p.BRANCH_CODE = d.BRANCH_CODE
and p.COMPANY_CODE = d.COMPANY_CODE
and p.LOAN_NBR = a.LOAN_NBR
and p.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
and p.BRANCH_CODE = a.BRANCH_CODE
and p.COMPANY_CODE = a.COMPANY_CODE
and p.REVISION_DATE_INT between nvl(p_date_from,p.REVISION_DATE_INT) and nvl(p_date_to,p.REVISION_DATE_INT)
and a.BALANCE_TYPE_CODE = t.BALANCE_TYPE_CODE
--
and  a.BALANCE_TYPE_CODE = o.BALANCE_TYPE_CODE
and  o.BALANCE_TYPE_CODE = t.BALANCE_TYPE_CODE
and  o.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
and  o.COMPANY_CODE = a.COMPANY_CODE
and  o.ACCOUNTING_ACCOUNTING_LOCATION != 'P' 
--

and t.REPAYMENT_TYPE in ('C','I')
and t.BALANCE_TYPE  != 5 
----------------------------------------------------------------
and p.PORTFOLIO_RATE_VALUE_CODE = r.PORTFOLIO_RATE_VALUE_CODE
and p.AMORTIZATION_TYPE_CODE = n.AMORTIZATION_TYPE_CODE
----------------------------------------------------------------
and s.COMPANY_CODE = p.COMPANY_CODE
and s.APPLICATION_CODE = 'BPR'
and s.SUBAPPLICATION_CODE = p.SUBAPPLICATION_CODE
------------------------------------------------------
and s.CURRENCY_CODE = m.CURRENCY_CODE
and s.CURRENCY_CODE = nvl(p_currency,s.CURRENCY_CODE)
and p.CLIENT_CODE = c.CLIENT_CODE
------------------------------------------------------
and p.BANCA_CODE = z.BANCA_CODE
and z.BANK_TYPE = nvl(p_banking,z.BANK_TYPE)
and p.TYPE_CODE = l.TYPE_CODE (+)
and nvl(p.TYPE_CODE,0) =  nvl(p_loan_class,nvl(p.TYPE_CODE,0))
------------------------------------------------------
and p.TASA_TYPE <> '0'
and p.STATE = '1'
and nvl(p.DISBURSEMENT_VALUE,0) > 0 
------------------- Fideicomiso ---------------
and p.BANCA_CODE = nvl(p_board_code,p.BANCA_CODE)
and nvl(p.PRODUCT_ID,0) = nvl(p_product_key,nvl(p.PRODUCT_ID,0))
and p.SUBAPPLICATION_CODE = nvl(p_subapplication,p.SUBAPPLICATION_CODE)
-------------------------------------------------------
group by
z.BANCA_CODE,
z.BANK_TYPE,
z.DESCRIPTION,
p.COMPANY_CODE, 
p.BRANCH_CODE, 
p.SUBAPPLICATION_CODE, 
p.CONTRACT_NBR,
p.LOAN_NBR,
p.BASE_CURRENT_INT_RATE,
p.MATHEMATICAL_RELATION_1,
p.CURRENT_SPREAD_1,
p.MATHEMATICAL_RELATION_2,
p.CURRENT_SPREAD_2,
p.TOTAL_QUANTITY,
P.FLOOR_RATE,
P.CHANGE_RATE_CUTOFF_DATE,
P.PROMOTION_CODE,
p.REVISION_FREQUENCY_TYPE,
p.PERIOD_RATE,
p.REVISION_DATE_INT,
p.DATE_INTEREST_RATE_LAST_REVISION,
p.TYPE_CODE,
nvl(l.DESCRIPTION,'LOAN CLASS NOT DEFINED') ,
s.CURRENCY_CODE ,
m.DESCRIPTION,
p.PORTFOLIO_RATE_VALUE_CODE,
r.DESCRIPTION ,
p.AMORTIZATION_TYPE_CODE,
n.DESCRIPTION ,
d.CREDIT_LINE_CODE,
d.LC_BRANCH_CODE,
d.SUBAPPLICATION_CODE_LC,
d.COMPANY_LC_CODE,
'   '||c.COMPLETE_NAME
order by p.REVISION_DATE_INT, client_name


-- Q_3:
select
s.CURRENCY_CODE AS currency_code_g,
'GRAND TOTAL IN '||m.DESCRIPTION AS currency_desc_g,
SUM(decode(t.REPAYMENT_TYPE,'C',a.VALUE,0)) AS balance_g
from 
PR_LOANS p,
PR_LOAN_BALANCES a,
MG_SUBAPPLICATIONS s,
MG_CURRENCY m,
PR_LOAN_CLASS_CD l,
PR_BALANCE_TYPES t,
PR_SUBAPPLICATION_BALANCE_TYPE o,
MG_BOARDS z
where p.LOAN_NBR = a.LOAN_NBR
and p.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
and p.BRANCH_CODE = a.BRANCH_CODE
and p.COMPANY_CODE = a.COMPANY_CODE
and p.REVISION_DATE_INT between nvl(p_date_from,p.REVISION_DATE_INT) and nvl(p_date_to,p.REVISION_DATE_INT)
and a.BALANCE_TYPE_CODE = t.BALANCE_TYPE_CODE
and t.REPAYMENT_TYPE in ('C','I')
and  t.BALANCE_TYPE != 5
--
and  a.BALANCE_TYPE_CODE =  o.BALANCE_TYPE_CODE
and  t.BALANCE_TYPE_CODE  =  o.BALANCE_TYPE_CODE
and  o.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
and  o.COMPANY_CODE           = a.COMPANY_CODE
and  o.ACCOUNTING_ACCOUNTING_LOCATION != 'P'
--
----------------------------------------------------------------
and s.COMPANY_CODE = p.COMPANY_CODE
and s.APPLICATION_CODE = 'BPR'
and s.SUBAPPLICATION_CODE = p.SUBAPPLICATION_CODE
------------------------------------------------------
and s.CURRENCY_CODE = m.CURRENCY_CODE
and s.CURRENCY_CODE = nvl(p_currency,s.CURRENCY_CODE)
------------------------------------------------------
and p.BANCA_CODE = z.BANCA_CODE
and z.BANK_TYPE = nvl(p_banking,z.BANK_TYPE)
and p.TYPE_CODE = l.TYPE_CODE
and p.TYPE_CODE =  nvl(p_loan_class,p.TYPE_CODE)
------------------------------------------------------
and p.TASA_TYPE <> '0'
and p.STATE = '1'
group by
s.CURRENCY_CODE ,
'GRAND TOTAL IN '||m.DESCRIPTION


-- funciones:
-- F_CF_periodo:
function CF_periodoFormula return Char is
LV_DESC VARCHAR2(20);
begin
 IF Q_2.REVISION_FREQUENCY_TYPE IS NOT NULL THEN
  if Q_2.REVISION_FREQUENCY_TYPE = 1 then --days
  	if Q_2PERIOD_RATE = 1 then
  		 lv_desc := 'DAILY';
  	elsif Q_2PERIOD_RATE = 7 then
  		 lv_desc := 'WEEKLY';
   	ELSE
  		 lv_desc := 'EVERY '||Q_2PERIOD_RATE||' DAYS';
  	end if;
  elsif Q_2.REVISION_FREQUENCY_TYPE = 2 then --months
  	if Q_2PERIOD_RATE = 1 then
  		 lv_desc := 'MONTHLY';
  	ELSIF Q_2PERIOD_RATE = 2 THEN
  	   Lv_desc := 'BIMONTHLY';
  	ELSIF Q_2PERIOD_RATE = 3 THEN
  	   lv_desc := 'QUARTERLY';
  	ELSIF Q_2PERIOD_RATE = 6 THEN
  		 lv_desc := 'SEMIANNUAL';
  	ELSE
  		 lv_desc := 'EVERY '||Q_2PERIOD_RATE||' MONTHS';
  	end if;
  END IF;
END IF;
RETURN (' '||LV_DESC);
end;

--F_PROMOCION
function CF_1Formula return Char is
LV_PROMOCION VARCHAR2(100);
begin
  IF Q_2.PROMOTION_CODE IS NOT NULL THEN
  	BEGIN
  	SELECT DISTINCT DESCRIPTION||' EXPIRES '||Q_2.CHANGE_RATE_CUTOFF_DATE INTO LV_PROMOCION
  	FROM PR_PROMOTIONS
  	WHERE PROMOTION_CODE = Q_2.PROMOTION_CODE;
  	EXCEPTION WHEN NO_DATA_FOUND THEN
  		LV_PROMOCION := 'PROMOTION DOES NOT EXIST';
  	END;
  	
END IF;
RETURN(LV_PROMOCION);
end;

-- F_codigo_linea_credito1
function CF_TIPO_LINEAFormula return Number is
begin
	IF :CODIGO_LINEA_CREDITO IS NOT NULL THEN
  RETURN(1);
	ELSE
	RETURN(NULL);
	END IF;
end;
