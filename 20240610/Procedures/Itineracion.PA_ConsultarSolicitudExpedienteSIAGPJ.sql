SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Richard Zúñiga Segura>
-- Fecha de creación:	<03/03/2021>
-- Descripción :		<Permite consultar los registros de SolicitudExpediente para crear el XML de EnvioSolicitud para Gestion>
-- ==================================================================================================================================================================================
-- Modificado:			<04/03/2021><Richard Zúñiga Segura><Se modifica la consulta de la tabla DINT>
-- Modificado:			<04/03/2021><Richard Zúñiga Segura><Se agrega la tabla DACODOC y se deshabilita el retorno de DACODOCR. Se corrige el CODTRAM para del DACO del archivo>
-- Modificado:			<04/03/2021><Richard Zúñiga Segura><Se agrega la configuración para agregar idaco en IDACOSOL de la tabla Expediente.SolicitudExpediente>
-- Modificado:			<05/03/2021><Richard Zúñiga Segura><Se agrega validación para revisar si la Solicitud ya posee un IDACOSOL>
-- Modificado:			<05/03/2021><Richard Zúñiga Segura><Se agrega la consulta de la ruta FTP y se retorna DPATH>
-- Modificado:			<05/03/2021><Richard Zúñiga Segura><Se cambia el uso del campo IDACOSOL por IDACO de la tabla Expediente.SolicitudExpediente para registrar el IDACO de la solicitud>
-- Modificación:		<19/03/2021><Karol Jiménez S.> <Se ajusta valor caso relevante a S-N>
-- Modificado:			<06/04/2021><Karol Jiménez S nchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificacion:		<24/06/2021><Jose Gabriel Cordero Soto> <Se ajusta para contemplar distincion por solicitud a itinerar en consultas y se incorpora el mapeo hacia DINTENT>
-- Modificación:		<25/06/2021><Luis Alonso Leiva Tames><Se agrega el lugar de trabajo en los intervientes>
-- Modificación:		<07/07/2021><Jose Gabriel Cordero Soto><Se ajusta seccion de DDOM y DINT para incorporar IDDOMI, IDDOMINOT y IDDOMINOTACC en DINT>
-- Modificado:			<08/07/2021><Jose Gabriel Cordero Soto><Se realiza ajuste en la asignacion del estado de documento al itinerar hacia gestión>
-- Modificación:		<11/08/2021> <Jose Gabriel Cordero Soto><Se realiza ajuste en consultas de DINT, DINTPER y DINTENT por falta de filtrado por expediente en consulta>
-- Modificación:        <16/08/2021> <Jose Gabriel Cordero Soto><Se realiza ajuste en procedimiento par actualizar ESDISCAPAC en DINTPER>
-- Modificación:		<01/10/2021> <Karol Jiménez S nchez> <Se aplica cambio para obtención de equivalencias cat logo Estados desde módulo de equivalencias>
-- Modificación:        <30/11/2021> <Luis Alonso Leiva Tames><Se envia la tabla DCARMASD para obtener el delito>
-- Modificado:			<07/10/2022> <Josué Quirós Batista><Se especifica el código del despacho origen de la itineración a la tabla tblArchivos.>
-- Modificación:		<10/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos ClaseAsunto, EstadoItineracion, 
--						Clase, Proceso, Fase, GrupoTrabajo, TipoCuantia, Prioridad, SituacionLaboral, Parentesco, TipoIntervencion, TipoMedioComunicacion, TipoIdentificacion, EstadoCivil,
--						Etnia, Profesion, Escolaridad, TipoRepresentacion, Provincia, Delito y TipoLicencia)>
-- Modificación:		<20/03/2024><Yesenia Araya Sánchez.><Incidente PBI: 377532 En la línea 798, la tabla @DINTPER se trunca el campo NUMLIC para que solo acepte 20 caracteres>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarSolicitudExpedienteSIAGPJ]	
	@CodHistoricoItineracion					Uniqueidentifier
AS
BEGIN

	--VARIABLES LOCALES
	DECLARE	@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,		
			@L_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_CodContextoOrigen						VARCHAR(4)			= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL,
			@L_NumeroExpediente							VARCHAR(14),				
			@L_UsuarioRed								VARCHAR(30),
			@L_ValorDefectoTipoRepresentacion			VARCHAR(3)			= NULL,
			@L_ValorDefectoTipoIntervencionRep			VARCHAR(3)			= NULL,
			@L_ValorDefectoSexo							VARCHAR(3)			= NULL,
			@L_EstadoTerminado							TINYINT				= 4,
			@L_Idaco									INT,
			@L_Path										VARCHAR(255)		= NULL, 
			@COLDAT										VARCHAR(2)

	--OBTIENE EL USUARIO DEL HISTORICO DE ITINERACION
	SELECT @L_UsuarioRed				=	A.TC_UsuarioRed
	FROM   Historico.Itineracion		A	WITH(NOLOCK)
	WHERE  A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion

	--SE OBTIUENE EL NÚMERO DE EXPEDIENTE Y CÓDIGO DE LEGAJO SI EL HISTÓRICO ESTÁ RELACIONADO A UN LEGAJO
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_CodContextoOrigen	= TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--OBTIENE EL NÚMERO MÁXIMO IDACOSOL RELACIONADO AL EXPEDIENTE
	SELECT @L_Idaco		=	ISNULL((SELECT	IDACO 
									FROM	Expediente.SolicitudExpediente	WITH(NOLOCK)
									WHERE	TU_CodHistoricoItineracion		=	@L_CodHistoricoItineracion),
									ISNULL((SELECT	MAX(IDACO)+1  
											FROM	Expediente.SolicitudExpediente	WITH(NOLOCK)
											WHERE	TC_NumeroExpediente				=	@L_NumeroExpediente),1))

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoTipoRepresentacion	= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_TipoRepresentacion','');
	SELECT	@L_ValorDefectoTipoIntervencionRep	= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_TipoIntervencionRep','');
	SELECT	@L_ValorDefectoSexo					= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_Sexo','');
	SELECT	@L_Path								= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');

	SELECT		@COLDAT		=	CASE 
									C.TC_CodMateria WHEN 'PJ' THEN 'F2' 
									ELSE 'F1' 
								END
	FROM		Expediente.ExpedienteDetalle	ED	WITH(NOLOCK)
	INNER JOIN	Catalogo.Contexto				C	WITH(NOLOCK)
	ON			C.TC_CodContexto				=	ED.TC_CodContexto
	WHERE		ED.TC_NumeroExpediente			=	@L_NumeroExpediente
	AND			ED.TC_CodContexto				=	@L_CodContextoOrigen

	Declare @Intervinientes As Table (
		TU_CodInterviniente			VARCHAR(36)		NOT NULL,
		IDINT						BIGINT			NULL);

	--Definición de tabla DACOSOL
	DECLARE @DACOSOL AS TABLE(
			CARPETA				[varchar](14)		NOT NULL,
			IDACO				[int] 				NOT NULL,
			CODDEJDES			[varchar](4)		NOT NULL,
			DESCRIP				[varchar](255)		NOT NULL,
			CODTIDEJ			[varchar](2)		NOT NULL,
			CODCLAS				[varchar](9)		NOT NULL,
			CODESTITI			[varchar](1)		NULL,
			FECESTITI			[datetime2](3)		NULL,
			CODDEJ				[varchar](4)		NULL,
			ID_NAUTIUS			[varchar](255)		NULL,
			CODRESUL			[varchar](9)		NULL,
			FECDEVOL			[datetime2](3)		NULL,
			CODPEN				[varchar](3)		NULL,
			IDACOSOL			[int]				NULL,
			IDUSUJUEZ			[varchar](25)		NULL);

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

	--Definición de tabla DACOINT
	DECLARE @DACOINT AS TABLE(
			[CARPETA]			[varchar](14)		NOT NULL,
			[IDACO]				[int]				NOT NULL,
			[IDINT]				[int]				NOT NULL);

	--Definición de tabla DINT
	Declare @DINT AS TABLE (
			[CARPETA]						VARCHAR(14)			NOT NULL,
			[IDINT]							INT					NOT NULL,
			[CODINT]						VARCHAR(3)			NOT NULL,
			[CODMEDCOM]						VARCHAR(1)			NULL,
			[IDDOMI]						INT					NULL,--SE LLENA EN MAPEO DE DOMICILIOS
			[IDDOMINOT]						INT					NULL,
			[CODSIT]						VARCHAR(9)			NULL,
			[FECSIT]						DATETIME2(3)		NULL,
			[CODECO]						VARCHAR(4)			NULL,
			[CODFIJU]						VARCHAR(1)			NOT NULL,
			[ALIAS]							VARCHAR(255)		NULL,
			[OBSERV]						VARCHAR(255)		NULL,
			[EDAD]							INT					NULL,
			[CODCATBEN]						VARCHAR(2)			NULL,
			[RECURRENTE]					BIT					NOT NULL,
			[LUGRESIDE]						VARCHAR(255)		NULL,
			[CODLAB]						VARCHAR(3)			NULL,
			[LUGTRAB]						VARCHAR(255)		NULL,
			[DIRLUGTRAB]					VARCHAR(255)		NULL,
			[CODMEDCOMACC]					VARCHAR(1)			NULL,
			[IDDOMINOTACC]					INT					NULL,
			[CODRELAC]						VARCHAR(9)			NULL,
			[DESISTE]						BIT					NOT NULL,
			[NOTIFICADO]					BIT					NOT NULL,
			[DESHABILITADA]					BIT					NOT NULL,
			[TU_CodMedioComunicacion]		UNIQUEIDENTIFIER	NULL,
			[TU_CodMedioComunicacionAcc]	UNIQUEIDENTIFIER	NULL,
			[TU_CodDomicilio]				UNIQUEIDENTIFIER	NULL);

	--Definición de tabla DHISFEP
	Declare @DINTPER AS TABLE (
			IDINT			INT				NOT NULL,
			NOMBRE			VARCHAR(50)		NOT NULL,
			APE1			VARCHAR(50)		NOT NULL,
			APE2			VARCHAR(50)		NULL,
			CODTIPIDE		VARCHAR(1)		NULL,
			NUMINT			VARCHAR(21)		NULL,
			CODPAIS			VARCHAR(5)		NULL,
			CODSEX			VARCHAR(1)		NOT NULL,
			FECNAC			DATETIME2(3)	NULL,
			LUGNAC			VARCHAR(50)		NULL,
			NOMRESP			VARCHAR(60)		NULL,
			NOMPAD			VARCHAR(60)		NULL,
			NOMMAD			VARCHAR(60)		NULL,
			CODESCIV		VARCHAR(1)		NULL,
			PROFES			VARCHAR(255)	NULL,
			FECDEF			DATETIME2(3)	NULL,
			LUGDEF			VARCHAR(50)		NULL,
			NUMLIC			VARCHAR(20)		NULL,
			FECEXPLIC		DATETIME2(3)	NULL,
			FECCADLIC		DATETIME2(3)	NULL,
			TIPLIC			VARCHAR(2)		NULL,
			REINCIDENTE		VARCHAR(1)		NULL,
			OBSERV			VARCHAR(255)	NULL,
			CODPROINT		VARCHAR(4)		NULL,
			REBELDE			VARCHAR(1)		NULL,
			CODETN			VARCHAR(2)		NULL,
			ESDISCAPAC		VARCHAR(1)		NULL,
			CODRESUL		VARCHAR(9)		NULL,
			FECACTUAL		DATETIME2(3)	NULL,
			FECRESOL		DATETIME2(3)	NULL,
			CODESCO			VARCHAR(2)		NULL,
			CODMONINT		VARCHAR(3)		NULL,
			TU_CodInterviniente		UNIQUEIDENTIFIER	NOT NULL);

	--Definicion de tabla DINTENT
	DECLARE	 @DINTENT AS TABLE 
	(
			IDINT					INT					NULL,
			NOMBRE					VARCHAR(100)		NULL,
			NOMCIAL					VARCHAR(100)		NULL,
			CODTIPIDE				VARCHAR(1)			NULL, 
			NUMINT					VARCHAR(21)			NULL,
			NOMRESP					VARCHAR(60)			NULL, 
			CARRESP					VARCHAR(15)			NULL,
			DESCRIP					VARCHAR(255)		NULL,
			TU_CodInterviniente		UNIQUEIDENTIFIER	NOT NULL
	);

	--Definicion de tabla DINTREP
	DECLARE @DINTREP As Table (
		CARPETA								VARCHAR(14)			NOT NULL,
		IDINT								INT					NOT NULL,
		IDINTREP							INT					NOT NULL,
		CODREP								VARCHAR(3)			NOT NULL,
		FECINI								DATETIME2(3)		NOT NULL,
		FECFIN								DATETIME2(3)		NULL,
		CODMEDCOM							VARCHAR(1)			NULL,
		CODMEDCOMACC						VARCHAR(1)			NULL,
		IDDOMI								INT					NULL,--SE LLENA EN MAPEO DE DOMICILIOS
		IDDOMINOT							INT					NULL,
		IDDOMINOTACC						INT					NULL,
		TU_CodMedioComunicacion				UNIQUEIDENTIFIER	NULL,
		TU_CodMedioComunicacionAcc			UNIQUEIDENTIFIER	NULL,
		TU_CodDomicilio						UNIQUEIDENTIFIER	NULL);

	--Definición de tabla DCOM
	Declare @DDOM AS TABLE (
			IDDOMI					INT					NOT NULL IDENTITY(1,1),
			CODCLADOM				VARCHAR(1)			NULL,
			CLAVDOM					INT					NULL,
			NOMVIA					VARCHAR(255)		NULL,
			CODBARRIO				VARCHAR(3)			NULL,
			CODDISTRITO				VARCHAR(3)			NULL,
			CODCANTON				VARCHAR(3)			NULL,
			CODPROV					VARCHAR(3)			NULL,
			APAPOS					VARCHAR(10)			NULL,
			BANCO					VARCHAR(50)			NULL,
			CUENTA					VARCHAR(255)		NULL,
			TELEFONO				VARCHAR(50)			NULL,
			FAX						VARCHAR(25)			NULL,
			EMAIL					VARCHAR(255)		NULL,
			OTROS					VARCHAR(255)		NULL,
			TELEFONOCEL				VARCHAR(50)			NULL,
			MENSCELULAR				VARCHAR(1)			NULL,
			CODAUTORIDAD			VARCHAR(5)			NULL,
			TU_CodMedioComunicacion UNIQUEIDENTIFIER	NULL,
			TU_CodDomicilio			UNIQUEIDENTIFIER	NULL
			);

	--Definición de tabla DPATH
	DECLARE	@DPATH AS TABLE (
			[IDPATH]					[INT]					NOT NULL,
			[PATH]						[VARCHAR](255)			NULL		
	);

	--Definición de tabla temporal de documentos
	DECLARE @DOCTEMP AS TABLE (
			[TU_CodArchivo]			UNIQUEIDENTIFIER	NOT NULL,-- Llaves de documentos SIAGPJ
			[CARPETA]				[varchar](14)		NOT NULL,
			[DESPACHO_TRAMITE]		[varchar](4)		NULL,
			[TDET_DESPACHO_TIPO]	[varchar](4)		NULL,
			[CODPLAZA_TRAMITE]		[varchar](9)		NULL,
			[USUARIO_LOGIN]			[varchar](50)		NOT NULL,
			[TDOT_TIPO_DOCUMENTO]	[varchar](9)		NULL,
			[DESCRIPCION]			[varchar](255)		NULL,
			[FECHA]					[datetime2](3)		NULL,
			[NOMBRE]				[varchar](255)		NOT NULL,
			[NOMBRE_GUID]			[varchar](255)		NULL,
			[IDPATH]				[varchar](255)		NOT NULL,
			[CODGT]					[varchar](9)		NULL,
			[NOTIFICA]				[bit]				NOT NULL,
			[TF_Particion]			[datetime2](3)		NOT NULL,
			[IDACO]					[int]				NOT NULL,
			[CODESTACO]				[varchar](1)		NULL)

		--Definición de tabla DACO
	DECLARE @DACO AS TABLE (
			[CARPETA]			[varchar](14)		NOT NULL,
			[IDACO]				[int]				NOT NULL,
			[CODDEJ]			[varchar](4)		NOT NULL,
			[FECHA]				[datetime2](3)		NOT NULL,
			[TEXTO]				[varchar](255)		NULL,
			[CODACO]			[varchar](9)		NOT NULL,
			[NUMACO]			[varchar](10)		NULL,
			[FECSYS]			[datetime2](3)		NOT NULL,
			[IDUSU]				[varchar](25)		NOT NULL,
			[CODDEJUSR]			[varchar](4)		NOT NULL,
			[CODESTACO]			[varchar](1)		NULL,
			[FECEST]			[datetime2](3)		NULL,
			[NUMFOL]			[int]				NULL,
			[NUMFOLINI]			[int]				NULL,
			[PIEZA]				[int]				NULL,
			[CODPRO]			[varchar](5)		NULL,
			[CODJUDEC]			[varchar](11)		NULL,
			[CODJUTRA]			[varchar](11)		NULL,
			[CODTRAM]			[varchar](12)		NULL,
			[CODESTADIST]		[varchar](5)		NULL,
			[CODTIDEJ]			[varchar](2)		NOT NULL,
			[IDACOREL]			[int]				NULL,
			[CODREL]			[varchar](3)		NULL,
			[PRIORI]			[int]				NULL,
			[CODICO]			[varchar](9)		NULL,
			[AMPLIAR]			[varchar](100)		NULL,
			[CANT]				[int]				NULL,
			[CODGT]				[varchar](9)		NULL,
			[CODESC]			[varchar](11)		NULL,
			[FECENTRDD]			[datetime2](3)		NULL,
			[CODTIPDOC]			[varchar](12)		NULL,
			[OTRGEST]			[bit]				NOT NULL,			   
			[IDENTREGA]			[varchar](20)		NULL,	
			[FINALIZAEXP]		[varchar](2)		NULL)

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
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ

	--Definición de tabla DACODOCR
	DECLARE @DACODOCR AS TABLE(
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NULL,
			[IDDOC]			[int]				NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[USURECEPTOR]	[varchar](50)		NULL,
			[IDPATH]		[varchar](255)		NULL,
			[DESCRIP]		[varchar](255)		NULL,
			[PUBLICADO]		[bit]				NULL,
			[ESELECTRONICO] [int]				NULL,
			[FIRMADIGITAL]	[char](1)			NULL,
			[USU_ENTREGA]	[varchar](130)		NULL,
			[TRAMITADO]		[char](4)			NULL,
			[USERLEIDO]		[varchar](20)		NULL,
			[FECLEIDO]		[datetime]			NULL,
			[RESERVADO]		[bit]				NOT NULL,
			[PARACESIONMASIVA] [bit]			NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ

	--Definición de tabla tblArchivos
	DECLARE @tblArchivos AS TABLE (
			[id]				[int]				NOT NULL,
			[idaco]				[int]				NOT NULL,
			[tipo]				[int]				NOT NULL,
			[nombre]			[varchar](255)		NOT NULL,
			[idruta]			[int]				NOT NULL,
			[ruta]				[varchar](255)		NOT NULL,
			[comprimido]		[bit]				NOT NULL,
			[adjunto]			[bit]				NOT NULL,
			[coddej]			[varchar](4)		NOT NULL,
			[ubicacion]			[int]				NOT NULL,
			[error]				[bit]				NULL,
			[errordesc]			[varchar](255)		NULL,
			[tamanio]			[int]				NOT NULL,
			[TU_CodArchivo]		UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ


	--Definición de tabla DCARMASD
	DECLARE @DCARMASD AS TABLE(
			[CARPETA] 			[varchar](14) 		NOT NULL,
			[CODMASD] 			[varchar](9) 		NOT NULL,
			[COLDAT] 			[varchar](2) 		NOT NULL,
			[IDATR] 			[int] 				NOT NULL,
			[VALOR] 			[varchar](255) 		NULL);

	--INSERCIÓN EN DACOSOL
	INSERT INTO @DACOSOL
				([CARPETA]
				,[IDACO]
				,[CODDEJDES]
				,[DESCRIP]
				,[CODTIDEJ]
				,[CODCLAS]
				,[CODESTITI]
				,[FECESTITI]
				,[CODDEJ]
				,[ID_NAUTIUS]
				,[CODRESUL]	
				,[FECDEVOL]
				,[CODPEN]
				,[IDACOSOL]
				,[IDUSUJUEZ])
	SELECT		@L_Carpeta,						-- [CARPETA]
				@L_Idaco,						-- [IDACO]   
				A.TC_CodContextoDestino,		-- [CODEJDES]
				A.TC_Descripcion,				-- [DESCRIP]
				E.CODTIDEJ,						-- [CODTIDEJ]  
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ClaseAsunto', A.TN_CodClaseAsunto,0,0),-- [CODCLAS]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'EstadoItineracion', A.TN_CodEstadoItineracion,0,0),-- [CODESTITI]
				A.TF_FechaEnvio	,				-- [FECESTITI]
				A.TC_CodContextoOrigen,			-- [CODDEJ]
				A.TU_CodHistoricoItineracion,	-- [ID_NAUTIUS]
				NULL,							-- [CODRESUL]
				NULL,							-- [FECDEVOL]
				NULL,							-- [CODPEN]
				NULL,							-- [IDACOSOL]   
				NULL							-- [IDUSUJUEZ]	 
	FROM 		Expediente.SolicitudExpediente  A
	INNER JOIN	Catalogo.Contexto				E	WITH (NOLOCK)
	ON			E.TC_CodContexto				=	A.TC_CodContextoDestino
	WHERE		A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion

	--INSERCIÓN EN DACO
	INSERT INTO @DACO
				([CARPETA],	
				 [IDACO],		
				 [CODDEJ],	
				 [FECHA],		
				 [TEXTO],		
				 [CODACO],	
				 [NUMACO],	
				 [FECSYS],	
				 [IDUSU],		
				 [CODDEJUSR],	
				 [CODESTACO],	
				 [FECEST],	
				 [NUMFOL],	
				 [NUMFOLINI],	
				 [PIEZA],	
				 [CODPRO],	
				 [CODJUDEC],	
				 [CODJUTRA],
				 [CODTRAM],	
				 [CODESTADIST],
				 [CODTIDEJ],	
				 [IDACOREL],
				 [CODREL],	
				 [PRIORI],	
				 [CODICO],	
				 [AMPLIAR],	
				 [CANT],		
				 [CODGT],		
				 [CODESC],	
				 [FECENTRDD],	
				 [CODTIPDOC],	
				 [OTRGEST],	
				 [IDENTREGA],	
				 [FINALIZAEXP])
	SELECT		@L_Carpeta,						-- [CARPETA]	
				IDACO,							-- [IDACO]	
				CODDEJ,							-- [CODDEJ]		
				GETDATE(),						-- [FECHA]		
				'Interponer solicitud',			-- [TEXTO]	
				'SOL',							-- [CODACO]	
				IDACO,							-- [NUMACO]	
				GETDATE(),						-- [FECSYS]		
				@L_UsuarioRed,					-- [IDUSU]	
				CODDEJ,							-- [CODDEJUSO]	
				'5',							-- [CODESTAC
				GETDATE(),						-- [FECEST]	
				NULL,							-- [NUMFOL]
				NULL,							-- [NUMFOLIN	
				NULL,							-- [PIEZA]	
				'',								-- [CODPRO]	
				NULL,							-- [CODJUDEC]	
				NULL,							-- [CODJUTRA	
				'INTER_SOL',					-- [CODTRAM]
				NULL,							-- [CODESTAD]	
				CODTIDEJ,						-- [CODTIDEJ]	
				NULL,							-- [IDACOREL
				NULL,							-- [CODREL]	
				0,								-- [PRIORI]	
				NULL,							-- [CODICO]		
				'7;',							-- [AMPLIAR]	
				NULL,							-- [CANT]		
				NULL,							-- [CODGT]	
				NULL,							-- [CODESC]	
				NULL,							-- [FECENTRDC]	
				NULL,							-- [CODTIPDO	
				0,								-- [OTRGEST]	
				NULL,							-- [IDENTREGEXP]
				NULL							-- [FINALIZA]
	FROM		@DACOSOL

	--INSERCIÓN EN DCAR						
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
				@L_Carpeta														-- [CARPETA]
				,ED.TC_NumeroExpediente											-- [NUE]
				,'PRI'															-- [CODASU]
				,COALESCE(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Clase', ED.TN_CodClase,0,0), '')-- [CODCLAS]
				,'M1'															-- [CODMAT]
				,ED.TF_Entrada													-- [FECENT]
				,GETDATE()														-- [FECULTACT]
				,ED.TC_CodContexto												-- [CODDEJ]
				,CT.TC_CodMateria												-- [CODJURIS]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Proceso', ED.TN_CodProceso,0,0)-- [CODPRO]
				,NULL															-- [CODJUDEC]
				,NULL															-- [CODJUTRA]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Fase', ED.TN_CodFase,0,0)-- [CODFAS]
				,EF.TF_Fase														-- [FECFASE]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Estado', MC.TN_CodEstado,0,0)--CODESTASU
				,MC.TF_Fecha													-- [FECEST]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', ED.TN_CodGrupoTrabajo,0,0)-- [CODGT]
				,COALESCE(NULLIF(E.TC_Descripcion, ''), 'Sin Observaciones')	-- [DESCRIP]
				,E.TN_MontoCuantia												-- [CUANTIA]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoCuantia', E.TN_CodTipoCuantia,0,0)-- [CODCUANTIA]
				,1																-- [PIEZA]
				,NULL															-- [NUMFOL]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Prioridad', E.TN_CodPrioridad,0,0)-- [CODPRI]
				,NULL															-- [IDACOUBI]
				,NULL															-- [CODCLR]
				,CASE 
					WHEN EXISTS (
							SELECT	Historico.ExpedienteAcumulacion.TU_CodAcumulacion
							FROM	Historico.ExpedienteAcumulacion WITH (NOLOCK)
							WHERE	TC_NumeroExpedienteAcumula	=	ED.TC_NumeroExpediente
							AND		TF_FinAcumulacion			IS NULL
						) THEN 1
					ELSE NULL
				END							--TENGOACUM - 1 si es pap  
				,(
					SELECT	CARPETA
					FROM	Expediente.Expediente WITH (NOLOCK)
					WHERE	TC_NumeroExpediente = EA.TC_NumeroExpedienteAcumula
				)							--CARPETAACUM - Carpeta de Pap 
				,'S'						--ES_FINEST - Si ya está terminado
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
				,CASE 
					WHEN E.TB_CasoRelevante = 1 
						THEN 'S' 
					ELSE 'N'	
				END							--CASORELEVANTE
	FROM		Expediente.ExpedienteDetalle	ED	WITH (NOLOCK)
	INNER JOIN	Expediente.Expediente			E	WITH (NOLOCK)
	ON			E.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto				CT	WITH (NOLOCK)
	ON			CT.TC_CodContexto				=	ED.TC_CodContexto
	LEFT JOIN	Historico.ExpedienteMovimientoCirculante MC WITH (NOLOCK)
	ON			MC.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			MC.TF_Fecha						=	(	
														SELECT	MAX(TF_Fecha)
														FROM	Historico.ExpedienteMovimientoCirculante	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente							= ED.TC_NumeroExpediente
													)
	LEFT JOIN	Historico.ExpedienteFase		EF	WITH (NOLOCK)
	ON			EF.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			EF.TF_Fase						=	(	
														SELECT	MAX(TF_Fase)
														FROM	Historico.ExpedienteFase	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente			= ED.TC_NumeroExpediente
													)

	LEFT JOIN	Historico.ExpedienteAcumulacion	EA	WITH (NOLOCK)
	ON			EA.TC_NumeroExpediente			=	ED.TC_NumeroExpediente
	AND			EA.TC_CodContexto				=	ED.TC_CodContexto
	AND			EA.TF_InicioAcumulacion			=	(
														SELECT	MAX(TF_InicioAcumulacion)
														FROM	Historico.ExpedienteAcumulacion	WITH (NOLOCK)
														WHERE	TC_NumeroExpediente				= ED.TC_NumeroExpediente
														AND		TF_FinAcumulacion				IS NULL
													)					
	WHERE		ED.TC_NumeroExpediente			=	@L_NumeroExpediente
	AND			ED.TC_CodContexto				=	@L_CodContextoOrigen;
	
	--INSERCIÓN EN DACOINT
	INSERT INTO @DACOINT
				(CARPETA,			
				IDACO,				
				IDINT)				
	SELECT		@L_Carpeta,							-- [CARPETA]
				@L_Idaco,							-- [IDACO]	
				D.IDINT								-- [IDINT]	
	FROM		Expediente.SolicitudExpediente		A	WITH(NOLOCK)
	INNER JOIN	Expediente.IntervencionSolicitud	B	WITH(NOLOCK)
	ON			A.TU_CodSolicitudExpediente			=	B.TU_CodSolicitudExpediente
	INNER JOIN	Expediente.Intervencion				D	WITH(NOLOCK)
	ON			B.TU_CodInterviniente				=	D.TU_CodInterviniente
	WHERE		a.TU_CodHistoricoItineracion		=	@L_CodHistoricoItineracion

	INSERT INTO @Intervinientes  
	SELECT		D.TU_CodInterviniente,
				D.IDINT
	FROM		Expediente.SolicitudExpediente		A	WITH(NOLOCK)
	INNER JOIN	Expediente.IntervencionSolicitud	B	WITH(NOLOCK)
	ON			A.TU_CodSolicitudExpediente			=	B.TU_CodSolicitudExpediente
	INNER JOIN	Expediente.Intervencion				D	WITH(NOLOCK)
	ON			B.TU_CodInterviniente				=	D.TU_CodInterviniente
	WHERE		a.TU_CodHistoricoItineracion		=	@L_CodHistoricoItineracion
			
	--INSERCIÓN EN DINT
	INSERT INTO @DINT
				([CARPETA],
				[IDINT],			
				[CODINT],
				[CODMEDCOM], 
				[CODFIJU],					
				[EDAD],			
				[RECURRENTE],					
				[DESISTE],	
				[NOTIFICADO], 				
				[DESHABILITADA],	
				[ALIAS],						
				[CODLAB],	
				[CODMEDCOMACC],				
				[CODRELAC],		
				[TU_CodMedioComunicacion],	
				[TU_CodMedioComunicacionAcc],
				[TU_CodDomicilio], 			
				[LUGTRAB])
	SELECT		@L_Carpeta,																-- [CARPETA]
				A.IDINT,																-- [IDINT]
				ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIntervencion', E.TN_CodTipoIntervencion,0,0), @L_ValorDefectoTipoIntervencionRep),-- [CODINT]
				K.CODMEDCOM,															-- [CODMEDCOM]
				C.TC_CodTipoPersona,													-- [CODFIJU]
				CASE WHEN C.TC_CodTipoPersona = 'F' THEN								
					CAST(DATEDIFF(DAY,D.TF_FechaNacimiento,GETDATE())/365.25 AS INT)	
					ELSE NULL															
				END,																	-- [EDAD]
				0,																		-- [RECURRENTE]
				0,																		-- [DESISTE]
				0,																		-- [NOTIFICADO]
				0,																		-- [DESHABILITADA]
				E.TC_Alias,																-- [ALIAS]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'SituacionLaboral', E.TN_CodSituacionLaboral,0,0),-- [CODLAB]
				L.CODMEDCOM,															-- [CODMEDCOMACC]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Parentesco', E.TU_CodParentesco,0,0),-- [CODRELAC]
				K.TU_CodMedioComunicacion,												-- [TU_CodMedioComunicacion]
				L.TU_CodMedioComunicacion,												-- [TU_CodMedioComunicacionAcc]
				M.TU_CodDomicilio,														-- [TU_CodDomiciliO]
				E.TC_LugarTrabajo														-- [LUGTRAB]
	FROM		@DACOINT					A
	INNER JOIN	Expediente.Intervencion		B WITH(NOLOCK)
	ON			B.IDINT						= A.IDINT
	AND			B.TC_NumeroExpediente		= @L_NumeroExpediente
	INNER JOIN	Persona.Persona				C WITH(NOLOCK)
	ON			C.TU_CodPersona				= B.TU_CodPersona
	LEFT JOIN	Persona.PersonaFisica		D WITH(NOLOCK)
	ON			D.TU_CodPersona				= C.TU_CodPersona
	LEFT JOIN	Expediente.Interviniente	E WITH(NOLOCK)
	ON			E.TU_CodInterviniente		= B.TU_CodInterviniente
	OUTER APPLY	(
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoMedioComunicacion', I.TN_CodMedio,0,0) CODMEDCOM,	
							I.TU_CodMedioComunicacion
				FROM		Expediente.IntervencionMedioComunicacion	I WITH(NOLOCK)
				WHERE		I.TU_CodInterviniente						= B.TU_CodInterviniente
				AND			I.TN_PrioridadExpediente					= 1
				)  K
	OUTER APPLY	(
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoMedioComunicacion', I.TN_CodMedio,0,0) CODMEDCOM,	
							I.TU_CodMedioComunicacion
				FROM		Expediente.IntervencionMedioComunicacion	I WITH(NOLOCK)
				WHERE		I.TU_CodInterviniente						= B.TU_CodInterviniente
				AND			I.TN_PrioridadExpediente					= 2
				)  L
	OUTER APPLY	(
				SELECT		TOP 1 I.TU_CodDomicilio
				FROM		Expediente.IntervinienteDomicilio	I WITH(NOLOCK)
				INNER JOIN	Persona.Domicilio					J WITH(NOLOCK)
				On			J.TU_CodDomicilio					= I.TU_CodDomicilio
				WHERE		I.TU_CodInterviniente				= B.TU_CodInterviniente
				AND			J.TB_DomicilioHabitual				= 1
				ORDER BY	J.TF_Actualizacion	DESC
				)M

	--INSERCIÓN EN DINTPER
	INSERT INTO @DINTPER
				([IDINT],				
				[NOMBRE],
				[APE1],
				[APE2],
				[CODTIPIDE],
				[NUMINT],
				[CODSEX],
				[FECNAC],
				[LUGNAC],
				[NOMPAD], 
				[NOMMAD],
				[PROFES],
				[CODESCIV],
				[FECDEF],
				[LUGDEF],
				[FECEXPLIC],
				[FECCADLIC],
				[NUMLIC],
				[TIPLIC],
				[CODETN],
				[CODPAIS],
				[OBSERV],
				[CODPROINT],
				[REBELDE],
				[CODESCO],
				[TU_CodInterviniente])
	SELECT		A.IDINT,												-- [IDINT]
				D.TC_Nombre,											-- [NOMBRE]
				D.TC_PrimerApellido,									-- [APE1]
				D.TC_SegundoApellido,									-- [APE2]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIdentificacion', C.TN_CodTipoIdentificacion,0,0),-- [CODTIPIDE]
				C.TC_Identificacion,									-- [NUMINT]
				ISNULL(D.TC_CodSexo,@L_ValorDefectoSexo),				-- [CODSEX]
				D.TF_FechaNacimiento,									-- [FECNAC]
				D.TC_LugarNacimiento,									-- [LUGNAC]
				SUBSTRING(D.TC_NombrePadre,0,60),						-- [NOMPAD] 
				SUBSTRING(D.TC_NombreMadre,0,60),						-- [NOMMAD]
				J.TC_Descripcion,										-- [PROFES]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'EstadoCivil', D.TN_CodEstadoCivil,0,0),-- [CODESCIV]
				D.TF_FechaDefuncion,									-- [FECDEF]
				D.TC_LugarDefuncion,									-- [LUGDEF]
				G.TF_Expedicion,										-- [FECEXPLIC]
				G.TF_Caducidad,											-- [FECCADLIC]
				LEFT(c.TC_Identificacion, 20),							-- [NUMLIC]
				G.TIPLIC,												-- [TIPLIC]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Etnia', D.TN_CodEtnia,0,0),-- [CODETN]
				I.TC_CodPais,											-- [CODPAIS]
				I.TC_Caracteristicas,									-- [OBSERV]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Profesion', I.TN_CodProfesion,0,0),-- [CODPROINT]
				CASE 
					WHEN I.TB_Rebeldia IS NULL THEN NULL
					WHEN I.TB_Rebeldia = 1 THEN 'S' 
					WHEN I.TB_Rebeldia = 0 THEN 'N' 
				END,													-- [REBELDE]
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Escolaridad', I.TN_CodEscolaridad,0,0),-- [CODESCO]
				B.TU_CodInterviniente									-- [TU_CodInterviniente]
	FROM		@DACOINT					A
	INNER JOIN	Expediente.Intervencion		B WITH(NOLOCK)
	ON			B.IDINT						= A.IDINT
	AND			B.TC_NumeroExpediente		= @L_NumeroExpediente
	INNER JOIN	Persona.Persona				C WITH(NOLOCK)
	ON			C.TU_CodPersona				= B.TU_CodPersona
	INNER JOIN	Persona.PersonaFisica		D WITH(NOLOCK)
	ON			D.TU_CodPersona				= C.TU_CodPersona
	OUTER APPLY	(
				SELECT		TOP 1 X.TF_Caducidad,	X.TF_Expedicion,
							Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoLicencia', X.TN_CodTipoLicencia,0,0) TIPLIC
				FROM		Persona.Licencia		X WITH(NOLOCK)
				WHERE		X.TU_CodPersona			= B.TU_CodPersona
				AND			X.TF_Caducidad			>= GETDATE()
				ORDER BY	TF_Expedicion
				) G
	LEFT JOIN	Expediente.Interviniente	I WITH(NOLOCK)
	ON			I.TU_CodInterviniente		= B.TU_CodInterviniente
	LEFT JOIN	Catalogo.Profesion			J WITH(NOLOCK)
	ON			J.TN_CodProfesion			= I.TN_CodProfesion

	--ACTUALIZACION PARA MAPEO DE DISCAPACIDAD EN DINTPER
	UPDATE		@DINTPER								 
	SET			ESDISCAPAC								=	1
	FROM		@DINTPER								AS	A
	INNER JOIN  Expediente.IntervinienteDiscapacidad	AS	B WITH(NOLOCK)
	ON			A.TU_CodInterviniente					=	B.TU_CodInterviniente
	INNER JOIN  Catalogo.Discapacidad					AS	C WITH(NOLOCK)
	ON			B.TN_CodDiscapacidad					=	C.TN_CodDiscapacidad

	--INSERCIÓN EN DINTENT
	INSERT INTO @DINTENT
	(
		IDINT,
		NOMBRE,
		NOMCIAL,
		CODTIPIDE,
		NUMINT,
		NOMRESP,
		CARRESP,
		DESCRIP,
		TU_CodInterviniente
	)
	SELECT		A.IDINT								IDINT,
				D.TC_Nombre							NOMBRE,
				D.TC_NombreComercial				NOMCIAL,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIdentificacion', C.TN_CodTipoIdentificacion,0,0) CODTIPIDE,
				C.TC_Identificacion					NUMINT,
				D.TC_NombreRepresentante			NOMRESP,
				D.TC_CargoRepresentante				CARRESP,
				NULL								DESCRIP,
				B.TU_CodInterviniente				TU_CODINTERVINIENTE		
			
	FROM		@DACOINT							A
	INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
	ON			B.IDINT								= A.IDINT
	AND			B.TC_NumeroExpediente				= @L_NumeroExpediente
	INNER JOIN	Persona.Persona						C WITH(NOLOCK)
	ON			C.TU_CodPersona						= B.TU_CodPersona
	AND			C.TC_CodTipoPersona					= 'J'
	INNER JOIN	Persona.PersonaJuridica				D WITH(NOLOCK)
	ON			D.TU_CodPersona						= C.TU_CodPersona

	--INSERCION EN TABLA INTERVINIENTES DE TIPO REPRESENTANTES
	INSERT INTO @DINTREP
			(CARPETA,					IDINT,								IDINTREP,					CODREP,	 
			 FECINI,					FECFIN,								CODMEDCOM,					CODMEDCOMACC,
			 TU_CodMedioComunicacion,	TU_CodMedioComunicacionAcc,			TU_CodDomicilio)						
		SELECT		@L_Carpeta											CARPETA,
					A.IDINT												IDINT,
					H.IDINT												IDINTREP,
					ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoRepresentacion', B.TN_CodTipoRepresentacion,0,0), @L_ValorDefectoTipoRepresentacion)	CODREP,
					B.TF_Inicio_Vigencia								FECINI,
					B.TF_Fin_Vigencia									FECFIN,
					F.CODMEDCOM											CODMEDCOM,
					G.CODMEDCOM											CODMEDCOMACC,
					F.TU_CodMedioComunicacion							TU_CodMedioComunicacion,
					G.TU_CodMedioComunicacion							TU_CodMedioComunicacionAcc,
					I.TU_CodDomicilio									TU_CodDomicilio
		FROM		@Intervinientes									A
		INNER JOIN	Expediente.Representacion						B WITH(NOLOCK)				
		ON			B.TU_CodInterviniente							= A.TU_CodInterviniente
		OUTER APPLY	(
					SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoMedioComunicacion', D.TN_CodMedio,0,0) CODMEDCOM,
								D.TU_CodMedioComunicacion
					FROM		Expediente.IntervencionMedioComunicacion D WITH(NOLOCK)
					WHERE		D.TU_CodInterviniente					 = B.TU_CodIntervinienteRepresentante
					AND			D.TN_PrioridadExpediente				 = 1
					) F
		OUTER APPLY	(
					SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoMedioComunicacion', D.TN_CodMedio,0,0) CODMEDCOM,	
								D.TU_CodMedioComunicacion
					FROM		Expediente.IntervencionMedioComunicacion D WITH(NOLOCK)
					WHERE		D.TU_CodInterviniente					 = B.TU_CodIntervinienteRepresentante
					AND			D.TN_PrioridadExpediente				 = 2
					) G
		INNER JOIN	Expediente.Intervencion							H WITH(NOLOCK)				
		ON			H.TU_CodInterviniente							= B.TU_CodIntervinienteRepresentante
		OUTER APPLY	(
					SELECT		TOP 1 I.TU_CodDomicilio
					FROM		Expediente.IntervinienteDomicilio	I WITH(NOLOCK)
					INNER JOIN	Persona.Domicilio					J WITH(NOLOCK)
					On			J.TU_CodDomicilio					= I.TU_CodDomicilio
					WHERE		I.TU_CodInterviniente				= B.TU_CodIntervinienteRepresentante
					AND			J.TB_DomicilioHabitual				= 1
					ORDER BY	J.TF_Actualizacion	DESC
					)  I

	--INSERCION DE LOS MEDIOS DE COMUNICACION 
	INSERT INTO @DDOM 
				(CODCLADOM,			CLAVDOM,		NOMVIA,					CODBARRIO,				
				CODDISTRITO,		CODCANTON,		CODPROV,				FAX,				
				EMAIL,				OTROS,			TU_CodMedioComunicacion)
	SELECT		CASE 
					WHEN B.TC_TipoParticipacion = 'P' THEN 'I'
					WHEN B.TC_TipoParticipacion = 'R' THEN 'P'
				END												CODCLADOM,
				A.IDINT											CLAVDOM, 
				CASE 
					WHEN E.TC_TipoMedio = 'D' THEN C.TC_Valor	--D= DOMICILIO
					WHEN E.TC_TipoMedio IN ('F', 'E') THEN C.TC_Rotulado --F=FAX, E=EMAIL 
				END												NOMVIA,
				I.CODBARRIO										CODBARRIO,
				H.CODDISTRITO									CODDISTRITO,
				G.CODCANTON										CODCANTON,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Provincia', C.TN_CodProvincia,0,0) CODPROV,
				CASE 
					WHEN E.TC_TipoMedio = 'F' THEN C.TC_Valor	--F=FAX
				END												FAX,
				CASE 
					WHEN E.TC_TipoMedio = 'E' THEN C.TC_Valor	--E=EMAIL 
				END												EMAIL,
				CASE 
					WHEN E.TC_TipoMedio NOT IN ('D', 'E', 'F')	THEN C.TC_Valor	--D= DOMICILIO, F=FAX, E=EMAIL 
				END												OTROS,
				C.TU_CodMedioComunicacion						TU_CodMedioComunicacion		
	FROM		@DACOINT										A
	INNER JOIN	Expediente.Intervencion							B WITH(NOLOCK)
	ON			B.IDINT											= A.IDINT
	AND			B.TC_NumeroExpediente							= @L_NumeroExpediente
	INNER JOIN	Expediente.IntervencionMedioComunicacion		C WITH(NOLOCK)
	ON			C.TU_CodInterviniente							= B.TU_CodInterviniente
	INNER JOIN	Catalogo.TipoMedioComunicacion					E WITH(NOLOCK)
	ON			E.TN_CodMedio									= C.TN_CodMedio
	LEFT JOIN	Catalogo.Canton									G WITH(NOLOCK)
	ON			G.TN_CodProvincia								= C.TN_CodProvincia
	AND			G.TN_CodCanton									= C.TN_CodCanton
	LEFT JOIN	Catalogo.Distrito								H WITH(NOLOCK)
	ON			H.TN_CodProvincia								= C.TN_CodProvincia
	AND			H.TN_CodCanton									= C.TN_CodCanton
	AND			H.TN_CodDistrito								= C.TN_CodDistrito
	LEFT JOIN	Catalogo.Barrio									I WITH(NOLOCK)
	ON			I.TN_CodProvincia								= C.TN_CodProvincia
	AND			I.TN_CodCanton									= C.TN_CodCanton
	AND			I.TN_CodDistrito								= C.TN_CodDistrito
	AND			I.TN_CodBarrio									= C.TN_CodBarrio	

	--INSERCION DE LOS DOMICILIOS
	INSERT INTO @DDOM 
				(CODCLADOM,				CLAVDOM,				NOMVIA,				CODBARRIO,				
				CODDISTRITO,			CODCANTON,				CODPROV,			APAPOS,					
				BANCO,					CUENTA,					TELEFONO,			FAX,					
				OTROS,					TELEFONOCEL,			MENSCELULAR,		CODAUTORIDAD,			
				TU_CodDomicilio)
	SELECT		CASE I.TC_TipoParticipacion			
					WHEN 'R' THEN 'P'
					WHEN 'P' THEN 'I'
				END												AS CODCLADOM,
				I.IDINT											AS CLAVDOM,
				PD.TC_Direccion									AS NOMVIA,
				B.CODBARRIO										AS CODBARRIO,
				D.CODDISTRITO									AS CODDISTRITO,
				C.CODCANTON										AS CODCANTON,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Provincia', PD.TN_CodProvincia,0,0) AS CODPROV,
				NULL											AS APAPOS,
				NULL											AS BANCO,
				NULL											AS CUENTA,
				NULL											AS TELEFONO,
				NULL											AS FAX,
				NULL											AS OTROS,
				NULL											AS TELEFONOCEL,
				NULL											AS MENSCELULAR,
				NULL											AS CODAUTORIDAD,
				ID.TU_CodDomicilio								AS TU_CodDomicilio
	FROM		@DACOINT										A 		
	INNER JOIN	Expediente.Intervencion							I   WITH(NOLOCK)
	ON			I.IDINT											=   A.IDINT
	AND			I.TC_NumeroExpediente							=	@L_NumeroExpediente
	INNER JOIN	Expediente.IntervinienteDomicilio				ID	WITH(NOLOCK)
	ON			ID.TU_CodInterviniente							=	I.TU_CodInterviniente
	INNER JOIN	Persona.Persona									PE	WITH(NOLOCK)
	ON			PE.TU_CodPersona								=   I.TU_CodPersona
	INNER JOIN	Persona.Domicilio								PD	WITH(NOLOCK)
	ON			PD.TU_CodPersona								=	PE.TU_CodPersona
	AND			PD.TU_CodDomicilio								=	ID.TU_CodDomicilio 
	LEFT JOIN	Catalogo.Canton									C	WITH(NOLOCK)
	ON			C.TN_CodProvincia								=	PD.TN_CodProvincia
	AND			C.TN_CodCanton									=	PD.TN_CodCanton
	LEFT JOIN	Catalogo.Distrito								D	WITH(NOLOCK)
	ON			D.TN_CodProvincia								=	PD.TN_CodProvincia
	AND			D.TN_CodCanton									=	PD.TN_CodCanton
	AND			D.TN_CodDistrito								=	PD.TN_CodDistrito
	LEFT JOIN	Catalogo.Barrio									B	WITH(NOLOCK)
	ON			B.TN_CodProvincia								=	PD.TN_CodProvincia
	AND			B.TN_CodCanton									=	PD.TN_CodCanton
	AND			B.TN_CodDistrito								=	PD.TN_CodDistrito
	AND			B.TN_CodBarrio									=	PD.TN_CodBarrio	

	IF (SELECT TU_CodArchivo FROM Expediente.SolicitudExpediente WITH(NOLOCK) WHERE TU_CodHistoricoItineracion=@L_CodHistoricoItineracion) IS NOT NULL
	BEGIN
		UPDATE @DACOSOL SET IDACOSOL=@L_Idaco+1

		--INSERCIÓN EN DPATH
		INSERT INTO @DPATH
					([IDPATH],
					[PATH])
		SELECT		1,
					CONCAT( @L_Path,
					   CASE WHEN RIGHT(@L_Path,1) = '/' THEN ''
							ELSE '/'
					   END
				 ,Convert(Varchar(36),@CodHistoricoItineracion))

		--INSERCIÓN DE DOCUMENTOS EN DOCTEMP
		INSERT INTO	@DOCTEMP
					([TU_CodArchivo],
					 [CARPETA],
					 [DESPACHO_TRAMITE],
					 [TDET_DESPACHO_TIPO],
					 [CODPLAZA_TRAMITE],
					 [USUARIO_LOGIN],
					 [TDOT_TIPO_DOCUMENTO],
					 [DESCRIPCION],		
					 [FECHA],			
					 [NOMBRE],				
					 [NOMBRE_GUID],		
					 [IDPATH],		
					 [CODGT],				
					 [NOTIFICA],				
					 [TF_Particion],	
					 [IDACO],
					 [CODESTACO])					
		SELECT		 
					D.TU_CodArchivo									-- ID SIAGPJ
					,@L_Carpeta										-- CARPETA (#Expediente o Legajo)
					,D.TC_CodContextoCrea							-- DESPACHO_TRAMITE -- DACO.CODDEJ
					,'VD'											-- TDET_DESPACHO_TIPO #### TODO: definir qu‚ se va a enviar ####
					,NULL											-- CODPLAZA_TRAMITE ??
					,D.TC_UsuarioCrea								-- USUARIO_LOGIN -- IDUSU
					,NULL											-- TDOT_TIPO_DOCUMENTO
					,D.TC_Descripcion								-- DESCRIPCION DACO.TEXTO
					,D.TF_FechaCrea									-- FECCREACION -- DACO:FECSYS
					,CONCAT(D.TU_CodArchivo, F.TC_Extensiones)		-- DACODOC.NOMBRE
					,NULL											-- NOMBRE_GUID
					,1												-- IDPATH TODO: se debe definir este ID para SIAGPJ en BD de Gestión?
					,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0)--CODGT- Grupo de trabajo
					,E.TB_Notifica									-- [NOTIFICA]
					,D.TF_Particion									-- TF_Particion
					,I.IDACOSOL										-- IDACO
					,CASE D.TN_CodEstado	
						WHEN 4 THEN '5'
						ELSE D.TN_CodEstado	
					 END												CODESTACO -- CODESTACO
		FROM		Archivo.Archivo									D	WITH(NOLOCK)
		INNER JOIN	Expediente.ArchivoExpediente					E	WITH(NOLOCK)
		ON			E.TU_CodArchivo									=	D.TU_CodArchivo
		INNER JOIN	Catalogo.FormatoArchivo							F	WITH(NOLOCK)
		ON			F.TN_CodFormatoArchivo							=	D.TN_CodFormatoArchivo
		INNER JOIN  Expediente.SolicitudExpediente					H	WITH(NOLOCK)
		ON			D.TU_CodArchivo									=	H.TU_CodArchivo
		INNER JOIN  @DACOSOL										I
		ON			I.ID_NAUTIUS									=	H.TU_CodHistoricoItineracion
		WHERE		H.TU_CodHistoricoItineracion					=	@L_CodHistoricoItineracion
		AND			E.TC_NumeroExpediente							=	@L_NumeroExpediente

		--INSERCIÓN EN DACODOC
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
				@L_Carpeta				--CARPETA
				,D.IDACO				--IDACO
				,1						--IDDOC
				,D.IDPATH				--IDPATH
				,'EMI'					--CODMOD ### TODO: definir valor para enviar ###
				,NULL					--CODICO
				,LEFT(D.NOMBRE,50)		--NOMBRE
				,0						--PUBLICADO
				,NULL					--FIRMADO
				,D.TU_CodArchivo
		FROM	@DOCTEMP D

		--INSERCIÓN EN DACODOCR
		INSERT INTO @DACODOCR
					(CARPETA,
					 IDACO,
					 IDDOC,
					 FECENTRDD,
					 USURECEPTOR,
					 IDPATH,
					 DESCRIP,
					 PUBLICADO,
					 ESELECTRONICO,
					 FIRMADIGITAL,
					 USU_ENTREGA,
					 TRAMITADO,
					 USERLEIDO,
					 FECLEIDO,
					 RESERVADO,
					 TU_CodArchivo)
		SELECT		@L_Carpeta				
					,IDACO					
					,1						-- **consecutivo genera gestion migracion no se tiene.SNUM de gestion y obtener el que corresponde y meterlo
					,FECHA				
					,NULL					
					,0						-- **id de la ruta del archivo
					,DESCRIPCION			
					,NULL					
					,1						
					,null					
					,USUARIO_LOGIN		
					,'N'					
					,NULL					
					,NULL					
					,0						
					,TU_CodArchivo		
		FROM		@DOCTEMP			
	
		--INSERCIÓN EN DACO
		INSERT INTO @DACO
					([CARPETA],	
					[IDACO],		
					[CODDEJ],	
					[FECHA],		
					[TEXTO],		
					[CODACO],	
					[NUMACO],	
					[FECSYS],	
					[IDUSU],		
					[CODDEJUSR],	
					[CODESTACO],	
					[FECEST],	
					[NUMFOL],	
					[NUMFOLINI],	
					[PIEZA],	
					[CODPRO],	
					[CODJUDEC],	
					[CODJUTRA],
					[CODTRAM],	
					[CODESTADIST],
					[CODTIDEJ],	
					[IDACOREL],
					[CODREL],	
					[PRIORI],	
					[CODICO],	
					[AMPLIAR],	
					[CANT],		
					[CODGT],		
					[CODESC],	
					[FECENTRDD],	
					[CODTIPDOC],	
					[OTRGEST],	
					[IDENTREGA],	
					[FINALIZAEXP])
		SELECT									
					@L_Carpeta,						-- [CARPETA]	
					A.IDACO,						-- [IDACO]	
					DESPACHO_TRAMITE,				-- [CODDEJ]		
					COALESCE(A.FECHA, GETDATE()),	-- [FECHA]		
					A.DESCRIPCION,					-- [TEXTO]	
					'EMI',							-- [CODACO]	
					A.IDACO,						-- [NUMACO]	
					COALESCE(A.FECHA, GETDATE()),	-- [FECSYS]		
					A.USUARIO_LOGIN,				-- [IDUSU]	
					B.CODDEJ,						-- [CODDEJUSO]	
					A.CODESTACO,					-- [CODESTAC
					COALESCE(A.FECHA, GETDATE()),	-- [FECEST]	
					NULL,							-- [NUMFOL]	
					NULL,							-- [NUMFOLIN]
					NULL,							-- [PIEZA]	
					'',								-- [CODPRO]		
					NULL,							-- [CODJUDEC]	
					NULL,							-- [CODJUTRA	
					'INTER_SOL',					-- [CODTRAM]
					NULL,							-- [CODESTAD]	
					B.CODTIDEJ,						-- [CODTIDEJ]	
					NULL,							-- [IDACOREL
					NULL,							-- [CODREL]	
					0,								-- [PRIORI]	
					NULL,							-- [CODICO]		
					'0;',							-- [AMPLIAR]	
					NULL,							-- [CANT]		
					NULL,							-- [CODGT]	
					NULL,							-- [CODESC]	
					NULL,							-- [FECENTRDC]	
					NULL,							-- [CODTIPDO	
					0,								-- [OTRGEST]A]	
					NULL,							-- [IDENTREGEXP]
					NULL							-- [FINALIZA]
		FROM		@DOCTEMP	A
		INNER JOIN	@DACOSOL	B
		ON			A.CARPETA	=	B.CARPETA

		--INSERCIÓN EN @tblArchivos
		INSERT INTO @tblArchivos
		SELECT
				D.IDACO																					-- [id]
				,D.IDACO																				-- [idaco]
				,0																						-- [tipo]
				,D.NOMBRE																				-- [nombre]
				,D.IDPATH																				-- [idruta]
				,CONCAT( @L_Path,
				CASE WHEN RIGHT(@L_Path,1) = '/' THEN ''
					ELSE '/'
				END
				,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',D.NOMBRE)							-- [ruta]
				,0																						-- [comprimido]
				,0																						-- [adjunto]
				,COALESCE(@L_CodContextoOrigen, '')														-- [coddej]
				,4																						-- [ubicacion]
				,0																						-- [Error]
				,NULL																					-- [errordesc]
				,0																						-- [tamanio]
				,D.TU_CodArchivo																		-- [TU_CodArchivo]
		FROM	@DOCTEMP D
	END

	----ACTUALIZAR IDACO DE LA TABLA EXPEDIENTE.SOLICITUDEXPEDIENTE
	UPDATE	Expediente.SolicitudExpediente
	SET		IDACO						=	@L_Idaco
	WHERE	TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion

	--SE ACTUALIZA EL IDDOMINOT
	UPDATE		A
	SET			A.IDDOMINOT					= B.IDDOMI
	FROM		@DINT						A
	INNER JOIN	@DDOM						B
	On			A.TU_CodMedioComunicacion	= B.TU_CodMedioComunicacion

	UPDATE		A
	SET			A.IDDOMINOT					= B.IDDOMI
	FROM		@DINTREP					A
	INNER JOIN	@DDOM						B
	On			A.TU_CodMedioComunicacion	= B.TU_CodMedioComunicacion

	--SE ACTUALIZA EL IDDOMINOTACC
	UPDATE		A
	SET			A.IDDOMINOTACC					= B.IDDOMI
	FROM		@DINT							A
	INNER JOIN	@DDOM							B
	On			A.TU_CodMedioComunicacionAcc	= B.TU_CodMedioComunicacion

	UPDATE		A
	SET			A.IDDOMINOTACC					= B.IDDOMI
	FROM		@DINTREP						A
	INNER JOIN	@DDOM							B
	On			A.TU_CodMedioComunicacionAcc	= B.TU_CodMedioComunicacion

	--SE ACTUALIZA EL IDDOMI (DOMICILIO HABITUAL)
	UPDATE		A
	SET			A.IDDOMI					= B.IDDOMI
	FROM		@DINT						A
	INNER JOIN	@DDOM						B
	On			A.TU_CodDomicilio			= B.TU_CodDomicilio

	UPDATE		A
	SET			A.IDDOMI					= B.IDDOMI
	FROM		@DINTREP					A
	INNER JOIN	@DDOM						B
	On			A.TU_CodDomicilio			= B.TU_CodDomicilio

	-- Delito de Expediente
	INSERT INTO @DCARMASD
				([CARPETA]
				,[CODMASD]
				,[COLDAT]
				,[IDATR]
				,[VALOR])
	SELECT		@L_Carpeta		--CARPETA
				,'CODDELEST'	--CODMASD
				,@COLDAT		--COLDAT
				,'1'			--IDATR
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Delito', C.TN_CodDelito,0,0)--CODDEL - VALOR
	FROM		Expediente.Expediente			C	WITH (NOLOCK)
	WHERE		C.TC_NumeroExpediente			=	@L_NumeroExpediente;
	
	
	--CONSULTA FINAL
	SELECT * FROM @DACOSOL;
	SELECT * FROM @DACO;
	SELECT * FROM @DCAR;
	SELECT * FROM @DACOINT;
	SELECT * FROM @DINT;
	SELECT * FROM @DINTPER;
	SELECT * FROM @DDOM;
	SELECT * FROM @DACODOC;
	--SELECT * FROM @DACODOCR;  --04/03/2021 - Esta tabla no se devuelve porque SIAGPJ no tiene habilitada la función para documentos externos
	SELECT * FROM @DPATH;
	SELECT * FROM @tblArchivos;
	SELECT * FROM @DINTENT;
	SELECT * FROM @DCARMASD;
	SELECT * FROM @DINTREP;
END
GO
