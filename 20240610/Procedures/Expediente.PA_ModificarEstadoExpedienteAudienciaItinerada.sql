SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Richard Zúñiga Segura>
-- Fecha creación:	<08/04/2021>
-- Descripción :	<Permite modificar el estado, canntidad de archivos y nombre de archivo de una audiencia itinerada> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarEstadoExpedienteAudienciaItinerada]
	@TN_CodAudiencia		bigint,
	@TC_NombreArchivo		varchar(255),
	@TN_EstadoPublicacion	smallint,
	@TN_CantidadArchivos	tinyint
AS
BEGIN
	UPDATE	Expediente.Audiencia
	SET		TN_EstadoPublicacion	=	@TN_EstadoPublicacion,
			TN_CantidadArchivos		=	@TN_CantidadArchivos,
			TC_NombreArchivo		=	@TC_NombreArchivo
	WHERE	TN_CodAudiencia			=	@TN_CodAudiencia
END
GO
