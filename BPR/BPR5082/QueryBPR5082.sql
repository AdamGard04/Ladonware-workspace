-- Q_PRESTAMO
select  a.codigo_agencia,
        a.codigo_sub_aplicacion,
        numero_prestamo,
        nombre_completo nombre,
        decode(tipo_tasa,'0','Fijo','1','Flotante','5','F Periodica','Otros') tipo_tasa,
        codigo_valor_tasa_cartera,
        tasa_base_int_corriente,
        relacion_matematica_1,
        spread_corriente_1,
        tasa_total,
        decode(tipo_frecuencia_revision,2,'Mensual',1,'Diaria',null)
 frecuencia_revision_tasa,
        periodo_tasa,
        dia_revision_tasa,
        fecha_ult_revision_tasa_int,
        fecha_revision_int,
        fecha_proximo_pago_capital,
        fecha_proximo_pago_interes,
       c.descripcion, 
       M.NOMBRE_AGENCIA,
       a.fecha_vencimiento,
       a.fecha_apertura

 from pr_prestamos a,
      mg_clientes b,
      mg_sub_aplicaciones c,
      MG_AGENCIAS M
 where b.codigo_cliente=a.codigo_cliente     
   AND A.CODIGO_EMPRESA = M.CODIGO_EMPRESA
   AND A.CODIGO_AGENCIA = M.CODIGO_AGENCIA
   and   a.codigo_sub_aplicacion = c.codigo_sub_aplicacion
  and    c.codigo_aplicacion = 'BPR'
  and    numero_prestamo = nvl(:p_prestamo,numero_prestamo)
 AND    nvl(tipo_tasa,'9') = nvl(:P_tipo_Tasa,nvl(tipo_tasa,'9'))
 AND  a. ESTADO = 1
 ORDER BY
         a.codigo_agencia ,
         codigo_sub_aplicacion,  
         tipo_tasa