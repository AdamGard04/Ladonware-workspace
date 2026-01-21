--Q_MATRICIAL
SELECT
    a.nivel_1,
    a.nivel_2,
    a.nivel_3,
    a.nivel_4,
    a.nivel_5,
    a.nivel_6,
    a.nivel_7,
    a.nivel_8,
    a.saldo,
    b.descripcion,
    c.nombre
FROM
    GM_CONSOLIDACION_EMPRESAS a,
    GM_BALANCE_CUENTAS b,
    MG_EMPRESAS c,
    GM_CATALOGOS d
WHERE
    b.nivel_1 (+) = a.nivel_1
    AND b.nivel_2 (+) = a.nivel_2
    AND b.nivel_3 (+) = a.nivel_3
    AND b.nivel_4 (+) = a.nivel_4
    AND b.nivel_5 (+) = a.nivel_5
    AND b.nivel_6 (+) = a.nivel_6
    AND b.nivel_7 (+) = a.nivel_7
    AND b.nivel_8 (+) = a.nivel_8
    AND c.codigo_empresa (+) = a.codigo_empresa
    AND d.nivel_1 = a.nivel_1
    AND d.nivel_2 = a.nivel_2
    AND d.nivel_3 = a.nivel_3
    AND d.nivel_4 = a.nivel_4
    AND d.nivel_5 = a.nivel_5
    AND d.nivel_6 = a.nivel_6
    AND d.clase_cuenta NOT IN ('ENC', 'SUM')
Order by
    a.nivel_1,
    a.nivel_2,
    a.nivel_3,
    a.nivel_4,
    a.nivel_5,
    a.nivel_6,
    a.nivel_7,
    a.nivel_8;

-- Functions:
function CF_FormulaFormula return VARCHAR2 is
Pv_Formato VARCHAR2(39);
begin
  GM_P_DESPLEGAR_R(:nivel_1, :nivel_2, :nivel_3, :nivel_4, :nivel_5,
      :nivel_6, :nivel_7, :nivel_8, :p_codigo_empresa, Pv_Formato);
  RETURN(Pv_Formato);
end;