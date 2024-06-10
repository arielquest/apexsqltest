SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================    
-- Versión:           <1.0>    
-- Creado por:        <Xinia Soto V.>    
-- Fecha de creación: <09/07/2020>    
-- Descripción :   <Permite Consultar las si una intervención permite asociar parentesco  
-- =================================================================================================================================================    
  
CREATE PROCEDURE [Catalogo].[PA_ConsultarHabilitarParentesco]    
 @CodigoMateria  varchar(5),    
 @CodigoTipoIntervencion smallint   
As    
Begin    
 Declare @L_CodigoMateria  varchar(5) =  @CodigoMateria  
 Declare @L_CodigoTipoIntervencion smallint = @CodigoTipoIntervencion  
     
 Select isnull(TB_VinculoAgresor,0)   
 From Catalogo.MateriaTipoIntervencion   
 Where TC_CodMateria          =  @L_CodigoMateria and  
    TN_CodTipoIntervencion =  @L_CodigoTipoIntervencion and  
    TF_Inicio_Vigencia  <= GETDATE()  
  
End 
GO
