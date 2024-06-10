SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<06/10/2021>
-- Descripción:			<Permite agregar un registro en la tabla: EnvioCorreo.>
-- ==================================================================================================================================================================================
-- <Modificacion>		<14/10/2021> <Miguel Avendaño> Se modifica para almacenar tambien el puesto de trabajo y usuario que envia el correo.
-- <Modificacion>		<20/10/2021> <Miguel Avendaño> Se modifica para almacenar tambien el mensaje de error al enviar correo en caso de que sea necesario.
-- <Modificacion>		<21/10/2021> <Karol Jiménez Sánchez><Se agrega campo Contexto>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarEnvioCorreo]
	@CodEnvioCorreo				UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CorreoPara					VARCHAR(150)		= NULL,
	@CorreosCopia				VARCHAR(600)		= NULL,
	@Asunto						VARCHAR(255)		= NULL,
	@IncluirDatosGenerales		BIT,
	@IncluirIntervenciones		BIT,
	@IncluirNotificaciones		BIT,
	@IncluirDocumentosEscritos	BIT,
	@Mensaje					VARCHAR(8000)		= NULL,
	@FechaEnvio					DATETIME2(7)		= NULL,
	@Estado						CHAR(1),
	@FechaRecepcion				DATETIME2(7)		= NULL,
	@CodigoContexto				VARCHAR(4)			= NULL,
	@CodigoPuestoTrabajo		VARCHAR(14)			= NULL,
	@UsuarioRed					VARCHAR(30)			= NULL,
	@MensajeErrorEnvio			VARCHAR(255)		= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEnvioCorreo				UNIQUEIDENTIFIER		= @CodEnvioCorreo,
			@L_TC_NumeroExpediente				CHAR(14)				= @NumeroExpediente,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TC_CorreoPara					VARCHAR(150)			= @CorreoPara,
			@L_TC_CorreosCopia					VARCHAR(600)			= @CorreosCopia,
			@L_TC_Asunto						VARCHAR(255)			= @Asunto,
			@L_TB_IncluirDatosGenerales			BIT						= @IncluirDatosGenerales,
			@L_TB_IncluirIntervenciones			BIT						= @IncluirIntervenciones,
			@L_TB_IncluirNotificaciones			BIT						= @IncluirNotificaciones,
			@L_TB_IncluirDocumentosEscritos		BIT						= @IncluirDocumentosEscritos,
			@L_TC_Mensaje						VARCHAR(8000)			= @Mensaje,
			@L_TF_FechaEnvio					DATETIME2(7)			= @FechaEnvio,
			@L_TC_Estado						CHAR(1)					= @Estado,
			@L_TF_FechaRecepcion				DATETIME2(7)			= @FechaRecepcion,
			@L_TC_CodContexto					VARCHAR(4)				= @CodigoContexto,
			@L_TC_CodPuestoTrabajo				VARCHAR(14)				= @CodigoPuestoTrabajo,
			@L_TC_UsuarioRed					VARCHAR(30)				= @UsuarioRed,
			@L_TC_MensajeErrorEnvio				VARCHAR(255)			= @MensajeErrorEnvio

	--Cuerpo
	INSERT INTO	Expediente.EnvioCorreo	WITH (ROWLOCK)
	(
		TU_CodEnvioCorreo,					TC_NumeroExpediente,				TU_CodLegajo,					TC_CorreoPara,					
		TC_CorreosCopia,					TC_Asunto,							TB_IncluirDatosGenerales,		TB_IncluirIntervenciones,		
		TB_IncluirNotificaciones,			TB_IncluirDocumentosEscritos,		TC_Mensaje,						TF_FechaEnvio,					
		TC_Estado,							TF_FechaRecepcion,					TC_CodContexto,					TC_CodPuestoTrabajo,			
		TC_UsuarioRed,						TC_MensajeErrorEnvio
	)
	VALUES
	(
		@L_TU_CodEnvioCorreo,				@L_TC_NumeroExpediente,				@L_TU_CodLegajo,				@L_TC_CorreoPara,				
		@L_TC_CorreosCopia,					@L_TC_Asunto,						@L_TB_IncluirDatosGenerales,	@L_TB_IncluirIntervenciones,	
		@L_TB_IncluirNotificaciones,		@L_TB_IncluirDocumentosEscritos,	@L_TC_Mensaje,					@L_TF_FechaEnvio,				
		@L_TC_Estado,						@L_TF_FechaRecepcion,				@L_TC_CodContexto,				@L_TC_CodPuestoTrabajo,			
		@L_TC_UsuarioRed,					@L_TC_MensajeErrorEnvio
	)
END
GO
