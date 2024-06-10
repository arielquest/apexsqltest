SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:				<Daniel Ruiz Hernández>
-- Fecha Creación:		<06/01/2021>
-- Descripcion:			<Ingresa un registro en el movimiento de circulante fase al legajo>
-- =================================================================================================================================================
-- Modificacion:	 <Luis Alonso Leiva Tames><22-04-2022><Se realiza ajuste al insertar la fecha de getdate() a usar una mayor precision sysdatetime>

CREATE PROCEDURE [Historico].[PA_AgregarLegajoMovimientoCirculanteFase] 
	@CodLegajoFase									uniqueidentifier,
	@CodLegajoMovimientoCirculante					bigint,
	@NumeroExpediente								char(14),
	@CodLegajo										uniqueidentifier,
	@CodContexto									char(4),
	@CantidadRepeticiones							Int = 0
AS

BEGIN TRY
    DECLARE @L_TU_CodLegajoFase						uniqueidentifier	= @CodLegajoFase
	DECLARE	@L_TN_CodLegajoMovimientoCirculante		bigint				= @CodLegajoMovimientoCirculante
	DECLARE	@L_TC_NumeroExpediente					char(14)			= @NumeroExpediente
	DECLARE	@L_TU_CodLegajo							uniqueidentifier	= @CodLegajo	
	DECLARE	@L_TC_CodContexto						char(4)				= @CodContexto	

	if (@L_TU_CodLegajoFase is null)
		set @L_TU_CodLegajoFase = (	select top 1 TU_CodLegajoFase 
									from		Historico.LegajoFase 
									where		TU_CodLegajo = @L_TU_CodLegajo 
									and			TC_CodContexto = @L_TC_CodContexto 
									order by	TF_Actualizacion desc )

	if (@L_TN_CodLegajoMovimientoCirculante is null)
		set @L_TN_CodLegajoMovimientoCirculante = (	select top 1 TN_CodLegajoMovimientoCirculante 
													from		Historico.LegajoMovimientoCirculante 
													where		TU_CodLegajo = @L_TU_CodLegajo 
													and			TC_CodContexto = @L_TC_CodContexto 
													order by	TF_Fecha desc )

	IF (@L_TU_CodLegajoFase IS NOT NULL AND @L_TN_CodLegajoMovimientoCirculante IS NOT NULL)
	BEGIN
		INSERT INTO Historico.LegajoMovimientoCirculanteFase
		(
			TU_CodLegajoFase, 
			TN_CodLegajoMovimientoCirculante,
			TC_NumeroExpediente,
			TU_CodLegajo,
			TF_Fecha
		)
		VALUES
		(
			@L_TU_CodLegajoFase,
			@L_TN_CodLegajoMovimientoCirculante,
			@L_TC_NumeroExpediente,
			@L_TU_CodLegajo,
			sysdatetime()
		)
	END
	RETURN
END TRY
BEGIN CATCH
	
	DECLARE @L_Cantidad INT = @CantidadRepeticiones + 1
	-- Volvemos a llamar
	if(@L_Cantidad < 2000000)
	BEGIN		
		EXEC [Historico].[PA_AgregarLegajoMovimientoCirculanteFase] @CodLegajoFase, @CodLegajoMovimientoCirculante, @NumeroExpediente, @CodLegajo, @CodContexto, @L_Cantidad
	END
	RETURN
END CATCH


GO
