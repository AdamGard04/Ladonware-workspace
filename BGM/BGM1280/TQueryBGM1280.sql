-- Q_REPORTE_DETALLE --> Q_REPORT_DETAIL
select
    A.COMPANY_CODE AS COMPANY_CODE,
    REPORT_CODE AS REPORT_CODE,
    FINAL_LEVEL_1 AS FINAL_LEVEL_1,
    FINAL_LEVEL_2 AS FINAL_LEVEL_2,
    FINAL_LEVEL_3 AS FINAL_LEVEL_3,
    FINAL_LEVEL_4 AS FINAL_LEVEL_4,
    FINAL_LEVEL_5 AS FINAL_LEVEL_5,
    FINAL_LEVEL_6 AS FINAL_LEVEL_6,
    FINAL_LEVEL_7 AS FINAL_LEVEL_7,
    FINAL_LEVEL_8 AS FINAL_LEVEL_8,
    NIVEL_1_INICIAL_CTA AS NIVEL_1_INICIAL_CTA,
    NIVEL_2_INICIAL AS NIVEL_2_INICIAL,
    NIVEL_3_INICIAL AS NIVEL_3_INICIAL,
    NIVEL_4_INICIAL_CTA AS NIVEL_4_INICIAL_CTA,
    NIVEL_5_INICIAL AS NIVEL_5_INICIAL,
    CTA_LEVEL_6_INITIAL AS CTA_LEVEL_6_INITIAL,
    FINAL_LEVEL_7 AS FINAL_LEVEL_7,
    NIVEL_8_INICIAL AS NIVEL_8_INICIAL,
    A.DESCRIPTION AS DESCRIPTION,
    RW AS RW,
    UNDERLINED AS UNDERLINED,
    COLUMN_NBR AS COLUMN_NBR,
    PRINT_SUBTOTAL AS PRINT_SUBTOTAL,
    TOTAL_PRINT AS TOTAL_PRINT,
    DETAIL_TYPE AS DETAIL_TYPE,
    SUBTOTAL_PRINT_02 AS SUBTOTAL_PRINT_02
from
    GM_REPORT_DETAIL A
where
    A.COMPANY_CODE = P_COMPANY_CODE
    and A.REPORT_CODE = P_REPORT_CODE
order by
    COMPANY_CODE,
    REPORT_CODE,
    RW;

-- ##############################################################

PROCEDURE pu_calculate_balance (GV_RECEIVES_MOVEMENT VARCHAR2,
                            GV_LEVELI_1 VARCHAR2, GV_LEVELI_2 VARCHAR2,
                            GV_LEVELI_3 VARCHAR2, GV_LEVELI_4 VARCHAR2,
                            GV_LEVELI_5 VARCHAR2, GV_LEVELI_6 VARCHAR2,
                            GV_LEVELI_7 VARCHAR2, GV_LEVELI_8 VARCHAR2,
			    GV_LEVELF_1 VARCHAR2, GV_LEVELF_2 VARCHAR2,
                            GV_LEVELF_3 VARCHAR2, GV_LEVELF_4 VARCHAR2,
                            GV_LEVELF_5 VARCHAR2, GV_LEVELF_6 VARCHAR2,
                            GV_LEVELF_7 VARCHAR2, GV_LEVELF_8 VARCHAR2,
                            Gn_Branch Number,
                            Gn_day     number,Gn_month    number,
                            Gn_year    number,Gn_day_end number,
                            Gn_month_end number,Gn_year_end number,
                            GN_TOTAL             OUT NUMBER)IS


Ln_initial_total  number (14,2):= 0;
Ln_final_total  number (14,2) := 0;
Ln_total      number (14,2) := 0;

/* cursor para separar por dia los saldos */

  cursor  C_BALANCE is
      select MONTH, DAY_1_BALANCE,DAY_2_BALANCE,DAY_3_BALANCE,DAY_4_BALANCE,DAY_5_BALANCE,DAY_6_BALANCE,
             DAY_7_BALANCE,DAY_8_BALANCE,DAY_9_BALANCE,DAY_10_BALANCE,DAY_11_BALANCE,DAY_12_BALANCE,
             DAY_13_BALANCE,DAY_14_BALANCE,DAY_15_BALANCE,DAY_16_BALANCE,DAY_17_BALANCE,DAY_18_BALANCE,
             DAY_19_BALANCE,DAY_20_BALANCE,DAY_21_BALANCE,DAY_22_BALANCE,DAY_23_BALANCE,DAY_24_BALANCE,
             DAY_25_BALANCE,DAY_26_BALANCE,DAY_27_BALANCE,DAY_28_BALANCE,DAY_29_BALANCE,DAY_30_BALANCE,DAY_31_BALANCE
      from   GM_BALANCES_DAILY a,
             GM_ACCOUNT_BALANCE b
      where ( ( YEAR   =  GN_YEAR 
        and    MONTH     =  GN_MONTH  )  
         or (  YEAR    =  GN_YEAR_END
         AND   MONTH     =   GN_MONTH_END )) 
      AND    a.level_1||a.level_2||a.level_3||a.level_4||a.level_5||a.level_6||a.level_7||a.level_8  BETWEEN
             Gv_leveli_1||Gv_leveli_2||Gv_leveli_3||Gv_leveli_4||Gv_leveli_5||Gv_leveli_6||Gv_leveli_7||Gv_leveli_8 AND
             Gv_levelf_1||Gv_levelf_2||Gv_levelf_3||Gv_levelf_4||Gv_levelf_5||Gv_levelf_6||Gv_levelf_7||Gv_levelf_8 
      AND a.level_1||a.level_2||a.level_3||a.level_4||a.level_5||a.level_6||a.level_7||a.level_8 = b.ACCOUNT
      AND B.TXN_ENTRY_RECEIVED = GV_RECEIVES_MOVEMENT
      AND a.company_code    = b.company_code
      AND To_Number(a.level_5) = Nvl(Gn_Branch,To_Number(a.level_5))
      order by  YEAR, MONTH, 
            a.level_1||a.level_2||a.level_3||a.level_4||a.level_5||a.level_6||a.level_7||a.level_8;
BEGIN
  
    FOR balance IN C_BALANCE loop

          ln_initial_total := 0;
          ln_final_total := 0;

     if balance.month = gn_month then
	if Gn_day = 1   then
            ln_initial_total :=  balance.day_1_balance;
        elsif Gn_day = 2   then
           ln_initial_total :=  balance.day_2_balance;
        elsif Gn_day = 3   then
           ln_initial_total :=  balance.day_3_balance;
        elsif Gn_day = 4   then
           ln_initial_total :=  balance.day_4_balance;
        elsif Gn_day = 5   then
           ln_initial_total :=  balance.day_5_balance;
        elsif Gn_day = 6   then
           ln_initial_total :=  balance.day_6_balance;
        elsif Gn_day = 7   then
           ln_initial_total :=  balance.day_7_balance;
        elsif Gn_day = 8   then
           ln_initial_total :=  balance.day_8_balance;
        elsif Gn_day = 9   then
           ln_initial_total :=  balance.day_9_balance;
        elsif Gn_day = 10   then
           ln_initial_total :=  balance.day_10_balance;
        elsif Gn_day = 11  then
           ln_initial_total :=  balance.day_11_balance;
        elsif Gn_day = 12   then
           ln_initial_total :=  balance.day_12_balance;
        elsif Gn_day = 13   then
           ln_initial_total :=  balance.day_13_balance;
        elsif Gn_day = 14   then
           ln_initial_total :=  balance.day_14_balance;
        elsif Gn_day = 15   then
           ln_initial_total :=  balance.day_15_balance;
        elsif Gn_day = 16   then
           ln_initial_total :=  balance.day_16_balance;
        elsif Gn_day = 17   then
           ln_initial_total :=  balance.day_17_balance;
        elsif Gn_day = 18   then
           ln_initial_total :=  balance.day_18_balance;
        elsif Gn_day = 19   then
           ln_initial_total :=  balance.day_19_balance;
        elsif Gn_day = 20   then
           ln_initial_total :=  balance.day_20_balance;
        elsif Gn_day = 21   then
           ln_initial_total :=  balance.day_21_balance;
        elsif Gn_day = 22   then
           ln_initial_total :=  balance.day_22_balance;
        elsif Gn_day = 23   then
           ln_initial_total :=  balance.day_23_balance;
        elsif Gn_day = 24   then
           ln_initial_total :=  balance.day_24_balance;
        elsif Gn_day = 25   then
           ln_initial_total :=  balance.day_25_balance;
        elsif Gn_day = 26   then
           ln_initial_total :=  balance.day_26_balance;
        elsif Gn_day = 27   then
           ln_initial_total :=  balance.day_27_balance;
        elsif Gn_day = 28   then
           ln_initial_total :=  balance.day_28_balance;
        elsif Gn_day = 29   then
           ln_initial_total :=  balance.day_29_balance;
        elsif Gn_day = 30   then
           ln_initial_total :=  balance.day_30_balance;
        else
           ln_initial_total :=  balance.day_31_balance;
        end if;
       end if; 

    if balance.month = gn_month_fin then
	if Gn_day_fin = 1   then
            ln_final_total :=  balance.day_1_balance;
        elsif Gn_day_fin = 2   then
           ln_final_total :=  balance.day_2_balance;
        elsif Gn_day_fin = 3   then
           ln_final_total :=  balance.day_3_balance;
        elsif Gn_day_fin = 4   then
           ln_final_total :=  balance.day_4_balance;
        elsif Gn_day_fin = 5   then
           ln_final_total :=  balance.day_5_balance;
        elsif Gn_day_fin = 6   then
           ln_final_total :=  balance.day_6_balance;
        elsif Gn_day_fin = 7   then
           ln_final_total :=  balance.day_7_balance;
        elsif Gn_day_fin = 8   then
           ln_final_total :=  balance.day_8_balance;
        elsif Gn_day_fin = 9   then
           ln_final_total :=  balance.day_9_balance;
        elsif Gn_day_fin = 10   then
           ln_final_total :=  balance.day_10_balance;
        elsif Gn_day_fin = 11  then
           ln_final_total :=  balance.day_11_balance;
        elsif Gn_day_fin = 12   then
           ln_final_total :=  balance.day_12_balance;
        elsif Gn_day_fin = 13   then
           ln_final_total :=  balance.day_13_balance;
        elsif Gn_day_fin = 14   then
           ln_final_total :=  balance.day_14_balance;
        elsif Gn_day_fin = 15   then
           ln_final_total :=  balance.day_15_balance;
        elsif Gn_day_fin = 16   then
           ln_final_total :=  balance.day_16_balance;
        elsif Gn_day_fin = 17   then
           ln_final_total :=  balance.day_17_balance;
        elsif Gn_day_fin = 18   then
           ln_final_total :=  balance.day_18_balance;
        elsif Gn_day_fin = 19   then
           ln_final_total :=  balance.day_19_balance;
        elsif Gn_day_fin = 20   then
           ln_final_total :=  balance.day_20_balance;
        elsif Gn_day_fin = 21   then
           ln_final_total :=  balance.day_21_balance;
        elsif Gn_day_fin = 22   then
           ln_final_total :=  balance.day_22_balance;
        elsif Gn_day_fin = 23   then
           ln_final_total :=  balance.day_23_balance;
        elsif Gn_day_fin = 24   then
           ln_final_total :=  balance.day_24_balance;
        elsif Gn_day_fin = 25   then
           ln_final_total :=  balance.day_25_balance;
        elsif Gn_day_fin = 26   then
           ln_final_total :=  balance.day_26_balance;
        elsif Gn_day_fin = 27   then
           ln_final_total :=  balance.day_27_balance;
        elsif Gn_day_fin = 28   then
           ln_final_total :=  balance.day_28_balance;
        elsif Gn_day_fin = 29   then
           ln_final_total :=  balance.day_29_balance;
        elsif Gn_day_fin = 30   then
           ln_final_total :=  balance.day_30_balance;
        else
           ln_final_total :=  balance.day_31_balance;
        end if;
       end if; 

        If p_balance_type = 1 Then
         ln_total := (ln_final_total - ln_initial_total) + ln_total;
        Else
         ln_total := Ln_total + ln_final_total;
        end if;
         gn_total := ln_total;
     end loop;
    Gn_total := nvl(gn_total,0);
  END;

-- ##############################################################
PROCEDURE PU_ACCOUNT_DESCRIPTION (GV_LEVEL1 VARCHAR2, GV_LEVEL2 VARCHAR2,
                              GV_LEVEL3 VARCHAR2, GV_LEVEL4 VARCHAR2,
                              GV_LEVEL5 VARCHAR2, GV_LEVEL6 VARCHAR2,
                              GV_LEVEL7 VARCHAR2, GV_LEVEL8 VARCHAR2,
                              GV_DESCRIPTION  OUT VARCHAR2 )IS
BEGIN
select DESCRIPTION into Gv_description  
  from GM_ACCOUNT_BALANCE
  where LEVEL_1  =  Gv_level1  and
        LEVEL_2  =  Gv_level2  and
	LEVEL_3  =  Gv_level3  and
	LEVEL_4  =  Gv_level4  and
	LEVEL_5  =  Gv_level5  and
	LEVEL_6  =  Gv_level6  and
	LEVEL_7  =  Gv_level7  and
	LEVEL_8  =  Gv_level8  and
  COMPANY_CODE =  COMPANY_CODE;      
exception
  when no_data_found then
       Gv_description := 'Error: Account Does Not Exist';
END;

-- ##############################################################
-- PU_P_CALCULATE_MONTH_BALANCES
PROCEDURE PU_P_CALCULATE_MONTH_BALANCES (
    p_amount_type   VARCHAR2,
    p_amount_month_01 IN OUT NUMBER,
    p_amount_month_02 IN OUT NUMBER,
    p_amount_month_03 IN OUT NUMBER,
    p_amount_month_04 IN OUT NUMBER,
    p_amount_month_05 IN OUT NUMBER,
    p_amount_month_06 IN OUT NUMBER,
    p_amount_month_07 IN OUT NUMBER,
    p_amount_month_08 IN OUT NUMBER,
    p_amount_month_09 IN OUT NUMBER,
    p_amount_month_10 IN OUT NUMBER,
    p_amount_month_11 IN OUT NUMBER,
    p_amount_month_12 IN OUT NUMBER
)
IS
  ln_calculation           NUMBER(16,2) := 0;
  ln_month                 NUMBER(2);
  ln_year                  NUMBER(4);
  ln_day                   NUMBER(2);
  ln_end_month             NUMBER(2);
  ln_end_year              NUMBER(4);
  ln_end_day               NUMBER(2);
  ln_prev_month            NUMBER(2);
  ln_prev_day              NUMBER(2);
  ln_prev_year             NUMBER(4);
  ln_branch                NUMBER(4);

  ld_start_date             DATE;
  ld_end_date               DATE;
  ld_previous_month         DATE;
  ld_previous_month_calc    DATE;

  ln_total                  NUMBER := 0;
  lv_has_movements          VARCHAR2(1);
  lv_column                 VARCHAR2(16);

BEGIN

    ln_branch := NVL(P_BRANCH, 0);
    IF ln_branch = 0 THEN
        ln_branch := NULL;
    END IF;

    IF Q_REPORT_DETAIL.DETAIL_TYPE = 'D' THEN
        lv_has_movements := 'Y';
    ELSE
        lv_has_movements := 'N';
    END IF;

    -- JANUARY
        ld_start_date := TO_DATE('01' || '01' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_day = 1 THEN
            ln_month := ln_month - 1;
        END IF;

        IF ln_year <> ln_end_year OR
            TO_NUMBER(TO_CHAR(P_END_DATE, 'MM')) =
            TO_NUMBER(TO_CHAR(P_FIRST_BUSINESS_WEEK, 'MM'))
        THEN
            ln_year := 1900;
        END IF;

        IF ln_end_year = P_FISCAL_YEAR
            AND ln_end_month >= P_FISCAL_MONTH
        THEN
            RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            p_amount_month_01
        );

    -- February
        ld_start_date := TO_DATE('01' || '02' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);
        ln_day        := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month      := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year       := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));
        ln_end_day    := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month  := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year   := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
            AND ln_end_month >= P_FISCAL_MONTH
        THEN
            RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            p_amount_month_02
        );

    -- March
        ld_start_date := TO_DATE('01' || '03' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_03
        );

    -- April
        ld_start_date := TO_DATE('01' || '04' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_04
        );

    -- May
        ld_start_date := TO_DATE('01' || '05' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_05
        );

    -- June
        ld_start_date := TO_DATE('01' || '06' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_06
        );

    -- July
        ld_start_date := TO_DATE('01' || '07' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_07
        );

    -- August
        ld_start_date := TO_DATE('01' || '08' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_MONTH
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_08
        );

    -- September
        ld_start_date := TO_DATE('01' || '09' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
           Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_09
        );

    -- October
        ld_start_date := TO_DATE('01' || '10' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_10
        );

    -- November
        ld_start_date := TO_DATE('01' || '11' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_11
        );

    -- December
        ld_start_date := TO_DATE('01' || '12' || TO_CHAR(P_YEAR), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = P_FISCAL_YEAR
        AND ln_end_month >= P_FISCAL_MONTH
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_2_INICIAL,
            Q_REPORT_DETAIL.NIVEL_3_INICIAL,
            Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA,
            Q_REPORT_DETAIL.NIVEL_5_INICIAL,
            Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL,
            Q_REPORT_DETAIL.NIVEL_7_CTA_INICIAL,
            Q_REPORT_DETAIL.NIVEL_8_INICIAL,
            Q_REPORT_DETAIL.FINAL_LEVEL_1,
            Q_REPORT_DETAIL.FINAL_LEVEL_2,
            Q_REPORT_DETAIL.FINAL_LEVEL_3,
            Q_REPORT_DETAIL.FINAL_LEVEL_4,
            Q_REPORT_DETAIL.FINAL_LEVEL_5,
            Q_REPORT_DETAIL.FINAL_LEVEL_6,
            Q_REPORT_DETAIL.FINAL_LEVEL_7,
            Q_REPORT_DETAIL.FINAL_LEVEL_8,
            ln_branch,
            ln_day,
            ln_month,
            ln_year,
            ln_end_day,
            ln_end_month,
            ln_end_year,
            amount_month_12
        );

END;