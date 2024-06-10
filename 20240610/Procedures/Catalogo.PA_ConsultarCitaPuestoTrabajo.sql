SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <08/10/2020>  
-- Descripcion:     <Permite consultar los puestos asociados a una configuración de cita de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarCitaPuestoTrabajo] 
 @CodConfiguracion UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion  

 --Lógica  
 SELECT TC_CodPuestoTrabajo from Catalogo.CitaPuestoTrabajo WHERE TU_CodConfiguracion = @L_CodConfiguracion

 END
GO
