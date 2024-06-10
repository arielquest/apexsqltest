SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<29/01/2021>
-- Descripción:			<Consulta el estado de una itineración por el codigo Guid de la itineración>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ConsultarItineracionEstado]
    @CodHistoricoItineracion UNIQUEIDENTIFIER
AS
BEGIN
--variables
DECLARE		@L_CodHistoricoItineracion			UNIQUEIDENTIFIER	=	@CodHistoricoItineracion

		SELECT		A.TN_CodEstadoItineracion			AS Codigo
		FROM		Historico.Itineracion				A WITH(NOLOCK)
		WHERE		A.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion
END
GO
