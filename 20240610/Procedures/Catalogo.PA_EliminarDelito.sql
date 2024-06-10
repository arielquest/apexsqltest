SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite Eliminar una asociacion Delito> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarDelito]
  
   @CodDelito varchar(11)
   
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.Delito 
			 WHERE TN_CodDelito = @CodDelito 

    END
 

GO
