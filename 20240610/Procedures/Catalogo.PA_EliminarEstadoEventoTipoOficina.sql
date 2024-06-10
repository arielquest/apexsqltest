SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<07/01/2021>
-- Descripción :			<Permite eliminar una asociación entre estado de evento y materia.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarEstadoEventoTipoOficina]
   @CodEstadoEvento		SMALLINT,
   @CodTipoOficina		SMALLINT,
   @CodMateria			VARCHAR(5)
AS 
BEGIN
--VARIABLES
DECLARE		@L_CodEstadoEvento		SMALLINT	= @CodEstadoEvento,
			@L_CodTipoOficina		SMALLINT	= @CodTipoOficina,
			@L_CodMateria			VARCHAR(5)	= @CodMateria
--LÓGICA
	DELETE FROM		Catalogo.EstadoEventoTipoOficina WITH(ROWLOCK)
	WHERE			TN_CodEstadoEvento	= @L_CodEstadoEvento
	AND				TN_CodTipoOficina	= @L_CodTipoOficina
	AND				TC_CodMateria		= @L_CodMateria;
END

GO
