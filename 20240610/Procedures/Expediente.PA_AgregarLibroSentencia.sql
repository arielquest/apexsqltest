SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Jose Gabriel Cordero Soto>-- Fecha de creación:	<15/06/2021>-- Descripción:			<Permite agregar un registro en la tabla: LibroSentencia.>-- ==================================================================================================================================================================================CREATE PROCEDURE				[Expediente].[PA_AgregarLibroSentencia]	@CodLibroSentencia			UNIQUEIDENTIFIER,	@AnnoSentencia				VARCHAR(4),	@CodContexto				VARCHAR(4),	@CodPuestoTrabajo			VARCHAR(14)			= NULL,	@NumeroResolucion			CHAR(14),	@FechaAsignacion			DATETIME2(7),	@Estado						CHAR(1),	@CodResolucion				UNIQUEIDENTIFIER	= NULL,	@UsuarioCrea				UNIQUEIDENTIFIER	= NULL,	@UsuarioConfirma			UNIQUEIDENTIFIER	= NULL,	@JustificacionNoUso			VARCHAR(150)		= NULL,		@JUEZ						VARCHAR(11)			= NULL,	@USUREDAC					VARCHAR(25)			= NULLASBEGIN	--Variables	DECLARE	@L_TU_CodLibroSentencia		UNIQUEIDENTIFIER		= @CodLibroSentencia,			@L_TC_AnnoSentencia			VARCHAR(4)				= @AnnoSentencia,			@L_TC_CodContexto			VARCHAR(4)				= @CodContexto,			@L_TC_CodPuestoTrabajo		VARCHAR(14)				= @CodPuestoTrabajo,			@L_TC_NumeroResolucion		CHAR(14)				= @NumeroResolucion,			@L_TF_FechaAsignacion		DATETIME2(7)			= @FechaAsignacion,			@L_TC_Estado				CHAR(1)					= @Estado,			@L_TU_CodResolucion			UNIQUEIDENTIFIER		= @CodResolucion,			@L_TU_UsuarioCrea			UNIQUEIDENTIFIER		= @UsuarioCrea,			@L_TU_UsuarioConfirma		UNIQUEIDENTIFIER		= @UsuarioConfirma,			@L_TC_JustificacionNoUso	VARCHAR(150)			= @JustificacionNoUso,						@L_JUEZ						VARCHAR(11)				= @JUEZ,						@L_USUAREDAC				VARCHAR(25)				= @USUREDAC	--Cuerpo	INSERT INTO	Expediente.LibroSentencia	WITH (ROWLOCK)	(		TU_CodLibroSentencia,			TC_AnnoSentencia,				TC_CodContexto,					TC_CodPuestoTrabajo,					TC_NumeroResolucion,			TF_FechaAsignacion,				TC_Estado,						TU_CodResolucion,						TU_UsuarioCrea,					TU_UsuarioConfirma,				TC_JustificacionNoUso,			TF_Actualizacion,		JUEZ,							USUREDAC								)	VALUES	(		@L_TU_CodLibroSentencia,		@L_TC_AnnoSentencia,			@L_TC_CodContexto,				@L_TC_CodPuestoTrabajo,					@L_TC_NumeroResolucion,			@L_TF_FechaAsignacion,			@L_TC_Estado,					@L_TU_CodResolucion,					@L_TU_UsuarioCrea,				@L_TU_UsuarioConfirma,			@L_TC_JustificacionNoUso,		GETDATE(),		@L_JUEZ,						@L_USUAREDAC													)END
GO
