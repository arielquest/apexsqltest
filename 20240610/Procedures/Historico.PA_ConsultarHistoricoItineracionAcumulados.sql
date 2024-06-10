SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<24/04/2021>
-- Descripción :			<Permite consultar los registros asociados por acumulación a una itineración.>  

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoItineracionAcumulados]
	@CodHistoricoItineracion					uniqueidentifier
AS  
BEGIN 

	DECLARE @L_CodHistoricoItineracion				uniqueidentifier	= @CodHistoricoItineracion

	SELECT	TU_CodHistoricoItineracion		AS Codigo,
			TC_NumeroExpediente				AS NumeroExpediente
	FROM	Historico.Itineracion			A With(Nolock)
	WHERE	TU_CodHistoricoItineracionPadre = @L_CodHistoricoItineracion

END



GO
