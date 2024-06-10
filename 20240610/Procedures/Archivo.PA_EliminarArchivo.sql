SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<22/04/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: Archivo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Archivo].[PA_EliminarArchivo]
	@CodArchivo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo

	--Lógica
	DELETE
	FROM	Archivo.Archivo	WITH (ROWLOCK)
	WHERE	TU_CodArchivo						= @L_TU_CodArchivo
END
GO
