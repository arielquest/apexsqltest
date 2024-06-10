SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Miguel Avendaño Rosales>
-- Fecha de creación:	<15/10/2021>
-- Descripción:			<Permite actualizar un registro en la tabla: EnvioCorreo.>
-- ==================================================================================================================================================================================
-- Modificación:		<20/10/2021> <Jose Miguel Avendaño Rosales> <Se modifica para actualizar tambien el mensaje de error de envio>
-- Modificación:		<21/10/2021> <Karol Jiménez Sánchez> <Se modifica para actualizar tambien contexto>
-- Modificación:		<17/11/2021> <Karol Jiménez Sánchez> <Se corrije tamaño de parámetros @CodigoContexto y @CodigoPuestoTrabajo>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ActualizarEnvioCorreo]
	@CodEnvioCorreo				UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14)			= NULL,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CorreoPara					VARCHAR(150)		= NULL,
	@CorreosCopia				VARCHAR(600)		= NULL,
	@Asunto						VARCHAR(255)		= NULL,
	@IncluirDatosGenerales		BIT					= NULL,
	@IncluirIntervenciones		BIT					= NULL,
	@IncluirNotificaciones		BIT					= NULL,
	@IncluirDocumentosEscritos	BIT					= NULL,
	@Mensaje					VARCHAR(8000)		= NULL,
	@FechaEnvio					DATETIME2(7)		= NULL,
	@Estado						CHAR(1)				= NULL,
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
	Update	Expediente.EnvioCorreo			WITH (ROWLOCK)
	Set		TC_NumeroExpediente				= COALESCE(@L_TC_NumeroExpediente, TC_NumeroExpediente),
			TU_CodLegajo					= COALESCE(@L_TU_CodLegajo, TU_CodLegajo),					
			TC_CorreoPara					= COALESCE(@L_TC_CorreoPara, TC_CorreoPara),					
			TC_CorreosCopia					= COALESCE(@L_TC_CorreosCopia, TC_CorreosCopia),
			TC_Asunto						= COALESCE(@L_TC_Asunto, TC_Asunto),
			TB_IncluirDatosGenerales		= COALESCE(@L_TB_IncluirDatosGenerales, TB_IncluirDatosGenerales),
			TB_IncluirIntervenciones		= COALESCE(@L_TB_IncluirIntervenciones, TB_IncluirIntervenciones),		
			TB_IncluirNotificaciones		= COALESCE(@L_TB_IncluirNotificaciones, TB_IncluirNotificaciones),
			TB_IncluirDocumentosEscritos	= COALESCE(@L_TB_IncluirDocumentosEscritos, TB_IncluirDocumentosEscritos),
			TC_Mensaje						= COALESCE(@L_TC_Mensaje, TC_Mensaje),
			TF_FechaEnvio					= COALESCE(@L_TF_FechaEnvio, TF_FechaEnvio),
			TC_Estado						= COALESCE(@L_TC_Estado, TC_Estado),
			TF_FechaRecepcion				= COALESCE(@L_TF_FechaRecepcion, TF_FechaRecepcion),
			TC_CodContexto					= COALESCE(@L_TC_CodContexto, TC_CodContexto),
			TC_CodPuestoTrabajo				= COALESCE(@L_TC_CodPuestoTrabajo, TC_CodPuestoTrabajo),
			TC_UsuarioRed					= COALESCE(@L_TC_UsuarioRed, TC_UsuarioRed),
			TC_MensajeErrorEnvio			= COALESCE(@L_TC_MensajeErrorEnvio, TC_MensajeErrorEnvio)
	Where	TU_CodEnvioCorreo				= @L_TU_CodEnvioCorreo
END
GO
