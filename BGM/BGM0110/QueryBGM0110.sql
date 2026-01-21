-- Q_1
select  a.codigo_criterio,
            b.descripcion descriterio,
            a.codigo_entidad,
            c.descripcion descentidad,
            a.valor
from GM_VALORES_CRIT_X_ENTIDAD a,
        gm_criterio_distribucion b,
        gm_centros_de_costos c
where  a.codigo_empresa = :p_codigo_empresa
  and a.codigo_criterio   = nvl(:p_criterio,a.codigo_criterio)
  and b.codigo_empresa = a.codigo_empresa
  and b.codigo_criterio = a.codigo_criterio
  and c.codigo_empresa = a.codigo_empresa
  and c.centro_de_costo = a.codigo_entidad
order by a.codigo_criterio,
             a.codigo_entidad

-- No hay funciones
