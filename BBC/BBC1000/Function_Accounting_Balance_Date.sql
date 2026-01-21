FUNCTION FC_ACCOUNTING_BALANCE_DATE  (
	PN_COMPANY_CODE      Number,
	PV_LEVEL_1            Varchar2,
	PV_LEVEL_2            Varchar2,
	PV_LEVEL_3            Varchar2,
	PV_LEVEL_4            Varchar2,
	PV_LEVEL_5            Varchar2,
	PV_LEVEL_6            Varchar2,
	PV_LEVEL_7            Varchar2,
	PV_LEVEL_8            Varchar2,
	PN_CURRENCY_CODE       Number,	
	PN_LOCAL_CURRENCY_CODE        Varchar2,
	PD_DATE              Date,
	PN_CURRENT_BALANCE IN OUT Number,
	PN_LOCAL_BALANCE  IN OUT Number
) RETURN NUMBER Is
  LD_TODAY_DATE     		Date;
  LN_YEAR         			Number;
  LN_MONTH          		Number;
  LN_DAY          			Number;
  LN_TOTAL_DEBIT     		Number;
  LN_TOTAL_CREDIT     		Number;
  LN_TOTAL_DEBIT_ME  		Number;
  LN_TOTAL_CREDIT_ME  		Number;
  LN_BALANCE        		Number;
  LN_BALANCE_ME     		Number;
  Lv_Error        			Varchar2(2000);
  LV_NAT   			Varchar2(1);
Begin
  Begin
	  Select TODAY_DATE
	    Into LD_TODAY_DATE
	    From MG_SCHEDULE
	   Where COMPANY_CODE    = PN_COMPANY_CODE
	     and APPLICATION_CODE = 'BGM';
	exception when others then
	return 0;
  End;
  
  LN_DAY  := To_number(to_char(PD_DATE,'DD'));  
  LN_MONTH  := To_number(to_char(PD_DATE,'MM'));
  LN_YEAR := To_number(to_char(PD_DATE,'YYYY'));
  
  Lv_Error :=  Gm_f_naturaleza_cuenta
                     (PN_COMPANY_CODE,
				   	          PV_LEVEL_1,
				   	          PV_LEVEL_2,
				   	          PV_LEVEL_3,
				   	          PV_LEVEL_4,
				   	          PV_LEVEL_5,
				   	          PV_LEVEL_6,
                      LV_NAT);

  If PD_DATE < LD_TODAY_DATE Then
    GM_K_BUSCA_SALDOS.GM_P_SALDO_DIARIOS
                    (PN_COMPANY_CODE,
				   	         PV_LEVEL_1,
				   	         PV_LEVEL_2,
				   	         PV_LEVEL_3,
				   	         PV_LEVEL_4,
				   	         PV_LEVEL_5,
				   	         PV_LEVEL_6,
				   	         PV_LEVEL_7,
				   	         PV_LEVEL_8,
				   	         LN_YEAR,   
				   	         LN_MONTH,
				   	         LN_DAY,
				   	         'S', -- Recibe Movimiento
					           LN_BALANCE,
			               Lv_Error);
	  If PN_LOCAL_CURRENCY_CODE != PN_CURRENCY_CODE Then
       Gm_P_saldo_Diario_ME
                       (PN_COMPANY_CODE,
                        'S',
                        PV_LEVEL_1,
                        PV_LEVEL_2,
                        PV_LEVEL_3,
                        PV_LEVEL_4,
                        PV_LEVEL_5, 
                        PV_LEVEL_6,
                        PV_LEVEL_7, 
                        PV_LEVEL_8,
                        PN_CURRENCY_CODE,
                        LN_DAY,
                        LN_MONTH,
                        LN_YEAR,
                        LN_BALANCE_ME);
                        
	  End If;
  Else
    Begin
  	  Begin
  	    Select BALANCE_CURRENT 
  	    Into LN_BALANCE
  	    From GM_ACCOUNT_BALANCE 
  	    Where COMPANY_CODE =  PN_COMPANY_CODE
  	    and LEVEL_1        = PV_LEVEL_1
   	    and LEVEL_2        = PV_LEVEL_2
  	    and LEVEL_3        = PV_LEVEL_3
   	    and LEVEL_4        = PV_LEVEL_4
   	    and LEVEL_5        = PV_LEVEL_5
   	    and LEVEL_6        = PV_LEVEL_6
    	  and LEVEL_7        = PV_LEVEL_7
   	    and LEVEL_8        = PV_LEVEL_8;
  	  Exception
  	 	  When No_data_found Then
  	 	    LN_BALANCE := 0;
          When others then
	        return 0;
  	  End;
  	 
      GM_P_CALCULA_SALDO_MOV 
                     (PN_COMPANY_CODE,
				   	          PV_LEVEL_1,
				   	          PV_LEVEL_2,
				   	          PV_LEVEL_3,
				   	          PV_LEVEL_4,
				   	          PV_LEVEL_5,
				   	          PV_LEVEL_6,
				   	          PV_LEVEL_7,
				   	          PV_LEVEL_8,
                      PN_LOCAL_CURRENCY_CODE,
                      PD_DATE,
                      LN_TOTAL_DEBIT,
                      LN_TOTAL_CREDIT,
                      LN_TOTAL_DEBIT_ME,
                      LN_TOTAL_CREDIT_ME);
 
      If LV_NAT = 'D' Then
   	    LN_BALANCE := LN_BALANCE + LN_TOTAL_DEBIT - LN_TOTAL_CREDIT;
   	  Else
        LN_BALANCE := LN_BALANCE - LN_TOTAL_DEBIT + LN_TOTAL_CREDIT;
   	  End IF;
   	 
      If PN_LOCAL_CURRENCY_CODE != PN_CURRENCY_CODE Then
   	    Begin
  	      Select BALANCE_CURRENT 
  	      Into LN_BALANCE_ME
  	      From GM_FOREIGN_BALANCE 
  	      Where COMPANY_CODE = PN_COMPANY_CODE
  	      and LEVEL_1       = PV_LEVEL_1
   	      and LEVEL_2       = PV_LEVEL_2
  	      and LEVEL_3       = PV_LEVEL_3
   	      and LEVEL_4       = PV_LEVEL_4
   	      and LEVEL_5       = PV_LEVEL_5
   	      and LEVEL_6       = PV_LEVEL_6
    	    and LEVEL_7       = PV_LEVEL_7
   	      and LEVEL_8       = PV_LEVEL_8
   	      and CURRENCY_CODE = PN_CURRENCY_CODE;
  	    Exception
  	 	    When No_data_found Then
  	 	      LN_BALANCE_ME := 0;
            When others then
                return 0;
  	    End; 
  	 
   	    If LV_NAT = 'D' Then
   	 	    LN_BALANCE_ME := LN_BALANCE_ME + LN_TOTAL_DEBIT_ME - LN_TOTAL_CREDIT_ME;
   	    Else
      	  LN_BALANCE_ME := LN_BALANCE_ME - LN_TOTAL_DEBIT_ME + LN_TOTAL_CREDIT_ME;
        End If;
      End If;
  	End;
  End If;
  PN_LOCAL_BALANCE   := LN_BALANCE;
  PN_CURRENT_BALANCE  := LN_BALANCE;
  If PN_CURRENCY_CODE != PN_LOCAL_CURRENCY_CODE Then
  	PN_CURRENT_BALANCE := LN_BALANCE_ME;
  End If;
  RETURN PN_CURRENT_BALANCE;
End;





parametro: 12-01-2018