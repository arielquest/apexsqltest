SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<08/08/2017>
-- Descripcion:			<Permite agregar un registro a la tabla Catalogo.FormatoJuridicoProcedimiento>
-- Modificacion:		<07/02/2019> <Isaac Dobles> <Se cambia nombre a PA_AgregarFormatoJuridicoProceso y se ajusta a nueva estructura>
-- ==========================================================================================
CREATE Procedure [Catalogo].[PA_AgregarFormatoJuridicoProceso]
	@CodFormatoJuridico		Varchar(8),
	@CodClase				Int,
	@CodProceso				SmallInt,
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5),
	@InicioVigencia		    DateTime2
As
Begin

	Insert Into	Catalogo.FormatoJuridicoProceso
	(
		TC_CodFormatoJuridico , TN_CodClase,	TN_CodProceso,	TF_Inicio_Vigencia,
		TN_CodTipoOficina,	TC_CodMateria
	)
	Values
	(
		@CodFormatoJuridico,	@CodClase,	@CodProceso,		@InicioVigencia,
		@CodTipoOficina,	@CodMateria
	)

End;
GO
