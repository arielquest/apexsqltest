SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel>
-- Fecha de creación:		<28/01/2021>
-- Descripción :			<Permite consultar las comunicaciones para enviarlas a Gestión>
-- =============================================================================================================================================================================
-- Modificado por:			<03-02-2021><Jose Gabriel Cordero Soto> <Se realiza ajustes en consulta para aplicar mejor rendimiento>
-- Modificación:			<09/02/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:			<11/02/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de IDINT>
-- Modificación:			<07/04/2021><Karol Jiménez Sánchez> <Se modifica para corregir join con las intervenciones, porque campo CodInterviniente de Comunicacion no se llena>
-- Modificación:			<17/05/2021><Richard Zúñiga Segura> <Se modifica la consulta y se agrega el uso de DacoInicial>
-- Modificación:			<25/05/2021><Richard Zúñiga Segura> <Se modifica la consulta de los documentos y que devuelva unicamente las notificaciones>
-- Modificación:			<26/05/2021><Richard Zúñiga Segura> <Se modifica el outer apply de la insersión en DOCTEMP>
-- Modificación:			<26/05/2021><Richard Zúñiga Segura> <Se modifica la consulta de los intervinientes para guardarlos en DACO>
-- Modificación:			<03/06/2021><Richard Zúñiga Segura> <Se hace el inner join de Catalogo.PuestoTrabajoFuncionario con campo TU_CodPuestoFuncionarioRegistro>			
-- Modificación:			<03/06/2021><Richard Zúñiga Segura> <Se modifica el valor de Estado para que devuelva nulo>		
-- Modificación:            <29/07/2021><Jose Gabriel Cordero Soto> <Se modifica condicion en OUTER APPLY entre Comunicacion.ArchivoComunicacion y Comunicacion.ComunicacionIntervencion>
-- Modificación:			<03/08/2021><Jose Gabriel Cordero Soto> <Se ajusta asignacion de IDACOREL en registros de DACO de las actas y registros de notificación>
-- Modificación:			<04/08/2021><Jose Gabriel Cordero Soto> <Se realiza ajustes en CODTRAM, CODREL, IDACOREL y generacion de los DACO>
-- Modificación:			<04/08/2021><Jose Gabriel Cordero Soto> <Se realiza ajustes para la consultas y generacion de los IDACOS, addemas de las asociaciones con los IDACOREL y 
--															      tambien asociacion con los documentos y actas y documento a notificar>
-- Modificación:			<05/08/2021><Jose Gabriel Cordero Soto> <Se realiza ajustes por duplicidad en la generación de los registros de notificacion para los DACONOT>
-- Modificación:			<23/08/2021><Luis Alonso Leiva Tames> <Se realiza Correccion de duplicacion en datos en la tabla DACONOT, en la tabla CambioEstadoComunicacion >
-- Modificación:			<10/09/2021><Ronny Ramírez R.> <Se pone Left Join por si el documento de la comunicación no tiene formato jurídico asociado>
-- Modificación:			<14/09/2021><Ronny Ramírez R.> <Se aplica ajuste para separar las consultas de comunicaciones del Expediente y Legajo, pues estaban juntas>
-- Modificación:			<29/09/2021><Ronny Ramírez R.> <Se aplica ajuste para que vaya siempre el código de contexto destino en la tabla @tblArchivos, para que no haya
--							problemas dedescarga con el FTP si el archivo se creó en un contexto distinto al que envía la itineración>
-- Modificación:			<14/10/2021><Ronny Ramírez R.> <Se aplica ajuste para permitir mapear registros de DACONOT en DACO que no tengan actas de notificación generadas,
--							por lo que quedarían con IDACOREL en NULL, esto para que no se den problemas al itinerar expedientes anteriores a la migración sin actas>
-- Modificación:			<22/10/2021><Ronny Ramírez R.> <Se aplica corrección en order by de @DOCTEMP para que no haya ambiguedad por nuevo campo IDACO en tabla de
--							Comunicacion, y también se aplica TOP 1 en filtrado de Comunicacion.IntentoComunicacion de DACONOT, pues estaba trayendo varios registros por error>
-- Modificación:			<02/12/2021><Isaac Santiago Méndez Castillo> <Se elimina la tabla temporal @INTERVENCIONES_Y_REPRESENTANTES ya que a nivel de SP no está realizando
--																		   funciones extras a la tabla @INTERVENCIONES y está afectando al funcionamiento correcto de este SP.
--																		   está duplicando datos y afecta al sistema de itineraciones. Incidente: 227737>
-- Modificación:			<24/01/2022><Luis Alonso Leiva Tames> <Incidente 234594, mostraba en DACODOC y tblArchivos mas datos, error por el filtrado de EsPrincipal>
-- Modificación:			<25/01/2022><Luis Alonso Leiva Tames> <Incidente 235069, mostraba IDACO repetidos y DACONOT, se realiza la corrección>
-- Modificación:			<07/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo, FormatoJuridico,
--							TipoMedioComunicacion, Provincia y HorarioMedioComunicacion)>

-- Modificación:			<13/03/2024><Yesenia Araya Sánchez> <Incidente 377529, se modifica para que al insertar datos en la tabla @DACONOT al validar equivalencias de Tipos de medios de comunicacion,
--                          si el valor devuelto es NULL, le asigne 0 al campo CODMEDCOM>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarComunicacionesSiagpj]
(
	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@DacoInicial				INT = 1
)
AS
BEGIN

	/*************************************************************************************************/
	--DECLARACION DE VARIABLES LOCALES A UTILIZAR
	/*************************************************************************************************/
	
	DECLARE @L_CodHistoricoItineracion			VARCHAR(36)			= @CodHistoricoItineracion,
			@L_TC_NumeroExpediente				CHAR(14)			= NULL,
			@L_TU_CodLegajo						UNIQUEIDENTIFIER	= NULL,
			@L_Carpeta							VARCHAR(14)			= NULL,
			@L_DacoInicial						INT					= @DacoInicial,
			@L_Path								VARCHAR(255)		= NULL,
			@L_ContextoDestino					VARCHAR(4),
			@L_CodContextoOrigen				VARCHAR(4)

	--OBTIENE EL VALOR DEL EXPEDIENTE Y/O LEGAJO CON BASE EN EL CODIGO DE HISTORICO DE ITINERACION
	SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_CodContextoOrigen	= TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);
	
	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_Path					= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');

	/*************************************************************************************************/
	--DECLARACION DE TABLAS
	/*************************************************************************************************/

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
			[IDUSU]				[varchar](25)		NULL, --Validar nulo
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
			[FINALIZAEXP]		[varchar](2)		NULL);

	--Definición de la tabla INTERVENCIONES
	DECLARE @INTERVENCIONES As Table (
			[TU_CodInterviniente]		UNIQUEIDENTIFIER	NOT NULL,
			[IDINT]						INT					NULL);

	--Definición de tabla DACO
	DECLARE @DACONOT AS TABLE (
			[CARPETA]			[varchar](14)		NOT NULL,
			[IDACO]				[int]				NOT NULL,
			[IDINT]				[int]				NULL,  --Validar
			[IDINTREP]			[int]				NULL,
			[CODMEDCOM]			[varchar](1)		NULL,
			[NUMDIR]			[varchar](255)		NULL,
			[CODBARRIO]			[varchar](3)		NULL,
			[CODDISTRITO]		[varchar](3)		NULL,
			[CODCANTON]			[varchar](3)		NULL,
			[CODPROV]			[varchar](3)		NULL,
			[COPIAS]			[varchar](1)		NULL,
			[SECTOR]			[varchar](4)		NULL,
			[LUGAR]				[varchar](255)		NULL,
			[CODESTNOT]			[varchar](1)		NOT NULL,
			[AMPESTNOT]			[varchar](255)		NULL,
			[FECEST]			[datetime2](3)		NOT NULL,
			[FECENTOCN]			[datetime2](3)		NULL,
			[FECDEVOCN]			[datetime2](3)		NULL,
			[LOTE]				[varchar](5)		NULL,
			[FECCOMUNIC]		[datetime2](3)		NULL,
			[NOTPRI]			[varchar](1)		NOT NULL,
			[FECRES]			[datetime2](3)		NULL,
			[ENVIADO]			[varchar](25)		NULL,
			[Horario]			[char](1)			NULL,
			[DESCRIPHORARIO]	[varchar](150)		NULL,
			[TELEFONOCEL]		[varchar](50)		NULL,
			[MENSCELULAR]		[varchar](1)		NULL,
			[MEDPRIMARIO]		[bit]				NOT NULL,
			[IDACODOCUNOT]		[int]				NULL,
			[ESTADO]			[varchar](1)		NULL,
			[IDTRANSACCION]		[varchar](255)		NULL,
			[IDTRANSACCIONACTA] [varchar](255)		NULL,
			[FECHAENVIOGL]		[datetime2](3)		NULL,
			[FECHASMS]			[datetime2](3)		NULL,
			[ENVIOSMS]			[bit]				NOT NULL,
			[TU_CodArchivo]		UNIQUEIDENTIFIER	NOT NULL, -- Llaves de documentos SIAGPJ
			[CodInterviniente]	UNIQUEIDENTIFIER	NOT NULL);

	--Definición de tabla DPATH
	DECLARE	@DPATH AS TABLE (
			[IDPATH]					[INT]					NOT NULL,
			[PATH]						[VARCHAR](255)			NULL		
	);

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
			[IDACO]					[int]				NULL,
			[ESACTA]				[bit]				NOT NULL,		
			[ESPRINCIPAL]			[bit]				NOT NULL,
			[COD_COMUNICACION]		UNIQUEIDENTIFIER	NOT NULL,
			[CODTRAM]				[varchar](12)		NULL);

	DECLARE @DOCUNICOS AS TABLE 
	(
		[IDACO]			   INT					NULL, 
		[TU_CodArchivo]	   UNIQUEIDENTIFIER	NOT NULL,
		[TF_Particion]     [datetime2](3)	    NULL	
	)

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


    /*************************************************************************************************/
	--CARGA DE INFORMACION DE TABLAS
	/*************************************************************************************************/

	--INSERSIÓN DE DOCUMENTOS Y ACTAS EN DOCTEMP
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
				 [ESACTA],
				 [ESPRINCIPAL],
				 [COD_COMUNICACION],
				 [TF_Particion],	
				 [IDACO],
				 [CODTRAM])
	SELECT		 
				(D.TU_CodArchivo)																	-- ID SIAGPJ
				,@L_Carpeta																			-- CARPETA (#Expediente o Legajo)
				,i.TC_CodContextoDestino															-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,'VD'																				-- TDET_DESPACHO_TIPO #### TODO: definir qué se va a enviar ####
				,NULL																				-- CODPLAZA_TRAMITE ??
				,D.TC_UsuarioCrea																	-- USUARIO_LOGIN -- IDUSU
				,NULL																				-- TDOT_TIPO_DOCUMENTO
				,D.TC_Descripcion																	-- DESCRIPCION DACO.TEXTO
				,D.TF_FechaCrea																		-- FECCREACION -- DACO:FECSYS
				,CONCAT(D.TU_CodArchivo, F.TC_Extensiones)											-- DACODOC.NOMBRE
				,NULL																				-- NOMBRE_GUID
				,1																					-- IDPATH TODO: se debe definir este ID para SIAGPJ en BD de Gestión?
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0)--CODGT (Grupo de trabajo)
				,E.TB_Notifica																		-- [NOTIFICA]
				,J.TB_EsActa																		-- ESACTA
				,J.TB_EsPrincipal																	-- ESPRINCIPAL
				,J.TU_CodComunicacion																-- COD_COMUNICACION
				,D.TF_Particion																		-- TF_Particion				
				,ISNULL(ROW_NUMBER() over (order by D.TF_Particion ASC) + @L_DacoInicial -1 -
				(select COUNT(isnull(IDACO,1)) from @DOCTEMP),@L_DacoInicial)						--	IDACO
				,ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'FormatoJuridico', D.TC_CodFormatoJuridico,0,0), 'SIN_CODIGO')--CODTRAM
	FROM		Archivo.Archivo																		D	WITH(NOLOCK)
	INNER JOIN	Expediente.ArchivoExpediente														E	WITH(NOLOCK)
	ON			E.TU_CodArchivo																		=	D.TU_CodArchivo
	INNER JOIN  Comunicacion.Comunicacion															K   WITH(NOLOCK)
	ON			K.TC_NumeroExpediente																=   E.TC_NumeroExpediente		
	INNER JOIN  Comunicacion.ArchivoComunicacion													J   WITH(NOLOCK)
	ON			J.TU_CodComunicacion																=   K.TU_CodComunicacion	
	INNER JOIN	Catalogo.FormatoArchivo																F	WITH(NOLOCK)
	ON			F.TN_CodFormatoArchivo																=	D.TN_CodFormatoArchivo
	INNER JOIN	Historico.Itineracion																I	WITH(NOLOCK)
	ON			E.TC_NumeroExpediente																=	I.TC_NumeroExpediente
	WHERE		I.TU_CodHistoricoItineracion														=	@L_CodHistoricoItineracion
	AND			I.TC_NumeroExpediente																=	@L_TC_NumeroExpediente
	AND			J.TU_CodArchivo																		=	D.TU_CodArchivo
	AND			(
					(
						@L_TU_CodLegajo				IS NOT NULL		
						AND			  
						K.TU_CodLegajo				= @L_TU_CodLegajo
					)
					OR	
					(
						@L_TU_CodLegajo				IS NULL
						AND
						K.TU_CodLegajo				IS NULL
					)
				)
	ORDER BY	K.IDACO ASC

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP;


	--INSERCION DE DOCUMENTOS UNICOS (FILTRADO DE LOS DOCTEMP)
	INSERT INTO @DOCUNICOS
	(		
		[IDACO],
		[TU_CodArchivo],
		[TF_Particion]		
	)		
	SELECT	 ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial) IDACO
			,A.TU_CodArchivo
			,A.TF_Particion		
	FROM   	(SELECT	DISTINCT	TU_CodArchivo,
								TF_Particion								
			 FROM				@DOCTEMP ) A			
			
	
	SELECT TOP(1) @L_ContextoDestino = DESPACHO_TRAMITE 
	FROM   @DOCTEMP		
		
	--INSERSIÓN EN TABLA INTERVENCIONES
	INSERT INTO @INTERVENCIONES	(
				TU_CodInterviniente,
				IDINT)
	SELECT		A.TU_CodInterviniente,
				A.IDINT
	FROM		Expediente.Intervencion				A WITH (NOLOCK)
	LEFT JOIN	Expediente.LegajoIntervencion		B WITH (NOLOCK)
	ON			B.TU_CodInterviniente				= A.TU_CodInterviniente
	AND			B.TU_CodLegajo						= @L_TU_CodLegajo
	WHERE		A.TC_NumeroExpediente				= @L_TC_NumeroExpediente
	AND			(
					(
						@L_TU_CodLegajo				IS NOT NULL		
					AND			  
						TU_CodLegajo				= @L_TU_CodLegajo
					)
				OR			 
					@L_TU_CodLegajo					IS NULL
				)				
	

	--(DACO) Acontecimiento del documento asociado a la comunicacion
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
	SELECT 		@L_Carpeta,																					-- [CARPETA]
				X.IDACO,																					-- [IDACO]
				A.DESPACHO_TRAMITE,																			-- [CODDEJ]
				A.FECHA,																					-- [FECHA]
				A.DESCRIPCION,																				-- [TEXTO]
				'EMI',																						-- [CODACO]	
				X.IDACO,																					-- [NUMACO]
				A.FECHA,																					-- [FECSYS]
				A.USUARIO_LOGIN,																			-- [IDUSU]
				C.TC_CodContexto,																			-- [CODDEJSUR] -- quien itineró código oficina origen
				5,																							-- [CODESTACO]
				A.FECHA,																					-- [FECEST]
				NULL,																						-- [NUMFOL]
				NULL,																						-- [NUMFOLINI]
				NULL,																						-- [PIEZA]
				'',																							-- [CODPRO]  --PREGUNTAR ESTO???
				NULL,																						-- [CODJUDEC]			
				NULL,																						-- [CODJUTRA]
				A.CODTRAM,																					-- [CODTRAM]
				NULL,																						-- [CODESTADIST]
				C.CODTIDEJ,																					-- [CODTIDEJ] --PREGUNTAR ESTO???
				NULL,																						-- [IDACOREL]
				NULL,																						-- [CODREL]
				0,																							-- [PRIORI]
				NULL, 																						-- [CODICO]
				CASE 
				 WHEN A.ESPRINCIPAL = 1 AND A.ESACTA = 0 THEN '0;'
				 WHEN A.ESPRINCIPAL = 0 AND A.ESACTA = 1 THEN '8;'
				END,	 																					-- [AMPLIAR]
				NULL, 																						-- [CANT]
				NULL, 																						-- [CODGT]
				NULL,																						-- [CODESC]
				NULL, 																						-- [FECENTRDD]		
				NULL, 																						-- [CODTIPDOC]	
				0,																							-- [OTRGEST]
				NULL, 																						-- [IDENTREGA]
				NULL																						-- [FINALIZAEXP]
	FROM		@DOCUNICOS								X	
	OUTER APPLY (
					SELECT  TOP(1) Z.NOMBRE,      Z.IDPATH, Z.DESPACHO_TRAMITE,  Z.CARPETA,     
								   Z.CODTRAM,	  Z.FECHA,  Z.USUARIO_LOGIN,     Z.DESCRIPCION,
								   Z.ESPRINCIPAL, Z.ESACTA, Z.IDACO
					FROM	@DOCTEMP			Z
					WHERE   Z.TU_CodArchivo     = X.TU_CodArchivo 					
				) A		
	LEFT JOIN	Expediente.Expediente		B   WITH (NOLOCK)
	ON			(			
					@L_TU_CodLegajo			IS NULL
					AND
					B.CARPETA				=	A.CARPETA	
					AND
					B.TC_NumeroExpediente	=	@L_TC_NumeroExpediente
				)
	LEFT JOIN	Expediente.Legajo			B2   WITH (NOLOCK)
	ON			B2.CARPETA					=	A.CARPETA
	AND			B2.TU_CodLegajo				=	@L_TU_CodLegajo
	AND			B2.TC_NumeroExpediente		=	@L_TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto			C	WITH (NOLOCK)
	ON			C.TC_CodContexto			=	ISNULL(B.TC_CodContexto, B2.TC_CodContexto)
	WHERE		A.ESPRINCIPAL				=   1					
	
	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial =  (COUNT(*) + @L_DacoInicial ) FROM @DOCUNICOS;

	--Acontecimiento del registro de la notificacion del documento 
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
	SELECT 		@L_Carpeta,																					-- [CARPETA]
				ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),	-- [IDACO],																							-- [IDACO]
				A.DESPACHO_TRAMITE,																			-- [CODDEJ]
				A.FECHA,																					-- [FECHA]
				'Registrar Notificaciones/Emitir documento/Asociar Documentos/',							-- [TEXTO]
				'EMI',																						-- [CODACO]	
				ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),	-- [NUMACO]
				A.FECHA,																					-- [FECSYS]
				A.USUARIO_LOGIN,																			-- [IDUSU]
				C.TC_CodContexto,																			-- [CODDEJSUR] -- quien itineró código oficina origen
				5,																							-- [CODESTACO]
				A.FECHA,																					-- [FECEST]
				NULL,																						-- [NUMFOL]
				NULL,																						-- [NUMFOLINI]
				NULL,																						-- [PIEZA]
				'',																							-- [CODPRO]  --PREGUNTAR ESTO???
				NULL,																						-- [CODJUDEC]			
				NULL,																						-- [CODJUTRA]
				'REG_NOTI',																					-- [CODTRAM]
				NULL,																						-- [CODESTADIST]
				C.CODTIDEJ,																					-- [CODTIDEJ] --PREGUNTAR ESTO???
				X.IDACO,																					-- [IDACOREL]
				'NOT',																						-- [CODREL]
				0,																							-- [PRIORI]
				NULL, 																						-- [CODICO]
				'8;',	 																					-- [AMPLIAR]
				NULL, 																						-- [CANT]
				NULL, 																						-- [CODGT]
				NULL,																						-- [CODESC]
				NULL, 																						-- [FECENTRDD]		
				NULL, 																						-- [CODTIPDOC]	
				0,																							-- [OTRGEST]
				NULL, 																						-- [IDENTREGA]
				NULL																						-- [FINALIZAEXP]
	FROM		@DOCTEMP								A  
	INNER JOIN	@DOCUNICOS								X
	ON			A.TU_CodArchivo							=	X.TU_CodArchivo		
	INNER JOIN	Comunicacion.ComunicacionIntervencion	D	WITH (NOLOCK)
	ON			D.TU_CodComunicacion					=	A.COD_COMUNICACION
	LEFT JOIN	Expediente.Expediente					B   WITH (NOLOCK)
	ON			(			
					@L_TU_CodLegajo						IS NULL
					AND
					B.CARPETA							=	A.CARPETA	
					AND
					B.TC_NumeroExpediente				=	@L_TC_NumeroExpediente
				)
	LEFT JOIN	Expediente.Legajo						B2  WITH (NOLOCK)
	ON			B2.CARPETA								=	A.CARPETA
	AND			B2.TU_CodLegajo							=	@L_TU_CodLegajo
	AND			B2.TC_NumeroExpediente					=	@L_TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto						C	WITH (NOLOCK)
	ON			C.TC_CodContexto						=	ISNULL(B.TC_CodContexto, B2.TC_CodContexto)
	WHERE		A.ESPRINCIPAL							=  1		
	
		
	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + 1
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DACO;
	
	--Acontecimiento del registro del acta de notificación
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
	SELECT 		@L_Carpeta,							-- [CARPETA]
				A.IDACO,							-- [IDACO]
				A.DESPACHO_TRAMITE,					-- [CODDEJ]
				A.FECHA,							-- [FECHA]
				'Acta de Notificación/Resolución',	-- [TEXTO]
				'EMI',								-- [CODACO]	
				A.IDACO,							-- [NUMACO]
				A.FECHA,							-- [FECSYS]
				A.USUARIO_LOGIN,					-- [IDUSU]
				C.TC_CodContexto,					-- [CODDEJSUR] -- quien itineró código oficina origen
				5,									-- [CODESTACO]
				A.FECHA,							-- [FECEST]
				NULL,								-- [NUMFOL]
				NULL,								-- [NUMFOLINI]
				NULL,								-- [PIEZA]
				'',									-- [CODPRO]  --PREGUNTAR ESTO???
				NULL,								-- [CODJUDEC]			
				NULL,								-- [CODJUTRA]
				'DOC_ACTA',							-- [CODTRAM]
				NULL,								-- [CODESTADIST]
				C.CODTIDEJ,							-- [CODTIDEJ] --PREGUNTAR ESTO???
				NULL,								-- [IDACOREL]
				'NOT',								-- [CODREL]
				0,									-- [PRIORI]
				NULL, 								-- [CODICO]
				'0;',	 							-- [AMPLIAR]
				NULL, 								-- [CANT]
				NULL, 								-- [CODGT]
				NULL,								-- [CODESC]
				NULL, 								-- [FECENTRDD]		
				NULL, 								-- [CODTIPDOC]	
				0,									-- [OTRGEST]
				NULL, 								-- [IDENTREGA]
				NULL								-- [FINALIZAEXP]
	
	FROM		@DOCTEMP						A
	LEFT JOIN	Expediente.Expediente			B   WITH (NOLOCK)
	ON			(
					@L_TU_CodLegajo				IS	NULL
					AND
					B.CARPETA					=	A.CARPETA	
					AND
					B.TC_NumeroExpediente		=	@L_TC_NumeroExpediente
				)
	LEFT JOIN	Expediente.Legajo				B2  WITH (NOLOCK)
	ON			B2.CARPETA						=	A.CARPETA
	AND			B2.TU_CodLegajo					=	@L_TU_CodLegajo
	AND			B2.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto				C	WITH (NOLOCK)
	ON			C.TC_CodContexto				=	ISNULL(B.TC_CodContexto, B2.TC_CodContexto)
	INNER JOIN	Comunicacion.Comunicacion		D	WITH (NOLOCK)
	ON			D.TU_CodComunicacion			=   A.COD_COMUNICACION		
	WHERE		A.ESACTA						=   1		
	
	
	--INSERCIÓN EN TABLA DACONOT (LAS COMUNICACIONES PARA GESTION)
	INSERT INTO @DACONOT
	SELECT		@L_Carpeta									CARPETA,				
				Q.IDACO										IDACO,
				A.IDINT										IDINT,
				NULL										IDINTREP,
				ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoMedioComunicacion', B.TC_CodMedio,0,0), 0), --CODMEDCOM
				SUBSTRING(B.TC_Valor, 0, 255)				NUMDIR,--VALORAR
				G.CODBARRIO									CODBARRIO,
				F.CODDISTRITO								CODDISTRITO,
				E.CODCANTON									CODCANTON,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Provincia', B.TN_CodProvincia,0,0) CODPROV,
				--D.CODPROV									CODPROV,
				CASE 
				    WHEN B.TB_RequiereCopias = 1 THEN 'S'							
					WHEN B.TB_RequiereCopias = 0 THEN 'N'
					ELSE ''
				END											COPIAS,
				NULL										SECTOR,
				SUBSTRING(B.TC_Rotulado, 0, 255)			LUGAR,
				CASE 
					WHEN UPPER(B.TC_Resultado) = 'P' THEN '+'
					WHEN UPPER(B.TC_Resultado) = 'N' THEN '-'
					ELSE ''
				END											CODESTNOT,
				H.TC_Observaciones							AMPESTNOT,
				I.FECEST,
				B.TF_FechaEnvio								FECENTOCN,
				B.TF_FechaDevolucion						FECDEVOCN, 	
				NULL										LOTE,
				I.FECEST									FECCOMUNIC,
				CASE 
					WHEN B.TB_TIENEPRIORIDAD = 0 THEN 'N'
					WHEN B.TB_TIENEPRIORIDAD = 1 THEN 'S'
					ELSE ''
				END											NOTPRI,
				B.TF_FECHARESOLUCION						FECRES,
				N.TC_UsuarioRed								ENVIADO,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'HorarioMedioComunicacion', B.TN_CodHorarioMedio,0,0) HORARIO,					
				SUBSTRING(B.TC_Observaciones, 0, 150)		DESCRIPHORARIO,
				K.TELEFONOCEL,
				K.MENSCELULAR,
				B.TN_PrioridadMedio							MEDPRIMARIO,
				J.IDACO										IDACODOCUNOT,
				NULL,										--Validar Si debe ir nulo (I.ESTADO)
				NULL										IDTRANSACCION,
				NULL										IDTRANSACCIONACTA,
				NULL										FECHAENVIOGL,
				NULL										FECHASMS,
				0											ENVIOSMS,
				M.TU_CodArchivo,
				L.TU_CodInterviniente						CodInterviniente
	FROM		@INTERVENCIONES								A
	INNER JOIN  Comunicacion.ComunicacionIntervencion		L WITH(NOLOCK)
	ON			L.TU_CodInterviniente						= A.TU_CodInterviniente
	INNER JOIN	Comunicacion.Comunicacion					B WITH(NOLOCK)
	ON			B.TU_CodComunicacion						= L.TU_CodComunicacion
	LEFT JOIN   Catalogo.Canton								E WITH(NOLOCK)
	ON			E.TN_CodCanton								= B.TN_CodCanton
	AND			E.TN_CodProvincia							= B.TN_CodProvincia
	LEFT JOIN	Catalogo.Distrito							F WITH(NOLOCK)
	ON			F.TN_CodDistrito							= B.TN_CodDistrito	
	AND			F.TN_CodCanton								= B.TN_CodCanton	
	AND			F.TN_CodProvincia							= B.TN_CodProvincia	
	LEFT JOIN   Catalogo.Barrio								G WITH(NOLOCK)
	ON			G.TN_CodBarrio								= B.TN_CodBarrio
	AND			G.TN_CodDistrito							= B.TN_CodDistrito
	AND			G.TN_CodCanton								= B.TN_CodCanton
	AND			G.TN_CodProvincia							= B.TN_CodProvincia
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario			N WITH(NOLOCK)
	ON			B.TU_CodPuestoFuncionarioRegistro			= N.TU_CodPuestoFuncionario
	OUTER APPLY	(
					SELECT TOP 1	Z.TF_FechaIntento,	Z.TC_Observaciones
					FROM			Comunicacion.IntentoComunicacion		Z WITH(NOLOCK)
					WHERE			Z. TU_CodComunicacion					= B.TU_CodComunicacion
					ORDER BY		Z.TF_FechaIntento	DESC
				) H
	OUTER APPLY	(
					SELECT		MAX(Y.TF_Fecha) FECEST
					FROM		Comunicacion.CambioEstadoComunicacion	Y WITH(NOLOCK)
					WHERE		Y.TU_CodComunicacion					= B.TU_CodComunicacion
				) I																				
	OUTER APPLY	(
					SELECT TOP 1 X.TC_Numero TELEFONOCEL,	CASE
																WHEN X.TB_SMS = 1 THEN 'S'
																WHEN X.TB_SMS = 0 THEN 'N'
															END MENSCELULAR
					FROM		Expediente.Intervencion		W WITH(NOLOCK)
					INNER JOIN	Persona.Telefono			X WITH(NOLOCK)
					ON			X.TU_CodPersona				= W.TU_CodPersona
					AND			X.TN_CodTipoTelefono		= 4--Para los móviles
					WHERE		W.TU_CodInterviniente		= A.TU_CodInterviniente
				) K
	
	INNER JOIN  Comunicacion.ArchivoComunicacion		M  WITH(NOLOCK)
	ON			M.TU_CodComunicacion					= B.TU_CodComunicacion
	AND			M.TB_EsPrincipal						= 1
	INNER JOIN  @DOCTEMP								Q
	ON			Q.COD_COMUNICACION						= M.TU_CodComunicacion
	AND			Q.TU_CodArchivo							= M.TU_CodArchivo
	OUTER APPLY	(
					SELECT	TOP(1)	Z.IDACO
					FROM	@DOCUNICOS			Z					
					WHERE	Z.TU_CodArchivo		= M.TU_CodArchivo					
				) J
	WHERE		B.TC_TipoComunicacion = 'N'		
	
	--Acontencimiento de la notificacion de las actas (DACONOT)	
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
	SELECT 		@L_Carpeta,									-- [CARPETA]
				A.IDACO,									-- [IDACO]
				@L_ContextoDestino,							-- [CODDEJ]
				A.FECCOMUNIC,								-- [FECHA]
				'Registrar Notificaciones/Notificación',	-- [TEXTO]
				'NOTI',										-- [CODACO]	
				A.IDACO	,									-- [NUMACO]
				A.FECCOMUNIC,								-- [FECSYS]
				A.ENVIADO,									-- [IDUSU]
				C.TC_CodContexto,							-- [CODDEJSUR] -- quien itineró código oficina origen
				5,											-- [CODESTACO]
				A.FECCOMUNIC,								-- [FECEST]
				NULL,										-- [NUMFOL]
				NULL,										-- [NUMFOLINI]
				NULL,										-- [PIEZA]
				'',											-- [CODPRO]  --PREGUNTAR ESTO???
				NULL,										-- [CODJUDEC]			
				NULL,										-- [CODJUTRA]
				'REG_NOTI',									-- [CODTRAM]
				NULL,										-- [CODESTADIST]
				C.CODTIDEJ,									-- [CODTIDEJ] --PREGUNTAR ESTO???
				G.IDACO,									-- [IDACOREL]
				'NOT',										-- [CODREL]
				0,											-- [PRIORI]
				NULL, 										-- [CODICO]
				'8;',	 									-- [AMPLIAR]
				NULL, 										-- [CANT]
				NULL, 										-- [CODGT]
				NULL,										-- [CODESC]
				NULL, 										-- [FECENTRDD]		
				NULL, 										-- [CODTIPDOC]	
				0,											-- [OTRGEST]
				NULL, 										-- [IDENTREGA]
				NULL										-- [FINALIZAEXP]						
				
	FROM		@DACONOT								A		
	LEFT JOIN	Expediente.Expediente					B   WITH (NOLOCK)
	ON			(
					B.CARPETA							=	A.CARPETA
					AND				
					@L_TU_CodLegajo						IS	NULL
				)
	LEFT JOIN	Expediente.Legajo						B2   WITH (NOLOCK)
	ON			B2.CARPETA								=	A.CARPETA
	AND			B2.TU_CodLegajo							=	@L_TU_CodLegajo
	INNER JOIN	Catalogo.Contexto						C	WITH (NOLOCK)
	ON			C.TC_CodContexto						=	ISNULL(B.TC_CodContexto, B2.TC_CodContexto)
	INNER JOIN	@DOCTEMP								F
	ON			F.IDACO									=   A.IDACO
	LEFT JOIN	@DOCTEMP								G  
	ON			G.COD_COMUNICACION						=   F.COD_COMUNICACION
	AND			G.ESACTA								=   1			
		
	--ACTUALIZA IDACOREL DEL REGISTRO DEL ACTA PARA ASOCIARLO AL IDACO DEL REGISTRO DE LA NOTIFICACIÓN		
	UPDATE		A
	SET			A.IDACOREL = Z.IDACO	
	FROM		@DACO	   A
	INNER JOIN	@DOCTEMP   B
	ON			B.IDACO	   = A.IDACO
	AND			B.ESACTA   = 1	
	OUTER APPLY (
					SELECT  Y.IDACO 
					FROM    @DACO		Y
					WHERE	Y.IDACOREL	= A.IDACO	
				) Z	
	
	--INSERSIÓN EN @tblArchivos
	INSERT INTO @tblArchivos
	SELECT		
				A.IDACO															-- [id]
				,A.IDACO														-- [idaco]
				,0																-- [tipo]
				,D.NOMBRE														-- [nombre]
				,D.IDPATH														-- [idruta]
				,CONCAT( @L_Path,
				CASE WHEN RIGHT(@L_Path,1) = '/' THEN ''
					ELSE '/'
				END
				,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',D.NOMBRE)	-- [ruta]
				,0																-- [comprimido]
				,0																-- [adjunto]
				,@L_CodContextoOrigen											-- [coddej]
				,4																-- [ubicacion]
				,0																-- [Error]
				,NULL															-- [errordesc]
				,0																-- [tamanio]
				,D.TU_CodArchivo												-- [TU_CodArchivo]
	FROM		@DOCUNICOS				A	
	INNER JOIN  @DOCTEMP				D
	ON			D.TU_CodArchivo			= A.TU_CodArchivo	
	AND			D.IDACO					= (
											SELECT	TOP(1) Z.IDACO
											FROM	@DOCTEMP			Z
											WHERE   Z.TU_CodArchivo     = A.TU_CodArchivo
										  ) 		
	WHERE		D.ESPRINCIPAL			= 1
	
	INSERT INTO @tblArchivos
	SELECT		
				A.IDACO															-- [id]
				,A.IDACO														-- [idaco]
				,0																-- [tipo]
				,A.NOMBRE														-- [nombre]
				,A.IDPATH														-- [idruta]
				,CONCAT( @L_Path,
				CASE WHEN RIGHT(@L_Path,1) = '/' THEN ''
					ELSE '/'
				END
				,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',A.NOMBRE)	-- [ruta]
				,0																-- [comprimido]
				,0																-- [adjunto]
				,@L_CodContextoOrigen											-- [coddej]
				,4																-- [ubicacion]
				,0																-- [Error]
				,NULL															-- [errordesc]
				,0																-- [tamanio]
				,A.TU_CodArchivo												-- [TU_CodArchivo]
	FROM		@DOCTEMP		A
	WHERE		A.ESACTA		= 1	
	
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
	SELECT	    @L_Carpeta				--CARPETA
			   ,A.IDACO					--IDACO
			   ,1						--IDDOC
			   ,D.IDPATH				--IDPATH
			   ,'EMI'					--CODMOD ### TODO: definir valor para enviar ###
			   ,NULL					--CODICO
			   ,LEFT(D.NOMBRE,50)		--NOMBRE
			   ,0						--PUBLICADO
			   ,NULL					--FIRMADO
			   ,A.TU_CodArchivo
	FROM		@DOCUNICOS				A	
	INNER JOIN  @DOCTEMP				D
	ON			D.TU_CodArchivo			= A.TU_CodArchivo	
	AND			D.IDACO					= (
											SELECT	TOP(1) Z.IDACO
											FROM	@DOCTEMP			Z
											WHERE   Z.TU_CodArchivo     = A.TU_CodArchivo
										 ) 		
	WHERE		D.ESPRINCIPAL			= 1
								 
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
			   ,D.IDACO					--IDACO
			   ,1						--IDDOC
			   ,D.IDPATH				--IDPATH
			   ,'EMI'					--CODMOD ### TODO: definir valor para enviar ###
			   ,NULL					--CODICO
			   ,LEFT(D.NOMBRE,50)		--NOMBRE
			   ,0						--PUBLICADO
			   ,NULL					--FIRMADO
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP		D
	WHERE		D.ESACTA		= 1      
	
	
	--INSERSIÓN EN DACODOCR   --04/03/2021 - Esta tabla no se devuelve porque SIAGPJ no tiene habilitada la función para documentos externos
	/*
	--INSERT INTO @DACODOCR

	--			(CARPETA,
	--			 IDACO,
	--			 IDDOC,
	--			 FECENTRDD,
	--			 USURECEPTOR,
	--			 IDPATH,
	--			 DESCRIP,
	--			 PUBLICADO,
	--			 ESELECTRONICO,
	--			 FIRMADIGITAL,
	--			 USU_ENTREGA,
	--			 TRAMITADO,
	--			 USERLEIDO,
	--			 FECLEIDO,
	--			 RESERVADO,
	--			 TU_CodArchivo)
	--SELECT		@L_Carpeta				
	--			,0--IDACO					
	--			,1						-- **consecutivo genera gestion migracion no se tiene.SNUM de gestion y obtener el que corresponde y meterlo
	--			,B.FECHA				
	--			,NULL					
	--			,0						-- **id de la ruta del archivo
	--			,B.DESCRIPCION			
	--			,NULL					
	--			,1						
	--			,null					
	--			,B.USUARIO_LOGIN		
	--			,'N'					
	--			,NULL					
	--			,NULL					
	--			,0						
	--			,TU_CodArchivo		
	--FROM		@DOCUNICOS D
	--OUTER APPLY (
	--				SELECT  TOP(1) Z.NOMBRE, Z.IDPATH, Z.DESPACHO_TRAMITE, Z.FECHA, Z.DESCRIPCION, Z.USUARIO_LOGIN
	--				FROM	       @DOCTEMP  Z
	--				WHERE		   Z.TU_CodArchivo     = D.TU_CodArchivo 					
	--			) B											
	*/
	
	--INSERSIÓN EN DPATH	  
	DECLARE @CANTIDADARCHIVOS INT = (SELECT COUNT(*) FROM @DOCUNICOS)

	IF @CANTIDADARCHIVOS > 0
	BEGIN
		INSERT INTO @DPATH
					([IDPATH],
					[PATH])
		SELECT	1,
				CONCAT( @L_Path,
						CASE WHEN RIGHT(@L_Path,1) = '/' THEN ''
							ELSE '/'
						END
				,Convert(Varchar(36),@L_CodHistoricoItineracion))
	END		
	
	/*************************************************************************************************/
	--COPNSULTA FINAL CON LOS RESULTADOS OBTENIDOS
	/*************************************************************************************************/
		
	SELECT * FROM @DACONOT ORDER BY IDACO;		
		
	SELECT * FROM @DACO ORDER BY IDACO;

    SELECT * FROM @DACODOC ORDER BY IDACO;
	
	--SELECT * FROM @DACODOCR;  --04/03/2021 - Esta tabla no se devuelve porque SIAGPJ no tiene habilitada la función para documentos externos
	
	SELECT * FROM @tblArchivos ORDER BY IDACO;
	
	SELECT * FROM @DPATH;
END
GO
