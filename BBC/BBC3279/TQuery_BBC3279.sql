-- ======================================================================== QUERY 1: Q_CHEQUES
SELECT 
    e.REFERENCE_NBR                                          AS reference_number,
    e.BENEFICIARY                                            AS beneficiary_detail,
    e.TXN_ENTRY_VALUE                                        AS amount,
    e.CORRESPONDENT_BRANCH_CODE                              AS correspondent_branch_code,
    e.BRANCH_CODE                                            AS branch_code,
    e.REFERENCE_NBR                                          AS document_number,
    e.DESCRIPTION                                            AS detail_description,
    e.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    e.TXN_ENTRY_DATE                                         AS txn_entry_date,
    c.BRANCH_NAME                                            AS branch_name,
    b.CURRENCY_CODE                                          AS currency_code,
    g.LANGUAGE_CHECK                                         AS check_language,
    h.GROUP_CODE                                             AS group_code,
    e.REFERENCE_NBR                                          AS check_number,
    f.REQUEST_SEQ                                            AS request_seq,
    f.CONCEPT_APPLICATION_CODE                               AS concept_application_code,
    e.ACCOUNT_NBR                                            AS account_number,
    f.CONCEPT_TRANSACTION_CODE                               AS concept_transaction_code,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code_2,
    e.TXN_ENTRY_VALUE                                        AS check_amount,
    a.COMPANY_CODE                                           AS accounting_company_code,
    a.ACCOUNT_LEVEL_1                                        AS level_1,
    a.ACCOUNT_LEVEL_2                                        AS level_2,
    a.ACCOUNT_LEVEL_3                                        AS level_3,
    a.ACCOUNT_LEVEL_4                                        AS level_4,
    a.ACCOUNT_LEVEL_5                                        AS level_5,
    a.ACCOUNT_LEVEL_6                                        AS level_6,
    a.ACCOUNT_LEVEL_7                                        AS level_7,
    a.ACCOUNT_LEVEL_8                                        AS level_8,
    DECODE(J.OTHER_DEBIT_CREDIT, 'C', 'Cr', 'D', 'Db', 'O', ' ') AS debit_credit_1,
    f.ORIGIN_BRANCH_CODE                                     AS origin_branch_code
FROM 
    MG_BRANCHES_GENERAL         c,
    BC_TXN_ENTRY_DETAILS        e,
    MG_CURRENCY                 b,
    BC_CORRESPONDENT_ACCOUNTS   g,
    MG_TYPES_OF_REDEMPTION      d,
    BC_TXN_ENTRIES              f,
    BC_CHECKS_PRINTED           h,
    BC_TRANSACTIONS_X_CONCEPTS  a,
    MG_TRANSACTION_TYPES        J
WHERE 
    j.APPLICATION_CODE              = a.APPLICATION_CODE
AND j.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.APPLICATION_CODE              = a.APPLICATION_CODE
AND f.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.CONCEPT_APPLICATION_CODE      = a.ORIGIN_APPLICATION_CODE
AND f.CONCEPT_TRANSACTION_CODE      = a.CONCEPT_TRANSACTION_CODE
AND f.CURRENCY_CODE                 = a.CURRENCY_CODE
AND e.COMPANY_CODE                  = NVL(:p_company_code, e.COMPANY_CODE)
AND e.BRANCH_CODE                   = NVL(:p_branch_code, e.BRANCH_CODE)
AND e.CURRENCY_CODE                 = NVL(:p_currency_code, e.CURRENCY_CODE)
AND e.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, e.CORRESPONDENT_BRANCH_CODE)
AND e.ACCOUNT_NBR                   = NVL(:p_account_number, e.ACCOUNT_NBR)
AND e.REFERENCE_NBR                 = NVL(:p_check_number, e.REFERENCE_NBR)
AND d.EXCHANGE_TYPE_CODE            = e.EXCHANGE_TYPE_CODE
AND d.CHECK_BANK_TYPE               = 2
AND c.BRANCH_CODE                   = e.CORRESPONDENT_BRANCH_CODE
AND c.COMPANY_CODE                  = e.COMPANY_CODE
AND b.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.COMPANY_CODE                  = e.COMPANY_CODE
AND g.BRANCH_CODE                   = e.BRANCH_CODE
AND g.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.CORRESPONDENT_BRANCH_CODE     = e.CORRESPONDENT_BRANCH_CODE
AND g.ACCOUNT_NBR                   = e.ACCOUNT_NBR
AND f.TXN_ENTRY_SEQ                 = e.TXN_ENTRY_SEQ
AND f.TXN_ENTRY_DATE                = e.TXN_ENTRY_DATE
AND f.USER_CODE                     = e.USER_TXN_ENTRY_CODE
AND f.TXN_ENTRY_STATE               = 1
AND h.COMPANY_CODE                  = NVL(:p_company_code, h.COMPANY_CODE)
AND h.BRANCH_CODE                   = NVL(:p_branch_code, h.BRANCH_CODE)
AND h.CURRENCY_CODE                 = NVL(:p_currency_code, h.CURRENCY_CODE)
AND h.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, h.CORRESPONDENT_BRANCH_CODE)
AND h.ACCOUNT_NBR                   = NVL(:p_account_number, h.ACCOUNT_NBR)
AND TO_CHAR(h.CHECK_NBR)            = NVL(:p_check_number, TO_CHAR(h.CHECK_NBR))
UNION 
SELECT 
    e.REFERENCE_NBR                                          AS reference_number,
    e.BENEFICIARY                                            AS beneficiary_detail,
    e.TXN_ENTRY_VALUE                                        AS amount,
    e.CORRESPONDENT_BRANCH_CODE                              AS correspondent_branch_code,
    e.BRANCH_CODE                                            AS branch_code,
    e.REFERENCE_NBR                                          AS document_number,
    e.DESCRIPTION                                            AS detail_description,
    e.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    e.TXN_ENTRY_DATE                                         AS txn_entry_date,
    c.BRANCH_NAME                                            AS branch_name,
    b.CURRENCY_CODE                                          AS currency_code,
    g.LANGUAGE_CHECK                                         AS check_language,
    h.GROUP_CODE                                             AS group_code,
    e.REFERENCE_NBR                                          AS check_number,
    f.REQUEST_SEQ                                            AS request_seq,
    f.CONCEPT_APPLICATION_CODE                               AS concept_application_code,
    e.ACCOUNT_NBR                                            AS account_number,
    f.CONCEPT_TRANSACTION_CODE                               AS concept_transaction_code,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code_2,
    e.TXN_ENTRY_VALUE                                        AS check_amount,
    a.COMPANY_CODE                                           AS accounting_company_code,
    a.ACCOUNT_LEVEL_1                                        AS level_1,
    a.ACCOUNT_LEVEL_2                                        AS level_2,
    a.ACCOUNT_LEVEL_3                                        AS level_3,
    a.ACCOUNT_LEVEL_4                                        AS level_4,
    a.ACCOUNT_LEVEL_5                                        AS level_5,
    a.ACCOUNT_LEVEL_6                                        AS level_6,
    a.ACCOUNT_LEVEL_7                                        AS level_7,
    a.ACCOUNT_LEVEL_8                                        AS level_8,
    DECODE(J.OTHER_DEBIT_CREDIT, 'C', 'Cr', 'D', 'Db', 'O', ' ') AS debit_credit_1,
    f.ORIGIN_BRANCH_CODE                                     AS origin_branch_code
FROM 
    MG_BRANCHES_GENERAL         c,
    BC_TXN_ENTRY_DETAILS        e,
    MG_CURRENCY                 b,
    BC_CORRESPONDENT_ACCOUNTS   g,
    MG_TYPES_OF_REDEMPTION      d,
    BC_TXN_ENTRIES              f,
    BC_CHECKS_PRINTED           h,
    BC_TRANSACTIONS_X_CONCEPTS  a,
    MG_TRANSACTION_TYPES        J
WHERE 
    j.APPLICATION_CODE              = a.APPLICATION_CODE
AND j.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.APPLICATION_CODE              = a.APPLICATION_CODE
AND f.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.CONCEPT_APPLICATION_CODE      = a.ORIGIN_APPLICATION_CODE
AND f.CONCEPT_TRANSACTION_CODE      = a.CONCEPT_TRANSACTION_CODE
AND f.CURRENCY_CODE                 = a.CURRENCY_CODE
AND e.COMPANY_CODE                  = NVL(:p_company_code, e.COMPANY_CODE)
AND e.BRANCH_CODE                   = NVL(:p_branch_code, e.BRANCH_CODE)
AND e.CURRENCY_CODE                 = NVL(:p_currency_code, e.CURRENCY_CODE)
AND e.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, e.CORRESPONDENT_BRANCH_CODE)
AND e.ACCOUNT_NBR                   = NVL(:p_account_number, e.ACCOUNT_NBR)
AND e.REFERENCE_NBR                 = NVL(:p_check_number, e.REFERENCE_NBR)
AND d.EXCHANGE_TYPE_CODE            = e.EXCHANGE_TYPE_CODE
AND d.CHECK_BANK_TYPE               = 2
AND c.BRANCH_CODE                   = e.CORRESPONDENT_BRANCH_CODE
AND c.COMPANY_CODE                  = e.COMPANY_CODE
AND b.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.COMPANY_CODE                  = e.COMPANY_CODE
AND g.BRANCH_CODE                   = e.BRANCH_CODE
AND g.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.CORRESPONDENT_BRANCH_CODE     = e.CORRESPONDENT_BRANCH_CODE
AND g.ACCOUNT_NBR                   = e.ACCOUNT_NBR
AND f.TXN_ENTRY_SEQ                 = e.TXN_ENTRY_SEQ
AND f.TXN_ENTRY_DATE                = e.TXN_ENTRY_DATE
AND f.USER_CODE                     = e.USER_TXN_ENTRY_CODE
AND f.TXN_ENTRY_STATE               = 1
AND h.COMPANY_CODE                  = NVL(:p_company_code, h.COMPANY_CODE)
AND h.BRANCH_CODE                   = NVL(:p_branch_code, h.BRANCH_CODE)
AND h.CURRENCY_CODE                 = NVL(:p_currency_code, h.CURRENCY_CODE)
AND h.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, h.CORRESPONDENT_BRANCH_CODE)
AND h.ACCOUNT_NBR                   = NVL(:p_account_number, h.ACCOUNT_NBR)
AND TO_CHAR(h.CHECK_NBR)            = NVL(:p_check_number, TO_CHAR(h.CHECK_NBR))
UNION 
SELECT 
    e.REFERENCE_NBR                                          AS reference_number,
    e.BENEFICIARY                                            AS beneficiary_detail,
    e.TXN_ENTRY_VALUE                                        AS amount,
    e.CORRESPONDENT_BRANCH_CODE                              AS correspondent_branch_code,
    e.BRANCH_CODE                                            AS branch_code,
    e.REFERENCE_NBR                                          AS document_number,
    e.DESCRIPTION                                            AS detail_description,
    e.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    e.TXN_ENTRY_DATE                                         AS txn_entry_date,
    c.BRANCH_NAME                                            AS branch_name,
    b.CURRENCY_CODE                                          AS currency_code,
    g.LANGUAGE_CHECK                                         AS check_language,
    h.GROUP_CODE                                             AS group_code,
    e.REFERENCE_NBR                                          AS check_number,
    f.REQUEST_SEQ                                            AS request_seq,
    f.CONCEPT_APPLICATION_CODE                               AS concept_application_code,
    e.ACCOUNT_NBR                                            AS account_number,
    f.CONCEPT_TRANSACTION_CODE                               AS concept_transaction_code,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code_2,
    e.TXN_ENTRY_VALUE                                        AS check_amount,
    a.COMPANY_CODE                                           AS accounting_company_code,
    a.ACCOUNT_LEVEL_1                                        AS level_1,
    a.ACCOUNT_LEVEL_2                                        AS level_2,
    a.ACCOUNT_LEVEL_3                                        AS level_3,
    a.ACCOUNT_LEVEL_4                                        AS level_4,
    a.ACCOUNT_LEVEL_5                                        AS level_5,
    a.ACCOUNT_LEVEL_6                                        AS level_6,
    a.ACCOUNT_LEVEL_7                                        AS level_7,
    a.ACCOUNT_LEVEL_8                                        AS level_8,
    DECODE(J.OTHER_DEBIT_CREDIT, 'C', 'Cr', 'D', 'Db', 'O', ' ') AS debit_credit_1,
    f.ORIGIN_BRANCH_CODE                                     AS origin_branch_code
FROM 
    MG_BRANCHES_GENERAL         c,
    BC_TXN_ENTRY_DETAILS        e,
    MG_CURRENCY                 b,
    BC_CORRESPONDENT_ACCOUNTS   g,
    MG_TYPES_OF_REDEMPTION      d,
    BC_TXN_ENTRIES              f,
    BC_CHECKS_PRINTED           h,
    BC_TRANSACTIONS_X_CONCEPTS  a,
    MG_TRANSACTION_TYPES        J
WHERE 
    j.APPLICATION_CODE              = a.APPLICATION_CODE
AND j.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.APPLICATION_CODE              = a.APPLICATION_CODE
AND f.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.CONCEPT_APPLICATION_CODE      = a.ORIGIN_APPLICATION_CODE
AND f.CONCEPT_TRANSACTION_CODE      = a.CONCEPT_TRANSACTION_CODE
AND f.CURRENCY_CODE                 = a.CURRENCY_CODE
AND e.COMPANY_CODE                  = NVL(:p_company_code, e.COMPANY_CODE)
AND e.BRANCH_CODE                   = NVL(:p_branch_code, e.BRANCH_CODE)
AND e.CURRENCY_CODE                 = NVL(:p_currency_code, e.CURRENCY_CODE)
AND e.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, e.CORRESPONDENT_BRANCH_CODE)
AND e.ACCOUNT_NBR                   = NVL(:p_account_number, e.ACCOUNT_NBR)
AND e.REFERENCE_NBR                 = NVL(:p_check_number, e.REFERENCE_NBR)
AND d.EXCHANGE_TYPE_CODE            = e.EXCHANGE_TYPE_CODE
AND d.CHECK_BANK_TYPE               = 2
AND c.BRANCH_CODE                   = e.CORRESPONDENT_BRANCH_CODE
AND c.COMPANY_CODE                  = e.COMPANY_CODE
AND b.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.COMPANY_CODE                  = e.COMPANY_CODE
AND g.BRANCH_CODE                   = e.BRANCH_CODE
AND g.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.CORRESPONDENT_BRANCH_CODE     = e.CORRESPONDENT_BRANCH_CODE
AND g.ACCOUNT_NBR                   = e.ACCOUNT_NBR
AND f.TXN_ENTRY_SEQ                 = e.TXN_ENTRY_SEQ
AND f.TXN_ENTRY_DATE                = e.TXN_ENTRY_DATE
AND f.USER_CODE                     = e.USER_TXN_ENTRY_CODE
AND f.TXN_ENTRY_STATE               = 1
AND h.COMPANY_CODE                  = NVL(:p_company_code, h.COMPANY_CODE)
AND h.BRANCH_CODE                   = NVL(:p_branch_code, h.BRANCH_CODE)
AND h.CURRENCY_CODE                 = NVL(:p_currency_code, h.CURRENCY_CODE)
AND h.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, h.CORRESPONDENT_BRANCH_CODE)
AND h.ACCOUNT_NBR                   = NVL(:p_account_number, h.ACCOUNT_NBR)
AND TO_CHAR(h.CHECK_NBR)            = NVL(:p_check_number, TO_CHAR(h.CHECK_NBR))
UNION 
SELECT 
    e.DOCUMENT_NBR                                           AS reference_number,
    e.BENEFICIARY                                            AS beneficiary_detail,
    e.TXN_ENTRY_VALUE                                        AS amount,
    e.CORRESPONDENT_BRANCH_CODE                              AS correspondent_branch_code,
    e.BRANCH_CODE                                            AS branch_code,
    e.DOCUMENT_NBR                                           AS document_number,
    e.DESCRIPTION                                            AS detail_description,
    e.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    e.TXN_ENTRY_DATE                                         AS txn_entry_date,
    c.BRANCH_NAME                                            AS branch_name,
    b.CURRENCY_CODE                                          AS currency_code,
    g.LANGUAGE_CHECK                                         AS check_language,
    h.GROUP_CODE                                             AS group_code,
    e.DOCUMENT_NBR                                           AS check_number,
    f.REQUEST_SEQ                                            AS request_seq,
    f.CONCEPT_APPLICATION_CODE                               AS concept_application_code,
    e.ACCOUNT_NBR                                            AS account_number,
    f.CONCEPT_TRANSACTION_CODE                               AS concept_transaction_code,
    e.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code_2,
    e.TXN_ENTRY_VALUE                                        AS check_amount,
    a.COMPANY_CODE                                           AS accounting_company_code,
    a.ACCOUNT_LEVEL_1                                        AS level_1,
    a.ACCOUNT_LEVEL_2                                        AS level_2,
    a.ACCOUNT_LEVEL_3                                        AS level_3,
    a.ACCOUNT_LEVEL_4                                        AS level_4,
    a.ACCOUNT_LEVEL_5                                        AS level_5,
    a.ACCOUNT_LEVEL_6                                        AS level_6,
    a.ACCOUNT_LEVEL_7                                        AS level_7,
    a.ACCOUNT_LEVEL_8                                        AS level_8,
    DECODE(J.OTHER_DEBIT_CREDIT, 'C', 'Cr', 'D', 'Db', 'O', ' ') AS debit_credit_1,
    f.ORIGIN_BRANCH_CODE                                     AS origin_branch_code
FROM 
    MG_BRANCHES_GENERAL             c,
    BC_DETAILS_HISTORICAL           e,
    MG_CURRENCY                     b,
    BC_CORRESPONDENT_ACCOUNTS       g,
    MG_TYPES_OF_REDEMPTION          d,
    BC_TXN_ENTRIES_HISTORICAL       f,
    BC_CHECKS_PRINTED               h,
    BC_TRANSACTIONS_X_CONCEPTS      a,
    MG_TRANSACTION_TYPES            J
WHERE 
    j.APPLICATION_CODE              = a.APPLICATION_CODE
AND j.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.APPLICATION_CODE              = a.APPLICATION_CODE
AND f.TRANSACTION_TYPE_CODE         = a.TRANSACTION_TYPE_CODE
AND f.CONCEPT_APPLICATION_CODE      = a.ORIGIN_APPLICATION_CODE
AND f.CONCEPT_TRANSACTION_CODE      = a.CONCEPT_TRANSACTION_CODE
AND f.CURRENCY_CODE                 = a.CURRENCY_CODE
AND e.COMPANY_CODE                  = NVL(:p_company_code, e.COMPANY_CODE)
AND e.BRANCH_CODE                   = NVL(:p_branch_code, e.BRANCH_CODE)
AND e.CURRENCY_CODE                 = NVL(:p_currency_code, e.CURRENCY_CODE)
AND e.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, e.CORRESPONDENT_BRANCH_CODE)
AND e.ACCOUNT_NBR                   = NVL(:p_account_number, e.ACCOUNT_NBR)
AND e.DOCUMENT_NBR                  = NVL(:p_check_number, e.DOCUMENT_NBR)
AND d.EXCHANGE_TYPE_CODE            = e.EXCHANGE_TYPE_CODE
AND d.CHECK_BANK_TYPE               = 2
AND c.BRANCH_CODE                   = e.CORRESPONDENT_BRANCH_CODE
AND c.COMPANY_CODE                  = e.COMPANY_CODE
AND b.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.COMPANY_CODE                  = e.COMPANY_CODE
AND g.BRANCH_CODE                   = e.BRANCH_CODE
AND g.CURRENCY_CODE                 = e.CURRENCY_CODE
AND g.CORRESPONDENT_BRANCH_CODE     = e.CORRESPONDENT_BRANCH_CODE
AND g.ACCOUNT_NBR                   = e.ACCOUNT_NBR
AND f.TXN_ENTRY_SEQ                 = e.TXN_ENTRY_SEQ
AND f.TXN_ENTRY_DATE                = e.TXN_ENTRY_DATE
AND f.USER_CODE                     = e.USER_TXN_ENTRY_CODE
AND f.TXN_ENTRY_STATE               = 1
AND h.COMPANY_CODE                  = NVL(:p_company_code, h.COMPANY_CODE)
AND h.BRANCH_CODE                   = NVL(:p_branch_code, h.BRANCH_CODE)
AND h.CURRENCY_CODE                 = NVL(:p_currency_code, h.CURRENCY_CODE)
AND h.CORRESPONDENT_BRANCH_CODE     = NVL(:p_correspondent_code, h.CORRESPONDENT_BRANCH_CODE)
AND h.ACCOUNT_NBR                   = NVL(:p_account_number, h.ACCOUNT_NBR)
AND TO_CHAR(h.CHECK_NBR)            = NVL(:p_check_number, TO_CHAR(h.CHECK_NBR))


-- ======================================================================== QUERY 2: Q_DESGLOSE
SELECT 
    a.AMOUNT                                                 AS breakdown_amount,
    a.DESCRIPTION                                            AS description,
    a.TRN_TRANSACTION_CODE                                   AS transaction_code_trn,
    a.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    a.USER_CODE                                              AS user_code,
    a.TXN_ENTRY_DATE                                         AS txn_entry_date,
    cdes.LEVEL_1                                             AS level_1_breakdown,
    cdes.LEVEL_2                                             AS level_2_breakdown,
    cdes.LEVEL_3                                             AS level_3_breakdown,
    cdes.LEVEL_4                                             AS level_4_breakdown,
    cdes.LEVEL_5                                             AS level_5_breakdown,
    cdes.LEVEL_6                                             AS level_6_breakdown,
    cdes.LEVEL_7                                             AS level_7_breakdown,
    cdes.LEVEL_8                                             AS level_8_breakdown,
    cdes.DESCRIPTION_BREAKDOWN                               AS accounting_desc_breakdown
FROM 
    BC_BREAKDOWNS_TXN_ENTRIES   a,
    BC_BREAKDOWN_CONCEPTS       cdes,
    MG_TRANSACTION_TYPES        b,
    BC_TXN_ENTRIES              c
WHERE 
    a.BREAKDOWN_SEQ                 = cdes.BREAKDOWN_SEQ
AND a.TRN_APPLICATION_CODE          = cdes.TRN_APPLICATION_CODE
AND a.TRN_TRANSACTION_CODE          = cdes.TRN_TRANSACTION_CODE
AND a.CURRENCY_CODE                 = cdes.CURRENCY_CODE
AND a.CONCEPT_APPLICATION_CODE      = cdes.CONCEPT_APPLICATION_CODE
AND a.CONCEPT_TRANSACTION_CODE      = cdes.CONCEPT_TRANSACTION_CODE
AND b.APPLICATION_CODE              = 'BBC'
AND b.TRANSACTION_TYPE_CODE         = a.TRN_TRANSACTION_CODE
AND c.TXN_ENTRY_DATE                = a.TXN_ENTRY_DATE
AND c.USER_CODE                     = a.USER_CODE
AND c.TXN_ENTRY_SEQ                 = a.TXN_ENTRY_SEQ
UNION ALL
SELECT 
    a.AMOUNT                                                 AS breakdown_amount,
    a.DESCRIPTION                                            AS description,
    a.TRN_TRANSACTION_CODE                                   AS transaction_code_trn,
    a.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    a.USER_TXN_ENTRY_CODE                                    AS user_code,
    a.TXN_ENTRY_DATE                                         AS txn_entry_date,
    cdes.LEVEL_1                                             AS level_1_breakdown,
    cdes.LEVEL_2                                             AS level_2_breakdown,
    cdes.LEVEL_3                                             AS level_3_breakdown,
    cdes.LEVEL_4                                             AS level_4_breakdown,
    cdes.LEVEL_5                                             AS level_5_breakdown,
    cdes.LEVEL_6                                             AS level_6_breakdown,
    cdes.LEVEL_7                                             AS level_7_breakdown,
    cdes.LEVEL_8                                             AS level_8_breakdown,
    cdes.DESCRIPTION_BREAKDOWN                               AS accounting_desc_breakdown
FROM 
    BC_BREAKDOWNS_HISTORICAL        a,
    BC_BREAKDOWN_CONCEPTS           cdes,
    MG_TRANSACTION_TYPES            b,
    BC_TXN_ENTRIES_HISTORICAL       c
WHERE 
    a.BREAKDOWN_SEQ                 = cdes.BREAKDOWN_SEQ
AND a.TRN_APPLICATION_CODE          = cdes.TRN_APPLICATION_CODE
AND a.TRN_TRANSACTION_CODE          = cdes.TRN_TRANSACTION_CODE
AND a.CURRENCY_CODE                 = cdes.CURRENCY_CODE
AND a.CONCEPT_APPLICATION_CODE      = cdes.CONCEPT_APPLICATION_CODE
AND a.CONCEPT_TRANSACTION_CODE      = cdes.CONCEPT_TRANSACTION_CODE
AND b.APPLICATION_CODE              = 'BBC'
AND b.TRANSACTION_TYPE_CODE         = a.TRN_TRANSACTION_CODE
AND c.TXN_ENTRY_DATE                = a.TXN_ENTRY_DATE
AND c.USER_CODE                     = a.USER_TXN_ENTRY_CODE
AND c.TXN_ENTRY_SEQ                 = a.TXN_ENTRY_SEQ


-- ======================================================================== QUERY 3: Q_DETALLE
SELECT 
    a.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    a.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    a.TXN_ENTRY_DATE                                         AS txn_entry_date,
    b.COMPANY_CODE                                           AS company_code,
    b.ACCOUNT_LEVEL_1                                        AS level_1_balance,
    b.ACCOUNT_LEVEL_2                                        AS level_2_balance,
    b.ACCOUNT_LEVEL_3                                        AS level_3_balance,
    b.ACCOUNT_LEVEL_4                                        AS level_4_balance,
    b.ACCOUNT_LEVEL_5                                        AS level_5_balance,
    b.ACCOUNT_LEVEL_6                                        AS level_6_balance,
    b.ACCOUNT_LEVEL_7                                        AS level_7_balance,
    b.ACCOUNT_LEVEL_8                                        AS level_8_balance,
    d.VALUE                                                  AS value,
    'Bank' || ' ' || f.BRANCH_NAME || ', ' || b.ACCOUNT_NBR AS accounting_desc_balance,
    DECODE(E.OTHER_DEBIT_CREDIT, 'D', 'Cr', 'C', 'Db', 'O', ' ') AS debit_credit_2
FROM 
    BC_TXN_ENTRY_DETAILS        a,
    BC_TXN_ENTRIES              d,
    BC_CORRESPONDENT_BALANCES   b,
    MG_TYPES_OF_REDEMPTION      c,
    MG_TRANSACTION_TYPES        e,
    MG_BRANCHES_GENERAL         f
WHERE 
    a.CORRESPONDENT_BRANCH_CODE     = f.BRANCH_CODE
AND a.ACCOUNT_NBR                   = b.ACCOUNT_NBR
AND a.COMPANY_CODE                  = b.COMPANY_CODE
AND a.BRANCH_CODE                   = b.BRANCH_CODE
AND a.CORRESPONDENT_BRANCH_CODE     = b.CORRESPONDENT_BRANCH_CODE
AND a.EXCHANGE_TYPE_CODE            = c.EXCHANGE_TYPE_CODE
AND b.BALANCE_TYPE                  = c.BANK_BALANCE_TYPE
AND a.TXN_ENTRY_SEQ                 = d.TXN_ENTRY_SEQ
AND a.TXN_ENTRY_DATE                = d.TXN_ENTRY_DATE
AND a.USER_TXN_ENTRY_CODE           = d.USER_CODE
AND e.APPLICATION_CODE              = d.CONCEPT_APPLICATION_CODE
AND e.TRANSACTION_TYPE_CODE         = d.TRANSACTION_TYPE_CODE
AND b.BALANCE_TYPE                  = 1
UNION
SELECT 
    a.TXN_ENTRY_SEQ                                          AS txn_entry_seq,
    a.USER_TXN_ENTRY_CODE                                    AS user_txn_entry_code,
    a.TXN_ENTRY_DATE                                         AS txn_entry_date,
    b.COMPANY_CODE                                           AS company_code,
    b.ACCOUNT_LEVEL_1                                        AS level_1_balance,
    b.ACCOUNT_LEVEL_2                                        AS level_2_balance,
    b.ACCOUNT_LEVEL_3                                        AS level_3_balance,
    b.ACCOUNT_LEVEL_4                                        AS level_4_balance,
    b.ACCOUNT_LEVEL_5                                        AS level_5_balance,
    b.ACCOUNT_LEVEL_6                                        AS level_6_balance,
    b.ACCOUNT_LEVEL_7                                        AS level_7_balance,
    b.ACCOUNT_LEVEL_8                                        AS level_8_balance,
    d.VALUE                                                  AS value,
    'Bank' || ' ' || f.BRANCH_NAME || ', ' || b.ACCOUNT_NBR AS accounting_desc_balance,
    DECODE(E.OTHER_DEBIT_CREDIT, 'D', 'Cr', 'C', 'Db', 'O', ' ') AS debit_credit_2
FROM 
    BC_DETAILS_HISTORICAL           a,
    BC_TXN_ENTRIES_HISTORICAL       d,
    BC_CORRESPONDENT_BALANCES       b,
    MG_TYPES_OF_REDEMPTION          c,
    MG_TRANSACTION_TYPES            e,
    MG_BRANCHES_GENERAL             f
WHERE 
    a.CORRESPONDENT_BRANCH_CODE     = f.BRANCH_CODE
AND a.ACCOUNT_NBR                   = b.ACCOUNT_NBR
AND a.COMPANY_CODE                  = b.COMPANY_CODE
AND a.BRANCH_CODE                   = b.BRANCH_CODE
AND a.CORRESPONDENT_BRANCH_CODE     = b.CORRESPONDENT_BRANCH_CODE
AND a.EXCHANGE_TYPE_CODE            = c.EXCHANGE_TYPE_CODE
AND b.BALANCE_TYPE                  = c.BANK_BALANCE_TYPE
AND a.TXN_ENTRY_SEQ                 = d.TXN_ENTRY_SEQ
AND a.TXN_ENTRY_DATE                = d.TXN_ENTRY_DATE
AND a.USER_TXN_ENTRY_CODE           = d.USER_CODE
AND e.APPLICATION_CODE              = d.CONCEPT_APPLICATION_CODE
AND e.TRANSACTION_TYPE_CODE         = d.TRANSACTION_TYPE_CODE
AND b.BALANCE_TYPE                  = 1