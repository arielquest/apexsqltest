SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Consulta el criterio de reparto> 
-- Modificado por:			<Johan Acosta Ibañez>
-- Fecha de creación:		<06/08/2021>
-- Descripción :			<Modificar el sp para que retorne los datos de toda la clase AsuntoReparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarASuntosParaRepartir]
	@CodConfiguracionReparto  UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE	@L_CodConfiguracionReparto	UNIQUEIDENTIFIER	=	@CodConfiguracionReparto
			
	SELECT		A.TN_CodAsunto					Codigo,
				B.TC_Descripcion				Descripcion,
				B.TF_Inicio_Vigencia			FechaActivacion,
				B.TF_Fin_Vigencia				FechaDesactivacion,
				'Split'							Split,
				A.TU_CodConfiguracionReparto	Codigo,
				C.TC_CodContexto				CodigoContexto,
				C.TB_Habilitado					RepartoHabilitado,
				C.TB_LimiteTiempoHabilitado		LimiteTiempoHabilitado,
				C.TN_DiasHabiles				DiasHabilesLimite,
				C.TC_CriterioReparto			CriterioReparto
	FROM		Catalogo.AsuntosReparto				 A	WITH(NOLOCK)
	INNER JOIN	Catalogo.Asunto						 B	WITH(NOLOCK)
	ON			B.TN_CodAsunto						 =	A.TN_CodAsunto
	INNER JOIN	Catalogo.ConfiguracionGeneralReparto C 	WITH(NOLOCK)
	ON			C.TU_CodConfiguracionReparto		 =	A.TU_CodConfiguracionReparto	
	WHERE		A.TU_CodConfiguracionReparto		 =	@L_CodConfiguracionReparto

END
GO
