SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<12/05/2021>
-- Descripción :			<Permite consultar las audiencias >
-- =============================================================================================================================================================================
-- Modificación:			<21/06/2021><Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<01/07/2021><Ronny Ramí­rez R.> <Se agrega Configuración (C_ITI_TipoAudienciaXDefecto) por defecto para tipo de audiencia en caso de no venir.>
-- Modificación:			<21/07/2021><Ronny Ramírez R.> <Se aplica conversión a DateTime2 en el mapeo del campo FECHA del DACO, para ser mapeado a FechaCrea>
-- Modificación:			<01/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo TipoAudiencia)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarDetalleAudienciasGestion]
	@CodItineracion Uniqueidentifier = null
AS
BEGIN
	--Variables 
	DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion,
			@L_XML						XML,
			@L_ASUNTO					SMALLINT,
			@L_ContextoDestino			VARCHAR(4),
			@L_CodTipoAudienciaxDefecto	SMALLINT;

	SELECT	@L_ContextoDestino					= RECIPIENTADDRESS 
	FROM	ItineracionesSIAGPJ.dbo.MESSAGES	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	SELECT	@L_CodTipoAudienciaxDefecto	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoAudienciaXDefecto', @L_ContextoDestino));

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion;

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH MULTIMEDIA AS (
		SELECT	A.B.value('(SINCRONIZADO)[1]',			'BIT')						SINCRONIZADO,
				A.B.value('(IDACO)[1]',					'INT')						IDACO,
				A.B.value('(CARPETA)[1]',				'VARCHAR(14)')				CARPETA,
				A.B.value('(DESCRIP)[1]',				'VARCHAR(255)')				DESCRIPCION,
				A.B.value('(DESPACHO_CREA)[1]',			'VARCHAR(4)')				DESPACHOCREA,
				A.B.value('(ESTADO)[1]',				'VARCHAR(1)')				ESTADO,
				A.B.value('(DURACION)[1]',				'VARCHAR(50)')				DURACION,
				A.B.value('(CANTARCH)[1]',				'INT')						CANTIDADARCHIVOS,
				A.B.value('(SISTEMA)[1]',				'VARCHAR(1)')				SISTEMA,
				A.B.value('(IDACO_ORIGINAL)[1]',		'INT')						IDACO_ORIGINAL,
				A.B.value('(IDMULTI)[1]',				'INT')						IDMULTI
		FROM	@L_XML.nodes('(/*/DMULTIMEDIA)')		AS A(B)
	),
	DCAR AS (
		SELECT	C.D.value('(NUE)[1]',					'VARCHAR(14)')				NUE,
				C.D.value('(CARPETA)[1]',				'VARCHAR(14)')				CARPETA
		FROM	@L_XML.nodes('(/*/DCAR)')				AS C(D)
	),
	DACODOCR AS (
		SELECT	E.F.value('(IDACO)[1]',					'INT')						IDACO,
				E.F.value('(CARPETA)[1]',				'VARCHAR(14)')				CARPETA,
				E.F.value('(DESCRIP)[1]',				'VARCHAR(255)')				DESCRIPCION
		FROM	@L_XML.nodes('(/*/DACODOCR)')			AS E(F)
	),
	DACO AS (
		SELECT	G.H.value('(IDACO)[1]',					'INT')						IDACO,
				G.H.value('(CARPETA)[1]',				'VARCHAR(14)')				CARPETA,
				G.H.value('(CODTIPDOC)[1]',				'VARCHAR(12)')				CODTIPDOC,
				G.H.value('(IDUSU)[1]',					'VARCHAR(25)')				IDUSU,
				TRY_CONVERT(DATETIME2(3), G.H.value('(FECHA)[1]', 'VARCHAR(35)'))	FECHA
		FROM	@L_XML.nodes('(/*/DACO)')				AS G(H)
	)

	SELECT		0							AS Codigo,
				A.DESCRIPCION				AS Descripcion,
				C.DESCRIPCION				AS NombreArchivo,
				A.DESPACHOCREA				AS Despacho_Crea,
				A.DURACION					AS DuracionTotal,
				D.FECHA						AS FechaCrea,
				A.CANTIDADARCHIVOS + 1		AS CantidadArchivos,
				A.IDACO_ORIGINAL			AS Idaco_Original,
				A.IDMULTI					AS IDMULTI,
				'SplitExpediente'			AS SplitExpediente,
				B.NUE						AS Numero,
				'SplitTipoAudiencia'		AS SplitTipoAudiencia,
				E.TN_CodTipoAudiencia		AS Codigo,
				E.TC_Descripcion			AS Descripcion,
				'SplitFuncionario'			AS SplitFuncionario,
				D.IDUSU						as UsuarioRed,
				'Split'						AS Split,
				CASE WHEN A.SINCRONIZADO = 0
					THEN 'N'
					ELSE 'S'
				END							AS Estado,
				A.ESTADO					AS EstadoPublicacion,
				A.SISTEMA					AS Sistema
	FROM		MULTIMEDIA					A 
	INNER JOIN  DCAR						B
	ON			A.CARPETA					= B.CARPETA
	LEFT JOIN	DACODOCR					C
	ON			C.CARPETA					= A.CARPETA
	AND			C.IDACO						= A.IDACO
	INNER JOIN	DACO						D
	ON			D.IDACO						= A.IDACO
	LEFT JOIN	Catalogo.TipoAudiencia		E With(NoLock) 
	ON			E.TN_CodTipoAudiencia		= ISNULL(CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoAudiencia', D.CODTIPDOC,0,0)), @L_CodTipoAudienciaxDefecto)
	
END
GO
