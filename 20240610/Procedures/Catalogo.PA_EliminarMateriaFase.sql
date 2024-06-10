SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Acosta Ibañez>
-- Fecha de creación:	<25/08/2015>
-- Descripción :		<Permite eliminar una fase asociada a una materia> 

-- Modificado por:		<Alejandro Villalta><07/01/2016><Modificar el tipo de dato del codigo de fase.>
-- Modificado por:		<Pablo Alvarez><02/12/2016><Modificar el campo TN_CodFase.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarMateriaFase]
   @CodMateria		varchar(5),
   @CodFase			smallint, 
   @CodTipoOficina	smallint 
 
AS 
    BEGIN
          
			 DELETE Catalogo.MateriaFase 
			 WHERE TC_CodMateria	= @CodMateria
			 AND   TN_CodFase		= @CodFase
			 AND	TN_CodTipoOficina = @CodTipoOficina

   END
 


GO
