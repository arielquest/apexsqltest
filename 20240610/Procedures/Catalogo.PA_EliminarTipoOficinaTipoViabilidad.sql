SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<24/08/2015>
-- Descripción :			<Permite eliminar un tipo de viabilidad de un tipo de oficina> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaTipoViabilidad]
   @CodTipoOficina		smallint,
   @CodTipoViabilidad	 smallint
 
AS 
    BEGIN
          
			 DELETE Catalogo.TipoOficinaTipoViabilidad
			 WHERE TN_CodTipoOficina	= @CodTipoOficina
			 AND   TN_CodTipoViabilidad = @CodTipoViabilidad

   END
 

GO
