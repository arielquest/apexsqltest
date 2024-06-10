SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<10/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Documento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarDocumento]
	@Codigo						UNIQUEIDENTIFIER,
	@CodObjeto					UNIQUEIDENTIFIER,
	@Descripcion				VARCHAR(300)		= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo		UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto			UNIQUEIDENTIFIER		= @CodObjeto,			
			@L_TC_Descripcion		VARCHAR(300)			= @Descripcion
	--Cuerpo
	INSERT INTO	Objeto.Documento	WITH (ROWLOCK)
	(
		TU_CodArchivo,				TU_CodObjeto,					TC_Descripcion
	)
	VALUES
	(
		@L_TU_CodArchivo,				@L_TU_CodObjeto,				@L_TC_Descripcion
	)
END
GO
