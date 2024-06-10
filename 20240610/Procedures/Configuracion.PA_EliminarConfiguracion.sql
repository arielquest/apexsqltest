SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Navarrete Alvarez>
-- Fecha de creación:		<4/20/2018>
-- Descripción :			<Permite Eliminar una Configuracion> 
-- =================================================================================================================================================

CREATE PROCEDURE  [Configuracion].[PA_EliminarConfiguracion]
  
   @CodConfiguracion varchar(27)
   
AS 
BEGIN
          
	DELETE 
	FROM Configuracion.Configuracion 
	WHERE TC_CodConfiguracion = @CodConfiguracion 

END
GO
