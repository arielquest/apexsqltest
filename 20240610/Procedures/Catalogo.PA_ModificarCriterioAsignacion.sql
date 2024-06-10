SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Registra el reparto en bitácora> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarCriterioAsignacion]      
	@CodCriterioReparto			uniqueidentifier,
	@CodPuestoTrabajo			varchar(14)
AS  
BEGIN  
	Declare 
			@L_CodCriterioReparto	uniqueidentifier = @CodCriterioReparto,
			@L_CodPuestoTrabajo		varchar(14)      = @CodPuestoTrabajo,
			@L_Adicionales			int
	
	select @L_Adicionales = TN_Adicionales 
	From  Catalogo.CriterioAsignacion
	Where TU_CodCriterio      = @L_CodCriterioReparto And
		  TC_CodPuestoTrabajo = @L_CodPuestoTrabajo

   If Isnull(@L_Adicionales,0) > 0
   Begin
		Update Catalogo.CriterioAsignacion 
		   Set TN_Adicionales = TN_Adicionales - 1, TN_TotalAcumulado = TN_TotalAcumulado + 1, TF_UltimaAsignacion = GETDATE()
		   Where TU_CodCriterio      = @L_CodCriterioReparto And
			     TC_CodPuestoTrabajo = @L_CodPuestoTrabajo
   End
   Else
   Begin
		Update Catalogo.CriterioAsignacion 
		   Set TN_Asignaciones = TN_Asignaciones + 1, TN_TotalAcumulado = TN_TotalAcumulado + 1, TF_UltimaAsignacion = GETDATE()
		   Where TU_CodCriterio       = @L_CodCriterioReparto And
			      TC_CodPuestoTrabajo = @L_CodPuestoTrabajo
   End
END
GO
