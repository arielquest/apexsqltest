SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<13-05-2020>
-- Description:					<Traducción de la Variable del PJEditor Hora y fecha de la resolución para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <17/01/2022> <Se agrega lógica para legajos>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaEmision]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN
	DECLARE 	@L_NumeroExpediente		AS CHAR(14)		=	@NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		=	@CodLegajo,
				@L_Contexto				AS VARCHAR(4)	=	@Contexto

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		MAX(A.TF_FechaResolucion)
		FROM		Expediente.Resolucion				A WITH(NOLOCK) 
		INNER JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= F.TC_NumeroExpediente 
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
	END
	ELSE
	BEGIN
		SELECT		MAX(A.TF_FechaResolucion)
		FROM		Expediente.Resolucion				A WITH(NOLOCK) 
		INNER JOIN	Expediente.Legajo					B WITH(NOLOCK) 
		ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
		INNER JOIN	Expediente.LegajoDetalle			C WITH(NOLOCK)
		ON			C.TU_CodLegajo						= B.TU_CodLegajo
		WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND			A.TC_CodContexto					= @L_Contexto
		AND			C.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
	END
END
GO
