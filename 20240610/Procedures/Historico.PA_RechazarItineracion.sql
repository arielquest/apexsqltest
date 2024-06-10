SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creacion:		<20/11/2020>
-- Descripción:				<Modifica una itineracion para marcarla como rechazada> 
-- =========================================================================================================
-- Modificacion:			<21/05/2021> <Miguel Avendaño> <Se modifica para que cuando se rechace una itineracion el sistema permita crear una nueva itineracion con ese 
--															mismo expediente, legajo, recurso, solicitud>
-- Modificacion:			<09/11/2021> <Luis Alonso Leiva Tames> <Se modifica para que cuando se rechace una itineracion Tipo Resultado Recurso se puedan agregar documentos>
-- Modificacion:			<14/01/2022> <Luis Alonso Leiva Tames> <Se modifica para que cuando se rechace una itineracion Tipo Resultado Solicitud se puedan agregar documentos>
-- Modificacion:			<29/08/2022> <Aaron Rios Retana> <Bug 269091 - Se modifica para indicar el estado correcto de rechazo cuando se rechaza un recurso, ya que en SIAGPJ se habilitó para modificar un recurso rechazado>
-- Modificacion:			<19/10/2022> <Aaron Rios Retana> <HU 272357- Se modifica para indicar el estado correcto de rechazo cuando se rechaza un resultado de recurso>
CREATE Procedure [Historico].[PA_RechazarItineracion]
	@CodEstadoItineracion smallint,
	@DescripcionMotivoRechazoItineracion varchar(255),
	@CodMotivoRechazoItineracion smallint,
	@CodHistoricoItineracion uniqueidentifier,
	@CodEstadoItineracionPendienteEnviar smallint
AS
Begin

	--Actualiza el historico de itineracion
	UPDATE	[Historico].[Itineracion]
	SET		[TN_CodEstadoItineracion]					= @CodEstadoItineracion,
			[TF_FechaRechazo]							= GETDATE(),
			[TC_DescripcionMotivoRechazoItineracion]	= @DescripcionMotivoRechazoItineracion,
			[TN_CodMotivoRechazoItineracion]			= @CodMotivoRechazoItineracion
	WHERE	[TU_CodHistoricoItineracion]				= @CodHistoricoItineracion

	--Actualiza la tabla ExpedienteEntradaSalida para que en caso de rechazo se pueda volver a itinerar el expediente
	UPDATE	[Historico].[ExpedienteEntradaSalida]
	SET		[TF_CreacionItineracion]					= NULL,
			[TF_Salida]									= NULL,
			[TC_CodContextoDestino]						= NULL,
			[TN_CodMotivoItineracion]					= NULL,
			[TU_CodHistoricoItineracion]				= NULL
	WHERE	[TU_CodHistoricoItineracion]				= @CodHistoricoItineracion

	--Actualiza la tabla LegajoEntradaSalida para que en caso de rechazo se pueda volver a itinerar el legajo
	UPDATE	[Historico].[LegajoEntradaSalida]
	SET		[TF_CreacionItineracion]					= NULL,
			[TF_Salida]									= NULL,
			[TC_CodContextoDestino]						= NULL,
			[TN_CodMotivoItineracion]					= NULL,
			[TU_CodHistoricoItineracion]				= NULL
	WHERE	[TU_CodHistoricoItineracion]				= @CodHistoricoItineracion

	--Actualiza la tabla RecursoExpediente para que en caso de rechazo se pueda modificar y volver a itinerar el legajo
	UPDATE	[Expediente].[RecursoExpediente]
	SET		[TF_Fecha_Envio]							= NULL,
			[TF_Fecha_Recepcion]						= NULL,
			[TU_CodHistoricoItineracion]				= NULL,
			[TU_CodResultadoRecurso]					= NULL,
			[TN_CodEstadoItineracion]					= @CodEstadoItineracion
	WHERE	[TU_CodHistoricoItineracion]				= @CodHistoricoItineracion

	--Actualiza la tabla SolicitudExpediente para que en caso de rechazo se pueda volver a itinerar el legajo
	UPDATE	[Expediente].[SolicitudExpediente]
	SET		[TF_FechaEnvio]								= NULL,
			[TF_FechaRecepcion]							= NULL,
			[TU_CodHistoricoItineracion]				= NULL,
			[TU_CodResultadoSolicitud]					= NULL,
			[TN_CodEstadoItineracion]					= @CodEstadoItineracionPendienteEnviar
	WHERE	[TU_CodHistoricoItineracion]				= @CodHistoricoItineracion

	
	--Actualiza la tabla Expediente.ResultadoRecurso para en caso de rechazo 
	UPDATE	[Expediente].[ResultadoRecurso] 
	SET		[TN_CodEstadoItineracion]		= @CodEstadoItineracion
	WHERE	[TU_CodHistoricoItineracion]	= @CodHistoricoItineracion

		--Actualiza la tabla Expediente.ResultadoSolicitud para en caso de rechazo 
	UPDATE	[Expediente].[ResultadoSolicitud] 
	SET		[TN_CodEstadoItineracion]		= @CodEstadoItineracionPendienteEnviar
	WHERE	[TU_CodHistoricoItineracion]	= @CodHistoricoItineracion




End
GO
