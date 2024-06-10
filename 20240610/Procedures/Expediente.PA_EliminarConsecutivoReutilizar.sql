SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<30/08/2022>
-- Descripción :			<Elimina un registro de [Expediente].[ConsecutivoReutilizar] para que no se pueda reutilizar el consecutivo> 
-- =============================================================================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_EliminarConsecutivoReutilizar]
	@CodPreasignado			uniqueidentifier
AS
BEGIN
	DECLARE @L_CodPreasignado		uniqueidentifier	= @CodPreasignado
	
	DELETE	
	FROM		[Expediente].[ConsecutivoReutilizar]
	WHERE		[TU_CodPreasignado]						= @L_CodPreasignado
END		
GO
