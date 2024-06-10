SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Donald Vargas>  
-- Fecha de creación:  <26/04/2016>  
-- Descripción :   <Permite eliminar un Archivo>   
-- =================================================================================================================================================  
-- Modificado por:          <Tatiana Flores> <12/09/2017> <Agrega el borrado lógico>   
-- Modificado por:       <Isaac Dobles> <19/09/2018> <Se modifica nombre de SP y se modifica para eliminar de la tabla ArchivoExpediente>  
-- Modificado por:       <Isaac Dobles> <02/05/2019> <Se agrega eliminación sobre tabla Expediente.LegajoArchivo si el registro existe en esa tabla>  
-- Modificado por:       <Xinia Soto>   <26/05/2020> <Se agrega eliminación sobre tabla Expediente.IntervencionArchivo si el registro existe en esa tabla>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_EliminarArchivo]  
 @CodArchivo uniqueidentifier,  
 @EsFisico bit  
AS    
BEGIN    
 IF @EsFisico = 1  
 BEGIN  
  DELETE FROM Expediente.IntervencionArchivo WHERE TU_CodArchivo = @CodArchivo  
  DELETE FROM Expediente.LegajoArchivo WHERE TU_CodArchivo = @CodArchivo  
  DELETE FROM Expediente.ArchivoExpediente WHERE TU_CodArchivo = @CodArchivo  
  DELETE FROM Archivo.Archivo WHERE TU_CodArchivo = @CodArchivo  
 END  
 ELSE  
 BEGIN  
  UPDATE Expediente.ArchivoExpediente SET TB_Eliminado = 1 WHERE TU_CodArchivo = @CodArchivo  
 END  
END  
GO
