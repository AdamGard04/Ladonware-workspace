-- PARAMETERS:
--   1. :P_TODAY_DATE
--   2. :P_CURRENCY_CODE
--   3. :P_BANK_TYPE
--   4. :P_BANK_CODE
--   5. :P_CLIENT_CODE
--   6. :P_SUBAPPLICATION_CODE
--   7. :P_LOAN_TYPE_CODE
--   8. :P_EXECUTIVE_CODE
--   9. :P_PRODUCT_KEY
-- P_COMPANY_CODE
-- P_TYPE_CODE


-- Q_LOAN_dATA (PR_PRESTAMOS -> PR_LOANS fields fixed)
SELECT
    a.type_code                                     AS loan_type_code,
    c.executive_code                                AS executive_code,
    u.names || ' ' || u.first_surname || ' ' || u.surname_second
                                                    AS executive_name,
    a.loan_nbr                                      AS loan_number,
    a.subapplication_code                           AS subapplication_code,
    a.branch_code                                   AS branch_code,
    a.client_code                                   AS client_code,
    b.complete_name                                 AS client_full_name,

    a.base_interest_rate_delinquency                AS base_late_interest_rate,
    a.delinquency_spread                            AS late_spread,
    a.mathematical_relation_delinquency             AS late_mathematical_relation,

    (TO_DATE(NVL(P_TODAY_DATE,SYSDATE)) - e.expiration_date)             AS days_late,
    e.installment_nbr                               AS installment_number,
    e.expiration_date                               AS due_date,

    SUM(
        DECODE(
            g.repayment_type,
            'I',
                DECODE(
                    g.balance_type,
                    3, f.value - NVL(f.paid_quantity, 0),
                    0
                ),
            0
        )
    )                                               AS late_interest,

    SUM(
        DECODE(
            g.repayment_type,
            'G', f.value - NVL(f.paid_quantity, 0),
            'P', f.value - NVL(f.paid_quantity, 0),
            'T', f.value - NVL(f.paid_quantity, 0),
            0
        )
    )                                               AS commission_amount,

    SUM(
        DECODE(
            g.repayment_type,
            'C', f.value - NVL(f.paid_quantity, 0),
            0
        )
    )                                               AS capital_amount,

    SUM(
        DECODE(
            g.repayment_type,
            'I',
                DECODE(
                    g.balance_type,
                    1, f.value - NVL(f.paid_quantity, 0),
                    2, f.value - NVL(f.paid_quantity, 0),
                    0
                ),
            0
        )
    )                                               AS interest_amount,

    SUM(
        DECODE(
            g.repayment_type,
            'I',
                DECODE(
                    g.balance_type,
                    1, 0,
                    2, 0,
                    3, 0,
                    f.value - NVL(f.paid_quantity, 0)
                ),
            0
        )
    )                                               AS other_balances,

    m.currency_code                                 AS currency_code,
    m.description                                   AS currency_description,

    a.last_payment_date                             AS last_payment_date,
    a.opening_date                                  AS opening_date,
    a.ultimo_desembolso_date                        AS last_disbursement_date,
    a.overdue_interests                             AS past_due_interest,
    a.disbursement_value                            AS disbursement_value

FROM
    PR_LOANS a,
    MG_CLIENTS b,
    PR_CONTRACTS c,
    MG_CURRENCY m,
    MG_SUBAPPLICATIONS d,
    PR_PAYMENT_PLAN e,
    PR_T_PAYMENT_PLAN_BALANCES f,
    PR_BALANCE_TYPES g,
    MG_USERS_SYSTEM u,
    MG_BOARDS l
WHERE
    a.client_code              = b.client_code
    AND a.contract_nbr         = c.contract_nbr
    AND a.subapplication_code  = c.subapplication_code
    AND a.branch_code          = c.branch_code
    AND a.company_code         = c.company_code
    AND a.state                = 1
    AND a.banca_code           = l.banca_code
    AND c.executive_code       = u.user_code

    AND a.cartera_state_code IN ('A','B')

    /* PAYMENT PLAN */
    AND a.loan_nbr             = e.loan_nbr
    AND a.subapplication_code  = e.subapplication_code
    AND a.branch_code          = e.branch_code
    AND a.company_code         = e.company_code
    AND NVL(e.paid, 'N')       = 'N'
    AND e.expiration_date      < NVL(P_TODAY_DATE,SYSDATE)

    /* BALANCES */
    AND e.installment_nbr      = f.installment_nbr
    AND e.loan_nbr             = f.loan_nbr
    AND e.subapplication_code  = f.subapplication_code
    AND e.branch_code          = f.branch_code
    AND e.company_code         = f.company_code
    AND f.balance_type_code    = g.balance_type_code

    /* SUBAPPLICATION */
    AND d.subapplication_code  = a.subapplication_code
    AND d.application_code     = 'BPR'
    AND d.company_code         = a.company_code
    AND d.currency_code        = m.currency_code

    /* FILTERS */
    AND d.currency_code              = NVL(P_CURRENCY_CODE, d.currency_code)
    AND l.bank_type                  = NVL(P_BANK_TYPE, l.bank_type)
    AND a.banca_code                 = NVL(P_BANK_CODE, a.banca_code)
    AND a.client_code                = NVL(P_CLIENT_CODE, a.client_code)
    AND a.subapplication_code        = NVL(P_SUBAPPLICATION_CODE, a.subapplication_code)
    AND NVL(a.type_code, 0)          = NVL(P_LOAN_TYPE_CODE, NVL(a.type_code, 0))
    AND c.executive_code             = NVL(P_EXECUTIVE_CODE, c.executive_code)
    AND NVL(a.product_id, 0)         = NVL(P_PRODUCT_KEY, NVL(a.product_id, 0))

GROUP BY
    a.type_code,
    c.executive_code,
    u.names || ' ' || u.first_surname || ' ' || u.surname_second,
    a.loan_nbr,
    a.subapplication_code,
    a.branch_code,
    a.client_code,
    b.complete_name,
    a.base_interest_rate_delinquency,
    a.delinquency_spread,
    a.mathematical_relation_delinquency,
    (TO_DATE(NVL(P_TODAY_DATE,SYSDATE) )- e.expiration_date),
    e.installment_nbr,
    e.expiration_date,
    m.currency_code,
    m.description,
    a.last_payment_date,
    a.opening_date,
    a.ultimo_desembolso_date,
    a.overdue_interests,
    a.disbursement_value

ORDER BY
    a.type_code,
    executive_name,
    b.complete_name,
    a.loan_nbr,
    e.installment_nbr;



-- CF_LOAN_CLASS_DESCRIPTION
-- Parameters:
--   1. :P_TYPE_CODE  - Loan class type code
function CF_DESCRIPTION_TYPE return CHAR is
  LV_DESCRIPTION  VARCHAR2(100);
begin
  begin
    select DESCRIPTION
    into   LV_DESCRIPTION
    from   PR_LOAN_CLASS_CD
    where  TYPE_CODE = NVL(P_TYPE_CODE,TYPE_CODE);
  exception
    when NO_DATA_FOUND then
      LV_DESCRIPTION := 'LOAN CLASS NOT DEFINED';
  end;

  return (LV_DESCRIPTION);
end;
return '';


-- CF_LATE_RATE
function CF_LATE_RATE return NUMBER is
  LN_LATE_RATE  NUMBER;
begin
  if Q_LOAN_DATA.late_mathematical_relation = '+' then
    LN_LATE_RATE := NVL(Q_LOAN_DATA.base_late_interest_rate, 0) + NVL(Q_LOAN_DATA.late_spread, 0);
  elsif Q_LOAN_DATA.late_mathematical_relation = '-' then
    LN_LATE_RATE := NVL(Q_LOAN_DATA.base_late_interest_rate, 0) - NVL(Q_LOAN_DATA.late_spread, 0);
  elsif Q_LOAN_DATA.late_mathematical_relation = '*' then
    LN_LATE_RATE := NVL(Q_LOAN_DATA.base_late_interest_rate, 0) * NVL(Q_LOAN_DATA.late_spread, 0);
  elsif Q_LOAN_DATA.late_mathematical_relation = '/' then
    LN_LATE_RATE := NVL(Q_LOAN_DATA.base_late_interest_rate, 0) / NVL(Q_LOAN_DATA.late_spread, 0);
  end if;
  return (LN_LATE_RATE);
end;


-- CF_PHONE_NUMBERS
-- Parameters:
--   1. :P_CLIENT_CODE  - Client code
function CF_PHONE_NUMBERS return CHAR is
  LV_PHONE_NUMBERS  VARCHAR2(200);
begin
  begin
    select NUM_PHONE
      into LV_PHONE_NUMBERS
      from MG_CLIENT_PHONES
     where CLIENT_CODE    = NVL(P_CLIENT_CODE,CLIENT_CODE)
       and PHONE_TYPE     = '1'
       and PRIMARY_PHONE  = 'S'
       and ROWNUM         = 1;
  exception
    when NO_DATA_FOUND then
      null;
  end;
  return (LV_PHONE_NUMBERS);
end;
return '';


-- CF_TOTAL_BALANCE
-- Parameters:
--   4. :P_COMPANY_CODE       - Company code
-- CP_LEGAL_DELINQUENCY
function CF_TOTAL_BALANCE return NUMBER is
  LV_TOTAL_BALANCE  NUMBER := 0;
begin
  CP_LEGAL_DELINQUENCY := 0;
  begin
    select 
           SUM(DECODE(t.repayment_type,'C',a.value,0)) LEGAL_DELINQUENCY
      into CP_LEGAL_DELINQUENCY
      from PR_LOAN_BALANCES a,
           PR_SUBAPPLICATION_BALANCE_TYPE s,
           PR_BALANCE_TYPES t
     where a.loan_nbr             = NVL(Q_LOAN_DATA.loan_number,a.loan_nbr)
       and a.subapplication_code  = NVL(Q_LOAN_DATA.subapplication_code,a.subapplication_code)
       and a.branch_code          = NVL(Q_LOAN_DATA.branch_code,a.branch_code)
       and a.company_code         = NVL(P_COMPANY_CODE,a.company_code)
       and a.balance_type_code    = s.balance_type_code
       and a.subapplication_code  = s.subapplication_code
       and a.company_code         = s.company_code
       and a.balance_type_code    = t.balance_type_code;
  end;

  LV_TOTAL_BALANCE := CP_LEGAL_DELINQUENCY;
  return (LV_TOTAL_BALANCE);
end;
return 0;


-- CF_LAST_PAYMENT_DATE
function CF_LAST_PAYMENT_DATE return DATE is
begin
  IF Q_LOAN_DATA.opening_date = Q_LOAN_DATA.LAST_PAYMENT_DATE THEN
    IF Q_LOAN_DATA.past_due_interest = 'Y' THEN
      RETURN(NULL);
    ELSE
      IF NVL(Q_LOAN_DATA.disbursement_value, 0) > 0 THEN
        RETURN(Q_LOAN_DATA.last_disbursement_date);
      ELSE
        RETURN(NULL);
      END IF;
    END IF;
  ELSE
    RETURN(Q_LOAN_DATA.LAST_PAYMENT_DATE);
  END IF;
end;


-- CF_TOTAL_GENERAL_LABEL
function CF_TOTAL_GENERAL_LABEL return CHAR is
begin
  return('GRAND TOTAL IN ' || Q_LOAN_DATA.currency_description);
end;


