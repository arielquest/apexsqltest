SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada>
-- Fecha de creación:		<13/05/2016>
-- Descripción:				<Permite agregar una solicitud a [Agenda].[PA_AgregarSolicitudDefensor].>
-- ======================================================================================================================================
-- Modificación:			<18/12/2017> <Ailyn López>		<Se agregan dos campos nuevos.>
-- Modificación:			<01/11/2019> <Isaac Dobles>		<Se modifica para estrucutra de expediente y legajos>
-- Modificación:			<07/02/2020> <Aida E Siles>		<Se agrega el contexto y el puesto trabajo del asignado seleccionado>
-- Modificación:			<Jonathan Aguilar Navarro>		<21/10/2020> <Se agrega el parametro TF_Inicio_Vigencia, por cambios en ExpedienteAsignado>
-- ======================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarSolicitudDefensor]
	 @CodigoSolicitudDefensor	UNIQUEIDENTIFIER,	
	 @NumeroExpediente			CHAR(14),
	 @EstadoSolicitud			VARCHAR(1),
	 @TipoSolicitud				VARCHAR(1),
	 @UsuarioRedSolicita		VARCHAR(30),
	 @Observaciones				VARCHAR(255),
	 @LugarDiligencia			VARCHAR(100),
	 @CodigoEvento				UNIQUEIDENTIFIER,
	 @CodigoArchivo				UNIQUEIDENTIFIER = NULL,
	 @FechaCreacion				DATETIME2(7),
	 @FechaEnvio				DATETIME2(7),
	 @FechaActualizacion		DATETIME2(7),
	 @ContextoSolicita			VARCHAR(4),
	 @OficinaDefensa			VARCHAR(4),
	 @CodContexto				VARCHAR(4),
	 @CodPuestoTrabajo			VARCHAR(14),
	 @FechaInicioVigencia		DATETIME2(7)
AS
BEGIN

	Declare @L_CodigoSolicitudDefensor	UNIQUEIDENTIFIER	= @CodigoSolicitudDefensor	
	Declare @L_NumeroExpediente			CHAR(14)			= @NumeroExpediente			
	Declare @L_EstadoSolicitud			VARCHAR(1)			= @EstadoSolicitud			
	Declare @L_TipoSolicitud			VARCHAR(1)			= @TipoSolicitud				
	Declare @L_UsuarioRedSolicita		VARCHAR(30)			= @UsuarioRedSolicita		
	Declare @L_Observaciones			VARCHAR(255)		= @Observaciones				
	Declare @L_LugarDiligencia			VARCHAR(100)		= @LugarDiligencia			
	Declare @L_CodigoEvento				UNIQUEIDENTIFIER	= @CodigoEvento				
	Declare @L_CodigoArchivo			UNIQUEIDENTIFIER 	= @CodigoArchivo				
	Declare @L_FechaCreacion			DATETIME2(7)		= @FechaCreacion				
	Declare @L_FechaEnvio				DATETIME2(7)		= @FechaEnvio				
	Declare @L_FechaActualizacion		DATETIME2(7)		= @FechaActualizacion		
	Declare @L_ContextoSolicita			VARCHAR(4)			= @ContextoSolicita			
	Declare @L_OficinaDefensa			VARCHAR(4)			= @OficinaDefensa			
	Declare @L_CodContexto				VARCHAR(4)			= @CodContexto				
	Declare @L_CodPuestoTrabajo			VARCHAR(14)			= @CodPuestoTrabajo			
	Declare @L_FechaInicioVigencia		DATETIME2(7)		= @FechaInicioVigencia		

	INSERT INTO [Expediente].[SolicitudDefensor]
	(
		TU_CodSolicitudDefensor, 
		TC_NumeroExpediente, 
		TC_EstadoSolicitudDefensor, 
		TC_TipoSolicitudDefensor, 
		TU_UsuarioRedSolicita, 
		TC_Observaciones, 
		TC_LugarDiligencia, 
		TU_Evento, 
		TU_CodArchivo, 
		TF_FechaCreacion, 
		TF_FechaEnvio,
        TF_Actualizacion,
		TC_CodOficinaSolicita,
		TC_CodOficinaDefensa,
		TC_CodContexto,
		TC_CodPuestoTrabajo,
		TF_Inicio_Vigencia
	)
	VALUES
	(
		@L_CodigoSolicitudDefensor,		
		@L_NumeroExpediente,			
		@L_EstadoSolicitud,			
		@L_TipoSolicitud,			
		@L_UsuarioRedSolicita,		
		@L_Observaciones,			
		@L_LugarDiligencia,			
		@L_CodigoEvento,				
		@L_CodigoArchivo,			
		@L_FechaCreacion,			
		@L_FechaEnvio,				
		@L_FechaActualizacion,		
		@L_ContextoSolicita,			
		@L_OficinaDefensa,			
		@L_CodContexto,				
		@L_CodPuestoTrabajo,			
    	@L_FechaInicioVigencia	
	)

END
GO
