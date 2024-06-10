SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Olger Gamboa Castillo
-- Create date: 20/04/2021
-- Description:	Procedimiento para para realizar la consulta de los expedientes por filtros de la solicitud de carga
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ConsultarPosiblesExpedientesInactivo]
	@CodSolicitud bigint,
	@ValidarDocumento bit,
	@ValidarEscrito bit,
	@FechaCorte Datetime2(3),
	@CodContexto varchar(4)
AS
BEGIN
	--Variables
DECLARE @TN_CodSolicitud bigint		=   @CodSolicitud,
		@TB_ValidarDocumento bit	=	@ValidarDocumento,
		@TB_ValidarEscrito bit		=	@ValidarEscrito,
		@TF_Corte Datetime2(3)		=	@FechaCorte,
		@TC_CodContexto  varchar(4)	=	@CodContexto

DECLARE @ESTADO_CIRCULANTE CHAR(1)='A'
DECLARE @FECHAMINIMA DATETIME2 =CONVERT(DATETIME, -53690)
DECLARE @SQL_LEGAJOS_CANDIDATOS_INACTIVAR NVARCHAR(MAX)='WITH LegajoEnCirculante_CTE(TC_NumeroExpediente,TU_CodLegajo,FechaMovimientoCirculante,TC_CodContexto,TC_Movimiento,TN_CodEstado,Estado) 
		AS (
		SELECT	hme.TC_NumeroExpediente,	hme.TU_CodLegajo,
				hme.TF_Fecha AS FechaMovimientoCirculante,
				hme.TC_CodContexto,			hme.TC_Movimiento,
				ce.TN_CodEstado,			ce.TC_Descripcion AS Estado 
		FROM Historico.LegajoMovimientoCirculante  hme WITH (NOLOCK) INNER join(
																SELECT  e.TC_NumeroExpediente, e.TC_CodContexto, e.TU_CodLegajo, max(e.TF_Fecha) AS Fecha
																FROM Historico.LegajoMovimientoCirculante e WITH (NOLOCK)
																GROUP BY  e.TC_NumeroExpediente, e.TC_CodContexto, e.TU_CodLegajo) ume
																ON ume.Fecha=hme.TF_Fecha AND ume.TC_CodContexto=hme.TC_CodContexto 
																AND ume.TC_NumeroExpediente=hme.TC_NumeroExpediente AND ume.TU_CodLegajo=hme.TU_CodLegajo
		INNER JOIN Catalogo.Estado ce WITH (NOLOCK) ON hme.TN_CodEstado= CE.TN_CodEstado AND  ce.TC_Circulante='''+@ESTADO_CIRCULANTE+'''
		WHERE hme.TC_CodContexto='''+@TC_CodContexto+''') '
DECLARE @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR NVARCHAR(MAX)='
DELETE 
		FROM [Expediente].[DetalleDepuracionInactivo] 
		WHERE [TN_CodSolicitud]='+CAST(@CodSolicitud AS VARCHAR)+';
WITH ExpedientesEnCirculante_CTE(TC_NumeroExpediente,FechaMovimientoCirculante,TC_CodContexto,TC_Movimiento,TN_CodEstado,Estado) 
AS (
		SELECT	hme.TC_NumeroExpediente,	hme.TF_Fecha AS FechaMovimientoCirculante,
				hme.TC_CodContexto,			hme.TC_Movimiento,
				ce.TN_CodEstado,			ce.TC_Descripcion AS Estado 
		FROM Historico.ExpedienteMovimientoCirculante hme WITH (NOLOCK) INNER join(
																SELECT  e.TC_NumeroExpediente, e.TC_CodContexto,max(e.TF_Fecha) AS Fecha
																FROM Historico.ExpedienteMovimientoCirculante e WITH (NOLOCK)
																GROUP BY  e.TC_NumeroExpediente, e.TC_CodContexto) ume
																ON ume.Fecha=hme.TF_Fecha AND ume.TC_CodContexto=hme.TC_CodContexto AND ume.TC_NumeroExpediente=hme.TC_NumeroExpediente
		INNER JOIN Catalogo.Estado ce WITH (NOLOCK) ON hme.TN_CodEstado= CE.TN_CodEstado AND ce.TC_Circulante='''+@ESTADO_CIRCULANTE+'''
		WHERE hme.TC_CodContexto='''+@TC_CodContexto+''')'
DECLARE @SUBQUERY_FROM_DOCUMENTO NVARCHAR(MAX)=''
DECLARE @SUBQUERY_FROM_DOCUMENTO_LEGAJO NVARCHAR(MAX)=''
IF @TB_ValidarDocumento=1
BEGIN
	SET @SUBQUERY_FROM_DOCUMENTO+=',isnull(max(aa.TF_FechaCrea),'''+ CAST(@FECHAMINIMA as varchar) +''') AS FechaUltimoDocumento'
	SET @SUBQUERY_FROM_DOCUMENTO_LEGAJO+=',isnull(max(aa.TF_FechaCrea),'''+ CAST(@FECHAMINIMA as varchar) +''') AS FechaUltimoDocumento'
END
ELSE BEGIN
	SET @SUBQUERY_FROM_DOCUMENTO+=','''+ CAST(@FECHAMINIMA as varchar)+''' AS FechaUltimoDocumento'
	SET @SUBQUERY_FROM_DOCUMENTO_LEGAJO+=','''+ CAST(@FECHAMINIMA as varchar)+''' AS FechaUltimoDocumento'
END
IF @TB_ValidarEscrito=1
BEGIN
	SET @SUBQUERY_FROM_DOCUMENTO+=',isnull(max(ee.TF_FechaIngresoOficina),'''+ CAST(@FECHAMINIMA as varchar) +''') AS FechaUltimoEscrito '
	SET @SUBQUERY_FROM_DOCUMENTO_LEGAJO+=',isnull(max(ee.TF_FechaIngresoOficina),'''+ CAST(@FECHAMINIMA as varchar) +''') AS FechaUltimoEscrito '
END
ELSE BEGIN
	SET @SUBQUERY_FROM_DOCUMENTO+=','''+ CAST(@FECHAMINIMA as varchar) +'''AS FechaUltimoEscrito'
	SET @SUBQUERY_FROM_DOCUMENTO_LEGAJO+=','''+ CAST(@FECHAMINIMA as varchar) +'''AS FechaUltimoEscrito'
END


SET @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR +='
		,ExpedientesCandidatosCTE(TC_NumeroExpediente,FechaMovimientoCirculante,
		TC_CodContexto,TC_Movimiento,TN_CodEstado,Estado,FechaUltimoDocumento,FechaUltimoEscrito) as (
		SELECT	hme.TC_NumeroExpediente, hme.FechaMovimientoCirculante, hme.TC_CodContexto, hme.TC_Movimiento, hme.TN_CodEstado, hme.Estado
		'+@SUBQUERY_FROM_DOCUMENTO+'
		FROM ExpedientesEnCirculante_CTE hme
			'
SET @SQL_LEGAJOS_CANDIDATOS_INACTIVAR +='
		,LegajosCandidatosCTE(TC_NumeroExpediente,TU_CodLegajo,FechaMovimientoCirculante,
		TC_CodContexto,TC_Movimiento,TN_CodEstado,Estado,FechaUltimoDocumento,FechaUltimoEscrito) as (
		SELECT	hme.TC_NumeroExpediente, hme.TU_CodLegajo,hme.FechaMovimientoCirculante, hme.TC_CodContexto, hme.TC_Movimiento, hme.TN_CodEstado, hme.Estado
		'+@SUBQUERY_FROM_DOCUMENTO_LEGAJO+'
		FROM LegajoEnCirculante_CTE hme
			'
IF @TB_ValidarDocumento=1
BEGIN
	SET @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR +='	
		LEFT JOIN Expediente.ArchivoExpediente ea  WITH (NOLOCK)
		ON ea.TC_NumeroExpediente=hme.TC_NumeroExpediente 
		AND ea.TU_CodArchivo NOT IN(
											SELECT lea.TU_CodArchivo
											FROM Expediente.LegajoArchivo lea
											WHERE lea.TU_CodArchivo=ea.TU_CodArchivo and lea.TC_NumeroExpediente=ea.TC_NumeroExpediente
										)
		LEFT JOIN Archivo.Archivo aa WITH (NOLOCK) ON aa.TU_CodArchivo= ea.TU_CodArchivo
		'
	SET @SQL_LEGAJOS_CANDIDATOS_INACTIVAR +='	
		LEFT JOIN Expediente.LegajoArchivo lea WITH (NOLOCK) on lea.TU_CodLegajo=hme.TU_CodLegajo and lea.TC_NumeroExpediente=hme.TC_NumeroExpediente
		LEFT JOIN Expediente.ArchivoExpediente ea WITH (NOLOCK) on ea.TU_CodArchivo=lea.TU_CodArchivo and ea.TC_NumeroExpediente=lea.TC_NumeroExpediente
		LEFT JOIN Archivo.Archivo aa WITH (NOLOCK) ON aa.TU_CodArchivo= ea.TU_CodArchivo '
END
IF @TB_ValidarEscrito=1
BEGIN
SET @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR +='	
		LEFT JOIN Expediente.EscritoExpediente ee WITH (NOLOCK) 
		ON ee.TC_NumeroExpediente = hme.TC_NumeroExpediente AND ee.TC_CodContexto=hme.TC_CodContexto
		AND ee.TU_CodEscrito NOT IN(
											SELECT lee.TU_CodEscrito 
											FROM Expediente.EscritoLegajo lee
											WHERE lee.TU_CodEscrito=ee.TU_CodEscrito)'
SET @SQL_LEGAJOS_CANDIDATOS_INACTIVAR +='	
		LEFT JOIN Expediente.EscritoLegajo lee WITH (NOLOCK) on lee.TU_CodLegajo=hme.TU_CodLegajo 
		LEFT JOIN Expediente.EscritoExpediente ee WITH (NOLOCK) ON ee.TU_CodEscrito=lee.TU_CodEscrito and  ee.TC_CodContexto=hme.TC_CodContexto
		
		'
END
SET @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR +=' 
		GROUP BY hme.TC_NumeroExpediente, hme.FechaMovimientoCirculante, 
		hme.TC_CodContexto, hme.TC_Movimiento, hme.TN_CodEstado, hme.Estado) '
SET @SQL_LEGAJOS_CANDIDATOS_INACTIVAR +=' 
		GROUP BY hme.TC_NumeroExpediente, hme.TU_CodLegajo, hme.FechaMovimientoCirculante, 
		hme.TC_CodContexto, hme.TC_Movimiento, hme.TN_CodEstado, hme.Estado) '

SET @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR +='
		INSERT INTO [Expediente].[DetalleDepuracionInactivo](
															TN_CodSolicitud,	
															TC_NumeroExpediente, 
															TU_CodLegajo,
															TB_TieneMandamientos,
															TB_TieneDepositos,
															TF_UltimoAcontecimiento,
															TC_TipoAcontecimiento,
															TC_Estado,
															TC_Resultado
															)
		SELECT	'+CAST(@CodSolicitud AS VARCHAR)+',
				TC_NumeroExpediente,
				NULL,
				0,
				0,
				(SELECT CASE	WHEN max(FechaUltimoDocumento)> max(FechaUltimoEscrito)   THEN max(FechaUltimoDocumento)
								WHEN max(FechaUltimoEscrito)>max(FechaUltimoDocumento)  THEN max(FechaUltimoEscrito)
								ELSE '''+ CAST(@FECHAMINIMA as varchar) +'''
								END) as FechaUltimoAcontecimiento,
				(SELECT CASE	WHEN max(FechaUltimoDocumento)> max(FechaUltimoEscrito)  THEN ''D''
								WHEN max(FechaUltimoEscrito)>max(FechaUltimoDocumento)  THEN ''E''
								ELSE NULL
								END) as FechaUltimoAcontecimiento,
				''P'',
				''En espera de validación del SDJ''
				FROM ExpedientesCandidatosCTE
				GROUP BY TC_NumeroExpediente,  FechaUltimoDocumento,FechaUltimoEscrito 
				HAVING max(FechaUltimoDocumento)<'''+ CAST(@TF_Corte as varchar) +'''
				AND max(FechaUltimoEscrito)<'''+ CAST(@TF_Corte as varchar) +''''
											
SET @SQL_LEGAJOS_CANDIDATOS_INACTIVAR +='
		INSERT INTO [Expediente].[DetalleDepuracionInactivo](
															TN_CodSolicitud,	
															TC_NumeroExpediente, 
															TU_CodLegajo,
															TB_TieneMandamientos,
															TB_TieneDepositos,
															TF_UltimoAcontecimiento,
															TC_TipoAcontecimiento,
															TC_Estado,
															TC_Resultado
															)
		SELECT	'+CAST(@CodSolicitud AS VARCHAR)+',
				TC_NumeroExpediente,
				TU_CodLegajo,
				0,
				0,
				(SELECT CASE	WHEN max(FechaUltimoDocumento)> max(FechaUltimoEscrito)   THEN max(FechaUltimoDocumento)
								WHEN max(FechaUltimoEscrito)>max(FechaUltimoDocumento)  THEN max(FechaUltimoEscrito)
								ELSE '''+ CAST(@FECHAMINIMA as varchar) +'''
								END) as FechaUltimoAcontecimiento,
				(SELECT CASE	WHEN max(FechaUltimoDocumento)> max(FechaUltimoEscrito)  THEN ''D''
								WHEN max(FechaUltimoEscrito)>max(FechaUltimoDocumento)  THEN ''E''
								ELSE NULL
								END) as FechaUltimoAcontecimiento,
				''P'',
				''En espera de validación del SDJ''
				FROM LegajosCandidatosCTE							 
				GROUP BY TC_NumeroExpediente,  TU_CodLegajo,FechaUltimoDocumento,FechaUltimoEscrito 
				HAVING max(FechaUltimoDocumento)<'''+ CAST(@TF_Corte as varchar) +'''
				AND max(FechaUltimoEscrito)<'''+ CAST(@TF_Corte as varchar) +''''
--PRINT @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR
--PRINT @SQL_LEGAJOS_CANDIDATOS_INACTIVAR
EXEC sys.[sp_executesql] @SQL_EXPEDIENTES_CANDIDATOS_INACTIVAR
EXEC sys.[sp_executesql]  @SQL_LEGAJOS_CANDIDATOS_INACTIVAR


SELECT	edi.TN_CodDetalleDepuracion AS Codigo,						edi.TN_CodSolicitud AS  CodigoSolicitud,
		edi.TB_TieneMandamientos AS TieneMandamientos,				edi.TB_TieneDepositos AS TieneDepositos,
		edi.TF_UltimoAcontecimiento AS FechaUltimoAcontecimiento,	edi.TC_Resultado AS Resultado,
		'SplitEnumeradores' AS SplitEnumeradores,						edi.TC_Estado AS Estado,
		edi.TC_TipoAcontecimiento AS TipoAcontecimiento,			'SplitExpediente' AS SplitExpediente,
		edi.TC_NumeroExpediente AS Numero,							'SplitLegajo' AS SplitLegajo,
		edi.TU_CodLegajo AS CodigoLegajo
FROM Expediente.DetalleDepuracionInactivo edi WITH (NOLOCK)
WHERE edi.TN_CodSolicitud=@TN_CodSolicitud

END
GO
