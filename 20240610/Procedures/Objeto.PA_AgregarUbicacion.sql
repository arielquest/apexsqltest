SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<31/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: Ubicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarUbicacion]
	@Codigo						UNIQUEIDENTIFIER,
	@CodObjeto					UNIQUEIDENTIFIER,
	@CodBodega					SMALLINT	= NULL,
	@CodSeccion					SMALLINT	= NULL,
	@CodEstante					SMALLINT	= NULL,
	@CodCompartimiento			SMALLINT	= NULL,
	@Descripcion				VARCHAR(500),
	@UsuarioRed					VARCHAR(30),
	@Fecha						DATETIME2(7)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodUbicacion			UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodObjeto				UNIQUEIDENTIFIER		= @CodObjeto,
			@L_TN_CodBodega				SMALLINT				= @CodBodega,
			@L_TN_CodSeccion			SMALLINT				= @CodSeccion,
			@L_TN_CodEstante			SMALLINT				= @CodEstante,
			@L_TN_CodCompartimiento		SMALLINT				= @CodCompartimiento,
			@L_TC_Descripcion			VARCHAR(500)			= @Descripcion,
			@L_TC_UsuarioRed			VARCHAR(30)				= @UsuarioRed,
			@L_TF_Fecha					DATETIME2(7)			= @Fecha
	--Cuerpo
	INSERT INTO	Objeto.Ubicacion	WITH (ROWLOCK)
	(
		TU_CodUbicacion,				TU_CodObjeto,					TN_CodBodega,					TN_CodSeccion,					
		TN_CodEstante,					TN_CodCompartimiento,			TC_Descripcion,					TC_UsuarioRed,					
		TF_Fecha						
	)
	VALUES
	(
		@L_TU_CodUbicacion,				@L_TU_CodObjeto,				@L_TN_CodBodega,				@L_TN_CodSeccion,				
		@L_TN_CodEstante,				@L_TN_CodCompartimiento,		@L_TC_Descripcion,				@L_TC_UsuarioRed,				
		@L_TF_Fecha						
	)
END
GO
