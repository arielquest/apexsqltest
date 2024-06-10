SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<12-05-2020>
-- Description:					<Traducción de la Variable del PJEditor A_ClaseAsunto para LibreOffice>
-- ====================================================================================================================================================================================
-- MODIFICACIÓN:				<AIDA ELENA SILES R> <20/01/2022> <SE AGREGA LÓGICA PARA MOSTRAR LA CLASE DE ASUNTO DEL LEGAJO.>
-- ====================================================================================================================================================================================
CREATE   PROCEDURE [Variable].[PA_A_ClaseExpediente]
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
		SELECT		B.TC_Descripcion				AS Clase
		FROM		Expediente.ExpedienteDetalle	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Clase					B WITH(NOLOCK) 
		ON			A.TN_CodClase					= B.TN_CodClase  
		WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			A.TC_CodContexto				= @L_Contexto
	END
	ELSE
	BEGIN
		SELECT		B.TC_Descripcion				AS Clase
		FROM		Expediente.LegajoDetalle		A WITH(NOLOCK)
		INNER JOIN	Catalogo.ClaseAsunto			B WITH(NOLOCK) 
		ON			A.TN_CodClaseAsunto				= B.TN_CodClaseAsunto
		WHERE		A.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			A.TC_CodContexto				= @L_Contexto
	END 
END
GO
