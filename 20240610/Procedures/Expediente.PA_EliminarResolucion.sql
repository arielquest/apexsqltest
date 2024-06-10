SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Autor:    <Jeffry Hernández>  
-- Fecha Creación:  <17/04/2018>  
-- Descripcion:   <Elimina un registro de Expediente.Resolucion luego de haber eliminado los registros de otras tablas que lo referencian>  
-- Modificación:        <23/05/2018> <Ailyn López> <Se agrega dentro de una transacción>  
-- Modificación   <Jonathan Aguilar Navarro> <16/07/2018> <Se eliminan las tablas RESOLUCIONNOTA,RESOLUCIONVOTOSALVADO>  
--      ResultadoResolucionInterviniente  
-- Modificación   <Xinia Soto V.> <14/08/2020> <Se agrega cambio para modificar el libro de sentencia>  
-- =============================================  
CREATE PROCEDURE [Expediente].[PA_EliminarResolucion]  
 @CodResolucion uniqueidentifier  
AS  
BEGIN  
 BEGIN TRY  
  BEGIN TRANSACTION;  
   DELETE   
   FROM Expediente.Resolucion  
   WHERE TU_CodResolucion = @CodResolucion   

  update Expediente.LibroSentencia set TC_Estado= 'I', TF_Actualizacion=GETDATE() where TU_CodResolucion = @CodResolucion
  COMMIT TRANSACTION;  
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT > 0  
   ROLLBACK TRANSACTION;  
   THROW;  
 END CATCH  
END  

GO
