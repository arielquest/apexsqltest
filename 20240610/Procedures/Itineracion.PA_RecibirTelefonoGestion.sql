SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Henry M‚ndez Ch>
-- Fecha de creaci¢n:		<16/12/2020>
-- Descripci¢n :			<Permite consultar los telefonos de un interviniente para un registro de Itineraci¢n de Gesti¢n para SIAGPJ>
-- =============================================================================================================================================================================
-- Modificaci¢n				<19/01/2021> <Jonathan Aguilar Navarro> <Se agrega al resultado de la consulta el c¢digo de IDINT> 
-- Modificaci¢n:			<01/03/2021><Karol Jim‚nez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, seg£n acuerdo con BT>
-- Modificaci¢n				<03/08/2021> <Ronny Ram¡rez R.> <Se elimina el mapeo del fax como facsimil en la lista de tel‚fonos, pues ya sale en medios de comunicaci¢n> 
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_RecibirTelefonoGestion]
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
					WHERE	ID								=	@L_CodItineracion
				);
	

	-- Common Table Expressions (CTE's) para facilitar los joins de m£ltiples nodos en memoria
	WITH DINTPER (IDINT, ESDISCAPAC) AS (
		SELECT	A.B.value('(IDINT)[1]', 'int'),
				A.B.value('(ESDISCAPAC)[1]', 'bit')
		FROM @L_XML.nodes('(/*/DINTPER)') AS A(B)
	),
	DDOM (CLAVDOM, TELEFONO, TELEFONOCEL, MENSCELULAR, FAX) AS (
		SELECT	A.C.value('(CLAVDOM)[1]', 'int'),
				A.C.value('(TELEFONO)[1]', 'VARCHAR(50)'),
				A.C.value('(TELEFONOCEL)[1]', 'VARCHAR(50)'),
				A.C.value('(MENSCELULAR)[1]', 'VARCHAR(1)'),
				A.C.value('(FAX)[1]', 'VARCHAR(25)')
		FROM @L_XML.nodes('(/*/DDOM)') AS A(C)
	),
	FIJO AS	(
				SELECT		B.IDINT,	1 TN_CodTipoTelefono,
							CASE 
								WHEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(A.TELEFONO)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') = '' THEN NULL
								ELSE REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(A.TELEFONO)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')
							END TC_Numero,
							0 TB_SMS
				FROM		DDOM		A
				INNER JOIN	DINTPER		B	ON	A.CLAVDOM	=	B.IDINT
			) 
			,
	FIJOCELULAR AS	(
				SELECT		A.IDINT,	4 TN_CodTipoTelefono,
							CASE 
								WHEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.TELEFONOCEL)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') = '' THEN NULL
								ELSE REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.TELEFONOCEL)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')
							END TC_Numero,
							CASE
								WHEN B.MENSCELULAR = '1' THEN 1
								ELSE 0
							END TB_SMS
				FROM		DINTPER A
				INNER JOIN	DDOM		B	ON	B.CLAVDOM	=	A.IDINT
				UNION ALL
				SELECT 		A.IDINT,	A.TN_CodTipoTelefono,	A.TC_Numero,	A.TB_SMS
				FROM		FIJO A
			)

	SELECT			NEWID()									AS	Codigo,
					SUBSTRING(B.TC_Numero, 1 , 8)			AS	Numero,
					'506'									AS	CodigoArea,
					NULL									AS	Extension,	
					B.TB_SMS								AS	SMS,
					B.IDINT									AS	CodigoIntervinienteGestion,
					'Split'									AS	Split,--Telefono
					B.TN_CodTipoTelefono					AS	Codigo


	FROM			FIJOCELULAR		B	
	WHERE			B.TC_Numero		IS NOT NULL	
							
END
GO
