SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jonathan Aguilar Navarro>
-- Fecha Creación:		<25/11/2019>
-- Descripcion:			<Permite eliminar una asociación entre TipoAudienci y TipoOficinaMateria>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoAudienciaTipoOficina]
	@CodTipoAudiencia		Smallint,
	@CodTipoOficina			Smallint,
	@CodMateria				Varchar(5)
AS
BEGIN

	DELETE
	FROM		Catalogo.TipoAudienciaTipoOficina	
	WHERE		TN_CodTipoAudiencia			=	@CodTipoAudiencia
	AND			TN_CodTipoOficina			=	@CodTipoOficina
	AND			TC_CodMateria				=	@CodMateria 

End

GO
