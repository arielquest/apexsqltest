SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<17/09/2021>
-- Descripción :			<inserta o modifica el criterio de reparto manual de un expediente o legajo> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_AgregarExpedienteCriterio]
	@CodLegajo				UNIQUEIDENTIFIER,
	@CodCriterioManual		INT,
	@CodContexto			VARCHAR(4),
	@NumeroExpediente		VARCHAR(14),
	@CodCriterio			UNIQUEIDENTIFIER
AS  
BEGIN  
	Declare 
		@L_CodLegajo			UNIQUEIDENTIFIER = @CodLegajo,
		@L_CodCriterioManual	INT = @CodCriterioManual,
		@L_CodContexto			VARCHAR(4) = @CodContexto,
		@L_NumeroExpediente		VARCHAR(14) = @NumeroExpediente,
		@L_CodCriterio			UNIQUEIDENTIFIER = @CodCriterio,
		@L_ExisteCriterio		INT
	
	IF @L_CodLegajo IS NULL
	BEGIN
		SELECT @L_ExisteCriterio = ISNULL(COUNT(TU_CodCriterio),0)
		FROM	Expediente.ExpedienteCriterio 
		WHERE	TC_NumeroExpediente = @L_NumeroExpediente AND
				TC_CodContexto		= @L_CodContexto AND
				TU_CodLegajo		  IS NULL
	END
	ELSE
	BEGIN
		SELECT @L_ExisteCriterio = ISNULL(COUNT(TU_CodCriterio),0)
		FROM	Expediente.ExpedienteCriterio 
		WHERE	TC_NumeroExpediente = @L_NumeroExpediente AND
				TC_CodContexto		= @L_CodContexto AND
				TU_CodLegajo		= @L_CodLegajo
	END

	IF @L_ExisteCriterio = 0
	BEGIN
		INSERT INTO Expediente.ExpedienteCriterio(
			TC_NumeroExpediente,	TC_CodContexto,		TU_CodLegajo, 
			TN_CodCriterioManual,	TU_CodCriterio)
		VALUES(
			@L_NumeroExpediente,	@L_CodContexto,		@L_CodLegajo,
			@L_CodCriterioManual,	@L_CodCriterio)
	END
	ELSE
	BEGIN
		IF @L_CodLegajo IS NULL
		BEGIN
			UPDATE  Expediente.ExpedienteCriterio
			SET    TN_CodCriterioManual = @L_CodCriterioManual
			WHERE  TC_NumeroExpediente  = @L_NumeroExpediente AND
				   TC_CodContexto		= @L_CodContexto AND
				   TU_CodLegajo		    IS NULL
		END
		ELSE
		BEGIN
			UPDATE  Expediente.ExpedienteCriterio
			SET    TN_CodCriterioManual = @L_CodCriterioManual
			WHERE  TC_NumeroExpediente  = @L_NumeroExpediente AND
				   TC_CodContexto		= @L_CodContexto AND
				   TU_CodLegajo		    = @L_CodLegajo
		END
	END
END
GO
