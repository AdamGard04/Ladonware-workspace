SELECT  a.NIVEL_1,a.NIVEL_2,a.NIVEL_3,a.NIVEL_4,
	a.NIVEL_5,a.NIVEL_6,a.NIVEL_7,a.NIVEL_8,
	a.DESCRIPCION, 
                a.PERMITIR_SOBREGIRO,
	a.PEDIR_AUTORIZACION_SOBREGIRO,
	a.PERMITIR_MOVIMIENTO,
	NVL(a.LIMITE_MAXIMO,0),
	NVL(a.LIMITE_MINIMO,0), d.descripcion desc_auciliar,
                a.RECIBE_MOVIMIENTO, b.CLASE_CUENTA, b.CODIGO_TIPO, C.CODIGO_AUXILIAR
FROM     GM_BALANCE_CUENTAS a, GM_CATALOGOS b, GM_BALANCE_AUXILIARES C, GM_CODIGOS_AUXILIARES D
WHERE  a.NIVEL_1 = b.NIVEL_1
AND        a.NIVEL_2 = b.NIVEL_2
AND        a.NIVEL_3 = b.NIVEL_3
AND        a.NIVEL_4 = b.NIVEL_4
AND        a.NIVEL_5 = b.NIVEL_5
AND        a.NIVEL_6 = b.NIVEL_6
AND        a.NIVEL_1 = c.NIVEL_1 (+)
AND        a.NIVEL_2 = c.NIVEL_2 (+)
AND        a.NIVEL_3 = c.NIVEL_3 (+)
AND        a.NIVEL_4 = c.NIVEL_4 (+)
AND        a.NIVEL_5 = c.NIVEL_5 (+)
AND        a.NIVEL_6 = c.NIVEL_6 (+)
AND        a.NIVEL_7 = c.NIVEL_7 (+)
AND        a.NIVEL_8 = c.NIVEL_8 (+)
AND        a.codigo_empresa = c.codigo_empresa (+)
AND        c.codigo_auxiliar = d.codigo_auxiliar (+)
AND        b.codigo_tipo = nvl( :p_codigo_tipo,b.codigo_tipo)
AND        a.nivel_1 = nvl(:p_nivel_1, a.nivel_1)
ORDER BY a.NIVEL_1,a.NIVEL_2,a.NIVEL_3,a.NIVEL_4,
	    a.NIVEL_5,a.NIVEL_6,a.NIVEL_7,a.NIVEL_8, c.codigo_auxiliar

-- Funciones
function CF_CUENTAFormula return VARCHAR2 is
BEGIN
DECLARE
  Lv_FORMATO VARCHAR(39);
begin
 GM_P_DESPLEGAR_R(:NIVEL_1,:NIVEL_2,:NIVEL_3,:NIVEL_4,:NIVEL_5,:NIVEL_6,:NIVEL_7,:NIVEL_8,:P_CODIGO_EMPRESA,Lv_FORMATO);
 RETURN(Lv_FORMATO);  
end;
RETURN NULL; END;