SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Ch>
-- Fecha de creación:		<16/12/2020>
-- Descripción :			<Permite consultar las discapacidades de un interviniente para un registro de Itineración de Gestión para SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación				<19/01/2021> <Jonathan Aguilar Navarro> <Se agrega al resultado de la consulta el código de IDINT> 
 -- Modificación:			<01/03/2021> <Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_RecibirDiscapacidadGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
--Variables 
DECLARE	@L_CodItineracion	Uniqueidentifier	=	@CodItineracion,
		@L_XML				XML

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
					WHERE	ID									=	@L_CodItineracion
				);
				
	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DINTPER (IDINT, ESDISCAPAC) AS (
		SELECT	A.B.value('(IDINT)[1]', 'int'),
				A.B.value('(ESDISCAPAC)[1]', 'bit')
		FROM @L_XML.nodes('(/*/DINTPER)') AS A(B)
	),	
	DISCAPACIDADES AS	(	
				SELECT		A.IDINT,				1 TN_CodDiscapacidad, B.TC_Descripcion
				FROM		DINTPER					A,
							Catalogo.Discapacidad	B
				WHERE		ESDISCAPAC				=	1
				AND			B.TN_CodDiscapacidad	=	1
						)

	SELECT			CONVERT(SMALLINT, A.TN_CodDiscapacidad)	AS	Codigo,
					A.TC_Descripcion						AS	Descripcion,
					A.IDINT									AS	CodigoIntervinienteGestion
	FROM			DISCAPACIDADES		A	
							
END
GO
