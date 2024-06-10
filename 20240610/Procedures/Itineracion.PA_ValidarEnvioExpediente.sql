SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<10/06/2020>
-- Descripción :			<Valida si un expediente puede ser itinerado>  
-- =================================================================================================================================================
-- Modificación:			<22/01/2021> <Aida Elena Siles R> <Corrección validación expediente finalizado. BUG 169921>
-- Modificación:			<27/01/2021> <Aida Elena Siles R> <Corrección validación documentos en terminado. BUG 170005>
-- Modificación:			<27/01/2021> <Aida Elena Siles R> <Corrección validación documentos en terminado. BUG 170008>
-- Modificación:			<18/02/2021> <Aida Elena Siles R> <Validaciones de itineración PBI 149983>
-- Modificación:			<24/06/2021> <Luis Alonso Leiva Tames> <Se elimina la validacion de los documentos sea distinta a terminado>
-- Modificación:			<09/07/2021> <Ronny Ramírez R.> <Se elimina validación de documentos, resoluciones y/o recursos que no estén terminados 
--							a solicitud de jefatura, y según lo visto con Stephanie de implantaciones>
-- =================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ValidarEnvioExpediente]
	@NumeroExpediente				VARCHAR(14),
	@Contexto						VARCHAR(4),
	@EstadoComunicacionEntregada	CHAR(1),
	@MovimientoCirtulanteTerminado	CHAR(1),
	@ConsultarDetalle				BIT = 0
AS  
BEGIN 

	DECLARE @L_TieneComunicionesPendientes		INT
	DECLARE @L_EstaFinalizadoEstadisticamente	INT
	DECLARE @L_EstaAcumulado					INT
	DECLARE @L_TieneEventosPendientes			INT
	DECLARE @L_NumeroExpediente					VARCHAR(14) = @NumeroExpediente
	DECLARE @L_Contexto							VARCHAR(4)	= @Contexto
	DECLARE @L_EstadoComunicacionEntregada		CHAR(1)		= @EstadoComunicacionEntregada
	DECLARE @L_MovimientoCirtulanteTerminado	CHAR(1)		= @MovimientoCirtulanteTerminado
	DECLARE @L_ConsultarDetalle					BIT			= @ConsultarDetalle

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
			--Busca las comunicaciones pendientes de le expediente
			SELECT	@L_TieneComunicionesPendientes = COUNT([TU_CodComunicacion])
			FROM	[Comunicacion].[Comunicacion]	WITH(NOLOCK)
			WHERE	[TC_NumeroExpediente]			= @L_NumeroExpediente
			AND		TC_CodContexto					= @L_Contexto
			AND		[TC_Estado]						<> @L_EstadoComunicacionEntregada
			AND		TU_CodLegajo					IS NULL

			IF (@L_TieneComunicionesPendientes > 0)
				BEGIN
					INSERT INTO @ValidacionesItineracion (	ItineracionValida,	ComunicacionesPendientes	)
					VALUES								 (	0,					1							)
				END
			ELSE
				BEGIN
					--Busca si esta finalizado estadisticamente
					SELECT	@L_EstaFinalizadoEstadisticamente			= COUNT(*)
					FROM	Historico.ExpedienteMovimientoCirculante	AS A WITH(NOLOCK)
					OUTER APPLY											( SELECT TOP 1 B.TN_CodExpedienteMovimientoCirculante 
																			FROM Historico.ExpedienteMovimientoCirculante AS B WITH(NOLOCK)
																			WHERE B.TC_NumeroExpediente	= @L_NumeroExpediente
																			AND	B.TC_CodContexto		= @L_Contexto
																			AND	B.TC_Movimiento			= @L_MovimientoCirtulanteTerminado
																			ORDER BY B.TF_Fecha DESC ) HMC
					WHERE	HMC.TN_CodExpedienteMovimientoCirculante	= A.TN_CodExpedienteMovimientoCirculante

					IF (@L_EstaFinalizadoEstadisticamente = 0)
						BEGIN
							INSERT INTO @ValidacionesItineracion (	ItineracionValida,	NoFinalizado	)
							VALUES								 (	0,					1				)
						END
					ELSE
						BEGIN
							--Busca si tiene otros expedientes acumulados 
							SELECT	@L_EstaAcumulado = COUNT(TU_CodAcumulacion) 
							FROM	Historico.ExpedienteAcumulacion		WITH(NOLOCK)
							WHERE	TC_NumeroExpediente					= @L_NumeroExpediente
							AND		TF_FinAcumulacion					IS NULL
							AND		TC_CodContexto						= @L_Contexto
							AND		TF_InicioAcumulacion				= (	SELECT  MAX(TF_InicioAcumulacion) 
																			FROM	Historico.ExpedienteAcumulacion WITH(NOLOCK)
																			WHERE	TC_NumeroExpediente				= @L_NumeroExpediente)

							IF (@L_EstaAcumulado > 0)
								BEGIN
									INSERT INTO @ValidacionesItineracion (	ItineracionValida,	Acumulados	)
									VALUES								 (	0,					1			)
								END
							ELSE
								BEGIN
									--Busca si tiene eventos pendientes
									SELECT @L_TieneEventosPendientes = COUNT([TU_CodEvento])
									FROM	[Agenda].[Evento]								A WITH(NOLOCK)
									JOIN	[Catalogo].[EstadoEvento]						B WITH(NOLOCK)
									ON		A.TN_CodEstadoEvento							= B.TN_CodEstadoEvento
									WHERE	B.TB_FinalizaEvento								= 0
									AND		A.TC_NumeroExpediente							= @L_NumeroExpediente
									AND		A.TC_CodContexto								= @L_Contexto

									IF (@L_TieneEventosPendientes > 0)
										BEGIN
											INSERT INTO @ValidacionesItineracion (	ItineracionValida,	EventosPendientes	)
											VALUES								 (	0,					1					)
										END
									ELSE
										BEGIN
											INSERT INTO @ValidacionesItineracion (	
																					ItineracionValida,		ComunicacionesPendientes,	NoFinalizado,		Acumulados,
																					DocumentosDifTerminado,	EscritosDifResuelto,		EventosPendientes
																					)
											VALUES								 (	
																					1,						0,							0,					0,
																					0,						0,							0
																					)
										END

								END
						END
				END
		END	 
	ELSE
		BEGIN
			--Busca las comunicaciones pendientes de expediente
			SELECT	@L_TieneComunicionesPendientes = COUNT([TU_CodComunicacion])
			FROM	[Comunicacion].[Comunicacion]	WITH(NOLOCK)
			WHERE	[TC_NumeroExpediente]			= @L_NumeroExpediente
			AND		TC_CodContexto					= @L_Contexto
			AND		[TC_Estado]						<> @L_EstadoComunicacionEntregada
	
			--Busca si esta finalizado estadisticamente
			SELECT	@L_EstaFinalizadoEstadisticamente			= COUNT(*)
			FROM	Historico.ExpedienteMovimientoCirculante	AS A WITH(NOLOCK)
			OUTER APPLY											( SELECT TOP 1 B.TN_CodExpedienteMovimientoCirculante 
																  FROM Historico.ExpedienteMovimientoCirculante AS B WITH(NOLOCK)
																  WHERE B.TC_NumeroExpediente	= @L_NumeroExpediente
																  AND	B.TC_CodContexto		= @L_Contexto
																  AND	B.TC_Movimiento			= @L_MovimientoCirtulanteTerminado
																  ORDER BY B.TF_Fecha DESC ) HMC
			WHERE	HMC.TN_CodExpedienteMovimientoCirculante	= A.TN_CodExpedienteMovimientoCirculante
	
			--Busca si tiene otros expedientes acumulados 
			SELECT	@L_EstaAcumulado = COUNT(TU_CodAcumulacion) 
			FROM	Historico.ExpedienteAcumulacion		WITH(NOLOCK)
			WHERE	TC_NumeroExpediente					= @L_NumeroExpediente
			AND		TF_FinAcumulacion					IS NULL
			AND		TC_CodContexto						= @L_Contexto
			AND		TF_InicioAcumulacion				= (	SELECT  MAX(TF_InicioAcumulacion) 
															FROM	Historico.ExpedienteAcumulacion WITH(NOLOCK)
															WHERE	TC_NumeroExpediente				= @L_NumeroExpediente)
	
	
			--Busca si tiene eventos pendientes
			SELECT @L_TieneEventosPendientes = COUNT([TU_CodEvento])
			FROM [Agenda].[Evento]								WITH(NOLOCK)
			JOIN [Catalogo].[EstadoEvento]						WITH(NOLOCK)
			ON Agenda.Evento.TN_CodEstadoEvento					= Catalogo.EstadoEvento.TN_CodEstadoEvento
			WHERE Catalogo.EstadoEvento.TB_FinalizaEvento		= 0
			AND	  Agenda.Evento.TC_NumeroExpediente				= @L_NumeroExpediente
			AND	  Agenda.Evento.TC_CodContexto					= @L_Contexto

			IF (@L_TieneComunicionesPendientes = 0 AND @L_EstaFinalizadoEstadisticamente = 1 AND @L_EstaAcumulado = 0 AND @L_TieneEventosPendientes = 0)
				INSERT INTO @ValidacionesItineracion (	ItineracionValida )
				VALUES								 (	1				  )
			ELSE
				BEGIN
					DECLARE @ComunicPend				BIT = 0,
							@NoFinalizado				BIT = 0,
							@Acumulados					BIT = 0,							
							@EventosPend				BIT = 0

					IF (@L_TieneComunicionesPendientes > 0)
						SET @ComunicPend = 1

					IF (@L_EstaFinalizadoEstadisticamente = 0)
						SET @NoFinalizado = 1

					IF (@L_EstaAcumulado > 0)
						SET @Acumulados = 1
			
					IF (@L_TieneEventosPendientes > 0)
						SET @EventosPend = 1

					INSERT INTO @ValidacionesItineracion (	
															ItineracionValida,		ComunicacionesPendientes,	NoFinalizado,		Acumulados,
															EventosPendientes
														 )
					VALUES								 (	
															0,						@ComunicPend,				@NoFinalizado,		@Acumulados,
															@EventosPend
														 )

				END

		END	-- Else
	

		SELECT	*
		FROM	@ValidacionesItineracion
END

GO
