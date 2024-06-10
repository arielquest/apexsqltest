SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<15/09/2021>
-- Descripción :			<Eliminar un criterio de reparto agrupado> 
-- =================================================================================================================================================
-- Versión:     <2.0>  
-- Creado por:    <Johan Acosta Ibañez>  
-- Fecha de creación:  <29/09/2021>  
-- Descripción :   <Se agrega el parámetro del código de agrupación>   
-- =================================================================================================================================================  
  
  
CREATE PROCEDURE [Catalogo].[PA_EliminarAgrupacionCriterio]  
 @CodConfiguracionReparto  UNIQUEIDENTIFIER,  
 @CodCriterio     UNIQUEIDENTIFIER = NULL,  
 @CodAgrupacion     UNIQUEIDENTIFIER = NULL  
AS    
BEGIN    
 DECLARE   
   @L_CodConfiguracionReparto  UNIQUEIDENTIFIER = @CodConfiguracionReparto,  
   @L_CodCriterio     UNIQUEIDENTIFIER = @CodCriterio,  
   @L_CodAgrupacion    UNIQUEIDENTIFIER = @CodAgrupacion  
   
 DELETE Catalogo.AgrupacionCriterio  
 WHERE TU_CodConfiguracionReparto = @L_CodConfiguracionReparto  
 AND  TU_CodCriterio    = COALESCE(@L_CodCriterio, TU_CodCriterio)  
 AND  TU_CodAgrupacion   = COALESCE(@L_CodAgrupacion, TU_CodAgrupacion)  
  
END
GO
