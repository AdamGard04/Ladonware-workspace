-- Q_cr_dif_conciliacion
Select  d.secuencia_movimiento sec_cr_dif, d.codigo_usuario_movimiento usuario_cr_dif, d.fecha_movimiento fecha_cr_dif, 
d.secuencia_movimiento_detalle sec_det_cr_dif, 
d.numero_documento num_doc_cr_dif, 
(a.diferencia) monto_cr_dif,
b.codigo_transaccion_concepto trn_cr_dif, b.codigo_aplicacion_auxiliar apl_cr_dif, 
'Movimiento generado por diferencia en la conciliacion'   detalle_cr_dif
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b,bc_historicos_detalles d, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.codigo_agencia = :p_codigo_agencia
and   a.diferencia > 0
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select d.secuencia_movimiento sec_cr_dif,  d.codigo_usuario_movimiento usuario_cr_dif, d.fecha_movimiento fec_cr_dif, 
d.secuencia_movimiento_detalle sec_det_cr_dif, d.numero_referencia num_doc_cr_dif, 
(a.diferencia ) monto_cr_dif,
b.codigo_transaccion_concepto trn_cr_dif, b.codigo_aplicacion_auxiliar apl_cr_dif, 
'Movimiento generado por diferencia en la conciliacion'  detalle_cr_dif
from bc_conciliacion_diaria_his a, bc_movimientos b, bc_movimientos_detalles d,bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.codigo_agencia = :p_codigo_agencia
and   a.diferencia > 0
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select  d.secuencia_movimiento sec_cr_dif, d.codigo_usuario_movimiento usuario_cr_dif, d.fecha_movimiento fecha_cr_dif, 
d.secuencia_movimiento_detalle sec_det_cr_dif, 
d.numero_documento num_doc_cr_dif, 
(a.diferencia) monto_cr_dif,
b.codigo_transaccion_concepto trn_cr_dif, b.codigo_aplicacion_auxiliar apl_cr_dif, 
'Movimiento generado por diferencia en la conciliacion'   detalle_cr_dif
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b,bc_historicos_detalles d, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  e.numero_cuenta = :p_numero_cuenta
and  e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and  e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and   a.diferencia > 0
and nvl(f.conciliacion_global,'N') = 'S'
UNION
Select d.secuencia_movimiento sec_cr_dif,  d.codigo_usuario_movimiento usuario_cr_dif, d.fecha_movimiento fec_cr_dif, 
d.secuencia_movimiento_detalle sec_det_cr_dif, d.numero_referencia num_doc_cr_dif, 
(a.diferencia ) monto_cr_dif,
b.codigo_transaccion_concepto trn_cr_dif, b.codigo_aplicacion_auxiliar apl_cr_dif, 
'Movimiento generado por diferencia en la conciliacion'  detalle_cr_dif
from bc_conciliacion_diaria_his a, bc_movimientos b, bc_movimientos_detalles d, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  e.numero_cuenta = :p_numero_cuenta
and e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and   a.diferencia > 0
and nvl(f.conciliacion_global,'N') = 'S'
order by fecha_cr_dif asc


-- Q_db_dif_conciliacion
Select  d.secuencia_movimiento sec_db_dif, d.codigo_usuario_movimiento usuario_db_dif, d.fecha_movimiento fecha_db_dif, 
d.secuencia_movimiento_detalle sec_det_db_dif, 
d.numero_documento num_doc_db_dif, 
(a.diferencia) monto_db_dif,
b.codigo_transaccion_concepto trn_db_dif, b.codigo_aplicacion_auxiliar apl_db_dif,  
'Movimiento generado por diferencia en la conciliacion' detalle_db_dif
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b, bc_historicos_detalles d, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and   a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.codigo_agencia = :p_codigo_agencia
and   a.diferencia < 0
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select d.secuencia_movimiento sec_db_dif,  d.codigo_usuario_movimiento usuario_db_dif, d.fecha_movimiento fec_db_dif, 
d.secuencia_movimiento_detalle sec_det_db_dif, d.numero_referencia num_doc_db_dif, 
(a.diferencia) monto_db_dif,
b.codigo_transaccion_concepto trn_db_dif, b.codigo_aplicacion_auxiliar apl_db_dif, 
'Movimiento generado por diferencia en la conciliacion' detalle_db_dif
from bc_conciliacion_diaria_his a, bc_movimientos b,bc_movimientos_detalles d,
       mg_tipos_de_transacciones c, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion_origen = c.codigo_aplicacion
and c.debito_credito_otro = 'D'
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.codigo_agencia = :p_codigo_agencia
and   a.diferencia < 0
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select  d.secuencia_movimiento sec_db_dif, d.codigo_usuario_movimiento usuario_db_dif, d.fecha_movimiento fecha_db_dif, 
d.secuencia_movimiento_detalle sec_det_db_dif, 
d.numero_documento num_doc_db_dif, 
(a.diferencia) monto_db_dif,
b.codigo_transaccion_concepto trn_db_dif, b.codigo_aplicacion_auxiliar apl_db_dif,  
'Movimiento generado por diferencia en la conciliacion' detalle_db_dif
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b, bc_historicos_detalles d, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and   a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  e.numero_cuenta = :p_numero_cuenta
and e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and   a.diferencia < 0
and nvl(f.conciliacion_global,'N') = 'S'
UNION
Select d.secuencia_movimiento sec_db_dif,  d.codigo_usuario_movimiento usuario_db_dif, d.fecha_movimiento fec_db_dif, 
d.secuencia_movimiento_detalle sec_det_db_dif, d.numero_referencia num_doc_db_dif, 
(a.diferencia) monto_db_dif,
b.codigo_transaccion_concepto trn_db_dif, b.codigo_aplicacion_auxiliar apl_db_dif, 
'Movimiento generado por diferencia en la conciliacion' detalle_db_dif
from bc_conciliacion_diaria_his a, bc_movimientos b,bc_movimientos_detalles d,
       mg_tipos_de_transacciones c, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion_origen = c.codigo_aplicacion
and c.debito_credito_otro = 'D'
and  a.estado_conciliacion = 'C'
and  a.diferencia is not null
and  e.numero_cuenta = :p_numero_cuenta
and e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and   a.diferencia < 0
and nvl(f.conciliacion_global,'N') = 'S'
order by fecha_db_dif asc


-- Q_extractos_creditos
select b.numero_cuenta,b.codigo_moneda,b.codigo_agencia,
b.codigo_agencia_corresponsal,b.codigo_empresa,b.secuencia_detalle,b.dia, 
b.anio,b.mes,b.monto, 
b.numero_documento,c.descripcion ,
to_date(to_char(a.dia)||'-'||to_char(a.mes)||'-'||to_char(a.anio),'dd-mm-yyyy')  fecha_extracto_cr,c.codigo_transaccion
from bc_conciliacion_diaria_ext a, bc_extractos_detalle b, bc_transacciones_corresponsal c
where a.numero_cuenta = b.numero_cuenta
and a.codigo_moneda = b.codigo_moneda
and a.codigo_agencia = b.codigo_agencia
and a.codigo_agencia_corresponsal = b.codigo_agencia_corresponsal
and a.secuencia_detalle = b.secuencia_detalle
and a.anio = b.anio
and a.mes = b.mes
and b.codigo_transaccion = c.codigo_transaccion
and b.codigo_agencia       = c.codigo_agencia
and b.codigo_agencia_corresponsal = c.codigo_agencia_corresponsal
and c.efecto = 'C'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.anio <= nvl(to_number(to_char(:p_fecha,'YYYY')),a.anio)
and a.mes <= to_number(to_char(:p_fecha,'MM'))
and  a.estado_conciliacion <> 'C'
--order by b.numero_documento
order by :p_fecha asc


-- Q_extractos_debitos
select b.numero_cuenta,b.codigo_moneda,b.codigo_agencia,
b.codigo_agencia_corresponsal,b.codigo_empresa,b.secuencia_detalle, b.dia,  
b.anio,b.mes,b.estado_conciliacion,(b.monto * -1) monto,
b.numero_documento,c.descripcion,
to_date(to_char(a.dia)||'-'||to_char(a.mes)||'-'||to_char(a.anio),'dd-mm-yyyy') fecha_extracto_db,c.codigo_transaccion
from bc_conciliacion_diaria_ext a, bc_extractos_detalle b, bc_transacciones_corresponsal c
where a.numero_cuenta = b.numero_cuenta
and a.codigo_moneda = b.codigo_moneda
and a.codigo_agencia = b.codigo_agencia
and a.codigo_agencia_corresponsal = b.codigo_agencia_corresponsal
and a.secuencia_detalle =b.secuencia_detalle
and a.anio = b.anio
and a.mes = b.mes
and b.codigo_transaccion = c.codigo_transaccion
and b.codigo_agencia       = c.codigo_agencia
and b.codigo_agencia_corresponsal = c.codigo_agencia_corresponsal
and c.efecto = 'D'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.anio <= nvl(to_number(to_char(:p_fecha,'YYYY')),a.anio)
and a.mes <= to_number(to_char(:p_fecha,'MM'))
and  a.estado_conciliacion <> 'C'
--order by b.numero_documento
order by :p_fecha asc


-- Q_historicos_creditos
Select d.secuencia_movimiento, d.codigo_usuario_movimiento, d.fecha_movimiento,d.secuencia_movimiento_detalle,d.numero_documento, 
d.valor_movimiento monto,
b.codigo_transaccion_concepto trn_cr,  b.codigo_aplicacion_auxiliar apl_cr,  c.debito_credito_otro,c.descripcion,
d.descripcion detalle_histc
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b,bc_historicos_detalles d, mg_tipos_de_transacciones c,
bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'C'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_agencia = :p_codigo_agencia
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select d.secuencia_movimiento, d.codigo_usuario_movimiento, d.fecha_movimiento,d.secuencia_movimiento_detalle,
d.numero_referencia numero_documento, d.valor_movimiento monto,
b.codigo_transaccion_concepto trn_cr,  b.codigo_aplicacion_auxiliar apl_cr, c.debito_credito_otro,c.descripcion,
d.descripcion detalle_histc
from bc_conciliacion_diaria_his a, 
        bc_movimientos b, bc_movimientos_detalles d,
        mg_tipos_de_transacciones c, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'C'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and a.codigo_agencia = :p_codigo_agencia
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select d.secuencia_movimiento, d.codigo_usuario_movimiento, d.fecha_movimiento,d.secuencia_movimiento_detalle,d.numero_documento, 
d.valor_movimiento monto,
b.codigo_transaccion_concepto trn_cr,  b.codigo_aplicacion_auxiliar apl_cr,  c.debito_credito_otro,c.descripcion,
d.descripcion detalle_histc
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b,bc_historicos_detalles d, mg_tipos_de_transacciones c, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'C'
and  e.numero_cuenta = :p_numero_cuenta
and e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'S'
UNION
Select d.secuencia_movimiento, d.codigo_usuario_movimiento, d.fecha_movimiento,d.secuencia_movimiento_detalle,
d.numero_referencia numero_documento, d.valor_movimiento monto,
b.codigo_transaccion_concepto trn_cr,  b.codigo_aplicacion_auxiliar apl_cr, c.debito_credito_otro,c.descripcion,
d.descripcion detalle_histc
from bc_conciliacion_diaria_his a, 
        bc_movimientos b, bc_movimientos_detalles d,
        mg_tipos_de_transacciones c, bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'C'
and  e.numero_cuenta = :p_numero_cuenta
and e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'S'
--order by 5
order by fecha_movimiento asc


-- Q_historicos_debitos
Select  d.secuencia_movimiento,  d.codigo_usuario_movimiento, d.fecha_movimiento, d.secuencia_movimiento_detalle, d.numero_documento, (d.valor_movimiento * -1) monto,
b.codigo_transaccion_concepto trn_db, b.codigo_aplicacion_auxiliar apl_db, c.debito_credito_otro, c.descripcion, 
d.descripcion detalle_histd
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b, bc_historicos_detalles d, mg_tipos_de_transacciones c, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and   a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and   b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'D'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_agencia = :p_codigo_agencia
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select d.secuencia_movimiento,  d.codigo_usuario_movimiento, d.fecha_movimiento, d.secuencia_movimiento_detalle, d.numero_referencia numero_documento, (d.valor_movimiento * -1) monto,
/*monto,diferencia,*/
b.codigo_transaccion_concepto trn_db, b.codigo_aplicacion_auxiliar apl_db, c.debito_credito_otro, c.descripcion,
d.descripcion detalle_histd
from bc_conciliacion_diaria_his a, bc_movimientos b,bc_movimientos_detalles d, mg_tipos_de_transacciones c, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and  b.codigo_aplicacion = c.codigo_aplicacion
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and  c.debito_credito_otro = 'D'
and  a.numero_cuenta = :p_numero_cuenta
and a.codigo_agencia = :p_codigo_agencia
and a.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and a.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'N'
UNION
Select  d.secuencia_movimiento,  d.codigo_usuario_movimiento, d.fecha_movimiento, d.secuencia_movimiento_detalle, d.numero_documento, (d.valor_movimiento * -1) monto,
b.codigo_transaccion_concepto trn_db, b.codigo_aplicacion_auxiliar apl_db, c.debito_credito_otro, c.descripcion, 
d.descripcion detalle_histd
from bc_conciliacion_diaria_his a, bc_historicos_movimientos b, bc_historicos_detalles d, mg_tipos_de_transacciones c, bc_cuentas_relacionadas e , bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and   a.fecha_movimiento = b.fecha_movimiento
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and   b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and   b.codigo_aplicacion = c.codigo_aplicacion
and c.debito_credito_otro = 'D'
and  e.numero_cuenta = :p_numero_cuenta
and  e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and  e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'S'
UNION
Select d.secuencia_movimiento,  d.codigo_usuario_movimiento, d.fecha_movimiento, d.secuencia_movimiento_detalle, d.numero_referencia numero_documento, (d.valor_movimiento * -1) monto,
/*monto,diferencia,*/
b.codigo_transaccion_concepto trn_db, b.codigo_aplicacion_auxiliar apl_db, c.debito_credito_otro, c.descripcion,
d.descripcion detalle_histd
from bc_conciliacion_diaria_his a, bc_movimientos b,bc_movimientos_detalles d, mg_tipos_de_transacciones c,
bc_cuentas_relacionadas e, bc_parametros_generales f
where a.secuencia_movimiento = b.secuencia_movimiento 
and   a.codigo_usuario_movimiento = b.codigo_usuario
and  a.fecha_movimiento = b.fecha_movimiento
and  b.codigo_tipo_transaccion = c.codigo_tipo_transaccion
and  b.codigo_aplicacion = c.codigo_aplicacion
and   a.secuencia_movimiento = d.secuencia_movimiento 
and   a.codigo_usuario_movimiento = d.codigo_usuario_movimiento
and   a.fecha_movimiento = d.fecha_movimiento
and   a.secuencia_movimiento_detalle = d.secuencia_movimiento_detalle
and   a.numero_cuenta = e.numero_cuenta
and   a.codigo_moneda = e.codigo_moneda
and   a.codigo_agencia = e.codigo_agencia_cuenta
and   a.codigo_empresa = e.codigo_empresa
and   a.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and  c.debito_credito_otro = 'D'
and  e.numero_cuenta = :p_numero_cuenta
and  e.codigo_moneda = nvl(:p_codigo_moneda, a.codigo_moneda)
and  e.codigo_agencia_corresponsal = :p_codigo_corresponsal
and  a.estado_conciliacion <> 'C'
and nvl(f.conciliacion_global,'N') = 'S'
order by fecha_movimiento asc


-- funciones:

-- F_desc_corresponsal1
-- CF_corresponsal
function CF_CORRESPONSALFORMULA0045 return VARCHAR2 is
  LV_BANCO    VARCHAR2(80);
begin
  SELECT NOMBRE_AGENCIA INTO LV_BANCO
  FROM MG_AGENCIAS_GENERALES
  WHERE CODIGO_AGENCIA = :p_codigo_CORRESPONSAL;

  RETURN(LV_BANCO);

  RETURN NULL; EXCEPTION 
    WHEN OTHERS THEN RETURN NULL;
end;


-- F_moneda1
-- CF_moneda:
function CF_monedaFormula return VARCHAR2 is
  LV_MONEDAS VARCHAR2(30);
begin
	begin
    SELECT DESCRIPCION
    INTO LV_MONEDAS
    FROM MG_MONEDAS
    WHERE CODIGO_MONEDA = :P_codigo_MONEDA;
   EXCEPTION 
    WHEN OTHERS THEN RETURN NULL;
  end;
  RETURN(Lv_MONEDAS);
end;

-- F_agencia
-- CF_AGENCIA:
function CF_AGENCIAFormula return Char is
  lv_nombre_agencia varchar2(40) := null;
  ln_agencia  number;
begin
if nvl(:cf_conciliacion_global,'N') = 'N' then
	ln_agencia :=  :p_codigo_agencia;
else
	ln_agencia :=  :cp_agencia_conciliacion;
end if;

  Select nombre_agencia 
    into lv_nombre_agencia
    from mg_agencias_generales
   where codigo_agencia = ln_agencia;
   return(lv_nombre_agencia);
Exception
	When no_data_found then
	  return(lv_nombre_agencia);
end;


-- F_numero_cuenta2
-- CF_CUENTAS_CONT:
function CF_CUENTAS_CONTABLESFormula return varchar2 is
	Lv_formato VARCHAR2(39);
	Lv_nivel_1 varchar2(4);
	Lv_nivel_2 varchar2(4);
	Lv_nivel_3 varchar2(4);
	Lv_nivel_4 varchar2(4);
	Lv_nivel_5 varchar2(4);
	Lv_nivel_6 varchar2(4);
	Lv_nivel_7 varchar2(4);
	Lv_nivel_8 varchar2(4);
	ln_agencia number;
BEGIN
	
if nvl(:cf_conciliacion_global,'N') = 'N' then
	 ln_agencia := :p_codigo_agencia;
else
	 ln_agencia := :cp_agencia_conciliacion;
end if;

	begin
    select  a.NIVEL_1_CUENTA_CONTABLE, a.NIVEL_2_CUENTA_CONTABLE,
            a.NIVEL_3_CUENTA_CONTABLE, a.NIVEL_4_CUENTA_CONTABLE,
            a.NIVEL_5_CUENTA_CONTABLE, a.NIVEL_6_CUENTA_CONTABLE,
            a.NIVEL_7_CUENTA_CONTABLE, a.NIVEL_8_CUENTA_CONTABLE
    INTO    Lv_nivel_1, Lv_nivel_2, Lv_nivel_3, Lv_nivel_4,
            Lv_nivel_5, Lv_nivel_6, Lv_nivel_7, Lv_nivel_8
    from bc_corresponsal_saldos a
    WHERE a.codigo_empresa              = :p_empresa
    and   a.codigo_agencia              = ln_agencia
    and   a.codigo_agencia_corresponsal = :P_codigo_corresponsal 
    and   a.codigo_moneda               = :P_codigo_moneda
    and   a.numero_cuenta               = :P_numero_cuenta 
    and   a.tipo_saldo = 1 ;
	exception
		  when no_data_found then
		    return('No existe');
  end;
 
  GM_P_DESPLEGAR_R(
    Lv_NIVEL_1  ,  Lv_NIVEL_2,  Lv_NIVEL_3  ,  
    Lv_NIVEL_4  ,  Lv_NIVEL_5,  Lv_NIVEL_6  ,  
    Lv_NIVEL_7  ,  Lv_NIVEL_8,  :p_empresa, Lv_FORMATO);
  RETURN(Lv_FORMATO);  
end;


-- F_descripcion4
-- cf_desc_cpto_cr
function CF_desc_concepto_4Formula return VARCHAR2 is
  Ln_descripcion varchar2(100) := null;
begin
  select descripcion
  into   Ln_descripcion
  from   mg_tipos_de_transacciones
  where  codigo_aplicacion       = :apl_cr
  and    codigo_tipo_transaccion = :trn_cr;

  return(Ln_descripcion);
end;


-- F_descripcion2
-- cf_desc_cpto_db
function CF_desc_concepto_dbFormula return VARCHAR2 is
  Ln_descripcion varchar2(100) := null;
begin
  select descripcion
  into   Ln_descripcion
  from   mg_tipos_de_transacciones
  where  codigo_aplicacion       = :apl_db
  and    codigo_tipo_transaccion = :trn_db;

  return(Ln_descripcion);
end;

-- F_segunbanco
-- CF_segun_banco
function CF_segun_bancoFormula return Number is
  Ln_saldo   number;
begin
  Ln_saldo := 0;
  ln_saldo := nvl(:cp_saldo_final,0) + nvl(:cs_hist_credito,0) + nvl(:cs_hist_debito,0);
             -- + nvl(:cs_mon_db_dif,0) + nvl(:cs_mon_cr_dif,0);
  return(ln_saldo);
end;


-- F_saldo_final1
-- CF_saldoslibros:
function CF_saldoslibrosFormula return Number is
  ln_total_saldo number;
  ln_montodif    number;
  ln_agencia     number;
  Ln_dia_1       number; Ln_dia_2  number; Ln_dia_3  number;
  Ln_dia_4       number; Ln_dia_5  number; Ln_dia_6  number;
  Ln_dia_7       number; Ln_dia_8  number; Ln_dia_9  number;
  Ln_dia_10      number; Ln_dia_11 number; Ln_dia_12 number;
  Ln_dia_13      number; Ln_dia_14 number; Ln_dia_15 number;
  Ln_dia_16      number; Ln_dia_17 number; Ln_dia_18 number;
  Ln_dia_19      number; Ln_dia_20 number; Ln_dia_21 number;
  Ln_dia_22      number; Ln_dia_23 number; Ln_dia_24 number;
  Ln_dia_25      number; Ln_dia_26 number; Ln_dia_27 number;
  Ln_dia_28      number; Ln_dia_29 number; Ln_dia_30 number;  Ln_dia_31 number;     
begin
if nvl(:cf_conciliacion_global,'N') = 'N' THEN
	/*
  begin
    select sum(nvl(monto_tipo_saldo,0))
    into   ln_total_saldo
    from   bc_corresponsal_saldos
    where numero_cuenta               = :p_numero_cuenta
    and   codigo_agencia              = :p_codigo_agencia
    and   codigo_agencia_corresponsal = :p_codigo_corresponsal
    and   codigo_moneda               = :p_codigo_moneda
    and   codigo_empresa              = :p_empresa;
  exception
     when no_data_found then
        ln_total_saldo := 0;
  end;
else
	 begin
    select sum(nvl(monto_tipo_saldo,0))
    into   ln_total_saldo
    from   bc_corresponsal_saldos a, bc_cuentas_relacionadas c
    where  a.numero_cuenta              = c.numero_cuenta
    and   a.codigo_agencia              = c.codigo_agencia_cuenta
    and   a.codigo_agencia_corresponsal = c.codigo_agencia_corresponsal
    and   a.codigo_moneda               = c.codigo_moneda
    and   a.codigo_empresa              = c.codigo_empresa
    and   c.numero_cuenta               = :p_numero_cuenta
    and   c.codigo_agencia_corresponsal = :p_codigo_corresponsal
    and   c.codigo_moneda               = :p_codigo_moneda
    and   c.codigo_empresa              = :p_empresa;
  exception
     when no_data_found then
        ln_total_saldo := 0;
  end; 
  
end if; */

           Ln_dia_1 := 0; Ln_dia_2:= 0;  Ln_dia_3:= 0;  Ln_dia_4:= 0;  Ln_dia_5:= 0;
           Ln_dia_6 := 0; Ln_dia_7:= 0;  Ln_dia_8:= 0;  Ln_dia_9:= 0;  Ln_dia_10:= 0;
           Ln_dia_11:= 0; Ln_dia_12:= 0; Ln_dia_13:= 0; Ln_dia_14:= 0; Ln_dia_15:= 0;
           Ln_dia_16:= 0; Ln_dia_17:= 0; Ln_dia_18:= 0; Ln_dia_19:= 0; Ln_dia_20:= 0;
           Ln_dia_21:= 0; Ln_dia_22:= 0; Ln_dia_23:= 0; Ln_dia_24:= 0; Ln_dia_25:= 0;
           Ln_dia_26:= 0; Ln_dia_27:= 0; Ln_dia_28:= 0; Ln_dia_29:= 0; Ln_dia_30:= 0; Ln_dia_31:= 0;

  begin
	  select sum(nvl(dia_1,0)),  sum(nvl(dia_2,0)),  sum(nvl(dia_3,0)),  sum(nvl(dia_4,0)),
	         sum(nvl(dia_5,0)),  sum(nvl(dia_6,0)),  sum(nvl(dia_7,0)),  sum(nvl(dia_8,0)),
	         sum(nvl(dia_9,0)),  sum(nvl(dia_10,0)), sum(nvl(dia_11,0)), sum(nvl(dia_12,0)),
	         sum(nvl(dia_13,0)), sum(nvl(dia_14,0)), sum(nvl(dia_15,0)), sum(nvl(dia_16,0)),
	         sum(nvl(dia_17,0)), sum(nvl(dia_18,0)), sum(nvl(dia_19,0)), sum(nvl(dia_20,0)),
	         sum(nvl(dia_21,0)), sum(nvl(dia_22,0)), sum(nvl(dia_23,0)), sum(nvl(dia_24,0)),
	         sum(nvl(dia_25,0)), sum(nvl(dia_26,0)), sum(nvl(dia_27,0)), sum(nvl(dia_28,0)),
	         sum(nvl(dia_29,0)), sum(nvl(dia_30,0)), sum(nvl(dia_31,0))
    into   Ln_dia_1,  Ln_dia_2 , Ln_dia_3,  Ln_dia_4,  Ln_dia_5,
           Ln_dia_6,  Ln_dia_7,  Ln_dia_8,  Ln_dia_9,  Ln_dia_10,
           Ln_dia_11, Ln_dia_12, Ln_dia_13, Ln_dia_14, Ln_dia_15,
           Ln_dia_16, Ln_dia_17, Ln_dia_18, Ln_dia_19, Ln_dia_20,
           Ln_dia_21, Ln_dia_22, Ln_dia_23, Ln_dia_24, Ln_dia_25,
           Ln_dia_26, Ln_dia_27, Ln_dia_28, Ln_dia_29, Ln_dia_30, Ln_dia_31
    from   bc_saldos_diarios
    where numero_cuenta               = :p_numero_cuenta
    and   codigo_agencia              = :p_codigo_agencia
    and   codigo_agencia_corresponsal = :p_codigo_corresponsal
    and   codigo_moneda               = :p_codigo_moneda
    and   codigo_empresa              = :p_empresa
    and   ano                         = to_number(to_char(:p_fecha,'YYYY'))
    and   mes                         = to_number(to_char(:p_fecha,'MM'));
  exception
     when no_data_found then
        ln_total_saldo := 0;
  end;
  
  else
  begin
	  select sum(nvl(dia_1,0)),  sum(nvl(dia_2,0)),  sum(nvl(dia_3,0)),  sum(nvl(dia_4,0)),
	         sum(nvl(dia_5,0)),  sum(nvl(dia_6,0)),  sum(nvl(dia_7,0)),  sum(nvl(dia_8,0)),
	         sum(nvl(dia_9,0)),  sum(nvl(dia_10,0)), sum(nvl(dia_11,0)), sum(nvl(dia_12,0)),
	         sum(nvl(dia_13,0)), sum(nvl(dia_14,0)), sum(nvl(dia_15,0)), sum(nvl(dia_16,0)),
	         sum(nvl(dia_17,0)), sum(nvl(dia_18,0)), sum(nvl(dia_19,0)), sum(nvl(dia_20,0)),
	         sum(nvl(dia_21,0)), sum(nvl(dia_22,0)), sum(nvl(dia_23,0)), sum(nvl(dia_24,0)),
	         sum(nvl(dia_25,0)), sum(nvl(dia_26,0)), sum(nvl(dia_27,0)), sum(nvl(dia_28,0)),
	         sum(nvl(dia_29,0)), sum(nvl(dia_30,0)), sum(nvl(dia_31,0))
    into   Ln_dia_1,  Ln_dia_2 , Ln_dia_3,  Ln_dia_4,  Ln_dia_5,
           Ln_dia_6,  Ln_dia_7,  Ln_dia_8,  Ln_dia_9,  Ln_dia_10,
           Ln_dia_11, Ln_dia_12, Ln_dia_13, Ln_dia_14, Ln_dia_15,
           Ln_dia_16, Ln_dia_17, Ln_dia_18, Ln_dia_19, Ln_dia_20,
           Ln_dia_21, Ln_dia_22, Ln_dia_23, Ln_dia_24, Ln_dia_25,
           Ln_dia_26, Ln_dia_27, Ln_dia_28, Ln_dia_29, Ln_dia_30, Ln_dia_31
    from   bc_saldos_diarios a, bc_cuentas_relacionadas c
    where  a.numero_cuenta              = c.numero_cuenta
    and   a.codigo_agencia              = c.codigo_agencia_cuenta
    and   a.codigo_agencia_corresponsal = c.codigo_agencia_corresponsal
    and   a.codigo_moneda               = c.codigo_moneda
    and   a.codigo_empresa              = c.codigo_empresa
    and   c.numero_cuenta               = :p_numero_cuenta
    and   c.codigo_agencia_corresponsal = :p_codigo_corresponsal
    and   c.codigo_moneda               = :p_codigo_moneda
    and   c.codigo_empresa              = :p_empresa
    and   a.ano                         = to_number(to_char(:p_fecha,'YYYY'))
    and   a.mes                         = to_number(to_char(:p_fecha,'MM'));
  exception
     when no_data_found then
        ln_total_saldo := 0;
  end;
  end if;
 
  if to_number(to_char(:p_fecha,'DD')) = 1 then
     ln_total_saldo := Ln_dia_1;
  elsif to_number(to_char(:p_fecha,'DD')) = 2 then
     ln_total_saldo := Ln_dia_2;
  elsif to_number(to_char(:p_fecha,'DD')) = 3 then
     ln_total_saldo := Ln_dia_3;
  elsif to_number(to_char(:p_fecha,'DD')) = 4 then
     ln_total_saldo := Ln_dia_4;
  elsif to_number(to_char(:p_fecha,'DD')) = 5 then
     ln_total_saldo := Ln_dia_5;
  elsif to_number(to_char(:p_fecha,'DD')) = 6 then
     ln_total_saldo := Ln_dia_6;
  elsif to_number(to_char(:p_fecha,'DD')) = 7 then
     ln_total_saldo := Ln_dia_7;
  elsif to_number(to_char(:p_fecha,'DD')) = 8 then
     ln_total_saldo := Ln_dia_8;
  elsif to_number(to_char(:p_fecha,'DD')) = 9 then
     ln_total_saldo := Ln_dia_9;
  elsif to_number(to_char(:p_fecha,'DD')) = 10 then
     ln_total_saldo := Ln_dia_10;
  elsif to_number(to_char(:p_fecha,'DD')) = 11 then
     ln_total_saldo := Ln_dia_11;
  elsif to_number(to_char(:p_fecha,'DD')) = 12 then
     ln_total_saldo := Ln_dia_12;
  elsif to_number(to_char(:p_fecha,'DD')) = 13 then
     ln_total_saldo := Ln_dia_13;
  elsif to_number(to_char(:p_fecha,'DD')) = 14 then
     ln_total_saldo := Ln_dia_14;
  elsif to_number(to_char(:p_fecha,'DD')) = 15 then
     ln_total_saldo := Ln_dia_15;
  elsif to_number(to_char(:p_fecha,'DD')) = 16 then
     ln_total_saldo := Ln_dia_16;
  elsif to_number(to_char(:p_fecha,'DD')) = 17 then
     ln_total_saldo := Ln_dia_17;
  elsif to_number(to_char(:p_fecha,'DD')) = 18 then
     ln_total_saldo := Ln_dia_18;
  elsif to_number(to_char(:p_fecha,'DD')) = 19 then
     ln_total_saldo := Ln_dia_19;
  elsif to_number(to_char(:p_fecha,'DD')) = 20 then
     ln_total_saldo := Ln_dia_20;
  elsif to_number(to_char(:p_fecha,'DD')) = 21 then
     ln_total_saldo := Ln_dia_21;
  elsif to_number(to_char(:p_fecha,'DD')) = 22 then
     ln_total_saldo := Ln_dia_22;
  elsif to_number(to_char(:p_fecha,'DD')) = 23 then
     ln_total_saldo := Ln_dia_23;
  elsif to_number(to_char(:p_fecha,'DD')) = 24 then
     ln_total_saldo := Ln_dia_24;
  elsif to_number(to_char(:p_fecha,'DD')) = 25 then
     ln_total_saldo := Ln_dia_25;
  elsif to_number(to_char(:p_fecha,'DD')) = 26 then
     ln_total_saldo := Ln_dia_26;
  elsif to_number(to_char(:p_fecha,'DD')) = 27 then
     ln_total_saldo := Ln_dia_27;
  elsif to_number(to_char(:p_fecha,'DD')) = 28 then
     ln_total_saldo := Ln_dia_28;
  elsif to_number(to_char(:p_fecha,'DD')) = 29 then
     ln_total_saldo := Ln_dia_29;
  elsif to_number(to_char(:p_fecha,'DD')) = 30 then
     ln_total_saldo := Ln_dia_30;
  elsif to_number(to_char(:p_fecha,'DD')) = 31 then
     ln_total_saldo := Ln_dia_31;
  end if;    

  return(ln_total_saldo);
end;


-- F_saldo_contabilidad1
-- CF_saldo_contabilidad:
function CF_saldo_contabilidadFormula return Number is
ln_saldo number;
ln_montodif number;
begin
  /*Monto por diferencia*/
  begin
      select sum(diferencia)
      into   ln_montodif
      from bc_conciliacion_diaria_his
      where diferencia is not null and numero_cuenta = :p_numero_cuenta; --CRAGE-2022-00157 se filtra por cuenta
  exception
      when no_data_found then
           ln_montodif := 0;
  end;
  
  ln_saldo := nvl(ln_montodif,0)+nvl(:cf_saldoslibros,0)+
              nvl(:cs_extracto_credito,0) + nvl(:cs_extracto_debito,0);
  return(ln_saldo);
end;


-- F_difbancos1
-- CF_diferencia_bancos:
function CF_diferencia_bancosFormula return Number is
  ln_diferencia number;
begin
  
  ln_diferencia := :cf_segun_banco - :cf_saldo_contabilidad;
  return(ln_diferencia);
end;
