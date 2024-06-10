SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<26/06/2020>
-- Description:					<Traducción de la Variable del PJEditor A_TasaInteres para LibreOffice>
-- Nota: Como parametro se debe pasar en @Fecha: I = Fecha inicio, F = Fecha Fin. En @TipoInteres: C = Interes Corriente, M = Interes Moratorio
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechasInteresesCalculoInteres]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Fecha					As Char(1),
	@TipoInteres			As Char(1),
	@Moneda					As SmallInt
AS
BEGIN
	Declare		@L_NumeroExpediente		Char(14)	= @NumeroExpediente
	Declare		@L_Contexto				VARCHAR(4)	= @Contexto;
	Declare		@L_Fecha				Char(1)		= @Fecha;
	Declare		@L_TipoInteres			Char(1)		= @TipoInteres;
	Declare		@L_Moneda				SmallInt	=	@Moneda;
	
	SELECT		CASE 
					WHEN @L_Fecha='I' THEN C.TF_FechaInicio
					WHEN @L_Fecha='F' THEN C.TF_FechaFinal
				END As Fecha
	FROM		Expediente.Deuda					A With(NoLock)
	INNER JOIN	Catalogo.Moneda						E With(NoLock)
	ON			A.TN_CodMoneda						= E.TN_CodMoneda
	And			E.TN_CodMoneda						= @L_Moneda
	INNER JOIN	Expediente.ExpedienteDetalle		B With(NoLock) 
	ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
	INNER JOIN	Expediente.CalculoInteres			C With(NoLock)
	ON			A.TU_CodigoDeuda					= C.TU_CodigoDeuda
	AND			C.TF_FechaCalculo					=	(
														Select	MAX(D.TF_FechaCalculo)
														From	Expediente.CalculoInteres	D With(NoLock)
														Where	D.TU_CodigoDeuda			= A.TU_CodigoDeuda
														)
	AND			C.TC_TipoInteres					= @L_TipoInteres
	AND			B.TC_NumeroExpediente				= @L_NumeroExpediente
	AND			B.TC_CodContexto					= @L_Contexto
END
GO
