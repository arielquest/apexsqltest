SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<09-09-2020>
-- Description:					<Traducción de la Variable del PJEditor numero de la resolución para LibreOffice>
-- ====================================================================================================================================================================================
-- Modidicación:				<18/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_NumeroResolucion]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN
DECLARE			@L_NumeroExpediente		AS CHAR(14)		= @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto				AS VARCHAR(4)	= @Contexto 

	
	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		B.TC_NumeroResolucion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)  
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		INNER JOIN	Expediente.LibroSentencia			B WITH(NOLOCK)
		ON			A.TU_CodResolucion					= B.TU_CodResolucion
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT	MAX(E.TF_FechaResolucion)
															FROM	Expediente.Resolucion	E WITH(NOLOCK)
															WHERE	A.TC_NumeroExpediente	= E.TC_NumeroExpediente
															AND		A.TC_CodContexto		= E.TC_CodContexto
															AND		E.TU_CodArchivo			NOT IN (SELECT	TU_CodArchivo 
																									FROM	Expediente.LegajoArchivo WITH(NOLOCK)
																									WHERE	TU_CodArchivo = E.TU_CodArchivo)
														  )
	END
	ELSE
	BEGIN
		SELECT		D.TC_NumeroResolucion
		FROM		Expediente.Resolucion				A WITH(NOLOCK)  
		INNER JOIN	Expediente.Legajo					B WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente				= A.TC_NumeroExpediente
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK)
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		INNER JOIN	Expediente.LibroSentencia			D WITH(NOLOCK)
		ON			D.TU_CodResolucion					= A.TU_CodResolucion
		WHERE		C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto					= @L_Contexto
		AND			A.TF_FechaResolucion				= (
															SELECT		MAX(E.TF_FechaResolucion)
															FROM		Expediente.Resolucion 	E WITH(NOLOCK)
															INNER JOIN	Expediente.LegajoArchivo F WITH(NOLOCK)
															ON			F.TU_CodArchivo			= E.TU_CodArchivo
															WHERE		C.TU_CodLegajo			= F.TU_CodLegajo
															AND			A.TC_CodContexto		= E.TC_CodContexto
														  )
	END
END
GO
