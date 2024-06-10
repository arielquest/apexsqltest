SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<10/09/2020>
-- Descripción :			<Valida si un legajo puede ser itinerado>  
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ValidarEnvioLegajo]
	@CodigoLegajo					uniqueidentifier,
	@Contexto						varchar(4),
	@EstadoComunicacionEntregada	char(1),
	@MovimientoCirtulanteTerminado	char(1)
	
AS  
BEGIN 

	DECLARE @L_TieneComunicionesPendientes			int
	DECLARE @L_EstaFinalizadoEstadisticamente		int
	DECLARE @L_TieneResolucionesEnBorrador			int
	DECLARE @L_TieneEscritosEnBorrador				int
	DECLARE @L_TieneEventosPendientes				int
	DECLARE @L_TieneDocsSinTerminar					int
	DECLARE @L_CodigoLegajo							uniqueidentifier	= @CodigoLegajo
	DECLARE @L_Contexto								varchar(4)			= @Contexto
	DECLARE @L_EstadoComunicacionEntregada			char(1)				= @EstadoComunicacionEntregada
	DECLARE @L_MovimientoCirtulanteTerminado		char(1)				= @MovimientoCirtulanteTerminado
	
	--Busca si esta finalizado estadisticamente
	SELECT	@L_EstaFinalizadoEstadisticamente		= COUNT(*)
	FROM	Historico.LegajoMovimientoCirculante	A With(Nolock)
	WHERE	A.TU_CodLegajo							= @L_CodigoLegajo
	AND		A.TC_Movimiento							<> @L_MovimientoCirtulanteTerminado
	AND		A.TC_CodContexto						= @L_Contexto
	AND		A.TF_Fecha								= (SELECT MAX(Historico.LegajoMovimientoCirculante.TF_Fecha)
														FROM   Historico.LegajoMovimientoCirculante With(Nolock)
														WHERE  Historico.LegajoMovimientoCirculante.TU_CodLegajo = @L_CodigoLegajo
														AND    Historico.LegajoMovimientoCirculante.TC_CodContexto = @L_Contexto)
	SELECT	@L_EstaFinalizadoEstadisticamente

	----Busca si tiene resoluciones en estado diferente a terminado
	Select	@L_TieneResolucionesEnBorrador	= Count(C.TU_CodResolucion)
	from	Expediente.LegajoArchivo		A With(Nolock)
	Inner join Archivo.Archivo				B With(NoLock)
	on		B.TU_CodArchivo					= A.TU_CodArchivo
	Inner join Expediente.Resolucion		C With(NoLock)
	on		C.TU_CodArchivo					= A.TU_CodArchivo
	Where	A.TU_CodLegajo					= @L_CodigoLegajo
	and		B.TN_CodEstado					<> 4

	Select	@L_TieneResolucionesEnBorrador

	--Busca documentos que no esten terminados para el legajo
	Select @L_TieneDocsSinTerminar				= Count(A.TU_CodArchivo)
	from	Expediente.ArchivoExpediente		A With(Nolock)
	Inner join	Expediente.LegajoArchivo		B with(NoLock)
	on		A.TU_CodArchivo						= B.TU_CodArchivo
	and		A.TC_NumeroExpediente				= B.TC_NumeroExpediente
	Inner join Archivo.Archivo					C With(NoLock)
	On		C.TU_CodArchivo						= B.TU_CodArchivo
	where	B.TU_CodLegajo						= @L_CodigoLegajo
	and		C.TN_CodEstado						<> 4
	
	Select @L_TieneDocsSinTerminar	

	--Busca si tiene escritos diferente a Resuelto
	SELECT	@L_TieneEscritosEnBorrador			= Count(A.TU_CodEscrito)
	FROM	Expediente.EscritoExpediente		A  With(Nolock)
	INNER JOIN	Archivo.Archivo					B With(Nolock)
	ON		A.TC_IDARCHIVO						= B.TU_CodArchivo
	INNER JOIN Expediente.EscritoLegajo			C
	on		C.TU_CodEscrito						= A.TU_CodEscrito
	WHERE	C.TU_CodLegajo						= @L_CodigoLegajo
	AND		A.TC_CodContexto					= @L_Contexto
	AND		A.TC_EstadoEscrito					<> 'R'
	
	SELECT	@L_TieneEscritosEnBorrador	

	IF	@L_EstaFinalizadoEstadisticamente		= 0
	AND	@L_TieneResolucionesEnBorrador			= 0 
	AND	@L_TieneEscritosEnBorrador				= 0 
	AND @L_TieneDocsSinTerminar					= 0
		return 1
	ELSE
		return 0  
END
GO
