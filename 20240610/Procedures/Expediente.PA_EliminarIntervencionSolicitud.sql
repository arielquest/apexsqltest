SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Aida E Siles>-- Fecha de creación:	<20/04/2020>-- Descripción:			<Permite eliminar un registro en la tabla: IntervencionSolicitud.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[Expediente].[PA_EliminarIntervencionSolicitud]	@CodSolicitudExpediente		UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodSolicitudExpediente		UNIQUEIDENTIFIER		= @CodSolicitudExpediente	--Lógica	DELETE	FROM	Expediente.IntervencionSolicitud	WITH (ROWLOCK)	WHERE	TU_CodSolicitudExpediente			= @L_TU_CodSolicitudExpedienteEND
GO
