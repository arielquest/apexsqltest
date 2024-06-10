SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<10/09/2020>
-- Descripción :			<Valida si un legajo puede ser itinerado>  
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <19/02/2021> <Validaciones de itineración PBI 149983>
-- Modificación:			<Ronny Ramírez R.> <09/07/2021> <Se elimina validación de documentos, resoluciones y/o recursos que no estén terminados 
--							a solicitud de jefatura, y según lo visto con Stephanie de implantaciones>
-- =================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ValidarEnvioLegajo]
	@CodigoLegajo					UNIQUEIDENTIFIER,
	@Contexto						VARCHAR(4),
	@EstadoComunicacionEntregada	CHAR(1),
	@MovimientoCirtulanteTerminado	CHAR(1),
	@ConsultarDetalle				BIT = 0
	
AS  
BEGIN 

	DECLARE @L_TieneComunicionesPendientes			INT
	DECLARE @L_EstaFinalizadoEstadisticamente		INT
	DECLARE @L_TieneEventosPendientes				INT
	DECLARE @L_CodigoLegajo							UNIQUEIDENTIFIER	= @CodigoLegajo
	DECLARE @L_Contexto								VARCHAR(4)			= @Contexto
	DECLARE @L_EstadoComunicacionEntregada			CHAR(1)				= @EstadoComunicacionEntregada
	DECLARE @L_MovimientoCirtulanteTerminado		CHAR(1)				= @MovimientoCirtulanteTerminado
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
			--Busca si esta finalizado estadisticamente
			SELECT	@L_EstaFinalizadoEstadisticamente		= COUNT(*)
			FROM	Historico.LegajoMovimientoCirculante	A WITH(NOLOCK)
			WHERE	A.TU_CodLegajo							= @L_CodigoLegajo
			AND		A.TC_Movimiento							= @L_MovimientoCirtulanteTerminado
			AND		A.TC_CodContexto						= @L_Contexto
			AND		A.TF_Fecha								= ( SELECT MAX(Historico.LegajoMovimientoCirculante.TF_Fecha)
																FROM   Historico.LegajoMovimientoCirculante WITH(NOLOCK)
																WHERE  Historico.LegajoMovimientoCirculante.TU_CodLegajo	= @L_CodigoLegajo
																AND    Historico.LegajoMovimientoCirculante.TC_CodContexto	= @L_Contexto)
		
			IF (@L_EstaFinalizadoEstadisticamente = 0)
				BEGIN
					INSERT INTO @ValidacionesItineracion (	ItineracionValida,	NoFinalizado	)
					VALUES								 (	0,					1				)
				END
			ELSE
				BEGIN					
					INSERT INTO @ValidacionesItineracion	( ItineracionValida )
					VALUES									( 1				 )
				END
		END
	ELSE
		BEGIN
			--Busca si esta finalizado estadísticamente
			SELECT	@L_EstaFinalizadoEstadisticamente		= COUNT(*)
			FROM	Historico.LegajoMovimientoCirculante	A WITH(NOLOCK)
			WHERE	A.TU_CodLegajo							= @L_CodigoLegajo
			AND		A.TC_Movimiento							= @L_MovimientoCirtulanteTerminado
			AND		A.TC_CodContexto						= @L_Contexto
			AND		A.TF_Fecha								= ( SELECT MAX(Historico.LegajoMovimientoCirculante.TF_Fecha)
																FROM   Historico.LegajoMovimientoCirculante WITH(NOLOCK)
																WHERE  Historico.LegajoMovimientoCirculante.TU_CodLegajo	= @L_CodigoLegajo
																AND    Historico.LegajoMovimientoCirculante.TC_CodContexto	= @L_Contexto)
			

			IF	@L_EstaFinalizadoEstadisticamente			= 1				
					INSERT INTO @ValidacionesItineracion (	ItineracionValida )
					VALUES								 (	1				  )
			ELSE
				BEGIN
					DECLARE @NoFinalizado				BIT = 0

					IF (@L_EstaFinalizadoEstadisticamente = 0)
						SET @NoFinalizado = 1					

					INSERT INTO @ValidacionesItineracion (	
															ItineracionValida,		NoFinalizado
														 )
										VALUES			 (	
															0,						@NoFinalizado
														 )
				END
		END


		SELECT	*
		FROM	@ValidacionesItineracion
END
GO
