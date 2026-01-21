-- Q_MOVIMIENTOS
SELECT 
b.nombre_banco,(A.CODIGO_AGENCIA||'-'||A.CODIGO_SUB_APLICACION||'-'||A.NUMERO_DEPOSITO)  NUM_DEP,A.FECHA_VIGENCIA,
A.FECHA_VENCIMIENTO,B.VALOR,A.ADICIONADO_POR,
A.FECHA_VALOR,
A.NUMERO_DEPOSITO,
A.CODIGO_AGENCIA,
A.CODIGO_SUB_APLICACION,
A.CODIGO_APLICACION,
B.CODIGO_TIPO_PAGO,
B.CODIGO_AGENCIA_CONTRA,
B.CODIGO_SUBAPLICACION_CONTRA,
B.CODIGO_CUENTA_CONTRA,
E.DESCRIPCION,
F.CODIGO_DIRECCION,

A.CODIGO_PROPIETARIO_PRINCIPAL,
F.ZONA||F.BARRIO||F.CALLE DIRECCION,
G.VALOR NUEVO_SALDO,
G.VALOR - A.VALOR SALDO_ANT,
B.NUMERO_CHEQUE_REFERENCIA,
DECODE(A.OPERADOR_MATEMATICO,'-',(A.VALOR_TASA -NVL(A.SPREAD,0)),'+',(A.VALOR_TASA +NVL( A.SPREAD,0))) 
VALOR_TASA,
M.ABREVIATURA 

FROM DP_MOVIMIENTOS_DIARIOS A,
DP_DESGLOSE_MOVIMIENTOS B,
MG_CLIENTES D, 
MG_FORMA_PAGOS_DESEMBOLSO E,
MG_DIRECCIONES F,
DP_SALDOS G,
MG_SUB_APLICACIONES      S,
MG_MONEDAS                       M

WHERE 
(A.NUMERO_DEPOSITO = :P_NUMERO_DEPOSITO OR :P_NUMERO_DEPOSITO IS NULL)
AND(A.NUMERO_MOVIMIENTO = :P_NUMERO_MOVIMIENTO OR :P_NUMERO_MOVIMIENTO IS NULL)
AND (A.CODIGO_AGENCIA = :P_AGENCIA OR  :P_AGENCIA IS NULL)
AND (A.ADICIONADO_POR = :P_USUARIO OR :P_USUARIO IS NULL)
AND A.NUMERO_MOVIMIENTO = B.NUMERO_MOVIMIENTO
AND A.CODIGO_AGENCIA = B.CODIGO_AGENCIA 
AND A.CODIGO_SUB_APLICACION = B.CODIGO_SUB_APLICACION
AND A.NUMERO_DEPOSITO = B.NUMERO_DEPOSITO
AND A.CODIGO_EMPRESA = B.CODIGO_EMPRESA
AND A.CODIGO_PROPIETARIO_PRINCIPAL = D.CODIGO_CLIENTE
AND D.CODIGO_CLIENTE = F.CODIGO_CLIENTE(+)
AND A.CODIGO_TIPO_TRANSACCION = 17
AND B.CODIGO_TIPO_PAGO = E.CODIGO_TIPO_PAGO
AND B.CODIGO_APLICACION = E.CODIGO_APLICACION
AND A.NUMERO_DEPOSITO = G.NUMERO_DEPOSITO
AND A.CODIGO_SUB_APLICACION = G.CODIGO_SUB_APLICACION
AND A.CODIGO_AGENCIA = G.CODIGO_AGENCIA
AND A.CODIGO_EMPRESA = G.CODIGO_EMPRESA
AND G.CODIGO_TIPO_SALDO = 1
AND A.ESTADO <> 5
AND A.CODIGO_SUB_APLICACION = S.CODIGO_SUB_APLICACION
AND A.CODIGO_APLICACION = S.CODIGO_APLICACION
AND S.CODIGO_MONEDA = M.CODIGO_MONEDA

-- Q_PROPIETARIOS
SELECT CODIGO_CLIENTE, NUMERO_DEPOSITO,
CODIGO_AGENCIA, CODIGO_SUB_APLICACION, CODIGO_APLICACION,RELACION
FROM DP_PROPIETARIOS 

-- funciones:

-- F_FECHA_HOY
function CF_FECHA_HOYFormula return Date is
Ld_FechaHoy date;
begin
  SELECT FECHA_HOY INTO Ld_FechaHoy
  FROM MG_CALENDARIO
  WHERE CODIGO_EMPRESA    = :P_COD_EMPRESA
  AND   CODIGO_APLICACION = 'BDP';
  RETURN Ld_FechaHoy;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;


-- F_DESCRIPCION
function CF_DESCRIPCIONFormula return VARCHAR2 is
Ln_descripcion       varchar2(80);
begin

   if :codigo_tipo_pago in (1,2,3,4) then
      ln_descripcion :=  :descripcion||' '||to_char(:codigo_agencia_contra)||'-'||
  		         to_char(:codigo_subaplicacion_contra)||'-'||
			 to_char(:codigo_cuenta_contra);
   end if;
 
   if :codigo_tipo_pago in (14,15) then
      ln_descripcion := :NOMBRE_BANCO||' '||:numero_cheque_referencia;
   end if;
   if :codigo_tipo_pago in (8,16,19) then
      ln_descripcion := :descripcion||' '||:numero_cheque_referencia;
   end if;

   if :codigo_tipo_pago = 13 then
      ln_descripcion := :descripcion||' '||:numero_cheque_referencia||' '||'Cta. '||
                        to_char(:codigo_agencia_contra)||'-'||
  		        to_char(:codigo_subaplicacion_contra)||'-'||
			to_char(:codigo_cuenta_contra);
   end if;
   return(ln_descripcion);
      
end;


-- F_VALOR_MONTO
function CF_VALORFormula return VARCHAR2 is
 Lv_monto    varchar2(25);
begin
lv_monto := :abreviatura||' '||ltrim(to_char(nvl(:valor,0),'999,999,999,999,990.00')); 
  return(lv_monto);
end;


-- SALDO_TOTAL:
function CF_SALDOTOTALFormula return Number is
Ln_Saldo_Total number(18,2);
Ln_Saldo_Retenido number(18,2);
begin
 Select nvl(valor,0) 
 into Ln_Saldo_Retenido 
 FROM DP_SALDOS 
 WHERE NUMERO_DEPOSITO = :numero_deposito and
    -- CODIGO_EMPRESA  = ac_k_global.gicodigoempresa  and
       CODIGO_AGENCIA  = :codigo_agencia  and
       CODIGO_SUB_APLICACION = :codigo_sub_aplicacion and
       CODIGO_APLICACION     = 'BDP' and
       CODIGO_TIPO_SALDO     = 10;
       Ln_Saldo_Total    := NVL(Ln_Saldo_Retenido,0) + NVL(:nuevo_saldo,0);
       RETURN(Ln_Saldo_Total);
Exception When Others Then 
	Ln_Saldo_Retenido := 0;
        Ln_Saldo_Total    := nvl(Ln_Saldo_Retenido,0) + nvl(:nuevo_saldo,0);     
        RETURN(Ln_Saldo_Total);
end;



-- F_saldoanterior
function CF_saldoanteriorFormula return VARCHAR2 is
Ln_Saldo_Total_ant   number(18,2);
Lv_SaldoAnterior     varchar2(30);
begin
  Ln_Saldo_Total_ant := nvl(:cf_saldototal,0) - nvl(:cs_suma_monto,0); 
  lv_SaldoAnterior :=  :abreviatura||' '||ltrim(to_char(nvl(Ln_Saldo_Total_ant,0),'999,999,999,999,990.00')); 
  RETURN(lv_SaldoAnterior);
end;


-- F_nuevo_saldo
function CF_nuevo_saldoFormula return VARCHAR2 is
Lv_saldo_total   varchar2(30);
begin
  lv_saldo_total :=  :abreviatura||' '||ltrim(to_char(nvl(:cf_saldototal,0),'999,999,999,999,990.00')); 
  RETURN(Lv_Saldo_Total);
end;


-- cf_saldototalFormula:
function CF_SALDOTOTALFormula return Number is
Ln_Saldo_Total number(18,2);
Ln_Saldo_Retenido number(18,2);
begin
 Select nvl(valor,0) 
 into Ln_Saldo_Retenido 
 FROM DP_SALDOS 
 WHERE NUMERO_DEPOSITO = :numero_deposito and
    -- CODIGO_EMPRESA  = ac_k_global.gicodigoempresa  and
       CODIGO_AGENCIA  = :codigo_agencia  and
       CODIGO_SUB_APLICACION = :codigo_sub_aplicacion and
       CODIGO_APLICACION     = 'BDP' and
       CODIGO_TIPO_SALDO     = 10;
       --Ln_Saldo_Total    := NVL(Ln_Saldo_Retenido,0) + NVL(:nuevo_saldo,0);
 --
       Ln_saldo_total := :nuevo_saldo;
 --
       RETURN(Ln_Saldo_Total);
RETURN NULL; Exception When Others Then 
	Ln_Saldo_Retenido := 0;
        Ln_Saldo_Total    := nvl(Ln_Saldo_Retenido,0) + nvl(:nuevo_saldo,0);     
        RETURN(Ln_Saldo_Total);
end;

-- F_amento_capital
function CF_INCRE_CAPITALFormula return VARCHAR2 is
 Lv_monto    varchar2(25);
begin
lv_monto := :abreviatura||' '||ltrim(to_char(nvl(:CS_SUMA_MONTO,0),'999,999,999,999,990.00')); 
  return(lv_monto);
end;


-- F_CLIENTE
function CF_CLIENTEFormula return VARCHAR2 is
Gv_NombreCliente       varchar2(130);
Gv_CodigoError         varchar2(80);
begin
  DP_P_OBTIENE_NOMBRE_CLIENTE(:codigo_propietario_principal,
		               Gv_NombreCliente,
                               Gv_CodigoError);
   IF Gv_CodigoError <> null THEN
      NULL;
   END IF;
   return (Gv_NombreCliente);
end;


-- F_1
function CF_PROPIETARIOSFormula return VARCHAR2 is
Gv_NombreCliente       varchar2(130);
Gv_CodigoError         varchar2(80);
begin
  DP_P_OBTIENE_NOMBRE_CLIENTE(:codigo_cliente,
		               Gv_NombreCliente,
                               Gv_CodigoError);
   IF Gv_CodigoError <> null THEN
      NULL;
   END IF;
   return (Gv_NombreCliente);
end;


-- F_DIRECCION
function CF_DPTOFormula return VARCHAR2 is
Gv_Direccion     varchar2(200);
Gv_codigoError   varchar2(200);
   
BEGIN
     PU_P_OBTIENE_DIRECCION(:codigo_propietario_principal,:cf_correspondencia,  
		           Gv_Direccion, Gv_CodigoError);
     return(Gv_Direccion);
     if Gv_CodigoError is not null then
        null;
     end if;
RETURN NULL; end;

-- CF_correspondenciaFormula:
function CF_correspondenciaFormula return Number is
ln_correspondencia   number(2);
begin
  select codigo_tipo_correspondencia
  into   ln_correspondencia
  from   dp_depositos_plazos
  where  numero_deposito = :numero_deposito
  and    codigo_agencia = :codigo_agencia
  and    codigo_sub_aplicacion = :codigo_sub_aplicacion
  and    codigo_aplicacion = :codigo_aplicacion
  and    codigo_empresa = :p_cod_empresa;
  return(ln_correspondencia);
RETURN NULL; exception
  when no_data_found then
       null;
  RETURN NULL; when others then 
       null;
RETURN NULL; end;


-- PU_P_OBTIENE_DIRECCION
procedure  PU_P_OBTIENE_DIRECCION(Gn_Codigo_cliente  IN NUMBER,
                      Gn_Cod_direccion IN NUMBER, Gn_TipoCorrespondencia IN NUMBER,
		      Gv_Direccion IN OUT VARCHAR2 ,Gv_CodigoError IN OUT VARCHAR2)
IS
cont_parag             number(3):=0;
fin_1_linea            number(3):=0;
nomen1                 varchar2(160);
inicia_linea_2         number(3):=0;
termina_linea_2        number(3):=0;
nomen2                 varchar2(50);
inicia_linea_3         number(3):=0;
termina_linea_3        number(3):=0;
largo                  number(3):=0;
largo2                 number(3):=0;
largo3                 number(3):=0;
largo4                 number(3):=0;
nomen3                 varchar2(150);
inicia_linea_4         number(3):=0;
termina_linea_4        number(3):=0;
nomen4                 varchar2(150);
largo_fin              number(3):=0;
direccion_del_cliente  varchar2(120);
Lv_nomeclatura_2       varchar2(120);
ln_direccion           varchar2(200);
lv_une_direcciones     varchar2(250);
BEGIN
SELECT nomenclatura, nomenclatura_2
INTO   direccion_del_cliente, Lv_nomeclatura_2
FROM   mg_direcciones
WHERE  codigo_cliente = Gn_Codigo_cliente
AND    codigo_direccion = Gn_Cod_direccion;
lv_une_direcciones := direccion_del_cliente||Lv_nomeclatura_2;
 begin
  for i in 1..160 loop
    if substr(lv_une_direcciones,i,1)<>'^' then
       fin_1_linea:=fin_1_linea + 1;
    else
       exit;
    end if;
  end loop;
  if lv_une_direcciones is null then
     nomen1:=null;
  else
     nomen1:=substr(Lv_une_direcciones,1,fin_1_linea);
  end if;
 end;
 begin
  if Gn_TipoCorrespondencia = 1 then
     begin
       inicia_linea_2 :=length(nomen1)+ 2;
       termina_linea_2:=inicia_linea_2 - 1;
       for i in inicia_linea_2..160 loop
           if substr(lv_une_direcciones,i,1)= '^' then
              exit;
           else
              termina_linea_2:=termina_linea_2 + 1;
           end if;
       end loop;
       if  termina_linea_2 < inicia_linea_2 then
           nomen2:=null;
       else
           largo2:=termina_linea_2-inicia_linea_2 + 1;
           nomen2:=substr(lv_une_direcciones,inicia_linea_2,largo2);
       end if;
      end;
  end if;
end;
 begin
  if Gn_TipoCorrespondencia = 1 then
     begin
       inicia_linea_3 :=length(nomen1) + length(nomen2)+ 3;
       termina_linea_3:=inicia_linea_3 - 1;
       for i in inicia_linea_3..160 loop
           if substr(lv_une_direcciones,i,1)='^' then
              exit;
           else
              termina_linea_3:=termina_linea_3 + 1;
           end if;
       end loop;
       if termina_linea_3 < inicia_linea_3 then
          nomen3:=null;
       else
          largo3:=termina_linea_3-inicia_linea_3 + 1;
          nomen3:=substr(lv_une_direcciones,inicia_linea_3,largo3);
       end if;
     end;
  end if;
end;
begin
  if Gn_TipoCorrespondencia = 1 then
     begin
       largo_fin:= length(lv_une_direcciones);
       inicia_linea_4:= length(nomen1)+ length(nomen2)+ length(nomen3)+ 4;
       termina_linea_4:=inicia_linea_4 - 1;
       largo_fin:=largo_fin-inicia_linea_4+1;
       nomen4:=substr(lv_une_direcciones,inicia_linea_4,largo_fin);
     end;
   else
      nomen4:=null;
   end if;
end;
Gv_direccion := nomen2||' '||nomen3||' '||nomen4;
return;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     Gv_CodigoError := MG_K_CTRL_ERROR.MG_F_ARMAR_CODIGO_ERROR(401,'PU_P_OBTIENE_DIRECCION', NULL);
     return;
   WHEN TOO_MANY_ROWS THEN
     null;
     return;
   WHEN OTHERS THEN
     null;
     return;
END;