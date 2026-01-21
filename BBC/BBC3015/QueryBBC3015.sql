-- Q_DETALLE
select 
   b.secuencia_solicitud,
   b.fecha_solicitud,
   b.codigo_usuario,
   b.valor,
   b.codigo_moneda,
   b.tasa_cambio,
   b.valor_moneda_cambio,
   b.numero_referencia,
   b.beneficiario,
   b.descripcion,
   b.codigo_tipo_canje
 From  bc_solicitudes_detalles b


 -- Q_maestro
 Select  
 a.secuencia_solicitud,
 a.codigo_usuario,
 a.fecha_solicitud,
 a.codigo_tipo_transaccion,
 a.codigo_aplicacion,
 a.codigo_transaccion_concepto,
 a.codigo_aplicacion_concepto,
 a.codigo_moneda,
 a.estado_solicitud,
 a.codigo_aplicacion_auxiliar
from bc_solicitudes_transacciones a
where codigo_tipo_transaccion = 2
and  a.fecha_solicitud between nvl(:p_fecha_ini,a.fecha_solicitud) and  nvl(:p_fecha_fin,a.fecha_solicitud)
order by
 codigo_transaccion_concepto, codigo_moneda


 -- funciones:
 -- F_CF_estado
 function CF_estadoFormula return VARCHAR2 is
var_estado        varchar2(180);
begin
  if :estado_solicitud = 'A' Then
    var_estado := 'TRANSACCIONES PROCESADAS';
    return(var_estado);
  Else
   -- var_estado := 'TRANSACCIONES NO PROCESADAS';
    var_estado := 'TRANSACCIONES REVERSADAS';
     return(var_estado);
  end if;
RETURN NULL; end;


-- F_CF_tran
function CF_transaccionFormula return VARCHAR2 is
var_tran        varchar2(80);
begin
  Select descripcion into Var_tran
  From mg_tipos_de_transacciones
  Where codigo_tipo_transaccion = :codigo_tipo_transaccion and
        codigo_aplicacion = :codigo_aplicacion;
  return(var_tran);
    RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;


-- F_CF_conc
function CF_conceptoFormula return VARCHAR2 is
var_concepto     varchar2(80);
begin
  Select descripcion into Var_concepto
  From mg_tipos_de_transacciones
  Where codigo_tipo_transaccion = :codigo_transaccion_concepto and
        codigo_aplicacion = :codigo_aplicacion_concepto;
  return(var_concepto);
    RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;


-- F_CF_mon
function CF_monFormula return VARCHAR2 is
   var_moneda        varchar2(80);
begin
  Select descripcion into Var_moneda
  From mg_monedas
  Where codigo_moneda = :codigo_moneda1;
  return(var_moneda);
    RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;


-- F_CF_aux
function CF_CONCEPTOFORMULA0037 return VARCHAR2 is
var_aux     varchar2(80);
begin
  Select nombre into Var_aux
  From mg_aplicaciones
  Where codigo_aplicacion = :codigo_aplicacion_auxiliar;
  return(var_aux);
    RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;


-- F_CF_pago
function CF_pagoFormula return VARCHAR2 is
   var_pago       varchar2(80);
begin
  Select descripcion into Var_pago
  From mg_tipos_de_canje
  Where codigo_tipo_canje = :codigo_tipo_canje;
  return(var_pago);
    RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;


