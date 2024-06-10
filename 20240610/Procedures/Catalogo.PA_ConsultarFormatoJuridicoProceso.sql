SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Jeffry Hernández>
-- Fecha Creación:	<03/08/2017>
-- Descripcion:		<Consulta los registros de la tabla FormatoJuridicoProcedimiento>
-- Modificado:		<09/03/2017> <Diego Navarrete> <Se agrega el comando  WITH(NOLOCK), en todos los Inner Join> 
-- Modificado:		<07/02/2019> <Isaac Dobles> <Se cambia nombre a PA_ConsultarFormatoJuridicoProceso y direcciona a tabla Catalogo.Proceso >    
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoProceso] 
	@CodFormatoJuridico		 Varchar(8)		= Null,
	@InicioVigencia			 Datetime2      = Null
AS
BEGIN
	SELECT	A.TC_CodFormatoJuridico AS	CodFormatoJuridico, A.TF_Inicio_Vigencia	AS  FechaActivacion, 
			'SplitProceso'			AS	SplitProceso,
			B.TN_CodProceso			AS	Codigo,				B.TC_Descripcion		AS	Descripcion, 
			B.TF_Inicio_Vigencia	AS	FechaActivacion,	B.TF_Fin_Vigencia		AS	FechaDesactivacion,
			'SplitClase'			AS	SplitClase,	
			C.TN_CodClase			AS	Codigo,				C.TC_Descripcion		AS	Descripcion,		
			C.TF_Inicio_Vigencia	AS	FechaActivacion,	C.TF_Fin_Vigencia		AS	FechaDesactivacion, 
			'SplitTipoOficina'		AS	SplitTipoOficina,
			D.TN_CodTipoOficina		AS	Codigo,				D.TC_Descripcion		AS	Descripcion, 
			D.TF_Inicio_Vigencia	AS	FechaActivacion,	D.TF_Fin_Vigencia		AS	FechaDesactivacion,
			'SplitMateria'			AS	SplitMateria,		E.TC_CodMateria			AS	Codigo,				
			E.TC_Descripcion		AS	Descripcion,		E.TB_EjecutaRemate		AS	EjecutaRemate,
			E.TF_Inicio_Vigencia	AS	FechaActivacion,	E.TF_Fin_Vigencia		AS	FechaDesactivacion

	FROM		Catalogo.FormatoJuridicoProceso			AS	A WITH(NOLOCK)
	Inner Join	Catalogo.Proceso						AS	B WITH(NOLOCK)
	On			A.TN_CodProceso							=	B.TN_CodProceso
	Inner Join	Catalogo.Clase							AS	C WITH(NOLOCK)
	On			A.TN_CodClase							=	C.TN_CodClase
	Inner Join	Catalogo.TipoOficina					AS	D WITH(NOLOCK)
	On			A.TN_CodTipoOficina						=	D.TN_CodTipoOficina
	Inner Join	Catalogo.Materia						AS	E WITH(NOLOCK)
	On			A.TC_CodMateria							=	E.TC_CodMateria

	WHERE		A.TC_CodFormatoJuridico					=	Coalesce(@CodFormatoJuridico, A.TC_CodFormatoJuridico) 
	AND			A.TF_Inicio_Vigencia					<=	CASE WHEN @InicioVigencia IS NULL THEN A.TF_Inicio_Vigencia ELSE GETDATE() END
END
GO
