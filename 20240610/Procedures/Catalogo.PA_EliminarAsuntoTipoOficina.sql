SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<19/02/2019>
-- Descripcion:			<Permite eliminar un registro de la tabla Catalogo.AsuntoTipoOficina>
-- Modificación :		<14/03/2023><Elías González Porras><Se agregar la codición AND TN_CodAsunto = @CodAsunto  
--                      para especificar que la asociación que se quiere eliminar es la del asunto seleccionado>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarAsuntoTipoOficina]
	@CodTipoOficina			SmallInt,
	@CodAsunto				int,
	@CodMateria				Varchar(5)
AS
BEGIN

	DELETE
	FROM		Catalogo.AsuntoTipoOficina	
	WHERE		TC_CodMateria				=	@CodMateria
	AND			TN_CodTipoOficina			=	@CodTipoOficina
	AND			TN_CodAsunto				=	@CodAsunto

End

GO
