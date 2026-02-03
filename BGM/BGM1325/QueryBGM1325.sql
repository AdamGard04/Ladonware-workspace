
-- Q_CUENTAS

SELECT  DECODE(:p_ruptura1,1,a.nivel_1,2,a.nivel_2, 3,a.nivel_3, 4,a.nivel_4, 5,a.nivel_5, 6,a.nivel_6, 7,a.nivel_7,8, a.nivel_8,a.nivel_7 ) ruptura1,
a.codigo_empresa, a.nivel_1, a.nivel_2, a.nivel_3, a.nivel_4, a.nivel_5, a.nivel_6, a.nivel_7, a.nivel_8, DECODE(:p_ruptura1,1,d.CANTIDAD_DIG_NIVEL_1,2,d.CANTIDAD_DIG_nivel_2, 3,d.CANTIDAD_DIG_nivel_3, 4,d.CANTIDAD_DIG_nivel_4, 5,d.CANTIDAD_DIG_nivel_5, 6,d.CANTIDAD_DIG_nivel_6, 7,d.CANTIDAD_DIG_nivel_7, d.CANTIDAD_DIG_nivel_8 ) CANTIDAD_DIG,
nvl(saldo_actual,0) saldo_anterior,
a.descripcion  desc_cuenta,e.signo
FROM    gm_balance_cuentas a, gm_catalogos c, GM_PARAMETRO_ESTRUCTURA_CTAS D,gm_tipos_de_cuentas e
WHERE  a.codigo_empresa = :p_codigo_empresa
AND e.CODIGO_EMPRESA = D.CODIGO_EMPRESA
and d.codigo_empresa = c.codigo_empresa
and a.codigo_tipo = e.codigo_tipo
AND a.nivel_1 BETWEEN nvl(:pnivel_1,a.nivel_1) 
and   DECODE(:pnivel_1_1,NULL,DECODE(:pnivel_1,NULL,a.nivel_1,:pnivel_1),:pnivel_1_1) 
AND a.nivel_2 BETWEEN nvl(:pnivel_2,a.nivel_2) 
AND DECODE(:pnivel_2_2,NULL,DECODE(:pnivel_2,NULL,a.nivel_2,:pnivel_2),:pnivel_2_2) 
AND a.nivel_3 BETWEEN nvl(:pnivel_3,a.nivel_3) 
AND   DECODE(:pnivel_3_3,NULL,DECODE(:pnivel_3,NULL,a.nivel_3,:pnivel_3),:pnivel_3_3) 
 AND a.nivel_4 BETWEEN nvl(:pnivel_4,a.nivel_4) 
AND   DECODE(:pnivel_4_4,NULL,DECODE(:pnivel_4,NULL,a.nivel_4,:pnivel_4),:pnivel_4_4) 
AND  a.nivel_5 BETWEEN nvl(:pnivel_5,a.nivel_5)
 AND   DECODE(:pnivel_5_5,NULL,DECODE(:pnivel_5,NULL,a.nivel_5,:pnivel_5),:pnivel_5_5)
 AND a.nivel_6  BETWEEN nvl(:pnivel_6,a.nivel_6) 
AND   DECODE(:pnivel_6_6,NULL,DECODE(:pnivel_6,NULL,a.nivel_6,:pnivel_6),:pnivel_6_6) 
 AND a.nivel_7 BETWEEN nvl(:pnivel_7,a.nivel_7) 
AND   DECODE(:pnivel_7_7,NULL,DECODE(:pnivel_7,NULL,a.nivel_7,:pnivel_7),:pnivel_7_7)
AND a.nivel_8 BETWEEN nvl(:pnivel_8,a.nivel_8)
AND   DECODE(:pnivel_8_8,NULL,DECODE(:pnivel_8,NULL,a.nivel_8,:pnivel_8),:pnivel_8_8) 
AND c.codigo_empresa = a.codigo_empresa
AND a.nivel_1 = c.nivel_1
AND a.nivel_2 = c.nivel_2
AND a.nivel_3 = c.nivel_3
AND a.nivel_4 = c.nivel_4
AND a.nivel_5 = c.nivel_5
AND a.nivel_6 = c.nivel_6
AND c.clase_cuenta NOT IN('ENC', 'SUM') 
AND A.RECIBE_MOVIMIENTO='N' 
AND (a.saldo_actual != 0
    or  0 != ( select nvl(sum(abs(monto_movimiento)),0)
                       from gm_movimientos_detalle m
                     where m.codigo_empresa = a.codigo_empresa
                         and m.nivel_1               = a.nivel_1
                        and m.nivel_2               = a.nivel_2
                        and m.nivel_3               = a.nivel_3
                        and m.nivel_4               = a.nivel_4
                        and m.nivel_5               = a.nivel_5
                        and m.nivel_6               = a.nivel_6
                        and m.fecha_movimiento <= :p_fecha_reporte)
     )
Order by a.codigo_empresa, 
A.CUENTA


-- FUNCTIONS:

-- F_Etiqueta1
function CF_Etiqueta1Formula return VARCHAR2 is
Lv_Etiqueta	GM_Parametro_Estructura_Ctas.Descripcion_nivel_1%TYPE := NULL;
begin
  SELECT DECODE(:P_RUPTURA1, 1, descripcion_nivel_1, 2, descripcion_nivel_2, 
		3, descripcion_nivel_3, 4, descripcion_nivel_4,
		5, descripcion_nivel_5, 6, descripcion_nivel_6,
		7, descripcion_nivel_7, 8, descripcion_nivel_8,
                   descripcion_nivel_5)
  INTO Lv_Etiqueta
  FROM GM_PARAMETRO_ESTRUCTURA_CTAS
  WHERE CODIGO_EMPRESA = TO_NUMBER(:P_CODIGO_EMPRESA);
  RETURN (INITCAP(Lv_Etiqueta)||':');
  RETURN NULL; EXCEPTION
  WHEN NO_DATA_FOUND THEN
  return(NULL);
  WHEN TOO_MANY_ROWS THEN
  RETURN(NULL);
  WHEN OTHERS THEN
  RETURN(NULL);
end;


-- PU_TOTALES:
PROCEDURE PU_P_TOTALES (
Pn_CodigoEmpresa    IN NUMBER,
Pv_Nivel1           IN VARCHAR2,
Pv_Nivel2           IN VARCHAR2,
Pv_Nivel3           IN VARCHAR2,
Pv_Nivel4           IN VARCHAR2,
Pv_Nivel5           IN VARCHAR2,
Pv_Nivel6           IN VARCHAR2,
Pv_Nivel7           IN VARCHAR2,
Pv_Nivel8           IN VARCHAR2,
Pd_Fecha	    IN DATE,
Pn_Saldo_Anterior   IN NUMBER,
Pn_TotalDb          IN OUT NUMBER,
Pn_TotalCr           IN OUT NUMBER,
Pn_SaldoActual      IN OUT NUMBER) IS
Lv_NaturalezaCuenta VARCHAR2(1);
Lv_Error            VARCHAR2(200);
Lv_monto_signo      VARCHAR2(1);
BEGIN
  Pn_TotalDb := 0;
  Pn_TotalCr  := 0;
/*
SELECT SUM(DECODE(DEBITO_CREDITO,'D',DECODE(A.CODIGO_MONEDA,C.CODIGO_MONEDA_LOCAL, abs(NVL(MONTO_MOVIMIENTO,0)),
                                                                                   abs(NVL(MONTO_MOVIMIENTO_LOCAL,0))),0)) ,
      SUM(DECODE(DEBITO_CREDITO, 'C',DECODE(A.CODIGO_MONEDA,C.CODIGO_MONEDA_LOCAL, abs(NVL(MONTO_MOVIMIENTO,0)),
                                                                                   abs(NVL(MONTO_MOVIMIENTO_LOCAL,0))),0))
  INTO   Pn_TotalDb,Pn_TotaCr 
  FROM   GM_MOVIMIENTOS_DETALLE A, GM_MOVIMIENTOS_ENCABEZADO B, gm_parametros C
  WHERE  NIVEL_1             =  Pv_Nivel1          AND
         NIVEL_2             =  Pv_Nivel2          AND
         NIVEL_3             =  Pv_Nivel3          AND
         NIVEL_4             =  Pv_Nivel4          AND
         B.USUARIO           = A.USUARIO           AND
         B.NUMERO_MOVIMIENTO = A.NUMERO_MOVIMIENTO AND
         B.FECHA_MOVIMIENTO  = A.FECHA_MOVIMIENTO  AND
	 B.FECHA_VALIDA     <= Pd_Fecha            AND
         B.ACTUALIZADO       = 'N'                 AND
         A.CODIGO_EMPRESA    = C.CODIGO_EMPRESA;
*/

  For Reg in ( Select a.debito_credito,
                      a.codigo_moneda ,
                      c.codigo_moneda_local,
                      a.monto_movimiento,
                      a.monto_movimiento_local
                  FROM GM_MOVIMIENTOS_DETALLE A, GM_MOVIMIENTOS_ENCABEZADO B, gm_parametros C
                 WHERE NIVEL_1             =  Pv_Nivel1          AND
                       NIVEL_2             =  Pv_Nivel2          AND
                       NIVEL_3             =  Pv_Nivel3          AND
                       NIVEL_4             =  Pv_Nivel4          AND
                       NIVEL_5             =  Pv_Nivel5          AND
                       NIVEL_6             =  Pv_Nivel6          AND
                       B.USUARIO           = A.USUARIO           AND
                       B.NUMERO_MOVIMIENTO = A.NUMERO_MOVIMIENTO AND
                       B.FECHA_MOVIMIENTO  = A.FECHA_MOVIMIENTO  AND
    	               B.FECHA_VALIDA     <= Pd_Fecha            AND
                       B.ACTUALIZADO       = 'N'                 AND
                       A.CODIGO_EMPRESA    = C.CODIGO_EMPRESA )
  Loop 
    If Reg.debito_credito = 'D' Then
       If Reg.codigo_moneda = reg.codigo_moneda_local Then
          Pn_TotalDb := Pn_TotalDb + Nvl(Reg.monto_movimiento,0);
       Else
          Pn_TotalDb := Pn_TotalDb + Nvl(Reg.monto_movimiento_local,0);
       End If;
    Else
       If Reg.codigo_moneda = reg.codigo_moneda_local Then
          Pn_TotalCr := Pn_TotalCr + Nvl(Reg.monto_movimiento,0);
       Else
          Pn_TotalCr := Pn_TotalCr + Nvl(Reg.monto_movimiento_local,0);
       End If;
    End If;
  End Loop;

   Lv_Error := GM_F_NATURALEZA_CUENTA(Pn_CodigoEmpresa,
					Pv_Nivel1 , 
					Pv_Nivel2 ,
					Pv_Nivel3 ,
					Pv_Nivel4 ,
					Pv_nivel5,
					Pv_nivel6,
					Lv_NaturalezaCuenta);
  IF Lv_NaturalezaCuenta = 'D' THEN
     Pn_SaldoActual := NVL(Pn_Saldo_Anterior,0) + ABS(NVL(Pn_TotalDb,0)) - ABS(NVL(Pn_TotalCr,0));
  ELSIF Lv_NaturalezaCuenta = 'C' THEN
     Pn_SaldoActual := NVL(Pn_Saldo_Anterior,0) - ABS(NVL(Pn_TotalDb,0)) + ABS(NVL(Pn_TotalCr,0));
  END IF; 

    if (Pn_TotalCr < 0) then
     Pn_TotalCr := abs(Pn_TotalCr * -1);
    end if; 
END;


-- CF_SALDO_ACTUAL
function CF_SALDO_ACTUALFormula return Number is
Ln_Saldo  NUMBER(20,2);
begin
  PU_P_TOTALES(To_Number(:P_Codigo_Empresa), :nivel_1, :nivel_2,:nivel_3, :nivel_4,
		 :nivel_5, :nivel_6,:nivel_7, :nivel_8,:P_Fecha_Reporte,
		 :Cf_SaldoAnterior, :W_DEBITO, :W_CREDITO, Ln_Saldo);
  RETURN(Ln_Saldo);
end;


-- F_Saldo_Anterior1
function CF_Saldo_Ant_CalcFormula return Number is


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
  IF  ( Lv_Naturaleza_Cta = 'D')
  THEN
    RETURN (:Cf_saldoanterior);
  ELSIF ( Lv_Naturaleza_Cta = 'C') THEN
    RETURN ((:Cf_saldoanterior) * -1 );
  END IF;
RETURN NULL; end;



-- F_CS_Total_Reg_Suc1
function CF_TOTAL_REGFormula return Number is
begin
  if NVL(:W_CREDITO,0) = 0 and NVL(:W_DEBITO,0) = 0 AND NVL(:CF_SALDO_ACTUAL,0) = 0 AND NVL(:SALDO_ANTERIOR,0) = 0 THEN
  return (0);
  ELSE 
   RETURN(1);
  END IF;  
RETURN NULL; end;


-- CF_Saldo_Dia_CalcFormula
function CF_Saldo_Dia_CalcFormula return Number is
begin
declare 
  Lv_Naturaleza_Cta VARCHAR2(1);
  Lv_CodError       VARCHAR2(200):=NULL ;
  Lv_codigo_tipo varchar2(1);
begin  
   Lv_CodError := GM_F_NATURALEZA_CUENTA(:P_Codigo_Empresa,
					:nivel_1, 
					:nivel_2,
					:nivel_3,
					:nivel_4,
					:nivel_5,
					:nivel_6,
					Lv_Naturaleza_Cta);
  IF  ( Lv_Naturaleza_Cta = 'D')
  THEN
    RETURN (:cf_Saldo_Actual);
  ELSIF ( Lv_Naturaleza_Cta = 'C' ) THEN
    RETURN ((:cf_Saldo_Actual) * -1 );
  END IF;
end;
RETURN NULL; end;


-- CF_saldo_a_dFormula
function CF_saldo_a_dFormula return Number is
begin
     if :cf_saldo_dia_calc > 0 then
        :CP_SALDO_DEU:= abs(:CF_Saldo_Dia_Calc); :CP_SALDO_ACR:=0;
     ELSIF :cf_saldo_dia_calc < 0 THEN
        :CP_SALDO_ACR := abs(:CF_Saldo_Dia_Calc); :CP_SALDO_DEU:=0;
     ELSIF :cf_saldo_dia_calc = 0 THEN :CP_SALDO_ACR := 0; :CP_SALDO_DEU:=0;
     END IF;
return(0);
end;


-- cf_saldo_dia_calc