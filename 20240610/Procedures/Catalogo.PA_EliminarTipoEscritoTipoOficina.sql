SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Autor:				<Andrew Allen Dawson>
-- Fecha Creación:		<23/09/2019>
-- Descripcion:			<Permite eliminar un registro de la tabla Catalogo.TipoEscritoTipoOficinaMateria>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoEscritoTipoOficina]
	@CodTipoOficina			SmallInt,
	@CodTipoEscrito			SmallInt,
	@CodMateria				Varchar(5)
AS
BEGIN

	DELETE
	FROM		Catalogo.TipoEscritoTipoOficina	
	WHERE		TC_CodMateria				=	@CodMateria
	AND			TN_CodTipoOficina			=	@CodTipoOficina
	AND			TN_CodTipoEscrito			=	@CodTipoEscrito

End

GO
