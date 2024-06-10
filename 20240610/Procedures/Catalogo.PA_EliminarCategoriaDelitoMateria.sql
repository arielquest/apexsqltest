SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<06/02/2018>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarCategoriaDelitoMateria]
   @CodCategoriaDelito int,
   @CodMateria     Varchar(4)
 
AS 
    BEGIN          
			 DELETE FROM	Catalogo.CategoriaDelitoMateria
			 WHERE			TN_CodCategoriaDelito	= @CodCategoriaDelito
			 AND			TC_CodMateria			= @CodMateria

   END
 
GO
