SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Eliminar asociación de equipos a un criterio> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarEquipoCriterio]
	@CodCriterio				UNIQUEIDENTIFIER,
	@CodEquipo					UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE 
			@L_CodCriterio					UNIQUEIDENTIFIER	= @CodCriterio,
			@L_CodEquipo					UNIQUEIDENTIFIER	= @CodEquipo


			
	
	DELETE	Catalogo.EquipoCriterio
	WHERE	TU_CodCriterio				=	@L_CodCriterio
	AND		TU_CodEquipo				=	COALESCE(@L_CodEquipo,TU_CodEquipo)
END
GO
