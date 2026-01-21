-- Q_REVALORIZACION
/*
    
*/
SELECT A.NIVEL_1,A.NIVEL_2, A.NIVEL_3, A.NIVEL_4,
              A.NIVEL_5, A.NIVEL_6, A.NIVEL_7, A.NIVEL_8,
              A.DESCRIPCION CTA_DESC ,A.CODIGO_MONEDA,
              NVL(A.SALDO_ACTUAL,0) SALDO_EXTRANJERO,
              NVL(B.SALDO_ACTUAL,0) SALDO_NACIONAL,

              C.DESCRIPCION MON_DESC             
FROM GM_BALANCE_EXTRANJEROS A,
            GM_BALANCE_CUENTAS B,
            MG_MONEDAS C,
           GM_PARAMETROS D
WHERE A.CODIGO_EMPRESA = B.CODIGO_EMPRESA   
AND      A.NIVEL_1                     = B.NIVEL_1
AND      A.NIVEL_2                     = B.NIVEL_2
AND      A.NIVEL_3                     = B.NIVEL_3
AND      A.NIVEL_4                     = B.NIVEL_4
AND      A.NIVEL_5                     = B.NIVEL_5
AND      A.NIVEL_6                     = B.NIVEL_6
AND      A.NIVEL_7                     = B.NIVEL_7
AND      A.NIVEL_8                     = B.NIVEL_8
AND (    B.SALDO_ACTUAL   != 0  
OR  0  !=  (SELECT SUM(MONTO_MOVIMIENTO)
      FROM GM_MOVIMIENTOS_DETALLE M
    WHERE M.CODIGO_EMPRESA     = A.CODIGO_EMPRESA
         AND M.NIVEL_1                         = A.NIVEL_1
         AND M.NIVEL_2                         = A.NIVEL_2
         AND M.NIVEL_3                         = A.NIVEL_3
         AND M.NIVEL_4                         = A.NIVEL_4
         AND M.NIVEL_5                         = A.NIVEL_5
        AND M.NIVEL_6                          = A.NIVEL_6
        AND M.NIVEL_7                          = A.NIVEL_7
       AND M.NIVEL_8                           = A.NIVEL_8
     /*  AND M.FECHA_MOVIMIENTO    != :P_FECHA */) )
AND     A.CODIGO_MONEDA   !=  D.CODIGO_MONEDA_LOCAL
AND     A.CODIGO_MONEDA     = C.CODIGO_MONEDA
AND   B.RECIBE_MOVIMIENTO  = 'S'
AND  ( A.NIVEL_1  < '400'
OR      A.NIVEL_1 > '599')
AND a.nivel_1 BETWEEN nvl(:pnivel_1,a.nivel_1) AND                 DECODE(:pnivel_1_1,NULL,DECODE(:pnivel_1,NULL,a.nivel_1,:pnivel_1),:pnivel_1_1) 
AND a.nivel_2 BETWEEN nvl(:pnivel_2,a.nivel_2) AND    DECODE(:pnivel_2_2,NULL,DECODE(:pnivel_2,NULL,a.nivel_2,:pnivel_2),:pnivel_2_2) 
AND a.nivel_3 BETWEEN nvl(:pnivel_3,a.nivel_3) AND   DECODE(:pnivel_3_3,NULL,DECODE(:pnivel_3,NULL,a.nivel_3,:pnivel_3),:pnivel_3_3) 
 AND a.nivel_4 BETWEEN nvl(:pnivel_4,a.nivel_4) AND   DECODE(:pnivel_4_4,NULL,DECODE(:pnivel_4,NULL,a.nivel_4,:pnivel_4),:pnivel_4_4) 
AND  a.nivel_5 BETWEEN nvl(:pnivel_5,a.nivel_5) AND   DECODE(:pnivel_5_5,NULL,DECODE(:pnivel_5,NULL,a.nivel_5,:pnivel_5),:pnivel_5_5)
 AND a.nivel_6  BETWEEN nvl(:pnivel_6,a.nivel_6) AND   DECODE(:pnivel_6_6,NULL,DECODE(:pnivel_6,NULL,a.nivel_6,:pnivel_6),:pnivel_6_6) 
 AND a.nivel_7 BETWEEN nvl(:pnivel_7,a.nivel_7) AND   DECODE(:pnivel_7_7,NULL,DECODE(:pnivel_7,NULL,a.nivel_7,:pnivel_7),:pnivel_7_7)
 AND a.nivel_8 BETWEEN nvl(:pnivel_8,a.nivel_8) AND   DECODE(:pnivel_8_8,NULL,DECODE(:pnivel_8,NULL,a.nivel_8,:pnivel_8),:pnivel_8_8) 
ORDER BY A.CODIGO_MONEDA, A.NIVEL_1||A.NIVEL_2||A.NIVEL_3||A.NIVEL_4||A.NIVEL_5||A.NIVEL_6||A.NIVEL_7||A.NIVEL_8

-- FUNCIONES:
-- F_CF_TASA
function CF_TASAFormula return Number is
  Ln_ValorCambio MG_TIPOS_DE_CAMBIO.VALOR_CAMBIO%TYPE;
  TasaCambioorigen       Number;
  TasaCambioDestino      Number;
  Ln_ValorTasa           Number;
  Ln_MontoMonedaLocal    Number;
  Ln_DiferenciaCambio    Number;
  Ln_GananciaPerdida     Number;
  Ld_FechaTipoCambio     Date;
  Lv_MensajeError    Varchar2(2000);
begin
	/*
    SELECT VALOR_CAMBIO
    INTO   Ln_ValorCambio
    FROM   MG_TIPOS_DE_CAMBIO A
    WHERE  A.CODIGO_MONEDA = :CODIGO_MONEDA AND
           A.FECHA_TIPO_DE_CAMBIO = (SELECT MAX(FECHA_TIPO_DE_CAMBIO)
                                     FROM    MG_TIPOS_DE_CAMBIO
                                     WHERE   CODIGO_MONEDA = :CODIGO_MONEDA
                                       AND FECHA_TIPO_DE_CAMBIO <= :CF_FECHA_HOY);
                                       
                                       
    */
        TasaCambioOrigen   := Null;
        Ln_ValorCambio     := Null;
        Mg_P_cambiomoneda ( :P_Codigo_Empresa,
                            :Codigo_Moneda,
  	              		      :p_moneda_local,
			                      1, -- Tipo Contable
			                      Ld_FechaTipoCambio,
			                      :p_fecha,
		  	                    TasaCambioorigen,
		  	                    TasaCambioDestino,
		                        Ln_ValorCambio,
	                          1 , --MontoOrigen
	                          Ln_MontoMonedaLocal,
	                          Ln_DiferenciaCambio,
	                          Ln_GananciaPerdida,
		                        Lv_MensajeError);
		 
   RETURN(Ln_ValorCambio);
end;

-- F_CUENTA
function CF_CUENTAFormula return VARCHAR2 is
  Lv_Formato  VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(:NIVEL_1,:NIVEL_2,:NIVEL_3,:NIVEL_4,:NIVEL_5,
                   :NIVEL_6,:NIVEL_7,:NIVEL_8, :p_codigo_empresa, Lv_Formato);
  RETURN(Lv_Formato);  
end;

-- F_TIPO_CAMBIO
function CF_TASACAMBIODETFormula return Number is
  Ln_ValorCambio MG_TIPOS_DE_CAMBIO.VALOR_CAMBIO%TYPE;
  TasaCambioorigen       Number;
  TasaCambioDestino      Number;
  Ln_ValorTasa           Number;
  Ln_MontoMonedaLocal    Number;
  Ln_DiferenciaCambio    Number;
  Ln_GananciaPerdida     Number;
  Ld_FechaTipoCambio     Date;
  Ln_TipoCambio          Number;
  Lv_MensajeError        Varchar2(2000);
  Lv_Cuenta              Varchar2(32);
begin
	/*
    SELECT VALOR_CAMBIO
    INTO   Ln_ValorCambio
    FROM   MG_TIPOS_DE_CAMBIO A
    WHERE  A.CODIGO_MONEDA = :CODIGO_MONEDA AND
           A.FECHA_TIPO_DE_CAMBIO = (SELECT MAX(FECHA_TIPO_DE_CAMBIO)
                                     FROM    MG_TIPOS_DE_CAMBIO
                                     WHERE   CODIGO_MONEDA = :CODIGO_MONEDA
                                       AND FECHA_TIPO_DE_CAMBIO <= :CF_FECHA_HOY);
                                       
                                       
    */

    Lv_cuenta := :nivel_1||:nivel_2||:nivel_3||:nivel_4||:nivel_5||
                 :nivel_6||:nivel_7||:nivel_8;
                 
    --
    Begin
      SELECT Tipo_Cambio
        INTO Ln_TipoCambio
        FROM  GM_Rangos_Ctas_Revaluo
      WHERE Codigo_Empresa  = :P_Codigo_Empresa
        AND codigo_moneda   = :codigo_moneda
        and desde_cta_nivel_1 <= :nivel_1
        and hasta_cta_nivel_1 >= :nivel_1
        and desde_cta_nivel_2 <= :nivel_2
        and hasta_cta_nivel_2 >= :nivel_2
        and desde_cta_nivel_3 <= :nivel_3
        and hasta_cta_nivel_3 >= :nivel_3
        and desde_cta_nivel_4 <= :nivel_4
        and hasta_cta_nivel_4 >= :nivel_4
        and desde_cta_nivel_5 <= :nivel_5
        and hasta_cta_nivel_5 >= :nivel_5
        and desde_cta_nivel_6 <= :nivel_6
        and hasta_cta_nivel_6 >= :nivel_6
        and desde_cta_nivel_7 <= :nivel_7
        and hasta_cta_nivel_7 >= :nivel_7
        and desde_cta_nivel_8 <= :nivel_8
        and hasta_cta_nivel_8 >= :nivel_8;
        
   
          Ln_TipoCambio  := Nvl(Ln_TipoCambio,1);
    Exception
    	When No_Data_Found Then
          Ln_TipoCambio := 1;
      when too_many_rows Then
          Ln_TipoCambio := 1;
   End;
   TasaCambioOrigen   := Null;
   Ln_ValorCambio     := Null;
   :cp_tipocambio := Ln_TipoCambio; 
   Mg_P_cambiomoneda ( :P_Codigo_Empresa,
                       :Codigo_Moneda,
              		     :p_moneda_local,
			                 Ln_TipoCambio,
			                 Ld_FechaTipoCambio,
			                 :p_fecha,
		  	               TasaCambioorigen,
		  	               TasaCambioDestino,
		                   Ln_ValorCambio,
	                     1 , --MontoOrigen
	                     Ln_MontoMonedaLocal,
	                     Ln_DiferenciaCambio,
	                     Ln_GananciaPerdida,
		                   Lv_MensajeError);
		 
   RETURN(Nvl(Ln_ValorCambio,1));
end;

-- F_SALDO_EXTRANJERO1
function CF_SALDO_EXTFormula return Number is
  Lv_Naturaleza_Cta  VARCHAR2(1);
  Lv_CodError        VARCHAR2(200) :=NULL ;
  MontoDebitoME      Number(19,6)  := 0;
  MontoDebitoMN      Number(19,6)  := 0;
  MontoCreditoME      Number(19,6) := 0;
  MontoCreditoMN      Number(19,6) := 0;
begin  
  For Reg in (Select a.*
                From gm_movimientos_detalle a , 
                     gm_movimientos_encabezado b
              Where
                    a.codigo_empresa    = :p_codigo_empresa
                and a.nivel_1           = :nivel_1
                and a.nivel_2           = :nivel_2
                and a.nivel_3           = :nivel_3
                and a.nivel_4           = :nivel_4
                and a.nivel_5           = :nivel_5
                and a.nivel_6           = :nivel_6
                and a.nivel_7           = :nivel_7
                and a.nivel_8           = :nivel_8
                and b.numero_movimiento = a.numero_movimiento 
                and b.usuario            = a.usuario
                and b.fecha_movimiento  = a.fecha_movimiento
                and b.fecha_valida     <= :p_fecha)
                
  Loop
    If Reg.codigo_moneda = :codigo_moneda Then
      If Reg.debito_credito = 'D' Then
         MontoDebitoMN := MontoDebitoMn + Reg.monto_movimiento_local;
         MontoDebitoME := MontoDebitoMe + Reg.monto_movimiento;
      Else
         MontoCreditoMN := MontoCreditoMn + Abs(Reg.monto_movimiento_local);
         MontoCreditoME := MontoCreditoMe + Abs(Reg.monto_movimiento);
      End If; 
    Else
      If Reg.debito_credito = 'D' Then
         MontoDebitoMN := MontoDebitoMN + Reg.monto_movimiento;
      Else
         MontoCreditoMN := MontoCreditoMn + Abs(Reg.monto_movimiento);
      End If;       
    End If;
  End Loop;  
  
  Lv_CodError := GM_F_NATURALEZA_CUENTA(:P_Codigo_Empresa,
					:nivel_1, 
					:nivel_2,
					:nivel_3,
					:nivel_4,
					:nivel_5,
					:nivel_6,
					Lv_Naturaleza_Cta);
   
  If Lv_Naturaleza_Cta = 'D' Then
    :cp_saldomovMN := MontoDebitoMN - MontoCreditoMN;
    :cp_SaldoMovME := MontoDebitoME - MontoCreditoME;
  Else
    :cp_saldomovMN := MontoCreditoMN - MontoDebitoMN;
    :cp_SaldoMovME := MontoCreditoME - MontoDebitoME;
  End If;
  
  

  IF  ( Lv_Naturaleza_Cta = 'D' AND :SALDO_EXTRANJERO > 0 ) OR
      ( Lv_Naturaleza_Cta = 'C' AND :SALDO_EXTRANJERO < 0 )
  THEN
    RETURN (ABS(:SALDO_EXTRANJERO + :Cp_SaldoMovME ));
  ELSE
    RETURN (ABS(:SALDO_EXTRANJERO + :Cp_SaldoMovME) * -1 );
  END IF;

RETURN NULL; end;

--F_SALDO_NACIONAL
function CF_SALDO_NACFormula return Number is
  Lv_Naturaleza_Cta VARCHAR2(1);
  Lv_CodError       VARCHAR2(200):=NULL ;
begin
  Lv_CodError := GM_F_NATURALEZA_CUENTA(:P_Codigo_Empresa,
					:nivel_1, 
					:nivel_2,
					:nivel_3,
					:nivel_4,
					:nivel_5,
					:nivel_6,
					Lv_Naturaleza_Cta);

  IF  ( Lv_Naturaleza_Cta = 'D' AND :SALDO_NACIONAL > 0 ) OR 
      ( Lv_Naturaleza_Cta = 'C' AND :SALDO_NACIONAL < 0 )
  THEN
    RETURN (ABS(:SALDO_NACIONAL + :Cp_SaldoMovMN));
  ELSE
    RETURN (ABS(:SALDO_NACIONAL + :Cp_SaldoMovMN) * -1 );
  END IF;
RETURN NULL; end;

--F_MONTO_REV
function CF_SALDO_REVFormula return Number is
  Lv_Naturaleza_Cta VARCHAR2(1);
  Lv_CodError       VARCHAR2(200):=NULL ;
begin  
  Lv_CodError := GM_F_NATURALEZA_CUENTA(:P_Codigo_Empresa,
					:nivel_1, 
					:nivel_2,
					:nivel_3,
					:nivel_4,
					:nivel_5,
					:nivel_6,
					Lv_Naturaleza_Cta);
  IF  ( Lv_Naturaleza_Cta = 'D' AND :CF_MONTO_REV > 0 ) OR 
      ( Lv_Naturaleza_Cta = 'C' AND :CF_MONTO_REV < 0 )
  THEN
    RETURN (ABS(:CF_MONTO_REV));
  ELSE
    RETURN (ABS(:CF_MONTO_REV) * -1 );
  END IF;
RETURN NULL; end;

-- F_Diferencia
function CF_DIFERENCIAFormula return Number is
 Ln_Diferencia   number(14,2);
begin
 Ln_Diferencia := nvl(:saldo_nacional,0) + nvl(:cp_saldomovmn,0) - nvl(:cf_Monto_Rev,0);
 RETURN(Ln_Diferencia);
end;



