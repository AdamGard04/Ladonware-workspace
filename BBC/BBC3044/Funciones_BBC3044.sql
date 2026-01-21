/*
==========ENCABEZADO DE REPORTES BBC3044=================
    1(CF): F_USUARIO
    2(CF): F_EMPRESA
    3(ID?): F_NOMBREREPORTE
    4(F?): F_FECHA_SISTEMA
    5(FC): F_FECHA_HOY

==========CUERPO DE REPORTES BBC3044===================
    1(BD): F_usuario1
    2(BD): F_codigo_unidad
    3(BD): F_numero_movimiento
    4(BD): F_fecha_valida
    5(BD): F_fecha_movimiento1
    6(BD): F_descripcion
    7(TXT?): B_14 (Agencia)
    8(BD): F_agencia
    9(?): F_1
    10(?): F_depto
    22(BD):F_secuencia_renglon
    23(CF): F_CF_Formula
    24(CF): F_desc_aux
    25(BD): F_Desc_Detalle
    26(BD): F_codigo_moneda1
    37(CF): F_NOMBRECUENTA
    40 (CF): F_CF_Diferencia
    47(CF): F_descripcion_error1
    48(CF): F_descripcion_error2
    49(CF): F_descripcion_suc1
    52 (CF): F_DIFERENCIA_SUC
*/

-- Encabezado Reporte:
    -- 1 (CF): F_USUARIO
        function CG_C_USERFormula return VARCHAR2 is
        begin
            return(:P_USER_REP);
        end;

    -- 2 (CF): F_EMPRESA
        function CF_NOMBRE_EMPRESAFormula return VARCHAR2 is Lv_Empresa VARCHAR2(30);
        begin
            SELECT NOMBRE INTO Lv_Empresa
            FROM MG_EMPRESAS
            WHERE CODIGO_EMPRESA = :P_CODIGO_EMPRESA;
            RETURN(Lv_Empresa);
            RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
        end;

    -- 3 (ID?): F_NOMBREREPORTE
        
    -- 4 (F?): F_FECHA_SISTEMA

    -- 5 (FC): F_FECHA_HOY2
        function CF_fecha_hoyFormula return Date is Ld_FechaHoy date;
        begin
            begin
            select fecha_hoy 
            into   Ld_FechaHoy
            from   mg_calendario
            where  codigo_empresa    = :P_CODIGO_EMPRESA
            and    codigo_aplicacion = :P_CODIGO_APLICACION;
            EXCEPTION 
                WHEN OTHERS THEN  
                Ld_fechaHoy := null;
        end;
        RETURN Ld_fechahoy;
        end;

    -- 6 (FC): F_FECHA_HOY1
        function CF_fecha_hoyFormula return Date is Ld_FechaHoy date;
        begin
            begin
            select fecha_hoy 
            into   Ld_FechaHoy
            from   mg_calendario
            where  codigo_empresa    = :P_CODIGO_EMPRESA
            and    codigo_aplicacion = :P_CODIGO_APLICACION;
            EXCEPTION 
                WHEN OTHERS THEN  
                Ld_fechaHoy := null;
        end;
        RETURN Ld_fechahoy;
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
        function CF_FormulaFormula return VARCHAR2 is Pv_Formato VARCHAR2(39);
        begin
            GM_P_DESPLEGAR_R(:nivel_1, :nivel_2, :nivel_3, :nivel_4, :nivel_5,
            :nivel_6, :nivel_7, :nivel_8,:P_CODIGO_EMPRESA, Pv_Formato);
        RETURN(Pv_Formato);
        end;

    -- 23 (CF): F_desc_aux
        function CF_dsp_conceptoFormula return Char is Lv_descripcion varchar2(60);
        begin
            begin
                select descripcion
                into   Lv_descripcion
                from   mg_tipos_de_transacciones
                where  codigo_aplicacion = :aplicacion_concepto
                and    codigo_tipo_transaccion = :transaccion_concepto;
            exception
                when no_data_found then
                Lv_descripcion := null;
            end;
            Lv_descripcion := :aplicacion_concepto||'-'||Lv_descripcion;
            return(Lv_descripcion);
            end;

    -- 37(CF): F_NOMBRECUENTA
        function CF_DESCCUENTAFormula return VARCHAR2 is

            lv_descripcion    VARCHAR2(80);
            DESCRIPCIONCUENTA VARCHAR2(80);
            Begin
            Begin
                SELECT DESCRIPCION
                INTO DESCRIPCIONCUENTA
                FROM GM_BALANCE_CUENTAS
                WHERE CODIGO_EMPRESA = :P_CODIGO_EMPRESA
                AND NIVEL_1        = :NIVEL_1
                AND NIVEL_2        = :NIVEL_2
                AND NIVEL_3        = :NIVEL_3
                AND NIVEL_4        = :NIVEL_4
                AND NIVEL_5        = :NIVEL_5
                AND NIVEL_6        = :NIVEL_6
                AND NIVEL_7        = :NIVEL_7
                AND NIVEL_8        = :NIVEL_8;
                --RETURN(DESCRIPCIONCUENTA);
                --RETURN NULL; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                RETURN(DESCRIPCIONCUENTA);
            End;
            IF :codigo_auxiliar is not null then
                Begin
                Select descripcion
                    into lv_descripcion
                    from gm_codigos_auxiliares
                where codigo_auxiliar = :codigo_auxiliar;
                exception
                    when no_data_found then
                    lv_descripcion := NULL;
                End;
                DESCRIPCIONCUENTA := SUBSTR(DESCRIPCIONCUENTA||' - '||Lv_Descripcion,1,80);
            End If;
            RETURN(DESCRIPCIONCUENTA);
        End;

    -- 40 (CF): F_CF_Diferencia
        function CF_DiferenciaFormula return VARCHAR2 is
        begin
            IF ABS(:CS_SUMA_CREDITOS) != ABS(:CS_SUMA_DEBITOS) 
            THEN
                RETURN('Los Totales de Débitos y Créditos no coinciden');
            ELSIF :TOTAL_CONTROL != 0 THEN
                    IF ABS(:CS_SUMA_CREDITOS) != ABS(:TOTAL_CONTROL)  OR
                    ABS(:CS_SUMA_DEBITOS)  != ABS(:TOTAL_CONTROL)  THEN
                    RETURN('Los Totales del Cr. o Db.no coincide con total ctrl.');
                    END IF;
            ELSE
                RETURN(NULL);
            END IF;
        RETURN NULL;
        end;

    -- 47(CF): F_descripcion_error1
        function CF_diferencia_totalFormula return VARCHAR2 is
        begin
            IF ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CR) 
            THEN
                RETURN('Existen Totales de Débitos y Créditos que no coinciden');
            ELSE
                RETURN(NULL);
            END IF;
        RETURN NULL; 
        end;
    
    -- 48(CF): F_descripcion_error2
        function CF_diferencia_total2Formula return VARCHAR2 is
        begin
            /*  IF (ABS(:CS_TOTAL_DB) != ABS(:CS_TOTAL_CONTROL)  OR
                    ABS(:CS_TOTAL_CR) != ABS(:CS_TOTAL_CONTROL) ) THEN
                RETURN('Existen Totales de Cr.o Db. que no coincide con total ctrl.');
            ELSE*/
            RETURN(NULL);
        --  END IF;
        end;

    -- 49(CF): F_descripcion_suc1
        function CF_descripcion_sucFormula return VARCHAR2 is
        begin
            DECLARE
                Lv_NombreAgencia  MG_Agencias_Generales.Nombre_Agencia%TYPE := ' ';
                Lv_MensajeError   VARCHAR2(200);
            BEGIN
                MG_P_NOMBRE_AGENCIA(:p_codigo_Empresa,null,Lv_NombreAgencia,Lv_MensajeError);
                IF Lv_MensajeError IS NULL 
                THEN
                RETURN(Lv_NombreAgencia);
                ELSE
                RETURN(NULL);
                END IF;
        END;
        RETURN NULL; 
        end;
        
    -- 52 (CF): F_DIFERENCIA_SUC
        function CF_DIF_sucFORMULA0240 return Number is
        begin
            return(abs(:sum_db-:sum_cr));
        end;

    