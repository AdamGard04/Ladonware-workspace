-- Q_DATOS_PRESTAMO --> Q_LOAN_DATA
select d.codigo_empresa,  y.ubicacion_contable, decode(y.ubicacion_contable,'P','PASIVO','A','ACTIVO') ubicacion,
        y.codigo_moneda, d.codigo_origen, 
        d.codigo_agencia,z.nombre_agencia,
       d.codigo_sub_aplicacion,y.descripcion nombre_subaplicacion,
       d.numero_prestamo, p.numero_documento_anterior,
       c.nombre_completo nombre_cliente,
       m.descripcion,
       d.monto_inicial,
       d.fecha_apertura,d.fecha_vencimiento,
       d.tasa_total,
       ct.codigo_inversion,
       d.codigo_tipo,
       d.codigo_estado_cartera,
       e.descripcion estado
from mg_agencias z,mg_sub_aplicaciones y,
     mg_clientes c, pr_fin_mes d, pr_contratos ct, pr_estados_cartera e,
     mg_monedas m, pr_prestamos p
WHERE d.anio_mes = :p_anio_mes
  and ct.numero_contrato = d.numero_contrato
  and ct.codigo_sub_aplicacion = d.codigo_sub_aplicacion
  and ct.codigo_agencia = d.codigo_agencia
  and ct.codigo_empresa = d.codigo_empresa
  and d.numero_prestamo >= nvl(:prestamo_ini, d.numero_prestamo)
  and d.numero_prestamo <= nvl(:prestamo_fin, d.numero_prestamo)
  and d.codigo_sub_aplicacion = NVL(:codigo_sub_aplicacion_p,d.codigo_sub_aplicacion)
  and d.codigo_agencia = NVL(:codigo_agencia_p,d.codigo_agencia)
  AND d.codigo_empresa = :codigo_empresa_p
  AND d.codigo_origen = nvl(:p_codigo_origen, d.codigo_origen)
  AND ct.codigo_inversion = nvl(:p_codigo_inversion, ct.codigo_inversion)
  AND d.estado = nvl(:estado_p,d.estado)
  and  d.codigo_tipo = nvl(:p_tipo, d.codigo_tipo)
  AND d.codigo_estado_cartera = nvl(:p_estado_cartera, d.codigo_estado_cartera)
  AND c.codigo_cliente = d.codigo_cliente
  AND y.codigo_sub_aplicacion = d.codigo_sub_aplicacion
  AND y.codigo_aplicacion = 'BPR'
  AND y.ubicacion_contable = nvl(:P_UBICACION, y.ubicacion_contable)
  AND z.codigo_agencia = d.codigo_agencia
  and z.codigo_empresa = d.codigo_empresa
  AND e.codigo_sub_aplicacion = d.codigo_sub_aplicacion
  and e.codigo_tipo_amortizacion = d.codigo_tipo_amortizacion
  and e.codigo_estado_cartera = d.codigo_estado_cartera
  AND y.codigo_moneda = m.codigo_moneda
AND d.codigo_empresa = p.codigo_empresa
and d.codigo_agencia = p.codigo_agencia
and d.codigo_sub_aplicacion = p.codigo_sub_aplicacion
and d.numero_prestamo = p.numero_prestamo
ORDER BY 3,1,4,6,10;

-- Q_SALDOS --> Q_BALANCES
SELECT a.codigo_empresa emp, a.codigo_agencia agen,
       a.codigo_sub_aplicacion suba ,a.numero_prestamo numprest,
       SUM(DECODE(b.tipo_abono,'C',a.valor,0)) Capital,
       --SUM(DECODE(b.tipo_abono,'I',decode(b.tipo_saldo,1,a.valor,2,a.valor,4,a.valor,0))) Interes,
       SUM(DECODE(b.tipo_abono,'I',decode(a.codigo_tipo_saldo,38,0,39,0,decode(b.tipo_saldo,1,a.valor,2,a.valor,4,a.valor,0)))) Interes,
       SUM(DECODE(b.tipo_abono,'I',decode(a.codigo_tipo_saldo,38,a.valor,39,a.valor,0))) InteresSuspenso,
       SUM(DECODE(b.tipo_abono,'T',a.valor,0)) Impuesto,
      --SUM(DECODE(b.tipo_abono,'I',decode(b.tipo_saldo,3,a.valor,0))) Mora,
      SUM(DECODE(b.tipo_abono,'I', decode(a.codigo_tipo_saldo,36,0,decode(b.tipo_saldo,3,a.valor,0)))) Mora,
      SUM(DECODE(b.tipo_abono,'I', decode(a.codigo_tipo_saldo,36,decode(b.tipo_saldo,3,a.valor,0),0))) MoraSuspenso,
       SUM(DECODE(b.tipo_saldo,5,a.valor,0)) Anticipos,
       sum(decode(b.tipo_abono,'S',a.valor,0)) seguros,
       sum(decode(b.tipo_abono,'P',a.valor,'G',a.valor,0)) comision,      
       sum(decode(b.tipo_saldo,5,0,decode(b.tipo_abono,'C',0,'I',0,'S',0,'P',0,a.valor))) otros
  FROM PR_SALDOS_FIN_MES_DETALLE a, PR_TIPOS_SALDO b
 WHERE a.codigo_empresa = :CODIGO_EMPRESA_P
  AND b.codigo_tipo_saldo = a.codigo_tipo_saldo
  AND A.ANIO_MES = :P_ANIO_MES
  AND nvl(a.valor,0) > 0
GROUP BY a.codigo_empresa,a.codigo_agencia,
         a.codigo_sub_aplicacion,a.numero_prestamo;


-- NOMBRE_inversion
function CF_descripcion_inversionFormul return Char is
  lv_descripcion varchar2(60);
begin
  select descripcion
  into lv_descripcion
  from mg_tipo_inversion
  where codigo_inversion = :codigo_inversion;
  return lv_descripcion;
exception
	when no_data_found then return 'NO EXISTE';
end;

-- NOMBRE_CLASE
function CF_descripcion_claseFormula return Char is
  lv_descripcion varchar2(60);
begin
  select descripcion
  into lv_descripcion
  from pr_clase_prestamo
  where codigo_tipo = :codigo_tipo;
  return lv_descripcion;
exception
	when no_data_found then return 'NO EXISTE';
end;

-- NOMBRE_CLASE1

function CF_descripcion_claseFormula return Char is
  lv_descripcion varchar2(60);
begin
  select descripcion
  into lv_descripcion
  from pr_clase_prestamo
  where codigo_tipo = :codigo_tipo;
  return lv_descripcion;
exception
	when no_data_found then return 'NO EXISTE';
end;


-- NOMBRE_inversion1
function CF_descripcion_inversionFormul return Char is
  lv_descripcion varchar2(60);
begin
  select descripcion
  into lv_descripcion
  from mg_tipo_inversion
  where codigo_inversion = :codigo_inversion;
  return lv_descripcion;
exception
	when no_data_found then return 'NO EXISTE';
end;


-- F_descripcion_origen2
function CF_origenFormula return Char is
  lv_descripcion varchar2(200);
begin
  select descripcion
  into lv_descripcion
  from mg_origen_recursos
  where codigo_origen = :codigo_origen;
  return lv_descripcion;
exception
	when no_data_found then return 'NO EXISTE';
end;

-- 