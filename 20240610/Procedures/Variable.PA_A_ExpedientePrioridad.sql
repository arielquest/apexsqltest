SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño R>
-- Create date:					<09/06/2020>
-- Description:					<Traducción de las Variable del PJEditor A_ExpedientePrioridad
-- Nota: indicar cual es el codigo de prioridad para REO PRESO
-- ====================================================================================================================================================================================
-- Modificación:				<20/01/2022> <Aida Elena Siles R> <Se agrega lógica para mostrar la prioridad del legajo.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_ExpedientePrioridad]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4) 
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
@L_Contexto             AS VARCHAR(4)   = @Contexto;

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		A.TN_CodPrioridad				AS Prioridad
		FROM		Expediente.Expediente			A WITH(NOLOCK)
		WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			A.TC_CodContexto				= @L_Contexto
		AND			A.TN_CodPrioridad				= 1
END
	ELSE
	BEGIN
		SELECT		A.TN_CodPrioridad				AS Prioridad
		FROM		Expediente.Legajo				A WITH(NOLOCK)
		WHERE		A.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto				= @L_Contexto
		AND			A.TN_CodPrioridad				= 1
	END	
END


GO
