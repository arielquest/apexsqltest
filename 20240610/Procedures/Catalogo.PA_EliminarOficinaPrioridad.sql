SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite eliminar una prioridad de una oficina> 
-- Modificado:              <Pablo Alvarez Espinoza>
-- Fecha Modifica:		    <07/01/2015>
-- Descripcion:			    <Se cambia la llave a smallint>
-- Modificación:			<21/12/2016> <Pablo Alvarez> <Se corrige TN_CodPrioridad por estandar.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarOficinaPrioridad]
   @CodOficina		varchar(4),
   @CodPrioridad	smallint
AS 
    BEGIN
          
			 DELETE Catalogo.OficinaPrioridad
			 WHERE TC_CodOficina	= @CodOficina
			 AND   TN_CodPrioridad = @CodPrioridad

   END
 

GO
