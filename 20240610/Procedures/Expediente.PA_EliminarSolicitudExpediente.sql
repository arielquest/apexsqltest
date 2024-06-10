SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/11/2020>
-- Descripción :			<Permite eliminar una solicitud de un expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarSolicitudExpediente]
	@CodSolicitudExpediente					UNIQUEIDENTIFIER
AS  
BEGIN
			DECLARE @L_CodSolicitudExpediente	UNIQUEIDENTIFIER	=	@CodSolicitudExpediente
			
			DELETE FROM	
			[Expediente].[SolicitudExpediente]
			WHERE	
			[TU_CodSolicitudExpediente]								=	@L_CodSolicitudExpediente
END
GO
