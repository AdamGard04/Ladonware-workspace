-- Q_DETALLE:
SELECT CODIGO_EMPRESA EMPRESA, 
 CODIGO_EMPRESA CODIGOEMPRESA, 
CODIGO_APLICACION, 
TITULO1, 
DATOS_ROMPIMIENTO1, 
 TITULO2, 
 DATOS_ROMPIMIENTO2, 
 TITULO3, 
 DATOS_ROMPIMIENTO3, 
 TITULO4, 
 DATOS_ROMPIMIENTO4,  
 TITULO5, 
 DATOS_ROMPIMIENTO5, 
 TITULO6, 
 DATOS_ROMPIMIENTO6, 
 TITULO7, 
 DATOS_ROMPIMIENTO7, NIVEL_1 NIVEL1, NIVEL_2 NIVEL2, 
 NIVEL_3 NIVEL3, NIVEL_4 NIVEL4, NIVEL_5 NIVEL5, NIVEL_6 NIVEL6, NIVEL_7 NIVEL7, 
 NIVEL_8 NIVEL8, MONTO_MOVIMIENTO, CODIGO_MONEDA MONEDA,
CODIGO_DATOS_ROMPIMIENTO1,
CODIGO_DATOS_ROMPIMIENTO2,
CODIGO_DATOS_ROMPIMIENTO3,
CODIGO_DATOS_ROMPIMIENTO4,
CODIGO_DATOS_ROMPIMIENTO5,
CODIGO_DATOS_ROMPIMIENTO6,
CODIGO_DATOS_ROMPIMIENTO7,
FECHA_MOVIMIENTO FECHAMOVIMIENTO,
FECHA_MOVIMIENTO FECHA,
 CODIGO_MONEDA MONEDA_SUBQUERY
 FROM GM_V_COMPARATIVOS
WHERE CODIGO_AGENCIA = NVL(:AGENCIA, CODIGO_AGENCIA)
AND CODIGO_SUB_APLICACION = NVL(:P_CODIGO_SUB_APLICACION, CODIGO_SUB_APLICACION)
AND FECHA_MOVIMIENTO = :P_FECHA
 order by to_number(codigo_datos_rompimiento1),
          to_number(codigo_datos_rompimiento2),
          to_number(codigo_datos_rompimiento3) 



-- Q_ENCABEZADO:
 SELECT DISTINCT b.CODIGO_EMPRESA, B.CODIGO_APLICACION APLICACION,
B.FECHA_MOVIMIENTO FECHA_MOVIMIENTO,
B.CODIGO_MONEDA MONEDA_PRINCIPAL,
SUBSTR(b.NIVEL_1,1,1) CUENTA_INICIAL,
  b.NIVEL_1     ,
  b.NIVEL_2     ,
  b.NIVEL_3     ,
  b.NIVEL_4     ,
  b.NIVEL_5     ,
  b.NIVEL_6     ,
  b.NIVEL_7     ,
  b.NIVEL_8     
FROM --GM_COMPARATIVO A,
           GM_V_COMPARATIVOS B
WHERE B.CODIGO_AGENCIA = NVL(:AGENCIA, B.CODIGO_AGENCIA)
/*AND (B.CODIGO_APLICACION = NVL(:P_COD_APLICACION, B.CODIGO_APLICACION)*/
AND (B.CODIGO_APLICACION = :P_COD_APLICACION 
         OR  :P_COD_APLICACION = 'ALL')
AND B.CODIGO_SUB_APLICACION = NVL(:P_CODIGO_SUB_APLICACION, B.CODIGO_SUB_APLICACION)
/*AND A.NIVEL_1 = NVL(:P_NIVEL1, A.NIVEL_1)
AND A.NIVEL_2 = NVL(:P_NIVEL2, A.NIVEL_2)
AND A.NIVEL_1 = B.NIVEL_1
AND A.NIVEL_2 = B.NIVEL_2
AND A.NIVEL_3 = B.NIVEL_3
AND A.NIVEL_4 = B.NIVEL_4
AND A.NIVEL_5 = B.NIVEL_5
AND A.NIVEL_6 = B.NIVEL_6
AND A.NIVEL_7 = B.NIVEL_7
AND A.NIVEL_8 = B.NIVEL_8*/
AND b.FECHA_MOVIMIENTO = :P_FECHA
order by 4,5, 6,7,8,9,10,11,12,13



-- funciones:
-- F_nombre_aplicacion
function CF_NOMBRE_APLICACIONFormula return Char is
Lv_nombre varchar2(90);
begin
	Begin
		Select nombre
		into Lv_nombre
		from mg_aplicaciones
		where codigo_aplicacion = :aplicacion;
	Exception
		when others then null;
	End;
	
	return(lv_nombre);
end;



-- F_descripcion_moneda
function CF_DESCRIPCION_MONEDAFormula return Char is
Lv_informacion_campo varchar(90);
begin
         BEGIN
               SELECT descripcion
            INTO Lv_informacion_campo
            FROM MG_MONEDAS
            WHERE codigo_moneda = :moneda_principal;
       EXCEPTION
                   WHEN OTHERS THEN Lv_informacion_campo:= NULL;
        END;
   return(Lv_informacion_campo);
end;



-- F_tipo_cuenta
FUNCTION cf_tipo_cuentaformula
   RETURN CHAR IS
   lv_nivel_1                    VARCHAR (4);
   lv_nivel_2                    VARCHAR (4);
   lv_nivel_3                    VARCHAR (4);
   lv_nivel_4                    VARCHAR (4);
   lv_nivel_5                    VARCHAR (4);
   lv_nivel_6                    VARCHAR (4);
   lv_nivel_7                    VARCHAR (4);
   lv_nivel_8                    VARCHAR (4);
   lv_nombre_cuenta              VARCHAR (100);
BEGIN
   BEGIN
      SELECT nivel_1, nivel_2, nivel_3, nivel_4, nivel_5, nivel_6, nivel_7, nivel_8
        INTO lv_nivel_1, lv_nivel_2, lv_nivel_3, lv_nivel_4, lv_nivel_5, lv_nivel_6, lv_nivel_7,
             lv_nivel_8
        FROM (SELECT   nivel_1, nivel_2, nivel_3, nivel_4, nivel_5, nivel_6, nivel_7, nivel_8
                  FROM gm_balance_cuentas
                 WHERE SUBSTR (nivel_1, 1, 1) = :cuenta_inicial
              ORDER BY 1, 2, 3, 4, 5, 6, 7, 8)
       WHERE ROWNUM = 1;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   BEGIN
      SELECT descripcion
        INTO lv_nombre_cuenta
        FROM gm_balance_cuentas
       WHERE nivel_1 = lv_nivel_1 AND
             nivel_2 = lv_nivel_2 AND
             nivel_3 = lv_nivel_3 AND
             nivel_4 = lv_nivel_4 AND
             nivel_5 = lv_nivel_5 AND
             nivel_6 = lv_nivel_6 AND
             nivel_7 = lv_nivel_7 AND
             nivel_8 = lv_nivel_8;
   EXCEPTION
      WHEN OTHERS THEN
         lv_nombre_cuenta:=sqlerrm;
   END;

   RETURN (lv_nombre_cuenta);
END;



-- F_CTA1
function CF_CTAFormula return Char is
Pv_Formato VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(:nivel_1, :nivel_2, :nivel_3, :nivel_4, :nivel_5,
      :nivel_6, :nivel_7, :nivel_8,:CODIGO_EMPRESA, Pv_Formato);
  RETURN(Pv_Formato);
end;



-- F_MONTO10
function CF_BALANCE_MAYOR_EXTFormula return Number is
Ln_monto number := 0;
Begin
	Begin
		Select (CASE
      WHEN NVL(A.BALANCE_MAYOR_EXT,0) = 0 THEN  A.BALANCE_MAYOR
 			ELSE  A.BALANCE_MAYOR_EXT
 			END )
		Into Ln_Monto
		FROM GM_COMPARATIVO A
		WHERE A.NIVEL_1 = :NIVEL_1
		AND A.NIVEL_2 = :NIVEL_2
		AND A.NIVEL_3 = :NIVEL_3
		AND A.NIVEL_4 = :NIVEL_4
		AND A.NIVEL_5 = :NIVEL_5
		AND A.NIVEL_6 = :NIVEL_6
		AND A.NIVEL_7 = :NIVEL_7
		AND A.NIVEL_8 = :NIVEL_8
		AND a.FECHA_MOVIMIENTO = :FECHA_MOVIMIENTO;
	Exception
		when others then null;
	End;
	
	return(Ln_Monto);
	
  
end;



-- F_MONTO2
function CF_BALANCE_MAYORFormula return Number IS
Ln_monto number := 0;
Begin
	Begin
		Select NVL(A.BALANCE_MAYOR, 0)   BALANCE_MAYOR
		Into Ln_Monto
		FROM GM_COMPARATIVO A
		WHERE A.NIVEL_1 = :NIVEL_1
		AND A.NIVEL_2 = :NIVEL_2
		AND A.NIVEL_3 = :NIVEL_3
		AND A.NIVEL_4 = :NIVEL_4
		AND A.NIVEL_5 = :NIVEL_5
		AND A.NIVEL_6 = :NIVEL_6
		AND A.NIVEL_7 = :NIVEL_7
		AND A.NIVEL_8 = :NIVEL_8
		AND a.FECHA_MOVIMIENTO = :FECHA_MOVIMIENTO;
	Exception
		when others then null;
	End;
	
	return(Ln_Monto);
	
  
end;



-- F_MONTO1
function CF_1Formula return Number is
Ln_monto number := 0;
Begin
	Ln_monto := :cf_balance_mayor - :cs_1;
	return(Ln_monto);
end;



-- F_DESCRIPCION_CTA1
function CF_DESCRIPCION_CTAFormula return Char is
DESCRIPCIONCUENTA VARCHAR2(80);
begin
  SELECT DESCRIPCION
    INTO DESCRIPCIONCUENTA
    FROM GM_BALANCE_CUENTAS
  WHERE CODIGO_EMPRESA = :CODIGO_EMPRESA
    AND NIVEL_1        = :NIVEL_1
    AND NIVEL_2        = :NIVEL_2
    AND NIVEL_3        = :NIVEL_3
    AND NIVEL_4        = :NIVEL_4
    AND NIVEL_5        = :NIVEL_5
    AND NIVEL_6        = :NIVEL_6
    AND NIVEL_7        = :NIVEL_7
    AND NIVEL_8        = :NIVEL_8;
  RETURN(DESCRIPCIONCUENTA);
RETURN NULL; EXCEPTION
WHEN NO_DATA_FOUND THEN
   RETURN(DESCRIPCIONCUENTA);
end;



-- F_MONTO_LOCAL1
function CF_MONTO_MONEDA_LOCALFormula return Number is

Ln_codigo_moneda_local number(2);
Ln_monto_destino       number := 0;
Gn_TasaCambioorigen    number;
Gn_TasaCambiodestino   number;
Gn_Factortasa          number;
Gn_diferenciacambio	   number;
Gn_Gananciaperdida	   number;
Gv_MensajeError        varchar2(100);
Gd_FechaCambioorigen   date;
begin
	Begin
		Select codigo_moneda_local
		into Ln_codigo_moneda_local
		from mg_parametros_generales
		where codigo_empresa = :codigoempresa;
	Exception
		when others then 
			Ln_codigo_moneda_local := 1;
	End;
	Gd_FechaCambioorigen := :fecha;
	
  Mg_P_Cambiomoneda(:CodigoEmpresa,
						:MONEDA, --Gn_CodigoMonedaorigen 	IN 	NUMBER,
						Ln_codigo_moneda_local,
						1, --Gn_TipoCambio   		IN 	NUMBER,
							--  1 = contable
							--  2 = Compra
							--  3 = Venta
							--- 4 = Compra Oficial
						Gd_FechaCambioorigen,
						:p_fecha,
		  			Gn_TasaCambioorigen  ,
		  			Gn_TasaCambiodestino ,
						Gn_Factortasa   		 ,
						:Monto_movimiento    ,
						Ln_Monto_Destino     ,
						Gn_diferenciacambio	 ,
						Gn_Gananciaperdida	 ,
						Gv_MensajeError 		 );
	
	--Ln_Monto_Destino     := :Monto_movimiento;
						
	return(Ln_monto_destino);
end;