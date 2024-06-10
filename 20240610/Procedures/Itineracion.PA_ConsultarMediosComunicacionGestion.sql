SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<13/01/2021>
-- Descripción :			<Permite consultar los medios de comunicación de las intervenciones de una Itineración de Gestión, con catálogos o tablas equivalentes del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<09/06/2021><Karol Jiménez S.> <Se elimina para que no retorne un codigo de medio de comunicación, dado que desde fuente se genera el ID>
-- Modificación:			<28/07/2021><Jose Gabriel Cordero Soto> <Se agrega filtro en consulta de DDOM para omitir en caso de CODMEDCOM igual a L>
-- Modificación:			<28/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos TipoMedioComunicacion y
--							Provincia)>
-- Modificación:			<18/04/2023><Karol Jiménez S.> <Bug 311543 - Se corrige duplicidad de medios misma prioridad y bugs 311559 - Se consultan medios de comunicación aunque
--							no existan en DDOM>
-- Modificación:   			<20/04/2023> <Luis Alonso Leiva Tames> <SSe agrega esta validación para traer solo un medio para el mismo interviniente con la misma prioridad, dado que cuando el interviniente es representante también algunas veces traía dobles los medios  > 
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarMediosComunicacionGestion]
	@CodItineracion			Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion						Uniqueidentifier	= @CodItineracion, 
			@L_ContextoDestino						VARCHAR(4),
			@L_XML									XML, 
			@L_ValorDefectoTipoMedioComunicacion	SMALLINT			= NULL; 

	DECLARE	@L_tblMediosComunicacion	TABLE (
										ID								UNIQUEIDENTIFIER	NOT NULL,				
										IDINT							INT					NOT NULL,				
										IDDOMI							INT					NULL,				
										IDDOMINOT						INT					NULL,				
										CODMEDCOM						VARCHAR(1)			NULL,		
										ES_PRIMARIO						BIT					NOT NULL,		
										NOMVIA							VARCHAR(255)		NULL,		
										TELEFONO						VARCHAR(50)			NULL,		
										TELEFONOCEL						VARCHAR(50)			NULL,		
										FAX								VARCHAR(25)			NULL,		
										EMAIL							VARCHAR(255)		NULL,		
										OTROS							VARCHAR(255)		NULL,		
										CODBARRIO						VARCHAR(5)			NULL,	
										CODDISTRITO						VARCHAR(5)			NULL,	
										CODCANTON						VARCHAR(5)			NULL,		
										CODPROV							VARCHAR(5)			NULL,	
										TC_CodMedio						SMALLINT			NULL,
										TC_TipoMedio					CHAR(1)				NULL,
										TN_CodProvincia					SMALLINT			NULL,
										TN_CodCanton					SMALLINT			NULL,
										TN_CodDistrito					SMALLINT			NULL,
										TN_CodBarrio					SMALLINT			NULL
									);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	SELECT	@L_ContextoDestino					= RECIPIENTADDRESS
	FROM	ItineracionesSIAGPJ.DBO.[MESSAGES]	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoTipoMedioComunicacion	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoMedioComunicacion',@L_ContextoDestino));
	
	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DDOM_DINT_PRI AS (
		SELECT		X.Y.value('(IDINT)[1]',			'INT')				IDINT,
					X.Y.value('(IDDOMINOT)[1]',		'INT')				IDDOMINOT,
					A.B.value('(IDDOMI)[1]',		'INT')				IDDOMI,
					X.Y.value('(CODMEDCOM)[1]',		'VARCHAR(1)')		CODMEDCOM,
					A.B.value('(NOMVIA)[1]',		'VARCHAR(255)')		NOMVIA,
					A.B.value('(TELEFONO)[1]',		'VARCHAR(50)')		TELEFONO,
					A.B.value('(TELEFONOCEL)[1]',	'VARCHAR(50)')		TELEFONOCEL,
					A.B.value('(FAX)[1]',			'VARCHAR(25)')		FAX,
					A.B.value('(EMAIL)[1]',			'VARCHAR(255)')		EMAIL,
					A.B.value('(OTROS)[1]',			'VARCHAR(255)')		OTROS,
					A.B.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
					A.B.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
					A.B.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
					A.B.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV
		FROM		@L_XML.nodes('(/*/DINT)')							AS X(Y)
		LEFT JOIN	@L_XML.nodes('(/*/DDOM)')							AS A(B)
		ON			A.B.value('(IDDOMI)[1]','INT')						= X.Y.value('(IDDOMINOT)[1]','INT')
		WHERE		X.Y.value('(CODMEDCOM)[1]','VARCHAR(1)')			IS NOT NULL 
		AND			X.Y.value('(CODMEDCOM)[1]','VARCHAR(1)')			<> ''
	),
	DDOM_DINT_ACC AS (
		SELECT		X.Y.value('(IDINT)[1]',			'INT')				IDINT,
					X.Y.value('(IDDOMINOTACC)[1]',	'INT')				IDDOMINOTACC,
					A.B.value('(IDDOMI)[1]',		'INT')				IDDOMI,
					X.Y.value('(CODMEDCOMACC)[1]',	'VARCHAR(1)')		CODMEDCOMACC,
					A.B.value('(NOMVIA)[1]',		'VARCHAR(255)')		NOMVIA,
					A.B.value('(TELEFONO)[1]',		'VARCHAR(50)')		TELEFONO,
					A.B.value('(TELEFONOCEL)[1]',	'VARCHAR(50)')		TELEFONOCEL,
					A.B.value('(FAX)[1]',			'VARCHAR(25)')		FAX,
					A.B.value('(EMAIL)[1]',			'VARCHAR(255)')		EMAIL,
					A.B.value('(OTROS)[1]',			'VARCHAR(255)')		OTROS,
					A.B.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
					A.B.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
					A.B.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
					A.B.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV
		FROM		@L_XML.nodes('(/*/DINT)')							AS X(Y)
		LEFT JOIN	@L_XML.nodes('(/*/DDOM)')							AS A(B)
		ON			A.B.value('(IDDOMI)[1]','INT')						= X.Y.value('(IDDOMINOTACC)[1]','INT')
		WHERE		X.Y.value('(CODMEDCOMACC)[1]','VARCHAR(1)')			IS NOT NULL 
		AND			X.Y.value('(CODMEDCOMACC)[1]','VARCHAR(1)')			<> ''
	),
	DDOM_DINTREP_PRI AS (
		SELECT		X.Y.value('(IDINTREP)[1]',		'INT')				IDINT,
					X.Y.value('(IDDOMINOT)[1]',		'INT')				IDDOMINOT,
					A.B.value('(IDDOMI)[1]',		'INT')				IDDOMI,
					X.Y.value('(CODMEDCOM)[1]',		'VARCHAR(1)')		CODMEDCOM,	
					A.B.value('(NOMVIA)[1]',		'VARCHAR(255)')		NOMVIA,
					A.B.value('(TELEFONO)[1]',		'VARCHAR(50)')		TELEFONO,
					A.B.value('(TELEFONOCEL)[1]',	'VARCHAR(50)')		TELEFONOCEL,
					A.B.value('(FAX)[1]',			'VARCHAR(25)')		FAX,
					A.B.value('(EMAIL)[1]',			'VARCHAR(255)')		EMAIL,
					A.B.value('(OTROS)[1]',			'VARCHAR(255)')		OTROS,
					A.B.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
					A.B.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
					A.B.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
					A.B.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV
		FROM		@L_XML.nodes('(/*/DINTREP)')						AS X(Y)
		LEFT JOIN	@L_XML.nodes('(/*/DDOM)')							AS A(B)
		ON			A.B.value('(IDDOMI)[1]','INT')						= X.Y.value('(IDDOMINOT)[1]','INT')
		WHERE		X.Y.value('(CODMEDCOM)[1]','VARCHAR(1)')			IS NOT NULL 
		AND			X.Y.value('(CODMEDCOM)[1]','VARCHAR(1)')			<> ''	
	),
	DDOM_DINTREP_ACC AS (
		SELECT		X.Y.value('(IDINTREP)[1]',		'INT')				IDINT,
					X.Y.value('(IDDOMINOTACC)[1]',	'INT')				IDDOMINOTACC,
					A.B.value('(IDDOMI)[1]',		'INT')				IDDOMI,				
					X.Y.value('(CODMEDCOMACC)[1]',	'VARCHAR(1)')		CODMEDCOMACC,
					A.B.value('(NOMVIA)[1]',		'VARCHAR(255)')		NOMVIA,
					A.B.value('(TELEFONO)[1]',		'VARCHAR(50)')		TELEFONO,
					A.B.value('(TELEFONOCEL)[1]',	'VARCHAR(50)')		TELEFONOCEL,
					A.B.value('(FAX)[1]',			'VARCHAR(25)')		FAX,
					A.B.value('(EMAIL)[1]',			'VARCHAR(255)')		EMAIL,
					A.B.value('(OTROS)[1]',			'VARCHAR(255)')		OTROS,
					A.B.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
					A.B.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
					A.B.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
					A.B.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV
		FROM		@L_XML.nodes('(/*/DINTREP)')						AS X(Y)
		LEFT JOIN	@L_XML.nodes('(/*/DDOM)')							AS A(B)
		ON			A.B.value('(IDDOMI)[1]','INT')						= X.Y.value('(IDDOMINOTACC)[1]','INT')
		WHERE		X.Y.value('(CODMEDCOMACC)[1]','VARCHAR(1)')			IS NOT NULL 
		AND			X.Y.value('(CODMEDCOMACC)[1]','VARCHAR(1)')			<> ''
	),
	MEDIOS_COMUNICACION AS
	(
		SELECT			A.IDINT,		A.IDDOMI,			A.IDDOMINOT,		1 ES_PRIMARIO,	
						A.CODMEDCOM,	A.NOMVIA,			A.TELEFONO,			
						A.TELEFONOCEL,	A.FAX,				A.EMAIL,			A.OTROS,			
						A.CODBARRIO,	A.CODDISTRITO,		A.CODCANTON,		A.CODPROV
		FROM			DDOM_DINT_PRI	A
		WHERE			A.CODMEDCOM		<> 'L' 
		UNION
		SELECT			A.IDINT,		A.IDDOMI,			A.IDDOMINOTACC,		0 ES_PRIMARIO,	
						A.CODMEDCOMACC,	A.NOMVIA,			A.TELEFONO,			
						A.TELEFONOCEL,	A.FAX,				A.EMAIL,			A.OTROS,			
						A.CODBARRIO,	A.CODDISTRITO,		A.CODCANTON,		A.CODPROV
		FROM			DDOM_DINT_ACC	A
		WHERE			A.CODMEDCOMACC	<> 'L' 
		UNION
		SELECT			A.IDINT,			A.IDDOMI,			A.IDDOMINOT,		1 ES_PRIMARIO,
						A.CODMEDCOM,		A.NOMVIA,			A.TELEFONO,			
						A.TELEFONOCEL,		A.FAX,				A.EMAIL,			A.OTROS,			
						A.CODBARRIO,		A.CODDISTRITO,		A.CODCANTON,		A.CODPROV
		FROM			DDOM_DINTREP_PRI	A
		WHERE			A.CODMEDCOM			<> 'L' 
		UNION
		SELECT			A.IDINT,			A.IDDOMI,			A.IDDOMINOTACC,		0 ES_PRIMARIO,
						A.CODMEDCOMACC,		A.NOMVIA,			A.TELEFONO,			
						A.TELEFONOCEL,		A.FAX,				A.EMAIL,			A.OTROS,			
						A.CODBARRIO,		A.CODDISTRITO,		A.CODCANTON,		A.CODPROV
		FROM			DDOM_DINTREP_ACC	A
		WHERE			A.CODMEDCOMACC		<> 'L' 
	)
	INSERT INTO @L_tblMediosComunicacion
				(ID,				IDINT,				IDDOMI,				IDDOMINOT,	
				CODMEDCOM,			ES_PRIMARIO,		NOMVIA,				
				TELEFONO,			TELEFONOCEL,		FAX,				EMAIL,				
				OTROS,				CODBARRIO,			CODDISTRITO,		CODCANTON,			
				CODPROV,			TC_CodMedio,		TC_TipoMedio,		TN_CodProvincia,	
				TN_CodCanton,		TN_CodDistrito,		TN_CodBarrio)
	SELECT		NEWID() ID,			A.IDINT,			A.IDDOMI,			A.IDDOMINOT,		
				A.CODMEDCOM,		ES_PRIMARIO,		A.NOMVIA,			
				A.TELEFONO,			A.TELEFONOCEL,		A.FAX,				A.EMAIL,			
				A.OTROS,			A.CODBARRIO,		A.CODDISTRITO,		A.CODCANTON,		
				A.CODPROV,			B.TN_CodMedio,		B.TC_TipoMedio,		D.TN_CodProvincia,	
				E.TN_CodCanton,		F.TN_CodDistrito,	G.TN_CodBarrio
	FROM		MEDIOS_COMUNICACION					A
	LEFT JOIN	Catalogo.TipoMedioComunicacion		B	WITH(NOLOCK)
	ON			B.TN_CodMedio						=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoMedioComunicacion', A.CODMEDCOM,0,0))
	LEFT JOIN	Catalogo.Provincia					D	WITH(NOLOCK)
	ON			D.TN_CodProvincia					=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Provincia', A.CODPROV,0,0))
	LEFT JOIN	Catalogo.Canton						E	WITH(NOLOCK)
	ON			E.CODPROV							=	A.CODPROV
	AND			E.CODCANTON							=	A.CODCANTON
	LEFT JOIN	Catalogo.Distrito					F	WITH(NOLOCK)
	ON			F.CODPROV							=	A.CODPROV
	AND			F.CODCANTON							=	A.CODCANTON
	AND			F.CODDISTRITO						=	A.CODDISTRITO
	LEFT JOIN	Catalogo.Barrio						G	WITH(NOLOCK)
	ON			G.CODPROV							=	A.CODPROV
	AND			G.CODCANTON							=	A.CODCANTON
	AND			G.CODDISTRITO						=	A.CODDISTRITO
	AND			G.CODBARRIO							=	A.CODBARRIO;
	
	WITH MEDIOS AS (
		SELECT	CASE
					WHEN ES_PRIMARIO = 1 THEN 1
					ELSE 2
				END										Prioridad,
				CASE
					WHEN TC_TipoMedio = 'D' THEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(NOMVIA)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')--D = Domicilio
					WHEN TC_TipoMedio = 'E' THEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(EMAIL)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')--E = Email
					WHEN TC_TipoMedio = 'F' THEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(FAX)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')--F = Fax
					WHEN CODMEDCOM = 'G' THEN --Teléfono
						coalesce('|'+ nullif(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TELEFONO)), CHAR(9), ''), CHAR(10),''), CHAR(13), ''), ''), '')
						+ coalesce('|'+ nullif(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(TELEFONOCEL)), CHAR(9), ''), CHAR(10),''), CHAR(13), ''), ''), '')
					ELSE 
						REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(OTROS)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') 
				END Valor,
				CASE
					WHEN TC_TipoMedio = 'F' OR TC_TipoMedio = 'E'--F = Fax, E = Email
						THEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(NOMVIA)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')
					ELSE NULL
				END Rotulado,
				1										PerteneceExpediente,
				'SplitInterviniente'					SplitInterviniente,
				IDINT									CodigoIntervinienteGestion,
				'SplitTipoMedio'						SplitTipoMedio,
				ISNULL(TC_CodMedio, @L_ValorDefectoTipoMedioComunicacion) Codigo,
				'SplitOtros'							SplitOtros,
				TN_CodProvincia							TN_CodProvincia,
				TN_CodCanton							TN_CodCanton,
				TN_CodDistrito							TN_CodDistrito,
				TN_CodBarrio							TN_CodBarrio,
				A.ID
		FROM	@L_tblMediosComunicacion				A	
	)
	SELECT		M.Prioridad,			M.Valor,						M.Rotulado,			M.PerteneceExpediente,
				M.SplitInterviniente,	M.CodigoIntervinienteGestion,	M.SplitTipoMedio,	M.Codigo, 
				M.SplitOtros,			M.TN_CodProvincia,				M.TN_CodCanton,		M.TN_CodDistrito,
				M.TN_CodBarrio
	FROM		MEDIOS	M
	WHERE		M.ID	IN (	SELECT		MAX(ID) ID /*Se agrega esta validación para traer solo un medio para el mismo interviniente con la misma prioridad, dado que cuando el interviniente es representante también algunas veces traía dobles los medios (Bug 311543)*/
								FROM		MEDIOS
								GROUP BY	CodigoIntervinienteGestion, Prioridad)
	ORDER BY	M.CodigoIntervinienteGestion DESC
END
GO
