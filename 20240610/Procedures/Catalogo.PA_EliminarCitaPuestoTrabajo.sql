SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite borrar los puestos de trabajo asociado a una cita>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_EliminarCitaPuestoTrabajo]
 @CodConfiguracion UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion

 --Lógica  
DELETE Catalogo.CitaPuestoTrabajo WHERE TU_CodConfiguracion = @L_CodConfiguracion

 END
GO
