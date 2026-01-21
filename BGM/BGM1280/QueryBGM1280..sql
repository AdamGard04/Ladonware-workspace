-- Q_REPORTE_DETALLE --> Q_REPORT_DETAIL

select A.CODIGO_EMPRESA, CODIGO_REPORTE, CTA_FINAL_NIVEL_1, CTA_FINAL_NIVEL_2, CTA_FINAL_NIVEL_3, CTA_FINAL_NIVEL_4, CTA_FINAL_NIVEL_5, CTA_FINAL_NIVEL_6, CTA_FINAL_NIVEL_7, CTA_FINAL_NIVEL_8, CTA_INICIAL_NIVEL_1, CTA_INICIAL_NIVEL_2, CTA_INICIAL_NIVEL_3, CTA_INICIAL_NIVEL_4, CTA_INICIAL_NIVEL_5, CTA_INICIAL_NIVEL_6, CTA_INICIAL_NIVEL_7, CTA_INICIAL_NIVEL_8, A.DESCRIPCION, RENGLON,  SUBRAYADO,NUMERO_COLUMNA,IMPRIME_SUBTOTAL ,IMPRIME_TOTAL   ,TIPO_DETALLE   ,
 IMPRIME_SUBTOTAL_02
 from GM_REPORTES_DETALLE A
where  a.codigo_empresa  = :p_codigo_empresa  and 
            a.codigo_reporte    = :p_codigo_reporte
order by codigo_empresa, codigo_reporte, renglon

-- ####################################################
--  Procedure 1:
PROCEDURE pu_calcula_saldo (GV_RECIBE_MOV VARCHAR2,
                            GV_NIVELI_1 VARCHAR2, GV_NIVELI_2 VARCHAR2,
                            GV_NIVELI_3 VARCHAR2, GV_NIVELI_4 VARCHAR2,
                            GV_NIVELI_5 VARCHAR2, GV_NIVELI_6 VARCHAR2,
                            GV_NIVELI_7 VARCHAR2, GV_NIVELI_8 VARCHAR2,
			    GV_NIVELF_1 VARCHAR2, GV_NIVELF_2 VARCHAR2,
                            GV_NIVELF_3 VARCHAR2, GV_NIVELF_4 VARCHAR2,
                            GV_NIVELF_5 VARCHAR2, GV_NIVELF_6 VARCHAR2,
                            GV_NIVELF_7 VARCHAR2, GV_NIVELF_8 VARCHAR2,
                            Gn_Agencia Number,
                            Gn_dia     number,Gn_mes    number,
                            Gn_anio    number,Gn_dia_fin number,
                            Gn_mes_fin number,Gn_anio_fin number,
                            GN_TOTAL             OUT NUMBER)IS


Ln_total_ini  number (14,2):= 0;
Ln_total_fin  number (14,2) := 0;
Ln_total      number (14,2) := 0;

/* cursor para separar por dia los saldos */

  cursor  C_Saldos is
      select MES, SALDO_DIA_1,SALDO_DIA_2,SALDO_DIA_3,SALDO_DIA_4,SALDO_DIA_5,SALDO_DIA_6,
             SALDO_DIA_7,SALDO_DIA_8,SALDO_DIA_9,SALDO_DIA_10,SALDO_DIA_11,SALDO_DIA_12,
             SALDO_DIA_13,SALDO_DIA_14,SALDO_DIA_15,SALDO_DIA_16,SALDO_DIA_17,SALDO_DIA_18,
             SALDO_DIA_19,SALDO_DIA_20,SALDO_DIA_21,SALDO_DIA_22,SALDO_DIA_23,SALDO_DIA_24,
             SALDO_DIA_25,SALDO_DIA_26,SALDO_DIA_27,SALDO_DIA_28,SALDO_DIA_29,SALDO_DIA_30,SALDO_DIA_31
      from   gm_saldos_diarios a,
             gm_balance_cuentas b
      where ( ( ANIO   =  GN_ANIO 
        and    MES     =  GN_MES  )  
         or (  ANIO    =  GN_ANIO_FIN
         AND   mes     =   GN_MES_FIN )) 
      AND    a.nivel_1||a.nivel_2||a.nivel_3||a.nivel_4||a.nivel_5||a.nivel_6||a.nivel_7||a.nivel_8  BETWEEN
             Gv_niveli_1||Gv_niveli_2||Gv_niveli_3||Gv_niveli_4||Gv_niveli_5||Gv_niveli_6||Gv_niveli_7||Gv_niveli_8 AND
             Gv_nivelf_1||Gv_nivelf_2||Gv_nivelf_3||Gv_nivelf_4||Gv_nivelf_5||Gv_nivelf_6||Gv_nivelf_7||Gv_nivelf_8 
      AND a.nivel_1||a.nivel_2||a.nivel_3||a.nivel_4||a.nivel_5||a.nivel_6||a.nivel_7||a.nivel_8 = b.cuenta
      AND B.RECIBE_MOVIMIENTO = GV_RECIBE_MOV
      AND a.codigo_empresa    = b.codigo_empresa
      AND To_Number(a.nivel_5) = Nvl(Gn_Agencia,To_Number(a.nivel_5))
      order by  ANIO, mes, 
            a.nivel_1||a.nivel_2||a.nivel_3||a.nivel_4||a.nivel_5||a.nivel_6||a.nivel_7||a.nivel_8;
BEGIN
  
    FOR SALDO IN C_SALDOS loop

          ln_total_ini := 0;
          ln_total_fin := 0;

     if saldo.mes = gn_mes then
	if Gn_dia = 1   then
            ln_total_ini :=  saldo.saldo_dia_1;
        elsif Gn_dia = 2   then
           ln_total_ini :=  saldo.saldo_dia_2;
        elsif Gn_dia = 3   then
           ln_total_ini :=  saldo.saldo_dia_3;
        elsif Gn_dia = 4   then
           ln_total_ini :=  saldo.saldo_dia_4;
        elsif Gn_dia = 5   then
           ln_total_ini :=  saldo.saldo_dia_5;
        elsif Gn_dia = 6   then
           ln_total_ini :=  saldo.saldo_dia_6;
        elsif Gn_dia = 7   then
           ln_total_ini :=  saldo.saldo_dia_7;
        elsif Gn_dia = 8   then
           ln_total_ini :=  saldo.saldo_dia_8;
        elsif Gn_dia = 9   then
           ln_total_ini :=  saldo.saldo_dia_9;
        elsif Gn_dia = 10   then
           ln_total_ini :=  saldo.saldo_dia_10;
        elsif Gn_dia = 11  then
           ln_total_ini :=  saldo.saldo_dia_11;
        elsif Gn_dia = 12   then
           ln_total_ini :=  saldo.saldo_dia_12;
        elsif Gn_dia = 13   then
           ln_total_ini :=  saldo.saldo_dia_13;
        elsif Gn_dia = 14   then
           ln_total_ini :=  saldo.saldo_dia_14;
        elsif Gn_dia = 15   then
           ln_total_ini :=  saldo.saldo_dia_15;
        elsif Gn_dia = 16   then
           ln_total_ini :=  saldo.saldo_dia_16;
        elsif Gn_dia = 17   then
           ln_total_ini :=  saldo.saldo_dia_17;
        elsif Gn_dia = 18   then
           ln_total_ini :=  saldo.saldo_dia_18;
        elsif Gn_dia = 19   then
           ln_total_ini :=  saldo.saldo_dia_19;
        elsif Gn_dia = 20   then
           ln_total_ini :=  saldo.saldo_dia_20;
        elsif Gn_dia = 21   then
           ln_total_ini :=  saldo.saldo_dia_21;
        elsif Gn_dia = 22   then
           ln_total_ini :=  saldo.saldo_dia_22;
        elsif Gn_dia = 23   then
           ln_total_ini :=  saldo.saldo_dia_23;
        elsif Gn_dia = 24   then
           ln_total_ini :=  saldo.saldo_dia_24;
        elsif Gn_dia = 25   then
           ln_total_ini :=  saldo.saldo_dia_25;
        elsif Gn_dia = 26   then
           ln_total_ini :=  saldo.saldo_dia_26;
        elsif Gn_dia = 27   then
           ln_total_ini :=  saldo.saldo_dia_27;
        elsif Gn_dia = 28   then
           ln_total_ini :=  saldo.saldo_dia_28;
        elsif Gn_dia = 29   then
           ln_total_ini :=  saldo.saldo_dia_29;
        elsif Gn_dia = 30   then
           ln_total_ini :=  saldo.saldo_dia_30;
        else
           ln_total_ini :=  saldo.saldo_dia_31;
        end if;
       end if; 

 

     if saldo.mes = gn_mes_fin then
	if Gn_dia_fin = 1   then
            ln_total_fin :=  saldo.saldo_dia_1;
        elsif Gn_dia_fin = 2   then
           ln_total_fin :=  saldo.saldo_dia_2;
        elsif Gn_dia_fin = 3   then
           ln_total_fin :=  saldo.saldo_dia_3;
        elsif Gn_dia_fin = 4   then
           ln_total_fin :=  saldo.saldo_dia_4;
        elsif Gn_dia_fin = 5   then
           ln_total_fin :=  saldo.saldo_dia_5;
        elsif Gn_dia_fin = 6   then
           ln_total_fin :=  saldo.saldo_dia_6;
        elsif Gn_dia_fin = 7   then
           ln_total_fin :=  saldo.saldo_dia_7;
        elsif Gn_dia_fin = 8   then
           ln_total_fin :=  saldo.saldo_dia_8;
        elsif Gn_dia_fin = 9   then
           ln_total_fin :=  saldo.saldo_dia_9;
        elsif Gn_dia_fin = 10   then
           ln_total_fin :=  saldo.saldo_dia_10;
        elsif Gn_dia_fin = 11  then
           ln_total_fin :=  saldo.saldo_dia_11;
        elsif Gn_dia_fin = 12   then
           ln_total_fin :=  saldo.saldo_dia_12;
        elsif Gn_dia_fin = 13   then
           ln_total_fin :=  saldo.saldo_dia_13;
        elsif Gn_dia_fin = 14   then
           ln_total_fin :=  saldo.saldo_dia_14;
        elsif Gn_dia_fin = 15   then
           ln_total_fin :=  saldo.saldo_dia_15;
        elsif Gn_dia_fin = 16   then
           ln_total_fin :=  saldo.saldo_dia_16;
        elsif Gn_dia_fin = 17   then
           ln_total_fin :=  saldo.saldo_dia_17;
        elsif Gn_dia_fin = 18   then
           ln_total_fin :=  saldo.saldo_dia_18;
        elsif Gn_dia_fin = 19   then
           ln_total_fin :=  saldo.saldo_dia_19;
        elsif Gn_dia_fin = 20   then
           ln_total_fin :=  saldo.saldo_dia_20;
        elsif Gn_dia_fin = 21   then
           ln_total_fin :=  saldo.saldo_dia_21;
        elsif Gn_dia_fin = 22   then
           ln_total_fin :=  saldo.saldo_dia_22;
        elsif Gn_dia_fin = 23   then
           ln_total_fin :=  saldo.saldo_dia_23;
        elsif Gn_dia_fin = 24   then
           ln_total_fin :=  saldo.saldo_dia_24;
        elsif Gn_dia_fin = 25   then
           ln_total_fin :=  saldo.saldo_dia_25;
        elsif Gn_dia_fin = 26   then
           ln_total_fin :=  saldo.saldo_dia_26;
        elsif Gn_dia_fin = 27   then
           ln_total_fin :=  saldo.saldo_dia_27;
        elsif Gn_dia_fin = 28   then
           ln_total_fin :=  saldo.saldo_dia_28;
        elsif Gn_dia_fin = 29   then
           ln_total_fin :=  saldo.saldo_dia_29;
        elsif Gn_dia_fin = 30   then
           ln_total_fin :=  saldo.saldo_dia_30;
        else
           ln_total_fin :=  saldo.saldo_dia_31;
        end if;
       end if; 

        If :p_tipo_saldo = 1 Then
         ln_total := (ln_total_fin - ln_total_ini) + ln_total;
        Else
         ln_total := Ln_total + ln_total_fin;
        end if;
         gn_total := ln_total;
     end loop;
    Gn_total := nvl(gn_total,0);
  END;


-- ####################################################

  -- Procedure 2:
  PROCEDURE PU_DESCRIPCION_CTA (GV_NIVEL1 VARCHAR2, GV_NIVEL2 VARCHAR2,
                              GV_NIVEL3 VARCHAR2, GV_NIVEL4 VARCHAR2,
                              GV_NIVEL5 VARCHAR2, GV_NIVEL6 VARCHAR2,
                              GV_NIVEL7 VARCHAR2, GV_NIVEL8 VARCHAR2,
                              GV_DESCRIPCION  OUT VARCHAR2 )IS
BEGIN
select descripcion into Gv_descripcion  
  from gm_balance_cuentas
  where nivel_1  =  Gv_nivel1  and
        nivel_2  =  Gv_nivel2  and
	nivel_3  =  Gv_nivel3  and
	nivel_4  =  Gv_nivel4  and
	nivel_5  =  Gv_nivel5  and
	nivel_6  =  Gv_nivel6  and
	nivel_7  =  Gv_nivel7  and
	nivel_8  =  Gv_nivel8  and
  codigo_empresa =  codigo_empresa;      
exception
  when no_data_found then
       Gv_descripcion := 'Error: Cuenta no Existe';
END;

-- ####################################################

-- CUERPO DE FUNCION:
Function PU_F_CALCULATOTALMES( TipoSaldo    Varchar2,
                                 MontoMes01  In Out Number,
                                 MontoMes02  In Out Number,
                                 MontoMes03  In Out Number,
                                 MontoMes04  In Out Number,
                                 MontoMes05  In Out Number,
                                 MontoMes06  In Out Number,
                                 MontoMes07  In Out Number,
                                 MontoMes08  In Out Number,
                                 MontoMes09  In Out Number,
                                 MontoMes10  In Out Number,
                                 MontoMes11  In out Number,
                                 MontoMes12  In Out Number)
Return Number
IS
  Pn_calculo  number(16,2) := 0;
  Ln_mes                Number(2);
  Ln_anio               Number(4);
  Ln_dia                Number(2);

begin
  If :p_anio = :p_anio_fiscal Then
    if :p_mes_fiscal != 1 Then
       Ln_mes := :p_mes_fiscal - 1;
    else
       ln_mes := 1;
    end if;
  else
    Ln_Mes := 12;  
  End if;   

  Pn_Calculo := MontoMes01 + MontoMes02 + MontoMes03 + 
                MontoMes04 + MontoMes05 + MontoMes06 + 
                MontoMes07 + MontoMes08 + MontoMes09 + 
                MontoMes10 + MontoMes11 + MontoMes12 ;

  If TipoSaldo != '1' Then
    Pn_Calculo := Pn_Calculo / Ln_mes;
  End If;
  Return(Pn_Calculo);
end;

-- ####################################################
-- Procedure 3:
PROCEDURE  PU_P_CALCULACOLUMNASMES 
IS
  Pn_calculo            Number(16,2) := 0;
  Ln_mes                Number(2);
  Ln_anio               Number(4);
  Ln_dia                Number(2);
  Ln_mes_fin            Number(2);
  Ln_anio_fin           Number(4);
  Ln_dia_fin            Number(2);
  Ln_MesAnt             Number(2);
  Ln_DiaAnt             Number(2);
  Ln_AnioAnt            Number(4);
  Ln_Agencia            Number(4);
  Ln_MontoMes01         Number(16,2);
  Ln_MontoMes02         Number(16,2);
  Ln_MontoMes03         Number(16,2);
  Ln_MontoMes04         Number(16,2);
  Ln_MontoMes05         Number(16,2);
  Ln_MontoMes06         Number(16,2);
  Ln_MontoMes07         Number(16,2);
  Ln_MontoMes08         Number(16,2);
  Ln_MontoMes09         Number(16,2);
  Ln_MontoMes10         Number(16,2);
  Ln_MontoMes11         Number(16,2);
  Ln_MontoMes12         Number(16,2);

  Ld_MesAnterior        Date;
  Ld_CalculoMesAnterior Date;
  Ln_Total              Number := 0;
  Lv_recibe_movimiento  Varchar2(1);
  Lv_Columna            Varchar2(16);
begin


Ln_MontoMes01 := 0; Ln_MontoMes02 := 0;
Ln_MontoMes03 := 0; Ln_MontoMes04 := 0;
Ln_MontoMes05 := 0; Ln_MontoMes06 := 0;
Ln_MontoMes07 := 0; Ln_MontoMes08 := 0;
Ln_MontoMes09 := 0; Ln_MontoMes10 := 0;
Ln_MontoMes11 := 0; Ln_MontoMes12 := 0;

  :cp_colmes01  := (' ');
  :cp_colmes02  := (' ');
  :cp_colmes03  := (' ');
  :cp_colmes04  := (' ');
  :cp_colmes05  := (' ');
  :cp_colmes06  := (' ');
  :cp_colmes07  := (' ');
  :cp_colmes08  := (' ');
  :cp_colmes09  := (' ');
  :cp_colmes10  := (' ');
  :cp_colmes11  := (' ');
  :cp_colmes12  := (' ');
  :cp_coltotmes := (' ');
If  :cta_inicial_nivel_1 is  not null  or   
    :cta_inicial_nivel_2 is  not null  or
    :cta_inicial_nivel_3 is  not null  or
    :cta_inicial_nivel_4 is  not null  or   
    :cta_inicial_nivel_5 is  not null  or   
    :cta_inicial_nivel_6 is  not null  or
    :cta_inicial_nivel_7 is  not null  or   
    :cta_inicial_nivel_8 is  not null  or   
    :cta_final_nivel_1   is  not null  or
    :cta_final_nivel_2   is  not null  or   
    :cta_final_nivel_3   is  not null  or   
    :cta_final_nivel_4   is  not null  or
    :cta_final_nivel_5   is  not null  or   
    :cta_final_nivel_6   is  not null  or   
    :cta_final_nivel_7   is  not null  or
    :cta_final_nivel_8   is  not null  
    then

  Pu_P_CALCULASALDOSMES
           ( :P_TIPO_SALDO ,
             Ln_MontoMes01 ,
             Ln_MontoMes02 ,
             Ln_MontoMes03 ,
             Ln_MontoMes04 ,
             Ln_MontoMes05 ,
             Ln_MontoMes06 ,
             Ln_MontoMes07 ,
             Ln_MontoMes08 ,
             Ln_MontoMes09 ,
             Ln_MontoMes10 ,
             Ln_MontoMes11 ,
             Ln_MontoMes12 );


End if;

if  :cta_inicial_nivel_1 is null  or   
    :cta_inicial_nivel_2 is null  or
    :cta_inicial_nivel_3 is null  or
    :cta_inicial_nivel_4 is null   
then
    if :subrayado in ('-') then

      :cp_colmes01  := LPAD(:cp_colmes01,50,CHR(95)); --('---------------');
      :cp_colmes02  := LPAD(:cp_colmes02,50,CHR(95)); --('---------------');
      :cp_colmes03  := LPAD(:cp_colmes03,50,CHR(95)); --('---------------');
      :cp_colmes04  := LPAD(:cp_colmes04,50,CHR(95)); --('---------------');
      :cp_colmes05  := LPAD(:cp_colmes05,50,CHR(95)); --('---------------');
      :cp_colmes06  := LPAD(:cp_colmes06,50,CHR(95)); --('---------------');
      :cp_colmes07  := LPAD(:cp_colmes07,50,CHR(95)); --('---------------');
      :cp_colmes08  := LPAD(:cp_colmes08,50,CHR(95)); --('---------------');
      :cp_colmes09  := LPAD(:cp_colmes09,50,CHR(95)); --('---------------');
      :cp_colmes10  := LPAD(:cp_colmes10,50,CHR(95)); --('---------------');
      :cp_colmes11  := LPAD(:cp_colmes11,50,CHR(95)); --('---------------');
      :cp_colmes12  := LPAD(:cp_colmes12,50,CHR(95)); --('---------------');
      :cp_coltotmes := LPAD(:cp_coltotmes,50,CHR(95)); --('---------------');
      
    elsif :subrayado in ('=') then
      :cp_colmes01  := LPAD(:cp_colmes01,50,CHR(61)); --('==============');
      :cp_colmes02  := LPAD(:cp_colmes02,50,CHR(61)); --('==============')
      :cp_colmes03  := LPAD(:cp_colmes03,50,CHR(61)); --('==============')
      :cp_colmes04  := LPAD(:cp_colmes04,50,CHR(61)); --('==============')
      :cp_colmes05  := LPAD(:cp_colmes05,50,CHR(61)); --('==============')
      :cp_colmes06  := LPAD(:cp_colmes06,50,CHR(61)); --('==============')
      :cp_colmes07  := LPAD(:cp_colmes07,50,CHR(61)); --('==============')
      :cp_colmes08  := LPAD(:cp_colmes08,50,CHR(61)); --('==============')
      :cp_colmes09  := LPAD(:cp_colmes09,50,CHR(61)); --('==============')
      :cp_colmes10  := LPAD(:cp_colmes10,50,CHR(61)); --('==============')
      :cp_colmes11  := LPAD(:cp_colmes11,50,CHR(61)); --('==============')
      :cp_colmes12  := LPAD(:cp_colmes12,50,CHR(61)); --('==============')
      :cp_coltotmes := LPAD(:cp_coltotmes,50,CHR(61)); --('==============')

    elsif :imprime_subtotal = 'S' then
     :cp_colmes01 := to_char(:cp_submes01,'999,999,999,990.00');
     :cp_colmes02 := to_char(:cp_submes02,'999,999,999,990.00');
     :cp_colmes03 := to_char(:cp_submes03,'999,999,999,990.00');
     :cp_colmes04 := to_char(:cp_submes04,'999,999,999,990.00');
     :cp_colmes05 := to_char(:cp_submes05,'999,999,999,990.00');
     :cp_colmes06 := to_char(:cp_submes06,'999,999,999,990.00');
     :cp_colmes07 := to_char(:cp_submes07,'999,999,999,990.00');
     :cp_colmes08 := to_char(:cp_submes08,'999,999,999,990.00');
     :cp_colmes09 := to_char(:cp_submes09,'999,999,999,990.00');
     :cp_colmes10 := to_char(:cp_submes10,'999,999,999,990.00');
     :cp_colmes11 := to_char(:cp_submes11,'999,999,999,990.00');
     :cp_colmes12 := to_char(:cp_submes12,'999,999,999,990.00');

     Pn_Calculo := PU_F_CALCULATOTALMES( :P_TIPO_SALDO ,
                                         :cp_SubMes01 ,
                                         :cp_SubMes02 ,
                                         :cp_SubMes03 ,
                                         :cp_SubMes04 ,
                                         :cp_SubMes05 ,
                                         :cp_SubMes06 ,
                                         :cp_SubMes07 ,
                                         :cp_SubMes08 ,
                                         :cp_SubMes09 ,
                                         :cp_SubMes10 ,
                                         :cp_SubMes11 ,
                                         :cp_SubMes12 );
 
     :cp_coltotmes   := to_char(Pn_calculo,'999,999,990.00');

     :cp_submes01 := 0;    :cp_submes02 := 0;
     :cp_submes03 := 0;    :cp_submes04 := 0;
     :cp_submes05 := 0;    :cp_submes06 := 0;
     :cp_submes07 := 0;    :cp_submes08 := 0;
     :cp_submes09 := 0;    :cp_submes10 := 0;
     :cp_submes11 := 0;    :cp_submes12 := 0;

   elsif :imprime_subtotal_02 = 'S' Then

       :cp_colmes01 := to_char(:cp_totdetmes01,'999,999,999,990.00');
       :cp_colmes02 := to_char(:cp_totdetmes02,'999,999,999,990.00');
       :cp_colmes03 := to_char(:cp_totdetmes03,'999,999,999,990.00');
       :cp_colmes04 := to_char(:cp_totdetmes04,'999,999,999,990.00');
       :cp_colmes05 := to_char(:cp_totdetmes05,'999,999,999,990.00');
       :cp_colmes06 := to_char(:cp_totdetmes06,'999,999,999,990.00');
       :cp_colmes07 := to_char(:cp_totdetmes07,'999,999,999,990.00');
       :cp_colmes08 := to_char(:cp_totdetmes08,'999,999,999,990.00');
       :cp_colmes09 := to_char(:cp_totdetmes09,'999,999,999,990.00');
       :cp_colmes10 := to_char(:cp_totdetmes10,'999,999,999,990.00');
       :cp_colmes11 := to_char(:cp_totdetmes11,'999,999,999,990.00');
       :cp_colmes12 := to_char(:cp_totdetmes12,'999,999,999,990.00');
      
       :cp_totdetmes01 := 0;       :cp_totdetmes02 := 0;
       :cp_totdetmes03 := 0;       :cp_totdetmes04 := 0;
       :cp_totdetmes05 := 0;       :cp_totdetmes06 := 0;
       :cp_totdetmes07 := 0;       :cp_totdetmes08 := 0;
       :cp_totdetmes09 := 0;       :cp_totdetmes10 := 0;
       :cp_totdetmes11 := 0;       :cp_totdetmes12 := 0;

       Pn_Calculo := PU_F_CALCULATOTALMES( :P_TIPO_SALDO ,
                                           :cp_TotalMes01 ,
                                           :cp_TotalMes02 ,
                                           :cp_TotalMes03 ,
                                           :cp_TotalMes04 ,
                                           :cp_TotalMes05 ,
                                           :cp_TotalMes06 ,
                                           :cp_TotalMes07 ,
                                           :cp_TotalMes08 ,
                                           :cp_TotalMes09 ,
                                           :cp_TotalMes10 ,
                                           :cp_TotalMes11 ,
                                           :cp_TotalMes12 );

       :cp_coltotmes   := to_char(Pn_calculo,'999,999,990.00');
   elsif :imprime_total = 'S' then


       :cp_colmes01 := to_char(:cp_totalmes01,'999,999,999,990.00');
       :cp_colmes02 := to_char(:cp_totalmes02,'999,999,999,990.00');
       :cp_colmes03 := to_char(:cp_totalmes03,'999,999,999,990.00');
       :cp_colmes04 := to_char(:cp_totalmes04,'999,999,999,990.00');
       :cp_colmes05 := to_char(:cp_totalmes05,'999,999,999,990.00');
       :cp_colmes06 := to_char(:cp_totalmes06,'999,999,999,990.00');
       :cp_colmes07 := to_char(:cp_totalmes07,'999,999,999,990.00');
       :cp_colmes08 := to_char(:cp_totalmes08,'999,999,999,990.00');
       :cp_colmes09 := to_char(:cp_totalmes09,'999,999,999,990.00');
       :cp_colmes10 := to_char(:cp_totalmes10,'999,999,999,990.00');
       :cp_colmes11 := to_char(:cp_totalmes11,'999,999,999,990.00');
       :cp_colmes12 := to_char(:cp_totalmes12,'999,999,999,990.00');

       Pn_Calculo := PU_F_CALCULATOTALMES( :P_TIPO_SALDO ,
                                           :cp_TotalMes01 ,
                                           :cp_TotalMes02 ,
                                           :cp_TotalMes03 ,
                                           :cp_TotalMes04 ,
                                           :cp_TotalMes05 ,
                                           :cp_TotalMes06 ,
                                           :cp_TotalMes07 ,
                                           :cp_TotalMes08 ,
                                           :cp_TotalMes09 ,
                                           :cp_TotalMes10 ,
                                           :cp_TotalMes11 ,
                                           :cp_TotalMes12 );
 
       :cp_coltotmes   := to_char(Pn_calculo,'999,999,990.00');

--     end If;

    end if;

else

 
  :cp_submes01  := :cp_submes01 + Ln_MontoMes01;  
  :cp_submes02  := :cp_submes02 + Ln_MontoMes02;  
  :cp_submes03  := :cp_submes03 + Ln_MontoMes03;  
  :cp_submes04  := :cp_submes04 + Ln_MontoMes04;  
  :cp_submes05  := :cp_submes05 + Ln_MontoMes05;  
  :cp_submes06  := :cp_submes06 + Ln_MontoMes06;  
  :cp_submes07  := :cp_submes07 + Ln_MontoMes07;  
  :cp_submes08  := :cp_submes08 + Ln_MontoMes08;  
  :cp_submes09  := :cp_submes09 + Ln_MontoMes09;  
  :cp_submes10  := :cp_submes10 + Ln_MontoMes10;  
  :cp_submes11  := :cp_submes11 + Ln_MontoMes11;  
  :cp_submes12  := :cp_submes12 + Ln_MontoMes12;  

  :cp_totdetmes01 := :cp_totdetmes01 + Ln_MontoMes01;
  :cp_totdetmes02 := :cp_totdetmes02 + Ln_MontoMes02;
  :cp_totdetmes03 := :cp_totdetmes03 + Ln_MontoMes03;
  :cp_totdetmes04 := :cp_totdetmes04 + Ln_MontoMes04;
  :cp_totdetmes05 := :cp_totdetmes05 + Ln_MontoMes05;
  :cp_totdetmes06 := :cp_totdetmes06 + Ln_MontoMes06;
  :cp_totdetmes07 := :cp_totdetmes07 + Ln_MontoMes07;
  :cp_totdetmes08 := :cp_totdetmes08 + Ln_MontoMes08;
  :cp_totdetmes09 := :cp_totdetmes09 + Ln_MontoMes09;
  :cp_totdetmes10 := :cp_totdetmes10 + Ln_MontoMes10;
  :cp_totdetmes11 := :cp_totdetmes11 + Ln_MontoMes11;
  :cp_totdetmes12 := :cp_totdetmes12 + Ln_MontoMes12;


  IF substr(:cta_inicial_nivel_1,1,1) = 5   then


    :cp_totalmes01 := :cp_totalmes01 + Ln_MontoMes01;
    :cp_totalmes02 := :cp_totalmes02 + Ln_MontoMes02;
    :cp_totalmes03 := :cp_totalmes03 + Ln_MontoMes03;
    :cp_totalmes04 := :cp_totalmes04 + Ln_MontoMes04;
    :cp_totalmes05 := :cp_totalmes05 + Ln_MontoMes05;
    :cp_totalmes06 := :cp_totalmes06 + Ln_MontoMes06;
    :cp_totalmes07 := :cp_totalmes07 + Ln_MontoMes07;
    :cp_totalmes08 := :cp_totalmes08 + Ln_MontoMes08;
    :cp_totalmes09 := :cp_totalmes09 + Ln_MontoMes09;
    :cp_totalmes10 := :cp_totalmes10 + Ln_MontoMes10;
    :cp_totalmes11 := :cp_totalmes11 + Ln_MontoMes11;
    :cp_totalmes12 := :cp_totalmes12 + Ln_MontoMes12;
  END IF;

  IF  substr(:cta_inicial_nivel_1,1,1) = 4   then
    :cp_totalmes01 := :cp_totalmes01 - Ln_MontoMes01;
    :cp_totalmes02 := :cp_totalmes02 - Ln_MontoMes02;
    :cp_totalmes03 := :cp_totalmes03 - Ln_MontoMes03;
    :cp_totalmes04 := :cp_totalmes04 - Ln_MontoMes04;
    :cp_totalmes05 := :cp_totalmes05 - Ln_MontoMes05;
    :cp_totalmes06 := :cp_totalmes06 - Ln_MontoMes06;
    :cp_totalmes07 := :cp_totalmes07 - Ln_MontoMes07;
    :cp_totalmes08 := :cp_totalmes08 - Ln_MontoMes08;
    :cp_totalmes09 := :cp_totalmes09 - Ln_MontoMes09;
    :cp_totalmes10 := :cp_totalmes10 - Ln_MontoMes10;
    :cp_totalmes11 := :cp_totalmes11 - Ln_MontoMes11;
    :cp_totalmes12 := :cp_totalmes12 - Ln_MontoMes12;
  END IF;

  :cp_colmes01 := to_char(Ln_montomes01,'999,999,999,990.00');
  :cp_colmes02 := to_char(Ln_montomes02,'999,999,999,990.00');
  :cp_colmes03 := to_char(Ln_montomes03,'999,999,999,990.00');
  :cp_colmes04 := to_char(Ln_montomes04,'999,999,999,990.00');
  :cp_colmes05 := to_char(Ln_montomes05,'999,999,999,990.00');
  :cp_colmes06 := to_char(Ln_montomes06,'999,999,999,990.00');
  :cp_colmes07 := to_char(Ln_montomes07,'999,999,999,990.00');
  :cp_colmes08 := to_char(Ln_montomes08,'999,999,999,990.00');
  :cp_colmes09 := to_char(Ln_montomes09,'999,999,999,990.00');
  :cp_colmes10 := to_char(Ln_montomes10,'999,999,999,990.00');
  :cp_colmes11 := to_char(Ln_montomes11,'999,999,999,990.00');
  :cp_colmes12 := to_char(Ln_montomes12,'999,999,999,990.00');
  
  Pn_Calculo := PU_F_CALCULATOTALMES( :P_TIPO_SALDO ,
                                          Ln_MontoMes01 ,
                                          Ln_MontoMes02 ,
                                          Ln_MontoMes03 ,
                                          Ln_MontoMes04 ,
                                          Ln_MontoMes05 ,
                                          Ln_MontoMes06 ,
                                          Ln_MontoMes07 ,
                                          Ln_MontoMes08 ,
                                          Ln_MontoMes09 ,
                                          Ln_MontoMes10 ,
                                          Ln_MontoMes11 ,
                                          Ln_MontoMes12 );

  :cp_coltotmes   := to_char(Pn_calculo,'999,999,999,990.00');

end if;
end;

-- Procedure 4:
Procedure PU_P_CALCULASALDOSMES( TipoMonto    Varchar2,
                                 MontoMes01  In Out Number,
                                 MontoMes02  In Out Number,
                                 MontoMes03  In Out Number,
                                 MontoMes04  In Out Number,
                                 MontoMes05  In Out Number,
                                 MontoMes06  In Out Number,
                                 MontoMes07  In Out Number,
                                 MontoMes08  In Out Number,
                                 MontoMes09  In Out Number,
                                 MontoMes10  In Out Number,
                                 MontoMes11  In out Number,
                                 MontoMes12  In Out Number)
IS
  Pn_calculo  number(16,2) := 0;
  Ln_mes                Number(2);
  Ln_anio               Number(4);
  Ln_dia                Number(2);
  Ln_mes_fin            Number(2);
  Ln_anio_fin           Number(4);
  Ln_dia_fin            Number(2);
  Ln_MesAnt             Number(2);
  Ln_DiaAnt             Number(2);
  Ln_AnioAnt            Number(4);
  Ln_Agencia            Number(4);
  Ld_FechaInicial       Date;
  Ld_FechaFinal         Date;
  Ld_MesAnterior        Date;
  Ld_CalculoMesAnterior Date;
  Ln_Total              Number := 0;
  Lv_recibe_movimiento  Varchar2(1);
  Lv_Columna            Varchar2(16);
begin
	
  Ln_Agencia  := Nvl(:P_AGENCIA,0);
  If Ln_Agencia = 0 
  Then
    Ln_Agencia := Null;
  End If;

  if :tipo_detalle = 'D' then
    lv_recibe_movimiento := 'S';
  else
    lv_recibe_movimiento := 'N';
  end if;


  Ld_FechaInicial := To_date('01'||'01'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  IF Ln_dia = 1 then
      ln_mes := ln_mes   - 1;
   end if;

  IF Ln_anio != ln_anio_fin or
   To_Number(to_char(:p_fecha_final,'mm')) = to_Number(to_char(:p_primer_habil_sem,'mm'))
  then
     Ln_Anio := 1900;
  End If;

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes01);

-- Febrero
  Ld_FechaInicial := To_date('01'||'02'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes02);   


-- Marzo   
  Ld_FechaInicial := to_date('01'||'03'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes03);   
-- Abril 
  Ld_FechaInicial := to_date('01'||'04'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));


  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes04);   

-- Mayo 
  Ld_FechaInicial := To_Date('01'||'05'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes05);  
-- Junio 
  Ld_FechaInicial := To_Date('01'||'06'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes06);  

-- Julio 

  Ld_FechaInicial := to_date('01'||'07'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes07);  
-- Agosto 

  Ld_FechaInicial := to_date('01'||'08'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes08);  
-- Septiembre
  Ld_FechaInicial := To_Date('01'||'09'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes09);
-- Octubre
  Ld_FechaInicial := To_Date('01'||'10'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes10);  

-- Noviembre 

  Ld_FechaInicial := To_Date('01'||'11'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes11);
-- Diciembre

  Ld_FechaInicial := to_date('01'||'12'||to_char(:p_anio),'ddmmyyyy');
  Ld_FechaFinal   := Last_day(Ld_FechaInicial);

  Ln_dia          := TO_NUMBER(TO_CHAR(Ld_FechaInicial - 1,'DD'));
  Ln_mes          := to_number(TO_CHAR(Ld_FechaInicial - 1,'MM'));
  Ln_anio         := to_number(TO_CHAR(Ld_FechaInicial - 1,'YYYY'));

  Ln_dia_fin  := TO_NUMBER(TO_CHAR(Ld_fechafinal,'DD'));
  Ln_mes_fin  := to_number(TO_CHAR(Ld_fechafinal,'MM'));
  Ln_anio_fin := to_number(TO_CHAR(LD_fechafinal,'YYYY'));

  if ln_anio_fin  = :p_anio_fiscal and
     ln_mes_fin  >= :p_mes_fiscal 
  Then
    Return;
  End If;

  pu_calcula_saldo  (lv_recibe_movimiento,
                     :cta_inicial_nivel_1,
                     :cta_inicial_nivel_2,
                     :cta_inicial_nivel_3,
                     :cta_inicial_nivel_4,
                     :cta_inicial_nivel_5,
                     :cta_inicial_nivel_6,
	             :cta_inicial_nivel_7,
                     :cta_inicial_nivel_8,
                     :cta_final_nivel_1,
		     :cta_final_nivel_2,
                     :cta_final_nivel_3,
                     :cta_final_nivel_4,
		     :cta_final_nivel_5,
                     :cta_final_nivel_6,
                     :cta_final_nivel_7,
		     :cta_final_nivel_8,
                     Ln_Agencia,
                     ln_dia,
                     ln_mes,
                     ln_anio,
                     ln_dia_fin,
                     ln_mes_fin,
	             ln_anio_fin,
                     MontoMes12);    
end;


-- ####################################################

-- Funciones:
function CF_ACUMULADO_ANUALFormula return VARCHAR2 is
Ln_acumulado_anual     number(14,2);
ln_SaldoTotalAnual     number(14,2);
ln_SaldoTotalSemestre  number(14,2);
ln_acumulado_semestral number(14,2);
Ln_subtotal number(14,2);
Lv_RECIBE_MOVIMIENTO VARCHAR2(1);
Ln_MesActual  Number;
Ln_AnioActual Number;
Ln_Agencia    Number := Nvl(:P_Agencia,0);
ln_total      Number := 0;
begin

If  :cta_inicial_nivel_1 is  not null  or   
    :cta_inicial_nivel_2 is  not null  or
    :cta_inicial_nivel_3 is  not null  or
    :cta_inicial_nivel_4 is  not null  or   
    :cta_final_nivel_1   is  not null  or
    :cta_final_nivel_2   is  not null  or   
    :cta_final_nivel_3   is  not null  or   
    :cta_final_nivel_4   is  not null  
    then
  if :tipo_detalle = 'D' then
     lv_recibe_movimiento := 'S';
  else
     lv_recibe_movimiento := 'N';
  end if;
 
  Select mes_fiscal_actual,
         ano_fiscal_actual
    Into Ln_MesActual,
         Ln_anioActual
    From gm_parametros
   Where codigo_empresa = :p_codigo_empresa;
  
   Ln_MesActual :=   to_Number(to_char(:p_fecha_final,'mm'));

   If Ln_MesActual = 1 
  Then
     Ln_mesActual := 0;
  elsif Ln_mesActual = 7 Then
     Ln_mesactual  := 12;
  else
     Ln_mesActual := Ln_MesActual -1;
  end iF;

  If Ln_Agencia = 0 Then 
     Ln_Agencia := Null;
  End If;

  select sum(decode(Ln_MesActual,1,saldo_mes_1,
                                  2,saldo_mes_2,
                                  3,saldo_mes_3,
                                  4,saldo_mes_4,
                                  5,saldo_mes_5,
                                  6,saldo_mes_6,
                                  7,saldo_mes_7,
                                  8,saldo_mes_8,
                                  9,saldo_mes_9,
                                 10,saldo_mes_10,
                                 11,saldo_mes_11,
                                 12,saldo_mes_12,0)),sum(nvl(saldo_mes_6,0))
    into Ln_acumulado_anual,ln_acumulado_semestral
    from gm_saldos_mensuales a,
         gm_balance_cuentas b
   where b.recibe_movimiento = lv_recibe_movimiento
     AND a.nivel_1||a.nivel_2||a.nivel_3||a.nivel_4||a.nivel_5||a.nivel_6||a.nivel_7||a.nivel_8  BETWEEN
         :cta_inicial_nivel_1 ||:cta_inicial_nivel_2||:cta_inicial_nivel_3||:cta_inicial_nivel_4||
         :cta_inicial_nivel_5 ||:cta_inicial_nivel_6||:cta_inicial_nivel_7||:cta_inicial_nivel_8
     AND :cta_final_nivel_1||:cta_final_nivel_2||:cta_final_nivel_3||:cta_final_nivel_4||
         :cta_final_nivel_5||:cta_final_nivel_6||:cta_final_nivel_7||:cta_final_nivel_8 
     AND a.nivel_1||a.nivel_2||a.nivel_3||a.nivel_4||a.nivel_5||a.nivel_6||a.nivel_7||a.nivel_8 = b.cuenta
     AND To_Number(a.nivel_5) = Nvl(Ln_Agencia,To_Number(a.nivel_5))
     AND anio = to_char(:p_fecha,'YYYY')
     AND B.CODIGO_EMPRESA = A.CODIGO_EMPRESA
     AND a.codigo_empresa = :p_codigo_empresa;

/*
  If Ln_MesActual > 6 
  Then
   Ln_saldototalanual    := ln_acumulado_semestral + ln_acumulado_anual;
   ln_saldototalsemestre := ln_acumulado_anual;
  Else
   ln_saldototalanual    := ln_acumulado_anual;
   ln_saldototalsemestre := ln_acumulado_anual;
  End if;
*/

  ln_saldototalanual  := ln_acumulado_anual;

  :cp_total_a := :cp_total_a + ln_saldototalanual;

  IF substr(:cta_inicial_nivel_1,1,1) = 4   
  Then
     :CP_INGRESOS_A := NVL(Ln_saldototalanual,0);
     :CP_GASTOS_A   := 0;
     :CP_INGRESOS_S := NVL(Ln_saldototalsemestre,0);
     :CP_GASTOS_S   := 0;
  END IF;

  IF  substr(:cta_inicial_nivel_1,1,1) = 5   then
     :CP_GASTOS_A   := NVL(Ln_saldototalanual,0);
     :CP_INGRESOS_A := 0;
     :CP_GASTOS_S   := NVL(Ln_saldototalsemestre,0);
     :CP_INGRESOS_S := 0;
  END IF;


    :cp_acum_semestre   := TO_CHAR((nvl(Ln_saldototalSemestre,0)),'999,999,999,990.00');

  return(TO_CHAR((NVL(Ln_saldototalanual,0)),'999,999,999,990.00'));

else
   if :subrayado in ('-') then
      :cp_acum_semestre  := '--------------------'; 
      return               ('--------------------');
    elsif :subrayado in ('=') then
      :cp_acum_semestre  := '===================='; 
      return               ('====================');
    elsif :imprime_subtotal = 'S' then
      ln_total := :cp_total_a;
      :cp_total_a := 0;
      :cp_acum_semestre  := to_char(:cp_subtotal_s,'999,999,999,990.00');
      return(TO_CHAR(ln_total ,'999,999,999,990.00'));

    elsif :imprime_total = 'S' then

      :cp_acum_semestre  := to_char(:cp_subtotal_s,'999,999,999,990');
       return(TO_CHAR(:CP_SUBTOTAL_A,'999,999,999,990.00'));

    else 
      :cp_acum_semestre := null;
    end if;
end if;
RETURN NULL; end;

-- ####################################################

function CF_ANIOFormula return Number is
begin
  RETURN(TO_CHAR(:P_FECHA,'YYYY'));
end;

-- ####################################################

function CF_CALCULOMESFormula return VARCHAR2 
is
Begin
:cp_colmes01  := (' ');
:cp_colmes02  := (' ');
:cp_colmes03  := (' ');
:cp_colmes04  := (' ');
:cp_colmes05  := (' ');
:cp_colmes06  := (' ');
:cp_colmes07  := (' ');
:cp_colmes08  := (' ');
:cp_colmes09  := (' ');
:cp_colmes10  := (' ');
:cp_colmes11  := (' ');
:cp_colmes12  := (' ');
:cp_coltotmes := (' ');
--
PU_P_CALCULACOLUMNASMES;
--
:CP_CONT:=:CP_CONT+1;
--
Return(Null);
RETURN NULL; 
Exception
When Others Then 
  Return(Null);
End;

-- ####################################################

function CF_FECHA_HOYFormula return Date is
Ld_FechaHoy date;
begin
  SELECT FECHA_HOY INTO Ld_FechaHoy
  FROM MG_CALENDARIO
  WHERE CODIGO_EMPRESA    = TO_NUMBER(:P_CODIGO_EMPRESA)
  AND   CODIGO_APLICACION = :P_CODIGO_APLICACION;
  RETURN Ld_FechaHoy;
  RETURN NULL; EXCEPTION WHEN OTHERS THEN NULL;
RETURN NULL; end;

-- ####################################################

function CF_ING_GAS_AFormula return Number is
begin

  if :imprime_subtotal = 'S' then
      :CP_INGRESOS_A:=0;
      :CP_GASTOS_A  :=0;
  END IF;
  
  :CP_SUBTOTAL_A:= NVL(:CP_SUBTOTAL_A,0) + :CP_INGRESOS_A - :CP_GASTOS_A;
  
  RETURN(0);
end;

-- ####################################################

function CF_ING_GAS_SFormula return Number is
begin

  if :imprime_subtotal = 'S' then
      :CP_INGRESOS_S:=0;
      :CP_GASTOS_S  :=0;
  END IF;
  
  :CP_SUBTOTAL_S:= NVL(:CP_SUBTOTAL_S,0) + :CP_INGRESOS_S - :CP_GASTOS_S;
  
  RETURN(0);
end;

-- ####################################################

function CF_MESFormula return VARCHAR2 is
begin
  :P_MES:= TO_CHAR(:P_FECHA,'MM');
  If :P_MES=1 then
      RETURN('ENERO');
  elsif :P_MES=2 then
      RETURN('FEBRERO');      
  elsif :P_MES=3 then
      RETURN('MARZO');      
  elsif :P_MES=4 then
      RETURN('ABRIL');
  elsif :P_MES=5 then
      RETURN('MAYO');      
  elsif :P_MES=6 then
      RETURN('JUNIO');      
  elsif :P_MES=7 then 
      RETURN('JULIO');
  elsif :P_MES=8 then
      RETURN('AGOSTO');      
  elsif :P_MES=9 then
      RETURN('SEPTIEMBRE');      
  elsif :P_MES=10 then
      RETURN('OCTUBRE');      
  elsif :P_MES=11 then
      RETURN('NOVIEMBRE');      
  elsif :P_MES=12 then
      RETURN('DICIEMBRE');      
  end if; 

RETURN NULL; end;

-- ####################################################

function CF_NOMBRE_EMPRESAFormula return VARCHAR2 is
Lv_Empresa VARCHAR2(30);
begin
  SELECT NOMBRE INTO Lv_Empresa
  FROM MG_EMPRESAS
  WHERE CODIGO_EMPRESA = To_Number(:P_CODIGO_EMPRESA);
  RETURN(Lv_Empresa);
  RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;

-- ####################################################

function CF_nombre_reporteFormula return VARCHAR2 is
lv_nombre   VARCHAR2(80);
begin

   select descripcion into lv_nombre
   from gm_reportes_encabezado
   where codigo_reporte = :p_codigo_reporte;
   If Nvl(:P_agencia,0) = 0 Then
     Lv_Nombre := Lv_Nombre ||' CONSOLIDADO';
   Else
    Begin
      Select Lv_Nombre ||' '|| Nombre_agencia
        Into Lv_Nombre 
        From mg_agencias_Generales
       Where codigo_agencia = :P_agencia;
     Exception
     When No_Data_Found Then Null;
    End;
   End If;
    
  RETURN(Lv_Nombre);
  RETURN NULL; EXCEPTION WHEN OTHERS THEN RETURN NULL;
end;

-- ####################################################

function CF_SUBTITULOFormula return VARCHAR2 is
  MesInicioFiscal    Number;
  MesFiscalActual    Number;
  AnioFiscalActual   Number;
begin
  
  Select mes_fiscal_actual,
         ano_fiscal_actual,
         mes_inicio_fiscal
    Into MesFiscalActual,
         anioFiscalActual,
         mesInicioFiscal
    From gm_parametros
   Where codigo_empresa = :p_codigo_empresa;

  MesFiscalActual := to_number(to_char(:p_fecha_final,'MM'));
  AnioFiscalActual  := to_number(to_char(:p_fecha_final,'yyyy'));

  If :P_tipo_saldo = '1' Then
  Return(' SALDOS NETOS ');
  ELSE
  Return(' SALDOS ACUMULADOS '); 
  END IF;
RETURN NULL; end;

-- ####################################################

function CF_TOTAL_CUENTA1Formula return VARCHAR2 is
  Pn_calculo  number(16,2) := 0;
  Ln_mes                Number(2);
  Ln_anio               Number(4);
  Ln_dia                Number(2);
  Ln_mes_fin            Number(2);
  Ln_anio_fin           Number(4);
  Ln_dia_fin            Number(2);
  Ln_MesAnt             Number(2);
  Ln_DiaAnt             Number(2);
  Ln_AnioAnt            Number(4);
  Ln_Agencia            Number(4);
  Ld_MesAnterior        Date;
  Ld_CalculoMesAnterior Date;
  Ln_Total              Number := 0;
  Lv_recibe_movimiento  Varchar2(1);
begin

if  :cta_inicial_nivel_1 is  not null  or   
    :cta_inicial_nivel_2 is  not null  or
    :cta_inicial_nivel_3 is  not null  or
    :cta_inicial_nivel_4 is  not null  or   
    :cta_inicial_nivel_5 is  not null  or   
    :cta_inicial_nivel_6 is  not null  or
    :cta_inicial_nivel_7 is  not null  or   
    :cta_inicial_nivel_8 is  not null  or   
    :cta_final_nivel_1   is  not null  or
    :cta_final_nivel_2   is  not null  or   
    :cta_final_nivel_3   is  not null  or   
    :cta_final_nivel_4   is  not null  or
    :cta_final_nivel_5   is  not null  or   
    :cta_final_nivel_6   is  not null  or   
    :cta_final_nivel_7   is  not null  or
    :cta_final_nivel_8   is  not null  
    then

       if :tipo_detalle = 'D' then
          lv_recibe_movimiento := 'S';
       else
          lv_recibe_movimiento := 'N';
       end if;

	Ln_dia      := TO_NUMBER(TO_CHAR(:P_fecha - 1,'DD'));
	Ln_mes      := to_number(TO_CHAR(:P_fecha - 1,'MM'));
	Ln_anio     := to_number(TO_CHAR(:P_fecha - 1,'YYYY'));

	Ln_dia_fin  := TO_NUMBER(TO_CHAR(:P_fecha_final,'DD'));
	Ln_mes_fin  := to_number(TO_CHAR(:P_fecha_final,'MM'));
	Ln_anio_fin := to_number(TO_CHAR(:P_fecha_final,'YYYY'));

 
        IF Ln_dia = 1 then
           ln_mes := ln_mes   - 1;
        end if;

        IF Ln_anio != ln_anio_fin or
           To_Number(to_char(:p_fecha_final,'mm')) = to_Number(to_char(:p_primer_habil_sem,'mm'))
        then
           Ln_Anio := 1900;
        End If; 

        Ln_Agencia  := Nvl(:P_AGENCIA,0);
        If Ln_Agencia = 0 
        THEN
          Ln_Agencia := Null;
        End If;


 	pu_calcula_saldo(lv_recibe_movimiento,
                         :cta_inicial_nivel_1,
                         :cta_inicial_nivel_2,
                         :cta_inicial_nivel_3,
                	 :cta_inicial_nivel_4,
                         :cta_inicial_nivel_5,
                         :cta_inicial_nivel_6,
	                 :cta_inicial_nivel_7,
                         :cta_inicial_nivel_8, 
                         :cta_final_nivel_1,
			 :cta_final_nivel_2,
                         :cta_final_nivel_3,
                         :cta_final_nivel_4,
		  	 :cta_final_nivel_5,
                         :cta_final_nivel_6,
                         :cta_final_nivel_7,
		  	 :cta_final_nivel_8,
                         Ln_Agencia,
                         ln_dia,
                         ln_mes,
                         ln_anio,
                         ln_dia_fin,
                         ln_mes_fin,
			 ln_anio_fin, 
                         pn_calculo);

     
END IF;

if  :cta_inicial_nivel_1 is null  or   
    :cta_inicial_nivel_2 is null  or
    :cta_inicial_nivel_3 is null  or
    :cta_inicial_nivel_4 is null   
then
    if :subrayado in ('-') then
      return('-----------------');
    elsif :subrayado in ('=') then
      return('=================');
    elsif :imprime_subtotal = 'S' then
       Ln_Total     := :cp_subtotal;
       :cp_subtotal := 0;

       return(TO_CHAR(ln_total,'999,999,990.00'));

    elsif :imprime_total = 'S' then

        return(TO_CHAR(:cp_total,'999,999,990.00'));
    end if;

else

  IF substr(:cta_inicial_nivel_1,1,1) = 4   then
     :CP_INGRESOS  := NVL(pn_calculo,0); 
     :CP_GASTOS    := 0;
  END IF;

  IF  substr(:cta_inicial_nivel_1,1,1) = 5   then
     :CP_GASTOS   := NVL(pn_calculo,0);
     :CP_INGRESOS := 0; 
  END IF;

  :cp_subtotal    := nvl(:cp_subtotal,0) + :cp_ingresos + :cp_gastos;
  :cp_total       := nvl(:cp_total,0)    + :cp_ingresos - :cp_gastos;

  return(TO_CHAR((NVL(pn_calculo,0)),'999,999,990.00'));

end if;
RETURN NULL; end;

-- ####################################################

