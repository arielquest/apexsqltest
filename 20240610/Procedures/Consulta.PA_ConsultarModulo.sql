SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez>
-- Fecha de creación:		<25/04/2016>
-- Descripción :			<Permite Consultar los modulos de consulta> 
-- Modificado por:			<>
-- Fecha de creación:		<>
-- Descripción :			<> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_ConsultarModulo]
	@CodModulo			int				= Null,
	@CodSeccion			int				= Null,
	@Nombre				varchar(50)		= Null,		
	@FechaActivacion	datetime2		= Null,	
	@FechaDesactivacion	datetime2		= Null	
	
As
Begin
	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Nombre Is Not Null,'%' + @Nombre + '%','%')

	--Todos
	If  @FechaDesactivacion Is Null And @CodModulo Is Null And @CodSeccion Is Null
	Begin
			Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
			Where	A.TC_Nombre like @ExpresionLike 
	End

	--Por Llave @CodModulo
	Else If  @CodModulo Is Not Null
	Begin
			Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
			Where	A.TN_CodModulo		=	@CodModulo
	End	

	--Por Llave @CodSeccion
	Else If  @CodSeccion Is Not Null
	Begin
			Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
			Where	A.TN_CodSeccion		=	@CodSeccion
	End	

	--Por activos
	Else If  @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
			Where	A.TC_Nombre				like	@ExpresionLike 
			And		A.TF_Inicio_Vigencia		< GETDATE ()
			And		(	A.TF_Fin_Vigencia		Is Null 
					OR	A.TF_Fin_Vigencia		>= GETDATE ())
	End

	--Por inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null		
		Begin
			Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
			Where	A.TC_Nombre				like	@ExpresionLike 
			And		(	A.TF_Inicio_Vigencia	> GETDATE ()
					Or	A.TF_Fin_Vigencia		< GETDATE ())
		End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select	A.TN_CodModulo			As	Codigo,				A.TC_Nombre			As	Nombre,
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitSeccion'			As	SplitSeccion,
					B.TN_CodSeccion			As	Codigo,				B.TC_Nombre			As	Nombre,		
					B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion,
					'SplitMateria'			As	SplitMateria,
					C.TC_CodMateria			As	Codigo,				C.TC_Descripcion	As	Descripcion,
					C.TF_Inicio_Vigencia	As	FechaActivacion,	C.TF_Fin_Vigencia	As	FechaDesactivacion
			From	Consulta.Modulo			A
			Join	Consulta.Seccion		B	On	B.TN_CodSeccion	=	A.TN_CodSeccion
			Join	Catalogo.Materia		C	On	C.TC_CodMateria	=	A.TC_CodMateria
		Where	A.TC_Nombre					like	@ExpresionLike 
		And		A.TF_Inicio_Vigencia	>= @FechaActivacion
		And		A.TF_Fin_Vigencia		<= @FechaDesactivacion 
	End
End

GO
