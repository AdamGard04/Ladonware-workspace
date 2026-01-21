-- Q_REPORTES:
select ANIO_FISCAL, ANULADO_VIGENTE, CODIGO_EMPRESA, DESCRIPCION, FECHA_ENTREGA, MES_FISCAL from GM_ENTREGA_REPORTES_OFICIALES
where codigo_empresa = :P_codigo_empresa


-- Funciones:
function CF_estatusFormula return VARCHAR2 is
begin
  if :anulado_vigente = 'A' THEN
     RETURN('ANULADO');
  ELSIF :anulado_vigente = 'V' THEN
     RETURN('VIGENTE');
  END IF;
RETURN NULL; end;