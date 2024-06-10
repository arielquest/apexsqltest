SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================================================================
-- Version:			  <1.0>
-- Creado por:		  <Cordero Soto Jose Gabriel>
-- Fecha de creación: <11/11/2019>
-- Descripción:		  <Actualiza información sobre entradas y salidas sobre legajos>
-- ===============================================================================================================================
-- Modificación:	  <Aida Elena Siles Rojas> <31/07/2020> <Se agrega el campo TF_CreacionItineracion para registrar la fecha>
-- ===============================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarEntradaSalidaLegajo]
@CodLegajoEntradaSalida		UNIQUEIDENTIFIER,
@CodContextoDestino			VARCHAR(4) = NULL,
@CodMotivoItineracion		SMALLINT = NULL,
@CodHistoricoItineracion	UNIQUEIDENTIFIER = NULL
AS
BEGIN

	DECLARE @L_CodLegajoEntradaSalida			UNIQUEIDENTIFIER	= @CodLegajoEntradaSalida
	DECLARE @L_CodContextoDestino				VARCHAR(4)			= @CodContextoDestino
	DECLARE @L_CodMotivoItineracion				SMALLINT			= @CodMotivoItineracion
	DECLARE @L_CodHistoricoItineracion			UNIQUEIDENTIFIER	= @CodHistoricoItineracion

	UPDATE [Historico].[LegajoEntradaSalida]
	SET    [TC_CodContextoDestino]		= @L_CodContextoDestino
		  ,[TN_CodMotivoItineracion]	= @L_CodMotivoItineracion
		  ,[TU_CodHistoricoItineracion] = @L_CodHistoricoItineracion
		  ,[TF_CreacionItineracion]		= GETDATE()
	WHERE [TU_CodLegajoEntradaSalida]	= @CodLegajoEntradaSalida

END
GO
