SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles R>
-- Fecha de creación:		<19/02/2021>
-- Descripción :			<Valida si un resultado recurso o de solicitud puede ser itinerado>  
-- =================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ValidarEnvioResultado]
	@CodResultadoRecurso			UNIQUEIDENTIFIER = NULL,	
	@CodResultadoSolicitud			UNIQUEIDENTIFIER = NULL,	
	@ConsultarDetalle				BIT = 0
AS  
BEGIN 
	DECLARE @L_SinDocumentoAsociado					INT	
	DECLARE @L_CodResultadoRecurso					UNIQUEIDENTIFIER	= @CodResultadoRecurso
	DECLARE @L_CodResultadoSolicitud				UNIQUEIDENTIFIER	= @CodResultadoSolicitud
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
		IF (@L_CodResultadoRecurso IS NOT NULL)
			BEGIN
			--Busca si el resultado recurso tiene documentos asociado
			SELECT	@L_SinDocumentoAsociado					= COUNT(A.TU_CodArchivo)
			FROM	Expediente.ResultadoRecursosArchivos	A WITH(NOLOCK)
			WHERE	A.TU_CodResultadoRecurso				= @L_CodResultadoRecurso
			END
		ELSE
			BEGIN
			--Busca si el resultado solicitud tiene documentos asociado
			SELECT	@L_SinDocumentoAsociado					= COUNT(A.TU_CodArchivo)
			FROM	Expediente.ResultadoSolicitudArchivos	A WITH(NOLOCK)
			WHERE	A.TU_CodResultadoSolicitud				= @L_CodResultadoSolicitud
			END
		
		IF (@L_SinDocumentoAsociado = 0)
			BEGIN
			INSERT INTO @ValidacionesItineracion (	ItineracionValida,	SinDocumentoAsociado	)
			VALUES								 (	0,					1						)
			END
		ELSE
			BEGIN
			INSERT INTO @ValidacionesItineracion ( ItineracionValida )
			VALUES								 ( 1				 )
			END
		END
	ELSE
		BEGIN
		IF (@L_CodResultadoRecurso IS NOT NULL)
			BEGIN
			--Busca si el resultado recurso tiene documentos asociado
			SELECT	@L_SinDocumentoAsociado					= COUNT(A.TU_CodArchivo)
			FROM	Expediente.ResultadoRecursosArchivos	A WITH(NOLOCK)
			WHERE	A.TU_CodResultadoRecurso				= @L_CodResultadoRecurso
			END
		ELSE
			BEGIN
			--Busca si el resultado solicitud tiene documentos asociado
			SELECT	@L_SinDocumentoAsociado					= COUNT(A.TU_CodArchivo)
			FROM	Expediente.ResultadoSolicitudArchivos	A WITH(NOLOCK)
			WHERE	A.TU_CodResultadoSolicitud				= @L_CodResultadoSolicitud
			END

		IF (@L_SinDocumentoAsociado > 0)
			INSERT INTO @ValidacionesItineracion (	ItineracionValida )
			VALUES								 (	1				  )
		ELSE
			BEGIN
			DECLARE @SinDocumentoAsociado		BIT = 0					

			IF (@L_SinDocumentoAsociado = 0)
				SET @SinDocumentoAsociado = 1

			INSERT INTO @ValidacionesItineracion (	ItineracionValida,	SinDocumentoAsociado	)
								VALUES			 (	0,					@SinDocumentoAsociado	)
			END
		END
	SELECT	*
	FROM	@ValidacionesItineracion
END
GO
