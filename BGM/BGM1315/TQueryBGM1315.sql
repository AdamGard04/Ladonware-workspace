-- Q_REVALORIZACION

SELECT A.LEVEL_1,A.LEVEL_2, A.LEVEL_3, A.LEVEL_4,
              A.LEVEL_5, A.LEVEL_6, A.LEVEL_7, A.LEVEL_8,
              A.DESCRIPTION AS ACCT_DESC ,A.CURRENCY_CODE,
              NVL(A.CURRENT_BALANCE,0) FOREIGN_BALANCE,
              NVL(B.CURRENT_BALANCE,0) LOCAL_BALANCE,

              C.DESCRIPTION AS CURR_DESC             
FROM GM_BALANCE_EXTRANJEROS A,
            GM_ACCOUNT_BALANCE B,
            MG_CURRENCY C,
           GM_SETTINGS D
WHERE A.COMPANY_CODE = B.COMPANY_CODE   
AND      A.LEVEL_1                     = B.LEVEL_1
AND      A.LEVEL_2                     = B.LEVEL_2
AND      A.LEVEL_3                     = B.LEVEL_3
AND      A.LEVEL_4                     = B.LEVEL_4
AND      A.LEVEL_5                     = B.LEVEL_5
AND      A.LEVEL_6                     = B.LEVEL_6
AND      A.LEVEL_7                     = B.LEVEL_7
AND      A.LEVEL_8                     = B.LEVEL_8
AND (    B.CURRENT_BALANCE   != 0  
OR  0  !=  (SELECT SUM(MOVEMENT_AMOUNT)
      FROM GM_TXN_ENTRIES_DETAIL M
    WHERE M.COMPANY_CODE     = A.COMPANY_CODE
         AND M.LEVEL_1                         = A.LEVEL_1
         AND M.LEVEL_2                         = A.LEVEL_2
         AND M.LEVEL_3                         = A.LEVEL_3
         AND M.LEVEL_4                         = A.LEVEL_4
         AND M.LEVEL_5                         = A.LEVEL_5
        AND M.LEVEL_6                          = A.LEVEL_6
        AND M.LEVEL_7                          = A.LEVEL_7
       AND M.LEVEL_8                           = A.LEVEL_8
     /*  AND M.MOVEMENT_DATE    != :P_DATE */) )
AND     A.CURRENCY_CODE   !=  D.LOCAL_CURRENCY_CODE
AND     A.CURRENCY_CODE     = C.CURRENCY_CODE
AND   B.RECEIVES_MOVEMENT  = 'S'
AND  ( A.LEVEL_1  < '400'
OR      A.LEVEL_1 > '599')
AND a.LEVEL_1 BETWEEN nvl(P_LEVEL_1,a.LEVEL_1) AND                 DECODE(P_LEVEL_1_1,NULL,DECODE(P_LEVEL_1,NULL,a.LEVEL_1,P_LEVEL_1),P_LEVEL_1_1) 
AND a.LEVEL_2 BETWEEN nvl(P_LEVEL_2,a.LEVEL_2) AND    DECODE(P_LEVEL_2_2,NULL,DECODE(P_LEVEL_2,NULL,a.LEVEL_2,P_LEVEL_2),P_LEVEL_2_2) 
AND a.LEVEL_3 BETWEEN nvl(P_LEVEL_3,a.LEVEL_3) AND   DECODE(P_LEVEL_3_3,NULL,DECODE(P_LEVEL_3,NULL,a.LEVEL_3,P_LEVEL_3),P_LEVEL_3_3) 
 AND a.LEVEL_4 BETWEEN nvl(P_LEVEL_4,a.LEVEL_4) AND   DECODE(P_LEVEL_4_4,NULL,DECODE(P_LEVEL_4,NULL,a.LEVEL_4,P_LEVEL_4),P_LEVEL_4_4) 
AND  a.LEVEL_5 BETWEEN nvl(P_LEVEL_5,a.LEVEL_5) AND   DECODE(P_LEVEL_5_5,NULL,DECODE(P_LEVEL_5,NULL,a.LEVEL_5,P_LEVEL_5),P_LEVEL_5_5)
 AND a.LEVEL_6  BETWEEN nvl(P_LEVEL_6,a.LEVEL_6) AND   DECODE(P_LEVEL_6_6,NULL,DECODE(P_LEVEL_6,NULL,a.LEVEL_6,P_LEVEL_6),P_LEVEL_6_6) 
 AND a.LEVEL_7 BETWEEN nvl(P_LEVEL_7,a.LEVEL_7) AND   DECODE(P_LEVEL_7_7,NULL,DECODE(P_LEVEL_7,NULL,a.LEVEL_7,P_LEVEL_7),P_LEVEL_7_7)
 AND a.LEVEL_8 BETWEEN nvl(P_LEVEL_8,a.LEVEL_8) AND   DECODE(P_LEVEL_8_8,NULL,DECODE(P_LEVEL_8,NULL,a.LEVEL_8,P_LEVEL_8),P_LEVEL_8_8) 
ORDER BY A.CURRENCY_CODE, A.LEVEL_1||A.LEVEL_2||A.LEVEL_3||A.LEVEL_4||A.LEVEL_5||A.LEVEL_6||A.LEVEL_7||A.LEVEL_8


-- FUNCIONES:
-- F_CF_TASA
function CF_EXCHANGE_RATE return Number is
  Ln_ExchangeValue MG_TIPOS_DE_CAMBIO.VALOR_CAMBIO%TYPE;
  ExchangeRateOrigin       Number;
  ExchangeRateDestination      Number;
  Ln_RateValue           Number;
  Ln_LocalCurrencyAmount    Number;
  Ln_ExchangeDifference    Number;
  Ln_ProfitLoss     Number;
  Ld_ExchangeRateDate     Date;
  Lv_ErrorMessage    Varchar2(2000);
begin
        ExchangeRateOrigin   := Null;
        Ln_ExchangeValue     := Null;
        MG_F_CURRENCY_EXCHANGE ( P_Company_Code,
                            Currency_Code,
  	              		      P_Local_Currency,
			                      1, -- Accounting Type
			                      Ld_ExchangeRateDate,
			                      P_DATE,
		  	                    ExchangeRateOrigin,
		  	                    ExchangeRateDestination,
		                        Ln_ExchangeValue,
	                          1 , --OriginAmount
	                          Ln_LocalCurrencyAmount,
	                          Ln_ExchangeDifference,
	                          Ln_ProfitLoss,
		                        Lv_ErrorMessage);
		 
   RETURN(Ln_ExchangeValue);
end;

-- F_CUENTA
function CF_ACCOUNT return VARCHAR2 is
  Lv_Format  VARCHAR2(39);
begin
  GM_P_DISPLAY_R(LEVEL_1,LEVEL_2,LEVEL_3,LEVEL_4,LEVEL_5,
                   LEVEL_6,LEVEL_7,LEVEL_8, P_Company_Code, Lv_Format);
  RETURN(Lv_Format);  
end;

-- F_TIPO_CAMBIO
function CF_EXCHANGE_RATE_DET return Number is
  Ln_ExchangeValue MG_TIPOS_DE_CAMBIO.VALOR_CAMBIO%TYPE;
  ExchangeRateOrigin       Number;
  ExchangeRateDestination      Number;
  Ln_RateValue           Number;
  Ln_LocalCurrencyAmount    Number;
  Ln_ExchangeDifference    Number;
  Ln_ProfitLoss     Number;
  Ld_ExchangeRateDate     Date;
  Ln_ExchangeRateType          Number;
  Lv_ErrorMessage        Varchar2(2000);
  Lv_Account              Varchar2(32);
begin
    Lv_Account := LEVEL_1||LEVEL_2||LEVEL_3||LEVEL_4||LEVEL_5||
                 LEVEL_6||LEVEL_7||LEVEL_8;
                 
    --
    Begin
      SELECT EXCHANGE_TYPE
        INTO Ln_EXCHANGE_TYPE
        FROM  GM_ACCOUNTS_REVALUATION_RANGES
      WHERE Company_Code  = Q_REVALORIZATION.P_Company_Code
        AND Currency_Code   = Q_REVALORIZATION.Currency_Code
        and From_Acct_Level_1 <= Q_REVALORIZATION.LEVEL_1
        and To_Acct_Level_1 >= Q_REVALORIZATION.LEVEL_1
        and From_Acct_Level_2 <= Q_REVALORIZATION.LEVEL_2
        and To_Acct_Level_2 >= Q_REVALORIZATION.LEVEL_2
        and From_Acct_Level_3 <= Q_REVALORIZATION.LEVEL_3
        and To_Acct_Level_3 >= Q_REVALORIZATION.LEVEL_3
        and From_Acct_Level_4 <= Q_REVALORIZATION.LEVEL_4
        and To_Acct_Level_4 >= Q_REVALORIZATION.LEVEL_4
        and From_Acct_Level_5 <= Q_REVALORIZATION.LEVEL_5
        and To_Acct_Level_5 >= Q_REVALORIZATION.LEVEL_5
        and From_Acct_Level_6 <= Q_REVALORIZATION.LEVEL_6
        and To_Acct_Level_6 >= Q_REVALORIZATION.LEVEL_6
        and From_Acct_Level_7 <= Q_REVALORIZATION.LEVEL_7
        and To_Acct_Level_7 >= Q_REVALORIZATION.LEVEL_7
        and From_Acct_Level_8 <= Q_REVALORIZATION.LEVEL_8
        and To_Acct_Level_8 >= Q_REVALORIZATION.LEVEL_8;
        
   
          Ln_ExchangeRateType  := Nvl(Ln_ExchangeRateType,1);
    Exception
    	When No_Data_Found Then
          Ln_ExchangeRateType := 1;
      when too_many_rows Then
          Ln_ExchangeRateType := 1;
   End;
   ExchangeRateOrigin   := Null;
   Ln_ExchangeValue     := Null;
   :CP_ExchangeRateType := Ln_ExchangeRateType; 
   MG_F_CURRENCY_EXCHANGE ( :P_Company_Code,
                       :Currency_Code,
              		     :P_Local_Currency,
			                 Ln_ExchangeRateType,
			                 Ld_ExchangeRateDate,
			                 :P_DATE,
		  	               ExchangeRateOrigin,
		  	               ExchangeRateDestination,
		                   Ln_ExchangeValue,
	                     1 , --OriginAmount
	                     Ln_LocalCurrencyAmount,
	                     Ln_ExchangeDifference,
	                     Ln_ProfitLoss,
		                   Lv_ErrorMessage);
		 
   RETURN(Nvl(Ln_ExchangeValue,1));
end;

-- F_SALDO_EXTRANJERO1
function CF_FOREIGN_BALANCE return Number is
  Lv_AccountNature  VARCHAR2(1);
  Lv_ErrorCode        VARCHAR2(200) :=NULL ;
  DebitAmountFC      Number(19,6)  := 0;
  DebitAmountLC      Number(19,6)  := 0;
  CreditAmountFC      Number(19,6) := 0;
  CreditAmountLC      Number(19,6) := 0;
begin  
  For Reg in (Select a.*
                From gm_movimientos_detalle a , 
                     gm_movimientos_encabezado b
              Where
                    a.Company_Code    = Q_REVALORIZATION.P_Company_Code
                and a.Level_1           = Q_REVALORIZATION.LEVEL_1
                and a.Level_2           = Q_REVALORIZATION.LEVEL_2
                and a.Level_3           = Q_REVALORIZATION.LEVEL_3
                and a.Level_4           = Q_REVALORIZATION.LEVEL_4
                and a.Level_5           = Q_REVALORIZATION.LEVEL_5
                and a.Level_6           = Q_REVALORIZATION.LEVEL_6
                and a.Level_7           = Q_REVALORIZATION.LEVEL_7
                and a.Level_8           = Q_REVALORIZATION.LEVEL_8
                and b.Movement_Number = a.Movement_Number 
                and b.Username            = a.Username
                and b.Movement_Date  = a.Movement_Date
                and b.Valid_Date     <= Q_REVALORIZATION.P_DATE)
                
  Loop
    If Reg.Currency_Code = :Currency_Code Then
      If Reg.Debit_Credit = 'D' Then
         DebitAmountLC := DebitAmountLC + Reg.Local_Movement_Amount;
         DebitAmountFC := DebitAmountFC + Reg.Movement_Amount;
      Else
         CreditAmountLC := CreditAmountLC + Abs(Reg.Local_Movement_Amount);
         CreditAmountFC := CreditAmountFC + Abs(Reg.Movement_Amount);
      End If; 
    Else
      If Reg.Debit_Credit = 'D' Then
         DebitAmountLC := DebitAmountLC + Reg.Movement_Amount;
      Else
         CreditAmountLC := CreditAmountLC + Abs(Reg.Movement_Amount);
      End If;       
    End If;
  End Loop;  
  
  Lv_ErrorCode := GM_F_ACCOUNT_NATURE(Q_REVALORIZATION.P_Company_Code,
					Q_REVALORIZATION.LEVEL_1, 
					Q_REVALORIZATION.LEVEL_2,
					Q_REVALORIZATION.LEVEL_3,
					Q_REVALORIZATION.LEVEL_4,
					Q_REVALORIZATION.LEVEL_5,
					Q_REVALORIZATION.LEVEL_6,
					Lv_AccountNature);
   
  If Lv_AccountNature = 'D' Then
    :CP_Movement_Balance_LC := DebitAmountLC - CreditAmountLC;
    :CP_Movement_Balance_FC := DebitAmountFC - CreditAmountFC;
  Else
    :CP_Movement_Balance_LC := CreditAmountLC - DebitAmountLC;
    :CP_Movement_Balance_FC := CreditAmountFC - DebitAmountFC;
  End If;
  
  

  IF  ( Lv_AccountNature = 'D' AND :FOREIGN_BALANCE > 0 ) OR
      ( Lv_AccountNature = 'C' AND :FOREIGN_BALANCE < 0 )
  THEN
    RETURN (ABS(:FOREIGN_BALANCE + :CP_Movement_Balance_FC ));
  ELSE
    RETURN (ABS(:FOREIGN_BALANCE + :CP_Movement_Balance_FC) * -1 );
  END IF;

RETURN NULL; end;

--F_SALDO_NACIONAL
function CF_LOCAL_BALANCE return Number is
  Lv_AccountNature VARCHAR2(1);
  Lv_ErrorCode       VARCHAR2(200):=NULL ;
begin
  Lv_ErrorCode := GM_F_ACCOUNT_NATURE(:P_Company_Code,
					Q_REVALORIZATION.LEVEL_1, 
					Q_REVALORIZATION.LEVEL_2,
					Q_REVALORIZATION.LEVEL_3,
					Q_REVALORIZATION.LEVEL_4,
					Q_REVALORIZATION.LEVEL_5,
					Q_REVALORIZATION.LEVEL_6,
					Lv_AccountNature);

  IF  ( Lv_AccountNature = 'D' AND :LOCAL_BALANCE > 0 ) OR 
      ( Lv_AccountNature = 'C' AND :LOCAL_BALANCE < 0 )
  THEN
    RETURN (ABS(:LOCAL_BALANCE + :CP_Movement_Balance_LC));
  ELSE
    RETURN (ABS(:LOCAL_BALANCE + :CP_Movement_Balance_LC) * -1 );
  END IF;
RETURN NULL; end;

--F_MONTO_REV
function CF_REVALUATION_BALANCE return Number is
  Lv_AccountNature VARCHAR2(1);
  Lv_ErrorCode       VARCHAR2(200):=NULL ;
begin  
  Lv_ErrorCode := GM_F_ACCOUNT_NATURE(Q_REVALORIZATION.P_Company_Code,
					Q_REVALORIZATION.LEVEL_1, 
					Q_REVALORIZATION.LEVEL_2,
					Q_REVALORIZATION.LEVEL_3,
					Q_REVALORIZATION.LEVEL_4,
					Q_REVALORIZATION.LEVEL_5,
					Q_REVALORIZATION.LEVEL_6,
					Lv_AccountNature);
  IF  ( Lv_AccountNature = 'D' AND :CF_REVALUATION_AMOUNT > 0 ) OR 
      ( Lv_AccountNature = 'C' AND :CF_REVALUATION_AMOUNT < 0 )
  THEN
    RETURN (ABS(:CF_REVALUATION_AMOUNT));
  ELSE
    RETURN (ABS(:CF_REVALUATION_AMOUNT) * -1 );
  END IF;
RETURN NULL; end;

-- F_Diferencia
function CF_DIFFERENCE return Number is
 Ln_Difference   number(14,2);
begin
 Ln_Difference := nvl(LOCAL_BALANCE,0) + nvl(CP_Movement_Balance_LC,0) - nvl(CF_REVALUATION_AMOUNT,0);
 RETURN(Ln_Difference);
end;