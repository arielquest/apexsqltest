SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<16/04/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: SolicitudExpediente.>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><03/09/2020><Se debe modificar campo TC_Descripcion a 255 caracteres en tabla>
-- Modificado por:      <Daniel Ruiz Hernández><02/02/2021><Se debe modificar los parametros @CodClaseAsunto y @L_TN_CodClaseAsunto de smallint a int>
-- =================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ModificarSolicitudExpediente]
	@CodSolicitudExpediente		UNIQUEIDENTIFIER,
	@FechaEnvio					DATETIME2(3)	= NULL,
	@FechaRecepcion				DATETIME2(3)	= NULL,
	@CodContextoOrigen			VARCHAR(4),
	@CodOficinaDestino			VARCHAR(4),
	@CodContextoDestino			VARCHAR(4),
	@CodMotivoItineracion		SMALLINT,
	@Descripcion				VARCHAR(255),
	@CodClaseAsunto				INT,
	@CodArchivo					UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudExpediente		UNIQUEIDENTIFIER	= @CodSolicitudExpediente,
			@L_TF_FechaEnvio					DATETIME2(7)		= @FechaEnvio,
			@L_TF_FechaRecepcion				DATETIME2(7)		= @FechaRecepcion,
			@L_TC_CodContextoOrigen				VARCHAR(4)			= @CodContextoOrigen,
			@L_TC_CodOficinaDestino				VARCHAR(4)			= @CodOficinaDestino,
			@L_TC_CodContextoDestino			VARCHAR(4)			= @CodContextoDestino,
			@L_TN_CodMotivoItineracion			SMALLINT			= @CodMotivoItineracion,
			@L_TC_Descripcion					VARCHAR(255)		= @Descripcion,
			@L_TN_CodClaseAsunto				INT					= @CodClaseAsunto,
			@L_TU_CodArchivo					UNIQUEIDENTIFIER	= @CodArchivo
	--Lógica
	UPDATE	Expediente.SolicitudExpediente	WITH (ROWLOCK)
	SET		TF_FechaEnvio					= @L_TF_FechaEnvio,
			TF_FechaRecepcion				= @L_TF_FechaRecepcion,
			TC_CodContextoOrigen			= @L_TC_CodContextoOrigen,
			TC_CodOficinaDestino			= @L_TC_CodOficinaDestino,
			TC_CodContextoDestino			= @L_TC_CodContextoDestino,
			TN_CodMotivoItineracion			= @L_TN_CodMotivoItineracion,
			TC_Descripcion					= @L_TC_Descripcion,
			TN_CodClaseAsunto				= @L_TN_CodClaseAsunto,
			TU_CodArchivo					= @L_TU_CodArchivo
	WHERE	TU_CodSolicitudExpediente		= @L_TU_CodSolicitudExpediente
END
GO
