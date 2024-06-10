SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<22/02/2019>
-- Descripción :			<Permite agregar los datos de una deuda> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<25/06/2019>
-- Modificación				<Agregado campo @CostasPersonalesCapital>
-- Modificación				<11/03/2021><Jonathan Aguilar Navarro><Se agregar el monto de sobre giro>
-- Modificación:			<18/03/2021><Jonathan Aguilar Navarro><Se agregan los campos correspondiente a sobre giro>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarDeuda]
	@Codigo								uniqueidentifier,	
	@Descripcion						varchar(255),	
	@FechaCreacion						datetime2,
	@ProcesoEstado						char(1),
	@TipoObligacion						char(1),
	@MontoDeuda							decimal(18,2),
	@MontoLPT							decimal(18,2)	= null,
	@MontoObrero						decimal(18,2)	= null,
	@MontoPatronal						decimal(18,2)	= null,
	@MontoTrabajadorInd					decimal(18,2)	= null,
	@ImpuestoRenta						decimal(18,2)	= null,
	@ImpuestoVenta						decimal(18,2)	= null,
	@Timbres							decimal(18,2)	= null,
	@Sanciones							decimal(18,2)	= null,
	@SaldoDeuda							decimal(18,2)	= null,
	@CodMoneda							smallint		= null,
	@CodigoBanco						char(4)			= null,
	@TipoTasaInteres					char(1)			,
	@Periodicidad						char(1)			= null,	
	@TipoInteres						char(1)			,
	@InteresCorriente					decimal(4,2)	= null,
	@InteresMoratorio					decimal(4,2)	= null,
	@NumeroExpediente					char(14)		,
	@CodigoDecreto						varchar(15)		= null,
	@CostasPersonalesCapital			bit = 0			,
	@MontoSobreGiro						decimal(18,2)	= null,
	@InteresSobreGiro					decimal(18,2)	= null,
	@FechaInicioSobreGiro				datetime2(7)	= null,
	@FechaFinalSobreGiro				datetime2(7)	= null,
	@MontoInteresSobreGiro				decimal(18,2)	= null,
	@TasaInteresPosterior				decimal(18,2)	= null,
	@FechaInteresPosterior				datetime2(7)	= null,
	@TasaInteresPosteriorSobreGiro		decimal(18,2)	= null,
	@FechaInteresPosteriorSobreGiro		datetime2(7)	= null
As
Begin
	declare

	@L_Codigo							uniqueidentifier			= @Codigo,				
	@L_Descripcion						varchar(255)				= @Descripcion,		
	@L_FechaCreacion					datetime2					= @FechaCreacion,			
	@L_ProcesoEstado					char(1)						= @ProcesoEstado,			
	@L_TipoObligacion					char(1)						= @TipoObligacion,			
	@L_MontoDeuda						decimal(18,2)				= @MontoDeuda,				
	@L_MontoLPT							decimal(18,2)				= @MontoLPT,				
	@L_MontoObrero						decimal(18,2)				= @MontoObrero,			
	@L_MontoPatronal					decimal(18,2)				= @MontoPatronal,			
	@L_MontoTrabajadorInd				decimal(18,2)				= @MontoTrabajadorInd,		
	@L_ImpuestoRenta					decimal(18,2)				= @ImpuestoRenta,			
	@L_ImpuestoVenta					decimal(18,2)				= @ImpuestoVenta,			
	@L_Timbres							decimal(18,2)				= @Timbres,				
	@L_Sanciones						decimal(18,2)				= @Sanciones,				
	@L_SaldoDeuda						decimal(18,2)				= @SaldoDeuda,				
	@L_CodMoneda						smallint					= @CodMoneda,				
	@L_CodigoBanco						char(4)						= @CodigoBanco,			
	@L_TipoTasaInteres					char(1)						= @TipoTasaInteres,		
	@L_Periodicidad						char(1)						= @Periodicidad,				
	@L_TipoInteres						char(1)						= @TipoInteres,			
	@L_InteresCorriente					decimal(4,2)				= @InteresCorriente,		
	@L_InteresMoratorio					decimal(4,2)				= @InteresMoratorio,		
	@L_NumeroExpediente					char(14)					= @NumeroExpediente,	
	@L_CodigoDecreto					varchar(15)					= @CodigoDecreto,			
	@L_CostasPersonalesCapital			bit 						= @CostasPersonalesCapital,
	@L_MontoSobreGiro					decimal(18,2)				= @MontoSobreGiro,	
	@L_InteresSobreGiro					decimal(18,2)				= @InteresSobreGiro	,			
	@L_FechaInicioSobreGiro				datetime2(7)				= @FechaInicioSobreGiro	,		
	@L_FechaFinalSobreGiro				datetime2(7)				= @FechaFinalSobreGiro,			
	@L_MontoInteresSobreGiro			decimal(18,2)				= @MontoInteresSobreGiro,			
	@L_TasaInteresPosterior				decimal(18,2)				= @TasaInteresPosterior	,		
	@L_FechaInteresPosterior			datetime2(7)				= @FechaInteresPosterior,			
	@L_TasaInteresPosteriorSobreGiro	decimal(18,2)				= @TasaInteresPosteriorSobreGiro,	
	@L_FechaInteresPosteriorSobreGiro	datetime2(7)				= @FechaInteresPosteriorSobreGiro

	Insert Into Expediente.Deuda(	TU_CodigoDeuda,						TC_Descripcion,						TF_FechaCreacion,		TC_ProcesoEstado,
									TC_TipoObligacion,					TN_MontoDeuda,						TN_MontoLPT,			TN_MontoObrero,
									TN_MontoPatronal,					TN_MontoTrabajadorInd,				TN_ImpuestoRenta,		TN_ImpuestoVenta,
									TN_Timbres,							TN_Sanciones,						TN_SaldoDeuda,			TN_CodMoneda,
									TC_CodigoBanco,						TC_TipoTasaInteres,					TC_Periodicidad,		TC_TipoInteres,
									TN_InteresCorriente,				TN_InteresMoratorio,				TC_NumeroExpediente,	TC_CodigoDecreto,
									TB_CostasPersonalesCapital,			TN_MontoSobreGiro,					TN_InteresSobreGiro,	TF_FechaInicioSobreGiro,
									TF_FechaFinalSobreGiro,				TN_MontoInteresSobreGiro,			TN_TasaInteresPosterior,TF_FechaInteresPosterior,
									TN_TasaInteresPosteriorSobreGiro,	TF_FechaInteresPosteriorSobreGiro
								) 	
	Values						(	@L_Codigo,							@L_Descripcion,						@L_FechaCreacion,		@L_ProcesoEstado,		
									@L_TipoObligacion,					@L_MontoDeuda,						@L_MontoLPT,			@L_MontoObrero,		
									@L_MontoPatronal,					@L_MontoTrabajadorInd,				@L_ImpuestoRenta,		@L_ImpuestoVenta,		
									@L_Timbres,							@L_Sanciones,						@L_SaldoDeuda,			@L_CodMoneda,			
									@L_CodigoBanco,						@L_TipoTasaInteres,					@L_Periodicidad,		@L_TipoInteres,		
									@L_InteresCorriente,				@L_InteresMoratorio,				@L_NumeroExpediente,	@L_CodigoDecreto,
									@L_CostasPersonalesCapital,			@L_MontoSobreGiro,					@L_InteresSobreGiro,	@L_FechaInicioSobreGiro,
									@L_FechaFinalSobreGiro,				@L_MontoInteresSobreGiro,			@L_TasaInteresPosterior,@L_FechaInteresPosterior,
									@L_TasaInteresPosteriorSobreGiro,	@L_FechaInteresPosteriorSobreGiro
								)		
End
GO
