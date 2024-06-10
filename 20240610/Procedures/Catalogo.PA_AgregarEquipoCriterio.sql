SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<30/08/2021>
-- Descripción :			<Agrega un equipo asociado a un criterio> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarEquipoCriterio]
	@CodEquipo					UNIQUEIDENTIFIER,
	@CodCriterio				UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE 
			@L_CodEquipo		UNIQUEIDENTIFIER	= @CodEquipo,
			@L_CodCriterio		UNIQUEIDENTIFIER	= @CodCriterio


			
	
	INSERT INTO		Catalogo.EquipoCriterio
					(TU_CodEquipo,		TU_CodCriterio)
	VALUES			(@L_CodEquipo,		@L_CodCriterio)
END
GO
