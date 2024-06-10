SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<27/11/2015>
-- Descripcion:		<Consultar vulnerabilidades de un interviniente.>
-- =============================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteVulnerabilidad]   
	@CodInterviniente	uniqueidentifier
AS
BEGIN
	   SELECT A.TN_CodVulnerabilidad  AS Codigo,
	          B.TC_Descripcion  as Descripcion,
			  B.TF_Inicio_Vigencia as FechaActivacion,
			  B.TF_Fin_Vigencia  as FechaDesactivacion
	   from   Expediente.IntervinienteVulnerabilidad A INNER JOIN 
	    Catalogo.Vulnerabilidad B on A.TN_CodVulnerabilidad = B.TN_CodVulnerabilidad 
       Where TU_CodInterviniente  = @CodInterviniente
	 
END
GO
