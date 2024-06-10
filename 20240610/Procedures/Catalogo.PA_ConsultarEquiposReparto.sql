SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<8/07/2021>
-- Descripción :			<Consulta los equipos de reparto> 
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<16/8/2021>
-- Descripción :			<Se agrega directiva WITH(NOLOCK)> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarEquiposReparto]
	@CodConfiguracionReparto  UNIQUEIDENTIFIER
AS  
BEGIN  
	DECLARE 
		   @L_CodConfiguracionReparto	UNIQUEIDENTIFIER = @CodConfiguracionReparto
	
	      SELECT  A.TC_NombreEquipo  Nombre,
				  A.TU_CodEquipo     Codigo,
				  A.TU_CodConfiguracionReparto CodigoConfiguracion
		  FROM    Catalogo.EquiposReparto A WITH(NOLOCK)
		  WHERE   A.TU_CodConfiguracionReparto = @L_CodConfiguracionReparto

END
GO
