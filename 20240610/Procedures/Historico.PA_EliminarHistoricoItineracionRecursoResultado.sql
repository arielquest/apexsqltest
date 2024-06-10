SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<21/10/2021>
-- Descripción:			<Permite eliminar un registro de la tabla: ItineracionRecursoResultado>
-- ==================================================================================================================================================
-- Modificación:		<Ronny Ramírez R.> <11/01/2022> <Se aplica ajuste para eliminar registros de histórico itineracion recurso resultado, que
--						no tienen asociado el código de Histórico de itineración, por haber sido rechazados
-- ==================================================================================================================================================

CREATE PROCEDURE	[Historico].[PA_EliminarHistoricoItineracionRecursoResultado]
	@CodHistoricoItineracion		UNIQUEIDENTIFIER,
	@CodRecurso						UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionRecurso		UNIQUEIDENTIFIER		= 	@CodHistoricoItineracion,
			@L_TU_CodRecurso				UNIQUEIDENTIFIER		=	@CodRecurso
	
	--Lógica
	
	-- Si no tiene asociado el Código de Histórico Itineración (porque se hizo un rechazo), se manda a eliminar todos los registros asociados al Código de Recurso
	IF @L_TU_CodItineracionRecurso = CAST(0x0 AS UNIQUEIDENTIFIER)
	BEGIN
		DELETE
		FROM	Historico.ItineracionRecursoResultado WITH (ROWLOCK)
		WHERE	TU_CodRecurso										=	@L_TU_CodRecurso
	END
	ELSE -- Si se tiene el código de Histórico Itineración se manda a eliminar normalmente
	BEGIN
		DELETE
		FROM	Historico.ItineracionRecursoResultado WITH (ROWLOCK)
		WHERE	TU_CodItineracionRecurso							= @L_TU_CodItineracionRecurso
	END
	
END

GO
