-- Q_1:
Select  
'GX' aplicacion,
B0057EmCod  codigo_empresa, 
A0174SlAgc codigo_agencia,
A0012SpCod codigo_sub_aplicacion,
B0057SlnRO numero_prestamo,   
B0011CrEje  codigo_ejecutivo,
B0013PbCod  clave_producto,
B0057EDSec secuencia,   --secuencia
B0057EDFch fecha_movimiento, 
to_char(B0057EDEst) estado,   --estado decicion 1 aprobado , 2 rechazado, 3 anaulado
B0057EDMoA VLR_APROBADO,
B0011CrMTo VLR_SOLICITADO,
B0010CcCCr Clase_prestamo,
b.codigo_moneda,
A0174SlFch  fecha_solicitud,
A0048ClCod codigo_cliente,
c.numero_identificacion,
DECODE(c.tipo_de_persona, 'N',c.primer_apellido||' '||c.segundo_apellido||' '|| c.nombres,NVL(razon_social,nombre_comercial))Nom_Cliente
From B0057 a, A0174, B0011, B0010, MG_SUB_APLICACIONES B, A0048, mg_clientes C
WHERE  B0057SlnRO=nvl(p_numero_op,B0057SlnRO)
And c.codigo_cliente = A0048ClCod
And A0012SpCod  =   b.codigo_sub_aplicacion
And b.codigo_aplicacion = 'BPR'
And B0011EmCod = B0057EmCod
And B0011PrCod = B0057PrCod
And B0011SoNro = B0057SlnRO
And B0010EmCod = B0057EmCod
And B0010PrCod = B0057PrCod
And B0010SoNro = B0057SlnRO
And A0001EmCod = B0057EmCod
And A0011PrCod = B0057PrCod
And A0174SlNro = B0057SlnRO
And B0057PrCod = '10'
AND ( (:Pv_Estado IN ('1','2')  AND to_char(B0057EDEst) =DECODE(:Pv_Estado,'1','1','2','3') )
          or 
         (:Pv_Estado in('9') AND B0057EDEst  IN (1,3))
       ) --GX 1, desembolsado 3 anulado 
And B0057EDFch  between :P_fecha_inicial and :P_fecha_final 
union
SELECT 
       'BPR' aplicacion,
       a.codigo_empresa, 
       a.codigo_agencia,
       a.codigo_sub_aplicacion,
       a.numero_prestamo, 
       con.codigo_ejecutivo, 
       a.clave_producto,
       0 secuencia, 
       NULL fecha_movimiento, 
       a.estado, --1 vigente, 9 anulado
       a.monto_inicial VLR_APROBADO,
       B0011CrMTo VLR_SOLICITADO, 
       a.codigo_tipo clase_prestamo, 
       c.codigo_moneda,
       con.fecha_aprobacion fecha_solicitud, 
       a.codigo_cliente, 
       d.numero_identificacion,
       DECODE(d.tipo_de_persona, 'N',d.primer_apellido||' '||d.segundo_apellido||' '|| d.nombres,NVL(razon_social,nombre_comercial))Nom_Cliente
  FROM pr_prestamos a,
       pr_contratos con,
       mg_sub_aplicaciones c,
       mg_clientes d,
       b0011
 WHERE a.numero_prestamo=nvl(:p_numero_op,a.numero_prestamo)
   AND a.numero_contrato = con.numero_contrato
   AND a.codigo_sub_aplicacion = con.codigo_sub_aplicacion
   AND a.codigo_agencia = con.codigo_agencia
   AND a.codigo_empresa = con.codigo_empresa
   AND a.codigo_cliente = d.codigo_cliente
   AND con.codigo_empresa = b0011emcod
   AND b0011prcod ='10'
   AND con.nro_solicitud = b0011sonro   
   AND c.codigo_aplicacion='BPR'
   AND c.codigo_sub_aplicacion = a.codigo_sub_aplicacion
   AND NVL(A.VALOR_DESEMBOLSOS,0) = 0 
   AND ( (:Pv_Estado IN ('3','4')  AND a.estado =DECODE(:Pv_Estado,'3','1','4','4') )
          or 
         (:Pv_Estado in('9') AND a.estado  IN ('1','4'))
       ) --BPR 1, desembolsado 4 anulado

-- Funciones:
-- F_estado:
function CF_ESTADOFormula return Char is
begin
	IF :APLICACION='GX'THEN 
    IF '1'= :estado THEN
    	RETURN( 'Solicitudes aprobados');
    ELSE 
      RETURN('Solicitudes anuladas');
    END IF;  
  ELSE
    IF '1'= :estado THEN
  	   RETURN('Créditos Formalizados');
    ELSE
  	   RETURN('Créditos For. Anulados');
     END IF;
  END IF;
end;


-- F_CF_ejecutivo:
function CF_ejecutivoFormula return Char is
Lv_nombre varchar2(200);
begin
	select primer_apellido||' '||segundo_apellido||' '||nombres
	into Lv_nombre
	 from mg_usuarios_del_sistema
	 where codigo_usuario=:codigo_ejecutivo;
  return(lv_nombre);
end;


