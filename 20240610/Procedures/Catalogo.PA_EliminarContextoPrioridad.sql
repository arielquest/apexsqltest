SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite eliminar una prioridad de un contexto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarContextoPrioridad]
   @CodContexto		varchar(4),
   @CodPrioridad	smallint
AS 
    BEGIN          
			 DELETE Catalogo.ContextoPrioridad
			 WHERE TC_CodContexto	= @CodContexto
			 AND   TN_CodPrioridad = @CodPrioridad

   END
 

GO
