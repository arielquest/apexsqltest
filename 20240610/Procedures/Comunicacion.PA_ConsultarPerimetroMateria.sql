SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<30/01/2017>
-- Descripción :			<Permite consultar registros de Comunicacion.PerimetroMateria.>
-- ================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarPerimetroMateria]
	@CodPerimetro			smallint	= Null,
	@CodMateria				varchar(2)	= Null,
	@FechaAsociacion		datetime2	= Null
 As
 Begin

	-- Registros activos
	If @FechaAsociacion  Is Null 
	Begin
		Select		B.TC_CodMateria					As	Codigo, 
					B.TC_Descripcion				As	Descripcion, 
					B.TF_Inicio_Vigencia			As	FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					A.TF_Inicio_Vigencia			As	FechaAsociacion, 
					'Split'							As	Split, 
					C.TN_CodPerimetro				As	Codigo, 
					C.TC_Descripcion				As	Descripcion, 
					C.TF_Inicio_Vigencia			As	FechaActivacion, 
					C.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Comunicacion.PerimetroMateria	As	A With(NoLock)
		Inner Join	Catalogo.Materia				As	B With(NoLock)
		On			B.TC_CodMateria					=	A.TC_CodMateria
		Inner Join	Comunicacion.Perimetro			As	C With(NoLock)
		On			C.TN_CodPerimetro				=	A.TN_CodPerimetro
		Where		(A.TN_CodPerimetro				=	@CodPerimetro	
		Or			A.TC_CodMateria					=	@CodMateria)
		And			A.TF_Inicio_Vigencia			<	GETDATE ()
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	-- Todos los registros
	Else
	Begin
		Select		B.TC_CodMateria					As	Codigo, 
					B.TC_Descripcion				As	Descripcion, 
					B.TF_Inicio_Vigencia			As	FechaActivacion, 
					B.TF_Fin_Vigencia				As	FechaDesactivacion,
					A.TF_Inicio_Vigencia			As	FechaAsociacion, 
					'Split'							As	Split, 
					C.TN_CodPerimetro				As	Codigo, 
					C.TC_Descripcion				As	Descripcion, 
					C.TF_Inicio_Vigencia			As	FechaActivacion, 
					C.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Comunicacion.PerimetroMateria	As	A With(NoLock)
		Inner Join	Catalogo.Materia				As	B With(NoLock)
		On			B.TC_CodMateria					=	A.TC_CodMateria
		Inner Join	Comunicacion.Perimetro			As	C With(NoLock)
		On			C.TN_CodPerimetro				=	A.TN_CodPerimetro
		Where		(A.TN_CodPerimetro				=	@CodPerimetro	
		Or			A.TC_CodMateria					=	@CodMateria)
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End

End
GO
