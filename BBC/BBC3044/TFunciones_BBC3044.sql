/*
==========ENCABEZADO DE REPORTES BBC3044=================
    1(CF): ENCABEZADO.CG$C_USER
    2(CF): ENCABEZADO.CF_COMPANY_NAME
    3(ID?): ENCABEZADO.F_NOMBREREPORTE?
    4(F?): ENCABEZADO.F_FECHA_SISTEMA? Origen: Fecha Actual?
    5(FC): ENCABEZADO.CF_today_date

==========CUERPO DE REPORTES BBC3044===================
    1(BD): Q_Cuentas.username
    2(BD): Q_Cuentas.unit_code
    3(BD): Q_Cuentas.numero_movimiento
    4(BD): Q_Cuentas.fecha_valida
    5(BD): Q_Cuentas.fecha_movimiento
    6(BD): Q_Cuentas.desc_enc
    7(?): B_14 (Agencia)
    8(BD): Q_Cuentas.codigo_agencia
    9(?): F_1
    10(?): F_depto
    21(BD): Q_Cuentas.secuencia_renglon
    22(CF): Q_Cuentas.CF_Display
    23(CF): Q_Cuentas.CF_display_concept
    37(CF): Q_Cuentas.CF_account_description
    40(CF): Q_Cuentas.CF_difference
    47(CF): CF_total_difference
    48(CF): CF_total_difference2
    49(CF): G_SUCURSAL.CF_branch_description
    52 (CF): G_SUCURSAL.CF_branch_diff
*/


-- Encabezado Reporte:
    -- 1 (CF): CG$C_USER
        function CG$C_USER return VARCHAR2 is
        begin
            return(:P_USER_REP);
        end;

    -- 2 (CF): F_COMPANY_NAME
        function CF_COMPANY_NAME return VARCHAR2 is
            lv_company VARCHAR2(30);
        begin
            SELECT NAME
            INTO   lv_company
            FROM   MG_COMPANIES
            WHERE  COMPANY_CODE = :P_COMPANY_CODE;
            RETURN(lv_company);
        EXCEPTION WHEN OTHERS THEN
            RETURN NULL;
        end;

    -- 3 (ID?): F_NOMBREREPORTE
        
    -- 4 (F?): F_FECHA_SISTEMA

    -- 5 (FC): F_FECHA_HOY
        function CF_today_date return Date is
            ld_today date;
        begin
            begin
                select TODAY_DATE
                into   ld_today
                from   MG_SCHEDULE
                where  COMPANY_CODE     = :P_COMPANY_CODE
                and    APPLICATION_CODE = :P_APPLICATION_CODE;
            EXCEPTION
                WHEN OTHERS THEN
                    ld_today := null;
            end;
            RETURN ld_today;
        end;

-- Cuerpo Reporte:
    -- 1 (BD): F_usuario1

    -- 2 (BD): F_codigo_unidad

    -- 3 (BD): F_numero_movimiento

    -- 4 (BD): F_fecha_valida

    -- 5 (BD): F_fecha_movimiento1

    -- 6 (BD): F_descripcion

    -- 7 (TXT?): B_14 (Agencia)

    -- 8 (BD): F_agencia

    -- 9 (?): F_1

    -- 10 (?): F_depto

    -- 22(CF): F_CF_Formula
        function CF_Display return VARCHAR2 is
            pv_format VARCHAR2(39);
        begin
            GM_P_DESPLEGAR_R(:level_1, :level_2, :level_3, :level_4, :level_5,
                             :level_6, :level_7, :level_8, :P_COMPANY_CODE, pv_format);
            RETURN(pv_format);
        end;

    -- 23 (CF): F_desc_aux
        function CF_display_concept return CHAR is
            lv_description varchar2(60);
        begin
            begin
                select DESCRIPTION
                into   lv_description
                from   MG_TRANSACTION_TYPES
                where  APPLICATION_CODE       = :concept_application
                and    TRANSACTION_TYPE_CODE  = :transaction_concept;
            exception
                when no_data_found then
                    lv_description := null;
            end;
            lv_description := :concept_application || '-' || lv_description;
            return(lv_description);
        end;

    -- 37(CF): F_NOMBRECUENTA
        function CF_account_description return VARCHAR2 is
            lv_description      VARCHAR2(80);
            description_account VARCHAR2(80);
        Begin
            Begin
                SELECT DESCRIPTION
                INTO   description_account
                FROM   GM_ACCOUNT_BALANCE
                WHERE  COMPANY_CODE = :P_COMPANY_CODE
                AND    LEVEL_1      = :LEVEL_1
                AND    LEVEL_2      = :LEVEL_2
                AND    LEVEL_3      = :LEVEL_3
                AND    LEVEL_4      = :LEVEL_4
                AND    LEVEL_5      = :LEVEL_5
                AND    LEVEL_6      = :LEVEL_6
                AND    LEVEL_7      = :LEVEL_7
                AND    LEVEL_8      = :LEVEL_8;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RETURN(description_account);
            End;
            IF :auxiliary_code is not null then
                Begin
                    Select DESCRIPTION
                    into   lv_description
                    from   GM_CODES_AUXILIARY
                    where  AUXILIARY_CODE = :auxiliary_code;
                exception
                    when no_data_found then
                        lv_description := NULL;
                End;
                description_account := SUBSTR(description_account || ' - ' || lv_description, 1, 80);
            End If;
            RETURN(description_account);
        End;

    -- 40 (CF): F_CF_Diferencia
        function CF_difference return VARCHAR2 is
        begin
            IF ABS(:CS_SUM_CREDITS) != ABS(:CS_SUM_DEBITS) THEN
                RETURN('Los Totales de Débitos y Créditos no coinciden');
            ELSIF :TOTAL_CONTROL != 0 THEN
                IF ABS(:CS_SUM_CREDITS) != ABS(:TOTAL_CONTROL) OR
                   ABS(:CS_SUM_DEBITS)  != ABS(:TOTAL_CONTROL) THEN
                    RETURN('Los Totales del Cr. o Db.no coincide con total ctrl.');
                END IF;
            ELSE
                RETURN(NULL);
            END IF;
            RETURN NULL;
        end;

    -- 47(CF): F_descripcion_error1
        function CF_total_difference return VARCHAR2 is
        begin
            IF ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CR) THEN
                RETURN('Existen Totales de Débitos y Créditos que no coinciden');
            ELSE
                RETURN(NULL);
            END IF;
            RETURN NULL;
        end;
    
    -- 48(CF): F_descripcion_error2
        function CF_total_difference2 return VARCHAR2 is
        begin
            /*  IF (ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CONTROL)  OR
                    ABS(:CS_TOTAL_CR) != ABS(:CS_TOTAL_CONTROL) ) THEN
                RETURN('Existen Totales de Cr.o Db. que no coincide con total ctrl.');
            ELSE*/
            RETURN(NULL);
        --  END IF;
        end;

    -- 49(CF): F_descripcion_suc1
        function CF_branch_description return VARCHAR2 is
        begin
            DECLARE
                lv_branch_name  MG_BRANCHES_GENERAL.Branch_Name%TYPE := ' ';
                lv_error_msg    VARCHAR2(200);
            BEGIN
                MG_P_NOMBRE_AGENCIA(:P_COMPANY_CODE, null, lv_branch_name, lv_error_msg);
                IF lv_error_msg IS NULL THEN
                    RETURN(lv_branch_name);
                ELSE
                    RETURN(NULL);
                END IF;
            END;
            RETURN NULL;
        end;
        
    -- 52 (CF): F_DIFERENCIA_SUC
        function CF_branch_diff return Number is
        begin
            return(abs(:sum_db - :sum_cr));
        end;

    