-- ======================================================================== QUERY 1: Q_CHEQUES
SELECT e.NUMERO_referencia, 
e.beneficiario beneficiario_detalle,
e.valor_movimiento monto,  
e.codigo_agencia_corresponsal,
e.codigo_agencia,
e.numero_referencia num_doc, 
e.descripcion desc_detalle, 
e.secuencia_movimiento,
e.codigo_usuario_movimiento,
e.fecha_movimiento, c.nombre_agencia, b.codigo_moneda, g.idioma_cheque,
h.codigo_grupo,
e.numero_referencia   nro_cheque,
f.secuencia_solicitud,
f.codigo_aplicacion_concepto,
e.numero_cuenta,
f.codigo_transaccion_concepto,
e.codigo_usuario_movimiento,
e.valor_movimiento monto_cheque,
a.codigo_empresa codigo_empresa_contable,
a.nivel_1_cuenta_contable nivel_1,     
a.nivel_2_cuenta_contable nivel_2,     
a.nivel_3_cuenta_contable nivel_3,     
a.nivel_4_cuenta_contable nivel_4,
a.nivel_5_cuenta_contable nivel_5,     
a.nivel_6_cuenta_contable nivel_6,     
a.nivel_7_cuenta_contable nivel_7,     
a.nivel_8_cuenta_contable nivel_8,
DECODE(J.DEBITO_CREDITO_OTRO, 'C', 'Cr', 'D', 'Db','O', ' ')  dbcr1 ,
f.codigo_agencia_origen

FROM  mg_agencias_generales  c, bc_movimientos_detalles e, mg_monedas b, bc_corresponsal_cuentas g, mg_tipos_de_canje d,
             bc_movimientos f, bc_cheques_impresos h,
bc_conceptos_x_transacciones a,    MG_TIPOS_DE_TRANSACCIONES J
WHERE 	j.codigo_aplicacion 		= a.codigo_aplicacion
and	j.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and          f.codigo_aplicacion 		= a.codigo_aplicacion
and	f.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and	f.codigo_aplicacion_concepto 	= a.codigo_aplicacion_origen
and	f.codigo_transaccion_concepto = a.codigo_transaccion_concepto
and	f.codigo_moneda		= a.codigo_moneda
and          e.codigo_empresa = nvl( :P_codigo_empresa,e.codigo_empresa)
and          e.codigo_agencia = nvl(:P_codigo_agencia,e.codigo_agencia)
and          e.codigo_moneda = nvl(:P_codigo_moneda,e.codigo_moneda)
and          e.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,e.codigo_agencia_corresponsal)
and          e.numero_cuenta = nvl(:p_numero_cuenta,e.numero_cuenta)
and          e.numero_referencia  = nvl(:p_numero_cheque, e.numero_referencia)
and         d.codigo_tipo_canje   = e.codigo_tipo_canje
and         d.tipo_cheque_banco = 2
and          c.codigo_agencia  = e.codigo_agencia_corresponsal
and          c.codigo_empresa = e.codigo_empresa
and          b.codigo_moneda = e.codigo_moneda
and          g.codigo_empresa = e.codigo_empresa
and          g.codigo_agencia  = e.codigo_agencia
and          g.codigo_moneda  = e.codigo_moneda
and         g.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and         g.numero_cuenta  = e.numero_cuenta
and         f.secuencia_movimiento = e.secuencia_movimiento
and         f.fecha_movimiento         = e.fecha_movimiento
and        f.codigo_usuario               = e.codigo_usuario_movimiento
and        f.estado_movimiento        = 1
and        h.codigo_empresa = nvl( :P_codigo_empresa,h.codigo_empresa)
and         h.codigo_agencia = nvl(:P_codigo_agencia,h.codigo_agencia)
and          h.codigo_moneda = nvl(:P_codigo_moneda,h.codigo_moneda)
and          h.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,h.codigo_agencia_corresponsal)
and          h.numero_cuenta = nvl(:p_numero_cuenta,h.numero_cuenta)
and          to_char(h.numero_cheque)  = nvl(:p_numero_cheque, to_char(h.numero_cheque))
UNION 
SELECT e.NUMERO_referencia, 
e.beneficiario beneficiario_detalle,
e.valor_movimiento monto,  
e.codigo_agencia_corresponsal,
e.codigo_agencia,
e.numero_referencia num_doc, 
e.descripcion desc_detalle, 
e.secuencia_movimiento,
e.codigo_usuario_movimiento,
e.fecha_movimiento, c.nombre_agencia, b.codigo_moneda, g.idioma_cheque,
h.codigo_grupo,
e.numero_referencia   nro_cheque,
f.secuencia_solicitud,
f.codigo_aplicacion_concepto,
e.numero_cuenta,
f.codigo_transaccion_concepto,
e.codigo_usuario_movimiento,
e.valor_movimiento monto_cheque,
a.codigo_empresa codigo_empresa_contable,
a.nivel_1_cuenta_contable nivel_1,     
a.nivel_2_cuenta_contable nivel_2,     
a.nivel_3_cuenta_contable nivel_3,     
a.nivel_4_cuenta_contable nivel_4,
a.nivel_5_cuenta_contable nivel_5,     
a.nivel_6_cuenta_contable nivel_6,     
a.nivel_7_cuenta_contable nivel_7,     
a.nivel_8_cuenta_contable nivel_8,
DECODE(J.DEBITO_CREDITO_OTRO, 'C', 'Cr', 'D', 'Db','O', ' ')  dbcr1,
f.codigo_agencia_origen
FROM  mg_agencias_generales  c, bc_movimientos_detalles e, mg_monedas b, bc_corresponsal_cuentas g, mg_tipos_de_canje d, bc_movimientos f, bc_cheques_impresos h,
bc_conceptos_x_transacciones a,     MG_TIPOS_DE_TRANSACCIONES J
WHERE 	j.codigo_aplicacion 		= a.codigo_aplicacion
and	j.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and          f.codigo_aplicacion 		= a.codigo_aplicacion
and	f.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and	f.codigo_aplicacion_concepto 	= a.codigo_aplicacion_origen
and	f.codigo_transaccion_concepto = a.codigo_transaccion_concepto
and	f.codigo_moneda		= a.codigo_moneda
and          e.codigo_empresa = nvl( :P_codigo_empresa,e.codigo_empresa)
and          e.codigo_agencia = nvl(:P_codigo_agencia,e.codigo_agencia)
and          e.codigo_moneda = nvl(:P_codigo_moneda,e.codigo_moneda)
and          e.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,e.codigo_agencia_corresponsal)
and          e.numero_cuenta = nvl(:p_numero_cuenta,e.numero_cuenta)
and          e.numero_referencia  = nvl(:p_numero_cheque, e.numero_referencia)
and         d.codigo_tipo_canje   = e.codigo_tipo_canje
and         d.tipo_cheque_banco = 2
and          c.codigo_agencia  = e.codigo_agencia_corresponsal
and          c.codigo_empresa = e.codigo_empresa
and          b.codigo_moneda = e.codigo_moneda
and          g.codigo_empresa = e.codigo_empresa
and          g.codigo_agencia  = e.codigo_agencia
and          g.codigo_moneda  = e.codigo_moneda
and         g.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and         g.numero_cuenta  = e.numero_cuenta
and         f.secuencia_movimiento = e.secuencia_movimiento
and         f.fecha_movimiento         = e.fecha_movimiento
and        f.codigo_usuario               = e.codigo_usuario_movimiento
and        f.estado_movimiento        = 1
and        h.codigo_empresa = nvl( :P_codigo_empresa,h.codigo_empresa)
and         h.codigo_agencia = nvl(:P_codigo_agencia,h.codigo_agencia)
and          h.codigo_moneda = nvl(:P_codigo_moneda,h.codigo_moneda)
and          h.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,h.codigo_agencia_corresponsal)
and          h.numero_cuenta = nvl(:p_numero_cuenta,h.numero_cuenta)
and          to_char(h.numero_cheque)  = nvl(:p_numero_cheque, to_char(h.numero_cheque))
UNION 
SELECT e.NUMERO_referencia,e.beneficiario beneficiario_detalle,
e.valor_movimiento monto,  
e.codigo_agencia_corresponsal,
e.codigo_agencia,
e.numero_referencia num_doc, 
e.descripcion desc_detalle, 
e.secuencia_movimiento,
e.codigo_usuario_movimiento,
e.fecha_movimiento, c.nombre_agencia, b.codigo_moneda, g.idioma_cheque,
h.codigo_grupo,
e.numero_referencia   nro_cheque,
f.secuencia_solicitud,
f.codigo_aplicacion_concepto,
e.numero_cuenta,
f.codigo_transaccion_concepto,
e.codigo_usuario_movimiento,
e.valor_movimiento monto_cheque,
a.codigo_empresa codigo_empresa_contable,
a.nivel_1_cuenta_contable nivel_1,     
a.nivel_2_cuenta_contable nivel_2,     
a.nivel_3_cuenta_contable nivel_3,     
a.nivel_4_cuenta_contable nivel_4,
a.nivel_5_cuenta_contable nivel_5,     
a.nivel_6_cuenta_contable nivel_6,     
a.nivel_7_cuenta_contable nivel_7,     
a.nivel_8_cuenta_contable nivel_8,
DECODE(J.DEBITO_CREDITO_OTRO, 'C', 'Cr', 'D', 'Db','O', ' ')  dbcr1,
f.codigo_agencia_origen
FROM  mg_agencias_generales  c, bc_movimientos_detalles e, mg_monedas b, bc_corresponsal_cuentas g, mg_tipos_de_canje d,
             bc_movimientos f, bc_cheques_impresos h,
bc_conceptos_x_transacciones a,    MG_TIPOS_DE_TRANSACCIONES J
WHERE 	j.codigo_aplicacion 		= a.codigo_aplicacion
and	j.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and          f.codigo_aplicacion 		= a.codigo_aplicacion
and	f.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and	f.codigo_aplicacion_concepto 	= a.codigo_aplicacion_origen
and	f.codigo_transaccion_concepto = a.codigo_transaccion_concepto
and	f.codigo_moneda		= a.codigo_moneda
and          e.codigo_empresa = nvl( :P_codigo_empresa,e.codigo_empresa)
and          e.codigo_agencia = nvl(:P_codigo_agencia,e.codigo_agencia)
and          e.codigo_moneda = nvl(:P_codigo_moneda,e.codigo_moneda)
and          e.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,e.codigo_agencia_corresponsal)
and          e.numero_cuenta = nvl(:p_numero_cuenta,e.numero_cuenta)
and          e.numero_referencia  = nvl(:p_numero_cheque, e.numero_referencia)
and         d.codigo_tipo_canje   = e.codigo_tipo_canje
and         d.tipo_cheque_banco = 2
and          c.codigo_agencia  = e.codigo_agencia_corresponsal
and          c.codigo_empresa = e.codigo_empresa
and          b.codigo_moneda = e.codigo_moneda
and          g.codigo_empresa = e.codigo_empresa
and          g.codigo_agencia  = e.codigo_agencia
and          g.codigo_moneda  = e.codigo_moneda
and         g.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and         g.numero_cuenta  = e.numero_cuenta
and         f.secuencia_movimiento = e.secuencia_movimiento
and         f.fecha_movimiento         = e.fecha_movimiento
and        f.codigo_usuario               = e.codigo_usuario_movimiento
and        f.estado_movimiento        = 1
and        h.codigo_empresa = nvl( :P_codigo_empresa,h.codigo_empresa)
and         h.codigo_agencia = nvl(:P_codigo_agencia,h.codigo_agencia)
and          h.codigo_moneda = nvl(:P_codigo_moneda,h.codigo_moneda)
and          h.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,h.codigo_agencia_corresponsal)
and          h.numero_cuenta = nvl(:p_numero_cuenta,h.numero_cuenta)
and          to_char(h.numero_cheque)  = nvl(:p_numero_cheque, to_char(h.numero_cheque))
UNION 
SELECT e.NUMERO_documento numero_referencia ,e.beneficiario beneficiario_detalle,
e.valor_movimiento monto,  
e.codigo_agencia_corresponsal,
e.codigo_agencia,
e.numero_documento num_doc, 
e.descripcion desc_detalle, 
e.secuencia_movimiento,
e.codigo_usuario_movimiento,
e.fecha_movimiento, c.nombre_agencia, b.codigo_moneda, g.idioma_cheque,
h.codigo_grupo,
e.numero_documento   nro_cheque,
f.secuencia_solicitud,
f.codigo_aplicacion_concepto,
e.numero_cuenta,
f.codigo_transaccion_concepto,
e.codigo_usuario_movimiento,
e.valor_movimiento monto_cheque,
a.codigo_empresa codigo_empresa_contable,
a.nivel_1_cuenta_contable nivel_1,     
a.nivel_2_cuenta_contable nivel_2,     
a.nivel_3_cuenta_contable nivel_3,     
a.nivel_4_cuenta_contable nivel_4,
a.nivel_5_cuenta_contable nivel_5,     
a.nivel_6_cuenta_contable nivel_6,     
a.nivel_7_cuenta_contable nivel_7,     
a.nivel_8_cuenta_contable nivel_8,
DECODE(J.DEBITO_CREDITO_OTRO, 'C', 'Cr', 'D', 'Db','O', ' ')  dbcr1 ,
f.codigo_agencia_origen
FROM  mg_agencias_generales  c, bc_historicos_detalles e, mg_monedas b, bc_corresponsal_cuentas g, mg_tipos_de_canje d, bc_historicos_movimientos f, bc_cheques_impresos h,
bc_conceptos_x_transacciones a,    MG_TIPOS_DE_TRANSACCIONES J
WHERE 	j.codigo_aplicacion 		= a.codigo_aplicacion
and	j.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and          f.codigo_aplicacion 		= a.codigo_aplicacion
and	f.codigo_tipo_transaccion 	                = a.codigo_tipo_transaccion
and	f.codigo_aplicacion_concepto 	= a.codigo_aplicacion_origen
and	f.codigo_transaccion_concepto = a.codigo_transaccion_concepto
and	f.codigo_moneda		= a.codigo_moneda
and          e.codigo_empresa = nvl( :P_codigo_empresa,e.codigo_empresa)
and          e.codigo_agencia = nvl(:P_codigo_agencia,e.codigo_agencia)
and          e.codigo_moneda = nvl(:P_codigo_moneda,e.codigo_moneda)
and          e.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,e.codigo_agencia_corresponsal)
and          e.numero_cuenta = nvl(:p_numero_cuenta,e.numero_cuenta)
and          e.numero_documento  = nvl(:p_numero_cheque, e.numero_documento)
and         d.codigo_tipo_canje   = e.codigo_tipo_canje
and         d.tipo_cheque_banco = 2
and          c.codigo_agencia  = e.codigo_agencia_corresponsal
and          c.codigo_empresa = e.codigo_empresa
and          b.codigo_moneda = e.codigo_moneda
and          g.codigo_empresa = e.codigo_empresa
and          g.codigo_agencia  = e.codigo_agencia
and          g.codigo_moneda  = e.codigo_moneda
and         g.codigo_agencia_corresponsal = e.codigo_agencia_corresponsal
and         g.numero_cuenta  = e.numero_cuenta
and         f.secuencia_movimiento = e.secuencia_movimiento
and         f.fecha_movimiento         = e.fecha_movimiento
and        f.codigo_usuario               = e.codigo_usuario_movimiento
and        f.estado_movimiento        = 1
and        h.codigo_empresa = nvl( :P_codigo_empresa,h.codigo_empresa)
and         h.codigo_agencia = nvl(:P_codigo_agencia,h.codigo_agencia)
and          h.codigo_moneda = nvl(:P_codigo_moneda,h.codigo_moneda)
and          h.codigo_agencia_corresponsal =
                nvl(:P_codigo_corresponsal,h.codigo_agencia_corresponsal)
and          h.numero_cuenta = nvl(:p_numero_cuenta,h.numero_cuenta)
and          to_char(h.numero_cheque)  = nvl(:p_numero_cheque, to_char(h.numero_cheque))


-- ======================================================================== QUERY 2: Q_DESGLOSE
select monto monto_desglose,  a.descripcion, a.codigo_transaccion_trn,
a.secuencia_movimiento,a.codigo_usuario,a.fecha_movimiento,
cdes.nivel_1 nivel_1_desglose,
cdes.nivel_2 nivel_2_desglose,
cdes.nivel_3 nivel_3_desglose,
cdes.nivel_4 nivel_4_desglose,
cdes.nivel_5 nivel_5_desglose,
cdes.nivel_6 nivel_6_desglose,
cdes.nivel_7 nivel_7_desglose,
cdes.nivel_8 nivel_8_desglose,
cdes.descripcion_desglose desc_contable_desglose
from bc_movimientos_desgloses a,
bc_conceptos_desgloses cdes, mg_tipos_de_transacciones b, bc_movimientos c
where a.secuencia_desglose = cdes.secuencia_desglose
and     a.codigo_aplicacion_trn =   cdes.codigo_aplicacion_trn
and     a.codigo_transaccion_trn = cdes.codigo_transaccion_trn
and     a.codigo_moneda            = cdes.codigo_moneda
and    a.codigo_aplicacion_concepto = cdes.codigo_aplicacion_concepto
and   a.codigo_transaccion_concepto = cdes.codigo_transaccion_concepto
and   b.codigo_aplicacion = 'BBC'
and   b.codigo_tipo_transaccion = a.codigo_transaccion_trn
and c.fecha_movimiento = a.fecha_movimiento
and c.codigo_usuario = a.codigo_usuario
and c.secuencia_movimiento = a.secuencia_movimiento
UNION ALL
select monto monto_desglose,  a.descripcion, a.codigo_transaccion_trn,
a.secuencia_movimiento,a.codigo_usuario_movimiento,a.fecha_movimiento,
cdes.nivel_1 nivel_1_desglose,
cdes.nivel_2 nivel_2_desglose,
cdes.nivel_3 nivel_3_desglose,
cdes.nivel_4 nivel_4_desglose,
cdes.nivel_5 nivel_5_desglose,
cdes.nivel_6 nivel_6_desglose,
cdes.nivel_7 nivel_7_desglose,
cdes.nivel_8 nivel_8_desglose,
cdes.descripcion_desglose desc_contable_desglose
from bc_historicos_desgloses a,
bc_conceptos_desgloses cdes, mg_tipos_de_transacciones b, bc_historicos_movimientos c
where a.secuencia_desglose = cdes.secuencia_desglose
and     a.codigo_aplicacion_trn =   cdes.codigo_aplicacion_trn
and     a.codigo_transaccion_trn = cdes.codigo_transaccion_trn
and     a.codigo_moneda            = cdes.codigo_moneda
and    a.codigo_aplicacion_concepto = cdes.codigo_aplicacion_concepto
and   a.codigo_transaccion_concepto = cdes.codigo_transaccion_concepto
and   b.codigo_aplicacion = 'BBC'
and   b.codigo_tipo_transaccion = a.codigo_transaccion_trn
and c.fecha_movimiento = a.fecha_movimiento
and c.codigo_usuario = a.codigo_usuario_movimiento
and c.secuencia_movimiento = a.secuencia_movimiento


-- ======================================================================== QUERY 3: Q_DETALLE
select 
a.secuencia_movimiento,a.codigo_usuario_movimiento,a.fecha_movimiento,
b.codigo_empresa,
b.nivel_1_cuenta_contable  nivel_1_saldo,
b.nivel_2_cuenta_contable nivel_2_saldo,
b.nivel_3_cuenta_contable nivel_3_saldo,
b.nivel_4_cuenta_contable nivel_4_saldo,
b.nivel_5_cuenta_contable nivel_5_saldo,
b.nivel_6_cuenta_contable nivel_6_saldo,
b.nivel_7_cuenta_contable nivel_7_saldo,
b.nivel_8_cuenta_contable nivel_8_saldo,
d.valor,
'Banco'||' '||f.nombre_agencia||', '||b.numero_cuenta desc_contable_saldo,
DECODE(E.DEBITO_CREDITO_OTRO, 'D', 'Cr', 'C', 'Db','O', ' ')  dbcr2
from bc_movimientos_detalles a, bc_movimientos d, bc_corresponsal_saldos b,
mg_tipos_de_canje c, mg_tipos_de_transacciones e,
mg_agencias_generales f
where  a.codigo_agencia_corresponsal = f.codigo_agencia  
and   a.numero_cuenta = b.numero_cuenta
and     a.codigo_empresa = b.codigo_empresa
and     a.codigo_agencia  = b.codigo_agencia
and     a.codigo_agencia_corresponsal = b.codigo_agencia_corresponsal
and     a.codigo_tipo_canje = c.codigo_tipo_canje
and     b.tipo_saldo       = c.tipo_saldo_banco
and  a.secuencia_movimiento  = d.secuencia_movimiento
and  a.fecha_movimiento        = d.fecha_movimiento
and  a.codigo_usuario_movimiento        = d.codigo_usuario
and   e.codigo_aplicacion   = d.codigo_aplicacion_concepto
and  e.codigo_tipo_transaccion          = d.codigo_tipo_transaccion
AND B.TIPO_SALDO = 1
UNION
select 
a.secuencia_movimiento,a.codigo_usuario_movimiento,a.fecha_movimiento,
b.codigo_empresa,
b.nivel_1_cuenta_contable  nivel_1_saldo,
b.nivel_2_cuenta_contable nivel_2_saldo,
b.nivel_3_cuenta_contable nivel_3_saldo,
b.nivel_4_cuenta_contable nivel_4_saldo,
b.nivel_5_cuenta_contable nivel_5_saldo,
b.nivel_6_cuenta_contable nivel_6_saldo,
b.nivel_7_cuenta_contable nivel_7_saldo,
b.nivel_8_cuenta_contable nivel_8_saldo,
d.valor,
'Banco'||' '||f.nombre_agencia||', '||b.numero_cuenta desc_contable_saldo,
DECODE(E.DEBITO_CREDITO_OTRO, 'D', 'Cr', 'C', 'Db','O', ' ')  dbcr2
from bc_historicos_detalles a, bc_historicos_movimientos d, bc_corresponsal_saldos b,
mg_tipos_de_canje c, mg_tipos_de_transacciones e,
mg_agencias_generales f
where  a.codigo_agencia_corresponsal = f.codigo_agencia  
and   a.numero_cuenta = b.numero_cuenta
and     a.codigo_empresa = b.codigo_empresa
and     a.codigo_agencia  = b.codigo_agencia
and     a.codigo_agencia_corresponsal = b.codigo_agencia_corresponsal
and     a.codigo_tipo_canje = c.codigo_tipo_canje
and     b.tipo_saldo       = c.tipo_saldo_banco
and  a.secuencia_movimiento  = d.secuencia_movimiento
and  a.fecha_movimiento        = d.fecha_movimiento
and  a.codigo_usuario_movimiento        = d.codigo_usuario
and   e.codigo_aplicacion   = d.codigo_aplicacion_concepto
and  e.codigo_tipo_transaccion          = d.codigo_tipo_transaccion
AND B.TIPO_SALDO = 1