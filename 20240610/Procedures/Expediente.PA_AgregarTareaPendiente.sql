SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<03/11/2020>
-- Descripción:			<Permite agregar un registro en la tabla: TareaPendiente.>
-- ==================================================================================================================================================================================
-- Modificado por:		<17/11/2020><Jose Gabriel Cordero Soto><Se actualiza el agregar tarea pendiente eliminando parametro @Actualizacion dado que es valor por defecto>
-- Modificado por:		<18/11/2020><Jose Gabriel Cordero Soto><Se ajusta el calculo de la fecha vence con base en la funcion de PlazoDiasFechaVence>
-- Modificado por:		<27/04/2021><Karol Jiménez Sánchez><Se agrega columna TC_CodContexto, a solicitud de SIGMA>
-- Modificado por:		<20/08/2021><Aida Elena Siles R><Se agrega último parámetro al llamado de la funcion Expediente.FN_PlazoDiasFechaVence>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[Expediente].[PA_AgregarTareaPendiente]
	@CodTareaPendiente			UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14)			= NULL,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@Recibido					DATETIME2(3),	
	@Mensaje					VARCHAR(150),
	@CodPuestoTrabajoOrigen		VARCHAR(14),
	@UsuarioRedOrigen			VARCHAR(30),
	@CodTarea					SMALLINT,
	@CodPuestoTrabajoDestino	VARCHAR(14),
	@CodTareaPendienteAnterior	UNIQUEIDENTIFIER	= NULL,
	@Finalizacion				DATETIME2(3)		= NULL,
	@UsuarioRedFinaliza			VARCHAR(30)			= NULL,
	@Reasignacion				DATETIME2(3)		= NULL,
	@UsuarioRedReasigna			VARCHAR(30)			= NULL,
	@CodigoOficina				VARCHAR(4),
	@CodigoMateria				VARCHAR(5),
	@CodigoTipoOficina			SMALLINT,
	@CodigoContexto				VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTareaPendiente			UNIQUEIDENTIFIER		= @CodTareaPendiente,
			@L_TC_NumeroExpediente			CHAR(14)				= @NumeroExpediente,
			@L_TU_CodLegajo					UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TF_Recibido					DATETIME2(3)			= @Recibido,
			@L_TN_CodTarea					SMALLINT				= @CodTarea,
			@L_TC_CodOficina				VARCHAR(4)				= @CodigoOficina,
			@L_TC_CodMateria				VARCHAR(5)				= @CodigoMateria,
			@L_TN_CodTipoOficina			SMALLINT				= @CodigoTipoOficina,
			@L_TF_Vence						DATETIME2(3),			
			@L_TC_Mensaje					VARCHAR(150)			= @Mensaje,
			@L_TC_CodPuestoTrabajoOrigen	VARCHAR(14)				= @CodPuestoTrabajoOrigen,
			@L_TC_UsuarioRedOrigen			VARCHAR(30)				= @UsuarioRedOrigen,			
			@L_TC_CodPuestoTrabajoDestino	VARCHAR(14)				= @CodPuestoTrabajoDestino,
			@L_TU_CodTareaPendienteAnterior	UNIQUEIDENTIFIER		= @CodTareaPendienteAnterior,
			@L_TF_Finalizacion				DATETIME2(3)			= @Finalizacion,
			@L_TC_UsuarioRedFinaliza		VARCHAR(30)				= @UsuarioRedFinaliza,
			@L_TF_Reasignacion				DATETIME2(3)			= @Reasignacion,
			@L_TC_UsuarioRedReasigna		VARCHAR(30)				= @UsuarioRedReasigna,
			@L_TC_CodContexto				VARCHAR(4)				= @CodigoContexto
			
	--Cuerpo

	--Calcula fecha vencimiento
	SET @L_TF_Vence = (SELECT [Expediente].[FN_PlazoDiasFechaVence] (@L_TN_CodTarea, @L_TC_CodMateria, @L_TC_CodOficina, @L_TN_CodTipoOficina, @L_TF_Recibido, 0))

	INSERT INTO	Expediente.TareaPendiente	WITH (ROWLOCK)
	(
		TU_CodTareaPendiente,			TC_NumeroExpediente,			TU_CodLegajo,					TF_Recibido,					
		TF_Vence,						TC_Mensaje,						TC_CodPuestoTrabajoOrigen,		TC_UsuarioRedOrigen,			
		TN_CodTarea,					TC_CodPuestoTrabajoDestino,		TU_CodTareaPendienteAnterior,	TF_Finalizacion,				
		TC_UsuarioRedFinaliza,			TF_Reasignacion,				TC_UsuarioRedReasigna,			TC_CodContexto
	)
	VALUES
	(
		@L_TU_CodTareaPendiente,		@L_TC_NumeroExpediente,			@L_TU_CodLegajo,					@L_TF_Recibido,					
		@L_TF_Vence,					@L_TC_Mensaje,					@L_TC_CodPuestoTrabajoOrigen,		@L_TC_UsuarioRedOrigen,			
		@L_TN_CodTarea,					@L_TC_CodPuestoTrabajoDestino,	@L_TU_CodTareaPendienteAnterior,	@L_TF_Finalizacion,				
		@L_TC_UsuarioRedFinaliza,		@L_TF_Reasignacion,				@L_TC_UsuarioRedReasigna,			@L_TC_CodContexto					
	)
END
GO
