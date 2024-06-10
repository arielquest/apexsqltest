SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Registra el reparto en bitácora> 
-- Fecha de modificación    <18/05/2021>
-- Modificado por:			<Johan Acosta Ibañez>
-- Descripción :			<Se modifica el schema, el nombre y la tabla de BitacoraReparto a HistoricoReparto> 
-- Fecha de modificación    <24/05/2021>
-- Modificado por:			<Johan Acosta Ibañez>
-- Descripción :			<Se modifica el procedimiento para agregar los campos de TC_Prioridad, TC_UsuarioRed> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarHistoricoReparto]
	@NumeroExpediente			varchar(14),      
	@CodLegajo					uniqueidentifier,
	@CodContexto				varchar(4),    
	@CodOficina					varchar(4),
	@CodPuestoTrabajo			varchar(14),			
	@CodTipoPuestoTrabajo		smallint,
	@DatosCriterio				varchar(255),
	@Accion						varchar(150),
	@Motivo						varchar(255),
	@CodCriterio				uniqueidentifier,
	@Prioridad					char(1),
	@UsuarioRed					varchar(30)
AS  
BEGIN  
	Declare 
			@L_NumeroExpediente			varchar(14)      = @NumeroExpediente,
			@L_CodLegajo				uniqueidentifier = @CodLegajo,
			@L_CodContexto				varchar(4)       = @CodContexto,
			@L_CodOficina				varchar(4)		 = @CodOficina,
			@L_CodPuestoTrabajo			varchar(14)      = @CodPuestoTrabajo,			
			@L_CodTipoPuestoTrabajo		smallint         = @CodTipoPuestoTrabajo,
			@L_DatosCriterio			varchar(255)     = @DatosCriterio,
			@L_Accion					varchar(150)     = @Accion,
			@L_Motivo					varchar(255)     = @Motivo,
			@L_CodCriterio				uniqueidentifier = @CodCriterio,
			@L_Prioridad				char(1)			 = @Prioridad,
			@L_UsuarioRed				varchar(30)		 = @UsuarioRed

	Insert Into Historico.HistoricoReparto(	TU_CodBitacora,			TC_CodOficina,				TC_CodContexto,			TC_NumeroExpediente,	
											TU_CodLegajo,			TN_CodTipoPuestoTrabajo,	TC_CodPuestoTrabajo,	TF_Fecha,		
											TC_Accion,				TC_Motivo,					TC_ValorAtributos,		TU_CodCriterio,		
											TC_Prioridad,			TC_UsuarioRed) 
								   Values(	NEWID(),                @L_CodOficina,				@L_CodContexto,			@L_NumeroExpediente,	
											@L_CodLegajo,			@L_CodTipoPuestoTrabajo,	@L_CodPuestoTrabajo,	GETDATE(),		
											@L_Accion,				@L_Motivo,					@L_DatosCriterio,       @L_CodCriterio,	
											@L_Prioridad,			@L_UsuarioRed)
	
END
GO
