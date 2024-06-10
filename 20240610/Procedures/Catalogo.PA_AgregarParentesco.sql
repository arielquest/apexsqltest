SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
  
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Gerardo Lopez R>  
-- Fecha de creación:  <02/05/2016>  
-- Descripción :   <Permite Agregar un nuevo tipo parentestco  >  
-- Modificación:   <10/09/2020> <Xinia Soto V.> <Se cambia el código a entero.>  
-- =================================================================================================================================================  
   
  
CREATE PROCEDURE [Catalogo].[PA_AgregarParentesco]   
 @Codigo smallint,  
 @Descripcion varchar(50),  
 @Nivel smallint,  
 @TipoParentesco char(1),   
 @InicioVigencia datetime2,  
 @FinVigencia datetime2  
   
  
AS    
BEGIN    
  
 Insert Into  Catalogo.Parentesco  
 ( TC_CodParentesco, TC_Descripcion, TN_Nivel, TC_TipoParentesco, TF_Inicio_Vigencia,  TF_Fin_Vigencia )  
 Values  
 (@Codigo, @Descripcion,@Nivel, @TipoParentesco, @InicioVigencia,@FinVigencia )  
End  
  
  
  
GO
