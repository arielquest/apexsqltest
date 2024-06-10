SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<19-01-2021>
-- Descripción :			<Obtiene el número de expediente y/o código de legajo asociado al envío de una itineración de SIAGPJ> 
-- =================================================================================================================================================
-- Modificación :			<09/02/2021><Karol Jiménez S.><Se retorna la carpeta del expediente o legajo> 
-- Modificación :			<17/02/2021><Ronny Ramírez R.><Se retorna el contexto de origen de la itineración> 
-- Modificación :			<19/04/2023><Karol Jiménez S.><Se retorna carpeta de legajo, cuando el recurso es de un legajo. Bug 311655> 
-- =================================================================================================================================================
CREATE FUNCTION [Itineracion].[FN_ConsultarExpLegajoHistoricoItineracion]
(
	@CodHistoricoItineracion		UNIQUEIDENTIFIER
)
RETURNS @Resultado  TABLE (
						TC_NumeroExpediente			CHAR(14)			NOT NULL,
						TU_CodLegajo				UNIQUEIDENTIFIER	NULL,
						CARPETA						VARCHAR(14)			NULL,
						TC_CodContextoOrigen		VARCHAR(4)			NULL)
AS
BEGIN
	DECLARE @L_TN_CodTipoItineracionExpediente			AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionExpediente', '')),
			@L_TN_CodTipoItineracionLegajo				AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionLegajo', '')),
			@L_TN_CodTipoItineracionRecurso				AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionRecurso', '')),
			@L_TN_CodTipoItineracionSolicitud			AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionSolicitud', '')),
			@L_TN_CodTipoItineracionResultadoRecurso	AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionResultadoR', '')),
			@L_TN_CodTipoItineracionResultadoSolicitud	AS SMALLINT = CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_TipoItineracionResultadoS', ''));

	INSERT INTO @Resultado
	SELECT		A.TC_NumeroExpediente,
				CASE 
					WHEN A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionExpediente  
							OR A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionSolicitud --SOLICITUDES SOLO SE CREAN EN EXPEDIENTES
						THEN NULL
					WHEN A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionLegajo THEN B.TU_CodLegajo
					WHEN A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionResultadoRecurso THEN C.TU_CodLegajo
					WHEN A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionResultadoSolicitud THEN D.TU_CodLegajo
					WHEN A.TN_CodTipoItineracion = @L_TN_CodTipoItineracionRecurso THEN R.TU_CodLegajo
				END										TU_CodLegajo,
				NULL									CARPETA,
				A.TC_CodContextoOrigen
	FROM		Historico.Itineracion					A WITH(NOLOCK)
	LEFT JOIN	Historico.LegajoEntradaSalida			B WITH(NOLOCK)
	ON			B.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	LEFT JOIN	Expediente.ResultadoRecurso				C WITH(NOLOCK)
	ON			C.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	LEFT JOIN	Expediente.ResultadoSolicitud			D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	LEFT JOIN	Expediente.RecursoExpediente			R WITH(NOLOCK)
	ON			R.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	WHERE		A.TU_CodHistoricoItineracion			= @CodHistoricoItineracion

	UPDATE		A		
	SET			CARPETA =	CASE 
								WHEN A.TU_CodLegajo IS NOT NULL THEN B.CARPETA
								ELSE C.CARPETA
							END		
	FROM		@Resultado				A
	LEFT JOIN	Expediente.Legajo		B WITH(NOLOCK)
	ON			B.TU_CodLegajo			= A.TU_CodLegajo
	LEFT JOIN	Expediente.Expediente	C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente	= A.TC_NumeroExpediente

	Return
END
GO
