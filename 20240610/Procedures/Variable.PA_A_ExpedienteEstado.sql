SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño R>
-- Create date:					<09/06/2020>
-- Description:					<Traducción de las Variable del PJEditor Create PROCEDURE [Variable].[PA_A_ExpedienteEstado]
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <20/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_ExpedienteEstado]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     	= @NumeroExpediente,
@L_CodLegajo			VARCHAR(40)			= @CodLegajo;

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		B.TC_Descripcion							As Estado
		FROM		Historico.ExpedienteMovimientoCirculante	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Estado								B WITH(NOLOCK)
		ON			A.TN_CodEstado								= B.TN_CodEstado
		WHERE		A.TC_NumeroExpediente						= @L_NumeroExpediente
		ORDER BY	A.TF_Fecha	DESC
	END
	ELSE
	BEGIN
		SELECT		B.TC_Descripcion							As Estado
		FROM		Historico.LegajoMovimientoCirculante		A WITH(NOLOCK)
		INNER JOIN	Catalogo.Estado								B WITH(NOLOCK)
		ON			A.TN_CodEstado								= B.TN_CodEstado
		WHERE		A.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		ORDER BY	A.TF_Fecha	DESC
	END

END
GO
