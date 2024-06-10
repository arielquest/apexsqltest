SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<26/06/2020>
-- Description:					<Traducción de la Variable del PJEditor A_Capital+IntCorMor para LibreOffice>
-- Parametros:		@NumeroExpediente: Numero para el que se quiere buscar la audiencia
--					@Contexto: Codigo del contexto al que pertenece el expediente
--					@Salida: Forma de retornar el monto
--							1- Monto total
--							2- Monto total + 50%
--							3- 50% del monto total
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_MontoTotalCalculoInteres]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Moneda					As SmallInt,
	@Salida					As Integer
AS
BEGIN
	Declare		@L_NumeroExpediente		Char(14)	= @NumeroExpediente
	Declare		@L_Contexto				VARCHAR(4)	= @Contexto;
	Declare		@L_Moneda				SmallInt	= @Moneda;
	Declare		@L_Salida				Integer		= @Salida;
		
	SELECT		CASE
					When @L_Salida = 1 THEN C.TN_MontoTotal
					When @L_Salida = 2 THEN C.TN_MontoTotal * 1.5
					When @L_Salida = 3 THEN C.TN_MontoTotal * 0.5
				END As Total
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
														Where	D.TU_CodigoDeuda	= A.TU_CodigoDeuda
														)
	AND			B.TC_NumeroExpediente				= @L_NumeroExpediente
	AND			B.TC_CodContexto					= @L_Contexto
END
GO
