SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<22/09/2016>
-- Descripción :			<Permite eliminar una asociación entre tipo de evento y materia.>
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <30/12/2020> <Se modifica la tabla por TipoEventoTipoOficina>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoEventoTipoOficina]
   @CodTipoEvento		SMALLINT,
   @CodTipoOficina		SMALLINT,
   @CodMateria			VARCHAR(5)
AS 
BEGIN
--VARIABLES
DECLARE		@L_CodTipoEvento		SMALLINT	= @CodTipoEvento,
			@L_CodTipoOficina		SMALLINT	= @CodTipoOficina,
			@L_CodMateria			VARCHAR(5)	= @CodMateria
--LÓGICA
	DELETE FROM		Catalogo.TipoEventoTipoOficina WITH(ROWLOCK)
	WHERE			TN_CodTipoEvento	= @L_CodTipoEvento
	AND				TN_CodTipoOficina	= @L_CodTipoOficina
	AND				TC_CodMateria		= @L_CodMateria;
END

GO
