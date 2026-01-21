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
    A.COMPANY_CODE = :P_COMPANY_CODE
    and A.REPORT_CODE = :P_REPORT_CODE
order by
    COMPANY_CODE,
    REPORT_CODE,
    RW;


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
PROCEDURE PU_P_CALCULATE_MONTH_COLUMNS
IS
  ln_calculation          NUMBER(16,2) := 0;
  ln_month                NUMBER(2);
  ln_year                 NUMBER(4);
  ln_day                  NUMBER(2);
  ln_end_month            NUMBER(2);
  ln_end_year             NUMBER(4);
  ln_end_day              NUMBER(2);
  ln_prev_month           NUMBER(2);
  ln_prev_day             NUMBER(2);
  ln_prev_year            NUMBER(4);
  ln_branch               NUMBER(4);

  ln_amount_month_01      NUMBER(16,2);
  ln_amount_month_02      NUMBER(16,2);
  ln_amount_month_03      NUMBER(16,2);
  ln_amount_month_04      NUMBER(16,2);
  ln_amount_month_05      NUMBER(16,2);
  ln_amount_month_06      NUMBER(16,2);
  ln_amount_month_07      NUMBER(16,2);
  ln_amount_month_08      NUMBER(16,2);
  ln_amount_month_09      NUMBER(16,2);
  ln_amount_month_10      NUMBER(16,2);
  ln_amount_month_11      NUMBER(16,2);
  ln_amount_month_12      NUMBER(16,2);

  ld_prev_month            DATE;
  ld_prev_month_calc       DATE;

  ln_total                 NUMBER := 0;
  lv_has_movements         VARCHAR2(1);
  lv_column                VARCHAR2(16);
BEGIN

  ln_amount_month_01 := 0; ln_amount_month_02 := 0;
  ln_amount_month_03 := 0; ln_amount_month_04 := 0;
  ln_amount_month_05 := 0; ln_amount_month_06 := 0;
  ln_amount_month_07 := 0; ln_amount_month_08 := 0;
  ln_amount_month_09 := 0; ln_amount_month_10 := 0;
  ln_amount_month_11 := 0; ln_amount_month_12 := 0;

  out_col_month_01  := ' ';
  out_col_month_02  := ' ';
  out_col_month_03  := ' ';
  out_col_month_04  := ' ';
  out_col_month_05  := ' ';
  out_col_month_06  := ' ';
  out_col_month_07  := ' ';
  out_col_month_08  := ' ';
  out_col_month_09  := ' ';
  out_col_month_10  := ' ';
  out_col_month_11  := ' ';
  out_col_month_12  := ' ';
  out_col_total     := ' ';

IF Q_REPORT_DETAIL.NIVEL_1_INICIAL_CTA IS NOT NULL OR
   Q_REPORT_DETAIL.NIVEL_2_INICIAL     IS NOT NULL OR
   Q_REPORT_DETAIL.NIVEL_3_INICIAL     IS NOT NULL OR
   Q_REPORT_DETAIL.NIVEL_4_INICIAL_CTA IS NOT NULL OR
   Q_REPORT_DETAIL.NIVEL_5_INICIAL     IS NOT NULL OR
   Q_REPORT_DETAIL.CTA_LEVEL_6_INITIAL IS NOT NULL OR
   Q_REPORT_DETAIL.VEL_7_CTA_INICIAL   IS NOT NULL OR
   Q_REPORT_DETAIL.NIVEL_8_INICIAL     IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_1       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_2       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_3       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_4       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_5       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_6       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_7       IS NOT NULL OR
   Q_REPORT_DETAIL.FINAL_LEVEL_8       IS NOT NULL
THEN


    PU_P_CALCULATE_MONTH_BALANCES(
        P_BALANCE_TYPE,
        ln_amount_month_01,
        ln_amount_month_02,
        ln_amount_month_03,
        ln_amount_month_04,
        ln_amount_month_05,
        ln_amount_month_06,
        ln_amount_month_07,
        ln_amount_month_08,
        ln_amount_month_09,
        ln_amount_month_10,
        ln_amount_month_11,
        ln_amount_month_12
    );
  END IF;

    IF acc_start_lvl_1 IS NULL OR
        acc_start_lvl_2 IS NULL OR
        acc_start_lvl_3 IS NULL OR
        acc_start_lvl_4 IS NULL
    THEN

    IF :underline IN ('-') THEN

        out_col_month_01  := LPAD(out_col_month_01, 50, CHR(95)); -- '_______________'
        out_col_month_02  := LPAD(out_col_month_02, 50, CHR(95));
        out_col_month_03  := LPAD(out_col_month_03, 50, CHR(95));
        out_col_month_04  := LPAD(out_col_month_04, 50, CHR(95));
        out_col_month_05  := LPAD(out_col_month_05, 50, CHR(95));
        out_col_month_06  := LPAD(out_col_month_06, 50, CHR(95));
        out_col_month_07  := LPAD(out_col_month_07, 50, CHR(95));
        out_col_month_08  := LPAD(out_col_month_08, 50, CHR(95));
        out_col_month_09  := LPAD(out_col_month_09, 50, CHR(95));
        out_col_month_10  := LPAD(out_col_month_10, 50, CHR(95));
        out_col_month_11  := LPAD(out_col_month_11, 50, CHR(95));
        out_col_month_12  := LPAD(out_col_month_12, 50, CHR(95));
        out_col_total     := LPAD(out_col_total,    50, CHR(95));

    ELSIF :underline IN ('=') THEN

        out_col_month_01  := LPAD(out_col_month_01, 50, CHR(61)); -- '==============='
        out_col_month_02  := LPAD(out_col_month_02, 50, CHR(61));
        out_col_month_03  := LPAD(out_col_month_03, 50, CHR(61));
        out_col_month_04  := LPAD(out_col_month_04, 50, CHR(61));
        out_col_month_05  := LPAD(out_col_month_05, 50, CHR(61));
        out_col_month_06  := LPAD(out_col_month_06, 50, CHR(61));
        out_col_month_07  := LPAD(out_col_month_07, 50, CHR(61));
        out_col_month_08  := LPAD(out_col_month_08, 50, CHR(61));
        out_col_month_09  := LPAD(out_col_month_09, 50, CHR(61));
        out_col_month_10  := LPAD(out_col_month_10, 50, CHR(61));
        out_col_month_11  := LPAD(out_col_month_11, 50, CHR(61));
        out_col_month_12  := LPAD(out_col_month_12, 50, CHR(61));
        out_col_total     := LPAD(out_col_total,    50, CHR(61));

    ELSIF :print_subtotal = 'S' THEN

        out_col_month_01 := TO_CHAR(sub_month_01, '999,999,999,990.00');
        out_col_month_02 := TO_CHAR(sub_month_02, '999,999,999,990.00');
        out_col_month_03 := TO_CHAR(sub_month_03, '999,999,999,990.00');
        out_col_month_04 := TO_CHAR(sub_month_04, '999,999,999,990.00');
        out_col_month_05 := TO_CHAR(sub_month_05, '999,999,999,990.00');
        out_col_month_06 := TO_CHAR(sub_month_06, '999,999,999,990.00');
        out_col_month_07 := TO_CHAR(sub_month_07, '999,999,999,990.00');
        out_col_month_08 := TO_CHAR(sub_month_08, '999,999,999,990.00');
        out_col_month_09 := TO_CHAR(sub_month_09, '999,999,999,990.00');
        out_col_month_10 := TO_CHAR(sub_month_10, '999,999,999,990.00');
        out_col_month_11 := TO_CHAR(sub_month_11, '999,999,999,990.00');
        out_col_month_12 := TO_CHAR(sub_month_12, '999,999,999,990.00');

        ln_calculation := PU_F_CALCULATE_MONTH_TOTAL(
                                P_BALANCE_TYPE,
                                sub_month_01,
                                sub_month_02,
                                sub_month_03,
                                sub_month_04,
                                sub_month_05,
                                sub_month_06,
                                sub_month_07,
                                sub_month_08,
                                sub_month_09,
                                sub_month_10,
                                sub_month_11,
                                sub_month_12
                            );

        out_col_total := TO_CHAR(ln_calculation, '999,999,990.00');

        sub_month_01 := 0;   sub_month_02 := 0;
        sub_month_03 := 0;   sub_month_04 := 0;
        sub_month_05 := 0;   sub_month_06 := 0;
        sub_month_07 := 0;   sub_month_08 := 0;
        sub_month_09 := 0;   sub_month_10 := 0;
        sub_month_11 := 0;   sub_month_12 := 0;
    
    ELSIF :print_subtotal_detail = 'S' THEN

        out_col_month_01 := TO_CHAR(detail_total_month_01, '999,999,999,990.00');
        out_col_month_02 := TO_CHAR(detail_total_month_02, '999,999,999,990.00');
        out_col_month_03 := TO_CHAR(detail_total_month_03, '999,999,999,990.00');
        out_col_month_04 := TO_CHAR(detail_total_month_04, '999,999,999,990.00');
        out_col_month_05 := TO_CHAR(detail_total_month_05, '999,999,999,990.00');
        out_col_month_06 := TO_CHAR(detail_total_month_06, '999,999,999,990.00');
        out_col_month_07 := TO_CHAR(detail_total_month_07, '999,999,999,990.00');
        out_col_month_08 := TO_CHAR(detail_total_month_08, '999,999,999,990.00');
        out_col_month_09 := TO_CHAR(detail_total_month_09, '999,999,999,990.00');
        out_col_month_10 := TO_CHAR(detail_total_month_10, '999,999,999,990.00');
        out_col_month_11 := TO_CHAR(detail_total_month_11, '999,999,999,990.00');
        out_col_month_12 := TO_CHAR(detail_total_month_12, '999,999,999,990.00');

        detail_total_month_01 := 0;   detail_total_month_02 := 0;
        detail_total_month_03 := 0;   detail_total_month_04 := 0;
        detail_total_month_05 := 0;   detail_total_month_06 := 0;
        detail_total_month_07 := 0;   detail_total_month_08 := 0;
        detail_total_month_09 := 0;   detail_total_month_10 := 0;
        detail_total_month_11 := 0;   detail_total_month_12 := 0;

        ln_calculation := PU_F_CALCULATE_MONTH_TOTAL(
                                P_BALANCE_TYPE,
                                total_month_01,
                                total_month_02,
                                total_month_03,
                                total_month_04,
                                total_month_05,
                                total_month_06,
                                total_month_07,
                                total_month_08,
                                total_month_09,
                                total_month_10,
                                total_month_11,
                                total_month_12
                            );

        :out_col_total := TO_CHAR(ln_calculation, '999,999,990.00');

    ELSIF :print_total = 'S' THEN

        out_col_month_01 := TO_CHAR(total_month_01, '999,999,999,990.00');
        out_col_month_02 := TO_CHAR(total_month_02, '999,999,999,990.00');
        out_col_month_03 := TO_CHAR(total_month_03, '999,999,999,990.00');
        out_col_month_04 := TO_CHAR(total_month_04, '999,999,999,990.00');
        out_col_month_05 := TO_CHAR(total_month_05, '999,999,999,990.00');
        out_col_month_06 := TO_CHAR(total_month_06, '999,999,999,990.00');
        out_col_month_07 := TO_CHAR(total_month_07, '999,999,999,990.00');
        out_col_month_08 := TO_CHAR(total_month_08, '999,999,999,990.00');
        out_col_month_09 := TO_CHAR(total_month_09, '999,999,999,990.00');
        out_col_month_10 := TO_CHAR(total_month_10, '999,999,999,990.00');
        out_col_month_11 := TO_CHAR(total_month_11, '999,999,999,990.00');
        out_col_month_12 := TO_CHAR(total_month_12, '999,999,999,990.00');

        ln_calculation := PU_F_CALCULATE_MONTH_TOTAL(
                                P_BALANCE_TYPE,
                                total_month_01,
                                total_month_02,
                                total_month_03,
                                total_month_04,
                                total_month_05,
                                total_month_06,
                                total_month_07,
                                total_month_08,
                                total_month_09,
                                total_month_10,
                                total_month_11,
                                total_month_12
                            );

        out_col_total := TO_CHAR(ln_calculation, '999,999,990.00');

    END IF;

  ELSE
    sub_month_01 := sub_month_01 + ln_amount_month_01;
    sub_month_02 := sub_month_02 + ln_amount_month_02;
    sub_month_03 := sub_month_03 + ln_amount_month_03;
    sub_month_04 := sub_month_04 + ln_amount_month_04;
    sub_month_05 := sub_month_05 + ln_amount_month_05;
    sub_month_06 := sub_month_06 + ln_amount_month_06;
    sub_month_07 := sub_month_07 + ln_amount_month_07;
    sub_month_08 := sub_month_08 + ln_amount_month_08;
    sub_month_09 := sub_month_09 + ln_amount_month_09;
    sub_month_10 := sub_month_10 + ln_amount_month_10;
    sub_month_11 := sub_month_11 + ln_amount_month_11;
    sub_month_12 := sub_month_12 + ln_amount_month_12;

    detail_total_month_01 := detail_total_month_01 + ln_amount_month_01;
    detail_total_month_02 := detail_total_month_02 + ln_amount_month_02;
    detail_total_month_03 := detail_total_month_03 + ln_amount_month_03;
    detail_total_month_04 := detail_total_month_04 + ln_amount_month_04;
    detail_total_month_05 := detail_total_month_05 + ln_amount_month_05;
    detail_total_month_06 := detail_total_month_06 + ln_amount_month_06;
    detail_total_month_07 := detail_total_month_07 + ln_amount_month_07;
    detail_total_month_08 := detail_total_month_08 + ln_amount_month_08;
    detail_total_month_09 := detail_total_month_09 + ln_amount_month_09;
    detail_total_month_10 := detail_total_month_10 + ln_amount_month_10;
    detail_total_month_11 := detail_total_month_11 + ln_amount_month_11;
    detail_total_month_12 := detail_total_month_12 + ln_amount_month_12;

    IF SUBSTR(:acc_start_lvl_1, 1, 1) = '5' THEN

        total_month_01 := total_month_01 + ln_amount_month_01;
        total_month_02 := total_month_02 + ln_amount_month_02;
        total_month_03 := total_month_03 + ln_amount_month_03;
        total_month_04 := total_month_04 + ln_amount_month_04;
        total_month_05 := total_month_05 + ln_amount_month_05;
        total_month_06 := total_month_06 + ln_amount_month_06;
        total_month_07 := total_month_07 + ln_amount_month_07;
        total_month_08 := total_month_08 + ln_amount_month_08;
        total_month_09 := total_month_09 + ln_amount_month_09;
        total_month_10 := total_month_10 + ln_amount_month_10;
        total_month_11 := total_month_11 + ln_amount_month_11;
        total_month_12 := total_month_12 + ln_amount_month_12;

    END IF;

    IF SUBSTR(:acc_start_lvl_1, 1, 1) = '4' THEN

        total_month_01 := total_month_01 - ln_amount_month_01;
        total_month_02 := total_month_02 - ln_amount_month_02;
        total_month_03 := total_month_03 - ln_amount_month_03;
        total_month_04 := total_month_04 - ln_amount_month_04;
        total_month_05 := total_month_05 - ln_amount_month_05;
        total_month_06 := total_month_06 - ln_amount_month_06;
        total_month_07 := total_month_07 - ln_amount_month_07;
        total_month_08 := total_month_08 - ln_amount_month_08;
        total_month_09 := total_month_09 - ln_amount_month_09;
        total_month_10 := total_month_10 - ln_amount_month_10;
        total_month_11 := total_month_11 - ln_amount_month_11;
        total_month_12 := total_month_12 - ln_amount_month_12;

    END IF;

    out_col_month_01 := TO_CHAR(ln_amount_month_01, '999,999,999,990.00');
    out_col_month_02 := TO_CHAR(ln_amount_month_02, '999,999,999,990.00');
    out_col_month_03 := TO_CHAR(ln_amount_month_03, '999,999,999,990.00');
    out_col_month_04 := TO_CHAR(ln_amount_month_04, '999,999,999,990.00');
    out_col_month_05 := TO_CHAR(ln_amount_month_05, '999,999,999,990.00');
    out_col_month_06 := TO_CHAR(ln_amount_month_06, '999,999,999,990.00');
    out_col_month_07 := TO_CHAR(ln_amount_month_07, '999,999,999,990.00');
    out_col_month_08 := TO_CHAR(ln_amount_month_08, '999,999,999,990.00');
    out_col_month_09 := TO_CHAR(ln_amount_month_09, '999,999,999,990.00');
    out_col_month_10 := TO_CHAR(ln_amount_month_10, '999,999,999,990.00');
    out_col_month_11 := TO_CHAR(ln_amount_month_11, '999,999,999,990.00');
    out_col_month_12 := TO_CHAR(ln_amount_month_12, '999,999,999,990.00');

    ln_calculation := PU_F_CALCULATE_MONTH_TOTAL(
                        :P_BALANCE_TYPE,
                        ln_amount_month_01,
                        ln_amount_month_02,
                        ln_amount_month_03,
                        ln_amount_month_04,
                        ln_amount_month_05,
                        ln_amount_month_06,
                        ln_amount_month_07,
                        ln_amount_month_08,
                        ln_amount_month_09,
                        ln_amount_month_10,
                        ln_amount_month_11,
                        ln_amount_month_12
                    );

    :out_col_total := TO_CHAR(ln_calculation, '999,999,999,990.00');

  END IF;

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

    ln_branch := NVL(:P_BRANCH, 0);
    IF ln_branch = 0 THEN
        ln_branch := NULL;
    END IF;

    IF :detail_type = 'D' THEN
        lv_has_movements := 'Y';
    ELSE
        lv_has_movements := 'N';
    END IF;

    -- JANUARY
        ld_start_date := TO_DATE('01' || '01' || TO_CHAR(:p_year), 'DDMMYYYY');
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
            TO_NUMBER(TO_CHAR(:p_end_date, 'MM')) =
            TO_NUMBER(TO_CHAR(:p_first_business_week, 'MM'))
        THEN
            ln_year := 1900;
        END IF;

        IF ln_end_year = :p_fiscal_year
            AND ln_end_month >= :p_fiscal_month
        THEN
            RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '02' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);
        ln_day        := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month      := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year       := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));
        ln_end_day    := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month  := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year   := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
            AND ln_end_month >= :p_fiscal_month
        THEN
            RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '03' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '04' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '05' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '06' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '07' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '08' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '09' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '10' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '11' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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
        ld_start_date := TO_DATE('01' || '12' || TO_CHAR(:p_year), 'DDMMYYYY');
        ld_end_date   := LAST_DAY(ld_start_date);

        ln_day   := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'DD'));
        ln_month := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'MM'));
        ln_year  := TO_NUMBER(TO_CHAR(ld_start_date - 1, 'YYYY'));

        ln_end_day   := TO_NUMBER(TO_CHAR(ld_end_date, 'DD'));
        ln_end_month := TO_NUMBER(TO_CHAR(ld_end_date, 'MM'));
        ln_end_year  := TO_NUMBER(TO_CHAR(ld_end_date, 'YYYY'));

        IF ln_end_year = :p_fiscal_year
        AND ln_end_month >= :p_fiscal_month
        THEN
        RETURN;
        END IF;

        pu_calculate_balance(
            lv_has_movements,
            acc_start_lvl_1,
            acc_start_lvl_2,
            acc_start_lvl_3,
            acc_start_lvl_4,
            acc_start_lvl_5,
            acc_start_lvl_6,
            acc_start_lvl_7,
            acc_start_lvl_8,
            acc_end_lvl_1,
            acc_end_lvl_2,
            acc_end_lvl_3,
            acc_end_lvl_4,
            acc_end_lvl_5,
            acc_end_lvl_6,
            acc_end_lvl_7,
            acc_end_lvl_8,
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


-- ##############################################################

-- PU_F_CALCULATE_MONTH_TOTAL
FUNCTION PU_F_CALCULATE_MONTH_TOTAL (
    p_balance_type   VARCHAR2,
    amount_month_01  IN OUT NUMBER,
    amount_month_02  IN OUT NUMBER,
    amount_month_03  IN OUT NUMBER,
    amount_month_04  IN OUT NUMBER,
    amount_month_05  IN OUT NUMBER,
    amount_month_06  IN OUT NUMBER,
    amount_month_07  IN OUT NUMBER,
    amount_month_08  IN OUT NUMBER,
    amount_month_09  IN OUT NUMBER,
    amount_month_10  IN OUT NUMBER,
    amount_month_11  IN OUT NUMBER,
    amount_month_12  IN OUT NUMBER
)
RETURN NUMBER
IS
  ln_calculation   NUMBER(16,2) := 0;
  ln_month         NUMBER(2);
  ln_year          NUMBER(4);
  ln_day           NUMBER(2);
BEGIN

  IF :p_year = :p_fiscal_year THEN
     IF :p_fiscal_month <> 1 THEN
        ln_month := :p_fiscal_month - 1;
     ELSE
        ln_month := 1;
     END IF;
  ELSE
     ln_month := 12;
  END IF;

  ln_calculation :=
        amount_month_01 + amount_month_02 + amount_month_03 +
        amount_month_04 + amount_month_05 + amount_month_06 +
        amount_month_07 + amount_month_08 + amount_month_09 +
        amount_month_10 + amount_month_11 + amount_month_12;

  IF p_balance_type <> '1' THEN
     ln_calculation := ln_calculation / ln_month;
  END IF;

  RETURN ln_calculation;
END;

-- ###################################################

PROCEDURE pu_calculate_balance (
    gv_has_movement      VARCHAR2,
    gv_start_lvl_1       VARCHAR2, gv_start_lvl_2 VARCHAR2,
    gv_start_lvl_3       VARCHAR2, gv_start_lvl_4 VARCHAR2,
    gv_start_lvl_5       VARCHAR2, gv_start_lvl_6 VARCHAR2,
    gv_start_lvl_7       VARCHAR2, gv_start_lvl_8 VARCHAR2,
    gv_end_lvl_1         VARCHAR2, gv_end_lvl_2   VARCHAR2,
    gv_end_lvl_3         VARCHAR2, gv_end_lvl_4   VARCHAR2,
    gv_end_lvl_5         VARCHAR2, gv_end_lvl_6   VARCHAR2,
    gv_end_lvl_7         VARCHAR2, gv_end_lvl_8   VARCHAR2,
    gn_branch            NUMBER,
    gn_day               NUMBER,
    gn_month             NUMBER,
    gn_year              NUMBER,
    gn_end_day           NUMBER,
    gn_end_month         NUMBER,
    gn_end_year          NUMBER,
    gn_total             OUT NUMBER
) IS

  ln_start_total  NUMBER(14,2) := 0;
  ln_end_total    NUMBER(14,2) := 0;
  ln_total        NUMBER(14,2) := 0;

  /* Cursor to split daily balances */
  CURSOR c_balances IS
      SELECT
          MONTH, DAY_1_BALANCE,DAY_2_BALANCE,DAY_3_BALANCE,DAY_4_BALANCE,DAY_5_BALANCE,DAY_6_BALANCE,
             DAY_7_BALANCE,DAY_8_BALANCE,DAY_9_BALANCE,DAY_10_BALANCE,DAY_11_BALANCE,DAY_12_BALANCE,
             DAY_13_BALANCE,DAY_14_BALANCE,DAY_15_BALANCE,DAY_16_BALANCE,DAY_17_BALANCE,DAY_18_BALANCE,
             DAY_19_BALANCE,DAY_20_BALANCE,DAY_21_BALANCE,DAY_22_BALANCE,DAY_23_BALANCE,DAY_24_BALANCE,
             DAY_25_BALANCE,DAY_26_BALANCE,DAY_27_BALANCE,DAY_28_BALANCE,DAY_29_BALANCE,DAY_30_BALANCE,DAY_31_BALANCE
      FROM GM_BALANCES_DAILY a,
           GM_ACCOUNT_BALANCE b
      WHERE (
              (year = gn_year AND month = gn_month)
           OR (year = gn_end_year AND month = gn_end_month)
            )
        AND a.level_1 || a.level_2 || a.level_3 || a.level_4 ||
            a.level_5 || a.level_6 || a.level_7 || a.level_8
            BETWEEN
            gv_start_lvl_1 || gv_start_lvl_2 || gv_start_lvl_3 || gv_start_lvl_4 ||
            gv_start_lvl_5 || gv_start_lvl_6 || gv_start_lvl_7 || gv_start_lvl_8
            AND
            gv_end_lvl_1 || gv_end_lvl_2 || gv_end_lvl_3 || gv_end_lvl_4 ||
            gv_end_lvl_5 || gv_end_lvl_6 || gv_end_lvl_7 || gv_end_lvl_8
        AND a.level_1 || a.level_2 || a.level_3 || a.level_4 ||
            a.level_5 || a.level_6 || a.level_7 || a.level_8 = b.account
        AND B.TXN_ENTRY_RECEIVED = GV_RECIBE_MOV
        AND a.company_code    = b.company_code
        AND To_Number(a.level_5) = Nvl(Gn_Branch,To_Number(a.level_5))
      ORDER BY
          year,
          month,
          a.level_1||a.level_2||a.level_3||a.level_4||a.level_5||a.level_6||a.level_7||a.level_8;

BEGIN

  FOR balance_rec IN c_balances LOOP

      ln_start_total := 0;
      ln_end_total   := 0;

      IF balance_rec.month = gn_month THEN
         IF gn_day = 1 THEN ln_start_total := balance_rec.balance_day_1;
         ELSIF gn_day = 2 THEN ln_start_total := balance_rec.balance_day_2;
         ELSIF gn_day = 3 THEN ln_start_total := balance_rec.balance_day_3;
         ELSIF gn_day = 4 THEN ln_start_total := balance_rec.balance_day_4;
         ELSIF gn_day = 5 THEN ln_start_total := balance_rec.balance_day_5;
         ELSIF gn_day = 6 THEN ln_start_total := balance_rec.balance_day_6;
         ELSIF gn_day = 7 THEN ln_start_total := balance_rec.balance_day_7;
         ELSIF gn_day = 8 THEN ln_start_total := balance_rec.balance_day_8;
         ELSIF gn_day = 9 THEN ln_start_total := balance_rec.balance_day_9;
         ELSIF gn_day = 10 THEN ln_start_total := balance_rec.balance_day_10;
         ELSIF gn_day = 11 THEN ln_start_total := balance_rec.balance_day_11;
         ELSIF gn_day = 12 THEN ln_start_total := balance_rec.balance_day_12;
         ELSIF gn_day = 13 THEN ln_start_total := balance_rec.balance_day_13;
         ELSIF gn_day = 14 THEN ln_start_total := balance_rec.balance_day_14;
         ELSIF gn_day = 15 THEN ln_start_total := balance_rec.balance_day_15;
         ELSIF gn_day = 16 THEN ln_start_total := balance_rec.balance_day_16;
         ELSIF gn_day = 17 THEN ln_start_total := balance_rec.balance_day_17;
         ELSIF gn_day = 18 THEN ln_start_total := balance_rec.balance_day_18;
         ELSIF gn_day = 19 THEN ln_start_total := balance_rec.balance_day_19;
         ELSIF gn_day = 20 THEN ln_start_total := balance_rec.balance_day_20;
         ELSIF gn_day = 21 THEN ln_start_total := balance_rec.balance_day_21;
         ELSIF gn_day = 22 THEN ln_start_total := balance_rec.balance_day_22;
         ELSIF gn_day = 23 THEN ln_start_total := balance_rec.balance_day_23;
         ELSIF gn_day = 24 THEN ln_start_total := balance_rec.balance_day_24;
         ELSIF gn_day = 25 THEN ln_start_total := balance_rec.balance_day_25;
         ELSIF gn_day = 26 THEN ln_start_total := balance_rec.balance_day_26;
         ELSIF gn_day = 27 THEN ln_start_total := balance_rec.balance_day_27;
         ELSIF gn_day = 28 THEN ln_start_total := balance_rec.balance_day_28;
         ELSIF gn_day = 29 THEN ln_start_total := balance_rec.balance_day_29;
         ELSIF gn_day = 30 THEN ln_start_total := balance_rec.balance_day_30;
         ELSE ln_start_total := balance_rec.balance_day_31;
         END IF;
      END IF;

      IF balance_rec.month = gn_end_month THEN
         IF gn_end_day = 1 THEN ln_end_total := balance_rec.balance_day_1;
         ELSIF gn_end_day = 2 THEN ln_end_total := balance_rec.balance_day_2;
         ELSIF gn_end_day = 3 THEN ln_end_total := balance_rec.balance_day_3;
         ELSIF gn_end_day = 4 THEN ln_end_total := balance_rec.balance_day_4;
         ELSIF gn_end_day = 5 THEN ln_end_total := balance_rec.balance_day_5;
         ELSIF gn_end_day = 6 THEN ln_end_total := balance_rec.balance_day_6;
         ELSIF gn_end_day = 7 THEN ln_end_total := balance_rec.balance_day_7;
         ELSIF gn_end_day = 8 THEN ln_end_total := balance_rec.balance_day_8;
         ELSIF gn_end_day = 9 THEN ln_end_total := balance_rec.balance_day_9;
         ELSIF gn_end_day = 10 THEN ln_end_total := balance_rec.balance_day_10;
         ELSIF gn_end_day = 11 THEN ln_end_total := balance_rec.balance_day_11;
         ELSIF gn_end_day = 12 THEN ln_end_total := balance_rec.balance_day_12;
         ELSIF gn_end_day = 13 THEN ln_end_total := balance_rec.balance_day_13;
         ELSIF gn_end_day = 14 THEN ln_end_total := balance_rec.balance_day_14;
         ELSIF gn_end_day = 15 THEN ln_end_total := balance_rec.balance_day_15;
         ELSIF gn_end_day = 16 THEN ln_end_total := balance_rec.balance_day_16;
         ELSIF gn_end_day = 17 THEN ln_end_total := balance_rec.balance_day_17;
         ELSIF gn_end_day = 18 THEN ln_end_total := balance_rec.balance_day_18;
         ELSIF gn_end_day = 19 THEN ln_end_total := balance_rec.balance_day_19;
         ELSIF gn_end_day = 20 THEN ln_end_total := balance_rec.balance_day_20;
         ELSIF gn_end_day = 21 THEN ln_end_total := balance_rec.balance_day_21;
         ELSIF gn_end_day = 22 THEN ln_end_total := balance_rec.balance_day_22;
         ELSIF gn_end_day = 23 THEN ln_end_total := balance_rec.balance_day_23;
         ELSIF gn_end_day = 24 THEN ln_end_total := balance_rec.balance_day_24;
         ELSIF gn_end_day = 25 THEN ln_end_total := balance_rec.balance_day_25;
         ELSIF gn_end_day = 26 THEN ln_end_total := balance_rec.balance_day_26;
         ELSIF gn_end_day = 27 THEN ln_end_total := balance_rec.balance_day_27;
         ELSIF gn_end_day = 28 THEN ln_end_total := balance_rec.balance_day_28;
         ELSIF gn_end_day = 29 THEN ln_end_total := balance_rec.balance_day_29;
         ELSIF gn_end_day = 30 THEN ln_end_total := balance_rec.balance_day_30;
         ELSE ln_end_total := balance_rec.balance_day_31;
         END IF;
      END IF;

      IF :p_balance_type = 1 THEN
         ln_total := (ln_end_total - ln_start_total) + ln_total;
      ELSE
         ln_total := ln_total + ln_end_total;
      END IF;

      gn_total := ln_total;

  END LOOP;

  gn_total := NVL(gn_total, 0);

END;
