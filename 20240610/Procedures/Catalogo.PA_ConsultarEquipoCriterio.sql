SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<01/09/2021>
-- Descripción :			<Consulta los criterios de reparto y equipo> 
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<03/09/2021>
-- Descripción :			<Consulta los criterios de reparto y equipo  para que pueda ser consultado opcionalmente por cualquiera de los dos> 
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarEquipoCriterio]
	@CodCriterio					UNIQUEIDENTIFIER = NULL,
	@CodEquipo						UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE			@L_CodCriterio					UNIQUEIDENTIFIER = @CodCriterio,
					@L_CodEquipo					UNIQUEIDENTIFIER = @CodEquipo

	
	SELECT			B.TU_CodEquipo					Codigo,
					B.TU_CodConfiguracionReparto	CodigoConfiguracion,
					B.TC_NombreEquipo				Nombre,
					'SplitCriterio'					SplitCriterio,
					C.TU_CodCriterio				Codigo,
					C.TC_Nombre						Nombre,
					C.TB_Agrupacion					Agrupacion,
					C.TU_CodConfiguracionReparto	CodigoConfiguracion,
					'SplitClase'					SplitClase,
					D.TN_CodClase					Codigo,
					D.TC_Descripcion				Descripcion,
				   'SplitProceso'					SplitProceso,
					E.TN_CodProceso					Codigo,
					E.TC_Descripcion				Descripcion,
					'SplitFase'						SplitFase,
					F.TN_CodFase					Codigo,
					F.TC_Descripcion				Descripcion,
					'SplitClaseAsunto'				SplitClaseAsunto,
					G.TN_CodClaseAsunto				Codigo,
					G.TC_Descripcion				Descripcion
	FROM			Catalogo.EquipoCriterio			A	WITH(NOLOCK)	
	INNER JOIN		Catalogo.EquiposReparto			B	WITH(NOLOCK)	
	ON				B.TU_CodEquipo					=	A.TU_CodEquipo
	INNER JOIN		Catalogo.CriteriosReparto		C	WITH(NOLOCK)
	ON				C.TU_CodCriterio				=	A.TU_CodCriterio
	LEFT OUTER JOIN Catalogo.Clase					D	WITH(NOLOCK)
	ON				D.TN_CodClase					=	C.TN_CodClase
	LEFT OUTER JOIN Catalogo.Proceso				E	WITH(NOLOCK)
	ON				E.TN_CodProceso					=	C.TN_CodProceso
	LEFT OUTER JOIN Catalogo.Fase					F	WITH(NOLOCK)
	ON				F.TN_CodFase					=	C.TN_CodFase
	LEFT OUTER JOIN Catalogo.ClaseAsunto			G	WITH(NOLOCK)
	ON				G.TN_CodClaseAsunto				=	C.TN_CodClaseAsunto
	WHERE			A.TU_CodCriterio				=	COALESCE(@L_CodCriterio, A.TU_CodCriterio)
	AND				A.TU_CodEquipo					=	COALESCE(@L_CodEquipo,	A.TU_CodEquipo)
	ORDER BY		B.TC_NombreEquipo
END
GO
