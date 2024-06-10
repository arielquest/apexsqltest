SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Autor:				<Jeffry Hernández>
-- Fecha Creación:		<08/08/2017>
-- Descripcion:			<Permite agregar un registro a la tabla Catalogo.FormatoJuridicoTipoOficina>
-- ==========================================================================================
-- Modificacion			<Jonathan Aguilar Navarro> <02/07/2018> <Se agregan los campos TB_EsResolucion y TN_CodTipoResolucion>
-- Modificacion			<Johan Acosta Ibañez> <06/11/2018> <Se agrega el campo CalculoIntereses>
-- ==========================================================================================

CREATE Procedure [Catalogo].[PA_AgregarFormatoJuridicoTipoOficina]
	@CodFormatoJuridico		Varchar(8),
	@CodTipoOficina			SmallInt,
	@CodMateria				Varchar(5),
	@EsResolucion			bit,
	@CodTipoResolucion		smallint, 
	@CalculoIntereses		bit,
	@InicioVigencia		    DATETIME2
    
As
Begin

	Insert Into	Catalogo.FormatoJuridicoTipoOficina
	(
		TC_CodFormatoJuridico , TN_CodTipoOficina,	TC_CodMateria,		TF_Inicio_Vigencia,
		TB_EsResolucion,		TN_CodTipoResolucion, TB_CalculoIntereses
	
	)
	Values
	(
		@CodFormatoJuridico,	@CodTipoOficina,	@CodMateria,		@InicioVigencia,
		@EsResolucion,			@CodTipoResolucion, @CalculoIntereses

	)

End;
GO
