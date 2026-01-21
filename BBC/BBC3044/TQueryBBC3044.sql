-- Q_Cuentas
SELECT  a.level_1,
        a.level_2,
        a.level_3,
        a.level_4,
        a.level_5,
        a.level_6,
        a.level_7,
        a.level_8,
        a.credit_debit,
        ABS(a.txn_entry_amount) txn_entry_amount,
        a.auxiliary_code,
        a.line_seq,
        b.username,
        b.txn_entry_nbr,
        b.txn_entry_date,
        b.effdate,
        a.reference,
        DECODE(a.credit_debit, 'D', DECODE(a.currency_code, d.local_currency_code, a.txn_entry_amount, a.txn_entry_local_amount)) debit_amount,
        DECODE(a.credit_debit, 'C', DECODE(a.currency_code, d.local_currency_code, a.txn_entry_amount, a.txn_entry_local_amount)) credit_amount,
        DECODE(a.credit_debit, 'D', a.txn_entry_amount) debit_amount_curr,
        DECODE(a.credit_debit, 'C', a.txn_entry_amount) credit_amount_curr,
        b.description header_desc,
        a.currency_code,
        c.description currency_desc,
        a.description detail_desc,
        DECODE(a.currency_code, d.local_currency_code, b.total_control, b.total_control * NVL(a.exchange_rate, 1)) total_control,
        b.unit_code,
        DECODE(a.exchange_rate, NULL, 1, a.exchange_rate) exchange_rate,
        a.cost_center,
        a.presupuesto_code,
        a.presupuesto_class,
        a.auxiliary_code,
        DECODE(b.exchange_rate, NULL, 1, b.exchange_rate) header_exchange_rate,
        b.branch_code,
        a.concept_application,
        a.transaction_concept
FROM    BC_COMPROBANTES b,
        BC_DETAILS_VOUCHERS a,
        MG_CURRENCY c,
        MG_PARAMETERS_GENERAL d
WHERE   b.company_code = nvl(TO_NUMBER(:p_company_code), b.company_code)
    AND a.username = b.username
    AND a.txn_entry_nbr = b.txn_entry_nbr
    AND a.txn_entry_date = b.txn_entry_date
    AND c.currency_code = a.currency_code
    AND d.company_code = b.company_code
ORDER BY b.username,
         b.txn_entry_nbr,
         b.txn_entry_date,
         a.concept_application,
         a.transaction_concept,
         a.line_seq


-- Q_SUCURSALES
SELECT  ABS(SUM(DECODE(a.credit_debit, 'D', DECODE(a.currency_code, d.local_currency_code, a.txn_entry_amount, a.txn_entry_local_amount)))) sum_db,
        ABS(SUM(DECODE(a.credit_debit, 'C', DECODE(a.currency_code, d.local_currency_code, ABS(a.txn_entry_amount), ABS(a.txn_entry_local_amount))))) sum_cr
FROM    BC_COMPROBANTES b,
        BC_DETAILS_VOUCHERS a,
        MG_CURRENCY c,
        GM_SETTINGS d
WHERE   b.company_code = TO_NUMBER(:p_company_code)
    AND a.username = b.username
    AND a.txn_entry_nbr = b.txn_entry_nbr
    AND a.txn_entry_date = b.txn_entry_date
    AND c.currency_code = a.currency_code
    AND d.company_code = b.company_code

