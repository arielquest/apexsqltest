SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<26/11/2020>
-- Descripción :			<Elimina un registro del histórico de itineraciones>  
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_EliminarHistoricoItineracion]
	@CodHistoricoItineracion		uniqueidentifier
	
AS  
BEGIN 

	DECLARE @L_CodHistoricoItineracion			uniqueidentifier	= @CodHistoricoItineracion


	DELETE 
	FROM		[Historico].[Itineracion]
	WHERE		[TU_CodHistoricoItineracion]			=	@L_CodHistoricoItineracion

END
GO
