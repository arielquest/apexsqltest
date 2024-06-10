SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<17/05/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: FormatoJuriComunicacionContexto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Catalogo].[PA_EliminarFormatoJuriComunicacionContexto]
	@CodFormatoJuridico		VARCHAR(8),	
	@CodContexto			VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_TC_CodFormatoJuridico		VARCHAR(8)		= @CodFormatoJuridico,
			@L_TC_CodContexto				VARCHAR(4)		= @CodContexto

	--Lógica
	DELETE
	FROM	Catalogo.FormatoJuriComunicacionContexto	WITH (ROWLOCK)
	WHERE	TC_CodFormatoJuridico						= @L_TC_CodFormatoJuridico
	AND		TC_CodContexto								= @L_TC_CodContexto
END
GO
