SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<26/02/2020>
-- Descripción:			<Permite eliminar un registro en la tabla: OficinaBodega.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Catalogo].[PA_EliminarOficinaBodega]
	@CodOficina			VARCHAR(4),	
	@CodBodega			SMALLINT
AS
BEGIN
	--Variables
	DECLARE	@L_TC_CodOficina		VARCHAR(4)		= @CodOficina,
			@L_TN_CodBodega			SMALLINT		= @CodBodega

	--Lógica
	DELETE
	FROM	Catalogo.OficinaBodega	WITH (ROWLOCK)
	WHERE	TC_CodOficina			= @L_TC_CodOficina
	AND		TN_CodBodega			= @L_TN_CodBodega
END
GO
