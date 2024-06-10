SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Versión:					<1.0>
-- Autor:					<Aida E Siles>
-- Fecha Creación:			<01/04/2019>
-- Descripcion:				<Crear una nueva representacion a una carpeta de la defensa pública>
-- Modificación:			<03/03/2020> <Aida E Siles> <Se agrega el codigo del interviniente>
-- Modificación:			<20/03/2020> <Aida E Siles> <Se agregan variables locales. Observación revisión par.>
-- =======================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_AgregarRepresentacion] 
	@CodRepresentacion		UNIQUEIDENTIFIER,
	@CodPersona				UNIQUEIDENTIFIER,
	@NRD					VARCHAR(14),	
	@Creacion				DATETIME2,
	@LugarTrabajo			VARCHAR(255),
	@Descripcion			VARCHAR(255),
	@CodSituacionLaboral	SMALLINT,
	@Alias					VARCHAR(50),
	@CodPais				VARCHAR(3),
	@CodEstadoCivil			SMALLINT,
	@CodSexo				CHAR(1),
	@CodProfesion			SMALLINT,
	@CodEscolaridad			SMALLINT,
	@CodInterviniente       UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE	@L_TU_CodRepresentacion		UNIQUEIDENTIFIER	= @CodRepresentacion,			@L_TU_CodPersona			UNIQUEIDENTIFIER	= @CodPersona,			@L_TC_NRD					VARCHAR(14)			= @NRD,			@L_TC_LugarTrabajo			VARCHAR(255)		= @LugarTrabajo,			@L_TC_Descripcion			VARCHAR(255)		= @Descripcion,			@L_TN_CodSituacionLaboral	SMALLINT			= @CodSituacionLaboral,			@L_TC_Alias					VARCHAR(50)			= @Alias,			@L_TC_CodPais				VARCHAR(3)			= @CodPais,			@L_TN_CodEstadoCivil		SMALLINT			= @CodEstadoCivil,			@L_TC_CodSexo				CHAR(1)				= @CodSexo,			@L_TN_CodProfesion			SMALLINT			= @CodProfesion,			@L_TN_CodEscolaridad		SMALLINT			= @CodEscolaridad,			@L_TU_CodInterviniente		UNIQUEIDENTIFIER	= @CodInterviniente

	INSERT INTO DefensaPublica.Representacion
	(
		TU_CodRepresentacion,		TU_CodPersona,			TC_NRD,						TF_Creacion,
		TC_LugarTrabajo,			TC_Descripcion,			TN_CodSituacionLaboral,		TC_Alias,
		TC_CodPais,					TN_CodEstadoCivil,		TC_CodSexo,					TN_CodProfesion,
		TN_CodEscolaridad,			TF_Actualizacion,		TU_CodInterviniente
	)
	VALUES
	(
		@L_TU_CodRepresentacion,	@L_TU_CodPersona,		@L_TC_NRD,					GETDATE(),
		@L_TC_LugarTrabajo,			@L_TC_Descripcion,		@L_TN_CodSituacionLaboral,	@L_TC_Alias,
		@L_TC_CodPais,				@L_TN_CodEstadoCivil,	@L_TC_CodSexo,				@L_TN_CodProfesion,
		@L_TN_CodEscolaridad,		GETDATE(),				@L_TU_CodInterviniente
	)
END

GO
