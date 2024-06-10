SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<24/09/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: SolicitudExpediente. Al enviar una itineración de tipo solicitud.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ActualizarSolicitudExpediente]
	@CodSolicitudExpediente		UNIQUEIDENTIFIER,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@CodEstadoItineracion		SMALLINT,
	@FechaRecepcion             DATETIME2(7) = NULL,
	@FechaEnvio					DATETIME2(7) = NULL
AS  
BEGIN 

	DECLARE @L_CodSolicitudExpediente		UNIQUEIDENTIFIER	= @CodSolicitudExpediente
	DECLARE @L_CodHistoricoItineracion		UNIQUEIDENTIFIER	= @CodHistoricoItineracion
	DECLARE @L_CodEstadoItineracion			SMALLINT			= @CodEstadoItineracion
	DECLARE @L_FechaRecepcion				DATETIME2(7)		= @FechaRecepcion
	DECLARE @L_FechaEnvio					DATETIME2(7)		= @FechaEnvio

	IF (@L_FechaRecepcion IS NULL)
	BEGIN
		UPDATE [Expediente].[SolicitudExpediente]	WITH (ROWLOCK)
		SET		[TU_CodHistoricoItineracion]		= @L_CodHistoricoItineracion, 
				[TF_FechaEnvio]						= @FechaEnvio,
				[TN_CodEstadoItineracion]			= @L_CodEstadoItineracion
		WHERE	[TU_CodSolicitudExpediente]			= @L_CodSolicitudExpediente
	END
	ELSE
	BEGIN
		UPDATE  [Expediente].[SolicitudExpediente]	WITH (ROWLOCK)
		SET		[TN_CodEstadoItineracion]			= @L_CodEstadoItineracion,
				[TF_FechaRecepcion]					= @L_FechaRecepcion
		WHERE	[TU_CodSolicitudExpediente]			= @L_CodSolicitudExpediente
	END

END
GO
