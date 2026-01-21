/*
================================================================================
PARAMETERS USED IN THIS FILE (in order of appearance)
================================================================================

MAIN QUERY (Q_CC_ESTADISTICAS):
  1.  :p_repayment_type         - Repayment type filter
  2.  :P_SINGLE_BRANCH           - Single branch indicator ('S' = Yes)
  3.  :p_corporate_branch        - Corporate branch code
  4.  :branch                    - Branch code filter (-1 = All)
  5.  :subapplication            - Subapplication code filter (-1 = All)
  6.  :plevel_1                  - Account level 1 start range
  7.  :plevel_1_1                - Account level 1 end range
  8.  :plevel_2                  - Account level 2 start range
  9.  :plevel_2_2                - Account level 2 end range
  10. :plevel_3                  - Account level 3 start range
  11. :plevel_3_3                - Account level 3 end range
  12. :plevel_4                  - Account level 4 start range
  13. :plevel_4_4                - Account level 4 end range
  14. :plevel_5                  - Account level 5 start range
  15. :plevel_5_5                - Account level 5 end range
  16. :plevel_6                  - Account level 6 start range
  17. :plevel_6_6                - Account level 6 end range
  18. :plevel_7                  - Account level 7 start range
  19. :plevel_7_7                - Account level 7 end range
  20. :plevel_8                  - Account level 8 start range
  21. :plevel_8_8                - Account level 8 end range

FUNCTIONS:
  22. :currency_code             - Currency code
  23. :P_COMPANY_CODE            - Company code
  24. :branch_code               - Branch code
  25. :level_1                   - Account level 1
  26. :level_2                   - Account level 2
  27. :level_3                   - Account level 3
  28. :level_4                   - Account level 4
  29. :level_5                   - Account level 5
  30. :level_6                   - Account level 6
  31. :level_7                   - Account level 7
  32. :level_8                   - Account level 8
  33. :Currency_Code             - Currency code (uppercase variant)
  34. :P_LOCAL_CURRENCY          - Local currency code
  35. :P_DATE                    - Processing date
  36. :CP_LOCAL_BALANCE           - Computed local balance (output)
  37. :SUBAPPLICATION_CODE       - Subapplication code
  38. :TYPE_CODE                 - Type code
  39. :BALANCE_TYPE_CODE         - Balance type code
  40. :CARTERA_STATE_CODE        - Portfolio state code
  41. :P_MONEDA_LOCAL            - Local currency (Spanish variant)
  42. :CURRENCY_CODE             - Currency code (Spanish variant)
  43. :P_CODIGO_EMPRESA          - Company code (Spanish variant)
  44. :TODAY_DATE                 - Today's date
  45. :CF_BALANCE_AUX              - Auxiliary balance
  47. :CS_AUX_BALANCE            - Auxiliary balance for comparison

================================================================================
*/

-- Q_CC_ESTADISTICAS --> Q_CC_STATISTICS
Select  d.BRANCH_CODE BRANCH_CODE,
            b.CURRENCY_CODE CURRENCY_CODE,
            a.ACCOUNT_CONT_LEVEL_1 LEVEL_1,
            a.ACCOUNT_CONT_LEVEL_2 LEVEL_2,
            a.ACCOUNT_CONT_LEVEL_3 LEVEL_3,
            a.ACCOUNT_CONT_LEVEL_4 LEVEL_4,
            a.ACCOUNT_CONT_LEVEL_5 LEVEL_5,
            a.ACCOUNT_CONT_LEVEL_6 LEVEL_6,
            LPAD(d.BRANCH_CODE,3,'0') LEVEL_7,
            a.ACCOUNT_CONT_LEVEL_8 LEVEL_8,
            b.APPLICATION_CODE APPLICATION_CODE,
            a.SUBAPPLICATION_CODE SUBAPPLICATION_CODE,
            a.BALANCE_TYPE_CODE BALANCE_TYPE_CODE,
            a.TYPE_CODE TYPE_CODE,
            a.CARTERA_STATE_CODE CARTERA_STATE_CODE
    from  PR_ACCOUNTING_PARAMETER_DETAIL a,
             MG_SUBAPPLICATIONS b,
             PR_BALANCE_TYPES c,
             MG_BRANCHES  d
where
          b.application_code          = 'BPR'
   and b.subapplication_code  = a.subapplication_code
   and c.balance_type_code          = a.balance_type_code
   and c.repayment_type                     = p_repayment_type 
    and a.type_code                  != 3
    and a.branch_code      != 0 
    and  a.branch_code = decode(P_SINGLE_BRANCH,'S', p_corporate_branch, d.branch_code)
    and  d.BRANCH_CODE  = nvl(decode(branch,-1,null,branch),d.BRANCH_CODE)
    and a.SUBAPPLICATION_CODE  = nvl(decode(subapplication,-1,null,subapplication), a.SUBAPPLICATION_CODE)
     AND  a.ACCOUNT_CONT_LEVEL_1  BETWEEN nvl(plevel_1, a.ACCOUNT_CONT_LEVEL_1) 
     AND DECODE(plevel_1_1,NULL,DECODE(plevel_1,NULL, a.ACCOUNT_CONT_LEVEL_1, plevel_1), plevel_1_1) 
     AND a.ACCOUNT_CONT_LEVEL_2  BETWEEN nvl(plevel_2, a.ACCOUNT_CONT_LEVEL_2) 
     AND DECODE(plevel_2_2,NULL,DECODE(plevel_2,NULL, a.ACCOUNT_CONT_LEVEL_2, plevel_2), plevel_2_2)   
     AND a.ACCOUNT_CONT_LEVEL_3  BETWEEN nvl(plevel_3, a.ACCOUNT_CONT_LEVEL_3) 
     AND DECODE(plevel_3_3,NULL,DECODE(plevel_3,NULL, a.ACCOUNT_CONT_LEVEL_3, plevel_3), plevel_3_3) 
      AND a.ACCOUNT_CONT_LEVEL_4  BETWEEN nvl(plevel_4, a.ACCOUNT_CONT_LEVEL_4) 
      AND DECODE(plevel_4_4,NULL,DECODE(plevel_4,NULL, a.ACCOUNT_CONT_LEVEL_4, plevel_4), plevel_4_4)
      AND a.ACCOUNT_CONT_LEVEL_5  BETWEEN nvl(plevel_5, a.ACCOUNT_CONT_LEVEL_5)
      AND DECODE(plevel_5_5,NULL,DECODE(plevel_5,NULL, a.ACCOUNT_CONT_LEVEL_5, plevel_5), plevel_5_5)
      AND a.ACCOUNT_CONT_LEVEL_6   BETWEEN nvl(plevel_6, a.ACCOUNT_CONT_LEVEL_6) 
       AND DECODE(plevel_6_6,NULL,DECODE(plevel_6,NULL, a.ACCOUNT_CONT_LEVEL_6, plevel_6), plevel_6_6) 
      AND a.ACCOUNT_CONT_LEVEL_7  BETWEEN nvl(plevel_7, a.ACCOUNT_CONT_LEVEL_7) 
      AND DECODE(plevel_7_7,NULL,DECODE(plevel_7,NULL, a.ACCOUNT_CONT_LEVEL_7, plevel_7), plevel_7_7)
      AND a.ACCOUNT_CONT_LEVEL_8  BETWEEN nvl(plevel_8, a.ACCOUNT_CONT_LEVEL_8) 
      AND DECODE(plevel_8_8,NULL,DECODE(plevel_8,NULL, a.ACCOUNT_CONT_LEVEL_8, plevel_8), plevel_8_8) 
order by d.BRANCH_CODE,
              b.CURRENCY_CODE,
             a.ACCOUNT_CONT_LEVEL_1 ,
             a.ACCOUNT_CONT_LEVEL_2,
             a.ACCOUNT_CONT_LEVEL_3,
             a.ACCOUNT_CONT_LEVEL_4,
             a.ACCOUNT_CONT_LEVEL_5,
             a.ACCOUNT_CONT_LEVEL_6,
              LPAD(d.BRANCH_CODE,3,'0'), 
             a.ACCOUNT_CONT_LEVEL_8,
             a.SUBAPPLICATION_CODE,
             a.TYPE_CODE,
             a.CARTERA_STATE_CODE,
             a.BALANCE_TYPE_CODE


-- funciones:
-- F_nombre_moneda
function CF_DESC_CURRENCY return Char is
 lv_description  MG_CURRENCY.DESCRIPTION%type;
begin
  select DESCRIPTION
    Into lv_description
   From MG_CURRENCY 
   Where currency_code = Q_CC_STATISTICS.CURRENCY_CODE;
  Return(lv_description);
Exception 
	When No_Data_Found Then
	  Return('Currency does not exist');
    when others then
    RETURN  null;
end;



-- F_CF_DESC_AGENCIA
function BRANCH_NAME1 return VARCHAR2 is
lv_branch_name MG_BRANCHES_GENERAL.BRANCH_NAME%type;
begin

select BRANCH_NAME 
  into lv_branch_name 
  from MG_BRANCHES 
  where company_code  = :P_COMPANY_CODE
    and Q_CC_STATISTICS.BRANCH_CODE = branch_code;
RETURN(lv_branch_name);
EXCEPTION 
	WHEN OTHERS THEN RETURN(' BRANCH ERROR');
end;


-- F_CF_CUENTA
function CF_ACCOUNT return Char is
Pv_Format VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(Q_CC_STATISTICS.LEVEL_1, Q_CC_STATISTICS.LEVEL_2, Q_CC_STATISTICS.LEVEL_3, Q_CC_STATISTICS.LEVEL_4, Q_CC_STATISTICS.LEVEL_5,
      Q_CC_STATISTICS.LEVEL_6, Q_CC_STATISTICS.LEVEL_7, Q_CC_STATISTICS.LEVEL_8,:P_COMPANY_CODE, Pv_Format);
  RETURN(Pv_Format);
end;


-- F_CF_DESCRIPCION
function CF_DESC_ACCOUNT return Char is

 Lv_Description   Varchar2(80);
begin
  Select description
    Into Lv_Description
    From GM_ACCOUNT_BALANCE
  Where company_code = P_COMPANY_CODE
    and level_1        = Q_CC_STATISTICS.LEVEL_1
    and level_2        = Q_CC_STATISTICS.LEVEL_2
    and level_3        = Q_CC_STATISTICS.LEVEL_3
    and level_4        = Q_CC_STATISTICS.LEVEL_4
    and level_5        = Q_CC_STATISTICS.LEVEL_5
    and level_6        = Q_CC_STATISTICS.LEVEL_6
    and level_7        = Q_CC_STATISTICS.LEVEL_7
    and level_8        = Q_CC_STATISTICS.LEVEL_8;        
  Return(Lv_Description);                
Exception
	 When No_Data_Found Then
	   Return ('Accounting Account does not exist');
     when others then
    RETURN  null;
end;


-- Gm_P_saldo_Diario_ME
Procedure Gm_P_saldo_Diario_ME
                       (GN_COMPANY_CODE NUMBER,
                        GV_TXN_ENTRY_RECEIVED     VARCHAR2,
                        GV_LEVEL_INIT_1       VARCHAR2, 
                        GV_LEVEL_INIT_2       VARCHAR2,
                        GV_LEVEL_INIT_3       VARCHAR2,
                        GV_LEVEL_INIT_4       VARCHAR2,
                        GV_LEVEL_INIT_5       VARCHAR2, 
                        GV_LEVEL_INIT_6       VARCHAR2,
                        GV_LEVEL_INIT_7       VARCHAR2, 
                        GV_LEVEL_INIT_8       VARCHAR2,
                        GN_CURRENCY_CODE  NUMBER,
                        GV_DAY            NUMBER,
                        GV_MONTH            NUMBER,
                        GV_YEAR           NUMBER,
                        GN_TOTAL      OUT NUMBER)
IS

Begin

  SELECT SUM(DECODE(GV_DAY,1,DAY_1_BALANCE, 2,DAY_2_BALANCE,
                           3,DAY_3_BALANCE, 4,DAY_4_BALANCE,
                           5,DAY_5_BALANCE, 6,DAY_6_BALANCE,
                           7,DAY_7_BALANCE, 8,DAY_8_BALANCE,
                           9,DAY_9_BALANCE, 10,DAY_10_BALANCE,
                          11,DAY_11_BALANCE,12,DAY_12_BALANCE,
                          13,DAY_13_BALANCE,14,DAY_14_BALANCE,
                          15,DAY_15_BALANCE,16,DAY_16_BALANCE,
                          17,DAY_17_BALANCE,18,DAY_18_BALANCE,
                          19,DAY_19_BALANCE,20,DAY_20_BALANCE,
                          21,DAY_21_BALANCE,22,DAY_22_BALANCE,
                          23,DAY_23_BALANCE,24,DAY_24_BALANCE,
                          25,DAY_25_BALANCE,26,DAY_26_BALANCE,
                          27,DAY_27_BALANCE,28,DAY_28_BALANCE,
                          29,DAY_29_BALANCE,30,DAY_30_BALANCE,
                          31,DAY_31_BALANCE)) DayBalance
    INTO GN_TOTAL  
    FROM GM_ACCOUNT_BALANCE A,
         GM_FOREIGN_DAYS_BALANCES B
  where
        a.level_1           = Gv_Level_Init_1
    and a.level_2           = Gv_Level_Init_2
    and a.level_3           = Gv_Level_Init_3
    and a.level_4           = Gv_Level_Init_4
    and a.level_5           = Gv_Level_Init_5
    and a.level_6           = Gv_Level_Init_6
    and a.level_7           = Gv_Level_Init_7 
    and a.level_8           = Gv_Level_Init_8
    and a.txn_entry_received = GV_TXN_ENTRY_RECEIVED
    and b.level_1           = a.level_1
    and b.level_2           = a.level_2
    and b.level_3           = a.level_3
    and b.level_4           = a.level_4
    and b.level_5           = a.level_5
    and b.level_6           = a.level_6
    and b.level_7           = a.level_7
    and b.level_8           = a.level_8
    and b.MONTH               = GV_MONTH
    and b.YEAR              = GV_YEAR
    and b.currency_code     = Gn_currency_code;
    
   Gn_Total = Nvl(Gn_Total,0);
   
exception
  when no_data_found then
       Gn_total := 0;
  when others then
    RETURN  null;
END;


-- GM_P_calcula_saldo_Mov
PROCEDURE GM_P_calcula_saldo_Mov (GN_COMPANYCODE        NUMBER,
                                  GV_LEVEL_1              VARCHAR2,
                                  GV_LEVEL_2              VARCHAR2,
                                  GV_LEVEL_3              VARCHAR2, 
                                  GV_LEVEL_4              VARCHAR2,
                                  GV_LEVEL_5              VARCHAR2, 
                                  GV_LEVEL_6              VARCHAR2,
                                  GV_LEVEL_7              VARCHAR2,
                                  GV_LEVEL_8              VARCHAR2,
                                  LocalCurrency             NUMBER,
                                  GD_DATE                DATE,
                                  GN_TOTAL_DB         OUT NUMBER,
                                  GN_TOTAL_CR         OUT NUMBER,
                                  GN_TOTAL_DBME       OUT NUMBER,
                                  GN_TOTAL_CRME       OUT NUMBER)
 IS

Ln_total_ini  number (14,2) := 0;
Ln_total_fin  number (14,2) := 0;
Ln_total      number (14,2) := 0;
Ln_CreditAmount  Number  := 0;
Ln_DebitAmount   Number  := 0;
Ln_CreditAmountFC Number := 0;
Ln_DebitAmountFC  Number := 0;
BEGIN
       select  sum(decode(credit_debit,'C',decode(currency_code,LocalCurrency,abs(txn_entry_amount),
                                   abs(txn_entry_local_amount)),0)) Credit_Amount,
               sum(decode(credit_debit,'D',decode(currency_code,LocalCurrency,txn_entry_amount,
                                   txn_entry_local_amount),0)) Debit_Amount,
               sum(decode(credit_debit,'C',decode(currency_code,LocalCurrency,0,
                                   abs(txn_entry_amount)),0)) Credit_Amount_Foreign,
               sum(decode(credit_debit,'D',decode(currency_code,LocalCurrency,0,
                                   txn_entry_amount),0)) Debit_Amount_Foreign
         Into Ln_CreditAmount,
              Ln_DebitAmount,
              Ln_CreditAmountFC,
              Ln_DebitAmountFC
         from GM_TXN_ENTRIES_DETAIL
        Where company_code    = Gn_CompanyCode
          and Level_1           = Gv_Level_1
          and Level_2           = Gv_Level_2
          and Level_3           = Gv_Level_3
          and Level_4           = Gv_Level_4
          and Level_5           = Gv_Level_5
          and Level_6           = Gv_Level_6
          and Level_7           = Gv_Level_7
          and Level_8           = Gv_Level_8
          and txn_entry_date  <= Gd_Date;

     Gn_Total_db := Nvl(Ln_DebitAmount,0);
     Gn_Total_cr := Nvl(Ln_CreditAmount,0);
     Gn_Total_dbme := Nvl(Ln_DebitAmountFC,0);
     Gn_Total_crme := Nvl(Ln_CreditAmountFC,0);
END;



-- PU_P_SaldoContableFecha
PROCEDURE PU_P_SaldoContableFecha  (Pn_CompanyCode      Number,
                                    Pv_level_1            Varchar2,
                                    Pv_level_2            Varchar2,
                                    Pv_level_3            Varchar2,
                                    Pv_level_4            Varchar2,
                                    Pv_level_5            Varchar2,
                                    Pv_level_6            Varchar2,
                                    Pv_level_7            Varchar2,
                                    Pv_level_8            Varchar2,
                                    Pn_CurrencyCode       Number,
                                    Pn_LocalCurrency        Varchar2,
                                    Pd_Date              Date,
                                    Pn_CurrentBalance IN OUT Number,
                                    Pn_LocalBalance  IN OUT Number )
                            Is
 Ld_Today     Date;
 Ln_Year         Number;
 Ln_Month          Number;
 Ln_Day          Number;
 Ln_Total_db     Number;
 Ln_Total_Cr     Number;
 Ln_Total_db_FC  Number;
 Ln_Total_Cr_FC  Number;
 Ln_balance        Number;
 Ln_balance_FC     Number;
 Lv_Error        Varchar2(2000);
 Lv_AccountNature   Varchar2(1);

Begin
  Begin
	  Select Today_Date
	    Into Ld_Today
	    From MG_SCHEDULE
	   Where company_code    = Pn_CompanyCode
	     and application_code = 'BGM';
  End;
  
  Ln_Day  := To_number(to_char(pd_Date,'DD'));  
  Ln_Month  := To_number(to_char(pd_Date,'MM'));
  Ln_Year := To_number(to_char(pd_Date,'YYYY'));
  
  Lv_Error :=  Gm_f_naturaleza_cuenta
                     (Pn_CompanyCode,
				   	          Pv_level_1,
				   	          Pv_level_2,
				   	          Pv_level_3,
				   	          Pv_level_4,
				   	          Pv_level_5,
				   	          Pv_level_6,
                      Lv_AccountNature);
 
 
  If  pd_Date < Ld_Today Then
    GM_K_BUSCA_SALDOS.GM_P_SALDO_DIARIOS
                    ( Pn_CompanyCode,
				   	          Pv_level_1,
				   	          Pv_level_2,
				   	          Pv_level_3,
				   	          Pv_level_4,
				   	          Pv_level_5,
				   	          Pv_level_6,
				   	          Pv_level_7,
				   	          Pv_level_8,
				   	          Ln_Year,   
				   	          Ln_Month,
				   	          Ln_Day,
				   	         'S', -- Recibe Movimiento
				            Ln_Balance,
		                Lv_Error);
	  If Pn_LocalCurrency != Pn_CurrencyCode Then
       Gm_P_saldo_Diario_ME
                       (Pn_CompanyCode,
                        'S',
                        Pv_level_1,
                        Pv_level_2,
                        Pv_level_3,
                        Pv_level_4,
                        Pv_level_5, 
                        Pv_level_6,
                        Pv_level_7, 
                        Pv_level_8,
                        Pn_CurrencyCode,
                        Ln_DAY,
                        Ln_MONTH,
                        Ln_YEAR,
                        Ln_Balance_FC);
	  End If;
  Else
  Begin
  	 Begin
  	  Select current_balance 
  	    Into Ln_balance
  	   From GM_ACCOUNT_BALANCE 
  	  Where company_code =  pn_CompanyCode
  	    and level_1        = Pv_level_1
   	    and level_2        = Pv_level_2
  	    and level_3        = Pv_level_3
   	    and level_4        = Pv_level_4
   	    and level_5        = Pv_level_5
   	    and level_6        = Pv_level_6
    	  and level_7        = Pv_level_7
   	    and level_8        = Pv_level_8;
  	 Exception
  	 	When No_data_found Then
  	 	  Ln_balance := 0;
        when others then
        RETURN  null;
  	 End;
  	 
     Gm_P_calcula_saldo_Mov 
                     (Pn_CompanyCode,
				   	          Pv_level_1,
				   	          Pv_level_2,
				   	          Pv_level_3,
				   	          Pv_level_4,
				   	          Pv_level_5,
				   	          Pv_level_6,
				   	          Pv_level_7,
				   	          Pv_level_8,
                      Pn_LocalCurrency,
                      Pd_Date,
                      Ln_Total_DB,
                      Ln_Total_CR,
                      Ln_Total_DB_FC,
                      Ln_Total_CR_FC);
 
     If Lv_AccountNature = 'D' Then
   	    Ln_Balance := Ln_balance + Ln_total_db - Ln_total_cr;
   	 Else
        Ln_Balance := Ln_balance - Ln_total_DB + Ln_total_cr;
   	 End IF;
   	 
     If Pn_LocalCurrency != Pn_CurrencyCode Then
   	 Begin
  	  Select current_balance 
  	    Into Ln_balance_FC
  	   From GM_FOREIGN_BALANCE 
  	  Where company_code =  pn_CompanyCode
  	    and level_1        = Pv_level_1
   	    and level_2        = Pv_level_2
  	    and level_3        = Pv_level_3
   	    and level_4        = Pv_level_4
   	    and level_5        = Pv_level_5
   	    and level_6        = Pv_level_6
    	  and level_7        = Pv_level_7
   	    and level_8        = Pv_level_8
   	    and currency_code  = Pn_CurrencyCode;

  	 Exception
  	 	When No_data_found Then
  	 	  Ln_balance_FC := 0;
        when others then
          RETURN  null;
  	 End; 
  	 
   	   If Lv_AccountNature = 'D' Then
   	 	   Ln_Balance_FC := Ln_balance_FC + Ln_total_db_FC - Ln_total_cr_FC;
   	   Else
      	 Ln_Balance_FC := Ln_balance_FC - Ln_total_db_FC + Ln_total_cr_FC;
       End IF;
     End If;
  	End;
  End If;
  Pn_LocalBalance   := Ln_Balance;
  Pn_CurrentBalance  := Ln_balance;
  If Pn_CurrencyCode != Pn_LocalCurrency Then
  	 Pn_CurrentBalance := Ln_Balance_FC;
  End If;
  
End;


-- F_CF_SaldoActual
function CF_ACTUAL_BALANCE return Number is

 Ln_CurrentBalance   Number;
 Ln_LocalBalance    Number;
begin
  PU_P_SaldoContableFecha
          (P_COMPANY_CODE,
           Q_CC_STATISTICS.LEVEL_1      ,
           Q_CC_STATISTICS.LEVEL_2      ,
           Q_CC_STATISTICS.LEVEL_3      ,
           Q_CC_STATISTICS.LEVEL_4      ,
           Q_CC_STATISTICS.LEVEL_5      ,
           Q_CC_STATISTICS.LEVEL_6      ,
           Q_CC_STATISTICS.LEVEL_7      ,
           Q_CC_STATISTICS.LEVEL_8      ,
           Q_CC_STATISTICS.CURRENCY_CODE ,
           P_LOCAL_CURRENCY  ,
           P_DATE        ,
           Ln_CurrentBalance ,
           Ln_LocalBalance );
           
  CP_LOCAL_BALANCE := Ln_LocalBalance;  
  
  Return(Ln_CurrentBalance);

end;



-- F_descrip_sub1
function DESCRIP_SUB1 return VARCHAR2 is
  Lv_Description	Varchar2(250);
begin
  select description 
  into Lv_Description
  from MG_SUBAPPLICATIONS 
  where application_code = 'BPR'
    and Q_CC_STATISTICS.SUBAPPLICATION_CODE = subapplication_code;
  RETURN Lv_Description;
RETURN NULL; exception
  when no_data_found then
    RETURN  null;
  when others then
    RETURN  null;
end;


-- F_codigo_tipo1
function CF_DESC_TYPE return Char is
 lv_description varchar2(40);
begin
  select description
    Into lv_description
    From PR_LOAN_CLASS_CD
   Where type_code = Q_CC_STATISTICS.TYPE_CODE;
   
  Return(lv_description);
Exception
	When No_data_found Then
	  Return(Null);
end;


-- F_desc_saldo
function CF_DESC_BALANCE return Char is
 lv_description varchar2(40);
begin
  select description
    Into lv_description
    From PR_BALANCE_TYPES
   Where balance_type_code = Q_CC_STATISTICS.BALANCE_TYPE_CODE;
   
  Return(lv_description);
Exception
	When No_data_found Then
	  Return(Null);
  when others then
    RETURN  null;
end;


-- PR_P_CALSALDOCOMPARATIVOBPR

 PROCEDURE  PR_P_CALCULASALDOCOMPARATIVO ( Gn_CompanyCode     Number ,
                                          Gn_BranchCode     Number ,
                                          Gn_SubAplic          Number ,
                                          Gn_BalanceTypeCode   Number , 
                                          Gn_TypeCode        Number ,
                                          Gv_CarteraStateCode Varchar2,
                                          Gd_Date             Date ,
                                          Gn_Value       IN OUT      Number )
  IS                                                 
  Ln_value             number;
  Ld_Date             Date := Gd_Date;
  Ld_Today          Date;
  Ld_NextDate      Date;
  Ld_EndMonth            DATE;
  Ld_PreviousDate     DATE;
  Ld_RepDate          DATE;
  Lv_Inactive          Varchar2(1); 
begin
	
  Begin
	  Select today_date, 
	         previous_date ,
	         Ld_NextDate 
	    Into Ld_Today, 
	         Ld_PreviousDate,
	         Ld_NextDate
	  From MG_SCHEDULE 
	  Where application_code  = 'BPR';
	  LD_RepDate := LD_NextDate - 1;
	  Ld_EndMonth   := Last_day (Ld_Date);
	  
	 Exception
	 When No_data_found Then 
  	  null;
    when others then
      RETURN  null;
  End;
  
  If Ld_Date = Ld_RepDate 
  Then
	
     select nvl(sum(value),0)
       Into Ln_value
      From PR_LOAN_BALANCES  b ,
           PR_LOANS        c
     where 
           b.subapplication_code = Gn_SubAplic
       and b.branch_code        = Gn_BranchCode
       and b.company_code        = Gn_CompanyCode
       and b.balance_type_code       = Gn_BalanceTypeCode
       and c.loan_number         = b.loan_number
       and c.branch_code          = b.branch_code
       and c.subapplication_code   = b.subapplication_code
       and c.company_code          = b.company_code
       and c.cartera_state_code   = Gv_CarteraStateCode
       and c.type_code             = Gn_TypeCode;
     
  Else
  		
     select nvl(sum(value),0)
       Into Ln_value
      From PR_LOAN_DAILY_BALANCES  b ,
           PR_LOANS               c
     where 
           b.subapplication_code =  Gn_SubAplic
       and b.branch_code        =Gn_BranchCode
       and b.company_code        =  Gn_CompanyCode
       and b.valid_date           = Gd_Date
       and b.balance_type_code       = Gn_BalanceTypeCode
       and c.loan_number         = b.loan_number
       and c.branch_code          = b.branch_code
       and c.subapplication_code   = b.subapplication_code
       and c.company_code          = b.company_code
       and b.cartera_state_code   = Gv_CarteraStateCode
       and c.type_code             = Gn_TypeCode;
 
  End if;
  Gn_value := Ln_value;
 
Exception
	When No_Data_Found Then
	 Gn_value := 0;
   when others then
    RETURN  null;
end;


-- F_saldo_aux
function CF_BALANCE_AUX return Number is
  Ln_value             number;
  Ld_Date             Date := P_DATE;
  Ld_Today          Date;
  Ld_NextDate      Date;
  Ld_EndMonth            DATE;
  Ld_PreviousDate     DATE;
  Ld_RepDate          DATE;
  Lv_Inactive          Varchar2(1); 
begin
	
	PR_P_CALSALDOCOMPARATIVOBPR  ( P_COMPANY_CODE ,
                                 Q_CC_STATISTICS.BRANCH_CODE ,
                                 Q_CC_STATISTICS.SUBAPPLICATION_CODE ,
                                 Q_CC_STATISTICS.BALANCE_TYPE_CODE , 
                                 Q_CC_STATISTICS.TYPE_CODE  ,
                                 Q_CC_STATISTICS.CARTERA_STATE_CODE,
                                 P_DATE ,
                                 ln_value );
	  
Return(ln_value);
Exception
	When No_Data_Found Then
	  Return(0);
  when others then
    RETURN  null;
end;


-- F_CF_BALANCE_AUX_MN
function CF_BALANCE_AUX_MN return Number is


  TasaCambioorigen      NUMBER(16,8);
  TasaCambioDestino     NUMBER(16,8);
  DiferenciaCambio      NUMBER(16,6);
  GananciaPerdida       NUMBER(19,6);
  FechaTipoCambio       DATE;
  ValorTipoCambio       NUMBER;
  Lv_MensajeError       VARCHAR2(2000);
  LN_saldoaux_MN          NUMBER(19,6);
  LN_SobregiroMN        NUMBER(19,6);
begin
  
  If :P_LOCAL_CURRENCY != Q_CC_STATISTICS.CURRENCY_CODE THEN
    Mg_P_CambioMoneda ( P_COMPANY_CODE,
                				Q_CC_STATISTICS.CURRENCY_CODE,
	                      P_LOCAL_CURRENCY,
	                      1,
	                      FechaTipoCambio,
                        Q_CC_STATISTICS.TODAY_DATE,
 		                    TasaCambioorigen,
		                    TasaCambioDestino,
                        ValorTipoCambio,
	                      CF_BALANCE_AUX,
                        Ln_SaldoAux_mn,
                        DiferenciaCambio,
	                      GananciaPerdida,
	                      Lv_MensajeError);
	                      
  Else
  	Ln_Saldoaux_mn := CF_BALANCE_AUX;
	End If;

   RETURN(Ln_saldoaux_mn);
  
end;



-- F_CF_SaldoActual1
-- function CF_ACTUAL_BALANCE return Number is

--  Ln_CurrentBalance   Number;
--  Ln_LocalBalance    Number;
-- begin
--   PU_P_SaldoContableFecha
--           (P_COMPANY_CODE,
--            Q_CC_STATISTICS.LEVEL_1      ,
--            Q_CC_STATISTICS.LEVEL_2      ,
--            Q_CC_STATISTICS.LEVEL_3      ,
--            Q_CC_STATISTICS.LEVEL_4      ,
--            Q_CC_STATISTICS.LEVEL_5      ,
--            Q_CC_STATISTICS.LEVEL_6      ,
--            Q_CC_STATISTICS.LEVEL_7      ,
--            Q_CC_STATISTICS.LEVEL_8      ,
--            Q_CC_STATISTICS.CURRENCY_CODE ,
--            P_LOCAL_CURRENCY  ,
--            P_DATE        ,
--            Ln_CurrentBalance ,
--            Ln_LocalBalance );
           
--   CP_LOCAL_BALANCE := Ln_LocalBalance;  
  
--   Return(Ln_CurrentBalance);

-- end;




-- F_CS_DIF1
function CF_DIFERENCE return Number is
  Lv_AccountOverdraft  Number := 0;
  Ln_Difference            Number := 0;
begin


  	 Ln_Difference := nvl(:CF_ACTUAL_BALANCE,0) - nvl(:CS_AUX_BALANCE,0); --LLAMA A OTRA FUNCIÓN

  Return(Ln_Difference);
end;
