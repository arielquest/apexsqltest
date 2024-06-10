SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite borrar los horarios deshabilitados para la atención de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_EliminarHorarioCitaHabilitado] 
 @CodConfiguracion UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion

 --Lógica  
DELETE Catalogo.HorarioCitaHabilitado WHERE TU_CodConfiguracion = @L_CodConfiguracion

 END
GO
