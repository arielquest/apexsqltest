SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<08/08/2017>
-- Descripcion:			<Permite eliminar un registro a la tabla Catalogo.FormatoJuridicoTipoOficina>
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_EliminarFormatoJuridicoTipoOficina]
	@CodFormatoJuridico		Varchar(8),
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5)
As
Begin

	Delete
	From	Catalogo.FormatoJuridicoTipoOficina
	Where	TC_CodFormatoJuridico	=	@CodFormatoJuridico
	And		TC_CodMateria			=	@CodMateria
	And		TN_CodTipoOficina		=	@CodTipoOficina


End;
GO
