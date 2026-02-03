-- Q_CA_DAILY_TRANSACTIONS
-- Parameters:
-- P_COMPANY_CODE
-- P_BRANCH_CODE
-- P_SUBAPPLICATION_CODE
-- P_ACCOUNT_NBR
-- P_BANCK_ASSIGNED_CODE
-- P_USER_CODE

SELECT a.user_code, 
       a.txn_entry_seq, 
       a.time, 
       a.company_code,
       a.branch_code, 
       a.subappl_code, 
       a.account_nbr,
       to_char(a.branch_code,'0000')||'-'||to_char(a.subappl_code,'000')||'-'||to_char(a.account_nbr,'000000000000') account_id,
       a.document_nbr, 
       a.origin_branch, 
       a.value, 
       a.effdate,
       decode(int_b.VERIFY, 'E', int_a.value) cash,
       decode(int_b.VERIFY, 'C', int_a.value) own_checks,
       decode(int_b.VERIFY, 'B', int_a.value, 'A', int_a.value) reserve_ob,
       decode(int_b.VERIFY, 'G', int_a.value) external_reserve,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'4',0,a.value)) credits_amt,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'4',0,1)) count_credits,       
       decode(e.other_debit_credit,'D', decode(e.operation_type,'4',0,a.value)) debits_amt,
       decode(e.other_debit_credit,'D', decode(e.operation_type,'4',0,1)) count_debits,
       decode(e.operation_type,'4',a.value) other_amt,
       decode(e.other_debit_credit,'D', decode(e.operation_type,'5',a.value,0)) db_garnishment,
       decode(e.other_debit_credit,'D', decode(e.operation_type,'5',1,0)) count_db_garnishment,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'5',a.value,0)) cr_garnishment,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'5',1,0)) count_cr_garnishment,
       decode(e.other_debit_credit,'D', decode(e.operation_type,'4',0, decode(e.operation_type,'5',0,a.value))) db_branch,
       decode(e.other_debit_credit,'D', decode(e.operation_type,'4',0, decode(e.operation_type,'5',0,1))) count_db_branch,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'4',0, decode(e.operation_type,'5',0,a.value))) cr_branch,
       decode(e.other_debit_credit,'C', decode(e.operation_type,'4',0, decode(e.operation_type,'5',0,1))) count_cr_branch,
       e.bank_assigned_code, 
       e.description,
       f.branch_name, 
       g.description subapplication_name, 
       h.currency_code,
       h.description currency_desc, 
       z.account_name
  FROM CA_TXN_ENTRIES_DAILY    a, 
       MG_TRANSACTION_TYPES    e,
       MG_BRANCHES             f,
       MG_SUBAPPLICATIONS      g, 
       MG_CURRENCY             h, 
       CA_SAVINGS_ACCOUNTS     z,
       CA_INTEGRATIONS         int_a,
       MG_TYPES_OF_REDEMPTION  int_b
 WHERE a.company_code          = z.company_code
   AND a.branch_code           = z.branch_code
   AND a.subappl_code          = z.subappl_code
   AND a.account_nbr           = z.account_nbr 
   AND a.application_code      = e.application_code
   AND a.transaction_type_code = e.transaction_type_code
   AND a.company_code          = f.company_code
   AND a.origin_branch         = f.branch_code
   AND a.subappl_code          = g.subapplication_code
   AND a.application_code      = g.application_code
   AND g.currency_code         = h.currency_code
   AND a.txn_entry_status     <> '5'
   AND a.user_code             = int_a.user_code(+)
   AND a.txn_entry_seq         = int_a.txn_entry_seq(+)
   AND int_a.reservation_type_code = int_b.exchange_type_code(+)
   AND a.company_code          = P_COMPANY_CODE
   AND (a.origin_branch        = P_BRANCH_CODE OR P_BRANCH_CODE IS NULL)
   AND (a.subappl_code         = P_SUBAPPLICATION_CODE OR P_SUBAPPLICATION_CODE IS NULL)
   AND (a.account_nbr          = P_ACCOUNT_NBR OR P_ACCOUNT_NBR IS NULL)
   AND (e.bank_assigned_code   = P_BANCK_ASSIGNED_CODE OR P_BANCK_ASSIGNED_CODE IS NULL)
   AND (a.user_code            = upper(P_USER_CODE) OR P_USER_CODE IS NULL) 
 ORDER BY h.currency_code, a.origin_branch, a.subappl_code, e.bank_assigned_code, 
          a.user_code, a.branch_code, a.account_nbr, a.txn_entry_seq