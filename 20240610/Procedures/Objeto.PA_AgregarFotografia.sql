SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<13/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Fotografia.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarFotografia]
	@Codigo					UNIQUEIDENTIFIER,
	@CodObjeto					UNIQUEIDENTIFIER,
	@Observacion				VARCHAR(300)	= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo		UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto			UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TC_Observacion		VARCHAR(300)			= @Observacion
	--Cuerpo
	INSERT INTO	Objeto.Fotografia	WITH (ROWLOCK)
	(
		TU_CodArchivo,					TU_CodObjeto,					TC_Observacion
	)
	VALUES
	(
		@L_TU_CodArchivo,				@L_TU_CodObjeto,				@L_TC_Observacion
	)
END
GO
