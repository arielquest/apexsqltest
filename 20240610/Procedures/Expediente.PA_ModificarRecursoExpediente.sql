SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<12/02/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: RecursoExpediente.>
-- ==================================================================================================================================================================================
-- Modificación			<13/02/2020> <Jonathan Aguilar Navarro> <Se quitant los parametros de NumeroExpedinete y FechaCreacion> 
-- Modificación			<02/02/2021> <Daniel Ruiz Hernández> <Se cambia el tipo de dato al codClaseAsunto de smallint a int> 
-- Modificación			<29/08/2022> <Aaron Rios Retana> <Bug 269091 -Se añade el parametro CodEstadoItineracion para actualizar el estado de la itineracion> 
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ModificarRecursoExpediente]
	@CodRecurso					UNIQUEIDENTIFIER,
	@CodClaseAsunto				INT,
	@CodContextoDestino			VARCHAR(4),
	@CodTipoIntervencion		SMALLINT,
	@CodResolucion				UNIQUEIDENTIFIER	= NULL,
	@Fecha_Envio				DATETIME2(3)		= NULL,
	@Fecha_Recepcion			DATETIME2(3)		= NULL,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER	= NULL,
	@CodResultadoRecurso		UNIQUEIDENTIFIER	= NULL,
	@CodMotivoItineracion		SMALLINT			= NULL,
	@CodEstadoItineracion		SMALLINT			= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodRecurso				UNIQUEIDENTIFIER		= @CodRecurso,
			@L_TN_CodClaseAsunto			INT						= @CodClaseAsunto,
			@L_TC_CodContextoDestino		VARCHAR(4)				= @CodContextoDestino,
			@L_TN_CodTipoIntervencion		SMALLINT				= @CodTipoIntervencion,
			@L_TU_CodResolucion				UNIQUEIDENTIFIER		= @CodResolucion,
			@L_TF_Fecha_Envio				DATETIME2(3)			= @Fecha_Envio,
			@L_TF_Fecha_Recepcion			DATETIME2(3)			= @Fecha_Recepcion,
			@L_TU_CodHistoricoItineracion	UNIQUEIDENTIFIER		= @CodHistoricoItineracion,
			@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER		= @CodResultadoRecurso,
			@L_TN_CodMotivoItineracion		SMALLINT				= @CodMotivoItineracion,
			@L_TN_CodEstadoItineracion		SMALLINT				= @CodEstadoItineracion
	--Lógica
	UPDATE	Expediente.RecursoExpediente	WITH (ROWLOCK)
	SET		TN_CodClaseAsunto										= @L_TN_CodClaseAsunto,
			TC_CodContextoDestino									= @L_TC_CodContextoDestino,
			TN_CodTipoIntervencion									= @L_TN_CodTipoIntervencion,
			TU_CodResolucion										= @L_TU_CodResolucion,
			TF_Fecha_Envio											= @L_TF_Fecha_Envio,
			TF_Fecha_Recepcion										= @L_TF_Fecha_Recepcion,
			TU_CodHistoricoItineracion								= @L_TU_CodHistoricoItineracion,
			TU_CodResultadoRecurso									= @L_TU_CodResultadoRecurso,
			TN_CodMotivoItineracion									= @L_TN_CodMotivoItineracion,
			TN_CodEstadoItineracion									= @L_TN_CodEstadoItineracion
	WHERE	TU_CodRecurso											= @L_TU_CodRecurso
END
GO
