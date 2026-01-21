SELECT  DISTINCT(A.CODIGO_AGENCIA_CORRESPONSAL) BANCO, A.CODIGO_EMPRESA EMPRESA,
A.CODIGO_MONEDA MONEDA,
A.NUMERO_CUENTA CUENTA,C.CODIGO_PAIS PAIS,
A.NIVEL_1_CUENTA_CONTABLE NIVEL_1, A.NIVEL_2_CUENTA_CONTABLE NIVEL_2,
A.NIVEL_3_CUENTA_CONTABLE NIVEL_3, A.NIVEL_4_CUENTA_CONTABLE NIVEL_4,
A.NIVEL_5_CUENTA_CONTABLE NIVEL_5, A.NIVEL_6_CUENTA_CONTABLE NIVEL_6,
A.NIVEL_7_CUENTA_CONTABLE NIVEL_7, A.NIVEL_8_CUENTA_CONTABLE NIVEL_8,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),1,SUM(D.DIA_1),0) SALDO_DIA_1,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),2,SUM(D.DIA_2),0) SALDO_DIA_2,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),3,SUM(D.DIA_3),0) SALDO_DIA_3,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),4,SUM(D.DIA_4),0) SALDO_DIA_4,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),5,SUM(D.DIA_5),0) SALDO_DIA_5,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),6,SUM(D.DIA_6),0) SALDO_DIA_6,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),7,SUM(D.DIA_7),0) SALDO_DIA_7,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),8,SUM(D.DIA_8),0) SALDO_DIA_8,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),9,SUM(D.DIA_9),0) SALDO_DIA_9,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),10,SUM(D.DIA_10),0) SALDO_DIA_10,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),11,SUM(D.DIA_11),0) SALDO_DIA_11,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),12,SUM(D.DIA_12),0) SALDO_DIA_12,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),13,SUM(D.DIA_13),0) SALDO_DIA_13,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),14,SUM(D.DIA_14),0) SALDO_DIA_14,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),15,SUM(D.DIA_15),0) SALDO_DIA_15,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),16,SUM(D.DIA_16),0) SALDO_DIA_16,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),17,SUM(D.DIA_17),0) SALDO_DIA_17,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),18,SUM(D.DIA_18),0) SALDO_DIA_18,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),19,SUM(D.DIA_19),0) SALDO_DIA_19,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),20,SUM(D.DIA_20),0) SALDO_DIA_20,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),21,SUM(D.DIA_21),0) SALDO_DIA_21,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),22,SUM(D.DIA_22),0) SALDO_DIA_22,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),23,SUM(D.DIA_23),0) SALDO_DIA_23,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),24,SUM(D.DIA_24),0) SALDO_DIA_24,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),25,SUM(D.DIA_25),0) SALDO_DIA_25,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),26,SUM(D.DIA_26),0) SALDO_DIA_26,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),27,SUM(D.DIA_27),0) SALDO_DIA_27,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),28,SUM(D.DIA_28),0) SALDO_DIA_28,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),29,SUM(D.DIA_29),0) SALDO_DIA_29,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),30,SUM(D.DIA_30),0) SALDO_DIA_30,
DECODE(TO_NUMBER(TO_CHAR(:P_FECHA,'DD')),31,SUM(D.DIA_31),0) SALDO_DIA_31
FROM BC_CORRESPONSAL_SALDOS A,BC_CORRESPONSAL_CUENTAS B,MG_AGENCIAS_GENERALES C, BC_SALDOS_DIARIOS D
WHERE A.CODIGO_EMPRESA = B.CODIGO_EMPRESA
AND   A.CODIGO_AGENCIA = B.CODIGO_AGENCIA
AND   A.CODIGO_AGENCIA_CORRESPONSAL = B.CODIGO_AGENCIA_CORRESPONSAL
AND   A.CODIGO_MONEDA = B.CODIGO_MONEDA
AND   A.NUMERO_CUENTA = B.NUMERO_CUENTA
AND   A.TIPO_SALDO = D.TIPO_SALDO
AND   A.NUMERO_CUENTA = D.NUMERO_CUENTA
AND   A.CODIGO_AGENCIA_CORRESPONSAL = D.CODIGO_AGENCIA_CORRESPONSAL
AND   A.CODIGO_MONEDA = D.CODIGO_MONEDA
AND   A.CODIGO_AGENCIA = D.CODIGO_AGENCIA
AND   A.CODIGO_EMPRESA = D.CODIGO_EMPRESA
AND   B.ESTADO_CUENTA != 3
--AND   B.CODIGO_AGENCIA = nvl(:P_CODIGO_AGENCIA, b.codigo_agencia)
AND   A.CODIGO_AGENCIA_CORRESPONSAL = C.CODIGO_AGENCIA
AND   C.CODIGO_PAIS =nvl( :P_PAIS,c.codigo_pais)
AND   D.MES = TO_NUMBER(TO_CHAR(:P_FECHA,'MM'))
AND   D.ANO = TO_NUMBER(TO_CHAR(:P_FECHA,'YYYY'))
GROUP BY A.CODIGO_AGENCIA_CORRESPONSAL,
          A.CODIGO_MONEDA,A.NUMERO_CUENTA,
          C.CODIGO_PAIS,
          A.CODIGO_EMPRESA,
          A.NIVEL_1_CUENTA_CONTABLE, A.NIVEL_2_CUENTA_CONTABLE,
          A.NIVEL_3_CUENTA_CONTABLE, A.NIVEL_4_CUENTA_CONTABLE,
          A.NIVEL_5_CUENTA_CONTABLE, A.NIVEL_6_CUENTA_CONTABLE,
          A.NIVEL_7_CUENTA_CONTABLE, A.NIVEL_8_CUENTA_CONTABLE
 ORDER BY C.CODIGO_PAIS,A.CODIGO_AGENCIA_CORRESPONSAL,A.NUMERO_CUENTA,
 A.CODIGO_MONEDA


-- funciones:
-- F_MONEDA1
function CF_desc_monedaFormula return VARCHAR2 is
  LV_MONEDA  VARCHAR(80);
begin
	begin
    SELECT descripcion
    INTO LV_MONEDA
    FROM MG_MONEDAS
    WHERE CODIGO_MONEDA = :MONEDA;
	exception
		when others then Lv_moneda := null;
	end;
	
	RETURN(LV_MONEDA);
end;



-- F_BANCO1
function CF_desc_bancoFormula return VARCHAR2 is
  lv_banco varchar(80);
begin
	begin
    SELECT NOMBRE_AGENCIA 
    INTO LV_BANCO
    FROM MG_AGENCIAS_GENERALES
    WHERE CODIGO_AGENCIA = :banco;
	EXCEPTION 
		 WHEN OTHERS THEN Lv_banco:= NULL;
	end;
	
	  RETURN(LV_BANCO);
end;



-- F_Saldo_Mayor
function CF_Saldo_MayorFormula return Number is
  Ln_SaldoActual NUMBER;
  Ln_SaldoLocal  NUMBER;
  Ln_Saldo_Mayor NUMBER;
begin
  PU_P_SaldoContableFecha(:P_Codigo_Empresa,
                          :nivel_1,
                          :nivel_2,
                          :nivel_3,
                          :nivel_4,
                          :nivel_5,
                          :nivel_6,
                          :nivel_7,
                          :nivel_8,
                          :Moneda,
                          :P_Moneda_Local,
                          :CF_Fecha_Hoy,
                          Ln_SaldoActual,
                          Ln_SaldoLocal);
  Ln_Saldo_Mayor := Ln_SaldoActual;
  RETURN(Ln_Saldo_Mayor);
end;



-- F_Saldo_Mayor_MN
function CF_Saldo_Mayor_MNFormula return Number is
  Ln_SaldoActual    NUMBER;
  Ln_SaldoLocal     NUMBER;
  Ln_Saldo_Mayor_MN NUMBER;
begin
  PU_P_SaldoContableFecha(:P_Codigo_Empresa,
                          :nivel_1,
                          :nivel_2,
                          :nivel_3,
                          :nivel_4,
                          :nivel_5,
                          :nivel_6,
                          :nivel_7,
                          :nivel_8,
                          :Moneda,
                          :P_Moneda_Local,
                          :CF_Fecha_Hoy,
                          Ln_SaldoActual,
                          Ln_SaldoLocal);
  Ln_Saldo_Mayor_MN := Ln_SaldoLocal;
  RETURN(Ln_Saldo_Mayor_MN);
end;



-- F_Saldo_Auxiliar
function CF_Saldo_AuxiliarFormula return Number is
  Ln_dia NUMBER;
begin
  Ln_dia := to_number(to_char(:p_fecha,'DD'));
  IF Ln_dia = 1 THEN
  	RETURN(:saldo_dia_1);
  ELSIF Ln_dia = 2 THEN
  	RETURN(:saldo_dia_2);
  ELSIF Ln_dia = 3 THEN
  	RETURN(:saldo_dia_3);
  ELSIF Ln_dia = 4 THEN
  	RETURN(:saldo_dia_4);
  ELSIF Ln_dia = 5 THEN
  	RETURN(:saldo_dia_5);
  ELSIF Ln_dia = 6 THEN
  	RETURN(:saldo_dia_6);
  ELSIF Ln_dia = 7 THEN
  	RETURN(:saldo_dia_7);
  ELSIF Ln_dia = 8 THEN
  	RETURN(:saldo_dia_8);
  ELSIF Ln_dia = 9 THEN
  	RETURN(:saldo_dia_9);
  ELSIF Ln_dia = 10 THEN
  	RETURN(:saldo_dia_10);
  ELSIF Ln_dia = 11 THEN
  	RETURN(:saldo_dia_11);
  ELSIF Ln_dia = 12 THEN
  	RETURN(:saldo_dia_12);
  ELSIF Ln_dia = 13 THEN
  	RETURN(:saldo_dia_13);
  ELSIF Ln_dia = 14 THEN
  	RETURN(:saldo_dia_14);
  ELSIF Ln_dia = 15 THEN
  	RETURN(:saldo_dia_15);
  ELSIF Ln_dia = 16 THEN
  	RETURN(:saldo_dia_16);
  ELSIF Ln_dia = 17 THEN
  	RETURN(:saldo_dia_17);
  ELSIF Ln_dia = 18 THEN
  	RETURN(:saldo_dia_18);
  ELSIF Ln_dia = 19 THEN
  	RETURN(:saldo_dia_19);
  ELSIF Ln_dia = 20 THEN
  	RETURN(:saldo_dia_20);
  ELSIF Ln_dia = 21 THEN
  	RETURN(:saldo_dia_21);
  ELSIF Ln_dia = 22 THEN
  	RETURN(:saldo_dia_22);
  ELSIF Ln_dia = 23 THEN
  	RETURN(:saldo_dia_23);
  ELSIF Ln_dia = 24 THEN
  	RETURN(:saldo_dia_24);
  ELSIF Ln_dia = 25 THEN
  	RETURN(:saldo_dia_25);
  ELSIF Ln_dia = 26 THEN
  	RETURN(:saldo_dia_26);
  ELSIF Ln_dia = 27 THEN
  	RETURN(:saldo_dia_27);
  ELSIF Ln_dia = 28 THEN
  	RETURN(:saldo_dia_28);
  ELSIF Ln_dia = 29 THEN
  	RETURN(:saldo_dia_29);
  ELSIF Ln_dia = 30 THEN
  	RETURN(:saldo_dia_30);
  ELSIF Ln_dia = 31 THEN
  	RETURN(:saldo_dia_31);
  END IF;
end;



-- F_Saldo_Auxiliar_MN
function CF_Saldo_Auxiliar_MNFormula return Number is
  TasaCambioorigen      NUMBER(16,8);
  TasaCambioDestino     NUMBER(16,8);
  DiferenciaCambio      NUMBER(16,6);
  GananciaPerdida       NUMBER(19,6);
  FechaTipoCambio       DATE;
  ValorTipoCambio       NUMBER;
  Lv_MensajeError       VARCHAR2(2000);
  LN_SinSobregiroMN     NUMBER(19,6);
begin
  
  If :P_MONEDA_LOCAL != :MONEDA THEN
    Mg_P_CambioMoneda ( :P_CODIGO_EMPRESA,
                				:MONEDA,
	                      :P_MONEDA_LOCAL,
	                      1, -- TipoContable
	                      FechaTipoCambio,
                        :CF_FECHA_HOY,
 		                    TasaCambioorigen,
		                    TasaCambioDestino,
                        ValorTipoCambio,
	                      :CF_Saldo_Auxiliar,
                        Ln_SinSobregiroMN,
                        DiferenciaCambio,
	                      GananciaPerdida,
	                      Lv_MensajeError);
  Else
  	Ln_SinSobregiroMN := :CF_Saldo_Auxiliar;
	End If;

  --:CP_SOBREGIRO_MN := Ln_SobregiroMN;
  RETURN(Ln_SinSobregiroMN);
end;



-- F_Diferencia
function CF_DiferenciaFormula return Number is
begin
  RETURN(:CF_Saldo_Mayor - :CF_Saldo_Auxiliar);
end;

