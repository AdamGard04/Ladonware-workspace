Select a.codigo_trama trama,
       a.fecha_hora fecha_hora,
       a.codigo_usuario usuario,
       a.lote lote,
       a.numero_registro nro_reg,
       a.posicion pos,
       a.codigo_error,
       b.descripcion desc_Trama
  From mg_trama_error a, mg_tipo_tramas b, mg_trama_temp c
 where a.lote = nvl(:pr_lote, a.lote)   
   --and a.codigo_empresa = :p_empresa
  -- and a.codigo_trama = nvl(:pr_trama,a.codigo_trama)
   and a.codigo_trama = b.codigo_trama
   and a.codigo_empresa = b.codigo_empresa
   and a.lote = c.lote
   and a.numero_registro = c.numero_registro
 order by 1, 2, 3, 4, 5, 6

-- No hay funciones
