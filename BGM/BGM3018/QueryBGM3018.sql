-- Q_SALDOS_ESTADISTICOS
Select c.codigo_moneda,
       c.nivel_1,
       c.nivel_2,
       c.nivel_3,
       c.nivel_4,
       c.nivel_5,
       c.nivel_6,
       c.nivel_7,
       c.nivel_8,
       --decode( :p_tipo_consolidado,'A', c.nivel_7 ,   decode(p.aplicar_nivel_7,'S', rpad('0',p.cantidad_dig_nivel_7,'0'),'0000' )  )    nivel_7,
       --decode( :p_tipo_consolidado,'A', c.nivel_8 ,   decode(p.aplicar_nivel_8,'S', rpad('0',p.cantidad_dig_nivel_8,'0'),'0000' )  )    nivel_8, 
       nvl(d.monto_1,0)      saldo_cont_local,
       nvl(d.monto_2,0)      saldo_cont,
       sum(nvl(b.valor,0))  saldo  
    from  (Select  x.codigo_moneda,y.codigo_empresa,y.codigo_agencia,y.codigo_sub_aplicacion,y.codigo_aplicacion , 0 codigo_auxiliar,
                   y.codigo_tipo_saldo,y.descripcion,
                   nvl(z.nivel_1_cuenta_cont,'0') nivel_1,  
                   nvl(z.nivel_2_cuenta_cont,'0') nivel_2,  
                   nvl(z.nivel_3_cuenta_cont,'0') nivel_3, 
                   nvl(z.nivel_4_cuenta_cont,'0') nivel_4, 
                   nvl(z.nivel_5_cuenta_cont,'0') nivel_5,   
                   nvl(z.nivel_6_cuenta_cont,'0') nivel_6, 
                   nvl( decode( :p_tipo_consolidado,'A',nvl( z.nivel_7_cuenta_cont ,'0'),   decode(w.aplicar_nivel_7,'S', rpad('0',w.cantidad_dig_nivel_7,'0'),'0000' )  ) 
                          ,'0') nivel_7,  
                   nvl( decode( :p_tipo_consolidado,'A', nvl(z.nivel_8_cuenta_cont,'0') ,   decode(w.aplicar_nivel_8,'S', rpad('0',w.cantidad_dig_nivel_8,'0'),'0000' )  )
                        ,'0') nivel_8
           From   (Select  i.codigo_empresa,i.codigo_aplicacion,i.codigo_agencia,
                           i.codigo_sub_aplicacion,j.codigo_tipo_saldo,j.descripcion
                   From    mg_agencias_x_subaplicacion  i,
                           mg_tipos_saldo               j
                   Where   i.codigo_aplicacion         in   ('BCC','BCA') -- BDP 
                   and     i.codigo_agencia             = nvl(:agencia,i.codigo_agencia)
                   and     i.codigo_sub_aplicacion      = nvl(:sub_aplicacion,i.codigo_sub_aplicacion)
                   and     i.codigo_empresa             = :P_CODIGO_EMPRESA 
                   and     j.codigo_aplicacion          = i.codigo_aplicacion 
                   and     j.codigo_tipo_saldo           is not null             
                   and     nvl(j.USADO_REPORTE_COMPARATIVO,'N') = 'S') y,       
                   mg_sub_aplicaciones          x,
                   mg_cuentas_x_agen_x_subaplic z ,
                   GM_PARAMETRO_ESTRUCTURA_CTAS  w 
              Where    x.codigo_aplicacion          = y.codigo_aplicacion
              and      x.codigo_sub_aplicacion      = y.codigo_sub_aplicacion
              and      z.codigo_aplicacion  (+)     = y.codigo_aplicacion
              and      z.codigo_tipo_saldo  (+)     = y.codigo_tipo_saldo
              and      z.codigo_agencia     (+)     = y.codigo_agencia            
              and      z.codigo_sub_aplicacion  (+) = y.codigo_sub_aplicacion      
              and      z.codigo_empresa     (+)     = y.codigo_empresa
              and      w.codigo_empresa                  =    :P_CODIGO_EMPRESA 
          )  c,
          (Select     a.codigo_aplicacion,a.codigo_empresa,a.codigo_agencia, a.codigo_subaplicacion, a.codigo_tipo_saldo,a.valor     
           From       ca_saldos_estadisticos  a, mg_tipos_saldo      t
           Where     a. fecha  =  :P_FECHA
           And           t.codigo_aplicacion = a.codigo_aplicacion 
           And           t.codigo_tipo_saldo = a.codigo_tipo_saldo
           And          nvl(t.USADO_REPORTE_COMPARATIVO,'N') = 'S' 
           UNION
           Select     a.codigo_aplicacion,a.codigo_empresa,a.codigo_agencia, a.codigo_subaplicacion, a.codigo_tipo_saldo,a.valor     
           From       cc_saldos_estadisticos  a,mg_tipos_saldo      t 
           Where      a.fecha  = :P_FECHA  
           And           t.codigo_aplicacion = a.codigo_aplicacion 
           And           t.codigo_tipo_saldo = a.codigo_tipo_saldo
           And          nvl(t.USADO_REPORTE_COMPARATIVO,'N') = 'S' 
          /*
           UNION
           Select     a.codigo_aplicacion,a.codigo_empresa,a.codigo_agencia, a.codigo_subaplicacion, a.codigo_tipo_saldo,a.valor     
           From       dp_saldos_estadisticos  a,mg_tipos_saldo      t
           Where      a.fecha  =   :P_FECHA  
           And           t.codigo_aplicacion = a.codigo_aplicacion 
           And           t.codigo_tipo_saldo = a.codigo_tipo_saldo
           And          nvl(t.USADO_REPORTE_COMPARATIVO,'N') = 'S'  
           */
           ) b   ,
          GM_DATOS_REPORTES_TEMP   d
   where  d.nivel_1               =  c.nivel_1
   and      d.nivel_2               =  c.nivel_2   
   and      d.nivel_3               =  c.nivel_3
   and      d.nivel_4               =  c.nivel_4
   and      d.nivel_5               =  c.nivel_5   
   and      d.nivel_6               =  c.nivel_6
   and      d.nivel_7               =  c.nivel_7   
   and      d.nivel_8               =  c.nivel_8
   and      d.codigo_empresa        =  :P_CODIGO_EMPRESA
   and      d.codigo                =  'BGM3018'
   and      d.usuario               = :P_USUARIO 
   and      b.codigo_aplicacion   (+)       = c.codigo_aplicacion
   and      b.codigo_tipo_saldo   (+)       = c.codigo_tipo_saldo
   and      b.codigo_agencia       (+)      = c.codigo_agencia            
   and      b.codigo_subaplicacion (+)      = c.codigo_sub_aplicacion      
   and      b.codigo_empresa         (+)    =   c.codigo_empresa   
   --and      p.codigo_empresa                  =    :P_CODIGO_EMPRESA 
Group by  c.codigo_moneda,
       c.nivel_1,
       c.nivel_2,
       c.nivel_3,
       c.nivel_4,
       c.nivel_5,
       c.nivel_6,
       c.nivel_7,
       c.nivel_8,
       --decode( :p_tipo_consolidado,'A', c.nivel_7 ,   decode(p.aplicar_nivel_7,'S', rpad('0',p.cantidad_dig_nivel_7,'0'),'0000' )  )  ,
       --decode( :p_tipo_consolidado,'A', c.nivel_8 ,   decode(p.aplicar_nivel_8,'S', rpad('0',p.cantidad_dig_nivel_8,'0'),'0000' )  ) ,
       nvl(d.monto_1,0) ,
       nvl(d.monto_2,0) 
Having   sum(nvl(b.valor,0))  <> 0
or            nvl(d.monto_1,0) <> 0
or          :P_IMPRIME_LINEA = 'S'          
order by 1,2,3,4,5,6,7,8,9,10

-- funciones
-- F_CF_DESC_MONEDA
function CF_DESC_MONEDAFormula return Char is
 lv_descripcion  mg_monedas.descripcion%type;
begin
  select descripcion
    Into lv_descripcion
   From mg_monedas 
   Where codigo_moneda = :codigo_moneda;
  Return(lv_descripcion);
Exception 
	When No_Data_Found Then
	  Return('No existe Moneda');
end;


-- F_CF_CUENTA
function CF_CUENTAFormula return Char is
  Pv_Formato VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(:nivel_1, :nivel_2, :nivel_3, :nivel_4, :nivel_5,
      :nivel_6, :nivel_7, :nivel_8,:p_codigo_empresa, Pv_Formato);
  RETURN(Pv_Formato);
end;


-- F_CF_DESCRIPCION
function CF_DESC_CUENTAFormula return Char is

 Lv_Descripcion   Varchar2(80);
 
begin
  Select descripcion
    Into Lv_Descripcion
    From gm_catalogos
  Where codigo_empresa = :p_codigo_empresa
    and nivel_1        = :nivel_1
    and nivel_2        = :nivel_2
    and nivel_3        = :nivel_3
    and nivel_4        = :nivel_4
    and nivel_5        = :nivel_5
    and nivel_6        = :nivel_6;        
  Return(Lv_Descripcion);                
Exception
	 When No_Data_Found Then
	   Return ('No existe Cuenta Contable');
end;



--F_CS_DIF1
function CF_DIFERENCIAFormula return Number is
  Lv_ContabilizaSobregiro  Number := 0;
  Ln_Diferencia            Number := 0;
Begin

  	Ln_Diferencia := :saldo_cont - :cs_saldo_auxiliar;

  Return(Ln_Diferencia);
end;


-- F_CS_M_SALDO_AUXILIAR_MN
--CF_SALDO_AUXILIAR_MNFormula --SUMA
function CF_SALDO_AUXILIAR_MNFormula return Number 
is

  TasaCambioorigen      NUMBER(16,8);
  TasaCambioDestino     NUMBER(16,8);
  DiferenciaCambio      NUMBER(16,6);
  GananciaPerdida       NUMBER(19,6);
  FechaTipoCambio       DATE;
  ValorTipoCambio       NUMBER;
  Lv_MensajeError       VARCHAR2(2000);
  LN_SinSobregiroMN     NUMBER(19,6);
begin
  
  If :P_MONEDA_LOCAL != :CODIGO_MONEDA THEN
    Mg_P_CambioMoneda ( :P_CODIGO_EMPRESA,
                				:CODIGO_MONEDA,
	                      :P_MONEDA_LOCAL,
	                      1, -- TipoContable
	                      FechaTipoCambio,
                        :FECHA_HOY,
 		                    TasaCambioorigen,
		                    TasaCambioDestino,
                        ValorTipoCambio,
	                      :SALDO,--:SALDO,
                        Ln_SinSobregiroMN,
                        DiferenciaCambio,
	                      GananciaPerdida,
	                      Lv_MensajeError);
  Else
  	Ln_SinSobregiroMN := :SALDO;-- :SALDO;
	End If;

  --:CP_SOBREGIRO_MN := Ln_SobregiroMN;
  RETURN(Ln_SinSobregiroMN);
  
end;