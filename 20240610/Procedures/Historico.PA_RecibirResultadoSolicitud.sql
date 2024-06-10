SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<27/11/2020>
-- Descripción:			<Hace las modificaciones para que indica la recepción de un resultado solicitud.>
-- ==================================================================================================================================================================================
-- Modificación:		<27/01/2021> <Aida Elena Siles R> <Se agrega la actualización de la fecha de recepción al resultado de la solicitud.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_RecibirResultadoSolicitud]
	@CodSolicitudExpediente UNIQUEIDENTIFIER,
	@CodResultadoSolicitud	UNIQUEIDENTIFIER
AS
BEGIN TRY
	BEGIN TRAN;
--Variables
DECLARE		@L_CodSolicitudExpediente	UNIQUEIDENTIFIER	=	@CodSolicitudExpediente,
			@L_CodResultadoSolicitud	UNIQUEIDENTIFIER	=	@CodResultadoSolicitud

	--Se asigna el codigo GUID del resultado a la solicitud.
	UPDATE	[Expediente].[SolicitudExpediente]	WITH(ROWLOCK)
	SET		[TU_CodResultadoSolicitud]			= @CodResultadoSolicitud
	WHERE	[TU_CodSolicitudExpediente]			= @CodSolicitudExpediente

	--Se asigna la fecha de recepción al resultado de solicitud.
	UPDATE	[Expediente].[ResultadoSolicitud]	WITH(ROWLOCK)
	SET		[TF_FechaRecepcion]					= GETDATE()
	WHERE	[TU_CodResultadoSolicitud]			= @L_CodResultadoSolicitud

	COMMIT TRAN;
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
	THROW;
END CATCH
GO
