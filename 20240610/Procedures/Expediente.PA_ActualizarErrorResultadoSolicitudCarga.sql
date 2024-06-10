SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jefferson Parker Cortes>
-- Fecha de creación:	<02/01/2021>
-- Descripción:			<Permite actualizar registro de SREM y SDJ si esta en error , en la tabla DetalleDepuracionInactivo >
-- ==================================================================================================================================================================================
-- Fecha de modificacion:	<10/03/2023> Modificado: <Rafa Badilla A> Descripción : Incluir parámetro TieneEMbargos.
-- ==================================================================================================================================================================================
CREATE     PROCEDURE [Expediente].[PA_ActualizarErrorResultadoSolicitudCarga]
	@CodDetalleDepuracion   BIGINT,
	@TieneMandamientos		bit,
	@TieneDepositos			bit,
	@TieneEmbargos			bit,
	@Estado                 char,
	@Resultado				varchar(200)
	
AS  
BEGIN 

	DECLARE @L_CodDetalleDepuracion BIGINT				= @CodDetalleDepuracion
	DECLARE @L_TieneMandamientos	bit					= @TieneMandamientos
	DECLARE @L_TieneDepositos		bit					= @TieneDepositos
	DECLARE @L_TieneEmbargos		bit					= @TieneEmbargos
	DECLARE @L_Estado				char				= @Estado
	DECLARE @L_Resultado			varchar(200)		= @Resultado
	
	BEGIN
		UPDATE  [Expediente].[DetalleDepuracionInactivo]	WITH (ROWLOCK)
		SET		[TB_TieneMandamientos]						= @L_TieneMandamientos,
				[TB_TieneDepositos]							= @L_TieneDepositos,
				[TB_TieneEmbargos]							= @L_TieneEmbargos,
				[TC_Estado]									= @L_Estado,
				[TC_Resultado]								= @L_Resultado
		WHERE	[TN_CodDetalleDepuracion]					= @L_CodDetalleDepuracion
	END

END
GO
