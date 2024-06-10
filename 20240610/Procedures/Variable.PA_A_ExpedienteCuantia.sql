SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<03/06/2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas para obtener la cuantía de la Carpeta para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_ExpedienteCuantia]
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4)
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto;

		
	SELECT		TN_MONTOCUANTIA 			AS CUANTIA
	FROM		EXPEDIENTE.EXPEDIENTE		E WITH(NOLOCK)
	LEFT JOIN	CATALOGO.TIPOCUANTIA		C WITH(NOLOCK) 
	ON 			E.TN_CODTIPOCUANTIA			= C.TN_CODTIPOCUANTIA
	LEFT JOIN	CATALOGO.MONEDA				M WITH(NOLOCK) 
	ON 			E.TN_CODMONEDA				= M.TN_CODMONEDA
	WHERE		E.TC_NumeroExpediente		= @L_NumeroExpediente
	AND			E.TC_CodContexto			= @L_Contexto

END
GO
