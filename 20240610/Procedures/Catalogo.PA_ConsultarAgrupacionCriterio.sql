SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<27/08/2021>
-- Descripción :			<Consulta los criterios de reparto que se encuentran agrupados> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto>
-- Fecha de creación:		<15/10/2021>
-- Descripción :			<Se agrega distinct para que no retorne registros duplicados> 
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarAgrupacionCriterio]
	@CodConfiguracionReparto		UNIQUEIDENTIFIER,
	@CodCriterio					UNIQUEIDENTIFIER,
	@CodAgrupacion					UNIQUEIDENTIFIER = NULL
AS  
BEGIN  

	DECLARE			@L_CodConfiguracionReparto		UNIQUEIDENTIFIER = @CodConfiguracionReparto,
					@L_CodCriterio					UNIQUEIDENTIFIER = @CodCriterio,
					@L_CodAgrupacion				UNIQUEIDENTIFIER = @CodAgrupacion
	
	SELECT DISTINCT	R.TU_CodAgrupacion				Codigo,
					R.TC_Nombre						Nombre,
					'SplitClase'					SplitClase,
					C.TN_CodClase					Codigo,
					C.TC_Descripcion				Descripcion,
					'SplitProceso'					SplitProceso,
					P.TN_CodProceso					Codigo,
					P.TC_Descripcion				Descripcion,
					'SplitFase'						SplitFase,
					F.TN_CodFase					Codigo,
					F.TC_Descripcion				Descripcion,
					'SplitClaseAsunto'				SplitClaseAsunto,
					A.TN_CodClaseAsunto				Codigo,
					A.TC_Descripcion				Descripcion,
					'SplitCriterioRepartoManual'	SplitCriterioRepartoManual,
					M.TN_CodCriterioRepartoManual	Codigo,
					M.TC_Descripcion				Descripcion,
					'SplitOtros'					SplitOtros,
					R.TU_CodCriterio				CodigoCriterio,
					R.TU_CodConfiguracionReparto	CodigoConfiguracion
	FROM			Catalogo.AgrupacionCriterio		R	WITH(NOLOCK)
	LEFT OUTER JOIN Catalogo.Clase					C	WITH(NOLOCK) 
	ON				C.TN_CodClase					=	R.TN_CodClase
	LEFT OUTER JOIN Catalogo.Proceso				P	WITH(NOLOCK) 
	ON				P.TN_CodProceso					=	R.TN_CodProceso
	LEFT OUTER JOIN Catalogo.Fase					F	WITH(NOLOCK) 
	ON				F.TN_CodFase					=	R.TN_CodFase
	LEFT OUTER JOIN Catalogo.ClaseAsunto			A	WITH(NOLOCK) 
	ON				A.TN_CodClaseAsunto				=	R.TN_CodClaseAsunto
	LEFT OUTER JOIN Catalogo.EquipoCriterio			E	WITH(NOLOCK) 
	ON				E.TU_CodCriterio				=	R.TU_CodCriterio
	LEFT OUTER JOIN Catalogo.CriterioRepartoManual	M	WITH(NOLOCK) 
	ON				M.TN_CodCriterioRepartoManual	=	R.TN_CodCriterioRepartoManual
	WHERE			R.TU_CodConfiguracionReparto	=	@L_CodConfiguracionReparto
	AND				R.TU_CodCriterio				=	@L_CodCriterio
	AND				R.TU_CodAgrupacion				=	COALESCE(@L_CodAgrupacion,	R.TU_CodAgrupacion)
	ORDER BY		R.TC_Nombre
END
GO
