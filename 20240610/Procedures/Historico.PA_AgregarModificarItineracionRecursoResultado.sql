SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles Rojas>
-- Fecha de creación:	<04/11/2020>
-- Descripción:			<Permite agregar/modificar un registro en la tabla: ItineracionRecursoResultado.>
-- ==================================================================================================================================================================================
-- Modificación:		<Luis Alonso Leiva Tames> <18/01/2021> <Se agrega el campo de CARPETA para asociar a los sistemas de Gestión>
-- Modificación:		<Karol Jiménez Sánchez> <28/01/2021> <Se valida si se agrega o actualiza el registro de ItineracionRecursoResultado>
-- Modificación:		<Ronny Ramírez R.> <04/03/2021> <Se agrega el identificador IDACOREC de Gestión a ItineracionRecursoResultado>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarModificarItineracionRecursoResultado]
	@CodItineracionRecurso		UNIQUEIDENTIFIER,
	@NumeroExpediente			CHAR(14),
	@CodRecurso					UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodResultadoRecurso		UNIQUEIDENTIFIER	= NULL,
	@CodItineracionResultado	UNIQUEIDENTIFIER	= NULL, 
	@CARPETA					CHAR(14)			= NULL,
	@CodigoRecursoGestion		BIGINT				= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodItineracionRecurso		UNIQUEIDENTIFIER		= @CodItineracionRecurso,
			@L_TC_NumeroExpediente			CHAR(14)				= @NumeroExpediente,
			@L_TU_CodRecurso				UNIQUEIDENTIFIER		= @CodRecurso,
			@L_TU_CodLegajo					UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER		= @CodResultadoRecurso,
			@L_TU_CodItineracionResultado	UNIQUEIDENTIFIER		= @CodItineracionResultado,
			@L_CARPETA						CHAR(14)				= @CARPETA,
			@L_CodigoRecursoGestion			BIGINT					= @CodigoRecursoGestion

	--Cuerpo
	IF (NOT	EXISTS(	SELECT	* 
					FROM	Historico.ItineracionRecursoResultado	WITH(NOLOCK) 
					WHERE	TU_CodItineracionRecurso				= @L_TU_CodItineracionRecurso
					AND		TC_NumeroExpediente						= @L_TC_NumeroExpediente
					AND		TU_CodRecurso							= @L_TU_CodRecurso))
	BEGIN
		INSERT INTO	Historico.ItineracionRecursoResultado	WITH (ROWLOCK)
		(
			TU_CodItineracionRecurso,			TC_NumeroExpediente,			TU_CodRecurso,		TU_CodLegajo,					
			TU_CodResultadoRecurso,				TU_CodItineracionResultado,		CARPETA,			IDACOREC	
		)
		VALUES
		(
			@L_TU_CodItineracionRecurso,		@L_TC_NumeroExpediente,			@L_TU_CodRecurso,	@L_TU_CodLegajo,				
			@L_TU_CodResultadoRecurso,			@L_TU_CodItineracionResultado,  @L_CARPETA,			@L_CodigoRecursoGestion		
		)
	END
	ELSE
	BEGIN
		UPDATE	Historico.ItineracionRecursoResultado
		SET		TU_CodItineracionRecurso				= @L_TU_CodItineracionRecurso
		WHERE	TU_CodItineracionRecurso				= @L_TU_CodItineracionRecurso
		AND		TC_NumeroExpediente						= @L_TC_NumeroExpediente
		AND		TU_CodRecurso							= @L_TU_CodRecurso
	END
END
GO
