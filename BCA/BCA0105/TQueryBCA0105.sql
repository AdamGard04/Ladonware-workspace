/*
=============================================================================
PARAMETERS LIST (in order of usage):
=============================================================================
:P_COMPANY_CODE      - Company code (mandatory)
:P_BRANCH_CODE       - Branch code (optional, null for all branches)
:P_SUBAPPL_CODE      - Subapplication code (optional, null for all subapplications)
=============================================================================
*/

-- Q_CA_ACCOUNT_BALANCE
SELECT A.COMPANY_CODE, A.BRANCH_CODE, A.SUBAPPL_CODE,
       A.ACCOUNT_NBR, A.BRANCH_CODE BRANCH,
       A.SUBAPPL_CODE SUBAPPLICATION,
      nvl(A.TOTAL_QUANTITY_BALANCE,0) TOTAL_QUANTITY_BALANCE, NVL(A.ACCUMULATED_INTEREST,0) ACCUMULATED_INTEREST, NVL(A.INTERESTS_OF_THE_MONTH,0) INTERESTS_OF_THE_MONTH,
NVL( A.INTEREST_MONTH_TAX,0) INTEREST_MONTH_TAX, NVL(A.ACCUMULATED_INTEREST_TAX,0) ACCUMULATED_INTEREST_TAX,
       C.BRANCH_NAME,
       D.DESCRIPTION,   (decode(e.OTHER_DEBIT_CREDIT,'D',nvl(f.value,0),0)) SUM_DEBITS,
       (decode(e.OTHER_DEBIT_CREDIT,'C',nvl(f.value,0),0)) SUM_CREDITS
FROM   CA_SAVINGS_ACCOUNTS A, MG_BRANCHES C, MG_SUBAPPLICATIONS D,
               CA_TXN_ENTRIES_PENDING f,         MG_TRANSACTION_TYPES E
WHERE a.company_code = f.company_code(+)
and a.branch_code = f.branch_code(+)
and a.subappl_code = f.subappl_code(+)
and a.account_nbr = f.account_nbr
and f.application_code = e.application_code
and f.transaction_type_code  = e.transaction_type_code
and f.printed = 'N'  
and  A.COMPANY_CODE =  C:P_COMPANY_CODE
AND    (a.branch_code = :P_BRANCH_CODE
          or :P_BRANCH_CODE is null)
AND    (a.subappl_code = :P_SUBAPPL_CODE
          or :P_SUBAPPL_CODE is null)
AND    a.STATUS <> 1
AND    (a.company_code = c.company_code and
        a.branch_code = c.branch_code)
AND    a.subappl_code = d.subapplication_code
ORDER BY A.COMPANY_CODE, A.SUBAPPL_CODE, A.BRANCH_CODE,
         A.ACCOUNT_NBR


-- Q_CAENDING_CREDITS
SELECT      A.COMPANY_CODE, A.BRANCH_CODE, A.SUBAPPL_CODE
FROM        CA_TXN_ENTRIES_PENDING A, MG_TRANSACTION_TYPES B
WHERE       (a.transaction_type_code = b.transaction_type_code and
             a.application_code = b.application_code)
AND         a.printed = 'N'
and         b.OTHER_DEBIT_CREDIT='C'
GROUP BY    A.COMPANY_CODE, A.BRANCH_CODE, A.SUBAPPL_CODE,
                      A.ACCOUNT_NBR



-- Q_CAENDING_DEBITS
SELECT      A.COMPANY_CODE, A.BRANCH_CODE, A.SUBAPPL_CODE
FROM        CA_TXN_ENTRIES_PENDING A, MG_TRANSACTION_TYPES B
WHERE       (a.transaction_type_code = b.transaction_type_code and
             a.application_code = b.application_code)
AND         a.printed = 'N'
and         b.OTHER_DEBIT_CREDIT = 'D'
GROUP BY    A.COMPANY_CODE, A.BRANCH_CODE, A.SUBAPPL_CODE,
            A.ACCOUNT_NBR



-- Q_CA_ACCOUNT_BALANCE - UNIFIED
SELECT 
    A.COMPANY_CODE, 
    A.BRANCH_CODE, 
    A.SUBAPPL_CODE,
    A.ACCOUNT_NBR, 
    A.BRANCH_CODE AS BRANCH,
    A.SUBAPPL_CODE AS SUBAPPLICATION,
    NVL(A.TOTAL_QUANTITY_BALANCE, 0) AS TOTAL_QUANTITY_BALANCE, 
    NVL(A.ACCUMULATED_INTEREST, 0) AS ACCUMULATED_INTEREST, 
    NVL(A.INTERESTS_OF_THE_MONTH, 0) AS INTERESTS_OF_THE_MONTH,
    NVL(A.INTEREST_MONTH_TAX, 0) AS INTEREST_MONTH_TAX, 
    NVL(A.ACCUMULATED_INTEREST_TAX, 0) AS ACCUMULATED_INTEREST_TAX,
    (SELECT C.BRANCH_NAME FROM MG_BRANCHES C 
     WHERE C.COMPANY_CODE = A.COMPANY_CODE 
       AND C.BRANCH_CODE = A.BRANCH_CODE) AS BRANCH_NAME,
    (SELECT D.DESCRIPTION FROM MG_SUBAPPLICATIONS D 
     WHERE D.SUBAPPLICATION_CODE = A.SUBAPPL_CODE) AS DESCRIPTION,
    (SELECT NVL(SUM(F.VALUE), 0)
     FROM CA_TXN_ENTRIES_PENDING F, MG_TRANSACTION_TYPES E
     WHERE F.COMPANY_CODE = A.COMPANY_CODE
       AND F.BRANCH_CODE = A.BRANCH_CODE
       AND F.SUBAPPL_CODE = A.SUBAPPL_CODE
       AND F.ACCOUNT_NBR = A.ACCOUNT_NBR
       AND F.APPLICATION_CODE = E.APPLICATION_CODE
       AND F.TRANSACTION_TYPE_CODE = E.TRANSACTION_TYPE_CODE
       AND F.PRINTED = 'N'
       AND E.OTHER_DEBIT_CREDIT = 'D') AS SUM_DEBITS,
    (SELECT NVL(SUM(F.VALUE), 0)
     FROM CA_TXN_ENTRIES_PENDING F, MG_TRANSACTION_TYPES E
     WHERE F.COMPANY_CODE = A.COMPANY_CODE
       AND F.BRANCH_CODE = A.BRANCH_CODE
       AND F.SUBAPPL_CODE = A.SUBAPPL_CODE
       AND F.ACCOUNT_NBR = A.ACCOUNT_NBR
       AND F.APPLICATION_CODE = E.APPLICATION_CODE
       AND F.TRANSACTION_TYPE_CODE = E.TRANSACTION_TYPE_CODE
       AND F.PRINTED = 'N'
       AND E.OTHER_DEBIT_CREDIT = 'C') AS SUM_CREDITS
FROM 
    CA_SAVINGS_ACCOUNTS A
WHERE 
    A.COMPANY_CODE = CP_COMPANY_CODE
    AND (A.BRANCH_CODE = P_BRANCH_CODE OR P_BRANCH_CODE IS NULL)
    AND (A.SUBAPPL_CODE = P_SUBAPPL_CODE OR P_SUBAPPL_CODE IS NULL)
    AND A.STATUS <> 1
ORDER BY 
    A.COMPANY_CODE, A.SUBAPPL_CODE, A.BRANCH_CODE, A.ACCOUNT_NBR;
