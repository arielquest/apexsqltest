SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles R>
-- Fecha de creación:		<19/02/2021>
-- Descripción :			<Valida si un recurso puede ser itinerado>  
-- =================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ValidarEnvioRecurso]
	@CodRecurso						UNIQUEIDENTIFIER,	
	@ConsultarDetalle				BIT = 0
AS  
BEGIN 

	DECLARE @L_SinIntervenciones					INT
	DECLARE @L_SinDocumentoAsociado					UNIQUEIDENTIFIER
	DECLARE @L_CodRecurso							UNIQUEIDENTIFIER	= @CodRecurso
	DECLARE @L_ConsultarDetalle						BIT					= @ConsultarDetalle

	DECLARE @ValidacionesItineracion AS TABLE
	(
		ItineracionValida			BIT DEFAULT 0,
		ComunicacionesPendientes	BIT DEFAULT 0,
		NoFinalizado				BIT DEFAULT 0,
		Acumulados					BIT DEFAULT 0,
		DocumentosDifTerminado		BIT DEFAULT 0,
		EscritosDifResuelto			BIT DEFAULT 0,
		EventosPendientes			BIT DEFAULT 0,
		ResolucionesBorrador		BIT DEFAULT 0,
		SinIntervenciones			BIT DEFAULT 0,
		SinDocumentoAsociado		BIT DEFAULT 0
	)

	IF (@L_ConsultarDetalle = 0)
		BEGIN
			--Busca si tiene intervenciones asociadas
		SELECT	@L_SinIntervenciones					= COUNT(*)
		FROM	Expediente.IntervencionRecurso			A WITH(NOLOCK)
		WHERE	A.TU_CodRecurso							= @L_CodRecurso		
		
		IF (@L_SinIntervenciones = 0)
			BEGIN
				INSERT INTO @ValidacionesItineracion (	ItineracionValida,	SinIntervenciones	)
				VALUES								 (	0,					1					)
			END
		ELSE
			BEGIN
			----Busca si tiene resolución asociada
			SELECT		@L_SinDocumentoAsociado			= A.TU_CodResolucion
			FROM		Expediente.RecursoExpediente	A WITH(NOLOCK)
			WHERE		A.TU_CodRecurso					= @L_CodRecurso

			IF (@L_SinDocumentoAsociado IS NULL OR @L_SinDocumentoAsociado = '00000000-0000-0000-0000-000000000000')
				INSERT INTO @ValidacionesItineracion (	ItineracionValida,	SinDocumentoAsociado	)
				VALUES								 (	0,					1						)
			ELSE
				INSERT INTO @ValidacionesItineracion ( ItineracionValida )
				VALUES								 ( 1				 )
			END			
		END
	ELSE
		BEGIN
			--Busca si tiene intervenciones asociadas
		SELECT	@L_SinIntervenciones					= COUNT(*)
		FROM	Expediente.IntervencionRecurso			A WITH(NOLOCK)
		WHERE	A.TU_CodRecurso							= @L_CodRecurso	

		----Busca si tiene resolución asociada
		SELECT		@L_SinDocumentoAsociado			= A.TU_CodResolucion
		FROM		Expediente.RecursoExpediente	A WITH(NOLOCK)
		WHERE		A.TU_CodRecurso					= @L_CodRecurso

		IF (@L_SinIntervenciones > 0 AND (@L_SinDocumentoAsociado IS NOT NULL OR @L_SinDocumentoAsociado <> '00000000-0000-0000-0000-000000000000'))
			INSERT INTO @ValidacionesItineracion (	ItineracionValida )
			VALUES								 (	1				  )
		ELSE
			BEGIN
			DECLARE @SinIntervenciones			BIT = 0,
					@SinDocumentoAsociado		BIT = 0

			IF (@L_SinIntervenciones = 0)
				SET @SinIntervenciones = 1

			IF (@L_SinDocumentoAsociado IS NULL OR @L_SinDocumentoAsociado = '00000000-0000-0000-0000-000000000000')
				SET @SinDocumentoAsociado = 1

			INSERT INTO @ValidacionesItineracion (	ItineracionValida,	SinIntervenciones,		SinDocumentoAsociado	)
								VALUES			 (	0,					@SinIntervenciones,		@SinDocumentoAsociado	)
			END
		END
	SELECT	*
	FROM	@ValidacionesItineracion
END

GO
