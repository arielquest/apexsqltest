SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<12/02/2019>
-- Descripción :			<Permite consultar los datos básicos de los tramos de cálculos de interés> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarCalculoInteresTramo]
	@CodigoCalculoInteres				uniqueidentifier
As
Begin
	Select			A.TU_CodigoTramoInteres				As	Codigo,
					A.TN_MontoLiquidado					As	MontoLiquidado,
					A.TF_FechaInicio					As	FechaInicio,
					A.TF_FechaFinal						As	FechaFinal,
					A.TN_ValorTasaInteres				As	ValorTasaInteres,
					'Split'								As	SplitTasaInteres,
					A.TN_CodigoTasaInteres				As	Codigo,
					B.TN_Valor							As	Valor,
					'Split'								As	SplitCalculoInteres,
					A.TU_CodigoCalculoInteres			As	Codigo
	From			Expediente.CalculoInteresTramo		As	A	With(Nolock)
	Left Outer Join	Catalogo.TasaInteres				As	B	With(Nolock)
	On				B.TN_CodigoTasaInteres				=	A.TN_CodigoTasaInteres		 	
	Where			A.TU_CodigoCalculoInteres			=	@CodigoCalculoInteres
	Order by		A.TF_FechaInicio	Asc
 End
GO
