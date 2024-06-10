SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/08/2020>
-- Descripción :			<Se actualiza el recurso de expediente(estado, fecha de estado e Historico códgio itineración)>  
-- =================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro> <19/08/2020> <Se agrega el parametro estado.> 
-- Modificación:			<Aida Elena Siles Rojas> <24/08/2020> <Se agrega el parámetro FechaRecepcion>
-- Modificación:            <Aida Elena Siles Rojas> <25/09/2020> <Se agrega parámetro FechaEnvio>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ActualizarRecursoExpediente]
	@CodRecurso					UNIQUEIDENTIFIER,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@Estado						SMALLINT,
	@FechaRecepcion             DATETIME2(7) = NULL,
	@FechaEnvio					DATETIME2(7) = NULL
AS  
BEGIN 

	DECLARE @L_@CodRecurso					UNIQUEIDENTIFIER	= @CodRecurso
	DECLARE @L_CodHistoricoItineracion		UNIQUEIDENTIFIER	= @CodHistoricoItineracion
	DECLARE @L_EstadoItineracion			SMALLINT			= @Estado
	DECLARE @L_FechaRecepcion				DATETIME2(7)		= @FechaRecepcion

	IF (@L_FechaRecepcion IS NULL)
	BEGIN
		UPDATE [Expediente].[RecursoExpediente] WITH (ROWLOCK)
		SET		[TU_CodHistoricoItineracion]	= @L_CodHistoricoItineracion, 
				[TF_Fecha_Envio]				= @FechaEnvio,
				[TN_CodEstadoItineracion]		= @L_EstadoItineracion,
				[TF_Fecha_Recepcion]			= @L_FechaRecepcion
		WHERE	[TU_CodRecurso]					= @L_@CodRecurso
	END
	ELSE
	BEGIN
		UPDATE  [Expediente].[RecursoExpediente] WITH (ROWLOCK)
		SET		[TN_CodEstadoItineracion]		= @L_EstadoItineracion,
				[TF_Fecha_Recepcion]			= @L_FechaRecepcion
		WHERE	[TU_CodRecurso]					= @L_@CodRecurso
		AND		[TN_CodEstadoItineracion]       <> @L_EstadoItineracion
	END

END
GO
