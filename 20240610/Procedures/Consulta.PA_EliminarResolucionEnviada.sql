SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<10/03/2020>
-- Descripción :			<Permite eliminar las resoluciones publicadas.>
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_EliminarResolucionEnviada]
	@CodArchivo		uniqueidentifier
AS
BEGIN
	
			DELETE FROM		[Consulta].[ArchivoConsulta]
			WHERE			[TU_CodArchivo]						= @CodArchivo

END
GO
