SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<05/03/2020>
-- Descripción :		<Permite consultar los documentos asociados a un expediente de SIAGPJ mapeado a registros de Gestión con sus cat logos respectivos>
-- =============================================================================================================================================================================
-- Modificación :		<18/03/2021><Karol Jiménez Sánchez><Se realizan ajustes varios a este mapeo (documentos duplicados, DCARTD9 y DACODOC sin retornos, se elimina DACOSOL del retorno porque no aplican en los resultados, etc)>
-- Modificado:			<06/04/2021><Karol Jiménez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO, se corrije select final de DACO, falta una coma y no cargaba CODTIDEJ por esto>
-- Modificado:			<25/06/2021><Luis Alonso Leiva Tames><Se modifica para que muestre todos los documentos sin importar el estado>
-- Modificado:			<09/07/2021><Jose Gabriel Cordero Soto><Se agrega el CODIGO ESTADO del ARCHIVO en CODESTACO en @DOCTEMP y otras tablas que se necesitan>
-- Modificación:		<01/10/2021> <Karol Jiménez Sánchez> <Se aplica cambio para obtención de equivalencias cat logo Estados desde módulo de equivalencias>
-- Modificado:			<07/10/2022><Josué Quirós Batista> <Se especifica el código del despacho origen de la itineración a la tabla tblArchivos.>
-- Modificación:		<10/02/2023> <Ronny Ramírez R.> <Se aplica ajuste para utilizar la carpeta de la tabla ItineracionSolicitudResultado en lugar de Legajo>
-- Modificación:		<09/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo, Asunto,
--						TipoResolucion, TipoIntervencion, ResultadoLegajo, ClaseAsunto, Fase y Prioridad)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarResultadoSolicitudItineracionSIAGPJ]
 	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS 
BEGIN
	--Variables 
	DECLARE	@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= NULL,
			@L_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_CodContextoOrigen						VARCHAR(4)			= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL,
			@L_DacoInicial								INT					= 1,
			@L_UsuarioRed								VARCHAR(30),	
			@L_NumeroExpediente							VARCHAR(14);
		
	--******************************************************************************************
	--DEFINIR TABLAS TEMPORALES

	DECLARE @DCAR AS TABLE
	(
			[CARPETA] 			[varchar](14) 		NOT NULL,
			[NUE] 				[varchar](14) 		NOT NULL,
			[CODASU] 			[varchar](3) 		NOT NULL,
			[CODCLAS] 			[varchar](9) 		NOT NULL,
			[CODMAT] 			[varchar](5) 		NOT NULL,
			[FECENT] 			[datetime2](3) 		NOT NULL,
			[FECULTACT] 		[datetime2](3) 		NOT NULL,
			[CODDEJ] 			[varchar](4) 		NOT NULL,
			[CODJURIS] 			[varchar](2) 		NOT NULL,
			[CODPRO] 			[varchar](5) 		NULL,
			[CODJUDEC] 			[varchar](11) 		NULL,
			[CODJUTRA] 			[varchar](11) 		NULL,
			[CODFAS] 			[varchar](6) 		NULL,
			[FECFASE] 			[datetime2](3) 		NULL,
			[CODESTASU] 		[varchar](9) 		NULL,
			[FECEST] 			[datetime2](3) 		NULL,
			[CODGT] 			[varchar](11) 		NULL,
			[DESCRIP] 			[varchar](255) 		NOT NULL,
			[cuantia] 			[numeric](12, 2) 	NULL,
			[CODCUANTIA] 		[varchar](2) 		NULL,
			[PIEZA] 			[int] 				NULL,
			[NUMFOL] 			[int] 				NULL,
			[CODPRI] 			[varchar](9) 		NULL,
			[IDACOUBI] 			[int] 				NULL,
			[CODCLR] 			[varchar](9) 		NULL,
			[TENGOACUM] 		[varchar](1) 		NULL,
			[CARPETAACUM] 		[varchar](14) 		NULL,
			[ES_FINEST] 		[varchar](1) 		NULL,
			[codubi] 			[varchar](25) 		NULL,
			[ubica] 			[varchar](255) 		NULL,
			[fecubi] 			[datetime2](3) 		NULL,
			[codsubest] 		[varchar](9) 		NULL,
			[fecsubest] 		[datetime2](3) 		NULL,
			[FECPLAZO] 			[datetime2](3) 		NULL,
			[FOLCUAN] 			[int] 				NULL,
			[CODSECTOR] 		[char](2) 			NULL,
			[FECTURNMAG] 		[datetime2](3) 		NULL,
			[CODESC] 			[varchar](11) 		NULL,
			[CODMON] 			[varchar](3) 		NULL,
			[ESELECTRONICO] 	[bit] 				NOT NULL,
			[CODTAREA] 			[varchar](10) 		NULL,
			[CODACTUBI] 		[varchar](10) 		NULL,
			[CODSECCION]		[varchar](4)		NULL,
			[CASORELEVANTE] 	[varchar](1)		NULL
	);

	DECLARE @DCARTD9 AS TABLE 
	(
			CARPETA		[varchar](14)		NOT NULL,
			DESCRIP		[varchar](255)		NULL,
			CODESTITI	[varchar](1)		NULL,
			FECESTITI	[datetime2](7)		NULL,
			FECDEVOL	[datetime2](7)		NULL,
			CODRESUL	[varchar](9)		NULL,
			CODDEJORI	[varchar](4)		NULL,
			IDACOSOL	[int]				NULL,
			IDACOREF	[int]				NULL,
			ID_NAUTIUS	[varchar](255)		NULL,
			CARPETAORI	[varchar](14)		NULL,
			DESPJUDFP	[varchar](255)		NULL
	);

	DECLARE @DOCTEMP AS TABLE 
	(
			[TU_CodArchivo]			UNIQUEIDENTIFIER	NOT NULL,-- Llaves de documentos SIAGPJ
			[CARPETA]				[varchar](14)		NOT NULL,
			[DESPACHO_TRAMITE]		[varchar](4)		NULL,
			[CODTIDEJ]				[varchar](2)		NOT NULL,
			[USUARIO_LOGIN]			[varchar](50)		NOT NULL,
			[DESCRIPCION]			[varchar](255)		NULL,
			[FECHA]					[datetime2](3)		NULL,
			[NOMBRE]				[varchar](255)		NOT NULL,
			[NOMBRE_GUID]			[varchar](255)		NULL,
			[IDPATH]				[varchar](255)		NOT NULL,
			[CODGT]					[varchar](9)		NULL,
			[NOTIFICA]				[bit]				NOT NULL,
			[TF_Particion]			[datetime2](3)		NOT NULL,
			[CODASU]				[varchar](3)		NULL,
			[CARPETAORI]			[varchar](14)		NULL,
			[CODDEJORI]			    [varchar](4)		NULL,
			[CODESTITI]				[varchar](1)		NULL,
			[FECESTITI]				[datetime2](3)		NULL,
			[ID_NAUTIUS]			[varchar](255)		NULL,
			[FECDEVOL]				[datetime2](3)		NULL,
			[IDACOSOL]				[bigint]			NULL,
			[TU_CodResolucion]		UNIQUEIDENTIFIER	NULL,
			[CODRES]				[varchar](4)		NULL,
			[IDACOINT]				[int]				NULL,
			[CODPRESENT]			[varchar](9)		NULL,
			[VOTNUM]				[varchar](10)		NULL,
			[IDACO]					[int]				NOT NULL,
			[CODRESUL]				[varchar](9)		NULL,
			[CODESTACO]				[varchar](1)		NULL
	);

	DECLARE @tblArchivos AS TABLE 
	(
			[id]			[int]				NOT NULL,
			[idaco]			[int]				NOT NULL,
			[tipo]			[int]				NOT NULL,
			[nombre]		[varchar](255)		NOT NULL,
			[idruta]		[int]				NOT NULL,
			[ruta]			[varchar](255)		NOT NULL,
			[comprimido]	[bit]				NOT NULL,
			[adjunto]		[bit]				NOT NULL,
			[coddej]		[varchar](4)		NOT NULL,
			[ubicacion]		[int]				NOT NULL,
			[error]			[bit]				NULL,
			[errordesc]		[varchar](255)		NULL,
			[tamanio]		[int]				NOT NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL
	); 

	DECLARE @DPATH AS TABLE 
	(
			[IDPATH]			[int]				NOT NULL,
			[PATH]				[varchar](255)		NULL
	);

	DECLARE @DACO AS TABLE 
	(
			[FECDOC]		[datetime2](7)	NULL,
			[CARPETA]		[varchar](14)	NOT NULL,
			[IDACO]			[int]			NOT NULL,
			[CODDEJ]		[varchar](4)	NOT NULL,
			[FECHA]			[datetime2](3)	NOT NULL,
			[TEXTO]			[varchar](255)  NULL,
			[CODACO]		[varchar](9)	NOT NULL,
			[NUMACO]		[varchar](10)	NULL,
			[FECSYS]		[datetime2](3)  NOT NULL,
			[IDUSU]			[varchar](25)	NOT NULL,
			[CODDEJUSR]		[varchar](4)	NOT NULL,
			[CODESTACO]		[varchar](1)	NULL,
			[FECEST]		[datetime2](3)  NULL,
			[NUMFOL]		[int]			NULL,
			[NUMFOLINI]		[int]			NULL,
			[PIEZA]			[int]			NULL,
			[CODPRO]		[varchar](5)	NULL,
			[CODJUDEC]		[varchar](11)	NULL,
			[CODJUTRA]		[varchar](11)	NULL,
			[CODTRAM]		[varchar](12)	NULL,
			[CODESTADIST]   [varchar](5)	NULL,
			[CODTIDEJ]		[varchar](2)	NOT NULL,
			[IDACOREL]		[int]			NULL,
			[CODREL]		[varchar](3)	NULL,
			[PRIORI]		[int]			NULL,
			[CODICO]		[varchar](9)	NULL,
			[AMPLIAR]		[varchar](100)	NULL,
			[CANT]			[int]			NULL,
			[CODGT]			[varchar](9)	NULL,
			[CODESC]		[varchar](11)	NULL,
			[FECENTRDD]		[datetime2](3)	NULL,
			[CODTIPDOC]		[varchar](12)	NULL,
			[OTRGEST]		[bit]			NOT NULL,
			[IDENTREGA]		[varchar](20)	NULL,
			[FINALIZAEXP]	[varchar](2)	NULL
	);

	DECLARE @DACODOC AS TABLE 
	(
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NOT NULL,
			[IDDOC]			[int]				NOT NULL,
			[IDPATH]		[varchar](255)		NOT NULL,
			[CODMOD]		[varchar](12)		NOT NULL,
			[CODICO]		[varchar](9)		NULL,	
			[NOMBRE]		[varchar](50)		NOT NULL,
			[PUBLICADO]		[bit]				NOT NULL,
			[FIRMADO]		[char](1)			NULL,
			[TU_CodArchivo]	uniqueidentifier    NOT NULL
	);


	--******************************************************************************************
	--SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES
	SELECT	@L_ValorDefectoRutaDescargaDocumentosFTP	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');

	--******************************************************************************************
	--OBTENER VALORES PARA CONSULTAS

	--OBTIENE EL USUARIO DEL HISTORICO DE ITINERACION
	SELECT @L_UsuarioRed				= A.TC_UsuarioRed
	FROM   Historico.Itineracion		A WITH(NOLOCK)
	WHERE  A.TU_CodHistoricoItineracion	= @L_CodHistoricoItineracion

	--SE OBTIUENE EL NÚMERO DE EXPEDIENTE Y CÓDIGO DE LEGAJO SI EL HISTÓRICO ESTÁ RELACIONADO A UN LEGAJO
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_CodContextoOrigen	= TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--******************************************************************************************
	--INSERCION DE DATOS EN TABLAS TEMPORALES

	INSERT INTO	@DOCTEMP
	SELECT		D.TU_CodArchivo															-- ID SIAGPJ
				,N.CARPETA																-- CARPETA (#Expediente o Legajo)
				,D.TC_CodContextoCrea													-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,T.CODTIDEJ																-- COTIDEJ
				,D.TC_UsuarioCrea														-- USUARIO_LOGIN -- IDUSU
				,D.TC_Descripcion														-- DESCRIPCION DACO.TEXTO
				,D.TF_FechaCrea															-- FECCREACION -- DACO:FECSYS
				,CONCAT(D.TU_CodArchivo, F.TC_Extensiones) AS NombreArchivo				-- NOMBRE -- DACODOC.NOMBRE
				,NULL																	-- NOMBRE_GUID
				,'1'																	-- IDPATH TODO: se debe definir este ID para SIAGPJ en BD de Gestión?
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0)-- Grupo de trabajo
				,E.TB_Notifica 
				,D.TF_Particion
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Asunto', H.TN_CodAsunto,0,0)-- CODASU
				,N.CARPETA																-- CARPETAORI
				,H.TC_CodContextoProcedencia											-- CODDEJORI
				,'I'																	-- CODESTITI
				,GETDATE()																-- FECESTITI
				,A.TU_CodHistoricoItineracion											-- ID_NAUTIUS -- debería tener el GUID cuando se envía
				,A.TF_FechaEnvio														-- FECDEVOL
				,N.IDACOSOL																-- IDACOSOL
				,K.TU_CodResolucion														-- TU_CodResolucion
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoResolucion', K.TN_CodTipoResolucion,0,0)-- CODRES
				,P.IDINT																-- IDACOINT
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIntervencion', R.TN_CodTipoIntervencion,0,0)-- CODPRESENT
				,M.TC_NumeroResolucion													-- VOTO
				,(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1)  -- [IDACO]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ResultadoLegajo', A.TN_CodResultadoLegajo,0,0)-- CODRESUL	
				,D.TN_CodEstado															-- CODESTACO
	FROM		Expediente.ResultadoSolicitud			A	WITH(NOLOCK)	
	INNER JOIN	Historico.Itineracion					B	WITH(NOLOCK)
	ON			B.TU_CodHistoricoItineracion			=	A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.ResultadoSolicitudArchivos	C	WITH(NOLOCK)
	ON			C.TU_CodResultadoSolicitud				=	A.TU_CodResultadoSolicitud
	INNER JOIN	Archivo.Archivo							D	WITH(NOLOCK)
	ON			D.TU_CodArchivo							=	C.TU_CodArchivo
	INNER JOIN	Expediente.ArchivoExpediente			E	WITH(NOLOCK)
	ON			E.TU_CodArchivo							=	D.TU_CodArchivo
	AND			E.TC_NumeroExpediente					=	C.TC_NumeroExpediente	
	INNER JOIN	Catalogo.FormatoArchivo					F	WITH(NOLOCK)
	ON			F.TN_CodFormatoArchivo					=	D.TN_CodFormatoArchivo
	INNER JOIN	Expediente.LegajoDetalle				H	WITH (NOLOCK)
	ON			H.TU_CodLegajo							=	A.TU_CodLegajo
	AND			H.TC_CodContexto						=	B.TC_CodContextoOrigen
	INNER JOIN	Expediente.Legajo						I	WITH (NOLOCK)
	ON			I.TU_CodLegajo							=	H.TU_CodLegajo	
	LEFT JOIN	Expediente.Resolucion					K	WITH (NOLOCK)
	ON			K.TU_CodArchivo							=	E.TU_CodArchivo
	AND			K.TC_NumeroExpediente					=	K.TC_NumeroExpediente
	LEFT JOIN	Expediente.LibroSentencia				M	WITH (NOLOCK)
	ON			M.TU_CodResolucion						=	K.TU_CodResolucion
	LEFT JOIN	Historico.ItineracionSolicitudResultado	N	WITH (NOLOCK)
	ON			N.TU_CodLegajo							=	I.TU_CodLegajo
	OUTER APPLY (
					SELECT		TOP 1 TU_CodInterviniente 
					FROM		Expediente.LegajoIntervencion	WITH(NOLOCK)
					WHERE		TU_CodLegajo					= I.TU_CodLegajo
					ORDER BY	TF_Particion					ASC
				) O
	LEFT JOIN	Expediente.Intervencion					P	WITH (NOLOCK)
	ON			P.TU_CodInterviniente					=	O.TU_CodInterviniente
	LEFT JOIN	Expediente.Interviniente				R	WITH (NOLOCK)
	ON			R.TU_CodInterviniente					=	O.TU_CodInterviniente
	LEFT JOIN	Catalogo.Contexto						T	WITH(NOLOCK)
	ON			T.TC_CodContexto						=	D.TC_CodContextoCrea
	WHERE		A.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;

	INSERT INTO @DCAR
	SELECT
				O.CARPETA					--CARPETA
				,D.TC_NumeroExpediente		--NUE
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Asunto', C.TN_CodAsunto,0,0)--CODASU
				,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ClaseAsunto', C.TN_CodClaseAsunto,0,0), '')--CODCLAS
				,'M1'						--CODMAT
				,C.TF_Entrada				--FECENT
				,GETDATE()					--FECULTACT
				,C.TC_CodContexto			--CODDEJ
				,F.TC_CodMateria			--CODJURIS
				,NULL						--CODPRO
				,NULL						--CODJUDEC
				,NULL						--CODJUTRA
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Fase', M.TN_CodFase,0,0)--CODFAS
				,M.TF_Fase					--FECFASE
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(B.TC_CodContextoOrigen,'Estado', K.TN_CodEstado,0,0)--CODESTASU
				,K.TF_Fecha					--FECEST
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', C.TN_CodGrupoTrabajo,0,0)--CODGT
				,COALESCE(NULLIF(D.TC_Descripcion, ''), 'Sin Observaciones')	--DESCRIP
				,NULL						--CUANTIA
				,NULL						--CODCUANTIA
				,1							--PIEZA
				,NULL						--NUMFOL
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Prioridad', D.TN_CodPrioridad,0,0)--CODPRI
				,NULL						--IDACOUBI
				,NULL						--CODCLR
				,NULL						--TENGOACUM - 1 si es pap 
				,NULL						--CARPETAACUM - Carpeta de Pap 
				,'S'							--ES_FINEST - Si ya está terminado
				,NULL						--CODUBI
				,'Recepción de itineración'	--UBICA
				,NULL						--FECUBI
				,NULL						--CODSUBEST
				,NULL						--FECSUBEST
				,NULL						--FECPLAZO
				,NULL						--FOLCUAN
				,NULL						--CODSECTOR
				,NULL						--CODESC
				,NULL						--FECTURNMAG
				,NULL						--CODMON
				,1							--ESELECTRONICO
				,NULL						--CODTAREA
				,NULL						--CODACTUBI
				,NULL						--CODSECCION
				,NULL						--CASORELEVANTE
	FROM		Expediente.ResultadoSolicitud			A	WITH(NOLOCK)	
	INNER JOIN	Historico.Itineracion					B	WITH(NOLOCK)
	ON			B.TU_CodHistoricoItineracion			=	A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle				C	WITH (NOLOCK)
	ON			C.TU_CodLegajo							=	A.TU_CodLegajo
	AND			C.TC_CodContexto						=	B.TC_CodContextoOrigen
	INNER JOIN	Expediente.Legajo						D	WITH (NOLOCK)
	ON			D.TU_CodLegajo							=	C.TU_CodLegajo	
	INNER JOIN	Catalogo.Contexto						F	WITH (NOLOCK)
	ON			F.TC_CodContexto						=	C.TC_CodContexto
	OUTER APPLY (
					SELECT  TOP(1)  Z.TF_Fecha, Z.TN_CodEstado
					FROM			Historico.LegajoMovimientoCirculante Z WITH (NOLOCK)
					WHERE			Z.TU_CodLegajo						 = C.TU_CodLegajo
					ORDER BY		Z.TF_Fecha DESC
				) K
	OUTER APPLY (
					SELECT TOP(1)	Y.TF_Fase, Y.TN_CodFase
					FROM			Historico.LegajoFase				Y WITH (NOLOCK)
					WHERE  			Y.TU_CodLegajo						= C.TU_CodLegajo 
					ORDER BY		Y.TF_Particion DESC
				) M
	LEFT JOIN	Historico.ItineracionSolicitudResultado	O	WITH (NOLOCK)
	ON			O.TU_CodLegajo							=	D.TU_CodLegajo
	WHERE		B.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + N
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP WHERE IDACO IS NOT NULL;

	INSERT INTO @DCARTD9
	SELECT		D.CARPETA					--CARPETA
				,'Respuesta de solicitud'	--DESCRIP
				,'I'						--CODESTITI
				,sysdatetime()				--FECESTITI
				,D.FECDEVOL					--FECDEVOL
				,D.CODRESUL					--CODRESUL
				,D.CODDEJORI				--CODDEJORI
				,D.IDACOSOL					--IDACOSOL --Se obtiene de Historico.ItineracionSolicitudResultado y corresponde al IDACO de la solicitud recibido
				,D.IDACO					--IDACOREF -- IDACO del primer documento de resultado 
				,D.ID_NAUTIUS				--ID_NAUTIUS
				,D.CARPETAORI				--CARPETAORI--Carpeta del origen de la solicitud,
				,NULL						--DESPJUDFP
	FROM		@DOCTEMP	D
	WHERE		D.IDACO		= (
									SELECT		TOP 1 IDACO
									FROM		@DOCTEMP
									ORDER BY	IDACO ASC -- Trae de primero el registro con el primer IDACO ordenado ascendentemente
								)

	INSERT INTO @DACO
	SELECT		NULL																					--  FECDOC
				,D.CARPETA																				--	CARPETA
				,D.IDACO																				--	IDACO
				,D.DESPACHO_TRAMITE																		--	CODDEJ
				,COALESCE(D.FECHA, GETDATE())															--  FECHA
				,D.DESCRIPCION																			--  TEXTO
				,'EMI'																					--  CODACO
				,NULL																					--  NUMACO**
				,COALESCE(D.FECHA, GETDATE())															--  FECSYS
				,COALESCE(D.USUARIO_LOGIN, '')															--  IDUSU
				,D.DESPACHO_TRAMITE																		--  CODDEJUSR
				,CASE D.CODESTACO
					WHEN 4 THEN '5'
					ELSE D.CODESTACO
				 END																					--	CODESTACO
				,COALESCE(D.FECHA, GETDATE())															--	FECEST
				,NULL																					--	NUMFOL
				,NULL																					--	NUMFOLINI
				,NULL																					--	PIEZA
				,''																						--	CODPRO
				,NULL																					--	CODJUDEC
				,NULL																					--	CODJUTRA
				,'REG_RESO'																				--	CODTRAM 'CODIGO DEL DOCUMENTO(REG_RESO)'	
				,NULL																					--	CODESTADIST
				,D.CODTIDEJ																				--	CODTIDEJ
				,NULL																					--	IDACOREL
				,NULL																					--	CODREL
				,0																						--	PRIORI
				,NULL																					--	CODICO
				,'0;'																					--	AMPLIAR
				,NULL																					--	CANT
				,NULL																					--	CODGT
				,NULL																					--	CODESC
				,NULL																					--	FECENTRDD
				,NULL																					--	CODTIPDOC
				,0																						--	OTRGEST			   
				,NULL																					--	IDENTREGA
				,NULL																					--	FINALIZAEXP
	FROM		@DOCTEMP D

	INSERT INTO @DPATH 
	SELECT	 1		-- IDPATH
			,CONCAT( 
				@L_ValorDefectoRutaDescargaDocumentosFTP,
				CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
					ELSE '/'
				END
				,Convert(Varchar(36),@CodHistoricoItineracion)
				)		-- PATH
	FROM	@DOCTEMP D

	INSERT INTO @tblArchivos
	SELECT		D.IDACO																		--id
				,D.IDACO																	--idaco
				,0																			--tipo
				,D.NOMBRE																	--nombre
				,D.IDACO																	--idruta
				,CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
					ELSE '/'
				END
				,Convert(Varchar(36),@CodHistoricoItineracion),'/',D.NOMBRE)				--ruta
				,0																			--comprimido
				,0																			--adjunto
				,COALESCE(@L_CodContextoOrigen, '')											--coddej
				,4																			--ubicacion
				,0																			--error
				,NULL																		--errordesc
				,0																			--tamanio
				,D.TU_CodArchivo
	FROM		@DOCTEMP D;

	INSERT INTO @DACODOC
			   ([CARPETA]
			   ,[IDACO]
			   ,[IDDOC]
			   ,[IDPATH]
			   ,[CODMOD]
			   ,[CODICO]
			   ,[NOMBRE]
			   ,[PUBLICADO]
			   ,[FIRMADO]
			   ,[TU_CodArchivo])
	SELECT
			    D.CARPETA				--CARPETA
			   ,D.IDACO					--IDACO
			   ,1						--IDDOC
			   ,D.IDPATH				--IDPATH
			   ,'EMI'					--CODMOD ### TODO: definir valor para enviar ###
			   ,NULL					--CODICO
			   ,LEFT(D.NOMBRE,50)		--NOMBRE
			   ,0						--PUBLICADO
			   ,NULL					--FIRMADO
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP D

	--******************************************************************************************
	--RESULTADOS DE LA CONSULTA

	SELECT  [CARPETA],		[NUE],			[CODASU],		[CODCLAS], 		
			[CODMAT],		[FECENT],		[FECULTACT],	[CODDEJ],		
			[CODJURIS],		[CODPRO],		[CODJUDEC],		[CODJUTRA], 		
			[CODFAS],		[FECFASE],		[CODESTASU],	[FECEST], 		
			[CODGT],		[DESCRIP],		[cuantia],		[CODCUANTIA], 	
			[PIEZA],		[NUMFOL],		[CODPRI],		[IDACOUBI],
			[CODCLR],		[TENGOACUM],	[CARPETAACUM],	[ES_FINEST], 	
			[codubi],		[ubica],		[fecubi],		[codsubest], 	
			[fecsubest],	[FECPLAZO],		[FOLCUAN],		[CODSECTOR], 	
			[FECTURNMAG],	[CODESC],		[CODMON],		[ESELECTRONICO], 
			[CODTAREA],		[CODACTUBI],	[CODSECCION],	[CASORELEVANTE] 
	FROM @DCAR

	SELECT  CARPETA,	DESCRIP,		CODESTITI,   FECESTITI,	
			FECDEVOL,	CODRESUL,		CODDEJORI,   IDACOSOL,	
			IDACOREF,	ID_NAUTIUS, 	CARPETAORI,	 DESPJUDFP	
	FROM	@DCARTD9

	SELECT  FECDOC,			CARPETA,	    IDACO,	 	   CODDEJ,
			FECHA,	 	    TEXTO,			CODACO,		   NUMACO,
			FECSYS,			IDUSU,			CODDEJUSR,	   CODESTACO,
			FECEST,	  	    NUMFOL,			NUMFOLINI,	   PIEZA,
			CODPRO,	  	    CODJUDEC,		CODJUTRA,	   CODTRAM,
			CODESTADIST,	CODTIDEJ,       IDACOREL,	   CODREL,
			PRIORI,	  	    CODICO,		    AMPLIAR,	   CANT,
			CODGT,	 	    CODESC,  	    FECENTRDD,     CODTIPDOC,
			OTRGEST,     	IDENTREGA,      FINALIZAEXP 
	FROM	@DACO

	SELECT	[IDPATH], [PATH]	
	FROM	@DPATH
	
	SELECT  [id],			[idaco],			[tipo],			[nombre],		
			[idruta],		[ruta],				[comprimido],	[adjunto],		
			[coddej],		[ubicacion],		[error],		[errordesc]		
			[tamanio],		[TU_CodArchivo]
	FROM	@tblArchivos; 

	SELECT * FROM @DACODOC;
END
GO
