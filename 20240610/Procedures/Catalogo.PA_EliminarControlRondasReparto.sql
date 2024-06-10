SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Elimina control de rondas de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarControlRondasReparto]
	@CodCriterio				UNIQUEIDENTIFIER,
	@CodRonda					UNIQUEIDENTIFIER	= NULL
AS  
BEGIN  
	DECLARE 
			@L_CodCriterio		UNIQUEIDENTIFIER	=	@CodCriterio,
			@L_CodRonda			UNIQUEIDENTIFIER	=	@CodRonda


			
	
	DELETE	Catalogo.ControlRondasReparto
	WHERE	TU_CodCriterioReparto		=	@L_CodCriterio
	AND		TU_CodRonda					=	COALESCE(@L_CodRonda,	TU_CodRonda)
END
GO
