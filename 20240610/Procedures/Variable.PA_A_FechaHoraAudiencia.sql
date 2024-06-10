SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:			<Miguel Avendaño Rosales>
-- Create date:		<22-09-2020>
-- Description:		<Traducción de la Variable del PJEditor fecha y hora de la audiencia para LibreOffice>
-- Parametros:		@NumeroExpediente: Numero para el que se quiere buscar la audiencia
--					@Contexto: Codigo del contexto al que pertenece el expediente
--					@Salida: Forma de listar la fecha
--							1- Fecha
--							2- Hora
-- ====================================================================================================================================================================================
-- Modificación:	<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaHoraAudiencia]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Salida					AS INTEGER
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto,
@L_Salida				AS INTEGER		= @Salida;


	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		CASE
						WHEN @L_Salida=1 THEN CONVERT(VARCHAR(20), A.TF_FechaCrea, 103)
						WHEN @L_Salida=2 THEN CONVERT(VARCHAR(20), A.TF_FechaCrea, 108)
					END AS FechaAudiencia
		FROM		Expediente.Audiencia				A WITH(NOLOCK)  
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK)
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContextoCrea				= @L_Contexto
		AND			A.TF_FechaCrea						= (
															SELECT	MAX(D.TF_FechaCrea)
															FROM	Expediente.Audiencia	D WITH(NOLOCK)
															WHERE	A.TC_NumeroExpediente	= TC_NumeroExpediente
															AND		A.TC_CodContextoCrea	= TC_CodContexto
															AND		D.TN_CodAudiencia		NOT IN (SELECT	E.TN_CodAudiencia
																									FROM	Expediente.AudienciaLegajo E WITH(NOLOCK)
																									WHERE	E.TN_CodAudiencia = A.TN_CodAudiencia)
														   )
	END
	ELSE
	BEGIN
		SELECT		CASE
						WHEN @L_Salida=1 THEN CONVERT(VARCHAR(20), A.TF_FechaCrea, 103)
						WHEN @L_Salida=2 THEN CONVERT(VARCHAR(20), A.TF_FechaCrea, 108)
					END AS FechaAudiencia
		FROM		Expediente.Audiencia				A WITH(NOLOCK)  
		INNER JOIN	Expediente.AudienciaLegajo			B WITH(NOLOCK)
		ON			A.TN_CodAudiencia					= B.TN_CodAudiencia
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK)
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContextoCrea				= @L_Contexto
		AND			A.TF_FechaCrea						= (
															SELECT		MAX(D.TF_FechaCrea)
															FROM		Expediente.Audiencia		D WITH(NOLOCK)
															INNER JOIN	Expediente.AudienciaLegajo	E WITH(NOLOCK)
															ON			D.TN_CodAudiencia			= E.TN_CodAudiencia
															WHERE		A.TC_NumeroExpediente		= TC_NumeroExpediente
															AND			A.TC_CodContextoCrea		= TC_CodContexto
															AND			B.TU_CodLegajo				= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
														  )
	END
END
GO
