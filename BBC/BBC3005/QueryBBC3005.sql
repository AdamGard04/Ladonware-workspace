SELECT a.CODIGO_EMPRESA, a.CODIGO_AGENCIA, b.nombre_agencia, a.CODIGO_MONEDA,
 a.CODIGO_AGENCIA_CORRESPONSAL, a.NUMERO_CUENTA, a.NUMERO_CHEQUE_INICIAL,
 a.CANTIDAD_CHEQUE, a.ULTIMO_CHEQUE_EMITIDO,
 d.nombre, e .descripcion, f.nombre_agencia
 from BC_CHEQUERAS a,
 mg_agencias_generales b,
 bc_corresponsal_cuentas c,
 mg_empresas d,
 mg_monedas e,
 mg_agencias_generales f
 where a.estado_chequera = 1 and
 a.tipo_chequera = 'U' and
 a.codigo_agencia_corresponsal = b.codigo_agencia and
 c.codigo_empresa = a.codigo_empresa and
 c.codigo_agencia = a.codigo_agencia and
 c.codigo_moneda     = a.codigo_moneda and
 c.codigo_agencia_corresponsal = a.codigo_agencia_corresponsal and
 c.numero_cuenta    = a.numero_cuenta and
 a.codigo_empresa = d.codigo_empresa and
 a.codigo_moneda = e.codigo_moneda and
 a.codigo_agencia = f.codigo_agencia and
 c.maneja_chequera = 'S' and
 c.punto_reorden >= a.cantidad_cheque - (select sum(x.cantidad_cheque)
from BC_CHEQUERAS x
 where x.estado_chequera = 1 and
 NVL(x.tipo_chequera,'Z') <> 'U' and
 x.codigo_empresa = a.codigo_empresa and
 x.codigo_agencia = a.codigo_agencia and
 x.codigo_moneda     = a.codigo_moneda and
 x.codigo_agencia_corresponsal = a.codigo_agencia_corresponsal and
 x.numero_cuenta    = a.numero_cuenta group by x.numero_cuenta)




 function CF_NOMBRE_EMPRESAFormula return VARCHAR2 is
Lv_Empresa VARCHAR2(30);
begin
  SELECT NOMBRE INTO Lv_Empresa
  FROM MG_EMPRESAS
  WHERE CODIGO_EMPRESA = :P_CODIGO_EMPRESA;
  RETURN(Lv_Empresa);
  RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;




function CF_FECHA_HOYFormula return Date is
Ld_FechaHoy date;
begin
  SELECT FECHA_HOY INTO Ld_FechaHoy
  FROM MG_CALENDARIO
  WHERE CODIGO_EMPRESA    = :P_CODIGO_EMPRESA
  AND   CODIGO_APLICACION = :P_CODIGO_APLICACION;
  RETURN Ld_FechaHoy;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;


function CG$C_USERFormula return VARCHAR2 is
begin
  return(:P_USER_REP);
end;