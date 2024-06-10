SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Eliminar una clase asunto asociado con un tipo de oficina>
-- ================================================================================================================================================= 
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado:				<Alejandro Villalta><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- Modificado:				<Jeffry Hernández><12/07/2017><Se agrega el parámetro @CodMateria>
-- Modificación:			<Jonathan Aguilar Navarro> <01/02/2019> < Se cambia el nombre del SP, se actualiza el nombre de la tabla> 
-- Modificación:			<Jonathan Aguilar Navarro> <01/02/2019> < Se cambia el nombre del SP, se actualiza el nombre de la tabla>
-- Modificación:			<Isaac Dobles Mata> <05/07/2019> <Se ajusta para estructura de catalogos de desarrollo expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaClase]
   @CodTipoOficina smallint,
   @CodClase	   int,
   @CodMateria     Varchar(5)
 
AS 
    BEGIN          
			 DELETE FROM Catalogo.ClaseTipoOficina
			 WHERE TN_CodTipoOficina	= @CodTipoOficina
			 AND   TN_CodClase			= @CodClase
			 AND   TC_CodMateria		= @CodMateria

   END
 
GO
