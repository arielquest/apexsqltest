SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<21/06/2018>
-- Descripción :			<Permite Consultar los TipoResolucion que tiene un tipo de oficina y materia. 
-- =================================================================================================================================================
-- Modificado por:			<31/05/2022><Jose Gabriel Cordero Soto><Se realiza ajuste en consulta para filtrar los registros inactivos del catalogo y si la fecha de asociacion es mayor a la fecha actual se quita del listado>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaTipoResolucion]
    @CodTipoOficina			smallint	= Null,
	@CodTipoResolucion		smallint	= Null,
	@CodMateria				Varchar(4)  = Null,
	@FechaAsociacion		Datetime2	= Null 
 As
 Begin 		
	--Registros activos
   If @FechaAsociacion  Is  Null 
	Begin
		SELECT		B.TN_CodTipoResolucion						AS Codigo, 
					B.TC_Descripcion							AS Descripcion, 
					B.TF_Inicio_Vigencia						AS FechaActivacion, 
					B.TF_Fin_Vigencia							AS FechaDesactivacion,
					A.TF_Inicio_Vigencia						AS FechaAsociacion, 
					'Split'										AS Split, 
					C.TN_CodTipoOficina							AS Codigo, 
					C.TC_Descripcion							AS Descripcion, 
					C.TF_Inicio_Vigencia						AS FechaActivacion, 
					C.TF_Fin_Vigencia							AS FechaDesactivacion,
					'Split'										AS Split,
					D.TC_CodMateria								AS Codigo,
					D.TC_Descripcion							AS Descripcion
		FROM		Catalogo.TipoOficinaTipoResolucion			AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoResolucion						AS	B WITH (Nolock) 
				ON	B.TN_CodTipoResolucion						=	A.TN_CodTipoResolucion 
		INNER JOIN	Catalogo.TipoOficina						AS	C WITH (Nolock) 
				ON	C.TN_CodTipoOficina							=	A.TN_CodTipoOficina
		LEFT JOIN	Catalogo.Materia							AS	D With (Nolock)
				ON	D.TC_CodMateria								=	A.TC_CodMateria
		WHERE		A.TN_CodTipoOficina							=	ISNULL(@CodTipoOficina,A.TN_CodTipoOficina) 
		and			A.TN_CodtIPOResolucion						=	ISNULL(@CodTipoResolucion,A.TN_CodTipoResolucion)
		and			A.TC_CodMateria								=	ISNULL(@CodMateria,	A.TC_CodMateria)
		and			A.TF_Inicio_Vigencia						<	GETDATE ()	 
		and			(B.TF_Fin_Vigencia							IS  NULL
		or			 B.TF_Fin_Vigencia							>=  GETDATE())
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	Else
	-- todos registros 	
		SELECT		B.TN_CodTipoResolucion						AS Codigo, 
					B.TC_Descripcion							AS Descripcion, 
					B.TF_Inicio_Vigencia						AS FechaActivacion, 
					B.TF_Fin_Vigencia							AS FechaDesactivacion,
					A.TF_Inicio_Vigencia						AS FechaAsociacion, 
					'Split'										AS Split, 
					C.TN_CodTipoOficina							AS Codigo, 
					C.TC_Descripcion							AS Descripcion, 
					C.TF_Inicio_Vigencia						AS FechaActivacion, 
					C.TF_Fin_Vigencia							AS FechaDesactivacion,
					'Split'										AS Split,
					D.TC_CodMateria								AS Codigo,
					D.TC_Descripcion							AS Descripcion
		FROM		Catalogo.TipoOficinaTipoResolucion			AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoResolucion						AS	B WITH (Nolock) 
				ON	B.TN_CodTipoResolucion					=	A.TN_CodTipoResolucion 
		INNER JOIN	Catalogo.TipoOficina						AS	C WITH (Nolock) 
				ON	C.TN_CodTipoOficina							=	A.TN_CodTipoOficina
		LEFT JOIN	Catalogo.Materia							AS	D With (Nolock)
				ON	D.TC_CodMateria								=	A.TC_CodMateria
		WHERE		A.TN_CodTipoOficina							=	ISNULL(@CodTipoOficina,A.TN_CodTipoOficina) 
		and			A.TN_CodtIPOResolucion						=	ISNULL(@CodTipoResolucion,A.TN_CodTipoResolucion)
		and			A.TC_CodMateria								=	ISNULL(@CodMateria,	A.TC_CodMateria)		
		Order By	B.TC_Descripcion, C.TC_Descripcion;
 End
GO
