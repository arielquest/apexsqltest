SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<11/09/2020>
-- Descripción :			<Actualiza un registro en la tabla Historico.LegajoEntradaSalida>  
-- =================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro>	<16/09/2020> <Se agregar el parámetro "FechaSalida"> 
-- Modificación:			<Isaac Dobles Mata>			<27/11/2020> <Se agregan parámetros "FechaCreacion", "ContextoDestino", "MotivoItineracion">
-- =================================================================================================================================================
CREATE Procedure [Historico].[PA_ModificarHistoricoLegajoEntradaSalida]
	@CodHistoricoItineracion				uniqueidentifier,
	@CodLegajoEntradaSalida					uniqueidentifier,
	@FechaSalida							datetime2(3),
	@FechaCreacion							DATETIME2(3),
	@CodContextoDestino						VARCHAR(4),
	@CodMotivoItineracion					SMALLINT
AS  
BEGIN 

	declare @L_CodHistoricoItineracion		uniqueidentifier	= @CodHistoricoItineracion,
	@L_CodLegajoEntradaSalida				uniqueidentifier	= @CodLegajoEntradaSalida,
	@L_FechaSalida							datetime			= @FechaSalida,
	@L_FechaCreacion						DATETIME			= @FechaCreacion,
	@L_CodContextoDestino					VARCHAR(4)			= @CodContextoDestino,
	@L_CodMotivoItineracion					SMALLINT			= @CodMotivoItineracion	

	Update Historico.LegajoEntradaSalida	with (ROWLOCK)
		set	TU_CodHistoricoItineracion				=		@L_CodHistoricoItineracion,
			TF_Salida								=		@L_FechaSalida,
			[TF_CreacionItineracion]				=		@L_FechaCreacion,
			[TC_CodContextoDestino]					=		@L_CodContextoDestino,
			[TN_CodMotivoItineracion]				=		@L_CodMotivoItineracion
		where 
			TU_CodLegajoEntradaSalida				=		@L_CodLegajoEntradaSalida

END
GO
