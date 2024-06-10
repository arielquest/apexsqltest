SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<25-08-2020>
-- Description:					<Traducción de la Variable del PJEditor por tanto de la resolución para LibreOffice>
-- ====================================================================================================================================================================================
-- Modidicación:				<18/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_PorTantoResolucion]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN

	DECLARE		@L_NumeroExpediente		AS CHAR(14)		= @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto				AS VARCHAR(4)	= @Contexto 

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		A.TC_PorTanto
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.ExpedienteDetalle		B WITH(NOLOCK)
		ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente 
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT	MAX(TF_FechaResolucion)
															FROM	Expediente.Resolucion	C WITH(NOLOCK)
															WHERE	A.TC_NumeroExpediente	= C.TC_NumeroExpediente
															AND		A.TC_CodContexto		= C.TC_CodContexto
															AND		A.TU_CodArchivo			NOT IN (SELECT	TU_CodArchivo 
																									FROM	Expediente.LegajoArchivo WITH(NOLOCK)
																									WHERE	TU_CodArchivo	= C.TU_CodArchivo)
														   )
	END
	ELSE
	BEGIN
		SELECT		A.TC_PorTanto
		FROM		Expediente.Resolucion				A WITH(NOLOCK)
		INNER JOIN	Expediente.Legajo					B WITH(NOLOCK)
		ON			B.TC_NumeroExpediente				= A.TC_NumeroExpediente
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK)
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT		MAX(TF_FechaResolucion)
															FROM		Expediente.Resolucion	D WITH(NOLOCK)
															INNER JOIN	Expediente.LegajoArchivo E WITH(NOLOCK)
															ON			D.TU_CodArchivo			= E.TU_CodArchivo
															WHERE		E.TU_CodLegajo			= C.TU_CodLegajo	
															AND			D.TC_CodContexto		= C.TC_CodContexto
														   )
	END
END
GO
