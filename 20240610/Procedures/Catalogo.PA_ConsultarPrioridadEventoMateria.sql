SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<14/11/2016>
-- Descripción :			<Permite consultar registros de Catalogo.PrioriodadEventoMateria.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPrioridadEventoMateria]
	@CodPrioridadEvento		smallint	= Null,
	@CodMateria				varchar(2)	= Null,
	@FechaAsociacion		datetime2	= Null
 As
 Begin

	--Registros activos
	If @FechaAsociacion  Is Null 
	Begin
		Select		B.TC_CodMateria					As	Codigo, 
					B.TC_Descripcion				As	Descripcion, 
					B.TF_Inicio_Vigencia			As	FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					A.TF_Inicio_Vigencia			As	FechaAsociacion, 
					'Split'							As	Split, 
					C.TN_CodPrioridadEvento			As	Codigo, 
					C.TC_Descripcion				As	Descripcion, 
					C.TF_Inicio_Vigencia			As	FechaActivacion, 
					C.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.PrioridadEventoMateria	As	A With(NoLock)
		Inner Join	Catalogo.Materia				As	B With(NoLock)
		On			B.TC_CodMateria					=	A.TC_CodMateria
		Inner Join	Catalogo.PrioridadEvento		As	C With(NoLock)
		On			C.TN_CodPrioridadEvento			=	A.TN_CodPrioridadEvento
		Where		(A.TN_CodPrioridadEvento		=	@CodPrioridadEvento	
		Or			A.TC_CodMateria					=	@CodMateria)
		And			A.TF_Inicio_Vigencia			<	GETDATE ()
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	-- todos registros
	Else
	Begin
		Select		B.TC_CodMateria					As	Codigo, 
					B.TC_Descripcion				As	Descripcion, 
					B.TF_Inicio_Vigencia			As	FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					A.TF_Inicio_Vigencia			As	FechaAsociacion, 
					'Split'							As	Split, 
					C.TN_CodPrioridadEvento			As	Codigo, 
					C.TC_Descripcion				As	Descripcion, 
					C.TF_Inicio_Vigencia			As	FechaActivacion, 
					C.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.PrioridadEventoMateria	As	A With(NoLock)
		Inner Join	Catalogo.Materia				As	B With(NoLock)
		On			B.TC_CodMateria					=	A.TC_CodMateria
		Inner Join	Catalogo.PrioridadEvento		As	C With(NoLock)
		On			C.TN_CodPrioridadEvento			=	A.TN_CodPrioridadEvento
		Where		(A.TN_CodPrioridadEvento		=	@CodPrioridadEvento	
		Or			A.TC_CodMateria					=	@CodMateria)
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End

End
GO
