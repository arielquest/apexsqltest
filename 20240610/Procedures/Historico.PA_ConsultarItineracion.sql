SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<08/06/2021>
-- Descripción:			<Permite consultar un registro en la tabla: Historico.Itineracion, por el CodHistoricoItineracion o por IdNautius>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ConsultarItineracion]
	@CodHistoricoItineracion		UNIQUEIDENTIFIER,
	@IdNautius						UNIQUEIDENTIFIER 
AS
BEGIN
	--Variables
	DECLARE				@L_TU_CodHistoricoItineracion		UNIQUEIDENTIFIER		= @CodHistoricoItineracion,
						@L_IdNautius						UNIQUEIDENTIFIER		= @IdNautius
	--Lógica
	SELECT	A.TU_CodHistoricoItineracion				Codigo,
			A.TC_NumeroExpediente						NumeroExpediente,
			A.TF_FechaEstado							FechaEstado,
			A.TC_MensajeError							MensajeError,
			A.CARPETA									CarpetaGestion,
			A.TU_CodHistoricoItineracionPadre			CodigoHistoricoItineracionPadre,
			A.TC_DescripcionMotivoRechazoItineracion	DescripcionMotivoRechazo,
			A.TN_CodEstadoItineracion					EstadoItineracion,
			A.TF_FechaRechazo							FechaRechazo,
			A.ID_NAUTIUS								IdNautius,
			'SplitTipoItineracion'						SplitTipoItineracion,
			A.TN_CodTipoItineracion						Codigo,
			'SplitContextoOrigen'						SplitContextoOrigen,
			A.TC_CodContextoOrigen						Codigo,
			'SplitContextoDestino'						SplitContextoDestino,
			A.TC_CodContextoDestino						Codigo,
			'SplitFuncionario'							SplitFuncionario,
			A.TC_UsuarioRed								UsuarioRed,
			'SplitMotivoRechazo'						SplitMotivoRechazo,
			A.TN_CodMotivoRechazoItineracion			Codigo
	FROM	Historico.Itineracion						A WITH (NOLOCK)
	WHERE	TU_CodHistoricoItineracion					= COALESCE(@L_TU_CodHistoricoItineracion, TU_CodHistoricoItineracion)
	AND		ID_NAUTIUS									= COALESCE(@L_IdNautius, ID_NAUTIUS)
END



GO
