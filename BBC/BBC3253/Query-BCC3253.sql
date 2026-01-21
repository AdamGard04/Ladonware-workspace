-- QUERY TRANSLATED:
SELECT  
    a.USER_CODE                   AS user_code,
    a.TXN_ENTRY_SEQ               AS txn_entry_seq,
    a.REQUEST_SEQ                 AS request_seq,
    a.TXN_ENTRY_DATE              AS txn_entry_date,
    a.VALUE                       AS value,
    a.CURRENCY_CODE               AS currency_code,
    a.CONCEPT_APPLICATION_CODE    AS concept_application_code,
    a.CONCEPT_TRANSACTION_CODE    AS concept_transaction_code,
    a.AUXILIARY_APPLICATION_CODE  AS auxiliary_application_code,
    a.TRANSACTION_TYPE_CODE       AS transaction_type_code,
    a.APPLICATION_CODE            AS application_code,
    c.ACCOUNT_NBR                 AS account_nbr,
    c.CORRESPONDENT_BRANCH_CODE   AS correspondent_branch_code,
    c.TXN_ENTRY_VALUE             AS txn_entry_value
FROM 
    BC_TXN_ENTRIES a,
    BC_TXN_ENTRY_DETAILS c,
    MG_TRANSACTION_TYPES b
WHERE  
       c.CORRESPONDENT_BRANCH_CODE = NVL(:p_correspondent_code, c.CORRESPONDENT_BRANCH_CODE)
  AND  c.CURRENCY_CODE             = NVL(:p_currency_code, c.CURRENCY_CODE)
  AND  c.BRANCH_CODE               = NVL(:p_branch_code, c.BRANCH_CODE)
  AND  c.ACCOUNT_NBR               = NVL(:p_account_number, c.ACCOUNT_NBR)
  AND  a.TRANSACTION_TYPE_CODE     = b.TRANSACTION_TYPE_CODE
  AND  a.APPLICATION_CODE          = b.APPLICATION_CODE
  AND  b.OTHER_DEBIT_CREDIT        IN ('D','C')
  AND  b.OPERATION_TYPE           != '4'
  AND  a.TXN_ENTRY_SEQ            = c.TXN_ENTRY_SEQ
  AND  a.TXN_ENTRY_DATE           = c.TXN_ENTRY_DATE
  AND  a.USER_CODE                = c.USER_TXN_ENTRY_CODE
  AND  c.TXN_ENTRY_VALUE          > 0
  AND  a.TXN_ENTRY_STATE          = 5
  AND  a.TXN_ENTRY_DATE BETWEEN NVL(:p_desde, a.TXN_ENTRY_DATE)
                            AND NVL(:p_hasta, a.TXN_ENTRY_DATE)

UNION ALL

SELECT  
    a.USER_CODE                   AS user_code,
    a.TXN_ENTRY_SEQ               AS txn_entry_seq,
    a.REQUEST_SEQ                 AS request_seq,
    a.TXN_ENTRY_DATE              AS txn_entry_date,
    a.VALUE                       AS value,
    a.CURRENCY_CODE               AS currency_code,
    a.CONCEPT_APPLICATION_CODE    AS concept_application_code,
    a.CONCEPT_TRANSACTION_CODE    AS concept_transaction_code,
    a.AUXILIARY_APPLICATION_CODE  AS auxiliary_application_code,
    a.TRANSACTION_TYPE_CODE       AS transaction_type_code,
    a.APPLICATION_CODE            AS application_code,
    c.ACCOUNT_NBR                 AS account_nbr,
    c.CORRESPONDENT_BRANCH_CODE   AS correspondent_branch_code,
    c.TXN_ENTRY_VALUE             AS txn_entry_value
FROM 
    BC_TXN_ENTRIES_HISTORICAL a,
    BC_DETAILS_HISTORICAL c,
    MG_TRANSACTION_TYPES b
WHERE  
       c.CORRESPONDENT_BRANCH_CODE = NVL(:p_correspondent_code, c.CORRESPONDENT_BRANCH_CODE)
  AND  c.CURRENCY_CODE             = NVL(:p_currency_code, c.CURRENCY_CODE)
  AND  c.ACCOUNT_NBR               = NVL(:p_account_number, c.ACCOUNT_NBR)
  AND  a.TRANSACTION_TYPE_CODE     = b.TRANSACTION_TYPE_CODE
  AND  a.APPLICATION_CODE          = b.APPLICATION_CODE
  AND  b.OTHER_DEBIT_CREDIT        IN ('D','C')
  AND  b.OPERATION_TYPE           != '4'
  AND  a.TXN_ENTRY_SEQ            = c.TXN_ENTRY_SEQ
  AND  a.TXN_ENTRY_DATE           = c.TXN_ENTRY_DATE
  AND  a.USER_CODE                = c.USER_TXN_ENTRY_CODE
  AND  c.TXN_ENTRY_VALUE          > 0
  AND  a.TXN_ENTRY_STATE          = 5
  AND  a.TXN_ENTRY_DATE BETWEEN NVL(:p_desde, a.TXN_ENTRY_DATE)
                            AND NVL(:p_hasta, a.TXN_ENTRY_DATE);

