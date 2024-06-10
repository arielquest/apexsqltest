SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Eliminar una clase asunto asociado con un tipo de oficina> 
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado:				<Alejandro Villalta><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- Modificado:				<Jeffry Hernández><12/07/2017><Se agrega el parámetro @CodMateria>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaClaseAsunto]
   @CodTipoOficina smallint,
   @CodClaseAsunto int,
   @CodMateria     Varchar(5)
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.TipoOficinaClaseAsunto
			 WHERE TN_CodTipoOficina = @CodTipoOficina
			 AND   TN_CodClaseAsunto = @CodClaseAsunto
			 AND   TC_CodMateria     = @CodMateria

   END
 
GO
