SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<30/10/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: ResultadoRecurso.>
-- ==================================================================================================================================================================================
-- Modificación			<Aida Elena Siles Rojas> <06/11/2020> <Se agregan parámetros para actualizar historico itineración, estado itineración y fecha envio>
-- Modificación			<Ronny Ramírez R.> <23/08/2022> <Se quita COALESCE del campo TF_FechaEnvio, para permitir nulos, pues se debe anular el campo cuando hay un error de envío>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ModificarResultadoRecurso]
	@CodResultadoRecurso		UNIQUEIDENTIFIER,
	@CodResultadoLegajo			SMALLINT			= NULL,
	@UsuarioRed					VARCHAR(30)			= NULL,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER	= NULL,
	@CodEstadoItineracion		SMALLINT			= NULL,
	@FechaEnvio					DATETIME2(3)		= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER		= @CodResultadoRecurso,
			@L_TN_CodResultadoLegajo		SMALLINT				= @CodResultadoLegajo,
			@L_TC_UsuarioRed				VARCHAR(30)				= @UsuarioRed,
			@L_TU_CodHistoricoItineracion	UNIQUEIDENTIFIER		= @CodHistoricoItineracion,
			@L_TN_CodEstadoItineracion		SMALLINT				= @CodEstadoItineracion,
			@L_TF_FechaEnvio				DATETIME2(3)			= @FechaEnvio
	--Lógica
	--Lógica
	UPDATE	Expediente.ResultadoRecurso	WITH (ROWLOCK)
	SET		TN_CodResultadoLegajo		= COALESCE(@L_TN_CodResultadoLegajo, TN_CodResultadoLegajo),
			TC_UsuarioRed				= COALESCE(@L_TC_UsuarioRed, TC_UsuarioRed),
			TU_CodHistoricoItineracion	= COALESCE(@L_TU_CodHistoricoItineracion, TU_CodHistoricoItineracion),
			TN_CodEstadoItineracion		= COALESCE(@L_TN_CodEstadoItineracion, TN_CodEstadoItineracion),
			TF_FechaEnvio				= @L_TF_FechaEnvio
	WHERE	TU_CodResultadoRecurso		= @L_TU_CodResultadoRecurso
END
GO
