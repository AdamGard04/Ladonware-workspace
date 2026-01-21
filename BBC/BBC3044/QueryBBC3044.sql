-- Q_Cuentas
    SELECT  a.nivel_1, a.nivel_2, a.nivel_3, a.nivel_4, a.nivel_5, a.nivel_6, a.nivel_7, a.nivel_8, a.debito_credito,abs(a.monto_movimiento) monto_mov,a.codigo_auxiliar,  a.secuencia_renglon,b.usuario,b.numero_movimiento,b.fecha_movimiento, b.fecha_valida,a.referencia,
    DECODE(A.DEBITO_CREDITO,'D',DECODE(A.CODIGO_MONEDA,D.CODIGO_MONEDA_LOCAL,A.MONTO_MOVIMIENTO,A.MONTO_MOVIMIENTO_LOCAL)) MONTO_DEBITO,
    DECODE(A.DEBITO_CREDITO,'C',DECODE(A.CODIGO_MONEDA,D.CODIGO_MONEDA_LOCAL,A.MONTO_MOVIMIENTO,A.MONTO_MOVIMIENTO_LOCAL)) MONTO_CREDITO,
    DECODE(A.DEBITO_CREDITO,'D',A.MONTO_MOVIMIENTO) MONTO_DEBITO_MON,
    DECODE(A.DEBITO_CREDITO,'C',A.MONTO_MOVIMIENTO) MONTO_CREDITO_MON,
    b.descripcion desc_enc,A.codigo_moneda,c.descripcion desc_moneda,a.descripcion  desc_detalle, b.fecha_movimiento,DECODE(A.CODIGO_MONEDA,D.CODIGO_MONEDA_LOCAL,B.TOTAL_CONTROL,B.TOTAL_CONTROL
    *nvl(a.tasa_cambio,1)) total_control,b.codigo_unidad,decode(A.tasa_cambio,null,1,A.tasa_cambio) tasa_cambio,
    centro_de_costo,
    codigo_presupuesto,
    clase_presupuesto,codigo_auxiliar,
    decode(b.tasa_cambio,null,1,b.tasa_cambio) tasa_cambio_enc, b.codigo_agencia, a.aplicacion_concepto, a.transaccion_concepto
    FROM  bc_comprobantes b,
                bc_comprobantes_detalles a, 
                mg_monedas c, 
                MG_PARAMETROS_GENERALES D
    WHERE b.codigo_empresa         = To_number(:p_codigo_empresa)
        AND a.usuario                       = b.usuario
        AND a.numero_movimiento   = b.numero_movimiento
        AND a.fecha_movimiento      = b.fecha_movimiento  
        AND c.codigo_moneda       = a.codigo_moneda
        AND d.codigo_empresa = b.codigo_empresa
    Order by  b.usuario,b.numero_movimiento,b.fecha_movimiento, a.aplicacion_concepto, a.transaccion_concepto, a.secuencia_renglon

-- Q_SUCURSALES
    select      
        ABS(SUM(DECODE(A.DEBITO_CREDITO,'D',DECODE(A.CODIGO_MONEDA,D.CODIGO_MONEDA_LOCAL,
                A.MONTO_MOVIMIENTO,A.MONTO_MOVIMIENTO_LOCAL)))) sum_db,
            ABS(SUM(DECODE(A.DEBITO_CREDITO,'C',DECODE(A.CODIGO_MONEDA,D.CODIGO_MONEDA_LOCAL,
                abs(A.MONTO_MOVIMIENTO),abs(A.MONTO_MOVIMIENTO_LOCAL))))) sum_cr
        FROM bc_comprobantes b,   bc_comprobantes_detalles a,
                mg_monedas   c,
                    gm_parametros d
        WHERE b.codigo_empresa         = To_number(:p_codigo_empresa)
            AND a.usuario                       = b.usuario
            AND a.numero_movimiento   = b.numero_movimiento
            AND a.fecha_movimiento      = b.fecha_movimiento  
            AND c.codigo_moneda       = a.codigo_moneda
            AND d.codigo_empresa = b.codigo_empresa

