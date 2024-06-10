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
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ValidarEnvioExpediente]
	@NumeroExpediente				VARCHAR(14),
	@Contexto						VARCHAR(4),
	@EstadoComunicacionEntregada	CHAR(1),
	@MovimientoCirtulanteTerminado	CHAR(1)
	
AS  
BEGIN 

	DECLARE @L_TieneComunicionesPendientes		INT
	DECLARE @L_EstaFinalizadoEstadisticamente	INT
	DECLARE @L_EstaAcumulado					INT
	DECLARE @L_TieneDocumentosEnBorrador		INT
	DECLARE @L_TieneEscritosPendientes			INT
	DECLARE @L_TieneEventosPendientes			INT
	DECLARE @L_NumeroExpediente					VARCHAR(14) = @NumeroExpediente
	DECLARE @L_Contexto							VARCHAR(4)	= @Contexto
	DECLARE @L_EstadoComunicacionEntregada		CHAR(1)		= @EstadoComunicacionEntregada
	DECLARE @L_MovimientoCirtulanteTerminado	CHAR(1)		= @MovimientoCirtulanteTerminado

	--Busca las comunicaciones pendientes de le expediente
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
	
	--Busca si tiene documentos o resoluciones en estado diferente de terminado.
	SELECT		@L_TieneDocumentosEnBorrador	= COUNT(A.TU_CodArchivo)
	FROM		Expediente.ArchivoExpediente	A WITH(NOLOCK)
	INNER JOIN	Archivo.Archivo					B WITH(NOLOCK)
	ON			A.TU_CodArchivo					= B.TU_CodArchivo	
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
	AND			B.TN_CodEstado					<> 4 --TERMINADO
	
	--Busca si tiene escritos en estado diferente de resuelto
	SELECT	@L_TieneEscritosPendientes = Count([TU_CodEscrito])
	FROM	[Expediente].[EscritoExpediente]						A WITH(NOLOCK)
	JOIN	[Archivo].[Archivo]										B WITH(NOLOCK)
	ON		A.TC_IDARCHIVO											= B.[TU_CodArchivo]
	WHERE	A.TC_NumeroExpediente									= @L_NumeroExpediente
	AND		TC_CodContexto											= @L_Contexto
	AND		A.[TC_EstadoEscrito]									<> 'R'
	
	--Busca si tiene eventos pendientes
	SELECT @L_TieneEventosPendientes = COUNT([TU_CodEvento])
	FROM [Agenda].[Evento]								WITH(NOLOCK)
	JOIN [Catalogo].[EstadoEvento]						WITH(NOLOCK)
	ON Agenda.Evento.TN_CodEstadoEvento					= Catalogo.EstadoEvento.TN_CodEstadoEvento
	WHERE Catalogo.EstadoEvento.TB_FinalizaEvento		= 0
	AND	  Agenda.Evento.TC_NumeroExpediente				= @L_NumeroExpediente
	AND	  Agenda.Evento.TC_CodContexto					= @L_Contexto

	
	IF (@L_TieneComunicionesPendientes = 0 AND @L_EstaFinalizadoEstadisticamente = 1 AND @L_EstaAcumulado = 0 
	AND @L_TieneDocumentosEnBorrador = 0 AND @L_TieneEscritosPendientes = 0 AND @L_TieneEventosPendientes = 0)
		RETURN 1
	ELSE
		RETURN 0  
END
GO
