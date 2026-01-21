-- Q_LOAN_DATA
select
    d.COMPANY_CODE,
    y.ACCOUNTING_ACCOUNTING_LOCATION,
    decode (
        y.ACCOUNTING_ACCOUNTING_LOCATION,
        'L',
        'LIABILITY',
        'A',
        'ASSET'
    ) accounting_location,
    y.CURRENCY_CODE,
    d.ORIGIN_CODE,
    d.BRANCH_CODE,
    z.BRANCH_NAME,
    d.SUBAPPLICATION_CODE,
    y.DESCRIPTION subapplication_name,
    d.LOAN_NBR,
    p.PREVIOUS_DOCUMENT_NBR,
    c.FULL_NAME client_name,
    m.DESCRIPTION,
    d.INITIAL_AMOUNT,
    d.OPENING_DATE,
    d.DUE_DATE,
    d.TOTAL_QUANTITY,
    ct.INVESTMENT_CODE,
    d.TYPE_CODE,
    d.CARTERA_STATE_CODE,
    e.DESCRIPTION state_description
from
    MG_BRANCHES z,
    MG_SUBAPPLICATIONS y,
    MG_CLIENTS c,
    PR_MONTH_END d,
    PR_CONTRACTS ct,
    PR_STATEES_CARTERA e,
    MG_CURRENCY m,
    PR_LOANS p
WHERE
    d.YEAR_MONTH = p_year_month
    and ct.CONTRACT_NBR = d.CONTRACT_NBR
    and ct.SUBAPPLICATION_CODE = d.SUBAPPLICATION_CODE
    and ct.BRANCH_CODE = d.BRANCH_CODE
    and ct.COMPANY_CODE = d.COMPANY_CODE
    and d.LOAN_NBR >= nvl (p_loan_nbr_start, d.LOAN_NBR)
    and d.LOAN_NBR <= nvl (p_loan_nbr_end, d.LOAN_NBR)
    and d.SUBAPPLICATION_CODE = NVL (p_subapplication_code, d.SUBAPPLICATION_CODE)
    and d.BRANCH_CODE = NVL (P_BRANCH_CODE, d.BRANCH_CODE)
    AND d.COMPANY_CODE = P_COMPANY_CODE
    AND d.ORIGIN_CODE = nvl (p_origin_code, d.ORIGIN_CODE)
    AND ct.INVESTMENT_CODE = nvl (p_investment_code, ct.INVESTMENT_CODE)
    AND d.STATE = nvl (p_state, d.STATE)
    and d.TYPE_CODE = nvl (p_type_code, d.TYPE_CODE)
    AND d.CARTERA_STATE_CODE = nvl (p_portfolio_state_code, d.CARTERA_STATE_CODE)
    AND c.CLIENT_CODE = d.CLIENT_CODE
    AND y.SUBAPPLICATION_CODE = d.SUBAPPLICATION_CODE
    AND y.APPLICATION_CODE = 'BPR'
    AND y.ACCOUNTING_ACCOUNTING_LOCATION = nvl (
        P_ACCOUNTING_LOCATION,
        y.ACCOUNTING_ACCOUNTING_LOCATION
    )
    AND z.BRANCH_CODE = d.BRANCH_CODE
    and z.COMPANY_CODE = d.COMPANY_CODE
    AND e.SUBAPPLICATION_CODE = d.SUBAPPLICATION_CODE
    and e.AMORTIZATION_TYPE_CODE = d.AMORTIZATION_TYPE_CODE
    and e.CARTERA_STATE_CODE = d.CARTERA_STATE_CODE
    AND y.CURRENCY_CODE = m.CURRENCY_CODE
    AND d.COMPANY_CODE = p.COMPANY_CODE
    and d.BRANCH_CODE = p.BRANCH_CODE
    and d.SUBAPPLICATION_CODE = p.SUBAPPLICATION_CODE
    and d.LOAN_NBR = p.LOAN_NBR
ORDER BY
    3,
    1,
    4,
    6,
    10;

-- Q_BALANCES
SELECT
    a.COMPANY_CODE comp,
    a.BRANCH_CODE branch,
    a.SUBAPPLICATION_CODE subapp,
    a.LOAN_NBR loan_nbr,
    SUM(DECODE (b.REPAYMENT_TYPE, 'C', a.VALUE, 0)) Principal,
    --SUM(DECODE(b.REPAYMENT_TYPE,'I',decode(b.BALANCE_TYPE,1,a.VALUE,2,a.VALUE,4,a.VALUE,0))) Interest,
    SUM(
        DECODE (
            b.REPAYMENT_TYPE,
            'I',
            decode (
                a.BALANCE_TYPE_CODE,
                38,
                0,
                39,
                0,
                decode (
                    b.BALANCE_TYPE,
                    1,
                    a.VALUE,
                    2,
                    a.VALUE,
                    4,
                    a.VALUE,
                    0
                )
            )
        )
    ) Interest,
    SUM(
        DECODE (
            b.REPAYMENT_TYPE,
            'I',
            decode (a.BALANCE_TYPE_CODE, 38, a.VALUE, 39, a.VALUE, 0)
        )
    ) InterestSuspended,
    SUM(DECODE (b.REPAYMENT_TYPE, 'T', a.VALUE, 0)) Tax,
    --SUM(DECODE(b.REPAYMENT_TYPE,'I',decode(b.BALANCE_TYPE,3,a.VALUE,0))) Delinquency,
    SUM(
        DECODE (
            b.REPAYMENT_TYPE,
            'I',
            decode (
                a.BALANCE_TYPE_CODE,
                36,
                0,
                decode (b.BALANCE_TYPE, 3, a.VALUE, 0)
            )
        )
    ) Delinquency,
    SUM(
        DECODE (
            b.REPAYMENT_TYPE,
            'I',
            decode (
                a.BALANCE_TYPE_CODE,
                36,
                decode (b.BALANCE_TYPE, 3, a.VALUE, 0),
                0
            )
        )
    ) DelinquencySuspended,
    SUM(DECODE (b.BALANCE_TYPE, 5, a.VALUE, 0)) Advances,
    sum(decode (b.REPAYMENT_TYPE, 'S', a.VALUE, 0)) insurance,
    sum(
        decode (b.REPAYMENT_TYPE, 'P', a.VALUE, 'G', a.VALUE, 0)
    ) commission,
    sum(
        decode (
            b.BALANCE_TYPE,
            5,
            0,
            decode (
                b.REPAYMENT_TYPE,
                'C',
                0,
                'I',
                0,
                'S',
                0,
                'P',
                0,
                a.VALUE
            )
        )
    ) others
FROM
    PR_FIN_MONTH_BALANCES_DETAIL a,
    PR_BALANCE_TYPES b
WHERE
    a.COMPANY_CODE = P_COMPANY_CODE
    AND b.BALANCE_TYPE_CODE = a.BALANCE_TYPE_CODE
    AND A.YEAR_MONTH = P_YEAR_MONTH
    AND nvl (a.VALUE, 0) > 0
GROUP BY
    a.COMPANY_CODE,
    a.BRANCH_CODE,
    a.SUBAPPLICATION_CODE,
    a.LOAN_NBR;

-- funciones:
-- NOMBRE_inversion
function CF_investment_description return Char is lv_description varchar2 (60);

begin
select
    DESCRIPTION into lv_description
from
    MG_INVESTMENT_TYPE
where
    INVESTMENT_CODE = Q_LOAN_DATA.investment_code;

return lv_description;

exception when no_data_found then return 'DOES NOT EXIST';

end;

-- NOMBRE_CLASE
function CF_loan_class_description return Char is lv_description varchar2 (60);

begin
select
    DESCRIPTION into lv_description
from
    PR_LOAN_CLASS_CD
where
    TYPE_CODE = Q_LOAN_DATA.type_code;

return lv_description;

exception when no_data_found then return 'DOES NOT EXIST';

end;

-- NOMBRE_CLASE1
function CF_loan_class_description return Char is lv_description varchar2 (60);

begin
select
    DESCRIPTION into lv_description
from
    PR_LOAN_CLASS_CD
where
    TYPE_CODE = Q_LOAN_DATA.type_code;

return lv_description;

exception when no_data_found then return 'DOES NOT EXIST';

end;

-- NOMBRE_inversion1
function CF_investment_description return Char is lv_description varchar2 (60);

begin
select
    DESCRIPTION into lv_description
from
    MG_INVESTMENT_TYPE
where
    INVESTMENT_CODE = Q_LOAN_DATA.investment_code;

return lv_description;

exception when no_data_found then return 'DOES NOT EXIST';

end;

-- F_descripcion_origen2
function CF_origin return Char is lv_description varchar2 (200);

begin
select
    DESCRIPTION into lv_description
from
    MG_RESOURCES_SOURCE
where
    ORIGIN_CODE = Q_LOAN_DATA.origin_code;

return lv_description;

exception when no_data_found then return 'DOES NOT EXIST';

end;