-- Funciones Originales:
-- F_2:
function CF_AGENCIAFormula return Char is
 lv_nombre_agencia varchar2(40):= null;
begin
  Select nombre_agencia
    into lv_nombre_agencia
    from mg_agencias_generales
   where codigo_agencia = :p_codigo_agencia;
   return(lv_nombre_agencia);
Exception 
	 When no_data_found then 
	   return(lv_nombre_agencia);
end;


-- F_CF_transaccion:
function CF_AGENCIAFormula return Char is
 lv_nombre_agencia varchar2(40):= null;
begin
  Select nombre_agencia
    into lv_nombre_agencia
    from mg_agencias_generales
   where codigo_agencia = :p_codigo_agencia;
   return(lv_nombre_agencia);
Exception 
	 When no_data_found then 
	   return(lv_nombre_agencia);
end;


-- F_cf_corr
function CF_agenciasFormula return VARCHAR2 is
 Var_Agencias      VARCHAR2(50);
begin
  Select nombre_agencia into Var_agencias
  From mg_agencias_generales
  Where codigo_agencia = :codigo_agencia_corresponsal;
  return(var_agencias); -- variable de agencia diferente desde la original
RETURN NULL; exception
 when no_data_found then
  null;
RETURN NULL; end;


-- F_moneda
function CF_monedaFormula return VARCHAR2 is
 Var_moneda      varchar2(50);
begin
  Select descripcion
  into Var_moneda
  From mg_monedas
  Where codigo_moneda = :codigo_Moneda;
  return(var_moneda);
RETURN NULL; exception
 when no_data_found then
  null;
RETURN NULL; end;



-- Funciones Traducidas:

-- Encabezado Reporte: BCC-3253
  

-- Cuerpo Reporte: BCC-3253
-- F_2:
function CF_BRANCHFormula return Char is
 lv_branch_name varchar2(40):= null;
begin
  Select branch_name 
    into lv_branch_name
    from mg_branches_general
   where branch_code = :p_branch_code;
   return(lv_branch_name);
Exception 
	 When no_data_found then 
	   return(lv_branch_name);
end;


-- F_CF_transaccion:
function CF_BRANCHFormula return Char is
 lv_branch_name varchar2(40):= null;
begin
  Select branch_name 
    into lv_branch_name
    from MG_BRANCHES_GENERAL 
   where branch_code = :p_branch_code;
   return(lv_branch_name);
Exception 
	 When no_data_found then 
	   return(lv_branch_name);
end;


-- F_cf_corr
function CF_branchesFormula return VARCHAR2 is
 lv_branch      VARCHAR2(50);
begin
  Select branch_name 
  From MG_BRANCHES_GENERAL 
  Where branch_code = :correspondent_branch_code;
  return(lv_branch);
RETURN NULL; exception
 when no_data_found then
  null;
RETURN NULL; end;


-- F_moneda
function CF_currencyFormula return VARCHAR2 is
 lv_currency      varchar2(50);
begin
  Select description
  into lv_currency
  From mg_currency -- cambiar a tabla de monedas en ingles
  Where currency_code = :currency_code;
  return(lv_currency);
RETURN NULL; exception
 when no_data_found then
  null;
RETURN NULL; end;