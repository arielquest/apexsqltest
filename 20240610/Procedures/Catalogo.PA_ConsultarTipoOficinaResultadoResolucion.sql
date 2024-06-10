SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo AlvareZ>
-- Fecha de creación:		<06/11/2015>
-- Descripción :			<Permite Consultar los ResultadoResolucions que tiene un tipo de oficina. 
-- =================================================================================================================================================
-- Modificación:			<17/11/2015> <Johan Acosta>	
-- Modificación:			<16/12/2015> <Johan Acosta> <Cambio tipo smallint TN_CodResultadoResolucion >
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificación:			<19/05/2018> <Jonathan Aguilar Navarro> <Se agrega la materia al resultado de la consulta>
-- =================================================================================================================================================
-- Modificado por:			<31/05/2022><Jose Gabriel Cordero Soto><Se realiza ajuste en consulta para filtrar los registros inactivos del catalogo y si la fecha de asociacion es mayor a la fecha actual se quita del listado>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaResultadoResolucion]
    @CodTipoOficina			smallint	= Null,
	@CodResultadoResolucion	smallint	= Null,
	@CodMateria				Varchar(4)	= null,
	@FechaAsociacion		Datetime2	= Null 
 As
 Begin 		
	--Registros activos
   If @FechaAsociacion  Is  Null 
	Begin
		SELECT		B.TN_CodResultadoResolucion					AS Codigo, 
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
		FROM		Catalogo.TipoOficinaResultadoResolucion		AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.ResultadoResolucion				AS	B WITH (Nolock) 
				ON	B.TN_CodResultadoResolucion					=	A.TN_CodResultadoResolucion 
		INNER JOIN	Catalogo.TipoOficina						AS	C WITH (Nolock) 
				ON	C.TN_CodTipoOficina							=	A.TN_CodTipoOficina
		LEFT JOIN	Catalogo.Materia							AS	D With (Nolock)
				ON	D.TC_CodMateria								=	A.TC_CodMateria
		WHERE		A.TN_CodTipoOficina							=	ISNULL(@CodTipoOficina,A.TN_CodTipoOficina) 
		and			A.TN_CodResultadoResolucion					=	ISNULL(@CodResultadoResolucion,A.TN_CodResultadoResolucion)
		and			A.TC_CodMateria								=	ISNULL(@CodMateria,	A.TC_CodMateria)
		And			A.TF_Inicio_Vigencia						<	GETDATE ()	 
		and			(B.TF_Fin_Vigencia							IS  NULL
		or			 B.TF_Fin_Vigencia							>=  GETDATE())
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	Else
	-- todos registros 	
		SELECT		B.TN_CodResultadoResolucion					AS Codigo, 
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
		FROM		Catalogo.TipoOficinaResultadoResolucion		AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.ResultadoResolucion				AS	B WITH (Nolock) 
				ON	B.TN_CodResultadoResolucion					=	A.TN_CodResultadoResolucion 
		INNER JOIN	Catalogo.TipoOficina						AS	C WITH (Nolock) 
				ON	C.TN_CodTipoOficina							=	A.TN_CodTipoOficina
		LEFT JOIN	Catalogo.Materia							AS	D With (Nolock)
				ON	D.TC_CodMateria								=	A.TC_CodMateria
		WHERE		A.TN_CodTipoOficina						=	ISNULL(@CodTipoOficina,A.TN_CodTipoOficina) 
		and 		A.TN_CodResultadoResolucion					=	ISNULL(@CodResultadoResolucion,A.TN_CodResultadoResolucion)
		and			A.TC_CodMateria								=	ISNULL(@CodMateria,	A.TC_CodMateria)
		Order By	B.TC_Descripcion, C.TC_Descripcion;
 End




GO
