SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Isaac Dobles Mata>
-- Fecha de creación:	<30/07/2020>
-- Descripción:			<Permite agregar una resolución para que sea posteriormente publicada en el módulo de consultas.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[Consulta].[PA_AgregarArchivoConsulta]
	@CodigoArchivo							UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo				UNIQUEIDENTIFIER		= @CodigoArchivo

	--Cuerpo
	INSERT INTO	Consulta.ArchivoConsulta	WITH (ROWLOCK)
	(
		TU_CodArchivo,					TC_Estado
	)
	VALUES
	(
		@L_TU_CodArchivo,				'P'
	)
END
GO
