/*
(10) BD - F_codigo_trama.Q_TRAMA_ERROR
(20) BD - F_descProceso.Q_TRAMA_ERROR.DESCRIPTION
(30) BD - F_Lote.Q_TRANA_ERROR.
(40) BD - F_NumeroRegistro.Q_TRAMA_ERROR.
(50) BD - F_Posicion.Q_TRAMA_ERROR.
(60) BD - F_ProcesadorPor.Q_TRAMA_ERROR.
(70) BD - F_Fecha.Q_TRAMA_ERROR.
(80) BD - F_codigo_error.Q_TRAMA_ERROR.
 */
--Q_TRAMA_ERROR
/*
PARAMETROS:
PR_LOTE
 */
Select
  a.TRAMA_CODE AS TRAMA,
  a.DATE_HOUR AS DATE_HOUR,
  a.USER_CODE AS USER_CODE,
  a.LOT AS LOT,
  a.REGISTER_NBR AS REGISTER_NBR,
  a.POSITION AS POS,
  a.ERROR_CODE AS ERROR_CODE,
  b.descripcion AS desc_Trama
From
  MG_ERROR_FRAME a,
  MG_TYPES_FRAMES b, -- traducir
  MG_TEMP_FRAME c
WHERE
  a.LOT = nvl (P_LOT, a.LOT)
  and a.TRAMA_CODE = b.TRAMA_CODE
  and a.COMPANY_CODE = b.COMPANY_CODE
  and a.LOT = c.LOT
  and a.REGISTER_NBR = c.REGISTER_NBR
ORDER BY
  1,
  2,
  3,
  4,
  5,
  6
  -- No hay funciones