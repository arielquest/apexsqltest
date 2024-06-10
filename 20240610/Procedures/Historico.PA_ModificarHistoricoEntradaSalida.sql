SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<10/06/2020>
-- Descripción :			<Actualiza un registro en la tabla Historico.ExpedienteEntradaSalida>
-- =================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro>	<16/09/2020> <Se agregar el parámetro "FechaSalida">
-- Modificación:			<Isaac Dobles Mata>			<27/11/2020> <Se agregan parámetros "FechaCreacion", "ContextoDestino", "MotivoItineracion">
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ModificarHistoricoEntradaSalida]
	@CodHistoricoItineracion				UNIQUEIDENTIFIER,
	@CodExpedienteEntradaSalida				UNIQUEIDENTIFIER,
	@FechaSalida							DATETIME2(3),
	@FechaCreacion							DATETIME2(3),
	@CodContextoDestino						VARCHAR(4),
	@CodMotivoItineracion					SMALLINT
AS  
BEGIN 

	DECLARE @L_CodHistoricoItineracion		UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
	@L_CodExpedienteEntradaSalida			UNIQUEIDENTIFIER	= @CodExpedienteEntradaSalida,
	@L_FechaSalida							DATETIME			= @FechaSalida,
	@L_FechaCreacion						DATETIME			= @FechaCreacion,
	@L_CodContextoDestino					VARCHAR(4)			= @CodContextoDestino,
	@L_CodMotivoItineracion					SMALLINT			= @CodMotivoItineracion

	UPDATE [Historico].[ExpedienteEntradaSalida] WITH (ROWLOCK)
	   SET 
	   [TU_CodHistoricoItineracion]		=		@L_CodHistoricoItineracion,
	   [TF_Salida]						=		@L_FechaSalida,
	   [TF_CreacionItineracion]			=		@L_FechaCreacion,
	   [TC_CodContextoDestino]			=		@L_CodContextoDestino,
	   [TN_CodMotivoItineracion]		=		@L_CodMotivoItineracion
	 WHERE [TU_CodExpedienteEntradaSalida]	= @L_CodExpedienteEntradaSalida

END
GO
