SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<05/08/2021>
-- Descripción :			<Consulta sí un despacho tiene ya configurado equipos con sus miembros> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarSiDespachoTieneEquipos]
	@CodConfiguracionReparto  UNIQUEIDENTIFIER	
AS  
BEGIN  
	DECLARE @L_CodConfiguracionReparto	UNIQUEIDENTIFIER = @CodConfiguracionReparto
			

			 SELECT ISNULL(COUNT(M.TC_CodPuestoTrabajo),0)
			 FROM         Catalogo.EquiposReparto				E WITH(NOLOCK)
			 INNER   JOIN Catalogo.ConjuntosReparto				C WITH(NOLOCK) ON  C.TU_CodEquipo         = E.TU_CodEquipo
			 INNER   JOIN Catalogo.MiembrosPorConjuntoReparto	M WITH(NOLOCK) ON  M.TU_CodConjutoReparto = C.TU_CodConjutoReparto
			 WHERE   E.TU_CodConfiguracionReparto = @L_CodConfiguracionReparto 

END
GO
