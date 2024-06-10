SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<09/07/2021>
-- Descripción :			<Consulta sí un equipo tiene criterios de reparto asociados> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_ConsultarSiEquipoTieneCriteriosAsociados]
	@CodEquipo   UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE
		    @L_CodEquipo	UNIQUEIDENTIFIER = @CodEquipo,
			@L_Cantidad	    INT
	
	
			SELECT  @L_Cantidad = COUNT(C.TU_CodCriterio) 
			FROM	Catalogo.CriteriosReparto C with(nolock)
					INNER JOIN	  Catalogo.EquipoCriterio  E ON E.TU_CodCriterio = C.TU_CodCriterio
			WHERE  	E.TU_CodEquipo = @L_CodEquipo
			
	SELECT ISNULL(@L_Cantidad,0) 

END
GO
