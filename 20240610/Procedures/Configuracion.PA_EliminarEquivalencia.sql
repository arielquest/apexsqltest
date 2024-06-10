SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    <1.0> 
-- Creado por:   <Fabian Sequeira> 
-- Fecha de creación: <13/02/2021> 
-- Descripción:   <Permite eliminar un registro en la tabla: Equivalencia.>
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Configuracion].[PA_EliminarEquivalencia]   
@Codigo      UNIQUEIDENTIFIER 
AS BEGIN  
--Variables  
DECLARE @L_TU_Codigo    UNIQUEIDENTIFIER  = @Codigo   
--Lógica  
DELETE  FROM Configuracion.Equivalencia WITH (ROWLOCK)  WHERE TU_Codigo     = @L_TU_Codigo 
END
GO
