-- Q_CA_BALANCE_DE_CUENTAS
SELECT A.CODIGO_EMPRESA, A.CODIGO_AGENCIA, A.CODIGO_SUBAPLICACION,
       A.NUMERO_CUENTA, A.CODIGO_AGENCIA AGENCIA,
       A.CODIGO_SUBAPLICACION SUBAPLICACION,
      nvl(A.SALDO_TOTAL,0) SALDO_TOTAL, NVL(A.INTERESES_ACUMULADOS,0) INTERESES_ACUMULADOS, NVL(A.INTERESES_DEL_MES,0) INTERESES_DEL_MES,
NVL( A.INTERES_X_IMPUESTO_MES,0) INTERES_X_IMPUESTO_MES, NVL(A.INTERES_X_IMPUESTO_ACUMULADO,0) INTERES_X_IMPUESTO_ACUMULADO,
       C.NOMBRE_AGENCIA,
       D.DESCRIPCION,   (decode(e.debito_credito_otro,'D',nvl(f.valor,0),0)) SUMA_DEBITOS,
       (decode(e.debito_credito_otro,'C',nvl(f.valor,0),0)) SUMA_CREDITOS
FROM   CA_CUENTAS_DE_AHORRO A, AGENCIAS C, SUB_APLICACIONES D,
               ca_movimientos_pendientes f,         tipos_de_transacciones E
WHERE a.codigo_empresa = f.codigo_empresa(+)
and a.codigo_agencia = f.codigo_agencia(+)
and a.codigo_subaplicacion = f.codigo_subaplicacion(+)
and a.numero_cuenta = f.numero_cuenta
and f.codigo_aplicacion = e.codigo_aplicacion
and f.codigo_tipo_transaccion  = e.codigo_tipo_transaccion
and f.impreso = 'N'  
and  A.CODIGO_EMPRESA =  :CODIGO_EMPRESA_P
AND    (a.codigo_agencia = :CODIGO_AGENCIA_P
          or :CODIGO_AGENCIA_P is null)
AND    (a.codigo_subaplicacion = :CODIGO_SUBAPLICACION_P
          or :CODIGO_SUBAPLICACION_P is null)
AND    a.situacion <> 1
AND    (a.codigo_empresa = c.codigo_empresa and
        a.codigo_agencia = c.codigo_agencia)
AND    a.codigo_subaplicacion = d.codigo_sub_aplicacion
ORDER BY A.CODIGO_EMPRESA, A.CODIGO_SUBAPLICACION, A.CODIGO_AGENCIA,
         A.NUMERO_CUENTA


-- Q_CA_CREDITOS_PENDIENTES
SELECT      A.CODIGO_EMPRESA, A.CODIGO_AGENCIA, A.CODIGO_SUBAPLICACION
           -- A.NUMERO_CUENTA, sum(nvl(VALOR,0)) TOTAL_CREDITOS
FROM        CA_MOVIMIENTOS_PENDIENTES A, TIPOS_DE_TRANSACCIONES B
WHERE       (a.codigo_tipo_transaccion = b.codigo_tipo_transaccion and
             a.codigo_aplicacion = b.codigo_aplicacion)
AND         a.impreso = 'N'
and         b.debito_credito_otro='C'
GROUP BY    A.CODIGO_EMPRESA, A.CODIGO_AGENCIA, A.CODIGO_SUBAPLICACION,
                      A.NUMERO_CUENTA



-- Q_CA_DEBITOS_PENDIENTES
SELECT      A.CODIGO_EMPRESA, A.CODIGO_AGENCIA, A.CODIGO_SUBAPLICACION
            --A.NUMERO_CUENTA, sum(nvl(VALOR,0)) TOTAL_DEBITOS
FROM        CA_MOVIMIENTOS_PENDIENTES A, TIPOS_DE_TRANSACCIONES B
WHERE       (a.codigo_tipo_transaccion = b.codigo_tipo_transaccion and
             a.codigo_aplicacion = b.codigo_aplicacion)
AND         a.impreso = 'N'
and         b.debito_credito_otro = 'D'
GROUP BY    A.CODIGO_EMPRESA, A.CODIGO_AGENCIA, A.CODIGO_SUBAPLICACION,
            A.NUMERO_CUENTA


