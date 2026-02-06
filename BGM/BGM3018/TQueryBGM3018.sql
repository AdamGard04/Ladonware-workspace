-- Q_STATISTICAL_BALANCES
Select c.currency_code,
       c.level_1,
       c.level_2,
       c.level_3,
       c.level_4,
       c.level_5,
       c.level_6,
       c.level_7,
       c.level_8,
       nvl(d.amount_1,0)      local_acct_balance,
       nvl(d.amount_2,0)      acct_balance,
       sum(nvl(b.value,0))  balance  
    from  (Select  x.currency_code,y.company_code,y.branch_code,y.subapplication_code,y.application_code , 0 auxiliary_code,
                   y.balance_type_code,y.description,
                   nvl(z.account_cont_level_1,'0') level_1,  
                   nvl(z.account_cont_level_2,'0') level_2,  
                   nvl(z.account_cont_level_3,'0') level_3, 
                   nvl(z.account_cont_level_4,'0') level_4, 
                   nvl(z.account_cont_level_5,'0') level_5,   
                   nvl(z.account_cont_level_6,'0') level_6, 
                   nvl( decode( :p_consolidation_type,'A',nvl( z.account_cont_level_7 ,'0'),   decode(w.apply_level_7,'S', rpad('0',w.digit_quantity_level_7,'0'),'0000' )  ) 
                          ,'0') level_7,  
                   nvl( decode( :p_consolidation_type,'A', nvl(z.account_cont_level_8,'0') ,   decode(w.apply_level_8,'S', rpad('0',w.digit_quantity_level_8,'0'),'0000' )  )
                        ,'0') level_8
           From   (Select  i.company_code,i.application_code,i.branch_code,
                           i.subapplication_code,j.balance_type_code,j.DESCRIPTION
                   From    MG_BRANCHES_X_SUBAPPLICATION  i,
                           MG_TYPES_BALANCE               j
                   Where   i.application_code         in   ('BCC','BCA') -- BDP 
                   and     i.branch_code             = nvl(:branch,i.branch_code)
                   and     i.subapplication_code      = nvl(:subapplication,i.subapplication_code)
                   and     i.company_code             = :P_COMPANY_CODE 
                   and     j.application_code          = i.application_code 
                   and     j.balance_type_code           is not null             
                   and     nvl(j.COMPARATIVE_REPORT_USED,'N') = 'S') y,       
                   MG_SUBAPPLICATIONS          x,
                   MG_ACCOUNTS_X_BRANCH_X_SUBAPPLICATION z ,
                   GM_PARAMETER_ACCOUNTS_STRUCTURE  w 
              Where    x.application_code          = y.application_code
              and      x.subapplication_code      = y.subapplication_code
              and      z.application_code  (+)     = y.application_code
              and      z.balance_type_code  (+)     = y.balance_type_code
              and      z.branch_code     (+)     = y.branch_code            
              and      z.subapplication_code  (+) = y.subapplication_code      
              and      z.company_code     (+)     = y.company_code
              and      w.company_code                  =    :P_COMPANY_CODE 
          )  c,
          (Select     a.application_code,a.company_code,a.branch_code, a.subappl_code, a.balance_type_code,a.value     
           From       CA_BALANCES_STATISTICAL  a, MG_TYPES_BALANCE      t
           Where     a.dt  =  :P_DATE
           And           t.application_code = a.application_code 
           And           t.balance_type_code = a.balance_type_code
           And          nvl(t.COMPARATIVE_REPORT_USED,'N') = 'S' 
           UNION
           Select     a.application_code,a.company_code,a.branch_code, a.subappl_code, a.balance_type_code,a.value     
           From       CC_BALANCES_STATISTICAL  a,MG_TYPES_BALANCE      t 
           Where      a.dt  = :P_DATE  
           And           t.application_code = a.application_code 
           And           t.balance_type_code = a.balance_type_code
           And          nvl(t.COMPARATIVE_REPORT_USED,'N') = 'S' 
           ) b   ,
          GM_REPORTS_DATA_TEMP   d
   where  d.level_1               =  c.level_1
   and      d.level_2               =  c.level_2   
   and      d.level_3               =  c.level_3
   and      d.level_4               =  c.level_4
   and      d.level_5               =  c.level_5   
   and      d.level_6               =  c.level_6
   and      d.level_7               =  c.level_7   
   and      d.level_8               =  c.level_8
   and      d.company_code        =  :P_COMPANY_CODE
   and      d.code                =  'BGM3018'
   and      d.username               = :P_USERNAME 
   and      b.application_code   (+)       = c.application_code
   and      b.balance_type_code   (+)       = c.balance_type_code
   and      b.branch_code       (+)      = c.branch_code            
   and      b.subappl_code (+)      = c.subapplication_code      
   and      b.company_code         (+)    =   c.company_code
Group by  c.currency_code,
       c.level_1,
       c.level_2,
       c.level_3,
       c.level_4,
       c.level_5,
       c.level_6,
       c.level_7,
       c.level_8,
       nvl(d.amount_1,0) ,
       nvl(d.amount_2,0) 
Having   sum(nvl(b.value,0))  <> 0
or            nvl(d.amount_1,0) <> 0
or          :P_PRINT_LINE = 'S'          
order by 1,2,3,4,5,6,7,8,9,10




-- funciones
-- F_CF_DESC_MONEDA
function CF_CURRENCY_DESCFormula return Char is
 lv_description  MG_CURRENCY.description%type;
begin
  select description
    Into lv_description
   From MG_CURRENCY 
   Where currency_code = :currency_code;
  Return(lv_description);
Exception 
	When No_Data_Found Then
	  Return('Currency does not exist');
  When others Then
    Return('Error obtaining Currency');
end;
return ' ';


-- F_CF_CUENTA
function CF_ACCOUNTFormula return Char is
  Pv_Format VARCHAR2(39);
begin
  GM_P_DISPLAY_R(:level_1, :level_2, :level_3, :level_4, :level_5,
      :level_6, :level_7, :level_8,:p_company_code, Pv_Format);
  RETURN(Pv_Format);
end;


-- F_CF_DESCRIPCION
function CF_ACCOUNT_DESCFormula return Char is

 Lv_Description   Varchar2(80);
 
begin
  Select description
    Into Lv_Description
    From GM_CATALOGS
  Where company_code = :p_company_code
    and level_1        = :level_1
    and level_2        = :level_2
    and level_3        = :level_3
    and level_4        = :level_4
    and level_5        = :level_5
    and level_6        = :level_6;        
  Return(Lv_Description);                
Exception
	 When No_Data_Found Then
	   Return ('Accounting Account does not exist');
   When others Then
     Return('Error obtaining Description');
end;
return ' ';



-- F_CS_DIF1
function CF_DIFFERENCEFormula return Number is
  Lv_AccountsOverdraft  Number := 0;
  Ln_Difference            Number := 0;
Begin

  	Ln_Difference := :acct_balance - :cs_auxiliary_balance;

  Return(Ln_Difference);
end;


-- CF_SALDO_AUXILIAR_MNFormula
--CF_AUXILIARY_BALANCE --SUM
function CF_AUXILIARY_BALANCE return Number 
is

  SourceExchangeRate      NUMBER(16,8);
  DestinationExchangeRate     NUMBER(16,8);
  ExchangeDifference      NUMBER(16,6);
  ProfitLoss       NUMBER(19,6);
  ExchangeRateDate       DATE;
  ExchangeRateValue       NUMBER;
  Lv_ErrorMessage       VARCHAR2(2000);
  LN_WithoutOverdraftLC     NUMBER(19,6);
begin
  
  If :P_LOCAL_CURRENCY != :CURRENCY_CODE THEN
    Mg_P_CambioMoneda ( :P_COMPANY_CODE,
                				:CURRENCY_CODE,
	                      :P_LOCAL_CURRENCY,
	                      1, -- AccountingType
	                      ExchangeRateDate,
                        :TODAY_DATE,
 		                    SourceExchangeRate,
		                    DestinationExchangeRate,
                        ExchangeRateValue,
	                      :BALANCE,
                        Ln_WithoutOverdraftLC,
                        ExchangeDifference,
	                      ProfitLoss,
	                      Lv_ErrorMessage);
  Else
  	Ln_WithoutOverdraftLC := :BALANCE;
	End If;

  RETURN(Ln_WithoutOverdraftLC);
  
end;