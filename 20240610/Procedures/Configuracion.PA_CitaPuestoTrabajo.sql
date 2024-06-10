SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite borrar los horarios deshabilitados para la atención de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Configuracion].[PA_CitaPuestoTrabajo]
 @CodConfiguracion UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion

 --Lógica  
DELETE Configuracion.CitaPuestoTrabajo WHERE TU_CodConfiguracion = @L_CodConfiguracion

 END
GO
