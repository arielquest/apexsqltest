SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Ch>
-- Fecha de creación:		<16/12/2020>
-- Descripción :			<Permite consultar los domicilios de un interviniente para un registro de Itineración de Gestión para SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación				<19/01/2021> <Jonathan Aguilar Navarro> <Se agrega al resultado de la consulta el código de IDINT> 
-- Modificación				<17/02/2021> <Jonathan Aguilar Navarro> <Se agrega a la consulta la configuración del Pasi por defecto> 
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<24/03/2021><Karol Jiménez S.> <Se corrije para que se devuelvan codigos de SIAGPJ para la provincia, cantón, distrito y barrio>
-- Modificación:			<09/04/2021><Karol Jiménez S.> <Se corrije para que no duplique el mismo domicilio, cuando el interviniente existe también como representante>
-- Modificación:			<22/06/2021><Karol Jiménez S.> <Se corrije error de subquery retorna más de un registro>
-- Modificación:			<28/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Provincia)>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_RecibirDomicilioGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
--Variables 
DECLARE	@L_CodItineracion		Uniqueidentifier	=	@CodItineracion,
		@L_XML					XML,
		@L_DESPACHODESTINO		VARCHAR(4)

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
					WHERE	ID								=	@L_CodItineracion
				);
	
	SELECT @L_DESPACHODESTINO= RECIPIENTADDRESS FROM ItineracionesSIAGPJ.dbo.MESSAGES WITH(NOLOCK) WHERE ID = @L_CodItineracion;

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DINT (IDINT, IDDOMI) AS (
		SELECT		A.D.value('(IDINT)[1]', 'int'),
					ISNULL(A.D.value('(IDDOMI)[1]', 'int'), (SELECT TOP 1 X.Y.value('(IDDOMI)[1]', 'int') IDDOMI
															 FROM	@L_XML.nodes('(/*/DINTREP)') X(Y)
															 WHERE	X.Y.value('(IDINTREP)[1]', 'int') = A.D.value('(IDINT)[1]', 'int')))
		FROM		@L_XML.nodes('(/*/DINT)') AS A(D)
		UNION
		SELECT		A.D.value('(IDINTREP)[1]', 'int'),
					ISNULL(A.D.value('(IDDOMI)[1]', 'int'), (SELECT TOP 1 X.Y.value('(IDDOMI)[1]', 'int') IDDOMI
															 FROM	@L_XML.nodes('(/*/DINT)') X(Y)
															 WHERE	X.Y.value('(IDINT)[1]', 'int') = A.D.value('(IDINTREP)[1]', 'int')))
		FROM @L_XML.nodes('(/*/DINTREP)') AS A(D)
	),
	DDOM (CLAVDOM, CODPROV, CODCANTON, CODDISTRITO, CODBARRIO, NOMVIA, IDDOMI) AS (
		SELECT	A.C.value('(CLAVDOM)[1]', 'int'),				
				A.C.value('(CODPROV)[1]', 'VARCHAR(3)'),
				A.C.value('(CODCANTON)[1]', 'VARCHAR(3)'),
				A.C.value('(CODDISTRITO)[1]', 'VARCHAR(3)'),
				A.C.value('(CODBARRIO)[1]', 'VARCHAR(3)'),
				A.C.value('(NOMVIA)[1]', 'VARCHAR(255)'),
				A.C.value('(IDDOMI)[1]', 'int')
		FROM @L_XML.nodes('(/*/DDOM)') AS A(C)
	),
	DOMICILIOS AS	(
				SELECT		A.IDINT,	C.TN_CodProvincia,	E.TN_CodCanton,	F.TN_CodDistrito,	G.TN_CodBarrio,
							CASE 
								WHEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.NOMVIA)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') = '' THEN NULL
								ELSE REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.NOMVIA)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')
							END TC_Direccion,
							CASE
								WHEN	A.IDDOMI	=	B.IDDOMI	THEN	1
								ELSE	0
							END TB_DomicilioHabitual
				FROM		DINT				A
				INNER JOIN	DDOM				B	
				ON			B.CLAVDOM			=	A.IDINT
				LEFT JOIN	Catalogo.Provincia	C	WITH(NOLOCK)
				ON			C.TN_CodProvincia	=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DESPACHODESTINO,'Provincia', B.CODPROV,0,0))
				OUTER APPLY	(
								SELECT	C.TN_CodCanton
								FROM	Catalogo.Canton		C	WITH(NOLOCK)
								WHERE	C.CODPROV			=	B.CODPROV
								AND		C.CODCANTON			=	B.CODCANTON
							) E
				OUTER APPLY	(
								SELECT	C.TN_CodDistrito
								FROM	Catalogo.Distrito	C	WITH(NOLOCK)
								WHERE	C.CODPROV			=	B.CODPROV
								AND		C.CODCANTON			=	B.CODCANTON
								AND		C.CODDISTRITO		=	B.CODDISTRITO
							) F
							
				OUTER APPLY	(
								SELECT	C.TN_CodBarrio
								FROM	Catalogo.Barrio	C WITH(NOLOCK)
								WHERE	C.CODPROV		= B.CODPROV
								AND		C.CODCANTON		= B.CODCANTON
								AND		C.CODDISTRITO	= B.CODDISTRITO
								AND		C.CODBARRIO		= B.CODBARRIO
							) G
				WHERE			B.CODPROV		IS NOT NULL
				OR				B.CODCANTON		IS NOT NULL
				OR				B.CODDISTRITO	IS NOT NULL
				OR				B.CODBARRIO		IS NOT NULL
				)
	SELECT			NEWID()									AS	CodigoDomicilio,
					SUBSTRING(ISNULL(C.TC_Direccion, 'Dirección desconocida'), 1, 255)	AS	Direccion,
					C.TB_DomicilioHabitual					AS	Activo,
					'Split'									AS	Split,--TipoDomicilio
					1										AS	CodigoTipoDomicilio,
					Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_PaisPorDefecto',@L_DESPACHODESTINO) AS	CodigoPais,
					C.TN_CodProvincia						AS	CodigoProvincia,
					C.TN_CodCanton							AS	CodigoCanton,
					C.TN_CodDistrito						AS	CodigoDistrito,
					C.TN_CodBarrio							AS	CodigoBarrio,
					C.IDINT									AS	CodigoIntervinienteGestion

	FROM			DOMICILIOS			C
							
END
GO
