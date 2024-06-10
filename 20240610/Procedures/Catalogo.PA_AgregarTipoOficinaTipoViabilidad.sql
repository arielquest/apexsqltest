SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Agregar una clase asunto a un tipo de oficina>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficinaTipoViabilidad]
   @CodTipoOficina smallint,
   @CodTipoViabilidad smallint,
   @Inicio_Vigencia datetime2(7)
AS 
    BEGIN
          
			 INSERT INTO Catalogo.TipoOficinaTipoViabilidad
			   (TN_CodTipoOficina,TN_CodTipoViabilidad, TF_Inicio_Vigencia)
			 VALUES
				   (@CodTipoOficina,@CodTipoViabilidad, @Inicio_Vigencia )
    END
 

GO
