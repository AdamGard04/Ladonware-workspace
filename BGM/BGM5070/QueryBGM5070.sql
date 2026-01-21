-- Q_CC_ESTADISTICAS
Select  d.codigo_agencia,
            b.codigo_moneda,
            a.nivel_1_cuenta_cont nivel_1,
            a.nivel_2_cuenta_cont nivel_2,
            a.nivel_3_cuenta_cont nivel_3,
            a.nivel_4_cuenta_cont nivel_4,
            a.nivel_5_cuenta_cont nivel_5,
            a.nivel_6_cuenta_cont nivel_6,
            LPAD(d.codigo_agencia,3,'0') nivel_7,  /*a.nivel_7_cuenta_cont nivel_7, */
            a.nivel_8_cuenta_cont nivel_8,
            b.codigo_aplicacion,
            a.codigo_sub_aplicacion,
            a.codigo_tipo_saldo,
            a.codigo_tipo ,
            a.codigo_estado_cartera
    from  pr_parametro_contable_detalle a,
             mg_sub_aplicaciones b,
             pr_tipos_saldo c,
             mg_agencias  d
where
          b.codigo_aplicacion          = 'BPR'
   and b.codigo_sub_aplicacion  = a.codigo_sub_aplicacion
   and c.codigo_tipo_saldo          = a.codigo_tipo_saldo
   and c.tipo_abono                     = :p_tipo_abono 
    and a.codigo_tipo                  != 3
--   and substr(a.nivel_1_cuenta_cont,1,1) in (7,6,8)
    and a.codigo_agencia      != 0 
--   and a.codigo_tipo_saldo   IN (3,17)
    and  a.codigo_agencia = decode(:P_AGENCIA_UNICA,'S', :p_agencia_corporativo, d.codigo_agencia)
    and  d.codigo_agencia  = nvl(decode(:agencia,-1,null,:agencia),d.codigo_agencia)
    and a.codigo_sub_aplicacion  = nvl(decode(:sub_aplicacion,-1,null,:sub_aplicacion),a.codigo_sub_aplicacion)
     AND  a.nivel_1_cuenta_cont  BETWEEN nvl(:pnivel_1,a.nivel_1_cuenta_cont) 
     AND DECODE(:pnivel_1_1,NULL,DECODE(:pnivel_1,NULL,a.nivel_1_cuenta_cont,:pnivel_1),:pnivel_1_1) 
     AND a.nivel_2_cuenta_cont  BETWEEN nvl(:pnivel_2,a.nivel_2_cuenta_cont) 
     AND DECODE(:pnivel_2_2,NULL,DECODE(:pnivel_2,NULL,a.nivel_2_cuenta_cont,:pnivel_2),:pnivel_2_2)   
     AND a.nivel_3_cuenta_cont  BETWEEN nvl(:pnivel_3,a.nivel_3_cuenta_cont) 
     AND DECODE(:pnivel_3_3,NULL,DECODE(:pnivel_3,NULL,a.nivel_3_cuenta_cont,:pnivel_3),:pnivel_3_3) 
      AND a.nivel_4_cuenta_cont  BETWEEN nvl(:pnivel_4,a.nivel_4_cuenta_cont) 
      AND DECODE(:pnivel_4_4,NULL,DECODE(:pnivel_4,NULL,a.nivel_4_cuenta_cont,:pnivel_4),:pnivel_4_4)
      AND a.nivel_5_cuenta_cont  BETWEEN nvl(:pnivel_5,a.nivel_5_cuenta_cont)
      AND DECODE(:pnivel_5_5,NULL,DECODE(:pnivel_5,NULL,a.nivel_5_cuenta_cont,:pnivel_5),:pnivel_5_5)
      AND a.nivel_6_cuenta_cont   BETWEEN nvl(:pnivel_6,a.nivel_6_cuenta_cont) 
       AND DECODE(:pnivel_6_6,NULL,DECODE(:pnivel_6,NULL,a.nivel_6_cuenta_cont,:pnivel_6),:pnivel_6_6) 
      AND a.nivel_7_cuenta_cont  BETWEEN nvl(:pnivel_7,a.nivel_7_cuenta_cont) 
      AND DECODE(:pnivel_7_7,NULL,DECODE(:pnivel_7,NULL,a.nivel_7_cuenta_cont,:pnivel_7),:pnivel_7_7)
      AND a.nivel_8_cuenta_cont  BETWEEN nvl(:pnivel_8,a.nivel_8_cuenta_cont) 
      AND DECODE(:pnivel_8_8,NULL,DECODE(:pnivel_8,NULL,a.nivel_8_cuenta_cont,:pnivel_8),:pnivel_8_8) 
order by d.codigo_agencia,
              b.codigo_moneda,
             a.nivel_1_cuenta_cont ,
             a.nivel_2_cuenta_cont,
             a.nivel_3_cuenta_cont,
             a.nivel_4_cuenta_cont,
             a.nivel_5_cuenta_cont,
             a.nivel_6_cuenta_cont,
              LPAD(d.codigo_agencia,3,'0'), 
             a.nivel_8_cuenta_cont,
             a.codigo_sub_aplicacion,
             a.codigo_tipo,
             a.codigo_estado_Cartera,
             a.codigo_tipo_saldo

-- funciones:
-- F_nombre_moneda
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



-- F_CF_DESC_AGENCIA
function nombre_agencia1Formula return VARCHAR2 is
lv_nombreagencia mg_agencias_generales.nombre_agencia%type;
begin

select nombre_agencia 
  into lv_nombreagencia 
  from agencias 
  where codigo_empresa  = :p_codigo_empresa
    and :codigo_agencia = codigo_agencia;
RETURN(Lv_NombreAgencia);
EXCEPTION 
	WHEN OTHERS THEN RETURN(' ERROR EN AGENCIA');
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
    From gm_balance_cuentas
  Where codigo_empresa = :p_codigo_empresa
    and nivel_1        = :nivel_1
    and nivel_2        = :nivel_2
    and nivel_3        = :nivel_3
    and nivel_4        = :nivel_4
    and nivel_5        = :nivel_5
    and nivel_6        = :nivel_6
    and nivel_7        = :nivel_7
    and nivel_8        = :nivel_8;        
  Return(Lv_Descripcion);                
Exception
	 When No_Data_Found Then
	   Return ('No existe Cuenta Contable');
end;


-- Gm_P_saldo_Diario_ME
Procedure Gm_P_saldo_Diario_ME
                       (GN_CODIGO_EMPRESA NUMBER,
                        GV_RECIBE_MOV     VARCHAR2,
                        GV_NIVELI_1       VARCHAR2, 
                        GV_NIVELI_2       VARCHAR2,
                        GV_NIVELI_3       VARCHAR2,
                        GV_NIVELI_4       VARCHAR2,
                        GV_NIVELI_5       VARCHAR2, 
                        GV_NIVELI_6       VARCHAR2,
                        GV_NIVELI_7       VARCHAR2, 
                        GV_NIVELI_8       VARCHAR2,
                        GN_CODIGO_MONEDA  NUMBER,
                        GV_DIA            NUMBER,
                        GV_MES            NUMBER,
                        GV_ANIO           NUMBER,
                        GN_TOTAL      OUT NUMBER)
IS

Begin

  SELECT SUM(DECODE(GV_DIA,1,SALDO_DIA_1, 2,SALDO_DIA_2,
                           3,SALDO_DIA_3, 4,SALDO_DIA_4,
                           5,SALDO_DIA_5, 6,SALDO_DIA_6,
                           7,SALDO_DIA_7, 8,SALDO_DIA_8,
                           9,SALDO_DIA_9, 10,SALDO_DIA_10,
                          11,SALDO_DIA_11,12,SALDO_DIA_12,
                          13,SALDO_DIA_13,14,SALDO_DIA_14,
                          15,SALDO_DIA_15,16,SALDO_DIA_16,
                          17,SALDO_DIA_17,18,SALDO_DIA_18,
                          19,SALDO_DIA_19,20,SALDO_DIA_20,
                          21,SALDO_DIA_21,22,SALDO_DIA_22,
                          23,SALDO_DIA_23,24,SALDO_DIA_24,
                          25,SALDO_DIA_25,26,SALDO_DIA_26,
                          27,SALDO_DIA_27,28,SALDO_DIA_28,
                          29,SALDO_DIA_29,30,SALDO_DIA_30,
                          31,SALDO_DIA_31)) SaldoDia
    INTO GN_TOTAL  
    FROM gm_balance_cuentas A,
         gm_saldos_extranjeros_dias b
  where
        a.nivel_1           = Gv_Niveli_1
    and a.nivel_2           = Gv_Niveli_2
    and a.nivel_3           = Gv_Niveli_3
    and a.nivel_4           = Gv_Niveli_4
    and a.nivel_5           = Gv_Niveli_5
    and a.nivel_6           = Gv_Niveli_6
    and a.nivel_7           = Gv_Niveli_7 
    and a.nivel_8           = Gv_Niveli_8
    and a.recibe_movimiento = GV_RECIBE_MOV
    and b.nivel_1           = a.nivel_1
    and b.nivel_2           = a.nivel_2
    and b.nivel_3           = a.nivel_3
    and b.nivel_4           = a.nivel_4
    and b.nivel_5           = a.nivel_5
    and b.nivel_6           = a.nivel_6
    and b.nivel_7           = a.nivel_7
    and b.nivel_8           = a.nivel_8
    and b.MES               = GV_MES
    and b.ANIO              = GV_ANIO
    and b.codigo_moneda     = Gn_codigo_moneda;
    
   Gn_Total := Nvl(Gn_Total,0);
   
exception
  when no_data_found then
       Gn_total := 0;

END;


-- GM_P_calcula_saldo_Mov
PROCEDURE GM_P_calcula_saldo_Mov (GN_CODIGOEMPRESA        NUMBER,
                                  GV_NIVEL_1              VARCHAR2,
                                  GV_NIVEL_2              VARCHAR2,
                                  GV_NIVEL_3              VARCHAR2, 
                                  GV_NIVEL_4              VARCHAR2,
                                  GV_NIVEL_5              VARCHAR2, 
                                  GV_NIVEL_6              VARCHAR2,
                                  GV_NIVEL_7              VARCHAR2,
                                  GV_NIVEL_8              VARCHAR2,
                                  MonedaLocal             NUMBER,
                                  GD_FECHA                DATE,
                                  GN_TOTAL_DB         OUT NUMBER,
                                  GN_TOTAL_CR         OUT NUMBER,
                                  GN_TOTAL_DBME       OUT NUMBER,
                                  GN_TOTAL_CRME       OUT NUMBER)
 IS

Ln_total_ini  number (14,2) := 0;
Ln_total_fin  number (14,2) := 0;
Ln_total      number (14,2) := 0;
Ln_MontoCredito  Number  := 0;
Ln_MontoDebito   Number  := 0;
Ln_MontoCreditoME Number := 0;
Ln_MontoDebitoME  Number := 0;
BEGIN
       select  sum(decode(debito_credito,'C',decode(codigo_moneda,Monedalocal,abs(monto_movimiento),
                                   abs(monto_movimiento_local)),0)) Monto_Credito,
               sum(decode(debito_credito,'D',decode(Codigo_moneda,MonedaLocal,monto_movimiento,
                                   monto_movimiento_local),0)) Monto_Debito,
               sum(decode(debito_credito,'C',decode(codigo_moneda,Monedalocal,0,
                                   abs(monto_movimiento)),0)) Monto_Credito_Ext,
               sum(decode(debito_credito,'D',decode(Codigo_moneda,MonedaLocal,0,
                                   monto_movimiento),0)) Monto_Debito_ext
         Into Ln_MontoCredito,
              Ln_MontoDebito,
              Ln_MontoCreditoME,
              Ln_MontoDebitoMe
         from gm_movimientos_detalle
        Where codigo_empresa    = Gn_CodigoEmpresa
          and Nivel_1           = Gv_Nivel_1
          and Nivel_2           = Gv_Nivel_2
          and Nivel_3           = Gv_Nivel_3
          and Nivel_4           = Gv_Nivel_4
          and Nivel_5           = Gv_Nivel_5
          and Nivel_6           = Gv_Nivel_6
          and Nivel_7           = Gv_Nivel_7
          and Nivel_8           = Gv_Nivel_8
          and fecha_movimiento  <= Gd_Fecha;

     Gn_Total_db := Nvl(Ln_MontoDebito,0);
     Gn_Total_cr := Nvl(Ln_MontoCredito,0);
     Gn_Total_dbme := Nvl(Ln_MontoDebitoME,0);
     Gn_Total_crme := Nvl(Ln_MontoCreditoME,0);
END;



-- PU_P_SaldoContableFecha
PROCEDURE PU_P_SaldoContableFecha  (Pn_CodigoEmpresa      Number,
                                    Pv_nivel_1            Varchar2,
                                    Pv_nivel_2            Varchar2,
                                    Pv_nivel_3            Varchar2,
                                    Pv_nivel_4            Varchar2,
                                    Pv_nivel_5            Varchar2,
                                    Pv_nivel_6            Varchar2,
                                    Pv_nivel_7            Varchar2,
                                    Pv_nivel_8            Varchar2,
                                    Pn_CodigoMoneda       Number,
                                    Pn_MonedaLocal        Varchar2,
                                    Pd_Fecha              Date,
                                    Pn_SaldoActual IN OUT Number,
                                    Pn_SaldoLocal  IN OUT Number )
                            Is
 Ld_FechaHoy     Date;
 Ln_Anio         Number;
 Ln_Mes          Number;
 Ln_Dia          Number;
 Ln_Total_db     Number;
 Ln_Total_Cr     Number;
 Ln_Total_db_Me  Number;
 Ln_Total_Cr_Me  Number;
 Ln_saldo        Number;
 Ln_saldo_Me     Number;
 Lv_Error        Varchar2(2000);
 Lv_Naturaleza   Varchar2(1);

Begin
  Begin
	  Select Fecha_Hoy
	    Into Ld_FechaHoy
	    From mg_calendario
	   Where codigo_empresa    = Pn_codigoEmpresa
	     and codigo_aplicacion = 'BGM';
  End;
  
  Ln_Dia  := To_number(to_char(pd_fecha,'DD'));  
  Ln_Mes  := To_number(to_char(pd_fecha,'MM'));
  Ln_Anio := To_number(to_char(pd_fecha,'YYYY'));
  
  Lv_Error :=  Gm_f_naturaleza_cuenta
                     (Pn_Codigoempresa,
				   	          Pv_nivel_1,
				   	          Pv_nivel_2,
				   	          Pv_nivel_3,
				   	          Pv_nivel_4,
				   	          Pv_nivel_5,
				   	          Pv_nivel_6,
                      Lv_Naturaleza);
 
 
  If  pd_fecha < Ld_FechaHoy Then
    GM_K_BUSCA_SALDOS.GM_P_SALDO_DIARIOS
                    ( Pn_Codigoempresa,
				   	          Pv_nivel_1,
				   	          Pv_nivel_2,
				   	          Pv_nivel_3,
				   	          Pv_nivel_4,
				   	          Pv_nivel_5,
				   	          Pv_nivel_6,
				   	          Pv_nivel_7,
				   	          Pv_nivel_8,
				   	          Ln_anio,   
				   	          Ln_mes,
				   	          Ln_dia,
				   	         'S', -- Recibe Movimiento
					            Ln_Saldo,
			                Lv_Error);
	  If Pn_MonedaLocal != Pn_CodigoMoneda Then
       Gm_P_saldo_Diario_ME
                       (Pn_CodigoEmpresa,
                        'S',
                        Pv_nivel_1,
                        Pv_nivel_2,
                        Pv_nivel_3,
                        Pv_nivel_4,
                        Pv_nivel_5, 
                        Pv_nivel_6,
                        Pv_nivel_7, 
                        Pv_nivel_8,
                        Pn_CodigoMoneda,
                        Ln_DIA,
                        Ln_MES,
                        Ln_ANIO,
                        Ln_Saldo_Me);
                        
	  End If;
  Else
  Begin
  	 Begin
  	  Select saldo_actual 
  	    Into Ln_saldo
  	   From gm_balance_cuentas 
  	  Where codigo_empresa =  pn_codigoempresa
  	    and nivel_1        = Pv_nivel_1
   	    and nivel_2        = Pv_nivel_2
  	    and nivel_3        = Pv_nivel_3
   	    and nivel_4        = Pv_nivel_4
   	    and nivel_5        = Pv_nivel_5
   	    and nivel_6        = Pv_nivel_6
    	  and nivel_7        = Pv_nivel_7
   	    and nivel_8        = Pv_nivel_8;
  	 Exception
  	 	When No_data_found Then
  	 	  Ln_saldo := 0;
  	 End;
  	 
     Gm_P_calcula_saldo_Mov 
                     (Pn_Codigoempresa,
				   	          Pv_nivel_1,
				   	          Pv_nivel_2,
				   	          Pv_nivel_3,
				   	          Pv_nivel_4,
				   	          Pv_nivel_5,
				   	          Pv_nivel_6,
				   	          Pv_nivel_7,
				   	          Pv_nivel_8,
                      Pn_MonedaLocal,
                      Pd_Fecha,
                      Ln_Total_DB,
                      Ln_Total_CR,
                      Ln_Total_DB_ME,
                      Ln_Total_CR_ME);
 
     If Lv_Naturaleza = 'D' Then
   	    Ln_Saldo := Ln_saldo + Ln_total_db - Ln_total_cr;
   	 Else
        Ln_Saldo := Ln_saldo - Ln_total_DB + Ln_total_cr;
   	 End IF;
   	 
     If Pn_MonedaLocal != Pn_CodigoMoneda Then
   	 Begin
  	  Select saldo_actual 
  	    Into Ln_saldo_Me
  	   From gm_balance_extranjeros 
  	  Where codigo_empresa =  pn_codigoempresa
  	    and nivel_1        = Pv_nivel_1
   	    and nivel_2        = Pv_nivel_2
  	    and nivel_3        = Pv_nivel_3
   	    and nivel_4        = Pv_nivel_4
   	    and nivel_5        = Pv_nivel_5
   	    and nivel_6        = Pv_nivel_6
    	  and nivel_7        = Pv_nivel_7
   	    and nivel_8        = Pv_nivel_8
   	    and codigo_moneda  = Pn_CodigoMoneda;

  	 Exception
  	 	When No_data_found Then
  	 	  Ln_saldo_Me := 0;
  	 End; 
  	 
   	   If Lv_Naturaleza = 'D' Then
   	 	   Ln_Saldo_Me := Ln_saldo_me + Ln_total_db_me - Ln_total_cr_me;
   	   Else
      	 Ln_Saldo_Me := Ln_saldo_me - Ln_total_db_me + Ln_total_cr_me;
       End IF;
     End If;
  	End;
  End If;
  Pn_SaldoLocal   := Ln_Saldo;
  Pn_SaldoActual  := Ln_saldo;
  If Pn_CodigoMoneda != Pn_MonedaLocal Then
  	 Pn_SaldoActual := Ln_Saldo_me;
  End If;
  
End;


-- F_CF_SaldoActual
function CF_SaldoActualFormula return Number is

 Ln_SaldoActual   Number;
 Ln_SaldoLocal    Number;
begin
  PU_P_SaldoContableFecha
          (:P_Codigo_Empresa,
           :nivel_1      ,
           :nivel_2      ,
           :nivel_3      ,
           :nivel_4      ,
           :nivel_5      ,
           :nivel_6      ,
           :nivel_7      ,
           :nivel_8      ,
           :Codigo_Moneda ,
           :P_Moneda_Local  ,
           :p_Fecha        ,
           Ln_SaldoActual ,
           Ln_SaldoLocal );
           
  :cp_SaldoLocal := Ln_SaldoLocal;  
  
  Return(Ln_SaldoActual);

end;



-- F_descrip_sub1
function descrip_sub1Formula return VARCHAR2 is
  Lv_Descripcion	Varchar2(250);
begin
  select descripcion 
  into Lv_Descripcion
  from sub_aplicaciones 
  where codigo_aplicaCion = 'BPR'
    and :codigo_sub_aplicacion = codigo_sub_aplicacion;
  RETURN Lv_Descripcion;
RETURN NULL; exception
  when no_data_found then
    RETURN  null;
end;


-- F_codigo_tipo1
function CF_DESC_TIPOFormula return Char is
 lv_descripcion varchar2(40);
begin
  select descripcion
    Into lv_descripcion
    From pr_clase_prestamo
   Where codigo_tipo = :codigo_tipo;
   
  Return(Lv_descripcion);
Exception
	When No_data_found Then
	  Return(Null);
end;


-- F_desc_saldo
function CF_DESC_SALDOFormula return Char is
 lv_descripcion varchar2(40);
begin
  select descripcion
    Into lv_descripcion
    From pr_tipos_saldo
   Where codigo_tipo_saldo = :codigo_tipo_saldo;
   
  Return(Lv_descripcion);
Exception
	When No_data_found Then
	  Return(Null);
end;


-- PR_P_CALSALDOCOMPARATIVOBPR

 PROCEDURE  PR_P_CALCULASALDOCOMPARATIVO ( Gn_CodigoEmpresa     Number ,
                                          Gn_CodigoAgencia     Number ,
                                          Gn_Subaplic          Number ,
                                          Gn_CodigoTipoSaldo   Number , 
                                          Gn_CodigoTipo        Number ,
                                          Gv_codigoEstadoCartera Varchar2,
                                          Gd_Fecha             Date ,
                                          Gn_Valor       IN OUT      Number )
  IS                                                 
  Ln_valor             number;
  Ld_Fecha             Date := Gd_fecha;
  Ld_fechaHoy          Date;
  Ld_FechaProxima      Date;
  Ld_FinMes            DATE;
  Ld_FechaAnterior     DATE;
  Ld_fechaRep          DATE;
  Lv_Inactiva          Varchar2(1); 
begin
	
  Begin
	  Select fecha_hoy, 
	         fecha_anterior ,
	         Ld_FechaProxima 
	    Into Ld_FechaHoy, 
	         Ld_FechaAnterior,
	         Ld_FechaProxima
	  From mg_calendario 
	  Where codigo_aplicacion  = 'BPR';
	  LD_FECHAREP := LD_fechaPROXIMA - 1;
	  Ld_FinMes   := Last_day (Ld_Fecha);
	  
	 Exception
	 When No_data_found Then 
  --Exception 
  	  null;
  End;
  
  If Ld_Fecha = Ld_FechaRep 
  Then
	
     select nvl(sum(valor),0)
       Into Ln_valor
      From pr_saldos_prestamo  b ,
           pr_prestamos        c
     where 
           b.codigo_sub_aplicacion = Gn_SubAplic
       and b.codigo_agencia        = Gn_CodigoAgencia
     -- and b.codigo_aplicacion     = 'BPR'
       and b.codigo_empresa        = Gn_Codigoempresa
    -- and b.codigo_estado_cartera = :codigo_estado_cartera
    -- and a.estado                = 1
    -- and b.codigo_tipo           = :codigo_tipo
    -- and b.fecha_valida          = :p_fecha
       and b.codigo_tipo_saldo       = Gn_CodigoTipoSaldo
       and c.numero_prestamo         = b.numero_prestamo
       and c.codigo_agencia          = b.codigo_agencia
       and c.codigo_sub_aplicacion   = b.codigo_sub_aplicacion
       and c.codigo_empresa          = b.codigo_empresa
       and c.codigo_estado_cartera   = Gv_CodigoEstadoCartera
       and c.codigo_tipo             = Gn_codigotipo;
     
  Else
  		
     select nvl(sum(valor),0)
       Into Ln_valor
      From pr_saldos_prestamo_diario  b ,
           pr_prestamos               c
     where 
           b.codigo_sub_aplicacion =  Gn_SubAplic
       and b.codigo_agencia        =Gn_CodigoAgencia
    -- and b.codigo_aplicacion     = 'BPR'
       and b.codigo_empresa        =  Gn_Codigoempresa
    -- and b.codigo_estado_cartera = :codigo_estado_cartera
    -- and a.estado                = 1
    -- and b.codigo_tipo           = :codigo_tipo
       and b.fecha_valida           = Gd_Fecha
       and b.codigo_tipo_saldo       = Gn_CodigoTipoSaldo
       and c.numero_prestamo         = b.numero_prestamo
       and c.codigo_agencia          = b.codigo_agencia
       and c.codigo_sub_aplicacion   = b.codigo_sub_aplicacion
       and c.codigo_empresa          = b.codigo_empresa
       and b.codigo_estado_cartera   = Gv_CodigoEstadoCartera
       and c.codigo_tipo             = Gn_codigotipo;
 
  End if;
  Gn_valor := Ln_valor;
 
Exception
	When No_Data_Found Then
	 Gn_valor := 0;
end;


-- F_saldo_aux
function CF_SALDO_AUXFormula return Number is
  Ln_valor             number;
  Ld_Fecha             Date := :p_fecha;
  Ld_fechaHoy          Date;
  Ld_FechaProxima      Date;
  Ld_FinMes            DATE;
  Ld_FechaAnterior     DATE;
  Ld_fechaRep          DATE;
  Lv_Inactiva          Varchar2(1); 
begin
	
	PR_P_CALSALDOCOMPARATIVOBPR  ( :p_codigo_empresa ,
                                 :codigo_agencia ,
                                 :codigo_sub_aplicacion ,
                                 :codigo_tipo_saldo , 
                                 :codigo_tipo  ,
                                 :codigo_estado_cartera,
                                 :p_fecha ,
                                 ln_valor );
	
	/*
  Begin
	  Select fecha_hoy, 
	         fecha_anterior ,
	         Ld_FechaProxima 
	    Into Ld_FechaHoy, 
	         Ld_FechaAnterior,
	         Ld_FechaProxima
	  From mg_calendario 
	  Where codigo_aplicacion  = 'BPR';
	  LD_FECHAREP := LD_fechaPROXIMA - 1;
	  Ld_FinMes   := Last_day (Ld_Fecha);
	    
	 Exception
	 When No_data_found Then 
  --Exception 
  	  null;
  End;
  */
 /*
  If Ld_Fecha = Ld_FechaRep 
  Then
	
     select nvl(sum(valor),0)
       Into Ln_valor
      From pr_saldos_prestamo  b ,
           pr_prestamos        c
     where 
           b.codigo_sub_aplicacion = :codigo_sub_aplicacion
       and b.codigo_agencia        = :codigo_agencia
     -- and b.codigo_aplicacion     = 'BPR'
       and b.codigo_empresa        = :p_codigo_empresa
    -- and b.codigo_estado_cartera = :codigo_estado_cartera
    -- and a.estado                = 1
    -- and b.codigo_tipo           = :codigo_tipo
    -- and b.fecha_valida          = :p_fecha
       and b.codigo_tipo_saldo       = :codigo_tipo_saldo
       and c.numero_prestamo         = b.numero_prestamo
       and c.codigo_agencia          = b.codigo_agencia
       and c.codigo_sub_aplicacion   = b.codigo_sub_aplicacion
       and c.codigo_empresa          = b.codigo_empresa
       and c.codigo_estado_cartera   = :codigo_estado_cartera
       and c.codigo_tipo             = :codigo_tipo;
     
  Else
  		
     select nvl(sum(valor),0)
       Into Ln_valor
      From pr_saldos_prestamo_diario  b ,
           pr_prestamos               c
     where 
           b.codigo_sub_aplicacion = :codigo_sub_aplicacion
       and b.codigo_agencia        = :codigo_agencia
    -- and b.codigo_aplicacion     = 'BPR'
       and b.codigo_empresa        = :p_codigo_empresa
    -- and b.codigo_estado_cartera = :codigo_estado_cartera
    -- and a.estado                = 1
    -- and b.codigo_tipo           = :codigo_tipo
       and b.fecha_valida             = :p_fecha
       and b.codigo_tipo_saldo       = :codigo_tipo_saldo
       and c.numero_prestamo         = b.numero_prestamo
       and c.codigo_agencia          = b.codigo_agencia
       and c.codigo_sub_aplicacion   = b.codigo_sub_aplicacion
       and c.codigo_empresa          = b.codigo_empresa
       and b.codigo_estado_cartera   = :codigo_estado_cartera
       and c.codigo_tipo             = :codigo_tipo;
 
  End if;
   */  
Return(ln_valor);
Exception
	When No_Data_Found Then
	  Return(0);
end;


-- F_CF_SALDO_AUX_MN
function CF_SALDO_AUX_MNFormula return Number is


  TasaCambioorigen      NUMBER(16,8);
  TasaCambioDestino     NUMBER(16,8);
  DiferenciaCambio      NUMBER(16,6);
  GananciaPerdida       NUMBER(19,6);
  FechaTipoCambio       DATE;
  ValorTipoCambio       NUMBER;
  Lv_MensajeError       VARCHAR2(2000);
  LN_saldoaux_MN          NUMBER(19,6);
  LN_SobregiroMN        NUMBER(19,6);
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
	                      :cf_saldo_aux,
                        Ln_SaldoAux_mn,
                        DiferenciaCambio,
	                      GananciaPerdida,
	                      Lv_MensajeError);
	                      
  Else
  	Ln_Saldoaux_mn := :cf_saldo_aux;
	End If;

   RETURN(Ln_saldoaux_mn);
  
end;



-- F_CF_SaldoActual1
function CF_SaldoActualFormula return Number is

 Ln_SaldoActual   Number;
 Ln_SaldoLocal    Number;
begin
  PU_P_SaldoContableFecha
          (:P_Codigo_Empresa,
           :nivel_1      ,
           :nivel_2      ,
           :nivel_3      ,
           :nivel_4      ,
           :nivel_5      ,
           :nivel_6      ,
           :nivel_7      ,
           :nivel_8      ,
           :Codigo_Moneda ,
           :P_Moneda_Local  ,
           :p_Fecha        ,
           Ln_SaldoActual ,
           Ln_SaldoLocal );
           
  :cp_SaldoLocal := Ln_SaldoLocal;  
  
  Return(Ln_SaldoActual);

end;




-- F_CS_DIF1
function CF_DIFERENCIAFormula return Number is
  Lv_ContabilizaSobregiro  Number := 0;
  Ln_Diferencia            Number := 0;
begin


  	 Ln_Diferencia := nvl(:cf_saldoactual,0) - nvl(:cs_saldo_aux,0);

  Return(Ln_Diferencia);
end;

