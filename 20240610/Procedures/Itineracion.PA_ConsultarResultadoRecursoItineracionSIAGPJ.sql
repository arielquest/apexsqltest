SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<03/03/2020>
-- Descripción :		<Permite consultar los documentos asociados a un expediente de SIAGPJ mapeado a registros de Gestión con sus catálogos respectivos>
-- =============================================================================================================================================================================
-- Modificado:			<07/03/2021><Ronny Ramírez R.><Se aplican modificaciones para llenar con datos de resolución DCARTD6, luego de aclaraciones con Elizandro y Esteban>
-- Modificado:			<06/04/2021><Karol Jiménez S nchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificado:			<25/06/2021><Luis Alonso Leiva Tames><Se modifica para que muestre todos los documentos sin importar el estado>
-- Modificado:			<09/07/2021><Jose Gabriel Cordero Soto><Se agrega el CODIGO ESTADO del ARCHIVO en CODESTACO en @DOCTEMP y otras tablas que se necesitan>
-- Modificado:			<29/07/2021><Ronny Ramírez R.><Se asigna valor por defecto por medio de configuración a campo CODESTRES requerido en @DACORES>
-- Modificado:			<11/08/2021><Ronny Ramírez R.><Se agrega valor por defecto tomado del usuario redactor de la resolución para el USUREDAC de DACORES y IDUSU de DACO 
--						en caso que el campo USUREDAC vaya NULL (porque se creó la resolución como resultado de recepcción de una itineración de recurso>
-- Modificación:		<18/08/2021><Jose Gabriel Cordero Soto> <Se ajusta valor del CODESTACO al valor correcto, por inversion con el valor de IDACO>
-- Modificación:		<01/10/2021><Karol Jiménez S nchez> <Se aplica cambio para obtención de equivalencias cat logo Estados desde módulo de equivalencias>
-- Modificación:		<21/09/2022> <Luis Alonso Leiva Tames> <Se realiza ajuste DACO de Resoluciones en el campo texto>																													 
-- Modificado:			<07/10/2022><Josué Quirós Batista> <Se especifica el código del despacho origen de la itineración a la tabla tblArchivos.>
-- Modificación:		<10/02/2023><Ronny Ramírez R.> <Se aplica ajuste para utilizar la carpeta de la tabla ItineracionRecursoResultado en lugar de Legajo>
-- Modificación:		<09/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo, Asunto,
--						TipoResolucion, TipoIntervencion, ClaseAsunto, Fase, Prioridad y ResultadoResolucion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarResultadoRecursoItineracionSIAGPJ]
 	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS 
BEGIN
	--**************************************************************************************************************************************
	--DEFINICION DE VARIABLES Y VALORES POR DEFECTO
	--**************************************************************************************************************************************

	--Variables 
	DECLARE	@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= NULL,
			@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_DacoInicial								INT					= 1,
			@L_ValorDefectoCODESTRES					VARCHAR(3)			= NULL,
			@L_CodContextoOrigen						VARCHAR(4)			= NULL;
	
	/*SE OBTIENEN VALORES POR DEFECTO, SEGéN CONFIGURACIONES*/
	SET	@L_ValorDefectoRutaDescargaDocumentosFTP	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');
	SET	@L_ValorDefectoCODESTRES					= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CODESTRES_ResRecurso','');

	SELECT	@L_CodContextoOrigen	= TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--**************************************************************************************************************************************
	--DEFINICION DE TABLAS
	--**************************************************************************************************************************************

	--Definición de tabla temporal de documentos
	DECLARE @DOCTEMP AS TABLE (
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
			[CARPETAREC]			[varchar](14)		NULL,
			[CODESTITI]				[varchar](1)		NULL,
			[FECESTITI]				[datetime2](3)		NULL,
			[ID_NAUTIUS]			[varchar](255)		NULL,
			[FECDEVOL]				[datetime2](3)		NULL,
			[IDACOREC]				[bigint]			NULL,
			[TU_CodResolucion]		UNIQUEIDENTIFIER	NULL,
			[CODRES]				[varchar](4)		NULL,
			[IDACOINT]				[int]				NULL,
			[CODPRESENT]			[varchar](9)		NULL,
			[VOTNUM]				[varchar](10)		NULL,			
			[CODESTACO]				[varchar](1)		NULL,
			[IDACO]					[int]				NOT NULL);
	--Definición de tabla DCAR
	DECLARE @DCAR AS TABLE(
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
			[CASORELEVANTE] 	[varchar](1)		NULL);
	--Definición de tabla DCARTD6
	DECLARE @DCARTD6 AS TABLE (
			[CARPETA]			[varchar](14)		NOT NULL,
			[CODDEJORI]			[varchar](4)		NOT NULL,
			[CODREC]			[varchar](3)		NOT NULL,
			[IDACOINT]			[int]				NULL,
			[CARPETAREC]		[varchar](14)		NULL,
			[IDACOREC]			[int]				NULL,
			[FECDEVOL]			[datetime2](3)		NULL,
			[IDACORES]			[int]				NULL,
			[CODRES]			[varchar](4)		NULL,
			[IDACOREF]			[int]				NULL,
			[CODESTITI]			[varchar](1)		NULL,
			[FECESTITI]			[datetime2](3)		NULL,
			[VOTNUM]			[varchar](10)		NULL,
			[CODPRESENT]		[varchar](9)		NULL,
			[ID_NAUTIUS]		[varchar](255)		NULL,
			[DESPJUDFP]			[varchar](255)		NULL,
			[FECHORRES]			[datetime2](3)		NULL);
	--Definición de tabla 
	DECLARE @DACORES AS TABLE (
	   [CARPETA]			[varchar](14)	not null
      ,[IDACO]				[int]			not null
      ,[CODJURIS]			[varchar](2)	not null
      ,[CODRESUL]			[varchar](9)	null
      ,[CODESTRES]			[varchar](3)	not null
      ,[FECEST]				[datetime2](3)	not null
      ,[CODNUM]				[varchar](9)	null
      ,[CODRES]				[varchar](4)	not null
      ,[VOTNUM]				[varchar](10)	null
      ,[JUEZ]				[varchar](11)	null
      ,[FECDIC]				[datetime2](3)	null
      ,[FECPUB]				[datetime2](3)	null
      ,[RECURRIDA]			[varchar](1)	null
      ,[CODRESREC]			[varchar](9)	null
      ,[SELECCIONADO]		[varchar](1)	null
      ,[CODESTENV]			[varchar](1)	null
      ,[CODPRESENT]			[varchar](9)	null
      ,[IDUSU]				[varchar](25)	null
      ,[HUBOJUICIO]			[varchar](1)	null
      ,[USUREDAC]			[varchar](25)	null	
      ,[IDACOSENDOC]		[int]			null
      ,[FECVOTO]			[datetime2](3)	null
      ,[ACOPORDOC]			[text]			null
      ,[ENVIADO_SINALEVI]	[varchar](1)	null
      ,[RESUMEN]			[text]			null	
      ,[FECVENCE]			[datetime2](3)	null
      ,[OBSER_DATSENSI]		[varchar](250)	null);
	--Definición de tabla PATH
	DECLARE @DPATH AS TABLE (
			[IDPATH]			[int]				NOT NULL,
			[PATH]				[varchar](255)		NULL);	
	--Definición de tabla DACO 
	-- Validar el campo TU_CodArchivo 
	DECLARE @DACO AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NOT NULL,
			[CODDEJ]		[varchar](4)		NOT NULL,
			[FECHA]			[datetime2](3)		NOT NULL,
			[TEXTO]			[varchar](255)		NULL,
			[CODACO]		[varchar](9)		NOT NULL,
			[NUMACO]		[varchar](10)		NULL,
			[FECSYS]		[datetime2](3)		NOT NULL,
			[IDUSU]			[varchar](25)		NOT NULL,
			[CODDEJUSR]		[varchar](4)		NOT NULL,
			[CODESTACO]		[varchar](1)		NULL,
			[FECEST]		[datetime2](3)		NULL,
			[NUMFOL]		[int]				NULL,
			[NUMFOLINI]		[int]				NULL,
			[PIEZA]			[int]				NULL,
			[CODPRO]		[varchar](5)		NULL,
			[CODJUDEC]		[varchar](11)		NULL,
			[CODJUTRA]		[varchar](11)		NULL,
			[CODTRAM]		[varchar](12)		NULL,
			[CODESTADIST]	[varchar](5)		NULL,
			[CODTIDEJ]		[varchar](2)		NOT NULL,
			[IDACOREL]		[int]				NULL,
			[CODREL]		[varchar](3)		NULL,
			[PRIORI]		[int]				NULL,
			[CODICO]		[varchar](9)		NULL,
			[AMPLIAR]		[varchar](100)		NULL,
			[CANT]			[int]				NULL,
			[CODGT]			[varchar](9)		NULL,
			[CODESC]		[varchar](11)		NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[CODTIPDOC]		[varchar](12)		NULL,
			[OTRGEST]		[bit]				NOT NULL,			   
			[IDENTREGA]		[varchar](20)		NULL,
			[FINALIZAEXP]	[varchar](2)		NULL); 
	--Definición de tabla DACODOC
	DECLARE @DACODOC AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NOT NULL,
			[IDDOC]			[int]				NOT NULL,
			[IDPATH]		[varchar](255)		NOT NULL,
			[CODMOD]		[varchar](12)		NOT NULL,
			[CODICO]		[varchar](9)		NULL,	
			[NOMBRE]		[varchar](50)		NOT NULL,
			[PUBLICADO]		[bit]				NOT NULL,
			[FIRMADO]		[char](1)			NULL,
			[TU_CodArchivo]	uniqueidentifier    NOT NULL); -- Llaves de documentos SIAGPJ	
	--Definición de tabla tblArchivos
	DECLARE @tblArchivos AS TABLE (
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
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ

	--**************************************************************************************************************************************
	--INSERCION EN TABLAS TEMPORALES
	--**************************************************************************************************************************************	
	
	--DOCUMENTOS asociados al Resultado Recurso
	INSERT INTO	@DOCTEMP
	SELECT		 D.TU_CodArchivo				-- ID SIAGPJ
				,IR.CARPETA						-- CARPETA (#Expediente o Legajo)
				,D.TC_CodContextoCrea			-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,C.CODTIDEJ						-- COTIDEJ
				,D.TC_UsuarioCrea				-- USUARIO_LOGIN -- IDUSU
				,D.TC_Descripcion				-- DESCRIPCION DACO.TEXTO
				,D.TF_FechaCrea					-- FECCREACION -- DACO:FECSYS
				,CONCAT(D.TU_CodArchivo, F.TC_Extensiones) AS NombreArchivo	-- NOMBRE -- DACODOC.NOMBRE
				,NULL							-- NOMBRE_GUID
				,'1'							-- IDPATH TODO: se debe definir este ID para SIAGPJ en BD de Gestión?
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0) -- CODGT - Grupo de trabajo
				,E.TB_Notifica 
				,D.TF_Particion
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Asunto', ED.TN_CodAsunto,0,0)-- CODASU
				,IR.CARPETA						-- CARPETAREC
				,'I'							-- CODESTITI
				,GETDATE()						-- FECESTITI
				,RR.TU_CodHistoricoItineracion	-- ID_NAUTIUS -- debería tener el GUID cuando se envía
				,RR.TF_FechaEnvio				-- FECDEVOL
				,IR.IDACOREC					-- IDACOREC
				,R.TU_CodResolucion				-- TU_CodResolucion
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoResolucion', R.TN_CodTipoResolucion,0,0)	-- CODRES
				,II.IDINT						-- IDACOINT
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIntervencion', IT.TN_CodTipoIntervencion,0,0)	-- CODINT => CODPRESENT
				,LS.TC_NumeroResolucion			-- VOTO
				,D.TN_CodEstado					-- CODESTACO
				,(ROW_NUMBER() over (order by RR.TF_Particion ASC) + @L_DacoInicial -1) -- [IDACO]
	FROM		Expediente.ResultadoRecurso				RR	WITH(NOLOCK)	
	INNER JOIN	Historico.Itineracion					I	WITH(NOLOCK)
	ON			I.TU_CodHistoricoItineracion			=	RR.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.ResultadoRecursosArchivos	RA	WITH(NOLOCK)
	ON			RA.TU_CodResultadoRecurso				=	RR.TU_CodResultadoRecurso
	INNER JOIN	Archivo.Archivo							D	WITH(NOLOCK)
	ON			D.TU_CodArchivo							=	RA.TU_CodArchivo
	INNER JOIN	Expediente.ArchivoExpediente			E	WITH(NOLOCK)
	ON			E.TU_CodArchivo							=	D.TU_CodArchivo
	AND			E.TC_NumeroExpediente					=	RA.TC_NumeroExpediente	
	INNER JOIN	Catalogo.FormatoArchivo					F	WITH(NOLOCK)
	ON			F.TN_CodFormatoArchivo					=	D.TN_CodFormatoArchivo
	INNER JOIN	Expediente.LegajoDetalle				ED	WITH (NOLOCK)
	ON			ED.TU_CodLegajo							=	RR.TU_CodLegajo
	AND			ED.TC_CodContexto						=	I.TC_CodContextoOrigen
	INNER JOIN	Expediente.Legajo						L	WITH (NOLOCK)
	ON			L.TU_CodLegajo							=	ED.TU_CodLegajo	
	LEFT JOIN	Expediente.Resolucion					R	WITH (NOLOCK)
	ON			R.TU_CodArchivo							=	E.TU_CodArchivo
	AND			R.TC_NumeroExpediente					=	E.TC_NumeroExpediente
	LEFT JOIN	Expediente.LibroSentencia				LS	WITH (NOLOCK)
	ON			LS.TU_CodResolucion						=	R.TU_CodResolucion
	LEFT JOIN	Historico.ItineracionRecursoResultado	IR	WITH (NOLOCK)
	ON			IR.TU_CodLegajo							=	L.TU_CodLegajo
	LEFT JOIN	Expediente.LegajoIntervencion			LI	WITH (NOLOCK)
	ON			LI.TU_CodLegajo							=	L.TU_CodLegajo
	AND			LI.TU_CodInterviniente = (
				  SELECT	TOP 1 TU_CodInterviniente 
				  FROM		Expediente.LegajoIntervencion	WITH(NOLOCK)
				  WHERE		TU_CodLegajo					= LI.TU_CodLegajo
				  ORDER BY	TF_Particion					ASC
				)
	LEFT JOIN	Expediente.Intervencion					II	WITH (NOLOCK)
	ON			II.TU_CodInterviniente					=	LI.TU_CodInterviniente
	LEFT JOIN	Expediente.Interviniente				IT	WITH (NOLOCK)
	ON			IT.TU_CodInterviniente					=	LI.TU_CodInterviniente
	LEFT JOIN	Catalogo.Contexto						C	WITH(NOLOCK)
	ON			C.TC_CodContexto						=	D.TC_CodContextoCrea
	WHERE		RR.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;

	--INSERCION EN DCAR
	INSERT INTO @DCAR
			   ([CARPETA]
			   ,[NUE]
			   ,[CODASU]
			   ,[CODCLAS]
			   ,[CODMAT]
			   ,[FECENT]
			   ,[FECULTACT]
			   ,[CODDEJ]
			   ,[CODJURIS]
			   ,[CODPRO]
			   ,[CODJUDEC]
			   ,[CODJUTRA]
			   ,[CODFAS]
			   ,[FECFASE]
			   ,[CODESTASU]
			   ,[FECEST]
			   ,[CODGT]
			   ,[DESCRIP]
			   ,[cuantia]
			   ,[CODCUANTIA]
			   ,[PIEZA]
			   ,[NUMFOL]
			   ,[CODPRI]
			   ,[IDACOUBI]
			   ,[CODCLR]
			   ,[TENGOACUM]
			   ,[CARPETAACUM]
			   ,[ES_FINEST]
			   ,[codubi]
			   ,[ubica]
			   ,[fecubi]
			   ,[CODSUBEST]
			   ,[FECSUBEST]
			   ,[FECPLAZO]
			   ,[FOLCUAN]
			   ,[CODSECTOR]
			   ,[CODESC]
			   ,[FECTURNMAG]
			   ,[CODMON]
			   ,[ESELECTRONICO]
			   ,[CODTAREA]
			   ,[CODACTUBI]
			   ,[CODSECCION]
			   ,[CASORELEVANTE])
	SELECT
			    IR.CARPETA					--CARPETA
			   ,E.TC_NumeroExpediente		--NUE
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Asunto', ED.TN_CodAsunto,0,0)--CODASU
			   ,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ClaseAsunto', ED.TN_CodClaseAsunto,0,0), '')--CODCLAS
			   ,'M1'						--CODMAT
			   ,ED.TF_Entrada				--FECENT
			   ,GETDATE()					--FECULTACT
			   ,ED.TC_CodContexto			--CODDEJ
			   ,CT.TC_CodMateria			--CODJURIS
			   ,NULL						--CODPRO
			   ,NULL						--CODJUDEC
			   ,NULL						--CODJUTRA
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(D.TC_CodContextoOrigen,'Fase', EF.TN_CodFase,0,0)--CODFAS
			   ,EF.TF_Fase					--FECFASE
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(D.TC_CodContextoOrigen,'Estado', MC.TN_CodEstado,0,0)--CODESTASU
			   ,MC.TF_Fecha					--FECEST
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo',ED.TN_CodGrupoTrabajo,0,0)--CODGT
			   ,COALESCE(NULLIF(E.TC_Descripcion, ''), 'Sin Observaciones')	--DESCRIP
			   ,NULL						--CUANTIA
			   ,NULL						--CODCUANTIA
			   ,1							--PIEZA
			   ,NULL						--NUMFOL
			   ,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Prioridad',E.TN_CodPrioridad,0,0)--CODPRI
			   ,NULL						--IDACOUBI
			   ,NULL						--CODCLR
			   ,NULL						--TENGOACUM - 1 si es pap 
			   ,NULL						--CARPETAACUM - Carpeta de Pap 
			   ,'S'							--ES_FINEST - Si ya est  terminado
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
	FROM		Expediente.ResultadoRecurso				RR	WITH(NOLOCK)	
	INNER JOIN	Historico.Itineracion					D	WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion			=	RR.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle				ED	WITH(NOLOCK)
	ON			ED.TU_CodLegajo							=	RR.TU_CodLegajo
	AND			ED.TC_CodContexto						=	D.TC_CodContextoOrigen
	INNER JOIN	Expediente.Legajo						E	WITH(NOLOCK)
	ON			E.TU_CodLegajo							=	ED.TU_CodLegajo	
	INNER JOIN	Catalogo.Contexto						CT	WITH(NOLOCK)
	ON			CT.TC_CodContexto						=	ED.TC_CodContexto
	LEFT JOIN	Historico.LegajoMovimientoCirculante	MC WITH (NOLOCK)
	ON			MC.TU_CodLegajo							=	ED.TU_CodLegajo
	AND			MC.TF_Fecha								=	(	
																SELECT	MAX(TF_Fecha)
																FROM	Historico.LegajoMovimientoCirculante	WITH (NOLOCK)
																WHERE	TU_CodLegajo							= ED.TU_CodLegajo
															)
	LEFT JOIN	Historico.LegajoFase					EF	WITH (NOLOCK)
	ON			EF.TU_CodLegajo							=	ED.TU_CodLegajo
	AND			EF.TF_Fase								=	(	
																SELECT	MAX(TF_Fase)
																FROM	Historico.LegajoFase	WITH (NOLOCK)
																WHERE	TU_CodLegajo			= ED.TU_CodLegajo
															)
	LEFT JOIN	Historico.ItineracionRecursoResultado	IR	WITH (NOLOCK)
	ON			IR.TU_CodLegajo							=	E.TU_CodLegajo
	WHERE		D.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + N
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP WHERE IDACO IS NOT NULL;

	-- Se insertan las resoluciones si hay
	INSERT INTO @DACORES
				(CARPETA
				,IDACO
				,CODJURIS
				,CODRESUL
				,CODESTRES
				,FECEST
				,CODNUM
				,CODRES
				,VOTNUM
				,JUEZ
				,FECDIC
				,FECPUB
				,RECURRIDA
				,CODRESREC
				,SELECCIONADO
				,CODESTENV
				,CODPRESENT
				,IDUSU
				,HUBOJUICIO
				,USUREDAC
				,IDACOSENDOC
				,FECVOTO
				,ACOPORDOC
				,ENVIADO_SINALEVI
				,RESUMEN
				,FECVENCE
				,OBSER_DATSENSI)
	SELECT 
				D.CARPETA,								-- [CARPETA]
				(ROW_NUMBER() over (order by D.IDACO ASC) + @L_DacoInicial -1),-- [IDACO]
				C.TC_CodMateria,						-- [CODJURIS]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ResultadoResolucion',E.TN_CodResultadoResolucion,0,0),-- [CODRESUL]	
				@L_ValorDefectoCODESTRES,				-- [CODESTRES]
				E.TF_Fecharesolucion,					-- [FECEST]
				null,									-- [CODNUM]
				D.CODRES,								-- [CODRES]
				D.VOTNUM,								-- [VOTNUM]		
				null,									-- [JUEZ]
				E.TF_FechaCreacion,						-- [FECDIC]
				null,									-- [FECPUB]
				null,									-- [RECURRIDA]
				null,									-- [CODRESREC]
				E.TC_EstadoEnvioSAS,					-- [SELECCIONADO]
				null,									-- [CODESTENV]
				null,									-- [CODPRESENT]
				null,									-- *[IDUSU] corresponde al usuario que genero el documento que se le va a realizar el registro de resolucion
				null,									-- [HUBOJUICIO]	
				ISNULL(E.USUREDAC, F.TC_UsuarioRed),	-- [USUREDAC] se envía el campo USUREDAC si era una resolución itinerada desde Gestión, caso contrario se toma la del redactor responsable de SIAGPJ
				D.IDACO,								-- *[IDACOSENDOC] corresponde al IDACO del documento (daco)
				E.TF_FechaResolucion,					-- [FECVOTO]
				E.TC_PorTanto,							-- [ACOPORDOC]
				CASE
					WHEN E.TC_EstadoEnvioSAS = 'N' THEN 'N'
					WHEN E.TC_EstadoEnvioSAS = 'P' THEN 'P'
					WHEN E.TC_EstadoEnvioSAS = 'V' THEN 'E'
					ELSE 'A'
				END,									-- [ENVIADO_SINALEVI] Si en SIAGPJ esta marcado corresponde a 'P'(si es N=0 : 1)
				E.TC_Resumen,							-- [RESUMEN]
				null,									-- [FECVENCE]
				E.TC_DescripcionSensible				-- [OBSER_DATSENSI]
	FROM		@DOCTEMP							D	
	INNER JOIN	Expediente.Resolucion				E	WITH (NOLOCK)
	ON			E.TU_CodResolucion					=	D.TU_CodResolucion
	INNER JOIN	Catalogo.Contexto					C	WITH (NOLOCK)
	ON			C.TC_CodContexto					=	E.TC_CodContexto
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	F	WITH (NOLOCK)
	ON			F.TU_CodPuestoFuncionario			=	E.TU_RedactorResponsable
	WHERE		D.TU_CodResolucion					IS	NOT NULL  

	-- Debe ser un único registro
	INSERT INTO @DCARTD6 
				([CARPETA]
				,[CODDEJORI]
				,[CODREC]
				,[IDACOINT]
				,[CARPETAREC]
				,[IDACOREC]
				,[FECDEVOL]
				,[IDACORES]
				,[CODRES]
				,[IDACOREF]
				,[CODESTITI]
				,[FECESTITI]
				,[VOTNUM]
				,[CODPRESENT]
				,[ID_NAUTIUS]
				,[DESPJUDFP]
				,[FECHORRES])
	SELECT		 D.CARPETA					--CARPETA
				,D.DESPACHO_TRAMITE			--CODDEJORI
				,D.CODASU					--CODREC
				,D.IDACOINT					--IDACOINT		-- Expediente.Intervencion - IDINT Agrego ID del primer interviniente asociado al Legajo (GUID??)
				,D.CARPETAREC				--CARPETAREC
				,D.IDACOREC					--IDACOREC		-- Se obtiene de Historico.ItineracionRecursoResultado y corresponde al IDACO del Recurso recibido
				,D.FECDEVOL					--FECDEVOL		-- Fecha en momento que se genera el envío del registro de resultado hacia Gestión
				,R.IDACO					--IDACORES		-- IDACO de @DACORES (Primera resolución si la hay, sino va NULL)
				,D.CODRES					--CODRES		-- Catalogo.TipoResolucion (Solo si hay resolución, sino va NULL)
				,D.IDACO					--IDACOREF		-- IDACO de primer documento ojal  de resolución
				,D.CODESTITI				--CODESTITI
				,D.FECESTITI				--FECESTITI
				,D.VOTNUM					--VOTNUM		-- Agregar el voto de la resolución si la tengo, sino NULL - Libro sentencia
				,D.CODPRESENT				--CODPRESENT	-- Tipo de intervención (CODINT) del primer Interviniente asociado al Legajo
				,D.ID_NAUTIUS				--ID_NAUTIUS
				,NULL						--DESPJUDFP
				,NULL						--FECHORRES
	FROM		@DOCTEMP				D
	LEFT JOIN	@DACORES				R
	ON			R.IDACOSENDOC			=	D.IDACO
	WHERE		D.IDACO = (
					SELECT	TOP 1 IDACO
					FROM	@DOCTEMP
					ORDER BY CASE WHEN TU_CodResolucion IS NULL THEN 1 ELSE 0 END ASC, IDACO ASC -- Trae de primero el registro con TU_CodResolucion no NULO, sino el primer IDACO ordenado ascendentemente
				)

	-- INSERTAMOS EN DACO Todos los documentos  
	INSERT INTO @DACO
			   ([CARPETA]
			   ,[IDACO]
			   ,[CODDEJ]
			   ,[FECHA]
			   ,[TEXTO]
			   ,[CODACO]
			   ,[NUMACO]
			   ,[FECSYS]
			   ,[IDUSU]
			   ,[CODDEJUSR]
			   ,[CODESTACO]
			   ,[FECEST]
			   ,[NUMFOL]
			   ,[NUMFOLINI]
			   ,[PIEZA]
			   ,[CODPRO]
			   ,[CODJUDEC]
			   ,[CODJUTRA]
			   ,[CODTRAM]
			   ,[CODESTADIST]
			   ,[CODTIDEJ]
			   ,[IDACOREL]
			   ,[CODREL]
			   ,[PRIORI]
			   ,[CODICO]
			   ,[AMPLIAR]
			   ,[CANT]
			   ,[CODGT]
			   ,[CODESC]
			   ,[FECENTRDD]
			   ,[CODTIPDOC]
			   ,[OTRGEST]			   
			   ,[IDENTREGA]
			   ,[FINALIZAEXP])
	SELECT 
				 D.CARPETA																				--	CARPETA
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

	UNION

	-- DACO de Resoluciones
	SELECT 
				 DR.CARPETA																				--	CARPETA
				,DR.IDACO																				--	IDACO
				,R.TC_CodContexto																		--	CODDEJ
				,COALESCE(DR.FECEST, GETDATE())															--  FECHA
				,R.TC_Resumen																			--  TEXTO
				,'RTS'																					--  CODACO
				,NULL																					--  NUMACO**
				,COALESCE(DR.FECEST, GETDATE())															--  FECSYS
				,COALESCE(DR.USUREDAC, D.USUARIO_LOGIN)													--  IDUSU  si el usuario de casualidad no viene ni del campo USUREDAC ni del redactor responsable, se asigna el del usuario que crea el archivo de la resolución
				,R.TC_CodContexto																		--  CODDEJUSR
				,5																						--	CODESTACO
				,COALESCE(DR.FECEST, GETDATE())															--	FECEST
				,NULL																					--	NUMFOL
				,NULL																					--	NUMFOLINI
				,NULL																					--	PIEZA
				,''																						--	CODPRO
				,NULL																					--	CODJUDEC
				,NULL																					--	CODJUTRA
				,'REG_RESO'																				--	CODTRAM 'CODIGO DEL DOCUMENTO(REG_RESO)'	
				,NULL																					--	CODESTADIST
				,C.CODTIDEJ																				--	CODTIDEJ
				,NULL																					--	IDACOREL
				,NULL																					--	CODREL
				,0																						--	PRIORI
				,NULL																					--	CODICO
				,'3;'																					--	AMPLIAR
				,NULL																					--	CANT
				,NULL																					--	CODGT
				,NULL																					--	CODESC
				,NULL																					--	FECENTRDD
				,NULL																					--	CODTIPDOC
				,0																						--	OTRGEST			   
				,NULL																					--	IDENTREGA
				,NULL																					--	FINALIZAEXP
	FROM		@DACORES				DR
	INNER JOIN	@DOCTEMP				D
	ON			D.IDACO					=	DR.IDACOSENDOC
	INNER JOIN	Expediente.Resolucion	R	WITH(NOLOCK)
	ON			R.TU_CodResolucion		=	D.TU_CodResolucion
	INNER JOIN	Catalogo.Contexto		C	WITH(NOLOCK)
	ON			R.TC_CodContexto		= C.TC_CodContexto;

	-- INSERTAMOS EN DACO Todos los documentos 
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

	-- Solo debe haber 1 registro de @PATH
	INSERT INTO @DPATH 
			([IDPATH]
			,[PATH])
	SELECT	 1		-- IDPATH
			,CONCAT( 
				@L_ValorDefectoRutaDescargaDocumentosFTP,
				CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
					ELSE '/'
				END
			   ,Convert(Varchar(36),@L_CodHistoricoItineracion)
			 )		-- PATH
	FROM	@DOCTEMP D;

	INSERT INTO @tblArchivos
			   ([id]
			   ,[idaco]
			   ,[tipo]
			   ,[nombre]
			   ,[idruta]
			   ,[ruta]
			   ,[comprimido]
			   ,[adjunto]
			   ,[coddej]
			   ,[ubicacion]
			   ,[error]
			   ,[errordesc]
			   ,[tamanio]
			   ,[TU_CodArchivo])
	SELECT
			    D.IDACO			--id
			   ,D.IDACO			--idaco
			   ,0				--tipo
			   ,D.NOMBRE		--nombre
			   ,D.IDACO			--idruta
			   ,CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
			   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
					ELSE '/'
			   END
			   ,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',D.NOMBRE)	--ruta
			   ,0				--comprimido
			   ,0				--adjunto
			   ,COALESCE(@L_CodContextoOrigen, '') --coddej
			   ,4				--ubicacion
			   ,0				--error
			   ,NULL			--errordesc
			   ,0				--tamanio
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP		D;

	--**************************************************************************************************************************************
	--CONSULTAS FINALES
	--**************************************************************************************************************************************	
	
	SELECT * FROM @DCAR;

	SELECT * FROM @DCARTD6;

	SELECT * FROM @DACO;

	SELECT * FROM @DACORES;

	SELECT * FROM @DACODOC;

	SELECT * FROM @DPATH;
	
	SELECT * FROM @tblArchivos;
END
GO
