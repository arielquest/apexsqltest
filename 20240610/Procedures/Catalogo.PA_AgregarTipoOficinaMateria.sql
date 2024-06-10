SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<12/07/2017>
-- Descripcion:			<Permite agregar un registro a la tabla Catalogo.TipoOficinaMateria>
-- =================================================================================================================================================
-- Modificación:		<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia'.>
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoOficinaMateria]
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5),
	@InicioVigencia		    DateTime2
As
Begin

	Insert Into	Catalogo.TipoOficinaMateria
	(
		TN_CodTipoOficina,			TC_CodMateria,		TF_Inicio_Vigencia
	)
	Values
	(
		@CodTipoOficina,			@CodMateria,		@InicioVigencia
	)
End;
GO
