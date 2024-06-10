SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<27/11/2020>
-- Descripción:			<Hace las modificaciones para que indica la recepción de un resultado recurso.>
-- ==================================================================================================================================================================================
-- Modificación:		<27/01/2021> <Aida Elena Siles R> <Se agrega la actualización de la fecha de recepción al resultado del recurso.>
-- Modificación:		<17/08/2022> <Aaron Rios Retana> <HU 270202 - Se quita el try and catch para que funcione correctamente el transaction scope en el API.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE [Historico].[PA_RecibirResultadoRecurso]
	@CodRecurso				UNIQUEIDENTIFIER,
	@CodResultadoRecurso	UNIQUEIDENTIFIER
AS
DECLARE 	@L_CodRecurso				UNIQUEIDENTIFIER	=	@CodRecurso,
			@L_CodResultadoRecurso		UNIQUEIDENTIFIER	=	@CodResultadoRecurso

	--Se asigna el codigo GUID del resultado al recurso.
	UPDATE	[Expediente].[RecursoExpediente]	WITH(ROWLOCK)
	SET		[TU_CodResultadoRecurso]			= @L_CodResultadoRecurso
	WHERE	[TU_CodRecurso]						= @L_CodRecurso

		--Se asigna la fecha de recepción al resultado del recurso.
	UPDATE	[Expediente].[ResultadoRecurso]		WITH(ROWLOCK)
	SET		[TF_FechaRecepcion]					= GETDATE()
	WHERE	[TU_CodResultadoRecurso]			= @L_CodResultadoRecurso

GO
