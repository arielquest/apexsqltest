SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<08/08/2017>
-- Descripcion:			<Permite eliminar un registro a la tabla Catalogo.FormatoJuridicoProcedimiento>
-- Modificación		    <30/05/2018> <Isaac Dobles Mata>  <Se cambia nombre y se ajusta a tabla FormatoJuridicoProceso> 
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_EliminarFormatoJuridicoProceso]
	@CodFormatoJuridico		Varchar(8),
	@CodClase				Int,
	@CodProceso				SmallInt,
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5)
As
Begin

	Delete
	From	Catalogo.FormatoJuridicoProceso
	Where	TC_CodFormatoJuridico	=	@CodFormatoJuridico
	And		TN_CodClase				=	@CodClase
	And		TN_CodProceso			=	@CodProceso
	And     TN_CodTipoOficina		=	@CodTipoOficina
	And     TC_CodMateria			=	@CodMateria

End;
GO
