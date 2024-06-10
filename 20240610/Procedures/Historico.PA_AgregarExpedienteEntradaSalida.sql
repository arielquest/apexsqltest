SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<24/02/2021>
-- Descripción :			<Crea un nuevo registro en el hitorico ExpedienteEntradaSalida para el registro de la entrada y salida de un expediente,
--							necesarios, para registros completos de EntradaSalida al recibir expedientes itinerados de Gestión> 
-- =================================================================================================================================================
-- Modificación :			<13/05/2021><Karol Jiménez Sánchez><Se agrega parámetro @CodHistoricoItineracion>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_AgregarExpedienteEntradaSalida] 
	@CodExpedienteEntradaSalida	UNIQUEIDENTIFIER, 
	@CodContexto				VARCHAR(4),
	@NumeroExpediente			CHAR(14),
	@Entrada					DATETIME2,
	@CreacionItineracion		DATETIME2			= NULL,
	@Salida						DATETIME2			= NULL,
	@CodContextoDestino			VARCHAR(4)			= NULL,
	@CodMotivoItineracion		SMALLINT			= NULL,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@IdNautius					VARCHAR(255)
AS
BEGIN

	DECLARE @L_CodExpedienteEntradaSalida	UNIQUEIDENTIFIER	= @CodExpedienteEntradaSalida,
			@L_CodContexto					VARCHAR(4)			= @CodContexto,				
			@L_NumeroExpediente				CHAR(14)			= @NumeroExpediente,			
			@L_FechaEntrada					DATETIME2			= @Entrada,				
			@L_FechaCreacionItineracion		DATETIME2			= @CreacionItineracion,	
			@L_FechaSalida					DATETIME2			= @Salida,				
			@L_CodContextoDestino			VARCHAR(4)			= @CodContextoDestino,		
			@L_CodMotivoItineracion			SMALLINT			= @CodMotivoItineracion,	
			@L_CodHistoricoItineracion		UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_IdNautius					VARCHAR(255)		= @IdNautius				


	INSERT INTO Historico.ExpedienteEntradaSalida
	(
		TU_CodExpedienteEntradaSalida,	TC_NumeroExpediente,	TC_CodContexto,			TF_Entrada,
		TF_CreacionItineracion,			TF_Salida,				TC_CodContextoDestino,	TN_CodMotivoItineracion,
		TU_CodHistoricoItineracion,		ID_NAUTIUS
	)
	VALUES
	(
		@L_CodExpedienteEntradaSalida,	@L_NumeroExpediente,	@L_CodContexto,			@L_FechaEntrada,
		@L_FechaCreacionItineracion,	@L_FechaSalida,			@L_CodContextoDestino,	@L_CodMotivoItineracion,			
		@L_CodHistoricoItineracion,		@L_IdNautius
	)
END
GO
