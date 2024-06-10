SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<23-10-2020>
-- Description:					<Traducción de la Variable del PJEditor A_TestimonioPiezas para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_TestimonioPiezas]
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4) 
AS
BEGIN
	SELECT		'Testimonio de Piezas'			As TestimonioPiezas
	FROM		Expediente.ExpedienteDetalle	A With(NoLock)
	WHERE		A.TC_NumeroExpediente			= @NumeroExpediente
	AND			A.TC_CodContexto				= @Contexto
	AND			A.TC_TestimonioPiezas			Is Not Null
END
GO
