SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
--Versión:	<1.0>  Creado por: <Rafa Badilla Alvarado> Fecha de creación:<29/09/2022> Descripción :	<Permite eliminar las materias asociadas a un tipo de medida. 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_EliminarTipoMedidaMateria]
   @CodTipoMedida int,
   @CodMateria     Varchar(4)
 
AS 
    BEGIN          
			 DELETE FROM	Catalogo.TipoMedidaMateria
			 WHERE			TN_CodTipoMedida		= @CodTipoMedida
			 AND			TC_CodMateria			= @CodMateria

   END
 
GO
