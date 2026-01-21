/*
  Listado de campos:
      Encabezado:
          1 (CF): F_USUARIO
          2 (CF): F_EMPRESA
          3 (ID?): F_NOMBREREPORTE
          4 (F?): F_FECHA_SISTEMA
          5 (FC): F_FECHA_HOY2
          6 (CF): F_BENEFICIARIO_2
          7 (FC): F_FECHA_HOY1
          8 (FC): F_NUMERO_CHEQUE_2
*/

--Encabezado de Reporte BBC3279:

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
function CF_FECHA_HOYFormula return Date is
Ld_FechaHoy date;
begin
  SELECT FECHA_HOY INTO Ld_FechaHoy
  FROM MG_CALENDARIO
  WHERE CODIGO_EMPRESA    = :P_CODIGO_EMPRESA
  AND   CODIGO_APLICACION = 'BBC';
  RETURN Ld_FechaHoy;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;

-- 6 (CF): F_BENEFICIARIO_2
  function CP_beneficiarioFormula return Char is
begin
  
end;

-- 7 (FC): F_FECHA_HOY1
function CF_FECHA_HOYFormula return Date is
Ld_FechaHoy date;
begin
  SELECT FECHA_HOY INTO Ld_FechaHoy
  FROM MG_CALENDARIO
  WHERE CODIGO_EMPRESA    = :P_CODIGO_EMPRESA
  AND   CODIGO_APLICACION = 'BBC';
  RETURN Ld_FechaHoy;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;

-- 8 (FC): F_NUMERO_CHEQUE_2
function CP_nro_chequeFormula return Char is
begin
  
end;

--Cuerpo de Reporte BBC3279:
-- F_CUENTA_SALDO: CF_cuenta_saldo 1(CF): 
function CF_cuenta_saldoFormula return Char is
lv_cuenta   varchar2(40);
begin
  if :nivel_1_saldo is not null then
    lv_cuenta:= :nivel_1_saldo||'-'||:nivel_2_saldo||'-'||:nivel_3_saldo||'-'||:nivel_4_saldo||'-'||:nivel_5_saldo||'-'||
                :nivel_6_saldo||'-'||:nivel_7_saldo||'-'||:nivel_8_saldo;
     
  end if;
  return(lv_cuenta);
end;



-- F_2_debito1: CF_DB_2
function CF_DB_2Formula return Number is
Begin
 If :dbcr2 = 'Dr' Then
 	return (:valor);
 Else
 	return (null);
 End if;
end;



-- F_2_credito1: CF_CR_2
function CF_CR_2Formula return Number is
Begin
 If :dbcr2 = 'Cr' Then
 	return (-:valor);
 Else
 	return (null);
 End if;
end;



-- F_CUENTA_DESGLOSE: CF_cuenta_desglose
function CF_cuenta_desgloseFormula return Char is
lv_cuenta   varchar2(40);
begin
  if :nivel_1_desglose is not null then
    lv_cuenta:= :nivel_1_desglose||'-'||:nivel_2_desglose||'-'||:nivel_3_desglose||'-'||:nivel_4_desglose||'-'||:nivel_5_desglose||'-'||
                :nivel_6_desglose||'-'||:nivel_7_desglose||'-'||:nivel_8_desglose;
     
  end if;
  return(lv_cuenta);
end;



-- F_CTA_CONCEPTO: CF_cuenta_concepto
function CF_cuenta_conceptoFormula return Char is
lv_cuenta   varchar2(40);
ln_nivel_agencia number;
lv_nivel_1 varchar2(4);
lv_nivel_2 varchar2(4);
lv_nivel_3 varchar2(4);
lv_nivel_4 varchar2(4);
lv_nivel_5 varchar2(4);
lv_nivel_6 varchar2(4);
lv_nivel_7 varchar2(4);
lv_nivel_8 varchar2(4);
begin
	
    lv_nivel_1 := :nivel_1;
   lv_nivel_2 := :nivel_2;
   lv_nivel_3 := :nivel_3;
   lv_nivel_4 := :nivel_4;
   lv_nivel_5 := :nivel_5;
   lv_nivel_6 := :nivel_6;
   lv_nivel_7 := :nivel_7;
   lv_nivel_8 := :nivel_8;
   
	begin
      select nivel_agencia
      into   ln_nivel_agencia
      from   gm_parametros
      where  codigo_empresa = :p_codigo_empresa;
      
      exception
        when no_data_found then
          ln_nivel_agencia := null;
   end;
  
	
	GM_P_CAMBIA_AGENCIA_A_CTA_CONT(:codigo_agencia_origen,
                                  ln_nivel_agencia,
                                  lv_nivel_1, lv_nivel_2, lv_nivel_3, lv_nivel_4,
                                  lv_nivel_5, lv_nivel_6, lv_nivel_7, lv_nivel_8,
                                  :p_codigo_empresa);
 
	 
   
  if :nivel_1 is not null then
    lv_cuenta:= lv_nivel_1||'-'||lv_nivel_2||'-'||lv_nivel_3||'-'||lv_nivel_4||'-'||lv_nivel_5||'-'||
                lv_nivel_6||'-'||lv_nivel_7||'-'||lv_nivel_8;
     
  end if;
 return(lv_cuenta);
end;

-- F_2: CF_DB_1
function CF_DB_1Formula return Number iS
Begin
 If :dbcr1 = 'Db' Then
 	return (:monto_cheque);
 Else
 	return (null);
 End if;
end;


-- F_1: CF_CR_1
function CF_CR_1Formula return Number is
Begin
 If :dbcr1 = 'Cr' Then
 	return (-:monto_cheque);
 Else
 	return (null);
 End if;
end;


-- F_total_db: CF_total_db
function CF_total_dbFormula return Number is
ln_monto number;
begin
	if :cs_suma_desglose >=  1 then
     ln_monto := nvl(:cs_db_2,0) + nvl(:cs_total_desglose,0);
	else
		 ln_monto := nvl(:cs_db_1,0) + nvl(:cs_db_2,0);
	end if;
  return(ln_monto);
end;



-- F_total_cr: CF_total_cr
function CF_total_crFormula return Number is
ln_monto number;
begin
  ln_monto := nvl(:cs_cr_1,0) + nvl(:cs_cr_2,0);
  return(ln_monto);
end;




 