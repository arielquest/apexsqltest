SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite asociar una prioridad a una oficina>
-- Modificado:              <Pablo Alvarez Espinoza>
-- Fecha Modifica:		    <07/01/2015>
-- Descripcion:			    <Se cambia la llave a smallint>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarOficinaPrioridad]
   @CodOficina varchar(4),
   @CodPrioridad smallint,
   @Inicio_Vigencia datetime2(7)
AS 
    BEGIN
          
			 INSERT INTO Catalogo.OficinaPrioridad
			   (TC_CodOficina,TN_CodPrioridad, TF_Inicio_Vigencia)
			 VALUES
				   (@CodOficina,@CodPrioridad, @Inicio_Vigencia )
    END
 

GO
