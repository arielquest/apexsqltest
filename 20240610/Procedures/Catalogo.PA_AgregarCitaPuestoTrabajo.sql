SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <08/10/2020>  
-- Descripcion:     <Permite ingresar un registro para asociar un puesto de trabajo a la configiración de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_AgregarCitaPuestoTrabajo] 
 @CodConfiguracion UNIQUEIDENTIFIER, 
 @CodPuesto		   VARCHAR(14)
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion, 
 @L_CodPuesto                VARCHAR(14)       = @CodPuesto  

 --Lógica  
 INSERT INTO Catalogo.CitaPuestoTrabajo VALUES(@L_CodConfiguracion, @L_CodPuesto, GETDATE())

 END
GO
