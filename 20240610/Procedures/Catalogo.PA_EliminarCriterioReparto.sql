SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Eliminar un criterio de reparto agrupado> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarCriterioReparto]
	@CodConfiguracionReparto		UNIQUEIDENTIFIER,
	@CodCriterio					UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE 
			@L_CodConfiguracionReparto		UNIQUEIDENTIFIER	= @CodConfiguracionReparto,
			@L_CodCriterio					UNIQUEIDENTIFIER	= @CodCriterio

	
	DELETE	Catalogo.CriteriosReparto
	WHERE	TU_CodConfiguracionReparto	=	@L_CodConfiguracionReparto
	AND		TU_CodCriterio				=	COALESCE(@L_CodCriterio, TU_CodCriterio)

END
GO
