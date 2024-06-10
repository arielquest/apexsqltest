SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<29/03/2019>
-- Descripción :			<Permite modificar los datos de un Cálculo de Interés> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<14/05/2019>
-- Modificación				<Eliminados campos de indexación>
-- Fecha de modificación	<27/06/2019>
-- Modificación				<Agregado nuevo campo @MontoLiquidado>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarCalculoInteres]
	@Codigo							uniqueidentifier,
	@CodigoDeuda					uniqueidentifier,
	@FechaInicio					datetime2,
	@FechaFinal						datetime2,
	@CodFormatoJuridico				varchar(8),
	@TipoInteres					char(1),
	@MontoCostasPersonales			decimal(18,2),
	@SaldoCostasPersonales			decimal(18,2),
	@MontoCostasProcesales			decimal(18,2),
	@SaldoCostasProcesales			decimal(18,2),
	@DescripcionCostasProcesales	varchar(255)		= null,
	@CostasPersonales				bit,
	@MontoTotal						decimal(18,2),
	@MontoLiquidado					decimal(18,2),
	@SaldoMontoLiquidado			decimal(18,2),
	@TipoCambioUsado				char(1)				= null,
	@MontoCambio					decimal(6,2)		= null,		
	@FechaTipoCambio				datetime2			= null
As
Begin
	
	Update	Expediente.CalculoInteres 
	Set		TF_FechaInicio					=	@FechaInicio,
			TF_FechaFinal					=	@FechaFinal,
			TC_TipoInteres					=	@TipoInteres,
			TC_CodFormatoJuridico			=	@CodFormatoJuridico,
			TB_CostasPersonales				=	@CostasPersonales,
			TN_MontoCostasPersonales		=	@MontoCostasPersonales,
			TN_SaldoCostasPersonales		=	@SaldoCostasPersonales,
			TN_MontoCostasProcesales		=	@MontoCostasProcesales,
			TN_SaldoCostasProcesales		=	@SaldoCostasProcesales,
			TC_DescripcionCostasProcesales	=	@DescripcionCostasProcesales,
			TN_MontoLiquidado				=	@MontoLiquidado,
			TN_SaldoMontoLiquidado			=	@SaldoMontoLiquidado,
			TC_TipoCambioUsado				=	@TipoCambioUsado,
			TN_MontoCambio					=	@MontoCambio,
			TF_FechaTipoCambio				=	@FechaTipoCambio,
			TN_MontoTotal					=	@MontoTotal
	Where	TU_CodigoCalculoInteres			=	@Codigo	
	And		TU_CodigoDeuda					=	@CodigoDeuda

End
GO
