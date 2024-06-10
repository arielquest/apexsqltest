SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<24/02/2021>
-- Descripción:			<Permite agregar un registro en la tabla: LegajoEntradaSalida.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_AgregarLegajoEntradaSalida]
	@CodLegajoEntradaSalida		UNIQUEIDENTIFIER,
	@CodLegajo					UNIQUEIDENTIFIER	= NULL,
	@CodContexto				VARCHAR(4),
	@FechaEntrada				DATETIME2(3),
	@FechaCreacionItineracion	DATETIME2(3)		= NULL,
	@FechaSalida				DATETIME2(3)		= NULL,
	@CodContextoDestino			VARCHAR(4)			= NULL,
	@CodMotivoItineracion		SMALLINT			= NULL,
	@CodHistoricoItineracion	UNIQUEIDENTIFIER	= NULL,	
	@IDNAUTIUS					VARCHAR(255)		= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodLegajoEntradaSalida		UNIQUEIDENTIFIER		= @CodLegajoEntradaSalida,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER		= @CodLegajo,
			@L_TC_CodContexto					VARCHAR(4)				= @CodContexto,
			@L_TF_FechaEntrada					DATETIME2(7)			= @FechaEntrada,
			@L_TF_FechaCreacionItineracion		DATETIME2(7)			= @FechaCreacionItineracion,
			@L_TF_FechaSalida					DATETIME2(7)			= @FechaSalida,
			@L_TC_CodContextoDestino			VARCHAR(4)				= @CodContextoDestino,
			@L_TN_CodMotivoItineracion			SMALLINT				= @CodMotivoItineracion,
			@L_TU_CodHistoricoItineracion		UNIQUEIDENTIFIER		= @CodHistoricoItineracion,			
			@L_IDNAUTIUS						VARCHAR(255)			= @IDNAUTIUS
	
	--Cuerpo
	INSERT INTO	Historico.LegajoEntradaSalida	WITH (ROWLOCK)
	(
		TU_CodLegajoEntradaSalida,			TU_CodLegajo,					TC_CodContexto,					TF_Entrada,						
		TF_CreacionItineracion,				TF_Salida,						TC_CodContextoDestino,			TN_CodMotivoItineracion,			
		TU_CodHistoricoItineracion,			ID_NAUTIUS						
	)
	VALUES
	(
		@L_TU_CodLegajoEntradaSalida,			@L_TU_CodLegajo,				@L_TC_CodContexto,				@L_TF_FechaEntrada,					
		@L_TF_FechaCreacionItineracion,			@L_TF_FechaSalida,					@L_TC_CodContextoDestino,	@L_TN_CodMotivoItineracion,			
		@L_TU_CodHistoricoItineracion,			@L_IDNAUTIUS					
	)
END
GO
