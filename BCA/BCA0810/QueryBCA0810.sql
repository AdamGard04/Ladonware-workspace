 -- Q_CA_MOVIMIENTOS_DIARIOS
Select a.codigo_usuario,a.secuencia_movimiento,a.hora,a.codigo_empresa,
       a.codigo_agencia,a.codigo_subaplicacion,a.numero_cuenta,
      to_char(a.codigo_agencia,'0000')||'-'||to_char(a.codigo_subaplicacion,'000')||'-'||
      to_char(a.numero_cuenta,'000000000000') codigo_cuenta,
       a.numero_documento,a.agencia_origen,a.valor,a.fecha_valida,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'4',0,a.valor)) creditos2,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'4',0,1)) contar_creditos,       
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'4',0,a.valor)) debitos2,
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'4',0,1)) contar_debitos,
       decode(e.tipo_operacion,'4',a.valor) otros2,
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'5',a.valor,0)) dbembargo,
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'5',1,0)) contar_dbembargo,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'5',a.valor,0)) crembargo,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'5',1,0)) contar_crembargo,
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'4',0,
               decode(e.tipo_operacion,'5',0,a.valor))) dbagencia,
       decode(e.debito_credito_otro,'D',
              decode(e.tipo_operacion,'4',0,
               decode(e.tipo_operacion,'5',0,1))) contar_dbagencia,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'4',0,
               decode(e.tipo_operacion,'5',0,a.valor))) cragencia,
       decode(e.debito_credito_otro,'C',
              decode(e.tipo_operacion,'4',0,
               decode(e.tipo_operacion,'5',0,1))) contar_cragencia,
       e.codigo_segun_banco,e.descripcion,
       f.nombre_agencia, g.descripcion nombre_subaplicacion, H.codigo_moneda,
       H.descripcion desmon, z.nombre_cuenta
  from CA_MOVIMIENTOS_DIARIOS           a,TIPOS_DE_TRANSACCIONES e,
          AGENCIAS f,
          SUB_APLICACIONES g, 
          MONEDAS H, 
          ca_cuentas_de_ahorro z
 where a.codigo_empresa = z.codigo_empresa
   and a.codigo_agencia = z.codigo_agencia
   and a.codigo_subaplicacion = z.codigo_subaplicacion
   and a.numero_cuenta = z.numero_cuenta 
   and a.codigo_aplicacion  = e.codigo_aplicacion
   and a.situacion_movimiento <> '5'
   and a.codigo_tipo_transaccion = e.codigo_tipo_transaccion
   and a.codigo_empresa          = f.codigo_empresa
   and a.agencia_origen          = f.codigo_agencia
   and a.codigo_subaplicacion    = g.codigo_sub_aplicacion
   and a.codigo_empresa = :CODIGO_EMPRESA_P
   and (a.agencia_origen = :CODIGO_AGENCIA_P  or
        :CODIGO_AGENCIA_P is null)
   and (a.codigo_subaplicacion = :CODIGO_SUBAPLICACION_P or
        :CODIGO_SUBAPLICACION_P is null)
   and (a.numero_cuenta = :cuenta_p or
        :cuenta_p is null)
   and (e.codigo_segun_banco = :CODIGO_SEGUN_BANCO_P  or
        :CODIGO_SEGUN_BANCO_P is null)
   and (a.codigo_usuario = upper(:CODIGO_USUARIO_P)  or
        :CODIGO_USUARIO_P is null) 
   and g.codigo_moneda = H.codigo_moneda
  and a.codigo_aplicacion = g.codigo_aplicacion
 order by H.codigo_moneda,a.agencia_origen,a.codigo_subaplicacion,e.codigo_segun_banco,H.codigo_moneda,
          a.codigo_usuario,a.codigo_agencia,a.codigo_subaplicacion,
          a.numero_cuenta,a.secuencia_movimiento

          
-- Q_CA_INTEGRACIONES
select a.codigo_usuario,a.secuencia_movimiento,
       decode(b.validar,'E',a.valor) Efectivo,
       decode(b.validar,'C',a.valor) Cheques_propios,
       decode(b.validar,'B',a.valor,'A',a.valor) Reserva_OB,
       decode(b.validar,'G',a.valor) Reserva_Exterior
  from CA_INTEGRACIONES a,TIPOS_DE_canje b
 where a.codigo_tipo_reserva = b.codigo_tipo_canje


