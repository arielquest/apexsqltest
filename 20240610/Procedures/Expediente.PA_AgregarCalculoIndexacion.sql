SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<07/01/2019>
-- Descripción :			<Permite agregar cálculo de indexación> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<21/05/2019>
-- Modificación				<Eliminar y agregar campos de indexación>
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<12/07/2019>
-- Modificación				<Agregado campo de CodigoDeuda, opcional, por si se está generando asociado a la Deuda>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarCalculoIndexacion]
	@Codigo						uniqueidentifier,	
	@Descripcion				varchar(150),
	@NumeroExpediente			char(14),
	@CodContexto				varchar(4),
	@FechaCalculo				datetime2,
	@UsuarioRed					varchar(30),
	@MontoIndexacion			decimal(18,2),
	@TipoMonto					char(1),
	@TipoPago					smallint,
	@MontoTotalIndexado			decimal(18,2),
	@Indicador					char(2),
	@CodMoneda					smallint,
	@CodigoDeuda				uniqueidentifier	=	Null
As
Begin
	
	Insert Into Expediente.CalculoIndexacion		(	TU_CodigoCalculoIndexacion,	TC_Descripcion,			TC_NumeroExpediente,	TC_CodContexto,
														TF_FechaCalculo,			TC_UsuarioRed,			TN_MontoIndexacion,		TC_TipoMonto,				
														TN_TipoPago,				TN_MontoTotalIndexado,	TC_Indicador,			TN_CodMoneda,
														TU_CodigoDeuda
													) 	
	Values											(	@Codigo,					@Descripcion,			@NumeroExpediente,		@CodContexto,		
														@FechaCalculo,				@UsuarioRed,			@MontoIndexacion,		@TipoMonto,					
														@TipoPago,					@MontoTotalIndexado,	@Indicador,				@CodMoneda,
														@CodigoDeuda
													)
End
GO
