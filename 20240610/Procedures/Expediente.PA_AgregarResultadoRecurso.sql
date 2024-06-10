SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<29/10/2020>
-- Descripción:			<Permite agregar un registro en la tabla: ResultadoRecurso.>
-- ==================================================================================================================================================================================
-- Modificación:		<08/03/2021><Karol Jiménez S.><Se agregan como parámetro la FechaCreacion, FechaEnvio y FechaRecepcion, para la creación de resultados recibidos de Gestión>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_AgregarResultadoRecurso]
	@CodResultadoRecurso		UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER,
	@CodResultadoLegajo			SMALLINT,
	@CodEstadoItineracion		SMALLINT,
	@CodContextoOrigen			VARCHAR(4),
	@UsuarioRed					VARCHAR(30),
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@CodMotivoItineracion		SMALLINT,
	@FechaCreacion				DATETIME2			= NULL,
	@FechaEnvio					DATETIME2			= NULL,
	@FechaRecepcion				DATETIME2			= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER	= @CodResultadoRecurso,
			@L_TU_CodLegajo					UNIQUEIDENTIFIER	= @CodLegajo,
			@L_TN_CodResultadoLegajo		SMALLINT			= @CodResultadoLegajo,
			@L_TN_CodEstadoItineracion		SMALLINT			= @CodEstadoItineracion,
			@L_TC_CodContextoOrigen			VARCHAR(4)			= @CodContextoOrigen,
			@L_TC_UsuarioRed				VARCHAR(30)			= @UsuarioRed,
			@L_TU_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_TN_CodMotivoItineracion		SMALLINT			= @CodMotivoItineracion,
			@L_TF_FechaCreacion				DATETIME2			= @FechaCreacion,
			@L_TF_FechaEnvio				DATETIME2			= @FechaEnvio,
			@L_TF_FechaRecepcion			DATETIME2			= @FechaRecepcion

	--Cuerpo
	INSERT INTO	Expediente.ResultadoRecurso	WITH (ROWLOCK)
	(
		TU_CodResultadoRecurso,					TU_CodLegajo,					TN_CodResultadoLegajo,			TN_CodEstadoItineracion,			
		TF_FechaCreacion,						TC_CodContextoOrigen,			TC_UsuarioRed,					TU_CodHistoricoItineracion,		
		TN_CodMotivoItineracion,				TF_FechaEnvio,					TF_FechaRecepcion
	)
	VALUES
	(
		@L_TU_CodResultadoRecurso,				@L_TU_CodLegajo,				@L_TN_CodResultadoLegajo,		@L_TN_CodEstadoItineracion,			
		ISNULL(@L_TF_FechaCreacion, GETDATE()),	@L_TC_CodContextoOrigen,		@L_TC_UsuarioRed,				@L_TU_CodHistoricoItineracion,	
		@L_TN_CodMotivoItineracion,				@L_TF_FechaEnvio,				@L_TF_FechaRecepcion			
	)
END
GO
