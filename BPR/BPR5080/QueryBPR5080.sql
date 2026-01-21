select a.codigo_empresa, 
           decode(p.contabiliza_x_agencia,'S',a.codigo_agencia,p.codigo_agencia_base) CODIGO_AGENCIA,
           decode(p.contabiliza_x_sub_aplicacion,'S',a.codigo_sub_aplicacion,p.codigo_sub_aplicacion_base) CODIGO_SUB_APLICACION,
          CODIGO_MONEDA,
          nvl(SUM(round(VALOR,2)),0) CAPITAL
 FROM    PR_PRESTAMOS A,                
               PR_SALDOS_PRESTAMO C, 
               PR_PARAMETROS_CARTERA P,
               PR_TIPOS_SALDO D,
               MG_SUB_APLICACIONES S,
               mg_calendario b
 WHERE a.estado = 1
  and  nvl(A.codigo_tipo,0)                     !=   3
  and  a.codigo_empresa = p.codigo_empresa
  AND S.CODIGO_EMPRESA                = A.CODIGO_EMPRESA
  AND  S.CODIGO_APLICACION                  = A.CODIGO_APLICACION
  AND S.CODIGO_SUB_APLICACION         = A.CODIGO_SUB_APLICACION
  AND S.CODIGO_MONEDA                        = NVL(:P_MONEDA,S.CODIGO_MONEDA) 
/********************/
  AND C.NUMERO_PRESTAMO             = A.NUMERO_PRESTAMO
  AND C.CODIGO_SUB_APLICACION     = A.CODIGO_SUB_APLICACION
  AND C.CODIGO_AGENCIA                    = A.CODIGO_AGENCIA
  AND C.CODIGO_EMPRESA                  = A.CODIGO_EMPRESA
  AND C.CODIGO_TIPO_SALDO             = D.CODIGO_TIPO_SALDO
  AND D.TIPO_ABONO = 'C'
/********************/
  AND  B.CODIGO_APLICACION              =  'BPR'
 GROUP BY  a.codigo_empresa, 
           decode(p.contabiliza_x_agencia,'S',a.codigo_agencia,p.codigo_agencia_base) ,
           decode(p.contabiliza_x_sub_aplicacion,'S',a.codigo_sub_aplicacion,p.codigo_sub_aplicacion_base) ,
          CODIGO_MONEDA


-- Funciones:

-- F_CF_nom_agen
function CF_nom_agenFormula return VARCHAR2 is
  nombre mg_agencias_generales.nombre_agencia%type;
begin
  begin
   Select nombre_agencia into nombre from mg_agencias_generales
   where codigo_agencia = :codigo_agencia
   and codigo_empresa = :codigo_empresa;
   exception
     when others then null;
  end;
  return(nombre);
end;

-- F_CF_NOM_SUBAPLI
function CF_NOM_SUBAPLIFormula return VARCHAR2 is
  nombre mg_sub_aplicaciones.descripcion%type;
begin
   begin
      Select descripcion into nombre from mg_sub_aplicaciones
      Where codigo_aplicacion     = 'BPR'
      And   codigo_sub_aplicacion = :codigo_sub_aplicacion;
     exception
       when others then null;
   end;
  return(nombre);
end;

-- F_Capital
function CF_CAPITALFormula return Number is
  LN_CREDITO        NUMBER;
  LN_CREDITO2       NUMBER;
  capital           number;
  FechaTipoCambio   Date;
  TipoCambioOrigen  Number;
  TipoCambioDestino Number;
  TipoCambio        Number;
  DiferenciaCambio  Number;
  GananciaPerdida   Number;
  Ln_MontoDestino   Number;
  Lv_Mensaje        Varchar2(2000);
  Ln_MontoExtranjero Number;
begin

  Ln_MontoDestino := :capital ;--+ LN_CREDITO;
	
	If :codigo_moneda != :p_moneda_local Then
		Ln_MontoExtranjero := Ln_MontoDestino ;
	 
		Ln_MontoDestino    := 0;
    Mg_P_CambioMoneda ( :P_CODIGO_EMPRESA,
                 				:CODIGO_MONEDA,
				                :p_moneda_local,
			                   1, -- TipoContable
				                FechaTipoCambio,
				                :P_dia_proceso,
		  		              TipoCambioorigen,
		  		              TipoCambioDestino,
				                TipoCambio,
				                Ln_MontoExtranjero,
				                Ln_MontoDestino,
				                DiferenciaCambio,
				                GananciaPerdida,
				                Lv_Mensaje);	
				 
End If;
	:cp_saldoextranjero := Ln_MontoExtranjero;
  RETURN(Ln_MontoDestino);  

end;

-- F_CF_mayor
function CF_mayorFormula return Number is
  Mayor Number;
begin
  begin
  select  nvl(SUM(NVL(F.SALDO_ACTUAL,0)),0) 
  Into Mayor
  FROM    GM_BALANCE_CUENTAS  F
  WHERE F.CUENTA  IN
               (SELECT DISTINCT
                   E.NIVEL_1_CUENTA_CONT||E.NIVEL_2_CUENTA_CONT||E.NIVEL_3_CUENTA_CONT||
                   E.NIVEL_4_CUENTA_CONT||E.NIVEL_5_CUENTA_CONT||E.NIVEL_6_CUENTA_CONT||
                   E.NIVEL_7_CUENTA_CONT||E.NIVEL_8_CUENTA_CONT
                FROM PR_PARAMETRO_CONTABLE_DETALLE E, PR_TIPOS_SALDO B,PR_PARAMETROS_CARTERA
                WHERE E.CODIGO_TIPO_SALDO         = B.CODIGO_TIPO_SALDO
                AND   B.TIPO_ABONO                = 'C'
                and   e.codigo_tipo != 3
                AND   B.TIPO_SALDO                IS NOT NULL
                AND   E.CODIGO_EMPRESA            = :codigo_empresa
                AND   E.CODIGO_AGENCIA            = :codigo_agencia
                AND   E.CODIGO_SUB_APLICACION     = :codigo_sub_aplicacion )
  AND   F.CODIGO_EMPRESA            = :codigo_empresa;

 exception 
  when others then null;
 end;
 return(Mayor);
end;

-- F_1
function CF_difFormula return Number is
  Mayor Number;
  dif number;
begin
 dif := (:cf_Mayor - :cF_capital);
 return(dif);
end;