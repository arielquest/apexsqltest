SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<12/07/2017>
-- Descripcion:			<Permite eliminar un registro de la tabla Catalogo.TipoOficinaMateria>
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_EliminarTipoOficinaMateria]
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5)
As
Begin

	Delete
	From	Catalogo.TipoOficinaMateria	
	Where	TC_CodMateria		=	@CodMateria
	And		TN_CodTipoOficina	=	@CodTipoOficina

End;
GO
