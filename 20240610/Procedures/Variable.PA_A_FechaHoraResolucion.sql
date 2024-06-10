SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<09-09-2020>
-- Description:					<Traducción de la Variable del PJEditor fecha y hora de la resolución para LibreOffice>
-- NOTA:						<28/09/2020> <El parametro @@TiposResolucion debe recibir los valores separados por comas.>
--														  <Por ejemplo: '1,14,15,11,17,18,19,20'>
-- ====================================================================================================================================================================================
-- Modificación:				<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaHoraResolucion]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@TiposResolucion		AS VARCHAR(MAX),
	@Cantidad				AS SMALLINT
AS
BEGIN
	DECLARE		@L_NumeroExpediente		AS CHAR(14)		=	@NumeroExpediente
	DECLARE		@L_CodLegajo			VARCHAR(40)		=	@CodLegajo
	DECLARE		@L_Contexto				AS VARCHAR(4)	=	@Contexto
	DECLARE		@L_TiposResolucion		VARCHAR(MAX)	=	@TiposResolucion
	DECLARE		@L_Cantidad				AS SMALLINT		=	@Cantidad
DECLARE		@L_Tipos				TABLE (Tipo INT);

	IF LEN(@L_TiposResolucion) = 0
		INSERT INTO @L_Tipos
		SELECT	TN_CodTipoResolucion
		FROM	Catalogo.TipoResolucion WITH(NOLOCK)
	ELSE
		INSERT INTO @L_Tipos
		SELECT	CONVERT(INT,RTRIM(LTRIM(Value)))
FROM	STRING_SPLIT(@L_TiposResolucion, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		Top(@L_Cantidad) A.TF_FechaResolucion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)  
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TN_CodTipoResolucion				IN (
															SELECT	Tipo
															FROM	@L_Tipos
															)
		ORDER BY	A.TF_FechaResolucion DESC
	END
	ELSE
	BEGIN
		SELECT		Top(@L_Cantidad) A.TF_FechaResolucion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.LegajoArchivo			B WITH(NOLOCK)
		ON			A.TU_CodArchivo						= B.TU_CodArchivo
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK) 
		ON			C.TU_CodLegajo						= B.TU_CodLegajo 
		WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TN_CodTipoResolucion				IN (
															SELECT	Tipo
															FROM	@L_Tipos
															)
		ORDER BY	A.TF_FechaResolucion DESC
	END
END
GO
