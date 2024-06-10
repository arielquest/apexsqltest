SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<21/06/2018>
-- Descripción :			<Permite eliminar un TipoResolucion asociado a un tipo de oficina y materia> 

CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaTipoResolucion]
   @CodTipoOficina			smallint,
   @CodTipoResolucion		smallint,
   @CodMateria				Varchar(5)
 
AS 
    BEGIN
          
			 DELETE Catalogo.TipoOficinaTipoResolucion
			 WHERE TN_CodTipoOficina			= @CodTipoOficina
			 AND   TN_CodTipoResolucion	= @CodTipoResolucion
			 AND   TC_CodMateria				= @CodMateria

   END
 



GO
