SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<17/05/2021>
-- Descripción :			<Revocar el criterio de asignación> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_RevocarCriterioAsignacion]      
	@CodCriterioReparto			uniqueidentifier,
	@CodPuestoTrabajo			varchar(14)
AS  
BEGIN  
	Declare 
			@L_CodCriterioReparto	uniqueidentifier = @CodCriterioReparto,
			@L_CodPuestoTrabajo		varchar(14)      = @CodPuestoTrabajo
	
	
		Update Catalogo.CriterioAsignacion 
		   Set TN_Adicionales = TN_Adicionales + 1, TN_TotalAcumulado = TN_TotalAcumulado - 1, TF_UltimaAsignacion = GETDATE()
		   Where TU_CodCriterio      = @L_CodCriterioReparto And
			     TC_CodPuestoTrabajo = @L_CodPuestoTrabajo
   
END
GO
