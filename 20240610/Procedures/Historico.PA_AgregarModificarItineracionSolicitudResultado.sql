SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<04/11/2020>
-- Descripción:			<Permite agregar/modificar un registro en la tabla: ItineracionSolicitudResultado.>
-- ==================================================================================================================================================================================
-- Modificación:		<Luis Alonso Leiva Tames> <18/01/2021> <Se agrega el campo de CARPETA para asociar a los sistemas de Gestión>
-- Modificación:		<Karol Jiménez Sánchez> <28/01/2021> <Se valida si se agrega o actualiza el registro de ItineracionSolicitudResultado>
-- Modificación:		<Karol Jiménez Sánchez> <15/03/2021> <Se agrega el identificador IDACO del DACOSOL de Gestión a ItineracionSolicitudResultado>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarModificarItineracionSolicitudResultado]
	@CodItineracionSolicitud	UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@CodSolicitud				UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodResultadoSolicitud		UNIQUEIDENTIFIER	= NULL,
	@CodItineracionResultado	UNIQUEIDENTIFIER	= NULL,
	@CARPETA					CHAR(14)			= NULL,
	@CodigoSolicitudGestion		BIGINT				= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionSolicitud		UNIQUEIDENTIFIER		= @CodItineracionSolicitud,
			@L_TC_NumeroExpediente				CHAR(14)				= @NumeroExpediente,
			@L_TU_CodSolicitud					UNIQUEIDENTIFIER		= @CodSolicitud,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TU_CodResultadoSolicitud			UNIQUEIDENTIFIER		= @CodResultadoSolicitud,
			@L_TU_CodItineracionResultado		UNIQUEIDENTIFIER		= @CodItineracionResultado, 
			@L_CARPETA							CHAR(14)				= @CARPETA,
			@L_CodigoSolicitudGestion			BIGINT					= @CodigoSolicitudGestion

	--Cuerpo
	IF (NOT EXISTS (SELECT	* 
					FROM	Historico.ItineracionSolicitudResultado 
					WHERE	TU_CodItineracionSolicitud				= @CodItineracionSolicitud
					AND		TC_NumeroExpediente						= @NumeroExpediente
					AND		TU_CodSolicitud							= @CodSolicitud))
	BEGIN
	
		INSERT INTO	Historico.ItineracionSolicitudResultado	WITH (ROWLOCK)
		(
			TU_CodItineracionSolicitud,			TC_NumeroExpediente,			TU_CodSolicitud,				TU_CodLegajo,					
			TU_CodResultadoSolicitud,			TU_CodItineracionResultado,		CARPETA,
			IDACOSOL
		)
		VALUES
		(
			@L_TU_CodItineracionSolicitud,		@L_TC_NumeroExpediente,			@L_TU_CodSolicitud,				@L_TU_CodLegajo,				
			@L_TU_CodResultadoSolicitud,		@L_TU_CodItineracionResultado,	@CARPETA,
			@L_CodigoSolicitudGestion
		)
	END
	ELSE
	BEGIN
		UPDATE	Historico.ItineracionSolicitudResultado
		SET		TU_CodItineracionSolicitud				= @L_TU_CodItineracionSolicitud
		WHERE	TU_CodItineracionSolicitud				= @L_TU_CodItineracionSolicitud
		AND		TC_NumeroExpediente						= @L_TC_NumeroExpediente
		AND		TU_CodSolicitud							= @L_TU_CodSolicitud
	END
END
GO
