SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<14/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: SolicitudExpediente.>
-- =================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><21/02/2020><Se agrega validación cuando el valor de codigo archvo se recibe EMPTY desde .Net>
-- ================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><20/04/2020><Se ajusta nombramiento de parametros recibidos para coincidir con nombre en campo de tabla, objetivo seguir el estandar>
-- =================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><03/09/2020><Se debe modificar campo TC_Descripcion a 255 caracteres en parametro de entrada y variable local>
-- =================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><18/01/2021><Se realiza ajuste por valor incorrecto en tipo de dato de CodClase (SMALLINT > INT)>
-- =================================================================================================================================================================================
-- Modificado por:		<Josué Quirós Batista> <25/09/2023> <Se agrega el parámetro para identificar legajos>
-- =================================================================================================================================================================================

CREATE PROCEDURE	[Expediente].[PA_AgregarSolicitudExpediente]
	@CodSolicitudExpediente			UNIQUEIDENTIFIER,
	@CodEstadoItineracion			SMALLINT,
	@FechaCreacion					DATETIME2(7),
	@FechaEnvio						DATETIME2(7)	= NULL,
	@FechaRecepcion					DATETIME2(7)	= NULL,
	@CodContextoOrigen				VARCHAR(4),
	@CodOficinaDestino				VARCHAR(4),
	@CodContextoDestino				VARCHAR(4),
	@CodMotivoItineracion			SMALLINT,
	@Descripcion					VARCHAR(255),
	@CodHistoricoItineracion		UNIQUEIDENTIFIER	= NULL,
	@CodTipoItineracion				SMALLINT,
	@NumeroExpediente				CHAR(14),
	@CodClaseAsunto					INT,
	@CodArchivo						UNIQUEIDENTIFIER,
	@CodigoLegajo					UNIQUEIDENTIFIER	= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudExpediente		UNIQUEIDENTIFIER		= @CodSolicitudExpediente,
			@L_TN_CodEstadoItineracion			SMALLINT				= @CodEstadoItineracion,
			@L_TF_FechaCreacion					DATETIME2(7)			= @FechaCreacion,
			@L_TF_FechaEnvio					DATETIME2(7)			= @FechaEnvio,
			@L_TF_FechaRecepcion				DATETIME2(7)			= @FechaRecepcion,
			@L_TC_CodContextoOrigen				VARCHAR(4)				= @CodContextoOrigen,
			@L_TC_CodOficinaDestino				VARCHAR(4)				= @CodOficinaDestino,
			@L_TC_CodContextoDestino			VARCHAR(4)				= @CodContextoDestino,
			@L_TN_CodMotivoItineracion			SMALLINT				= @CodMotivoItineracion,
			@L_TC_Descripcion					VARCHAR(255)			= @Descripcion,
			@L_TU_CodHistoricoItineracion		UNIQUEIDENTIFIER		= @CodHistoricoItineracion,
			@L_TN_CodTipoItineracion			SMALLINT				= @CodTipoItineracion,
			@L_TC_NumeroExpediente				CHAR(14)				= @NumeroExpediente,
			@L_TN_CodClaseAsunto				INT						= @CodClaseAsunto,
			@L_TU_CodArchivo					UNIQUEIDENTIFIER		= CASE @CodArchivo 
																			WHEN '00000000-0000-0000-0000-000000000000' THEN NULL 
																			ELSE @CodArchivo 
																		  END, 
		    @L_CodigoLegajo						UNIQUEIDENTIFIER		= CASE @CodigoLegajo 
																			WHEN '00000000-0000-0000-0000-000000000000' THEN NULL 
																			ELSE @CodigoLegajo 
																		  END
	--Cuerpo
	INSERT INTO	Expediente.SolicitudExpediente	WITH (ROWLOCK)
	(
		TU_CodSolicitudExpediente,		TN_CodEstadoItineracion,		TF_FechaCreacion,				TF_FechaEnvio,					
		TF_FechaRecepcion,				TC_CodContextoOrigen,			TC_CodOficinaDestino,			TC_CodContextoDestino,			
		TN_CodMotivoItineracion,		TC_Descripcion,					TU_CodHistoricoItineracion,		TN_CodTipoItineracion,			
		TC_NumeroExpediente,			TN_CodClaseAsunto,				TU_CodArchivo,					TU_CODLEGAJO					
	)
	VALUES
	(
		@L_TU_CodSolicitudExpediente,	@L_TN_CodEstadoItineracion,		@L_TF_FechaCreacion,			@L_TF_FechaEnvio,				
		@L_TF_FechaRecepcion,			@L_TC_CodContextoOrigen,		@L_TC_CodOficinaDestino,		@L_TC_CodContextoDestino,			
		@L_TN_CodMotivoItineracion,		@L_TC_Descripcion,				@L_TU_CodHistoricoItineracion,	@L_TN_CodTipoItineracion,			
		@L_TC_NumeroExpediente,			@L_TN_CodClaseAsunto,			@L_TU_CodArchivo,				@L_CodigoLegajo				
	)
END
GO
