SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<26/04/2021>
-- Descripción :			<Permite consultar los registros asociados por acumulación a una itineración de Gestión>  

CREATE PROCEDURE [Itineracion].[PA_ConsultarItineracionGestionAcumulados]
	@CodItineracion					uniqueidentifier
AS  
BEGIN 

	DECLARE @L_CodItineracion					varchar(36)	= @CodItineracion

	SELECT	CAST(ID AS UNIQUEIDENTIFIER)		AS CodigoItineracionGestion,
			'Split'								AS Split,
			NUE									AS Numero
	FROM	ItineracionesSIAGPJ.dbo.MESSAGES	A With(Nolock)
	WHERE	IDACUM							 =	@L_CodItineracion

END

GO
