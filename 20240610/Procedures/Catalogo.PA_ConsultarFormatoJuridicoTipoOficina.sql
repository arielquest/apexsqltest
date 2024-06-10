SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Autor:			<Jeffry Hernández>
-- Fecha Creación:	<03/08/2017>
-- Descripcion:		<Consulta los registros de la tabla FormatoJuridicoTipoOficina>
-- ===========================================================================================
-- Modificacion		<Johan Acosta Ibañez> <06/11/2018> <Se agrega el campo CalculoIntereses>
-- Modificacion		<Ronny Ramírez R.> <19/03/2021> <Se agrega el campo GenerarVotoAutomatico>
-- ===========================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoTipoOficina] 
	@CodFormatoJuridico		 Varchar(8)		= Null,
	@InicioVigencia			 Datetime2      = Null
AS
BEGIN
	SELECT	A.TC_CodFormatoJuridico		AS	CodFormatoJuridico, 
			A.TF_Inicio_Vigencia		AS  FechaActivacion,
			A.TB_EsResolucion			AS  EsResolucion,  
			A.TB_CalculoIntereses		AS	CalculoInteres,
			E.TB_GenerarVotoAutomatico	AS	GenerarVotoAutomatico,
			'SplitTipoOficina'			AS	SplitTipoOficina,
			B.TN_CodTipoOficina			AS	Codigo,				
			B.TC_Descripcion			AS	Descripcion, 
			B.TF_Inicio_Vigencia		AS	FechaActivacion,	
			B.TF_Fin_Vigencia			AS	FechaDesactivacion,
			'SplitMateria'				AS	SplitMateria,		
			C.TC_CodMateria				AS	Codigo,				
			C.TC_Descripcion			AS	Descripcion,		
			C.TB_EjecutaRemate			AS	EjecutaRemate,
			C.TF_Inicio_Vigencia		AS	FechaActivacion,	
			C.TF_Fin_Vigencia			AS	FechaDesactivacion,
			'SplitTipoResolucion'		AS  SplitTipoResolucion,
			D.TN_CodTipoResolucion		AS  Codigo,
			D.TC_Descripcion			AS  Descripcion,
			D.TF_Inicio_Vigencia		AS	FechaActivacion,
			D.TF_Fin_Vigencia			AS	FechasDesactivacion

	FROM		Catalogo.FormatoJuridicoTipoOficina	AS	A WITH(NOLOCK)
	Inner Join	Catalogo.TipoOficina				AS	B
	On			A.TN_CodTipoOficina					=	B.TN_CodTipoOficina
	Inner Join	Catalogo.Materia					AS	C
	On			A.TC_CodMateria						=	C.TC_CodMateria
	Left Join	Catalogo.TipoResolucion				AS	D With(NoLock)
	On			A.TN_CodTipoResolucion				=   D.TN_CodTipoResolucion
	Left Join	Catalogo.FormatoJuridico			AS	E WITH(NOLOCK)
	ON			E.TC_CodFormatoJuridico				=	A.TC_CodFormatoJuridico
	WHERE		A.TC_CodFormatoJuridico				=	Coalesce(@CodFormatoJuridico, A.TC_CodFormatoJuridico) 
	AND			A.TF_Inicio_Vigencia				<=	CASE WHEN @InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
END
GO
