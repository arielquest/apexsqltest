SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<04/11/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: ItineracionSolicitudResultado.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ModificarItineracionSolicitudResultado]
	@CodItineracionSolicitud	UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodResultadoSolicitud		UNIQUEIDENTIFIER	= NULL,
	@CodItineracionResultado	UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionSolicitud		UNIQUEIDENTIFIER		= @CodItineracionSolicitud,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TU_CodResultadoSolicitud			UNIQUEIDENTIFIER		= @CodResultadoSolicitud,
			@L_TU_CodItineracionResultado		UNIQUEIDENTIFIER		= @CodItineracionResultado
	--Lógica
	UPDATE	Historico.ItineracionSolicitudResultado	WITH (ROWLOCK)
	SET		TU_CodLegajo							= @L_TU_CodLegajo,
			TU_CodResultadoSolicitud				= @L_TU_CodResultadoSolicitud,
			TU_CodItineracionResultado				= @L_TU_CodItineracionResultado,
			TF_Actualizacion						= GETDATE()
	WHERE	TU_CodItineracionSolicitud				= @L_TU_CodItineracionSolicitud
END
GO
