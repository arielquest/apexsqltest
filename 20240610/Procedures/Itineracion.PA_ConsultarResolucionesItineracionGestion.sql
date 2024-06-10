SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Isaac Dobles Mata>
-- Fecha de creación:	<04/01/2021>
-- Descripción :		<Permite los registros de resolución de una itineración>
-- =============================================================================================================================================================================
-- Modificación:		<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:		<03/03/2021><Jonathan Aguilar Navarro> <Ze agrega las configuraciones por defecto para TipoResolucion y ResultadoResolucion>
-- Modificación:		<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:		<11/06/2021><Karol Jiménez S.> <Se corrije para evitar productos cartesianos al obtener equivalencias de catálogos>
-- Modificación:		<14/06/2021><Jose Gabriel Cordero Soto> <Se agrega mapeo para LibroSetencia, con el fin de mostrar en SIAGPJ el Numero de V>
-- Modificación:		<15/06/2021><Ronny Ramírez R.> <Se corrige tipo del campo ENVIADO_SINALEVI para mapearlo como EstadoEnvioSAS y se agrega FECPUB como FechaEnvioSAS>
-- Modificación:		<22/06/2021><Jose Gabriel Cordero Soto> <Se corregi FECHA RESOLUCION con el campo que corresponde por no visualizacion correcta>
-- Modificación:		<27/09/2022><Ronny Ramírez R.> <Se corrige el mapeo del campo VOTNUM, para validar cuando trae formato de 10 caracteres o no>
-- Modificación:		<02/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos TipoResolucion
--						y ResultadoResolucion)>
-- Modificación:		<17/04/2023><Luis Alonso Leiva Tames> <Se corrige en el campo ConsecutivoResolucion en lugar de devolver un vacio que devuelva un null>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarResolucionesItineracionGestion]
	@CodItineracion Uniqueidentifier = null
AS 
BEGIN

	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		=	@CodItineracion,
			@L_XML						XML,
			@L_NumeroExpediente			VARCHAR(14),
			@L_Despacho					VARCHAR(4),
			@L_DespachoDestino			VARCHAR(4);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK) 
					WHERE	ID									= @L_CodItineracion
				);

	--Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');

	--Se obtiene el codigo de despacho del XML
	SET @L_Despacho = @L_XML.value('(/*/DCAR/CODDEJ)[1]','VARCHAR(4)');

	SET @L_DespachoDestino = (	
									SELECT		A.RECIPIENTADDRESS
									FROM		ItineracionesSIAGPJ.dbo.MESSAGES	A WITH(NOLOCK)
									WHERE		A.ID								= @L_CodItineracion
								);

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH 
	DACORES AS (
		SELECT	
				X.Y.value('(IDACO)[1]',				'INT')										IDACO,
				X.Y.value('(IDACOSENDOC)[1]',		'INT')										IDACOSENDOC,
				X.Y.value('(CODRESUL)[1]',			'VARCHAR(9)')								CODRESUL,
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECVOTO)[1]', 'VARCHAR(35)'))				FECVOTO,
				X.Y.value('(CODRES)[1]',			'VARCHAR(4)')								CODRES,
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECDIC)[1]', 'VARCHAR(35)'))				FECDIC,
				X.Y.value('(IDUSU)[1]',				'VARCHAR(25)')								IDUSU,
				X.Y.value('(USUREDAC)[1]',			'VARCHAR(25)')								USUREDAC,
				X.Y.value('(ACOPORDOC)[1]',			'VARCHAR(MAX)')								ACOPORDOC,
				X.Y.value('(RESUMEN)[1]',			'VARCHAR(MAX)')								RESUMEN,
				X.Y.value('(OBSER_DATSENSI)[1]',	'VARCHAR(250)')								OBSER_DATSENSI,
				X.Y.value('(VOTNUM)[1]',			'VARCHAR(10)')								VOTNUM,
				X.Y.value('(JUEZ)[1]',				'VARCHAR(11)')								JUEZ,
				X.Y.value('(ENVIADO_SINALEVI)[1]',	'VARCHAR(1)')								ENVIADO_SINALEVI,
				TRY_CONVERT(DATETIME2(3),X.Y.value('(FECPUB)[1]',	'VARCHAR(35)'))				FECPUB				
		FROM	@L_XML.nodes('(/*/DACORES)')	AS X(Y)
	),
	DACO (IDACO, FECEST, CODDEJ, FECHA, IDUSU) AS (
		SELECT	U.W.value('(IDACO)[1]', 'INT')										IDACO,
				TRY_CONVERT(DATETIME2(3),U.W.value('(FECEST)[1]', 'VARCHAR(35)'))	FECEST,
				U.W.value('(CODDEJ)[1]', 'VARCHAR(4)')								CODDEJ,
				TRY_CONVERT(DATETIME2(3),U.W.value('(FECHA)[1]', 'VARCHAR(35)'))	FECHA,
				U.W.value('(IDUSU)[1]', 'VARCHAR(14)')								IDUSU
		FROM @L_XML.nodes('(/*/DACO)') AS U(W)
	)

	--Consulta de registros
	SELECT			
					U.FECEST																As	FechaCreacion,
					ISNULL(X.FECVOTO, U.FECEST)												As	FechaResolucion,
					X.ACOPORDOC																As  PorTanto,
					@L_NumeroExpediente														As  NumeroExpediente,
					X.RESUMEN																As  Resumen,
					X.OBSER_DATSENSI														As  DescripcionSensible,
					CASE WHEN (X.OBSER_DATSENSI IS NOT NULL AND X.OBSER_DATSENSI<>'')
					THEN 1
					ELSE 0
					END																		As  DatoSensible,
					X.FECPUB																As  FechaEnvioSAS,
					CASE 
					WHEN EXISTS(
						SELECT T.*
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= @L_CodItineracion
						AND		X.Y.value('(CODMASD)[1]', 'VARCHAR(9)') = 'EXPMEDIAT'
						AND		X.Y.value('(VALOR)[1]','VARCHAR(255)') = 'S'
					)
					THEN	1
					ELSE	0
					END																		As  EsRelevante,
					X.IDACOSENDOC															As	CodigoGestion,
					X.USUREDAC																As	USUREDAC,
					CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		As	CodigoResolucion,		
					'SplitContexto'															As  SplitContexto,
					U.CODDEJ																As	Codigo,
					E.TC_Descripcion														As  Descipcion,
					'SplitResultadoResolucion'												As  SplitResultadoResolucion,
					ISNULL(C.TN_CodResultadoResolucion,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_ResulResPorDefecto',@L_DespachoDestino)) As	Codigo,
					C.TC_Descripcion														As  Descripcion,
					'SplitTipoResolucion'													As  SplitTipoResolucion,
					ISNULL(B.TN_CodTipoResolucion	,Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoResPorDefecto',@L_DespachoDestino)) As	Codigo,
					B.TC_Descripcion														As	Descripcion,
					'SplitNumeroResolucion'													As  SplitNumeroResolucion,
					CASE
						WHEN ((X.VOTNUM IS NOT NULL) AND (LEN(TRIM(X.VOTNUM)) = 10))		-- Si tiene 10 caracteres, tiene formato Gestión [Año(4 char)+Consecutivo(6 char)]
							THEN SUBSTRING(X.VOTNUM, 1, 4)
						ELSE NULL
					END																		As	Anno,
					CASE WHEN (
					CASE
						WHEN ((X.VOTNUM IS NOT NULL) AND (LEN(TRIM(X.VOTNUM)) = 10))		-- Si tiene 10 caracteres, tiene formato Gestión [Año(4 char)+Consecutivo(6 char)], sino se guarda tal como viene
							THEN SUBSTRING(X.VOTNUM, 5, LEN(X.VOTNUM)-4)
						ELSE ISNULL(TRIM(X.VOTNUM), NULL)
					END) = '' THEN NULL ELSE
					(CASE
						WHEN ((X.VOTNUM IS NOT NULL) AND (LEN(TRIM(X.VOTNUM)) = 10))		-- Si tiene 10 caracteres, tiene formato Gestión [Año(4 char)+Consecutivo(6 char)], sino se guarda tal como viene
							THEN SUBSTRING(X.VOTNUM, 5, LEN(X.VOTNUM)-4)
						ELSE ISNULL(TRIM(X.VOTNUM), NULL)
					END)
					END
					As  ConsecutivoResolucion,
					ISNULL(X.FECVOTO, U.FECHA)												As  FechaAsignacion,
					U.CODDEJ																As  Contexto,
					X.USUREDAC																As  UsuarioCrea,
					CASE
						WHEN REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(X.VOTNUM)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') = '' OR REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(X.VOTNUM)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') IS NULL  THEN 'P'
						ELSE 'A'
					END																		As  Estado,
					X.JUEZ																	As  JUEZ,
					'SplitOtros'															As	SplitOtros,
					X.ENVIADO_SINALEVI														As	EstadoEnvioSAS
	FROM			DACORES							As	X
	INNER JOIN		DACO							As	U With(NoLock)
	ON				X.IDACO							=	U.IDACO
	LEFT JOIN		Catalogo.TipoResolucion			B	With(NoLock) 
	ON				B.TN_CodTipoResolucion			=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DespachoDestino,'TipoResolucion', X.CODRES,0,0))
	LEFT JOIN		Catalogo.ResultadoResolucion	C With(NoLock) 
	ON				C.TN_CodResultadoResolucion		=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_DespachoDestino,'ResultadoResolucion', X.CODRESUL,0,0))
	LEFT JOIN		Catalogo.Contexto				As	E With(NoLock)
	ON				E.TC_CodContexto				=	@L_DespachoDestino	
END
GO
