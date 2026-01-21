-- Q_DETALLE --> Q_DETAIL:
SELECT COMPANY_CODE COMPANY, 
 COMPANY_CODE COMPANYCODE, 
APPLICATION_CODE, 
TITLE1, 
BREAKDOWN_DATA1, 
 TITLE2, 
 BREAKDOWN_DATA2, 
 TITLE3, 
 BREAKDOWN_DATA3, 
 TITLE4, 
 BREAKDOWN_DATA4,  
 TITLE5, 
 BREAKDOWN_DATA5, 
 TITLE6, 
 BREAKDOWN_DATA6, 
 TITLE7, 
 BREAKDOWN_DATA7, LEVEL_1 LEVEL1, LEVEL_2 LEVEL2, 
 LEVEL_3 LEVEL3, LEVEL_4 LEVEL4, LEVEL_5 LEVEL5, LEVEL_6 LEVEL6, LEVEL_7 LEVEL7, 
 LEVEL_8 LEVEL8, TXN_ENTRY_AMOUNT, CURRENCY_CODE CURRENCY,
BREAKDOWN_DATA_CODE1,
BREAKDOWN_DATA_CODE2,
BREAKDOWN_DATA_CODE3,
BREAKDOWN_DATA_CODE4,
BREAKDOWN_DATA_CODE5,
BREAKDOWN_DATA_CODE6,
BREAKDOWN_DATA_CODE7,
TXN_ENTRY_DATE AS TXN_DATE,
TXN_ENTRY_DATE AS DATE
 CURRENCY_CODE CURRENCY_SUBQUERY
 FROM GM_V_COMPARATIVES
WHERE BRANCH_CODE = NVL(:P_BRANCH, BRANCH_CODE)
AND SUB_APPLICATION_CODE = NVL(:P_SUB_APPLICATION_CODE, SUB_APPLICATION_CODE)
AND TXN_ENTRY_DATE = :P_DATE
 order by to_number(BREAKDOWN_DATA_CODE1),
          to_number(BREAKDOWN_DATA_CODE2),
          to_number(BREAKDOWN_DATA_CODE3) 



-- Q_ENCABEZADO --> Q_HEADER:
 SELECT DISTINCT b.COMPANY_CODE, B.APPLICATION_CODE APPLICATION,
B.TXN_ENTRY_DATE TXN_DATE,
B.CURRENCY_CODE MAIN_CURRENCY,
SUBSTR(b.LEVEL_1,1,1) INITIAL_ACCOUNT,
  b.LEVEL_1     ,
  b.LEVEL_2     ,
  b.LEVEL_3     ,
  b.LEVEL_4     ,
  b.LEVEL_5     ,
  b.LEVEL_6     ,
  b.LEVEL_7     ,
  b.LEVEL_8     
FROM --GM_COMPARATIVO A,
           GM_V_COMPARATIVES B
WHERE B.BRANCH_CODE = NVL(P_BRANCH, B.BRANCH_CODE)
/*AND (B.APPLICATION_CODE = NVL(:P_APPLICATION_CODE, B.APPLICATION_CODE)*/
AND (B.APPLICATION_CODE = :P_APPLICATION_CODE 
         OR  :P_APPLICATION_CODE = 'ALL')
AND B.SUB_APPLICATION_CODE = NVL(:P_SUB_APPLICATION_CODE, B.SUB_APPLICATION_CODE)
/*AND A.LEVEL_1 = NVL(:P_LEVEL1, A.LEVEL_1)
AND A.LEVEL_2 = NVL(:P_LEVEL2, A.LEVEL_2)
AND A.LEVEL_1 = B.LEVEL_1
AND A.LEVEL_2 = B.LEVEL_2
AND A.LEVEL_3 = B.LEVEL_3
AND A.LEVEL_4 = B.LEVEL_4
AND A.LEVEL_5 = B.LEVEL_5
AND A.LEVEL_6 = B.LEVEL_6
AND A.LEVEL_7 = B.LEVEL_7
AND A.LEVEL_8 = B.LEVEL_8*/
AND b.TXN_ENTRYDATE = :P_DATE
order by 4,5, 6,7,8,9,10,11,12,13


-- funciones:
-- F_APPLICATION_NAME
function CF_APPLICATION_NAME return Char is
Lv_name varchar2(90);
begin
	Begin
		Select NAME
		into Lv_name
		from MG_APPLICATIONS
		where APPLICATION_CODE = :APPLICATION;
	Exception
		when others then null;
	End;
	
	return(Lv_name);
end;



-- F_CURRENCY_DESCRIPTION
function CF_CURRENCY_DESCRIPTION return Char is
Lv_field_information varchar(90);
begin
         BEGIN
               SELECT DESCRIPTION
            INTO Lv_field_information
            FROM MG_CURRENCY
            WHERE CURRENCY_CODE = Q_HEADER.MAIN_CURRENCY;
       EXCEPTION
                   WHEN OTHERS THEN Lv_field_information:= NULL;
        END;
   return(Lv_field_information);
end;



-- F_ACCOUNT_TYPE
FUNCTION CF_ACCOUNT_TYPE
   RETURN CHAR IS
   lv_level_1                    VARCHAR (4);
   lv_level_2                    VARCHAR (4);
   lv_level_3                    VARCHAR (4);
   lv_level_4                    VARCHAR (4);
   lv_level_5                    VARCHAR (4);
   lv_level_6                    VARCHAR (4);
   lv_level_7                    VARCHAR (4);
   lv_level_8                    VARCHAR (4);
   lv_account_name               VARCHAR (100);
BEGIN
   BEGIN
      SELECT LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5, LEVEL_6, LEVEL_7, LEVEL_8
        INTO lv_level_1, lv_level_2, lv_level_3, lv_level_4, lv_level_5, lv_level_6, lv_level_7,
             lv_level_8
        FROM (SELECT   LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5, LEVEL_6, LEVEL_7, LEVEL_8
                  FROM GM_ACCOUNT_BALANCE
                 WHERE SUBSTR (LEVEL_1, 1, 1) = :INITIAL_ACCOUNT
              ORDER BY 1, 2, 3, 4, 5, 6, 7, 8)
       WHERE ROWNUM = 1;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      SELECT DESCRIPTION
        INTO lv_account_name
        FROM GM_ACCOUNT_BALANCE
       WHERE LEVEL_1 = lv_level_1 AND
             LEVEL_2 = lv_level_2 AND
             LEVEL_3 = lv_level_3 AND
             LEVEL_4 = lv_level_4 AND
             LEVEL_5 = lv_level_5 AND
             LEVEL_6 = lv_level_6 AND
             LEVEL_7 = lv_level_7 AND
             LEVEL_8 = lv_level_8;
   EXCEPTION
      WHEN OTHERS THEN
         lv_account_name:=sqlerrm; 
   END;

   RETURN (lv_account_name);
END;



-- F_ACCOUNT
function CF_ACCOUNT return Char is
Pv_Format VARCHAR2(39);
begin
  GM_P_DISPLAY_R(Q_HEADER.LEVEL_1, Q_HEADER.LEVEL_2, Q_HEADER.LEVEL_3, Q_HEADER.LEVEL_4, Q_HEADER.LEVEL_5,
      Q_HEADER.LEVEL_6, Q_HEADER.LEVEL_7, Q_HEADER.LEVEL_8,Q_HEADER.COMPANY_CODE, Pv_Format);
  RETURN(Pv_Format);
end;



-- F_MONTO10
function CF_MAJOR_BALANCE_EXT return Number is
Ln_amount number := 0;
Begin
	Begin
		Select (CASE
      WHEN NVL(A.EXT_GENERAL_LEDGER_BALANCE,0) = 0 THEN  A.MAJOR_BALANCE
 			ELSE  A.EXT_GENERAL_LEDGER_BALANCE
 			END )
		Into Ln_amount
		FROM GM_COMPARISON A
		WHERE A.LEVEL_1 = Q_HEADER.LEVEL_1
		AND A.LEVEL_2 = Q_HEADER.LEVEL_2
		AND A.LEVEL_3 = Q_HEADER.LEVEL_3
		AND A.LEVEL_4 = Q_HEADER.LEVEL_4
		AND A.LEVEL_5 = Q_HEADER.LEVEL_5
		AND A.LEVEL_6 = Q_HEADER.LEVEL_6
		AND A.LEVEL_7 = Q_HEADER.LEVEL_7
		AND A.LEVEL_8 = Q_HEADER.LEVEL_8
		AND a.TXN_ENTRY_DATE = Q_HEADER.TXN_DATE;
	Exception
		when others then null;
	End;
	
	return(Ln_amount);
	
  
end;



-- F_MONTO2
function CF_MAJOR_BALANCE return Number IS
Ln_amount number := 0;
Begin
	Begin
		Select NVL(A.MAJOR_BALANCE, 0)   MAJOR_BALANCE
		Into Ln_amount
		FROM GM_COMPARATIVO A
		WHERE A.LEVEL_1 = :LEVEL_1
		AND A.LEVEL_2 = :LEVEL_2
		AND A.LEVEL_3 = :LEVEL_3
		AND A.LEVEL_4 = :LEVEL_4
		AND A.LEVEL_5 = :LEVEL_5
		AND A.LEVEL_6 = :LEVEL_6
		AND A.LEVEL_7 = :LEVEL_7
		AND A.LEVEL_8 = :LEVEL_8
		AND a.TXN_ENTRY_DATE = :TXN_DATE;
	Exception
		when others then null;
	End;
	
	return(Ln_amount);
	
  
end;



-- F_MONTO1
function CF_1 return Number is
Ln_amount number := 0;
Begin
	Ln_amount := CF_MAJOR_BALANCE - :cs_1;
	return(Ln_amount);
end;



-- F_DESCRIPCION_CTA1
function CF_ACCOUNT_DESCRIPTIONFormula return Char is
ACCOUNT_DESCRIPTION VARCHAR2(80);
begin
  SELECT DESCRIPTION
    INTO ACCOUNT_DESCRIPTION
    FROM GM_ACCOUNT_BALANCE
  WHERE COMPANY_CODE = Q_HEADER.COMPANY_CODE
    AND LEVEL_1        = Q_HEADER.LEVEL_1
    AND LEVEL_2        = Q_HEADER.LEVEL_2
    AND LEVEL_3        = Q_HEADER.LEVEL_3
    AND LEVEL_4        = Q_HEADER.LEVEL_4
    AND LEVEL_5        = Q_HEADER.LEVEL_5
    AND LEVEL_6        = Q_HEADER.LEVEL_6
    AND LEVEL_7        = Q_HEADER.LEVEL_7
    AND LEVEL_8        = Q_HEADER.LEVEL_8;
  RETURN(ACCOUNT_DESCRIPTION);
RETURN NULL; EXCEPTION
WHEN NO_DATA_FOUND THEN
   RETURN(ACCOUNT_DESCRIPTION);
end;



-- F_LOCAL_CURRENCY_AMOUNT
function CF_LOCAL_CURRENCY_AMOUNTFormula return Number is

Ln_local_currency_code number(2);
Ln_destination_amount       number := 0;
Gn_ExchangeRateOrigin    number;
Gn_ExchangeRateDestination   number;
Gn_RateFactor          number;
Gn_exchangedifference	   number;
Gn_GainLoss	   number;
Gv_ErrorMessage        varchar2(100);
Gd_ExchangeDateOrigin   date;
begin
	Begin
		Select LOCAL_CURRENCY_CODE
		into Ln_local_currency_code
		from MG_PARAMETROS_GENERALES
		where COMPANY_CODE = :COMPANYCODE;
	Exception
		when others then 
			Ln_local_currency_code := 1;
	End;
	Gd_ExchangeDateOrigin := Q_HEADER.DATE;
	
  MG_F_CAMBIOMONEDA(:COMPANYCODE,
						Q_HEADER.CURRENCY, --Gn_CurrencyCodeOrigin 	IN 	NUMBER,
						Ln_local_currency_code,
						1, --Gn_ExchangeType   		IN 	NUMBER,
							--  1 = contable
							--  2 = Compra
							--  3 = Venta
							--- 4 = Compra Oficial
						Gd_ExchangeDateOrigin,
						P_DATE,
		  			Gn_ExchangeRateOrigin  ,
		  			Gn_ExchangeRateDestination ,
						Gn_RateFactor   		 ,
						Q_DETAIL.TXN_ENTRY_AMOUNT    ,
						Ln_destination_amount     ,
						Gn_exchangedifference	 ,
						Gn_GainLoss	 ,
						Gv_ErrorMessage 		 );
	
	--Ln_destination_amount     = :TXN_AMOUNT;
						
	return(Ln_destination_amount);
end;