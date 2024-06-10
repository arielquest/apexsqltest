SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<30/08/2022>
-- Descripción :			<Inserta un registro en [Expediente].[ConsecutivoReutilizar] para que se pueda reutilizar el consecutivo al intentar generarse uno desde Sistemas externos como GL o CEREDOC> 
-- =============================================================================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_AgregarConsecutivoReutilizar]
	@CodPreasignado			uniqueidentifier
AS
BEGIN
	DECLARE @L_CodPreasignado		uniqueidentifier	= @CodPreasignado
	
	INSERT	INTO	[Expediente].[ConsecutivoReutilizar]
	([TU_CodPreasignado])
	VALUES
	(@L_CodPreasignado)
END		
GO
