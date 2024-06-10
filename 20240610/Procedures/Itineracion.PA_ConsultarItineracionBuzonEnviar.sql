SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<28/01/2021>
-- Descripción:			<Consulta la itineración para validar si ya fue enviada>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ConsultarItineracionBuzonEnviar]
    @CodExpedienteEntradaSalida UNIQUEIDENTIFIER = NULL,
	@CodLegajoEntradaSalida		UNIQUEIDENTIFIER = NULL,
	@CodRecurso					UNIQUEIDENTIFIER = NULL,
	@CodSolicitud				UNIQUEIDENTIFIER = NULL,
	@CodResultadoRecurso		UNIQUEIDENTIFIER = NULL,
	@CodResultadoSolicitud		UNIQUEIDENTIFIER = NULL
AS
BEGIN
--variables
DECLARE		@L_CodExpedienteEntradaSalida	UNIQUEIDENTIFIER = @CodExpedienteEntradaSalida,
			@L_CodLegajoEntradaSalida		UNIQUEIDENTIFIER = @CodLegajoEntradaSalida,
			@L_CodRecurso					UNIQUEIDENTIFIER = @CodRecurso,
			@L_CodSolicitud					UNIQUEIDENTIFIER = @CodSolicitud,
			@L_CodResultadoRecurso			UNIQUEIDENTIFIER = @CodResultadoRecurso,
			@L_CodResultadoSolicitud		UNIQUEIDENTIFIER = @CodResultadoSolicitud

IF (@L_CodExpedienteEntradaSalida IS NOT NULL)
	BEGIN
		SELECT		A.TF_CreacionItineracion			AS	FechaCreacion,
					A.TF_Salida							AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion
		FROM		Historico.ExpedienteEntradaSalida	A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodExpedienteEntradaSalida		= @L_CodExpedienteEntradaSalida
	END
ELSE IF (@L_CodLegajoEntradaSalida IS NOT NULL)
	BEGIN
		SELECT		A.TF_CreacionItineracion			AS	FechaCreacion,
					A.TF_Salida							AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion			 
		FROM		Historico.LegajoEntradaSalida		A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodLegajoEntradaSalida			= @L_CodLegajoEntradaSalida
	END
ELSE IF (@L_CodRecurso IS NOT NULL)
	BEGIN
		SELECT		A.TF_Fecha_Creacion					AS	FechaCreacion,
					A.TF_Fecha_Envio					AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion
		FROM		Expediente.RecursoExpediente		A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodRecurso						= @L_CodRecurso
	END
ELSE IF (@L_CodSolicitud IS NOT NULL)
	BEGIN
		SELECT		A.TF_FechaCreacion					AS	FechaCreacion,
					A.TF_FechaEnvio						AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion
		FROM		Expediente.SolicitudExpediente		A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodSolicitudExpediente			= @L_CodSolicitud
	END
ELSE IF (@L_CodResultadoRecurso IS NOT NULL)
	BEGIN
		SELECT		A.TF_FechaCreacion					AS	FechaCreacion,
					A.TF_FechaEnvio						AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion
		FROM		Expediente.ResultadoRecurso			A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodResultadoRecurso			= @L_CodResultadoRecurso
	END
ELSE IF (@L_CodResultadoSolicitud IS NOT NULL)
	BEGIN
		SELECT		A.TF_FechaCreacion					AS	FechaCreacion,
					A.TF_FechaEnvio						AS	FechaEnvio,					
					'Split'								AS	Split,
					B.TN_CodEstadoItineracion			AS	CodEstadoItineracion
		FROM		Expediente.ResultadoSolicitud		A WITH(NOLOCK)
		LEFT JOIN	Historico.Itineracion				B WITH(NOLOCK)
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		A.TU_CodResultadoSolicitud			= @L_CodResultadoSolicitud
	END
END
GO
