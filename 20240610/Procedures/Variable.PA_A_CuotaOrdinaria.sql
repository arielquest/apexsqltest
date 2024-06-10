SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jose Miguel Avendaño Rosales>
-- Create date:					<10/06/2021>
-- Description:					<Traducción de la Variable A_CuotaOrdinaria >
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_CuotaOrdinaria]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4) 
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto;

	SELECT		A.TN_MontoMensual				As MontoMensual
	FROM		Expediente.Expediente			A With(NoLock)
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
	AND			A.TC_CodContexto				= @L_Contexto
END
GO
