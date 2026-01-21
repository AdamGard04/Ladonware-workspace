SELECT   Decode(:p_ruptura1,1,a.nivel_1,2,a.nivel_2,3,a.nivel_3,4,a.nivel_4,5,a.nivel_5,6,a.nivel_6,
                7,a.nivel_7,8,a.nivel_8)ruptura1,
                 a.nivel_1, a.nivel_2, a.nivel_3, a.nivel_4, a.nivel_5, a.nivel_6, a.nivel_7, a.nivel_8, a.descripcion,
(b.TOTAL_DB_MES_1+b.TOTAL_DB_MES_2+b.TOTAL_DB_MES_3+b.TOTAL_DB_MES_4                +b.TOTAL_DB_MES_5+b.TOTAL_DB_MES_6+b.TOTAL_DB_MES_7+b.TOTAL_DB_MES_8+b.TOTAL_DB_MES_9+b.TOTAL_DB_MES_10+b.TOTAL_DB_MES_11+b.TOTAL_DB_MES_12) total_db,
(b.TOTAL_CR_MES_1+b.TOTAL_CR_MES_2+b.TOTAL_CR_MES_3+b.TOTAL_CR_MES_4                 +b.TOTAL_CR_MES_5+b.TOTAL_CR_MES_6+b.TOTAL_CR_MES_7+b.TOTAL_CR_MES_8+b.TOTAL_CR_MES_9+b.TOTAL_CR_MES_10+b.TOTAL_CR_MES_11+b.TOTAL_CR_MES_12) total_cr,
                 DECODE(:P_MESINI,1,b.TOTAL_DB_MES_1,2,b.TOTAL_DB_MES_2,3,b.TOTAL_DB_MES_3,4,b.TOTAL_DB_MES_4,
                 5,b.TOTAL_DB_MES_5,6,b.TOTAL_DB_MES_6,7,b.TOTAL_DB_MES_7,8,b.TOTAL_DB_MES_8,9,b.TOTAL_DB_MES_9,10,b.TOTAL_DB_MES_10,
                 11,b.TOTAL_DB_MES_11,12,b.TOTAL_DB_MES_12) DB_MES1,

DECODE(:P_MESINI,1,b.TOTAL_CR_MES_1,2,b.TOTAL_CR_MES_2,3,b.TOTAL_CR_MES_3,4,b.TOTAL_CR_MES_4,
                 5,b.TOTAL_CR_MES_5,6,b.TOTAL_CR_MES_6,7,b.TOTAL_CR_MES_7,8,b.TOTAL_CR_MES_8,9,b.TOTAL_CR_MES_9,10,b.TOTAL_CR_MES_10,
                 11,b.TOTAL_CR_MES_11,12,b.TOTAL_CR_MES_12) CR_MES1,

                 DECODE(DECODE(:P_MESINI-1,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_DB_MES_1,2,b.TOTAL_DB_MES_2,3,b.TOTAL_DB_MES_3,4,b.TOTAL_DB_MES_4,
                 5,b.TOTAL_DB_MES_5,6,b.TOTAL_DB_MES_6,7,b.TOTAL_DB_MES_7,8,b.TOTAL_DB_MES_8,9,b.TOTAL_DB_MES_9,10,b.TOTAL_DB_MES_10,
                 11,b.TOTAL_DB_MES_11,12,b.TOTAL_DB_MES_12) DB_MES2,

DECODE(DECODE(:P_MESINI-1,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_CR_MES_1,2,b.TOTAL_CR_MES_2,3,b.TOTAL_CR_MES_3,4,b.TOTAL_CR_MES_4,
                 5,b.TOTAL_CR_MES_5,6,b.TOTAL_CR_MES_6,7,b.TOTAL_CR_MES_7,8,b.TOTAL_CR_MES_8,9,b.TOTAL_CR_MES_9,10,b.TOTAL_CR_MES_10,
                 11,b.TOTAL_CR_MES_11,12,b.TOTAL_CR_MES_12) CR_MES2,
            DECODE(DECODE(:P_MESINI-2,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_DB_MES_1,2,b.TOTAL_DB_MES_2,3,b.TOTAL_DB_MES_3,4,b.TOTAL_DB_MES_4,
                 5,b.TOTAL_DB_MES_5,6,b.TOTAL_DB_MES_6,7,b.TOTAL_DB_MES_7,8,b.TOTAL_DB_MES_8,9,b.TOTAL_DB_MES_9,10,b.TOTAL_DB_MES_10,
                 11,b.TOTAL_DB_MES_11,12,b.TOTAL_DB_MES_12) DB_MES3,

DECODE(DECODE(:P_MESINI-2,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_CR_MES_1,2,b.TOTAL_CR_MES_2,3,b.TOTAL_CR_MES_3,4,b.TOTAL_CR_MES_4,
                 5,b.TOTAL_CR_MES_5,6,b.TOTAL_CR_MES_6,7,b.TOTAL_CR_MES_7,8,b.TOTAL_CR_MES_8,9,b.TOTAL_CR_MES_9,10,b.TOTAL_CR_MES_10,
                 11,b.TOTAL_CR_MES_11,12,b.TOTAL_CR_MES_12) CR_MES3,

                  DECODE(DECODE(:P_MESINI-3,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_DB_MES_1,2,b.TOTAL_DB_MES_2,3,b.TOTAL_DB_MES_3,4,b.TOTAL_DB_MES_4,                 5,b.TOTAL_DB_MES_5,6,b.TOTAL_DB_MES_6,7,b.TOTAL_DB_MES_7,8,b.TOTAL_DB_MES_8,9,b.TOTAL_DB_MES_9,10,b.TOTAL_DB_MES_10,
                 11,b.TOTAL_DB_MES_11,12,b.TOTAL_DB_MES_12) DB_MES4,

                  DECODE(DECODE(:P_MESINI-3,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_CR_MES_1,2,b.TOTAL_CR_MES_2,3,b.TOTAL_CR_MES_3,4,b.TOTAL_CR_MES_4,
                 5,b.TOTAL_CR_MES_5,6,b.TOTAL_CR_MES_6,7,b.TOTAL_CR_MES_7,8,b.TOTAL_CR_MES_8,9,b.TOTAL_CR_MES_9,10,b.TOTAL_CR_MES_10,
                 11,b.TOTAL_CR_MES_11,12,b.TOTAL_CR_MES_12) CR_MES4,

                 DECODE(DECODE(:P_MESINI-4,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_DB_MES_1,2,b.TOTAL_DB_MES_2,3,b.TOTAL_DB_MES_3,4,b.TOTAL_DB_MES_4,
                 5,b.TOTAL_DB_MES_5,6,b.TOTAL_DB_MES_6,7,b.TOTAL_DB_MES_7,8,b.TOTAL_DB_MES_8,9,b.TOTAL_DB_MES_9,10,b.TOTAL_DB_MES_10,
                 11,b.TOTAL_DB_MES_11,12,b.TOTAL_DB_MES_12) DB_MES5,

                 DECODE(DECODE(:P_MESINI-4,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12),1,b.TOTAL_CR_MES_1,2,b.TOTAL_CR_MES_2,3,b.TOTAL_CR_MES_3,4,b.TOTAL_CR_MES_4,
                 5,b.TOTAL_CR_MES_5,6,b.TOTAL_CR_MES_6,7,b.TOTAL_CR_MES_7,8,b.TOTAL_CR_MES_8,9,b.TOTAL_CR_MES_9,10,b.TOTAL_CR_MES_10,
                 11,b.TOTAL_CR_MES_11,12,b.TOTAL_CR_MES_12) CR_MES5,d.TOTAL_DB_DIA_1,d.TOTAL_DB_DIA_2,d.TOTAL_DB_DIA_3,d.TOTAL_DB_DIA_4,d.TOTAL_DB_DIA_5,d.TOTAL_DB_DIA_6,d.TOTAL_DB_DIA_7,d.TOTAL_DB_DIA_8,d.TOTAL_DB_DIA_9,d.TOTAL_DB_DIA_10,d.TOTAL_DB_DIA_11,d.TOTAL_DB_DIA_12,d.TOTAL_DB_DIA_13,d.TOTAL_DB_DIA_14,d.TOTAL_DB_DIA_15,d.TOTAL_DB_DIA_16,d.TOTAL_DB_DIA_17,d.TOTAL_DB_DIA_18,d.TOTAL_DB_DIA_19,d.TOTAL_DB_DIA_20,d.TOTAL_DB_DIA_21,d.TOTAL_DB_DIA_22,d.TOTAL_DB_DIA_23,TOTAL_DB_DIA_24,d.TOTAL_DB_DIA_25,d.TOTAL_DB_DIA_26,d.TOTAL_DB_DIA_27,d.TOTAL_DB_DIA_28,d.TOTAL_DB_DIA_29,d.TOTAL_DB_DIA_30,d.TOTAL_DB_DIA_31,d.TOTAL_CR_DIA_1,d.TOTAL_CR_DIA_2,d.TOTAL_CR_DIA_3,d.TOTAL_CR_DIA_4,d.TOTAL_CR_DIA_5,d.TOTAL_CR_DIA_6,d.TOTAL_CR_DIA_7,d.TOTAL_CR_DIA_8,d.TOTAL_CR_DIA_9,d.TOTAL_CR_DIA_10,d.TOTAL_CR_DIA_11,d.TOTAL_CR_DIA_12,d.TOTAL_CR_DIA_13,d.TOTAL_CR_DIA_14,d.TOTAL_CR_DIA_15,d.TOTAL_CR_DIA_16,d.TOTAL_CR_DIA_17,d.TOTAL_CR_DIA_18,d.TOTAL_CR_DIA_19,d.TOTAL_CR_DIA_20,d.TOTAL_CR_DIA_21,d.TOTAL_CR_DIA_22,d.TOTAL_CR_DIA_23,d.TOTAL_CR_DIA_24,d.TOTAL_CR_DIA_25,d.TOTAL_CR_DIA_26,d.TOTAL_CR_DIA_27,d.TOTAL_CR_DIA_28,d.TOTAL_CR_DIA_29,d.TOTAL_CR_DIA_30,d.TOTAL_CR_DIA_31,E.CANTIDAD_DIG_NIVEL_1, E.CANTIDAD_DIG_NIVEL_2 ,E.CANTIDAD_DIG_NIVEL_3,E.CANTIDAD_DIG_NIVEL_4,E.CANTIDAD_DIG_NIVEL_5,E.CANTIDAD_DIG_NIVEL_6,
E.CANTIDAD_DIG_NIVEL_7,E.CANTIDAD_DIG_NIVEL_8,E.USAR_SEPARADOR_NIVEL_1 ,
E.USAR_SEPARADOR_NIVEL_2 ,
E.USAR_SEPARADOR_NIVEL_3 ,
E.USAR_SEPARADOR_NIVEL_4 ,
E.USAR_SEPARADOR_NIVEL_5 ,
E.USAR_SEPARADOR_NIVEL_6 ,
E.USAR_SEPARADOR_NIVEL_7 ,
E.USAR_SEPARADOR_NIVEL_8 ,
E.SEPARADOR              ,
F.SIGNO 

FROM    gm_balance_cuentas a, 
               gm_saldos_mensuales b,
              gm_saldos_diarios d,
              gm_catalogos c,
              GM_PARAMETRO_ESTRUCTURA_CTAS E,
               GM_TIPOS_DE_CUENTAS F
WHERE  a.nivel_1 BETWEEN nvl(:pnivel_1,a.nivel_1) 
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
and d.mes (+)  = :p_mes
and Decode(:p_ruptura1,1,a.nivel_1,2,a.nivel_2,3,a.nivel_3,4,a.nivel_4,5,a.nivel_5,6,a.nivel_6,
                7,a.nivel_7,8,a.nivel_8) = nvl(:P_RUPTURA,Decode(:p_ruptura1,1,a.nivel_1,2,a.nivel_2,3,a.nivel_3,4,a.nivel_4,5,a.nivel_5,6,a.nivel_6,
                7,a.nivel_7,8,a.nivel_8))
and  a.codigo_empresa          = c.codigo_empresa
and  c.codigo_empresa          = e.codigo_empresa
AND e.CODIGO_EMPRESA  = :P_CODIGO_EMPRESA
AND f.CODIGO_EMPRESA  = e.CODIGO_EMPRESA
AND f.CODIGO_TIPO           = c.CODIGO_TIPO
and  b.codigo_empresa (+) = a.codigo_empresa
and  b.nivel_1(+)                = a.nivel_1
AND b.nivel_2(+)                = a.nivel_2
AND b.nivel_3(+)                = a.nivel_3
AND b.nivel_4(+)                = a.nivel_4
AND b.nivel_5(+)                = a.nivel_5
AND b.nivel_6(+)                = a.nivel_6
AND b.nivel_7(+)                = a.nivel_7
AND b.nivel_8(+)                = a.nivel_8
--
and  d.codigo_empresa (+) = a.codigo_empresa
AND d.nivel_1(+)              = a.nivel_1
AND d.nivel_2(+)              = a.nivel_2
AND d.nivel_3(+)              = a.nivel_3
AND d.nivel_4(+)              = a.nivel_4
AND d.nivel_5(+)              = a.nivel_5
AND d.nivel_6(+)              = a.nivel_6
AND d.nivel_7(+)             = a.nivel_7
AND d.nivel_8(+)             = a.nivel_8
--
and a.nivel_1 = c.nivel_1
and a.nivel_2 = c.nivel_2
and a.nivel_3 = c.nivel_3
and a.nivel_4 = c.nivel_4
and a.nivel_5 = c.nivel_5
and a.nivel_6 = c.nivel_6
and c.nivel_1 between 400 and 599
and b.anio(+) =  to_number(nvl(:P_ANIO,to_char(:p_fecha_reporte,'YYYY')))
AND d.anio (+) = to_number(nvl(:P_ANIO,to_char(:p_fecha_reporte,'YYYY')))
and a.recibe_movimiento = 'S'
AND c.clase_cuenta NOT IN ('ENC','SUM')
ORDER BY A.cuenta



