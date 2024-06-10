SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Luis Alonso Leiva Tames>
-- Fecha de creación:	<21/03/2021>
-- Descripción:			<Permite Eliminar una prevención en la tabla: Prevencion.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarPrevencion]
	@Codigo					UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE
		@L_Codigo				UNIQUEIDENTIFIER	= @Codigo
		

	DELETE FROM 
		Expediente.Prevencion	
	WHERE 
		TU_CodPrevencion = @L_Codigo

END



GO
