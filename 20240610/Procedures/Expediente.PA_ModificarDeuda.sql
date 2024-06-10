SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<01/04/2019>
-- Descripción :			<Permite modificar los datos de una deuda> 
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<25/06/2019>
-- Modificación				<Agregado campo @CostasPersonalesCapital>
-- =================================================================================================================================================
-- Modificación:			<11/03/2021><Jonathan Aguilar Navarro><Se agrega el campo TN_MontoSobreGiro>
-- Modificación:			<18/03/2021><Jonathan Aguilar Navarro><Se agrega el campo correspondiente a sobregiros>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarDeuda]
		@Codigo								uniqueidentifier,	
		@Descripcion						varchar(255)	,	
		@ProcesoEstado						char(1)			,
		@TipoObligacion						char(1)			,
		@MontoDeuda							decimal(18,2)	,
		@MontoLPT							decimal(18,2)	= null,
		@MontoObrero						decimal(18,2)	= null,
		@MontoPatronal						decimal(18,2)	= null,
		@MontoTrabajadorInd					decimal(18,2)	= null,
		@ImpuestoRenta						decimal(18,2)	= null,
		@ImpuestoVenta						decimal(18,2)	= null,
		@Timbres							decimal(18,2)	= null,
		@Sanciones							decimal(18,2)	= null,
		@SaldoDeuda							decimal(18,2)	= null,
		@CodMoneda							smallint		,
		@CodigoBanco						char(4)			,
		@TipoTasaInteres					char(1)			,
		@Periodicidad						char(1)			= null,	
		@TipoInteres						char(1)			,
		@InteresCorriente					decimal(4,2)	= null,
		@InteresMoratorio					decimal(4,2)	= null,
		@CodigoDecreto						varchar(15)		= NULL,
        @CostasPersonalesCapital			bit				,
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
BEGIN

DECLARE
	@L_Codigo								uniqueidentifier			=	@Codigo					,
	@L_Descripcion							varchar(255)				=	@Descripcion			,	
	@L_ProcesoEstado						char(1)						=	@ProcesoEstado			,
	@L_TipoObligacion						char(1)						=	@TipoObligacion			,
	@L_MontoDeuda							decimal(18,2)				=	@MontoDeuda				,
	@L_MontoLPT								decimal(18,2)				=	@MontoLPT				, 
	@L_MontoObrero							decimal(18,2)				=	@MontoObrero			, 
	@L_MontoPatronal						decimal(18,2)				=	@MontoPatronal			, 
	@L_MontoTrabajadorInd					decimal(18,2)				=	@MontoTrabajadorInd		, 
	@L_ImpuestoRenta						decimal(18,2)				=	@ImpuestoRenta			, 
	@L_ImpuestoVenta						decimal(18,2)				=	@ImpuestoVenta			, 
	@L_Timbres								decimal(18,2)				=	@Timbres				, 
	@L_Sanciones							decimal(18,2)				=	@Sanciones				, 
	@L_SaldoDeuda							decimal(18,2)				=	@SaldoDeuda				, 
	@L_CodMoneda							smallint					=	@CodMoneda				,
	@L_CodigoBanco							char(4)						=	@CodigoBanco			,
	@L_TipoTasaInteres						char(1)						=	@TipoTasaInteres		,
	@L_Periodicidad							char(1)						=	@Periodicidad			,	
	@L_TipoInteres							char(1)						=	@TipoInteres			,
	@L_InteresCorriente						decimal(4,2)				=	@InteresCorriente		,
	@L_InteresMoratorio						decimal(4,2)				=	@InteresMoratorio		,
	@L_CodigoDecreto						varchar(15)					=	@CodigoDecreto			,
	@L_CostasPersonalesCapital				bit							=	@CostasPersonalesCapital,
	@L_MontoSobreGiro						decimal(18,2)				=	@MontoSobreGiro			,
	@L_InteresSobreGiro						decimal(18,2)				=	@InteresSobreGiro		,			
	@L_FechaInicioSobreGiro					datetime2(7)				=	@FechaInicioSobreGiro	,		
	@L_FechaFinalSobreGiro					datetime2(7)				=	@FechaFinalSobreGiro	,			
	@L_MontoInteresSobreGiro				decimal(18,2)				=	@MontoInteresSobreGiro	,			
	@L_TasaInteresPosterior					decimal(18,2)				=	@TasaInteresPosterior	,		
	@L_FechaInteresPosterior				datetime2(7)				=	@FechaInteresPosterior	,			
	@L_TasaInteresPosteriorSobreGiro		decimal(18,2)				=	@TasaInteresPosteriorSobreGiro,	
	@L_FechaInteresPosteriorSobreGiro		datetime2(7)				=	@FechaInteresPosteriorSobreGiro
	
	Update	Expediente.Deuda 
	Set		TC_Descripcion							=	@L_Descripcion,		       
			TC_ProcesoEstado						=	@L_ProcesoEstado,		
			TC_TipoObligacion						=	@L_TipoObligacion,		
			TN_MontoDeuda							=	@L_MontoDeuda,			
			TN_MontoLPT								=	@L_MontoLPT,			
			TN_MontoObrero							=	@L_MontoObrero,		
			TN_MontoPatronal						=	@L_MontoPatronal,		
			TN_MontoTrabajadorInd					=	@L_MontoTrabajadorInd,
			TN_ImpuestoRenta						=	@L_ImpuestoRenta,		
			TN_ImpuestoVenta						=	@L_ImpuestoVenta,		
			TN_Timbres								=	@L_Timbres,			
			TN_Sanciones							=	@L_Sanciones,			
			TN_SaldoDeuda							=	@L_SaldoDeuda,			
			TN_CodMoneda							=	@L_CodMoneda,			
			TC_CodigoBanco							=	@L_CodigoBanco,		
			TC_TipoTasaInteres						=	@L_TipoTasaInteres,	
			TC_Periodicidad							=	@L_Periodicidad,		
			TC_TipoInteres							=	@L_TipoInteres,		
			TN_InteresCorriente						=	@L_InteresCorriente,	
			TN_InteresMoratorio						=	@L_InteresMoratorio,	
			TC_CodigoDecreto						=	@L_CodigoDecreto,
			TB_CostasPersonalesCapital				=	@L_CostasPersonalesCapital,
			TN_MontoSobreGiro						=	@L_MontoSobreGiro,
			TN_InteresSobreGiro						=	@L_InteresSobreGiro,				
			TF_FechaInicioSobreGiro					=	@L_FechaInicioSobreGiro,			
			TF_FechaFinalSobreGiro					=	@L_FechaFinalSobreGiro,			
			TN_MontoInteresSobreGiro				=	@L_MontoInteresSobreGiro,		
			TN_TasaInteresPosterior					=	@L_TasaInteresPosterior	,		
			TF_FechaInteresPosterior				=	@L_FechaInteresPosterior,		
			TN_TasaInteresPosteriorSobreGiro		=	@L_TasaInteresPosteriorSobreGiro,
			TF_FechaInteresPosteriorSobreGiro		=	@L_FechaInteresPosteriorSobreGiro
	Where	TU_CodigoDeuda				=	@L_Codigo
End
GO
