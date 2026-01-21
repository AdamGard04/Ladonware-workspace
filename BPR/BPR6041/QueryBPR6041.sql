-- Q_1:
select
p.codigo_tipo codigo_tipo_t,
s.codigo_moneda codigo_moneda_t ,
'TOTAL EN '||m.descripcion desc_moneda_t,
SUM(decode(tipo_abono,'C',a.VALOR,0)) saldo_t
from 
pr_prestamos p,
pr_saldos_prestamo a,
mg_sub_aplicaciones s,
mg_monedas m,
pr_clase_prestamo l,
pr_tipos_saldo t,
mg_bancas z
where p.numero_prestamo = a.numero_prestamo
and p.codigo_sub_aplicacion = a.codigo_sub_aplicacion
and p.codigo_agencia = a.codigo_agencia
and p.codigo_empresa = a.codigo_empresa
and p.fecha_revision_int between nvl(:p_fecha_desde,p.fecha_revision_int) and nvl(:p_fecha_hasta,p.fecha_revision_int)
and a.codigo_tipo_saldo = t.codigo_tipo_saldo
and t.tipo_abono in ('C','I')
----------------------------------------------------------------
and s.codigo_empresa = p.codigo_empresa
and s.CODIGO_APLICACION = 'BPR'
and s.CODIGO_SUB_APLICACION   = p.CODIGO_SUB_APLICACION
------------------------------------------------------
and s.codigo_moneda = m.codigo_moneda
and s.codigo_moneda = nvl(:p_moneda,s.codigo_moneda)
------------------------------------------------------
and p.codigo_banca = z.codigo_banca
and z.tipo_banca = nvl(:p_banca,z.tipo_banca)
and p.codigo_tipo = l.codigo_tipo
and p.codigo_tipo =  nvl(:p_cLASE_PRESTAMO,p.codigo_tipo)
------------------------------------------------------
and p.tipo_tasa <> '0'
and p.estado = '1'
------------------- Fideicomiso ---------------
and p.codigo_banca = nvl(:p_cbanca,p.codigo_banca)
and nvl(p.clave_producto,0) = nvl(:p_clave_producto,nvl(p.clave_producto,0))
and p.codigo_sub_aplicacion = nvl(:p_sub_aplicacion,p.codigo_sub_aplicacion)
-------------------------------------------------------
group by
p.codigo_tipo,
s.codigo_moneda ,
'TOTAL EN '||m.descripcion


-- Q_2:
select
z.codigo_banca, 
z.tipo_banca,
z.descripcion desc_banca,
p.codigo_empresa, 
p.codigo_agencia, 
p.codigo_sub_aplicacion, 
p.numero_contrato,
p.numero_prestamo,
p.tasa_base_int_corriente,
p.relacion_matematica_1,
p.spread_corriente_1,
p.relacion_matematica_2,
p.spread_corriente_2,
p.tasa_total,
P.TASA_PISO,
P.FECHA_TOPE_CAMBIO_TASA,
P.CODIGO_PROMOCION, 
p.tipo_frecuencia_revision,
p.periodo_tasa,
p.fecha_revision_int,
p.fecha_ult_revision_tasa_int,
p.codigo_tipo,
nvl(l.descripcion,'CLASE DE PRESTAMO NO DEFINIDO') desc_clase_prestamo,
s.codigo_moneda ,
m.descripcion desc_moneda,
p.codigo_valor_tasa_cartera,
r.descripcion desc_tasa,
p.codigo_tipo_amortizacion,
n.descripcion desc_amortizacion,
d.codigo_linea_credito,
d.codigo_agencia_lc,
d.codigo_sub_aplicacion_lc,
d.codigo_empresa_lc,
'   '||c.nombre_completo NOMBRE_COMPLETO,
SUM(decode(tipo_abono,'C',a.VALOR,0)) saldo
from 
pr_prestamos p,
pr_contratos d,
pr_saldos_prestamo a,
mg_sub_aplicaciones s,
mg_monedas m,
mg_grupos_tasa r,
pr_tipos_amortizacion n,
pr_clase_prestamo l,
pr_tipos_saldo t,
pr_tipo_saldo_subaplicacion o,
mg_clientes c,
mg_bancas z
where p.numero_contrato= d.numero_contrato
and p.codigo_sub_aplicacion = d.codigo_sub_aplicacion
and p.codigo_agencia = d.codigo_agencia
and p.codigo_empresa = d.codigo_empresa
and p.numero_prestamo = a.numero_prestamo
and p.codigo_sub_aplicacion = a.codigo_sub_aplicacion
and p.codigo_agencia = a.codigo_agencia
and p.codigo_empresa = a.codigo_empresa
and p.fecha_revision_int between nvl(:p_fecha_desde,p.fecha_revision_int) and nvl(:p_fecha_hasta,p.fecha_revision_int)
and a.codigo_tipo_saldo = t.codigo_tipo_saldo
--
and  a.codigo_tipo_saldo                  =  o.codigo_tipo_saldo
and  o.codigo_tipo_saldo                  =   t.codigo_tipo_saldo
and  o.codigo_sub_aplicacion          =   a.codigo_sub_aplicacion
and  o.codigo_empresa                    =   a.codigo_empresa
and  o.ubicacion_contable               != 'P' 
--

and t.tipo_abono in ('C','I')
and t.tipo_saldo  != 5 
----------------------------------------------------------------
and p.codigo_valor_tasa_cartera = r.codigo_valor_tasa_cartera
and p.codigo_tipo_amortizacion = n.codigo_tipo_amortizacion
----------------------------------------------------------------
and s.codigo_empresa = p.codigo_empresa
and s.CODIGO_APLICACION = 'BPR'
and s.CODIGO_SUB_APLICACION   = p.CODIGO_SUB_APLICACION
------------------------------------------------------
and s.codigo_moneda = m.codigo_moneda
and s.codigo_moneda = nvl(:p_moneda,s.codigo_moneda)
and p.codigo_cliente = c.codigo_cliente
------------------------------------------------------
and p.codigo_banca = z.codigo_banca
and z.tipo_banca = nvl(:p_banca,z.tipo_banca)
and p.codigo_tipo = l.codigo_tipo (+)
and nvl(p.codigo_tipo,0) =  nvl(:p_CLASE_PRESTAMO,nvl(p.codigo_tipo,0))
------------------------------------------------------
and p.tipo_tasa <> '0'
and p.estado = '1'
and nvl(p.valor_desembolsos,0) > 0 
------------------- Fideicomiso ---------------
and p.codigo_banca = nvl(:p_cbanca,p.codigo_banca)
and nvl(p.clave_producto,0) = nvl(:p_clave_producto,nvl(p.clave_producto,0))
and p.codigo_sub_aplicacion = nvl(:p_sub_aplicacion,p.codigo_sub_aplicacion)
-------------------------------------------------------
group by
z.codigo_banca,
z.tipo_banca,
z.descripcion,
p.codigo_empresa, 
p.codigo_agencia, 
p.codigo_sub_aplicacion, 
p.numero_contrato,
p.numero_prestamo,
p.tasa_base_int_corriente,
p.relacion_matematica_1,
p.spread_corriente_1,
p.relacion_matematica_2,
p.spread_corriente_2,
p.tasa_total,
P.TASA_PISO,
P.FECHA_TOPE_CAMBIO_TASA,
P.CODIGO_PROMOCION,
p.tipo_frecuencia_revision,
p.periodo_tasa,
p.fecha_revision_int,
p.fecha_ult_revision_tasa_int,
p.codigo_tipo,
nvl(l.descripcion,'CLASE DE PRESTAMO NO DEFINIDO') ,
s.codigo_moneda ,
m.descripcion,
p.codigo_valor_tasa_cartera,
r.descripcion ,
p.codigo_tipo_amortizacion,
n.descripcion ,
d.codigo_linea_credito,
d.codigo_agencia_lc,
d.codigo_sub_aplicacion_lc,
d.codigo_empresa_lc,
'   '||c.nombre_completo
order by p.fecha_revision_int, nombre_completo


-- Q_3:
select
s.codigo_moneda codigo_moneda_g,
'TOTAL GENERAL EN '||m.descripcion desc_moneda_g,
SUM(decode(tipo_abono,'C',a.VALOR,0)) saldo_g
from 
pr_prestamos p,
pr_saldos_prestamo a,
mg_sub_aplicaciones s,
mg_monedas m,
pr_clase_prestamo l,
pr_tipos_saldo t,
pr_tipo_saldo_subaplicacion o,
mg_bancas z
where p.numero_prestamo = a.numero_prestamo
and p.codigo_sub_aplicacion = a.codigo_sub_aplicacion
and p.codigo_agencia = a.codigo_agencia
and p.codigo_empresa = a.codigo_empresa
and p.fecha_revision_int between nvl(:p_fecha_desde,p.fecha_revision_int) and nvl(:p_fecha_hasta,p.fecha_revision_int)
and a.codigo_tipo_saldo = t.codigo_tipo_saldo
and t.tipo_abono in ('C','I')
and  t.tipo_saldo != 5
--
and  a.codigo_tipo_saldo =  o.codigo_tipo_saldo
and  t.codigo_tipo_saldo  =  o.codigo_tipo_saldo
and  o.codigo_sub_aplicacion = a.codigo_sub_aplicacion
and  o.codigo_empresa           = a.codigo_empresa
and  o.ubicacion_contable != 'P'
--
----------------------------------------------------------------
and s.codigo_empresa = p.codigo_empresa
and s.CODIGO_APLICACION = 'BPR'
and s.CODIGO_SUB_APLICACION   = p.CODIGO_SUB_APLICACION
------------------------------------------------------
and s.codigo_moneda = m.codigo_moneda
and s.codigo_moneda = nvl(:p_moneda,s.codigo_moneda)
------------------------------------------------------
and p.codigo_banca = z.codigo_banca
and z.tipo_banca = nvl(:p_banca,z.tipo_banca)
and p.codigo_tipo = l.codigo_tipo
and p.codigo_tipo =  nvl(:p_cLASE_PRESTAMO,p.codigo_tipo)
------------------------------------------------------
and p.tipo_tasa <> '0'
and p.estado = '1'
group by
s.codigo_moneda ,
'TOTAL GENERAL EN '||m.descripcion

-- funciones:
-- F_CF_periodo:
function CF_periodoFormula return Char is
LV_DESC VARCHAR2(20);
begin
 IF :TIPO_FRECUENCIA_REVISION IS NOT NULL THEN
  if :tipo_frecuencia_revision = 1 then --dias
  	if :periodo_tasa = 1 then
  		 lv_desc := 'DIARIO';
  	elsif :periodo_tasa = 7 then
  		 lv_desc := 'SEMANAL';
   	ELSE
  		 lv_desc := 'CADA '||:PERIODO_TASA||' DIAS';
  	end if;
  elsif :tipo_frecuencia_revision = 2 then --meses
  	if :periodo_tasa = 1 then
  		 lv_desc := 'MENSUAL';
  	ELSIF :PERIODO_TASA = 2 THEN
  	   Lv_desc := 'BIMESTRAL';
  	ELSIF :PERIODO_TASA = 3 THEN
  	   lv_desc := 'TRIMESTRAL';
  	ELSIF :PERIODO_TASA = 6 THEN
  		 lv_desc := 'SEMESTRAL';
  	ELSE
  		 lv_desc := 'CADA '||:PERIODO_TASA||' MESES';
  	end if;
  END IF;
END IF;
RETURN (' '||LV_DESC);
end;

--F_PROMOCION
function CF_1Formula return Char is
LV_PROMOCION VARCHAR2(100);
begin
  IF :CODIGO_PROMOCION IS NOT NULL THEN
  	BEGIN
  	SELECT DISTINCT DESCRIPCION||' VENCE '||:FECHA_TOPE_CAMBIO_TASA INTO LV_PROMOCION
  	FROM PR_PROMOCIONES
  	WHERE CODIGO_PROMOCION = :CODIGO_PROMOCION;
  	EXCEPTION WHEN NO_DATA_FOUND THEN
  		LV_PROMOCION := 'NO EXISTE LA PROMOCION';
  	END;
  	
END IF;
RETURN(LV_PROMOCION);
end;

-- F_codigo_linea_credito1
function CF_TIPO_LINEAFormula return Number is
begin
	IF :CODIGO_LINEA_CREDITO IS NOT NULL THEN
  RETURN(1);
	ELSE
	RETURN(NULL);
	END IF;
end;

-- 