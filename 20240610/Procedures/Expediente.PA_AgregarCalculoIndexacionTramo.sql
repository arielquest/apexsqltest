SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<07/01/2019>
-- Descripción :			<Permite agregar de tramos de cálculos de indexación> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<21/05/2019>
-- Modificación				<Se cambian los nombres de las columnas IPCInicial e IPCFinal, para que coincidan con las de las BD>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarCalculoIndexacionTramo]
	@Codigo						uniqueidentifier,
	@CodigoCalculoIndexacion	uniqueidentifier,
	@FechaInicio				datetime2,
	@FechaFinal					datetime2,
	@IPCInicial					decimal(18,15),
	@IPCFinal					decimal(18,15),
	@MontoAIndexar				decimal(18,2),
	@MontoIndexado				decimal(18,2),
	@MontoTotalIndexado			decimal(18,2),
	@MontoAguinaldoIndexado		decimal(18,2)
As
Begin
	
	Insert Into Expediente.CalculoIndexacionTramo	(	TU_CodigoTramoIndexacion,	TU_CodigoCalculoIndexacion,	TF_FechaInicio,		TF_FechaFinal,
														TN_IndicadorInicial,		TN_IndicadorFinal,			TN_MontoAIndexar,	TN_MontoIndexado,	
														TN_MontoTotalIndexado,		TN_MontoAguinaldoIndexado) 	
	Values											(	@Codigo,					@CodigoCalculoIndexacion,	@FechaInicio,		@FechaFinal,				
														@IPCInicial,				@IPCFinal,					@MontoAIndexar,		@MontoIndexado,
														@MontoTotalIndexado,		@MontoAguinaldoIndexado)
End
GO
