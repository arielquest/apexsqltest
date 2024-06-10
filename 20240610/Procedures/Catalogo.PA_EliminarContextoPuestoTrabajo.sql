SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jonathan Aguilar Navarro>
-- Fecha Creación:		<03/04/2018>
-- Descripcion:			<Permite eliminar un registro de la tabla Catalogo.ContextoPuestoTrabajo>
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_EliminarContextoPuestoTrabajo]
	@CodPuestoTrabajo		Varchar(14),
	@CodContexto			Varchar(4)
As
Begin

	Delete
	From	Catalogo.ContextoPuestoTrabajo	
	Where	TC_CodPuestoTrabajo		=	@CodPuestoTrabajo
	And		TC_CodContexto			=	@CodContexto

End;
GO
