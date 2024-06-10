SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<25/04/2016>
-- Descripción :			<Permite Eliminar un modulo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_EliminarModulo]
   @CodModulo smallint   
AS 
    BEGIN
          
			 DELETE FROM Consulta.Modulo
			 WHERE TN_CodModulo = @CodModulo

    END
 

GO
