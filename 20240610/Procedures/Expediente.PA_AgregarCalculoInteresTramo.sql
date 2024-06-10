SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<25/02/2019>
-- Descripción :			<Permite agregar tramo de cálculo de interés> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarCalculoInteresTramo]
	@Codigo					uniqueidentifier,	
	@FechaInicio			datetime2,
	@FechaFinal				datetime2,
	@CodigoCalculoInteres	uniqueidentifier,
	@CodigoTasaInteres		uniqueidentifier = null,
	@ValorTasaInteres		decimal(8,5) = null,
	@MontoLiquidado			decimal(18,2)
As
Begin
	
	Insert Into Expediente.CalculoInteresTramo(	TU_CodigoTramoInteres,	TF_FechaInicio,			TF_FechaFinal,	TU_CodigoCalculoInteres,
												TN_CodigoTasaInteres,	TN_ValorTasaInteres,	TN_MontoLiquidado) 	
	Values									  (	@Codigo,				@FechaInicio,			@FechaFinal,	@CodigoCalculoInteres,
												@CodigoTasaInteres,		@ValorTasaInteres,		@MontoLiquidado)		
End
GO
