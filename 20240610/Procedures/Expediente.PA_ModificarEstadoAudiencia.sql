SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrew Allen Dawson>
-- Fecha creación:	<30/01/2019>
-- Descripción :	<Permite modificar el estado de una audiencia.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarEstadoAudiencia]
	 @CodAudiencia bigint,
	 @Estado smallint
AS
BEGIN

	DECLARE @L_CodAudiencia Bigint,
	        @L_Estado smallint

	SET @L_CodAudiencia = @CodAudiencia
	SET	@L_Estado = @Estado


	UPDATE [Expediente].[Audiencia]
	   SET TN_EstadoPublicacion = @L_Estado
	 WHERE [TN_CodAudiencia] = @L_CodAudiencia
END
GO
