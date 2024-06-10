SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<22-10-2020>
-- Description:					<Traducción de la Variable del PJEditor A_FechaEntradaIndidente para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaEntradaIncidente]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@CodLegajo				As uniqueidentifier
AS
BEGIN
	SELECT		A.TF_Inicio						As FechaEntrada
	FROM		Expediente.Legajo				A With(NoLock)
	Left Join	Expediente.LegajoDetalle		B With(NoLock)
	On			A.TU_CodLegajo					= B.TU_CodLegajo
	WHERE		A.TC_NumeroExpediente			= @NumeroExpediente
	AND			B.TC_CodContexto				= @Contexto
	And			B.TN_CodAsunto					= 2
	And			B.TU_CodLegajo					= @CodLegajo
END
GO
