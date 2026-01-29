SELECT a.nivel_1, a.nivel_2, a.nivel_3, a.nivel_4, a.nivel_5, a.nivel_6, a.nivel_7, a.nivel_8, 
          --    d.descripcion, 
          debito_credito, decode(debito_credito,'D',monto_movimiento) F_DEBITO,
              decode(debito_credito,'C',abs(monto_movimiento)) F_CREDITO,
              monto_movimiento,
              a.codigo_auxiliar, A.fecha_valida,  DECODE(A.CODIGO_MONEDA,E.CODIGO_MONEDA_LOCAL,A.MONTO_MOVIMIENTO,A.MONTO_MOVIMIENTO_LOCAL) MONTO,
              a.usuario, a.numero_movimiento, a.codigo_unidad, a.fecha_movimiento, a.codigo_moneda, 
              a.descripcion_detalle  desc_detalle, a.tasa_cambio,
a.monto_movimiento_local, E.CODIGO_MONEDA_LOCAL,
              a.referencia, a.codigo_auxiliar_ref,
  a.codigo_presupuesto,a.clase_presupuesto

FROM   gm_movimientos_anual_detalle a, 
     --        gm_catalogos d , 
             GM_PARAMETROS E
WHERE  a.fecha_valida  >=   :p_fecha_reporte  AND a.fecha_valida <=  :p_fecha_final
AND  a.nivel_1 BETWEEN nvl(:pnivel_1,a.nivel_1) 
AND DECODE(:pnivel_1_1,NULL,DECODE(:pnivel_1,NULL,a.nivel_1,:pnivel_1),:pnivel_1_1) 
AND a.nivel_2 BETWEEN nvl(:pnivel_2,a.nivel_2) 
AND DECODE(:pnivel_2_2,NULL,DECODE(:pnivel_2,NULL,a.nivel_2,:pnivel_2),:pnivel_2_2) 
AND a.nivel_3 BETWEEN nvl(:pnivel_3,a.nivel_3) 
AND DECODE(:pnivel_3_3,NULL,DECODE(:pnivel_3,NULL,a.nivel_3,:pnivel_3),:pnivel_3_3) 
AND a.nivel_4 BETWEEN nvl(:pnivel_4,a.nivel_4) 
AND DECODE(:pnivel_4_4,NULL,DECODE(:pnivel_4,NULL,a.nivel_4,:pnivel_4),:pnivel_4_4) 
AND a.nivel_5 BETWEEN nvl(:pnivel_5,a.nivel_5)
AND DECODE(:pnivel_5_5,NULL,DECODE(:pnivel_5,NULL,a.nivel_5,:pnivel_5),:pnivel_5_5)
AND a.nivel_6  BETWEEN nvl(:pnivel_6,a.nivel_6) 
AND DECODE(:pnivel_6_6,NULL,DECODE(:pnivel_6,NULL,a.nivel_6,:pnivel_6),:pnivel_6_6) 
AND a.nivel_7 BETWEEN nvl(:pnivel_7,a.nivel_7) 
AND DECODE(:pnivel_7_7,NULL,DECODE(:pnivel_7,NULL,a.nivel_7,:pnivel_7),:pnivel_7_7)
AND a.nivel_8 BETWEEN nvl(:pnivel_8,a.nivel_8) 
AND DECODE(:pnivel_8_8,NULL,DECODE(:pnivel_8,NULL,a.nivel_8,:pnivel_8),:pnivel_8_8) 
AND a.codigo_empresa =  :p_codigo_empresa
/*AND d.nivel_1 = a.nivel_1
AND d.nivel_2 = a.nivel_2
AND d.nivel_3 = a.nivel_3
AND d.nivel_4 = a.nivel_4
AND d.nivel_5 = a.nivel_5
AND d.nivel_6 = a.nivel_6
AND d.nivel_7 = a.nivel_7
AND d.nivel_8 = a.nivel_8 
AND d.codigo_empresa  = a.codigo_empresa */
AND ( a.codigo_auxiliar = nvl(:P_CODIGO_AUXILIAR, a.codigo_auxiliar)  OR  a.codigo_auxiliar IS NULL)  
AND a.usuario = nvl(:p_usuario,a.usuario)
AND ( a.codigo_auxiliar_ref = :p_auxiliar_ref     OR    :p_auxiliar_ref is null)
AND a.codigo_moneda = nvl(:p_moneda,a.codigo_moneda)
AND e.codigo_empresa = a.codigo_empresa
Order by a.nivel_1,a.nivel_2,a.nivel_3,a.nivel_4, a.nivel_5,a.nivel_6,a.nivel_7,a.nivel_8,a.codigo_moneda,a.fecha_valida, a.fecha_movimiento, a.usuario,a.numero_movimiento,a.secuencia_renglon
