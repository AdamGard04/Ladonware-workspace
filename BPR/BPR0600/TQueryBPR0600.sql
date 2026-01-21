-- Q_1:
SELECT
    'GX' application,
    B0057EmCod AS company_code,
    A0174SlAgc AS branch_code,
    A0012SpCod AS SUBAPPLICATION_CODE,
    B0057SlnRO AS LOAN_NBR,
    B0011CrEje AS EXECUTIVE_CODE,
    B0013PbCod AS PRODUCT_ID,
    B0057EDSec AS SEQUENCE_NUMBER, --sequence
    B0057EDFch AS TXN_ENTRY_DATE,
    to_char (B0057EDEst) AS STATUS, --decision status 1 approved, 2 rejected, 3 cancelled
    B0057EDMoA AS APPROVED_AMOUNT,
    B0011CrMTo AS REQUESTED_AMOUNT,
    B0010CcCCr AS LOAN_CLASS,
    b.CURRENCY_CODE,
    A0174SlFch AS REQUEST_DATE,
    A0048ClCod AS CLIENT_CODE,
    c.IDENTIFICATION_NBR,
    DECODE (
        c.PERSON_TYPE,
        'N',
        c.first_last_name || ' ' || c.second_last_name || ' ' || c.first_name,
        NVL (company_name, trade_name)
    ) Client_Name
FROM
    B0057 a,
    A0174,
    B0011,
    B0010,
    MG_SUBAPPLICATIONS b,
    A0048,
    MG_CLIENTS C
WHERE
    B0057SlnRO = nvl (p_LOAN_NBR, B0057SlnRO)
    AND c.CLIENT_CODE = A0048ClCod
    AND A0012SpCod = b.SUBAPPLICATION_CODE
    AND b.application_code = 'BPR'
    AND B0011EmCod = B0057EmCod
    AND B0011PrCod = B0057PrCod
    AND B0011SoNro = B0057SlnRO
    AND B0010EmCod = B0057EmCod
    AND B0010PrCod = B0057PrCod
    AND B0010SoNro = B0057SlnRO
    AND A0001EmCod = B0057EmCod
    AND A0011PrCod = B0057PrCod
    AND A0174SlNro = B0057SlnRO
    AND B0057PrCod = '10'
    AND (
        (
            Pv_Status IN ('1', '2')
            AND to_char (B0057EDEst) = DECODE (Pv_Status, '1', '1', '2', '3')
        )
        OR (
            Pv_Status IN ('9')
            AND B0057EDEst IN (1, 3)
        )
    ) --GX 1, disbursed 3 cancelled 
    AND B0057EDFch BETWEEN P_start_date AND P_end_date
UNION
SELECT
    'BPR' application,
    a.COMPANY_CODE AS COMPANY_CODE,
    a.BRANCH_CODE AS BRANCH_CODE,
    a.SUBAPPLICATION_CODE AS SUBAPPLICATION_CODE,
    a.LOAN_NBR AS LOAN_NBR,
    con.EXECUTIVE_CODE AS EXECUTIVE_CODE,
    a.PRODUCT_ID AS PRODUCT_ID,
    0 AS SEQUENCE_NUMBER,
    NULL AS TXN_ENTRY_DATE,
    a.STATUS AS STATUS, --1 active, 9 cancelled
    a.INITIAL_AMOUNT AS APPROVED_AMOUNT,
    B0011CrMTo AS REQUESTED_AMOUNT,
    a.TYPE_CODE AS LOAN_CLASS,
    c.CURRENCY_CODE AS CURRENCY_CODE,
    con.APPROVAL_DATE AS REQUEST_DATE,
    a.CLIENT_CODE AS CLIENT_CODE,
    d.IDENTIFICATION_NBR AS IDENTIFICATION_NBR,
    DECODE (
        d.PERSON_TYPE,
        'N',
        d.first_last_name || ' ' || d.second_last_name || ' ' || d.first_name,
        NVL (company_name, trade_name)
    ) Client_Name
FROM
    PR_LOANS a,
    PR_CONTRACTS con,
    MG_SUBAPPLICATIONS c,
    MG_CLIENTS d,
    B0011
WHERE
    a.LOAN_NBR = nvl (p_LOAN_NBR, a.LOAN_NBR)
    AND a.contract_number = con.contract_number
    AND a.SUBAPPLICATION_CODE = con.SUBAPPLICATION_CODE
    AND a.branch_code = con.branch_code
    AND a.company_code = con.company_code
    AND a.CLIENT_CODE = d.CLIENT_CODE
    AND con.company_code = b0011emcod
    AND b0011prcod = '10'
    AND con.application_number = b0011sonro
    AND c.application_code = 'BPR'
    AND c.SUBAPPLICATION_CODE = a.SUBAPPLICATION_CODE
    AND NVL (A.disbursement_amount, 0) = 0
    AND (
        (
            Pv_Status IN ('3', '4')
            AND a.status = DECODE (Pv_Status, '3', '1', '4', '4')
        )
        OR (
            Pv_Status IN ('9')
            AND a.status IN ('1', '4')
        )
    ) --BPR 1, disbursed 4 cancelled
    -- Functions:
    -- F_estado:
    function CF_STATUS return Char is begin IF Q_1.APPLICATION = 'GX' THEN IF '1' = Q_1.STATUS THEN RETURN ('Approved Applications');

ELSE RETURN ('Cancelled Applications');

END IF;

ELSE IF '1' = Q_1.STATUS THEN RETURN ('Formalized Loans');

ELSE RETURN ('Cancelled Formalized Loans');

END IF;

END IF;

end;

-- F_CF_ejecutivo:
function CF_executive return Char is Lv_name varchar2 (200);

begin
select
    first_last_name || ' ' || second_last_name || ' ' || first_name into Lv_name
from
    MG_USERS_SYSTEM
where
    user_code = Q_1.EXECUTIVE_CODE;

return (Lv_name);

end;