SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Richard Zúñiga Segura>
-- Fecha de creación:		<19/04/2021>
-- Descripción :			<Consulta la audiencias Itinerada >
-- =================================================================================================================================================
-- Modificado:				<Richard Zúñiga Segura<30/04/2021><Se cambia la consulta para que sea por el codigo de la audiencial>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAudienciaItinerada]
	@TN_CodAudiencia		int
AS 
BEGIN

	--VARIABLES LOCALES
	DECLARE 
					@L_TN_CodAudiencia		int	=	@TN_CodAudiencia				

	SELECT			A.[TN_CodAudiencia]				AS Codigo
					,A.[TC_Descripcion]				AS Descripcion
					,A.[TC_NombreArchivo]			AS NombreArchivo
					,A.[TN_CantidadArchivos]		AS CantidadArchivos
					,''								AS split
					,A.[TC_CodContextoCrea]			AS Codigo
					,C.[TC_Descripcion]				AS Descripcion
					,''								AS split
					,A.[TN_EstadoPublicacion]		AS EstadoPublicacion
	FROM			[Expediente].[Audiencia]		A
	INNER JOIN		Catalogo.Contexto				C
	ON				C.TC_CodContexto				=		A.TC_CodContextoCrea
	WHERE			A.TN_CodAudiencia				=		@L_TN_CodAudiencia
	
END
GO
