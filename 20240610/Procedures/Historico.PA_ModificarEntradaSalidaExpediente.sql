SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================
-- Version:			  <1.0>
-- Creado por:		  <Cordero Soto Jose Gabriel>
-- Fecha de creación: <11/11/2019>
-- Descripción:		  <Actualiza información sobre entradas y salidas sobre expediente y legajos>
-- =============================================================================================================================
-- Modificación:	  <Aida Elena Siles Rojas> <30/07/2020> <Se agrega el campo TF_CreacionItineracion para registrar la fecha>
-- =============================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarEntradaSalidaExpediente]
@CodExpedienteEntradaSalida UNIQUEIDENTIFIER,
@CodContextoDestino			VARCHAR(4) = null,
@CodMotivoItineracion		SMALLINT = null,
@CodHistoricoItineracion	UNIQUEIDENTIFIER = null
AS
BEGIN

	DECLARE @L_CodExpedienteEntradaSalida		UNIQUEIDENTIFIER	= @CodExpedienteEntradaSalida
	DECLARE @L_CodContextoDestino				VARCHAR(4)			= @CodContextoDestino
	DECLARE @L_CodMotivoItineracion				SMALLINT			= @CodMotivoItineracion
	DECLARE @L_CodHistoricoItineracion			UNIQUEIDENTIFIER	= @CodHistoricoItineracion

	UPDATE [Historico].[ExpedienteEntradaSalida]
	SET    [TC_CodContextoDestino]			= @L_CodContextoDestino
		  ,[TN_CodMotivoItineracion]		= @L_CodMotivoItineracion
		  ,[TU_CodHistoricoItineracion]		= @L_CodHistoricoItineracion
		  ,[TF_CreacionItineracion]			= GETDATE()
	WHERE [TU_CodExpedienteEntradaSalida]	= @CodExpedienteEntradaSalida

END
GO
