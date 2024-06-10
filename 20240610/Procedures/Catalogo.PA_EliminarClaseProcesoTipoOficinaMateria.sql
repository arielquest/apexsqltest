SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<26/04/2021>
-- Descripción :			<Permite desasociar un proceso de una clase, tipo oficina, materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarClaseProcesoTipoOficinaMateria]
	@CodigoProceso			smallint,
	@CodTipoOficina			smallint,
	@CodClase				int,
	@CodMateria				varchar(5)
 
AS 
    BEGIN
          
			 DELETE FROM Catalogo.ClaseProcesoTipoOficinaMateria
			 WHERE	TN_CodClase			= @CodClase
			 AND	TN_CodProceso		= @CodigoProceso
			 AND	TN_CodTipoOficina	= @CodTipoOficina
			 AND	TC_CodMateria		= @CodMateria
   END
GO
