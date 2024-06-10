SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:				<Wagner Vargas Sanabria>
-- Fecha Creación:		<06/01/2021>
-- Descripcion:			<Ingresa un registro en el movimiento de circulante fase al Expediente>
-- =================================================================================================================================================
-- Modificacion:	 <Josue Quiros Batista><Se realiza ajuste al insertar la fecha de getdate() a usar una mayor precision sysdatetime>


CREATE PROCEDURE [Historico].[PA_AgregarExpedienteMovimientoCirculanteFase] 
	@ExpedienteFase										uniqueidentifier=NULL,
	@CodExpedienteMovimientoCirculante					bigint=NULL,
	@NumeroExpediente								    char(14),
	@CodContexto									    char(4), 
	@CantidadRepeticiones								Int = 0

AS

BEGIN TRY
    DECLARE @L_TU_ExpedienteFase						uniqueidentifier	= @ExpedienteFase
	DECLARE	@L_TN_CodExpedienteMovimientoCirculante		bigint			    = @CodExpedienteMovimientoCirculante
	DECLARE	@L_TC_NumeroExpediente					    char(14)	        = @NumeroExpediente
	DECLARE @L_TC_Contexto								char(4)				= @CodContexto

	if (@L_TU_ExpedienteFase is null)
		select top 1 @L_TU_ExpedienteFase =TU_CodExpedienteFase 
	    from		Historico.ExpedienteFase WITH(NOLOCK)
	    where		TC_NumeroExpediente =    @L_TC_NumeroExpediente 
	   	and			TC_CodContexto =         @L_TC_Contexto 
	    order by	TF_Fase desc 

	if (@L_TN_CodExpedienteMovimientoCirculante is null)
		select top 1 @L_TN_CodExpedienteMovimientoCirculante=TN_CodExpedienteMovimientoCirculante 
	   	from		Historico.ExpedienteMovimientoCirculante WITH(NOLOCK)
	   	where		TC_NumeroExpediente = @L_TC_NumeroExpediente 
	   	and			TC_CodContexto = @L_TC_Contexto 
	   	order by	TF_Fecha desc 

	IF (@L_TN_CodExpedienteMovimientoCirculante IS NOT NULL AND @L_TU_ExpedienteFase IS NOT NULL)
	BEGIN

		INSERT INTO Historico.ExpedienteMovimientoCirculanteFase WITH(ROWLOCK)
		(
			TU_CodExpedienteFase, 
			TN_CodExpedienteMovimientoCirculante,
			TC_NumeroExpediente,
			TF_Fecha
		)
		VALUES
		(
			@L_TU_ExpedienteFase,
			@L_TN_CodExpedienteMovimientoCirculante,
			@L_TC_NumeroExpediente,
			sysdatetime()
		)
	END
	
	RETURN
END TRY
BEGIN CATCH
	
	DECLARE @L_Cantidad INT = @CantidadRepeticiones + 1
	-- Volvemos a llamar
	if(@L_Cantidad < 200)
	BEGIN		
		EXEC [Historico].[PA_AgregarExpedienteMovimientoCirculanteFase] @ExpedienteFase, @CodExpedienteMovimientoCirculante, @NumeroExpediente, @CodContexto, @L_Cantidad
	END
	RETURN
END CATCH

GO
