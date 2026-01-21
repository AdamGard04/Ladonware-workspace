-- Q_1:
SELECT  A.NIVEL_1,A.NIVEL_2,A.NIVEL_3,A.NIVEL_4,
               A.NIVEL_5,A.NIVEL_6,A.NIVEL_7,A.NIVEL_8,              
              DECODE(:PARA_MES,1,A.SALDO_MES_1,
              2,A.SALDO_MES_2,3,A.SALDO_MES_3,
              4,A.SALDO_MES_4,5,A.SALDO_MES_5,
              6,A.SALDO_MES_6,7,A.SALDO_MES_7,
              8,A.SALDO_MES_8,9,A.SALDO_MES_9,
              10,A.SALDO_MES_10,11,A.SALDO_MES_11,
              12,A.SALDO_MES_12) SALDO, B.DESCRIPCION, C.CODIGO_TIPO
FROM    GM_SALDOS_MENSUALES A,
              GM_BALANCE_CUENTAS    B,
              GM_CATALOGOS C
WHERE a.nivel_1 BETWEEN nvl(:pnivel_1,a.nivel_1) AND          DECODE(:pnivel_1_1,NULL,DECODE(:pnivel_1,NULL,a.nivel_1,:pnivel_1),:pnivel_1_1) 
AND a.nivel_2 BETWEEN nvl(:pnivel_2,a.nivel_2) AND    DECODE(:pnivel_2_2,NULL,DECODE(:pnivel_2,NULL,a.nivel_2,:pnivel_2),:pnivel_2_2) 
AND a.nivel_3 BETWEEN nvl(:pnivel_3,a.nivel_3) AND   DECODE(:pnivel_3_3,NULL,DECODE(:pnivel_3,NULL,a.nivel_3,:pnivel_3),:pnivel_3_3) 
 AND a.nivel_4 BETWEEN nvl(:pnivel_4,a.nivel_4) AND   DECODE(:pnivel_4_4,NULL,DECODE(:pnivel_4,NULL,a.nivel_4,:pnivel_4),:pnivel_4_4) 
AND  a.nivel_5 BETWEEN nvl(:pnivel_5,a.nivel_5) AND   DECODE(:pnivel_5_5,NULL,DECODE(:pnivel_5,NULL,a.nivel_5,:pnivel_5),:pnivel_5_5)
 AND a.nivel_6  BETWEEN nvl(:pnivel_6,a.nivel_6) AND   DECODE(:pnivel_6_6,NULL,DECODE(:pnivel_6,NULL,a.nivel_6,:pnivel_6),:pnivel_6_6) 
 AND a.nivel_7 BETWEEN nvl(:pnivel_7,a.nivel_7) AND   DECODE(:pnivel_7_7,NULL,DECODE(:pnivel_7,NULL,a.nivel_7,:pnivel_7),:pnivel_7_7)
 AND a.nivel_8 BETWEEN nvl(:pnivel_8,a.nivel_8) AND   DECODE(:pnivel_8_8,NULL,DECODE(:pnivel_8,NULL,a.nivel_8,:pnivel_8),:pnivel_8_8) 
AND B.NIVEL_1=A.NIVEL_1
AND B.NIVEL_2=A.NIVEL_2
AND B.NIVEL_3=A.NIVEL_3
AND B.NIVEL_4=A.NIVEL_4
AND B.NIVEL_5=A.NIVEL_5
AND B.NIVEL_6=A.NIVEL_6
AND B.NIVEL_7=A.NIVEL_7
AND B.NIVEL_8=A.NIVEL_8
AND  A.ANIO=:PARA_ANIO 
AND A.codigo_empresa = B.codigo_empresa
AND B.codigo_empresa = C.codigo_empresa
and   b.recibe_movimiento = 'S'
AND a.nivel_1 = c.nivel_1 
AND a.nivel_2 = c.nivel_2 
AND a.nivel_3 = c.nivel_3 
AND a.nivel_4 = c.nivel_4
AND a.nivel_5 = c.nivel_5 
AND a.nivel_6 = c.nivel_6
AND c.codigo_empresa  = :p_codigo_empresa 
ORDER BY 1,2,3,4,5,6,7,8

-- funciones:

--F_CF_FORMULA
function CF_1Formula return VARCHAR2 is
PV_FORMATO VARCHAR2(39);
begin
GM_P_DESPLEGAR_R(:NIVEL_1,:NIVEL_2,:NIVEL_3,:NIVEL_4,:NIVEL_5,:NIVEL_6,
                :NIVEL_7,:NIVEL_8,:p_codigo_empresa,PV_FORMATO);
 RETURN (PV_FORMATO); 
end;

