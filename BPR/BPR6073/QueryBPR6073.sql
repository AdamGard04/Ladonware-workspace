select A.CODIGO_TIPO,
          c.codigo_ejecutivo CODIGO_EJECUTIVO, 
          u.nombres||' '||u.primer_apellido||' '||u.segundo_apellido nombre_ejecutivo,
          a.numero_prestamo,
          a.codigo_sub_aplicacion,
          a.codigo_agencia,
          a.codigo_cliente, 
          b.nombre_completo,
          a.tasa_base_int_mora,
          a.spread_mora,
          a.relacion_matematica_mora,
          (:fecha_hoy- e.fecha_vence) dias_mora,
          e.numero_cuota,
          e.fecha_vence,
         sum(decode(g.tipo_abono,'I',decode(g.tipo_saldo,3,f.valor- NVL(F.VALOR_PAGADO,0),0),0)) interes_mora,
         sum(decode(g.tipo_abono,'G',f.valor - NVL(F.VALOR_PAGADO,0), 'P',f.valor - NVL(F.VALOR_PAGADO,0),'T',f.valor - NVL(F.VALOR_PAGADO,0),0))  comision, -- comision, gastos, impuesto
          sum(decode(g.tipo_abono,'C',f.valor- NVL(F.VALOR_PAGADO,0),0))  monto_capital,
         sum(decode(g.tipo_abono,'I',
                 decode(g.tipo_saldo,1,f.valor- NVL(F.VALOR_PAGADO,0),2,f.valor-NVL(F.VALOR_PAGADO,0),0),0)) monto_interes,
           sum(decode(g.tipo_abono,'I',decode(g.tipo_saldo,1,0,
                                                                                         2,0,
                                                                                         3,0,f.valor- NVL(F.VALOR_PAGADO,0)),0))OTROS_SALDOS ,
          m.codigo_moneda,
          m.descripcion desc_moneda,
          a.fecha_ultimo_pago,a.fecha_apertura,a.fecha_ultimo_desembolso,a.intereses_vencidos,a.valor_desembolsos
from pr_prestamos a,
       mg_clientes b,
       pr_contratos c,
       mg_monedas m,
       mg_sub_aplicaciones d,
       pr_plan_pago e,
       pr_saldos_plan_pago f,
       pr_tipos_saldo g,
       mg_usuarios_del_sistema u,
       mg_bancas L
where   a.codigo_cliente = b.codigo_cliente
and      a.numero_contrato = c.numero_contrato
and      a.codigo_sub_aplicacion = c.codigo_sub_aplicacion
and      a.codigo_agencia = c.codigo_agencia
and      a.codigo_empresa = c.codigo_empresa
and      a.estado = 1
and      a.codigo_banca     =  L.codigo_banca
and      c.codigo_ejecutivo = u.codigo_usuario
and      a.codigo_estado_cartera in ('A','B')
/*************************************************/
and      a.numero_prestamo = e.numero_prestamo
and      a.codigo_sub_aplicacion = e.codigo_sub_aplicacion
and      a.codigo_agencia = e.codigo_agencia
and      a.codigo_empresa = e.codigo_empresa
and      nvl(e.pagado,'N') = 'N'
and      e.fecha_vence < :fecha_hoy
/**************************************************/
and      e.numero_cuota = f.numero_cuota
and      e.numero_prestamo = f.numero_prestamo
and      e.codigo_sub_aplicacion = f.codigo_sub_aplicacion
and      e.codigo_agencia = f.codigo_agencia
and      e.codigo_empresa = f.codigo_empresa
and      f.codigo_tipo_saldo = g.codigo_tipo_saldo
/**************************************************/
and      d.codigo_sub_aplicacion = a.codigo_sub_aplicacion
and      d.codigo_aplicacion = 'BPR'
and      d.codigo_empresa = a.codigo_empresa
and      d.codigo_moneda = m.codigo_moneda
/*****************************************************/
and      d.codigo_moneda            = nvl(:p_moneda,d.codigo_moneda)
and      l.tipo_banca                     = nvl(:p_tipo_banca,l.tipo_banca)
and     a.codigo_banca                = nvl(:p_codigo_banca,a.codigo_banca)
and      a.codigo_cliente              = nvl(:p_codigo_cliente,a.codigo_cliente)
and      a.codigo_sub_aplicacion = nvl(:p_sub_aplicacion,a.codigo_sub_aplicacion)
and      NVL(a.codigo_tipo,0)                   = nvl(:p_tipo_prestamo,NVL(a.codigo_tipo,0))
and      c.codigo_ejecutivo          = nvl(:p_ejecutivo,c.codigo_ejecutivo)
/* Fideicomiso */
and nvl(a.clave_producto,0) = nvl(:p_clave_producto,nvl(a.clave_producto,0))
/* Fideicomiso */
group by  A.CODIGO_TIPO,
          c.codigo_ejecutivo, 
          u.nombres||' '||u.primer_apellido||' '||u.segundo_apellido,
          a.numero_prestamo,
          a.codigo_sub_aplicacion,
          a.codigo_agencia,
          a.codigo_cliente, 
          b.nombre_completo,
          a.tasa_base_int_mora,
          a.spread_mora,
          a.relacion_matematica_mora,
          (:fecha_hoy- e.fecha_vence) ,
          e.numero_cuota,
          e.fecha_vence,
          m.codigo_moneda,
          m.descripcion ,
          a.fecha_ultimo_pago,a.fecha_apertura,a.fecha_ultimo_desembolso,a.intereses_vencidos, a.valor_desembolsos
order by  a.codigo_tipo,u.nombres||' '||u.primer_apellido||' '||u.segundo_apellido,b.nombre_completo,a.numero_prestamo,e.numero_cuota  
