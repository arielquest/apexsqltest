SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.2>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<25/02/2019>
-- Descripción :			<Permite agregar los datos de un Cálculo de Interés> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<14/05/2019>
-- Modificación				<Eliminados campos de indexación>
-- Descripción :			<Permite agregar campos: CostasPersonales, FechaTipoCambio> 
-- Fecha de modificación	<27/06/2019>
-- Modificación				<Agregado nuevo campo @MontoLiquidado>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarCalculoInteres]
	@Codigo							uniqueidentifier,
	@FechaInicio					datetime2,
	@FechaFinal						datetime2,
	@TipoInteres					char(1),
	@EstadoCalculo					char(1),
	@FechaResolucion				datetime2 = null,	
	@CodFormatoJuridico				varchar(8),
	@CodResolucion					uniqueidentifier = null,
	@CodigoDeuda					uniqueidentifier,
	@FechaCalculo					datetime2,
	@UsuarioRed						varchar(30),
	@CodContexto					varchar(4),
	@CalculoLiquidado				bit,
	@EnFirme						bit,
	@MontoCostasPersonales			decimal(18,2),
	@SaldoCostasPersonales			decimal(18,2),
	@MontoCostasProcesales			decimal(18,2),
	@SaldoCostasProcesales			decimal(18,2),
	@DescripcionCostasProcesales	varchar(255) = null,
	@MontoLiquidado					decimal(18,2),
	@SaldoMontoLiquidado			decimal(18,2),
	@TipoCambioUsado				char(1) = null,
	@MontoCambio					decimal(6,2) = null,
	@MontoTotal						decimal(18,2),
	@CostasPersonales				bit,
	@FechaTipoCambio				datetime2	= null
As
Begin
	
	Insert Into Expediente.CalculoInteres(	TU_CodigoCalculoInteres,		TF_FechaInicio,				TF_FechaFinal,				TC_TipoInteres,				TC_EstadoCalculo,			TF_FechaResolucion,
											TC_CodFormatoJuridico,			TU_CodResolucion,			TU_CodigoDeuda,				TF_FechaCalculo,			TC_UsuarioRed,				TC_CodContexto,
											TB_CalculoLiquidado,			TN_MontoCostasPersonales,	TN_SaldoCostasPersonales,	TN_MontoCostasProcesales,	TN_SaldoCostasProcesales,   TC_DescripcionCostasProcesales,	
											TN_MontoLiquidado,				TN_SaldoMontoLiquidado,		TC_TipoCambioUsado,			TN_MontoCambio,				TN_MontoTotal,				TB_EnFirme,					
											TB_CostasPersonales,			TF_FechaTipoCambio
										) 	
	Values						(			@Codigo,						@FechaInicio,			@FechaFinal,				@TipoInteres,				@EstadoCalculo,				@FechaResolucion,			
											@CodFormatoJuridico,			@CodResolucion,			@CodigoDeuda,				@FechaCalculo,				@UsuarioRed,				@CodContexto,				
											@CalculoLiquidado,				@MontoCostasPersonales,	@SaldoCostasPersonales,		@MontoCostasProcesales,		@SaldoCostasProcesales,		@DescripcionCostasProcesales,	
											@MontoLiquidado,				@SaldoMontoLiquidado,	@TipoCambioUsado,			@MontoCambio,				@MontoTotal,			    @EnFirme,					
											@CostasPersonales,				@FechaTipoCambio
								)		

End

GO
