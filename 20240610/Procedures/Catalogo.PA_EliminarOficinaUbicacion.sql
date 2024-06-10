SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Eliminar una asociacion OficinaUbicacion si no tiene funcionarios asociados> 
-- Modificación:		    <10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarOficinaUbicacion]
  
   @CodOficina		varchar(4),
   @CodUbicacion	int
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.OficinaUbicacion 
			 WHERE TC_CodOficina =			 @CodOficina   
			 AND   TN_CodUbicacion =		 @CodUbicacion 
	 
    END
 

GO
