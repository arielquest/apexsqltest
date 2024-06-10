SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Modificar un criterio de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarCriterioReparto]
	@CodCriterio			    UNIQUEIDENTIFIER,
	@Agrupacion					BIT,
	@NombreCriterio			    VARCHAR(250) 
AS  
BEGIN  
	DECLARE 
			@L_CodCriterio					UNIQUEIDENTIFIER	=	@CodCriterio,
			@L_Agrupacion					BIT					=	@Agrupacion,
			@L_NombreCriterio				VARCHAR(250)		=	@NombreCriterio


	
	
	UPDATE	Catalogo.CriteriosReparto
	SET		TB_Agrupacion	=	@L_Agrupacion,	
			TC_Nombre		=	@L_NombreCriterio
	WHERE	TU_CodCriterio	=	@L_CodCriterio
END
GO
