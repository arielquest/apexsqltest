SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite consultar las materias asociadas a una categoría de delio 

CREATE PROCEDURE [Catalogo].[PA_ConsultarCategoriaDelitoMateria]
   @CodCategoriaDelito		smallint	= Null,
   @CodMateria				varchar(4)	= Null,
   @FechaAsociacion			Datetime2	= Null
As
Begin

	SELECT		A.TF_Inicio_Vigencia				AS	FechaAsociacion, 			
				B.TN_CodCategoriaDelito				AS	Codigo, 
				B.TC_Descripcion					AS	Descripcion, 
				B.TF_Inicio_Vigencia				AS	FechaActivacion, 
				B.TF_Fin_Vigencia					AS	FechaDesactivacion,				
				'Split'								AS	Split,
				C.TC_CodMateria						AS	Codigo,				
				C.TC_Descripcion					AS	Descripcion,
				C.TB_EjecutaRemate					AS	EjecutaRemate,
				C.TF_Inicio_Vigencia				AS	FechaActivacion,	
				C.TF_Fin_Vigencia					AS	FechaDesactivacion

	FROM		Catalogo.CategoriaDelitoMateria		AS	A WITH (Nolock) 
	INNER JOIN	Catalogo.CategoriaDelito			AS	B WITH (Nolock)
	ON			B.TN_CodCategoriaDelito				=	A.TN_CodCategoriaDelito
	INNER JOIN  Catalogo.Materia					AS	C WITH (Nolock)
	ON			C.TC_CodMateria						=	A.TC_CodMateria				
	WHERE		A.TN_CodCategoriaDelito				=	COALESCE(@CodCategoriaDelito, A.TN_CodCategoriaDelito)
	AND			A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
	AND			A.TF_Inicio_Vigencia				<=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;

End

GO
