SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<11/12/2019>
-- Descripción:			<Permite agregar un registro en la tabla: Objeto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_AgregarObjeto]
	@Codigo						UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@CodOficina					VARCHAR(4),
	@TipoObjeto					CHAR(1),
	@NumeroObjeto				VARCHAR(20),
	@Descripcion				VARCHAR(255),
	@Observacion				VARCHAR(500),
	@Marca						VARCHAR(255),
	@Modelo						VARCHAR(255),
	@Serie						VARCHAR(255),
	@Color						VARCHAR(50),
	@Peritaje					BIT,
	@CodMoneda					SMALLINT,
	@Valor						DECIMAL,
	@FechaRegistro				DATETIME,
	@Contenedor					BIT,
	@CodigoObjetoPadre			UNIQUEIDENTIFIER,
	@UsuarioRed					VARCHAR(30),
	@Ley						BIT

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @Codigo,
			@L_TC_NumeroExpediente		CHAR(14)			= @NumeroExpediente,
			@L_TC_CodOficina			VARCHAR(4)			= @CodOficina,
			@L_TC_TipoObjeto			CHAR(1)				= @TipoObjeto,
			@L_TC_NumeroObjeto			VARCHAR(20)			= @NumeroObjeto,
			@L_TC_Descripcion			VARCHAR(255)		= @Descripcion,
			@L_TC_Observacion			VARCHAR(500)		= @Observacion,
			@L_TC_Marca					VARCHAR(255)		= @Marca,
			@L_TC_Modelo				VARCHAR(255)		= @Modelo,
			@L_TC_Serie					VARCHAR(255)		= @Serie,
			@L_TC_Color					VARCHAR(50)			= @Color,
			@L_TB_Peritaje				BIT					= @Peritaje,
			@L_TN_CodMoneda				SMALLINT			= @CodMoneda,
			@L_TN_Valor					DECIMAL				= @Valor,
			@L_TF_FechaRegistro			DATETIME			= @FechaRegistro,
			@L_TB_Contenedor			BIT					= @Contenedor,
			@L_TU_CodigoObjetoPadre		UNIQUEIDENTIFIER	= @CodigoObjetoPadre,
			@L_TC_UsuarioRed			VARCHAR(30)			= @UsuarioRed,
			@L_TB_Ley					BIT					= @Ley
	--Cuerpo
	INSERT INTO	Objeto.Objeto	WITH (ROWLOCK)
	(
		TU_CodObjeto,					TC_NumeroExpediente,			TC_CodOficina,					TC_TipoObjeto,					
		TC_NumeroObjeto,				TC_Descripcion,					TC_Observacion,					TC_Marca,						
		TC_Modelo,						TC_Serie,						TC_Color,						TB_Peritaje,					
		TN_CodMoneda,					TN_Valor,						TF_FechaRegistro,				TB_Contenedor,					
		TU_CodigoObjetoPadre,			TC_UsuarioRed,					TB_Ley
	)
	VALUES
	(
		@L_TU_CodObjeto,				@L_TC_NumeroExpediente,			@L_TC_CodOficina,				@L_TC_TipoObjeto,				
		@L_TC_NumeroObjeto,				@L_TC_Descripcion,				@L_TC_Observacion,				@L_TC_Marca,					
		@L_TC_Modelo,					@L_TC_Serie,					@L_TC_Color,					@L_TB_Peritaje,					
		@L_TN_CodMoneda,				@L_TN_Valor,					@L_TF_FechaRegistro,			@L_TB_Contenedor,				
		@L_TU_CodigoObjetoPadre,		@L_TC_UsuarioRed,				@L_TB_Ley
	)
END
GO
