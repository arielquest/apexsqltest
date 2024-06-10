SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<27/02/2021>
-- Descripción :			<Permite consultar los registros de DACOINT que vienen relacionados a un recurso de una itineración>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarDacointRecursoGestion]
	
	@CodItineracion			Uniqueidentifier 
AS
BEGIN
	--Variables 
	DECLARE @L_CodItineracion			Uniqueidentifier,	
			@L_XML						XML,
			@L_NumeroExpediente			VARCHAR(14),
			@L_CodContexto				VARCHAR(14)

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET	@L_XML = (
					SELECT  VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
					WHERE	ID						= 		@CodItineracion
				);	
				
    -- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DACOINT AS (
	 SELECT         X.Y.value('(IDACO)[1]',			'INT')		IDACO,	
					X.Y.value('(IDINT)[1]',			'INT')		IDINT
		FROM		@L_XML.nodes('(/*/DACOINT)')	AS X(Y)
	),

		DINT (IDINT,IDACO) AS (
		SELECT	A.B.value('(IDINT)[1]', 'INT'),
				A.B.value('(IDACO)[1]', 'INT')
		FROM @L_XML.nodes('(/*/DINT)') AS A(B)
	),
		DACOREC (IDACO) AS (
		SELECT	A.B.value('(IDACO)[1]', 'INT')
		FROM @L_XML.nodes('(/*/DACOREC)') AS A(B)
	)

	-- Consulta DACOINT 
	SELECT	CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)	AS Codigo,
			A.IDACO										AS CodigoGestion,
			'SplitInterviniente'						SplitInterviniente,
			A.IDINT										AS CodigoIntervinienteGestion
	FROM	DACOINT										A
	INNER JOIN	DINT									B
	ON		A.IDINT										= B.IDINT
	INNER JOIN	DACOREC									C
	ON	C.IDACO											= A.IDACO

END
GO
