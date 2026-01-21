-- 1: CF_EXCHANGE_RATE
-- 2: CF_AMOUNT_DEBIT
-- 3: CF_AMOUNT_CREDIT
-- 4: CF_Total_Debit
-- 5: CF_ACCOUNT_DESC


-- Q_CUENTAS
SELECT   
  a.level_1                AS level_1, 
  a.level_2                AS level_2, 
  a.level_3                AS level_3, 
  a.level_4                AS level_4, 
  a.level_5                AS level_5, 
  a.level_6                AS level_6, 
  a.level_7                AS level_7, 
  a.level_8                AS level_8, 
  a.credit_debit           AS credit_debit, 
  ABS(a.txn_entry_amount)  AS amount_mov,
  a.auxiliary_code         AS auxiliary_code,
  a.line_seq               AS line_seq,
  b.username               AS username,
  b.txn_entry_nbr          AS txn_entry_nbr,
  b.txn_entry_date         AS txn_entry_date,
  b.effdate                AS effdate,
  a.reference              AS reference,

  DECODE(a.credit_debit,'D',
         DECODE(a.currency_code, d.local_currency_code,
                a.txn_entry_amount, a.txn_entry_local_amount)
  ) AS amount_debit,

  DECODE(a.credit_debit,'C',
         DECODE(a.currency_code, d.local_currency_code,
                a.txn_entry_amount, a.txn_entry_local_amount)
  ) AS amount_credit,

  DECODE(a.credit_debit,'D', a.txn_entry_amount) AS amount_debit_curr,
  DECODE(a.credit_debit,'C', a.txn_entry_amount) AS amount_credit_curr,

  b.description            AS header_desc,
  a.currency_code          AS currency_code,
  c.description            AS currency_desc,
  a.description            AS detail_desc,

  b.txn_entry_date         AS txn_date,

  DECODE(a.currency_code,
         d.local_currency_code,
         b.total_control,
         b.total_control * NVL(a.exchange_rate,1)
  ) AS total_control,

  b.unit_code              AS unit_code,

  DECODE(a.exchange_rate, NULL, 1, a.exchange_rate) AS exchange_rate,

  a.cost_center              AS cost_center,
  a.presupuesto_code              AS presupuesto_code,
  a.presupuesto_class             AS presupuesto_class,
  a.auxiliary_code           AS auxiliary_code,

  DECODE(b.exchange_rate, NULL, 1, b.exchange_rate) AS header_exchange_rate,

  b.branch_code            AS branch_code,
  a.concept_application    AS concept_application,
  a.transaction_concept    AS transaction_concept

FROM  bc_comprobantes b,
      BC_DETAILS_VOUCHERS a, 
      MG_CURRENCY c, 
      MG_PARAMETERS_GENERAL d
WHERE b.company_code      = nvl(TO_NUMBER(p_company_code), b.company_code)
  AND a.username          = b.username
  AND a.txn_entry_nbr     = b.txn_entry_nbr
  AND a.txn_entry_date    = b.txn_entry_date   
  AND c.currency_code     = a.currency_code
  AND d.company_code      = b.company_code
ORDER BY 
     b.username,
     b.txn_entry_nbr,
     b.txn_entry_date, 
     a.concept_application, 
     a.transaction_concept, 
     a.line_seq

  

-- Q_SUCURSAL
SELECT      
  ABS(SUM(
        DECODE(a.credit_debit, 'D',
            DECODE(a.currency_code, d.local_currency_code,
                   a.txn_entry_amount, a.txn_entry_local_amount)
        )
  )) AS sum_db,
  ABS(SUM(
        DECODE(a.credit_debit, 'C',
            DECODE(a.currency_code, d.local_currency_code,
                   ABS(a.txn_entry_amount), ABS(a.txn_entry_local_amount))
        )
  )) AS sum_cr
FROM bc_comprobantes b,   
     BC_DETAILS_VOUCHERS a,
     MG_CURRENCY c,
     GM_SETTINGS d
WHERE b.company_code        = nvl(TO_NUMBER(P_COMPANY_CODE), b.company_code)
  AND a.USERNAME             = b.username
  AND a.TXN_ENTRY_NBR   = b.txn_entry_nbr
  AND a.TXN_ENTRY_DATE    = b.txn_entry_date  
  AND c.CURRENCY_CODE       = a.currency_code
  AND d.COMPANY_CODE      = b.company_code

-- BEFORE REPORT
function BeforePForm return boolean is
begin
    pu_p_initialize_report(:P_COMPANY,
                           :P_COMPANY_NAME,
                           :P_ACTION,
                           :DesType,
                           :DesFormat,
                           :P_USER_CONNECT,
                           :P_SERVERNAME);

    :P_COMPANY_CODE := :P_COMPANY;

    begin
        SELECT NAME
        INTO :P_APP_NAME
        FROM mg_aplicaciones
        WHERE APPLICATION_CODE = :p_application_code;
    exception
        when no_data_found then null;
        when others then null;
    end;

    return TRUE;
end;

-- F_DEB
  function CF_MONTO_DEB_MONFormula return Number is
  begin
    RETURN(abs(:monto_debito_MON));    
  end;
-- TRADUCCIÓN
  function CF_AMOUNT_DEBIT return Number is
  begin
    RETURN(abs(Q_ACCOUNTS.AMOUNT_DEBIT_CURR));    
  end;


-- F_CRED
function CF_MONTO_CRED_MONFormula return Number is
begin
    RETURN(abs(:monto_credito_MON));   
end;
-- TRADUCCIÓN
function CF_AMOUNT_CREDIT return Number is
begin
    RETURN(abs(Q_ACCOUNTS.AMOUNT_CREDIT_CURR));   
end;

-- CF_MOVIMIETO_DEBITO
function CF_TOTAL_DEBIT return Number is
begin
     RETURN(abs(Q_ACCOUNTS.amount_debit));    
END;

-- CF_MOVIMIENTO_CREDITO
function CF_TOTAL_CREDIT return Number is
begin
      RETURN(abs(Q_ACCOUNTS.amount_credit));   
end;

function CF_DESCCUENTAFormula return VARCHAR2 is

lv_descripcion    VARCHAR2(80);
DESCRIPCIONCUENTA VARCHAR2(80);
Begin
  Begin
    SELECT DESCRIPCION
      INTO DESCRIPCIONCUENTA
      FROM GM_BALANCE_CUENTAS
    WHERE CODIGO_EMPRESA = :P_CODIGO_EMPRESA
      AND NIVEL_1        = :NIVEL_1
      AND NIVEL_2        = :NIVEL_2
      AND NIVEL_3        = :NIVEL_3
      AND NIVEL_4        = :NIVEL_4
      AND NIVEL_5        = :NIVEL_5
      AND NIVEL_6        = :NIVEL_6
      AND NIVEL_7        = :NIVEL_7
      AND NIVEL_8        = :NIVEL_8;
    --RETURN(DESCRIPCIONCUENTA);
    --RETURN NULL; 
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN(DESCRIPCIONCUENTA);
  End;
  IF :codigo_auxiliar is not null then
    Begin
  	  Select descripcion
  	    into lv_descripcion
  	    from gm_codigos_auxiliares
  	   where codigo_auxiliar = :codigo_auxiliar;
    exception
    	when no_data_found then
    	  lv_descripcion := NULL;
    End;
    DESCRIPCIONCUENTA := SUBSTR(DESCRIPCIONCUENTA||' - '||Lv_Descripcion,1,80);
  End If;
  RETURN(DESCRIPCIONCUENTA);
End;


-- CF_FORMULA 
function CF_FORMULA return VARCHAR2 is
            pv_format VARCHAR2(39);
        begin
            GM_P_DESPLEGAR_R(Q_ACCOUNTS.level_1, Q_ACCOUNTS.level_2, Q_ACCOUNTS.level_3, Q_ACCOUNTS.level_4, Q_ACCOUNTS.level_5,
                             Q_ACCOUNTS.level_6, Q_ACCOUNTS.level_7, Q_ACCOUNTS.level_8, P_COMPANY_CODE, pv_format);
            RETURN(pv_format);
        end;

-- F_DESC_AUX
function CF_DSP_CONCEPT return CHAR is
            lv_description varchar2(60);
        begin
            begin
                select DESCRIPTION
                into   lv_description
                from   MG_TRANSACTION_TYPES
                where  APPLICATION_CODE       = Q_ACCOUNTS.concept_application
                and    TRANSACTION_TYPE_CODE  = Q_ACCOUNTS.transaction_concept;
            exception
                when no_data_found then
                    lv_description := null;
            end;
            lv_description := Q_ACCOUNTS.concept_application || '-' || lv_description;
            return(lv_description);
        end;



-- CF_ACCOUNT_DESC (Account Description)
-- Retrieves the account description from GM_ACCOUNT_BALANCE and optionally appends auxiliary code description
function CF_ACCOUNT_DESC return VARCHAR2 is

lv_aux_description    VARCHAR2(80);
account_description   VARCHAR2(80);
Begin
  Begin
    SELECT DESCRIPTION
      INTO account_description
      FROM GM_ACCOUNT_BALANCE
    WHERE COMPANY_CODE = NVL(P_COMPANY_CODE, COMPANY_CODE)
      AND LEVEL_1      = Q_ACCOUNTS.LEVEL_1
      AND LEVEL_2      = Q_ACCOUNTS.LEVEL_2
      AND LEVEL_3      = Q_ACCOUNTS.LEVEL_3
      AND LEVEL_4      = Q_ACCOUNTS.LEVEL_4
      AND LEVEL_5      = Q_ACCOUNTS.LEVEL_5
      AND LEVEL_6      = Q_ACCOUNTS.LEVEL_6
      AND LEVEL_7      = Q_ACCOUNTS.LEVEL_7
      AND LEVEL_8      = Q_ACCOUNTS.LEVEL_8; 
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN(account_description);
      when others then null;
  End;
  IF Q_ACCOUNTS.auxiliary_code is not null then
    Begin
  	  Select DESCRIPTION
  	    into lv_aux_description
  	    from GM_CODES_AUXILIARY
  	   where AUXILIARY_CODE = Q_ACCOUNTS.auxiliary_code;
    exception
    	when no_data_found then
    	  lv_aux_description := NULL;
        when others then null;
    End;
    account_description := SUBSTR(account_description||' - '||lv_aux_description,1,80);
  End If;
  RETURN(account_description);
End;


function CF_EXCHANGE_RATE return Number is

begin
  
  IF NVL(Q_ACCOUNTS.exchange_rate,1)      = 1 AND
     NVL(Q_ACCOUNTS.header_exchange_rate,1) != 1 AND
     NVL(Q_ACCOUNTS.currency_code,1)   != 1
  THEN
   
     RETURN(Q_ACCOUNTS.header_exchange_rate);
  ELSE
     RETURN(Q_ACCOUNTS.exchange_rate);
  END IF;
RETURN NULL; 
end;



function CF_DiferenciaFormula return VARCHAR2 is
begin
  IF ABS(:CS_SUMA_CREDITOS) != ABS(:CS_SUMA_DEBITOS) 
  THEN
     RETURN('Los Totales de Débitos y Créditos no coinciden');
  ELSIF :TOTAL_CONTROL != 0 THEN
        IF ABS(:CS_SUMA_CREDITOS) != ABS(:TOTAL_CONTROL)  OR
           ABS(:CS_SUMA_DEBITOS)  != ABS(:TOTAL_CONTROL)  THEN
           RETURN('Los Totales del Cr. o Db.no coincide con total ctrl.');
        END IF;
  ELSE
     RETURN(NULL);
  END IF;
RETURN NULL; end;

function CF_difference return VARCHAR2 is
        begin
            IF ABS(:CS_SUM_CREDITS) != ABS(:CS_SUM_DEBITS) THEN
                RETURN('Los Totales de Débitos y Créditos no coinciden');
            ELSIF :TOTAL_CONTROL != 0 THEN
                IF ABS(:CS_SUM_CREDITS) != ABS(:TOTAL_CONTROL) OR
                   ABS(:CS_SUM_DEBITS)  != ABS(:TOTAL_CONTROL) THEN
                    RETURN('Los Totales del Cr. o Db.no coincide con total ctrl.');
                END IF;
            ELSE
                RETURN(NULL);
            END IF;
            RETURN NULL;
        end;


function CF_descripcion_sucFormula return VARCHAR2 is
begin
  DECLARE
    Lv_NombreAgencia  MG_Agencias_Generales.Nombre_Agencia%TYPE := ' ';
    Lv_MensajeError   VARCHAR2(200);
  BEGIN
    MG_P_NOMBRE_AGENCIA(:p_codigo_Empresa,null,Lv_NombreAgencia,Lv_MensajeError);
    IF Lv_MensajeError IS NULL 
    THEN
       RETURN(Lv_NombreAgencia);
    ELSE
       RETURN(NULL);
    END IF;
  END;
RETURN NULL; end;


function CF_BRANCH_DESCRIPTION return VARCHAR2 is
        begin
              lv_branch_name  MG_BRANCHES_GENERAL.Branch_Name%TYPE := ' ';
              lv_error_msg    VARCHAR2(200);
            BEGIN
                MG_P_NOMBRE_AGENCIA(P_COMPANY_CODE, null, lv_branch_name, lv_error_msg);
                IF lv_error_msg IS NULL THEN
                    RETURN(lv_branch_name);
                ELSE
                    RETURN(NULL);
                END IF;
            END;
            RETURN NULL;
        end;

function CF_BRANCH_DIFF return Number is
        begin
            return(abs(Q_BRANCHES.sum_db - Q_BRANCHES.sum_cr));
        end;


function CF_diferencia_totalFormula return VARCHAR2 is
begin
  IF ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CR) 
  THEN
     RETURN('Existen Totales de Débitos y Créditos que no coinciden');
  ELSE
     RETURN(NULL);
  END IF;
RETURN NULL; end;

function CF_total_difference return VARCHAR2 is  -- HACER EN JASPERREPOT
        begin
            IF ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CR) THEN
                RETURN('Existen Totales de Débitos y Créditos que no coinciden');
            ELSE
                RETURN(NULL);
            END IF;
            RETURN NULL;
        end;

-- 48(CF): F_descripcion_error2
        function CF_total_difference2 return VARCHAR2 is
        begin
            /*  IF (ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CONTROL)  OR
                    ABS(:CS_TOTAL_CR) != ABS(:CS_TOTAL_CONTROL) ) THEN
                RETURN('Existen Totales de Cr.o Db. que no coincide con total ctrl.');
            ELSE*/
            RETURN(NULL);
        --  END IF;
        end;
