SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<26/06/2020>
-- Description:					<Traducción de la Variable del PJEditor A_InteresCorriente para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_InteresCorrienteCalculoInteres]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Moneda					As SmallInt
AS
BEGIN
	Declare		@L_NumeroExpediente		Char(14)	=	@NumeroExpediente
	Declare		@L_Contexto				VARCHAR(4)	=	@Contexto;
	Declare		@L_Moneda				SmallInt	=	@Moneda;
	
	SELECT		Top(1)  A.TN_InteresCorriente				As Interes
	FROM		Expediente.Deuda					A With(NoLock)
	INNER JOIN	Catalogo.Moneda						C With(NoLock)
	ON			A.TN_CodMoneda						= C.TN_CodMoneda
	And			C.TN_CodMoneda						= @L_Moneda
	INNER JOIN	Expediente.ExpedienteDetalle		B With(NoLock) 
	ON			B.TC_NumeroExpediente				= B.TC_NumeroExpediente  
	AND			B.TC_NumeroExpediente				= @L_NumeroExpediente
	AND			B.TC_CodContexto					= @L_Contexto
	Order By	A.TF_FechaCreacion					Desc
END
GO
