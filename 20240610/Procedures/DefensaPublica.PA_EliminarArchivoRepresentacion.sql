SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<20/04/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: ArchivoRepresentacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_EliminarArchivoRepresentacion]
	@CodArchivo					UNIQUEIDENTIFIER,	
	@CodRepresentacion			UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo,
			@L_TU_CodRepresentacion		UNIQUEIDENTIFIER		= @CodRepresentacion

	--Lógica
	DELETE
	FROM	DefensaPublica.ArchivoRepresentacion	WITH (ROWLOCK)
	WHERE	TU_CodArchivo							= @L_TU_CodArchivo
	AND		TU_CodRepresentacion					= COALESCE(@L_TU_CodRepresentacion, TU_CodRepresentacion)
END
GO
