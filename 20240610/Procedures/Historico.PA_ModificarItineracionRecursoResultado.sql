SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<04/11/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: ItineracionRecursoResultado.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ModificarItineracionRecursoResultado]
	@CodItineracionRecurso		UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodResultadoRecurso		UNIQUEIDENTIFIER	= NULL,
	@CodItineracionResultado	UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionRecurso		UNIQUEIDENTIFIER		= @CodItineracionRecurso,
			@L_TU_CodLegajo					UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER		= @CodResultadoRecurso,
			@L_TU_CodItineracionResultado	UNIQUEIDENTIFIER		= @CodItineracionResultado
	--Lógica
	UPDATE	Historico.ItineracionRecursoResultado	WITH (ROWLOCK)
	SET		TU_CodLegajo							= @L_TU_CodLegajo,
			TU_CodResultadoRecurso					= @L_TU_CodResultadoRecurso,
			TU_CodItineracionResultado				= @L_TU_CodItineracionResultado,
			TF_Actualizacion						= GETDATE()
	WHERE	TU_CodItineracionRecurso				= @L_TU_CodItineracionRecurso
END
GO
