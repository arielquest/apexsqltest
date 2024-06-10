SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Permite Consultar Domicilios> 
--
-- Modificación:			<15/02/2015> <Andrés Díaz> <Se elimina el campo Telefono de la tabla.>
-- Modificación:			<19/02/2015> <Andrés Díaz> <Se agrega el campo RequiereRegionalidad de la tabla Pais y se modifican joins.>
-- Modificado :				<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación:			<Andrés Díaz><24/08/2017><Se vuelve a tabular el PA.>
-- Modificación:			<Jonathan Aguilar Navarro> <08/10/2019> <Se cambia el nombre del campo TB_Activo por TB_DomicilioHabitual>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ConsultarDomicilio]
	@CodPersona		uniqueidentifier
As
Begin
	Select			A.TU_CodDomicilio			As	CodigoDomicilio,
					A.TC_Direccion				As	Direccion,
					A.TB_DomicilioHabitual	    As	Activo,				      
					'SplitTD'					As	SplitTD,
					A.TN_CodTipoDomicilio		As CodigoTipoDomicilio,
					B.TC_Descripcion			As  DescripcionTipoDomicilio,
					A.TC_CodPais				As CodigoPais,
					G.TC_Descripcion			As  DescripcionPais, 
					G.TB_RequiereRegionalidad	As RequiereRegionalidad,
					A.TN_CodProvincia			As CodigoProvincia,
					C.TC_Descripcion			As	DescripcionProvincia,
					A.TN_CodCanton				As CodigoCanton,
					D.TC_Descripcion			As	DescripcionCanton,
					A.TN_CodDistrito			As CodigoDistrito,
					E.TC_Descripcion			As	DescripcionDistrito,
					A.TN_CodBarrio				As CodigoBarrio,
					F.TC_Descripcion			As  DescripcionBarrio
	From			Persona.Domicilio			As A With(Nolock)
	Inner Join		Catalogo.TipoDomicilio		As B With(Nolock) 
	On				B.TN_CodTipoDomicilio		= A.TN_CodTipoDomicilio
	Left Join		Catalogo.Provincia			As C With(Nolock) 
	On				C.TN_CodProvincia			= A.TN_CodProvincia
	Left Join		Catalogo.Canton				As D With(Nolock) 
	On				D.TN_CodCanton				= A.TN_CodCanton 
	And				D.TN_CodProvincia			= A.TN_CodProvincia
	Left Join		Catalogo.Distrito			As E With(Nolock) 
	On				E.TN_CodDistrito			= A.TN_CodDistrito 
	And				E.TN_CodCanton				= A.TN_CodCanton
	And				E.TN_CodProvincia			= A.TN_CodProvincia
	Left Join		Catalogo.Barrio				As F With(Nolock) 
	On				F.TN_CodBarrio				= A.TN_CodBarrio
	And				E.TN_CodDistrito			= A.TN_CodDistrito 
	And				E.TN_CodCanton				= A.TN_CodCanton
	And				E.TN_CodProvincia			= A.TN_CodProvincia
	Inner Join		Catalogo.Pais				As G With(Nolock) 
	On				G.TC_CodPais				= A.TC_CodPais
	Where			A.TU_CodPersona				= @CodPersona;
End
GO
