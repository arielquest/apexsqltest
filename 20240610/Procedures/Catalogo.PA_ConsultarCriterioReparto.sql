SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Consulta los criterios de reparto de una configuración dada> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCriterioReparto]
	@CodConfiguracionReparto    UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE @L_CodConfiguracionReparto	UNIQUEIDENTIFIER = @CodConfiguracionReparto
	
	SELECT DISTINCT R.TU_CodCriterio	Codigo,
		   R.TC_Nombre					Nombre,
		   R.TB_Agrupacion				Agrupacion,
		   R.TU_CodConfiguracionReparto CodigoConfiguracion,
		   (CASE WHEN E.TU_CodCriterio IS  NULL THEN 0 ELSE 1 END) Asignado,
		   'SplitClase'					SplitClase,
		   C.TN_CodClase				Codigo,
		   C.TC_Descripcion				Descripcion,
		   'SplitProceso'				SplitProceso,
		   P.TN_CodProceso				Codigo,
		   P.TC_Descripcion				Descripcion,
		   'SplitFase'					SplitFase,
		   F.TN_CodFase					Codigo,
		   F.TC_Descripcion				Descripcion,
		   'SplitClaseAsunto'			SplitClaseAsunto,
		   A.TN_CodClaseAsunto			Codigo,
		   A.TC_Descripcion				Descripcion
	FROM Catalogo.CriteriosReparto			R WITH(NOLOCK)
	LEFT OUTER JOIN Catalogo.Clase			C WITH(NOLOCK) ON C.TN_CodClase			= R.TN_CodClase
	LEFT OUTER JOIN Catalogo.Proceso		P WITH(NOLOCK) ON P.TN_CodProceso		= R.TN_CodProceso
	LEFT OUTER JOIN Catalogo.Fase			F WITH(NOLOCK) ON F.TN_CodFase			= R.TN_CodFase
	LEFT OUTER JOIN Catalogo.ClaseAsunto	A WITH(NOLOCK) ON A.TN_CodClaseAsunto	= R.TN_CodClaseAsunto
	LEFT OUTER JOIN Catalogo.EquipoCriterio E WITH(NOLOCK) ON E.TU_CodCriterio      = R.TU_CodCriterio
	WHERE R.TU_CodConfiguracionReparto		= @L_CodConfiguracionReparto  
	ORDER BY  R.TC_Nombre
END
GO
