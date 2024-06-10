SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<25/10/2021>
-- Descripción:			<Permite eliminar un registro de la tabla: ItineracionSolicitudResultado>
-- ===================================================================================================================================================
-- Modificación:		<Ronny Ramírez R.> <11/01/2022> <Se aplica ajuste para eliminar registros de histórico itineracion solicitud resultado, que
--						no tienen asociado el código de Histórico de itineración, por haber sido rechazados> 
-- ===================================================================================================================================================

CREATE PROCEDURE	[Historico].[PA_EliminarHistoricoItineracionSolicitudResultado]
	@CodHistoricoItineracion		UNIQUEIDENTIFIER,
	@CodSolicitud					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionSolicitud		UNIQUEIDENTIFIER		= 	@CodHistoricoItineracion,
			@L_TU_CodSolicitud					UNIQUEIDENTIFIER		=	@CodSolicitud
	
	--Lógica
	
	-- Si no tiene asociado el Código de Histórico Itineración (porque se hizo un rechazo), se manda a eliminar todos los registros asociados al Código de Solicitud
	IF @L_TU_CodItineracionSolicitud = CAST(0x0 AS UNIQUEIDENTIFIER)
	BEGIN
		DELETE
		FROM	Historico.ItineracionSolicitudResultado WITH (ROWLOCK)
		WHERE	TU_CodSolicitud											=	@L_TU_CodSolicitud
	END
	ELSE -- Si se tiene el código de Histórico Itineración se manda a eliminar normalmente
	BEGIN
		DELETE	
		FROM	Historico.ItineracionSolicitudResultado WITH (ROWLOCK)
		WHERE	TU_CodItineracionSolicitud								= @L_TU_CodItineracionSolicitud
	END
	
END

GO
