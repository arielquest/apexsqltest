SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<20/04/2016>
-- Descripción :			<Permite Eliminar una presentacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_EliminarPresentacion]
   @CodPresentacion smallint   
AS 
    BEGIN
          
			 DELETE FROM Consulta.Presentacion 
			 WHERE TN_CodPresentacion = @CodPresentacion

    END
 

GO
