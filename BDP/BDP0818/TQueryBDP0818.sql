-- Q_AVISO_DISMINUCION_DEPOSITO_A_PLAZO

SELECT 
b.BANK_NAME,
(A.BRANCH_CODE||'-'||A.SUBAPPLICATION_CODE||'-'||A.DEPOSIT_NBR)     DEPOSIT_NBR,
A.EFFECTIVE_DATE                                                    EFFECTIVE_DATE,
A.DUE_DATE                                                          DUE_DATE, 
B.VALUE                                                             VALUE,
A.ADDED_BY                                                          ADDED_BY,
A.VALUE_DATE                                                        VALUE_DATE,
A.DEPOSIT_NBR                                                       DEPOSIT_NBR_1,
A.BRANCH_CODE                                                       BRANCH_CODE,
A.SUBAPPLICATION_CODE                                               SUBAPPLICATION_CODE,
A.APPLICATION_CODE                                                  APPLICATION_CODE,
B.PAYMENT_TYPE_CODE                                                 PAYMENT_TYPE_CODE,
B.CONTRA_BRANCH_CODE                                                CONTRA_BRANCH_CODE,
B.SUBAPPLICATION_QUANTITYER_CODE                                    SUBAPPLICATION_QUANTITYER_CODE,
B.CONTRA_ACCOUNT_CODE                                               CONTRA_ACCOUNT_CODE,
E.DESCRIPTION                                                       DESCRIPTION,
F.ADDRESS_CODE                                                      ADDRESS_CODE,
A.MAIN_OWNER_CODE                                                   MAIN_OWNER_CODE,
F.ZONE||F.NEIGHBORHOOD||F.STREET                                    ADDRESS,
G.VALUE                                                             NEW_BALANCE,
G.VALUE - A.VALUE                                                   PREVIOUS_BALANCE,
B.REFERENCE_CHECK_NBR                                               REFERENCE_CHECK_NBR,
DECODE(
    A.MATHEMATICAL_OPERATOR,
    '-',
    (A.RATE_VALUE -NVL(A.SPREAD,0)),
    '+',
    (A.RATE_VALUE +NVL( A.SPREAD,0))
)                                                                   RATE_VALUE,
M.ABBREVIATION                                                      ABBREVIATION,
O.CLIENT_CODE                                                       CLIENT_CODE, 
O.ACCOUNT_CODE                                                      ACCOUNT_CODE,
O.RELATION_Y_O                                                      RELATION_Y_O
FROM DP_TXN_ENTRIES_DAILY A,
DP_TXN_ENTRIES_BREAKDOWN B,
MG_CLIENTS D, 
MG_DISBURSEMENT_PAYMENT_METHODS E,
MG_ADDRESSES F,
DP_ACCT_BALANCES G,
MG_SUBAPPLICATIONS      S,
MG_CURRENCY                       M,
DP_OWNERS O

WHERE 
(A.DEPOSIT_NBR = P_DEPOSIT_NBR OR P_DEPOSIT_NBR IS NULL)
AND(A.TXN_ENTRY_NBR = P_TXN_ENTRY_NBR OR P_TXN_ENTRY_NBR IS NULL)
AND (A.BRANCH_CODE = P_BRANCH OR  P_BRANCH IS NULL)
AND (A.ADDED_BY = P_USER OR P_USER IS NULL)
AND A.TXN_ENTRY_NBR = B.TXN_ENTRY_NBR
AND A.BRANCH_CODE = B.BRANCH_CODE 
AND A.SUBAPPLICATION_CODE = B.SUBAPPLICATION_CODE
AND A.DEPOSIT_NBR = B.DEPOSIT_NBR
AND A.COMPANY_CODE = B.COMPANY_CODE
AND A.MAIN_OWNER_CODE = D.CLIENT_CODE
AND O.CLIENT_CODE = D.CLIENT_CODE
AND O.APPLICATION_CODE = A.APPLICATION_CODE
AND D.CLIENT_CODE = F.CLIENT_CODE(+)
AND A.TRANSACTION_TYPE_CODE = 18
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


--FUNCIONES:
-- F_DESCRIPCION
function CF_DESCRIPCION return Char is
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

-- F_VALOR_MONTO:
function CF_VALOR return Char is
 Lv_amount    varchar2(25);
begin
lv_amount := Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(Q_MOVEMENTS.VALUE,0),'999,999,999,999,990.00')); 
  return(lv_amount);
end;


-- CF_SALDOTOTAL
function CF_TOTAL_BALANCE return Number is
Ln_Total_Balance number(18,2);
Ln_Retained_Balance number(18,2);
begin
 Select nvl(Q_MOVEMENTS.VALUE,0) 
 into Ln_Retained_Balance 
 FROM DP_ACCT_BALANCES 
 WHERE DEPOSIT_NBR = Q_MOVEMENTS.DEPOSIT_NBR and
       BRANCH_CODE  = Q_MOVEMENTS.BRANCH_CODE  and
       SUBAPPLICATION_CODE = Q_MOVEMENTS.SUBAPPLICATION_CODE and
       APPLICATION_CODE     = 'BDP' and
       BALANCE_TYPE_CODE     = 10;
       Ln_Total_Balance    := NVL(Ln_Retained_Balance,0) + NVL(Q_MOVEMENTS.NEW_BALANCE,0);
       RETURN(Ln_Total_Balance);
Exception When Others Then 
	Ln_Retained_Balance := 0;
        Ln_Total_Balance    := nvl(Ln_Retained_Balance,0) + nvl(Q_MOVEMENTS.NEW_BALANCE,0);     
        RETURN(Ln_Total_Balance);
end;
return 0;


-- F_saldoanterior
function CF_saldoanterior return Char is
Ln_Previous_Total_Balance   number(14,2);
Lv_PreviousBalance     varchar2(30);
begin
  Ln_Previous_Total_Balance := nvl(CF_TOTAL_BALANCE,0) + nvl(Q_MOVEMENTS.VALUE,0);
  lv_PreviousBalance :=  Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(Ln_Previous_Total_Balance,0),'999,999,999,999,990.00')); 
  RETURN(lv_PreviousBalance);
end;

-- F_nuevo_saldo
function CF_NEW_BALANCE_f return Char is
Lv_total_balance   varchar2(30);
begin
  lv_total_balance :=  Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(CF_TOTAL_BALANCE,0),'999,999,999,999,990.00'));  
  RETURN(Lv_Total_Balance);
end;


-- F_amento_capital
function CF_INCRE_CAPITAL return Char is
 Lv_amount    varchar2(25);
begin
lv_amount := Q_MOVEMENTS.ABBREVIATION||' '||ltrim(to_char(nvl(Q_MOVEMENTS.VALUE,0),'999,999,999,999,990.00')); 
  return(lv_amount);
end;

-- F_CLIENTE
function CF_CLIENT return Char is
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
function CF_OWNER return Char is
Gv_ClientName       varchar2(130);
Gv_ErrorCode         varchar2(80);
begin
  DP_P_OBTIENE_NOMBRE_CLIENTE(Q_MOVEMENTS.CLIENT_CODE,
			       Gv_ClientName,
                               Gv_ErrorCode);
   IF Gv_ErrorCode <> null THEN
      NULL;
   END IF;
   return (Gv_ClientName);
end;


-- CF_GET_ADDRESS - Get Client Address
procedure  CF_GET_ADDRESS(Gn_Client_Code  IN NUMBER,
                      Gn_Address_Code IN NUMBER, Gn_CorrespondenceType IN NUMBER,
		      Gv_Address IN OUT VARCHAR2 ,Gv_ErrorCode IN OUT VARCHAR2)
IS
paragraph_count        number(3):=0;
end_line_1             number(3):=0;
address_line_1         varchar2(160);
start_line_2           number(3):=0;
end_line_2             number(3):=0;
address_line_2         varchar2(50);
start_line_3           number(3):=0;
end_line_3             number(3):=0;
length_1               number(3):=0;
length_2               number(3):=0;
length_3               number(3):=0;
length_4               number(3):=0;
address_line_3         varchar2(150);
start_line_4           number(3):=0;
end_line_4             number(3):=0;
address_line_4         varchar2(150);
final_length           number(3):=0;
client_address         varchar2(120);
lv_nomenclature_2      varchar2(120);
ln_address             varchar2(200);
lv_combined_addresses  varchar2(250);
    BEGIN
    SELECT NOMENCLATURE, NOMENCLATURE_2
    INTO   client_address, lv_nomenclature_2
    FROM   MG_ADDRESSES
    WHERE  CLIENT_CODE = Gn_Client_Code
    AND    ADDRESS_CODE = Gn_Address_Code;
    lv_combined_addresses := client_address||lv_nomenclature_2;
    begin
    for i in 1..160 loop
        if substr(lv_combined_addresses,i,1)<>'^' then
        end_line_1:=end_line_1 + 1;
        else
        exit;
        end if;
    end loop;
    if lv_combined_addresses is null then
        address_line_1:=null;
    else
        address_line_1:=substr(lv_combined_addresses,1,end_line_1);
    end if;
    end;
    begin
    if Gn_CorrespondenceType = 1 then
        begin
        start_line_2 :=length(address_line_1)+ 2;
        end_line_2:=start_line_2 - 1;
        for i in start_line_2..160 loop
            if substr(lv_combined_addresses,i,1)= '^' then
                exit;
            else
                end_line_2:=end_line_2 + 1;
            end if;
        end loop;
        if  end_line_2 < start_line_2 then
            address_line_2:=null;
        else
            length_2:=end_line_2-start_line_2 + 1;
            address_line_2:=substr(lv_combined_addresses,start_line_2,length_2);
        end if;
        end;
    end if;
    end;
    begin
    if Gn_CorrespondenceType = 1 then
        begin
        start_line_3 :=length(address_line_1) + length(address_line_2)+ 3;
        end_line_3:=start_line_3 - 1;
        for i in start_line_3..160 loop
            if substr(lv_combined_addresses,i,1)='^' then
                exit;
            else
                end_line_3:=end_line_3 + 1;
            end if;
        end loop;
        if end_line_3 < start_line_3 then
            address_line_3:=null;
        else
            length_3:=end_line_3-start_line_3 + 1;
            address_line_3:=substr(lv_combined_addresses,start_line_3,length_3);
        end if;
        end;
    end if;
    end;
    begin
    if Gn_CorrespondenceType = 1 then
        begin
        final_length:= length(lv_combined_addresses);
        start_line_4:= length(address_line_1)+ length(address_line_2)+ length(address_line_3)+ 4;
        end_line_4:=start_line_4 - 1;
        final_length:=final_length-start_line_4+1;
        address_line_4:=substr(lv_combined_addresses,start_line_4,final_length);
        end;
    else
        address_line_4:=null;
    end if;
    end;
    Gv_address := address_line_2||' '||address_line_3||' '||address_line_4;
    return ' ';
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        Gv_ErrorCode := MG_K_CTRL_ERROR.MG_F_ARMAR_CODIGO_ERROR(401,'CF_GET_ADDRESS', NULL);
        return ' ';
    WHEN TOO_MANY_ROWS THEN
        null;
        return ' ';
    WHEN OTHERS THEN
        null;
        return ' ';
    END;


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
  and    COMPANY_CODE = CP_COMPANY_CODE;
  return(Ln_correspondence);
RETURN NULL; exception
  when no_data_found then
       null;
  RETURN NULL; when others then 
       null;
RETURN NULL; end;


-- F_DIRECCION
function CF_ADDRESS return Char is
Gv_Address     varchar2(200);
Gv_ErrorCode   varchar2(200);
   
BEGIN
     CF_GET_ADDRESS(Q_MOVEMENTS.MAIN_OWNER_CODE, Q_MOVEMENTS.ADDRESS_CODE, CF_CORRESPONDENCE,  
			   Gv_Address, Gv_ErrorCode);
     return(Gv_Address);
     if Gv_ErrorCode is not null then
        null;
     end if;
end;


