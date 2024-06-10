SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<17/09/2021>
-- Descripción :			<Consulta el criterio de reparto manual de un expediente o legajo> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarExpedienteCriterio]
	@CodLegajo				UNIQUEIDENTIFIER,
	@CodContexto			VARCHAR(4),
	@NumeroExpediente		VARCHAR(14)
AS  
BEGIN  
	Declare 
		@L_CodLegajo			UNIQUEIDENTIFIER = @CodLegajo,
		@L_CodContexto			VARCHAR(4) = @CodContexto,
		@L_NumeroExpediente		VARCHAR(14) = @NumeroExpediente

	
	IF @L_CodLegajo IS NULL
	BEGIN
		SELECT  TN_CodCriterioManual 'CodigoCriterioManual',
				M.TC_Descripcion     'Descripcion'
		FROM	Expediente.ExpedienteCriterio E
		INNER JOIN Catalogo.CriterioRepartoManual M ON M.TN_CodCriterioRepartoManual = E.TN_CodCriterioManual
		WHERE	E.TC_NumeroExpediente = @L_NumeroExpediente AND
				E.TC_CodContexto		= @L_CodContexto AND
				E.TU_CodLegajo	      IS NULL
	END
	ELSE
	BEGIN
			SELECT  TN_CodCriterioManual 'CodigoCriterioManual',
					M.TC_Descripcion     'Descripcion'
			FROM	Expediente.ExpedienteCriterio E
			INNER JOIN Catalogo.CriterioRepartoManual M ON M.TN_CodCriterioRepartoManual = E.TN_CodCriterioManual
			WHERE	E.TC_NumeroExpediente = @L_NumeroExpediente AND
					E.TC_CodContexto		= @L_CodContexto AND
					E.TU_CodLegajo		= @L_CodLegajo

	END
END
GO
