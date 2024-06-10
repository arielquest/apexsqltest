SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<17/05/2021>
-- Descripción:			<Permite agregar un registro en la tabla: ComunicacionRegistroAutomatico.>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><18-05-2021><Se incorpora el campo codigo interviniente en el registro de la comunicación> 
-- Modificación		   <09-05-2023><Glopezr><Se asigna el sector a partir de los datos de barrio distrito canton y provincia>
-- ===============================================================================================================================================

CREATE PROCEDURE	[Comunicacion].[PA_AgregarComunicacionRegistroAutomatico]
	@CodComunicacionAut					UNIQUEIDENTIFIER,
	@CodAsignacionFirmado				UNIQUEIDENTIFIER,
	@CodContextoOCJ						VARCHAR(4),
	@CodMedio							SMALLINT,
	@Valor								VARCHAR(350)		= NULL,
	@CodProvincia						SMALLINT			= NULL,
	@CodCanton							SMALLINT			= NULL,
	@CodDistrito						SMALLINT			= NULL,
	@CodBarrio							SMALLINT			= NULL,
	@CodSector							SMALLINT			= NULL,
	@Rotulado							VARCHAR(255)		= NULL,
	@TienePrioridad						BIT,
	@PrioridadMedio						TINYINT,
	@FechaResolucion					DATETIME2(3)		= NULL,
	@CodHorarioMedio					SMALLINT			= NULL,
	@RequiereCopias						BIT,
	@Observaciones						VARCHAR(255)		= NULL,
	@CodPuestoFuncionarioRegistro		UNIQUEIDENTIFIER	= NULL,
	@FechaPreRegistro					DATETIME2(7),
	@TipoComunicacion					CHAR(1),
	@EstadoEnvio						CHAR(1),
	@CodInterviniente					UNIQUEIDENTIFIER

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodComunicacionAut				UNIQUEIDENTIFIER		= @CodComunicacionAut,
			@L_TU_CodAsignacionFirmado				UNIQUEIDENTIFIER		= @CodAsignacionFirmado,
			@L_TC_CodContextoOCJ					VARCHAR(4)				= @CodContextoOCJ,
			@L_TC_CodMedio							SMALLINT				= @CodMedio,
			@L_TC_Valor								VARCHAR(350)			= @Valor,
			@L_TN_CodProvincia						SMALLINT				= @CodProvincia,
			@L_TN_CodCanton							SMALLINT				= @CodCanton,
			@L_TN_CodDistrito						SMALLINT				= @CodDistrito,
			@L_TN_CodBarrio							SMALLINT				= @CodBarrio,
			@L_TN_CodSector							SMALLINT				= @CodSector,
			@L_TC_Rotulado							VARCHAR(255)			= @Rotulado,
			@L_TB_TienePrioridad					BIT						= @TienePrioridad,
			@L_TN_PrioridadMedio					TINYINT					= @PrioridadMedio,
			@L_TF_FechaResolucion					DATETIME2(7)			= @FechaResolucion,
			@L_TN_CodHorarioMedio					SMALLINT				= @CodHorarioMedio,
			@L_TB_RequiereCopias					BIT						= @RequiereCopias,
			@L_TC_Observaciones						VARCHAR(255)			= @Observaciones,
			@L_TU_CodPuestoFuncionarioRegistro		UNIQUEIDENTIFIER		= @CodPuestoFuncionarioRegistro,
			@L_TF_FechaPreRegistro					DATETIME2(7)			= @FechaPreRegistro,
			@L_TC_TipoComunicacion					CHAR(1)					= @TipoComunicacion,
			@L_TC_EstadoEnvio						CHAR(1)					= @EstadoEnvio,			
			@L_CodInterviniente						UNIQUEIDENTIFIER		= @CodInterviniente		

 
 
	--Cuerpo
	INSERT INTO	Comunicacion.ComunicacionRegistroAutomatico	WITH (ROWLOCK)
	(
		TU_CodComunicacionAut,			TU_CodAsignacionFirmado,			TC_CodContextoOCJ,				TC_CodMedio,					
		TC_Valor,						TN_CodProvincia,					TN_CodCanton,					TN_CodDistrito,					
		TN_CodBarrio,					TN_CodSector,						TC_Rotulado,					TB_TienePrioridad,				
		TN_PrioridadMedio,				TF_FechaResolucion,					TN_CodHorarioMedio,				TB_RequiereCopias,				
		TC_Observaciones,				TU_CodPuestoFuncionarioRegistro,	TF_FechaPreRegistro,			TC_TipoComunicacion,			
		TC_EstadoEnvio,					TU_CodInterviniente					
	)
	VALUES
	(
		@L_TU_CodComunicacionAut,		@L_TU_CodAsignacionFirmado,			@L_TC_CodContextoOCJ,			@L_TC_CodMedio,					
		@L_TC_Valor,					@L_TN_CodProvincia,					@L_TN_CodCanton,				@L_TN_CodDistrito,				
		@L_TN_CodBarrio,				@L_TN_CodSector,					@L_TC_Rotulado,					@L_TB_TienePrioridad,			
		@L_TN_PrioridadMedio,			@L_TF_FechaResolucion,				@L_TN_CodHorarioMedio,			@L_TB_RequiereCopias,			
		@L_TC_Observaciones,			@L_TU_CodPuestoFuncionarioRegistro,	@L_TF_FechaPreRegistro,			@L_TC_TipoComunicacion,			
		@L_TC_EstadoEnvio,				@L_CodInterviniente
	)
END
GO
