SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<26/06/2020>
-- Description:					<Traducción de la Variable del PJEditor A_TasaInteres para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_TasaInteresCalculoInteres]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Moneda					As SmallInt
AS
BEGIN
	Declare		@L_NumeroExpediente		Char(14)	=	@NumeroExpediente
	Declare		@L_Contexto				VARCHAR(4)	=	@Contexto;
	Declare		@L_Moneda				SmallInt	=	@Moneda;
	
	SELECT		E.TN_ValorTasaInteres				As TasaInteres
	FROM		Expediente.Deuda					A With(NoLock)
	INNER JOIN	Catalogo.Moneda						G With(NoLock)
	ON			A.TN_CodMoneda						= G.TN_CodMoneda
	And			G.TN_CodMoneda						= @L_Moneda
	INNER JOIN	Expediente.ExpedienteDetalle		B With(NoLock) 
	ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
	INNER JOIN	Expediente.CalculoInteres			C With(NoLock)
	ON			A.TU_CodigoDeuda					= C.TU_CodigoDeuda
	AND			C.TF_FechaCalculo					=	(
														Select	MAX(D.TF_FechaCalculo)
														From	Expediente.CalculoInteres	D With(NoLock)
														Where	D.TU_CodigoDeuda	= A.TU_CodigoDeuda
														)
	INNER JOIN	Expediente.CalculoInteresTramo		E With(NoLock)
	ON			E.TU_CodigoCalculoInteres			= C.TU_CodigoCalculoInteres
	AND			E.TF_FechaInicio					=	(
														Select	MAX(F.TF_FechaInicio)
														From	Expediente.CalculoInteresTramo	F With(NoLock)
														Where	F.TU_CodigoCalculoInteres	= C.TU_CodigoCalculoInteres
														) 
	AND			B.TC_NumeroExpediente				= @L_NumeroExpediente
	AND			B.TC_CodContexto					= @L_Contexto
END
GO
