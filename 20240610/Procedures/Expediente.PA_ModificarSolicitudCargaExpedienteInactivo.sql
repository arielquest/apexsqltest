SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:		Isaac Dobles Mata
-- Create date: 17/02/2023
-- Description:	Actualiza el estado de una solicitud de carga
-- ====================================================================================================================================================================================

-- ====================================================================================================================================================================================
CREATE     PROCEDURE [Expediente].[PA_ModificarSolicitudCargaExpedienteInactivo]
	@CodigoSolicitud	BIGINT,
	@Estado				CHAR(1)
AS
BEGIN
		--Variables
		DECLARE 
		@L_CodSolicitud			BIGINT			=   @CodigoSolicitud,
		@L_Estado				CHAR(1)			=	@Estado

		UPDATE	[Expediente].[SolicitudCargaInactivo]
		SET		[TC_Estado]									=	@L_Estado
		WHERE	[TN_CodSolicitud]							=	@L_CodSolicitud
END
GO
