SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Autor:			<Xinia Soto V>
-- Fecha Creación:	<22/11/2021>
-- Descripcion:		<Consulta los registros de la tabla FormatoJuridicoTipoOficina que no tienen encadenamiento>
-- ============================/===============================================================/
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoTipoOficinaSinEncadenamiento] 
	@CodFormatoJuridico		 Varchar(8)		= Null,
	@InicioVigencia			 Datetime2      = Null
AS
BEGIN

DECLARE 	@L_CodFormatoJuridico		 Varchar(8)		= @CodFormatoJuridico,
			@L_InicioVigencia			 Datetime2      = @InicioVigencia

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
			C.TF_Fin_Vigencia			AS	FechaDesactivacion
	FROM		Catalogo.FormatoJuridicoTipoOficina	AS	A WITH(NOLOCK)
	Inner Join	Catalogo.TipoOficina				AS	B
	On			A.TN_CodTipoOficina					=	B.TN_CodTipoOficina
	Inner Join	Catalogo.Materia					AS	C
	On			A.TC_CodMateria						=	C.TC_CodMateria	
	Left Join	Catalogo.FormatoJuridico			AS	E WITH(NOLOCK)
	ON			E.TC_CodFormatoJuridico				=	A.TC_CodFormatoJuridico
	WHERE		A.TC_CodFormatoJuridico				=	Coalesce(@L_CodFormatoJuridico, A.TC_CodFormatoJuridico) 
	AND			A.TF_Inicio_Vigencia				<=	CASE WHEN @L_InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	AND			NOT EXISTS (SELECT E.TN_CodEncadenamientoFormatoJuridico 
						    FROM Catalogo.EncadenamientoFormatoJuridico E  WITH(NOLOCK)
						    WHERE E.TC_CodMateria         = A.TC_CodMateria AND
								  E.TN_CodTipoOficina     = A.TN_CodTipoOficina AND
								  E.TC_CodFormatoJuridico = A.TC_CodFormatoJuridico)
END
GO
