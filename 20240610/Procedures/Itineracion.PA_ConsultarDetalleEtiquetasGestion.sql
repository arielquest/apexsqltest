SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<12/05/2021>
-- Descripción :			<Permite consultar las etiqueta de una itinearación proveniente de Gestión>
-- Modificado por:			<Jonathan Aguilar Navarro><01/09/2021><Para que muestre el tiempo en milisegundo y tiempo archivo correctamente>
-- =============================================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleEtiquetasGestion]
	
	@CodItineracion Uniqueidentifier = null

AS

BEGIN
--Variables
DECLARE @L_CodItineracion Uniqueidentifier = @CodItineracion
DECLARE @L_XML XML

-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT @L_XML = VALUE
	FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK)
	WHERE ID = @L_CodItineracion;

	 -- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH MULTIMEDIANOTA AS (
		SELECT	A.B.value('(TIEMPOGRABACION)[1]',			'VARCHAR(50)')		TIEMPOGRABACION,
				A.B.value('(DESCRIP)[1]',					'VARCHAR(255)')		DESCRIPCION,
				A.B.value('(PRIVADO)[1]',					 'BIT')				PRIVADO,
				A.B.value('(TIEMPOARCHIVO)[1]',				'VARCHAR(50)')		TIEMPOARCHIVO,
				A.B.value('(NOMBREARCH)[1]',				'VARCHAR(50)')		NOMBREARCHIVO,
				A.B.value('(IDMULTI)[1]',					'INT')				IDMULTI

	 FROM @L_XML.nodes('(/*/DMULTIMEDIANOTA)') AS A(B)
	)

	 SELECT CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)AS Codigo,
			A.DESCRIPCION								AS Descripcion,
			A.TIEMPOGRABACION							AS TiempoArchivo,
			A.PRIVADO									AS TipoEtiqueta,
			A.NOMBREARCHIVO								AS NombreArchivo,
			'SplitAudiencia'							AS SplitAudiencia,
			A.IDMULTI									AS IDMULTI
	FROM	MULTIMEDIANOTA A
END
GO
