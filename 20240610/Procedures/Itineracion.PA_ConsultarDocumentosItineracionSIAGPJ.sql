SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<13/01/2021>
-- Descripción :			<Permite consultar los documentos asociados a un expediente de SIAGPJ mapeado a registros de Gestión con sus catálogos respectivos>
-- ======================================================================================================================================================================================================
-- Modificado:				<24/01/2021><Luis Alonso Leiva Tames><Se Agrega la consulta para Escritos de un expediente y legajo>
-- Modificado:				<25/01/2021><Luis Alonso Leiva Tames><Se Agrega la consulta para mostrar las resoluciones de un expediente>
-- Modificación:			<09/02/2021> <Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:			<16/02/2021> <Karol Jiménez Sánchez> <Se modifica para incluir ID Historico Itineracion en carpeta ftp donde se guardarán los documentos>
-- Modificado:				<22/02/2021><Luis Alonso Leiva Tames><Se Agrega la consulta para Escritos de un legajo>
-- Modificado:				<22/02/2021><Luis Alonso Leiva Tames><Se inserta en la tabla @tblArchivos los escritos y las resoluciones>
-- Modificado:				<22/02/2021><Luis Alonso Leiva Tames><Se modifica para excluir los escritos de un legajos cuando es por expediente>
-- Modificado:				<03/03/2021><Luis Alonso Leiva Tames><Se modifica para insertar en la tabla DACO documentos, demandas, escritos, apremios, resoluciones >
-- Modificado:				<04/03/2021><Karol Jiménez Sánchez><Se agrega mapeo de documentos de apremios en DACODOC, se ajusta llenado de @DOCTEMP solo con lo necesario>
-- Modificado:				<04/03/2021><Luis Alonso Leiva Tames><Se modifica el IDACO generado, cambio en consulta de escritos>
-- Modificado:				<05/03/2021><Luis Alonso Leiva Tames><Se saca el DACO de resoluciones>
-- Modificado:				<05/03/2021><Karol Jiménez Sánchez><Se agrega tabla DPATH y se agrega mapeo de documentos de apremios en DACODOC>
-- Modificado:				<19/03/2021><Ronny Ramírez R.><Se agrega campo CODMOD del campo CODTRAM de tabla Catalogo.FormatoJuridico, asociada con Archivo.Archivo>
-- Modificado:				<06/04/2021><Karol Jiménez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificado:				<25/05/2021><Richard Zúñiga Segura> <Se modifica la consulta para que ignore los archivos que relacionados con las comunicaciones>
-- Modificado:				<14/06/2021><Karol Jiménez Sánchez> <Se corrige bug 197895 - Se pone campo PUBLICADO = 0 de DACODOCR>
-- Modificado:				<15/06/2021><Ronny Ramírez R.> <Se corrige bug 197459 - Se pone campo D.CODMOD en lugar de REG_RESO quemado en @DACO, solo se deja para resoluciones>
-- Modificado:				<18/06/2021><Karol Jiménez Sánchez> <Se corrige bug 197900 - Se indica campo DACORES.CODESTRES obligaratorio, y se envia '999' (según mapeo de Roger y acuerdo con Sigifredo)
--							Se corrige para que envie itineraciones aunque no tengan número de voto>
-- Modificado:				<18/06/2021><Ronny Ramírez R.> <Se aplica corrección en caso que el campo P.TC_UsuarioRed venga NULL, porque no venía inicialmente desde Gestión
--							se reenvía el campo original almacenado en E.USUREDAC>
-- Modificado:				<22/06/2021><Karol Jiménez Sánchez><Se corrige para que campo DACODOCR.PARACESIONMASIVA se llene con NULL, dado que no existe en SIAGPJ y no acepta nulos
--							Además, se ajusta DACODOCR.IDACO que estaba mapeandose nulo>
-- Modificado:				<24/06/2021><Luis Alonso Leiva Tames><Se modifica para seleccionar todos los documentos sin importar su estado>
-- Modificado:				<28/06/2021><Ronny Ramírez R.> <Se corrige bug 199863 - se asigna valor de DACO del documento asociado a la resolución en IDACOSENDOC>
-- Modificado:				<07/07/2021><Karol Jiménez Sánchez> <Se corrige error por IDUSU de DACO null, y se ajusta un posible producto cartesiano al obtener el usuario en DACORES
--							de un puesto de trabajo, se cambia a outer apply con top 1>
-- Modificado:				<08/07/2021><Jose Gabriel Cordero Soto><Se realiza ajuste en la asignacion del estado de documento al itinerar hacia gestión>
-- Modificado:				<12/07/2021><Ronny Ramírez R.> <Se aplica mapeo con respecto al estado del escrito hacia Gestión>
-- Modificado:				<12/07/2021><Karol Jiménez Sánchez> <Se aplica ajuste campo TEXTO de DACO de Resoluciones, valor por defecto cuando Resumen es nulo>
-- Modificado:				<13/07/2021><Ronny Ramírez R.> <Se aplica cambio en mapeo de estado de escrito, cuando es Pendiente se mapea a 0003 (Tramitándose), según se vió con Sigifredo>
-- Modificado:				<13/07/2021><Jose Gabriel Cordero Soto><Se realiza ajuste para obtener contexto destino para asignar cuando el estado del documento es borrador o borrador publico>
-- Modificado:				<15/07/2021><Luis Alonso Leiva Tames><Se agrega en DACO el tipo de Escrito>
-- Modificado:				<04/08/2021><Ronny Ramírez R.><Se aplica filtro para que la consulta no traiga los documentos eliminados del expediente>
-- Modificado:				<10/08/2021><Ronny Ramírez R.><Se asigna valor por defecto por medio de configuración a campo CODESTRES requerido en @DACORES>
-- Modificado:				<08/10/2021><Ronny Ramírez R.><Se aplica ordenamiento ASC a la tabla @DACO para hacer que los IDACOs se vean en orden en el DataSet, pues la aplicación los espera ordenados> 
-- Modificado:				<03/12/2021><Luis Alonso Leiva Tames><Se realiza correccion ya que en las resoluciones estaba repitiendo los datos>
-- Modificación:			<29/09/2022><Ronny Ramírez R.> <Se agrega valor de TC_AnnoSentencia a VOTNUM>
-- Modificado:				<06/10/2022><Josué Quirós Batista><Se especifica el código del despacho origen de la itineración a la tabla tblArchivos.>
-- Modificado:				<07/03/2023><Josué Quirós Batista><Evitar obtener los escritos GUID predeterminado que no estén relacionados a la carpeta a itinerar.>
-- Modificado:				<20/03/2023> <Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo, FormatoJuridico, ResultadoResolucion,
--							TipoResolucion y TipoEscrito)>
-- =========================================================================================================================================================================================================
 CREATE  PROCEDURE [Itineracion].[PA_ConsultarDocumentosItineracionSIAGPJ]
 	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@DacoInicial				INT = 1
AS 
BEGIN
	--Variables 
	DECLARE	@L_TC_NumeroExpediente						CHAR(14),
			@L_TU_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL, 
			@L_DacoInicial								INT					= @DacoInicial,
			@L_TC_CodContextoOrigen						VARCHAR(4)			= NULL,
			@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_ValorDefectoCODESTRES					VARCHAR(3)			= NULL;

	-- Se consulta si la itineración está ligada a un Expediente o a un Legajo
	-- Siempre retorna el numero del Expediente
    SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_TC_CodContextoOrigen	= TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoRutaDescargaDocumentosFTP	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');
	SET	@L_ValorDefectoCODESTRES						= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CODESTRES_ResRecurso','');

	--*********************************************************************************************************************************
	--Definición de tabla temporal de documentos

	--Definición de tabla DOCTEMP
	DECLARE @DOCTEMP AS TABLE (
			[TU_CodArchivo]			UNIQUEIDENTIFIER	NOT NULL,-- Llaves de documentos SIAGPJ
			[DESPACHO_TRAMITE]		[varchar](4)		NULL,
			[USUARIO_LOGIN]			[varchar](50)		NOT NULL,
			[DESCRIPCION]			[varchar](255)		NULL,
			[FECHA]					[datetime2](3)		NULL,
			[NOMBRE]				[varchar](255)		NOT NULL,
			[IDPATH]				[varchar](255)		NOT NULL,
			[CODGT]					[varchar](9)		NULL,
			[TF_Particion]			[datetime2](3)		NOT NULL,
			[ES_APREMIO]			[bit]				NOT NULL,
			[TU_CodApremio]			[uniqueidentifier]	NULL,
			[IDACO]					[int]				NOT NULL,
			[CODMOD]				[varchar](12)		NULL,
			[CODESTACO]				[varchar](1)		NULL);

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

	--Definición de tabla DACODOCR Escritos
	DECLARE @DACODOCR AS TABLE (
			[CARPETA]		[varchar](14)		NOT NULL,
			[IDACO]			[int]				NULL,
			[IDDOC]			[int]				NULL,
			[FECENTRDD]		[datetime2](3)		NULL,
			[USURECEPTOR]	[varchar](50)		NULL,
			[IDPATH]		[varchar](255)		NULL,
			[DESCRIP]		[varchar](255)		NULL,
			[PUBLICADO]		[bit]				NOT NULL,
			[ESELECTRONICO] [int]				NULL,
			[FIRMADIGITAL]	[char](1)			NULL,
			[USU_ENTREGA]	[varchar](130)		NULL,
			[TRAMITADO]		[char](4)			NULL,
			[USERLEIDO]		[varchar](20)		NULL,
			[FECLEIDO]		[datetime]			NULL,
			[RESERVADO]		[bit]				NOT NULL,
			[PARACESIONMASIVA] [bit]			NOT NULL,
			[TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ

	-- Definición de tabla de Resoluciones
	DECLARE @DACORES AS TABLE (
			 [CARPETA]				[varchar](14)	NOT null
			,[IDACO]				[int]			NOT NULL
			,[CODJURIS]				[varchar](2)	NOT null
			,[CODRESUL]				[varchar](9)	null
			,[CODESTRES]			[varchar](3)	Not null
			,[FECEST]				[datetime2](3)	not null
			,[CODNUM]				[varchar](9)	null
			,[CODRES]				[varchar](4)	not null
			,[VOTNUM]				[varchar](10)	null
			,[JUEZ]					[varchar](11)	null
			,[FECDIC]				[datetime2](3)	null
			,[FECPUB]				[datetime2](3)	null
			,[RECURRIDA]			[varchar](1)	null
			,[CODRESREC]			[varchar](9)	null
			,[SELECCIONADO]			[varchar](1)	null
			,[CODESTENV]			[varchar](1)	null
			,[CODPRESENT]			[varchar](9)	null
			,[IDUSU]				[varchar](25)	null
			,[HUBOJUICIO]			[varchar](1)	null
			,[USUREDAC]				[varchar](25)	null	
			,[IDACOSENDOC]			[int]			null
			,[FECVOTO]				[datetime2](3)	null
			,[ACOPORDOC]			[text]			null
			,[ENVIADO_SINALEVI]		[varchar](1)	null
			,[RESUMEN]				[text]			null	
			,[FECVENCE]				[datetime2](3)	null
			,[OBSER_DATSENSI]		[varchar](250)	null,
			 [TU_CodArchivo]	UNIQUEIDENTIFIER	NOT NULL); -- Llaves de documentos SIAGPJ

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

	--*********************************************************************************************************************************
	-- Se llena tabla temporal con datos de SIAGPJ


	--DOCUMENTOS asociados a un Expediente o Legajo
	INSERT INTO	@DOCTEMP
	SELECT		 D.TU_CodArchivo																			-- ID SIAGPJ
				,D.TC_CodContextoCrea																		-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,D.TC_UsuarioCrea																			-- USUARIO_LOGIN -- IDUSU
				,D.TC_Descripcion																			-- DESCRIPCION DACO.TEXTO
				,D.TF_FechaCrea																				-- FECHA -- DACO:FECSYS
				,CONCAT(D.TU_CodArchivo, F.TC_Extensiones) AS NombreArchivo									-- NOMBRE -- DACODOC.NOMBRE
				,'1'																						-- IDPATH 
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0)-- Grupo de trabajo
				,D.TF_Particion																				-- TF_Particion
				,0																							-- ES_APREMIO
				,NULL																						-- TU_CodApremio
				,ISNULL(ROW_NUMBER() over (order by D.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial)	-- IDDACO
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'FormatoJuridico', D.TC_CodFormatoJuridico,0,0)-- CODMOD == CODTRAM
				,D.TN_CodEstado																				-- CODESTACO
	FROM		Archivo.Archivo					D	WITH(NOLOCK)
	INNER JOIN	Expediente.ArchivoExpediente	E	WITH(NOLOCK)
	ON			E.TU_CodArchivo					=	D.TU_CodArchivo
	LEFT JOIN	Expediente.LegajoArchivo		L	WITH(NOLOCK)
	ON			L.TU_CodArchivo					=	E.TU_CodArchivo
	INNER JOIN	Catalogo.FormatoArchivo			F	WITH(NOLOCK)
	ON			F.TN_CodFormatoArchivo			=	D.TN_CodFormatoArchivo
	WHERE		E.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			(	
					(
						@L_TU_CodLegajo			IS NULL 
						AND	L.TU_CodLegajo		IS NULL							
					)
					OR	
					(	
						@L_TU_CodLegajo			IS NOT NULL
						AND	L.TU_CodLegajo		=  @L_TU_CodLegajo
					)
				)
	AND			E.TB_Eliminado					=	0
	AND			NOT EXISTS						(SELECT	K.TU_CodArchivo 
												FROM	Comunicacion.ArchivoComunicacion	K WITH(NOLOCK)
												WHERE	K.TU_CodArchivo						= D.TU_CodArchivo) ;

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + DacoInicial
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP WHERE ES_APREMIO = 0;

	--DOCUMENTOS de apremios
	INSERT INTO	@DOCTEMP
	SELECT		 A.TC_IDARCHIVO																				-- ID SIAGPJ
				,A.TC_CodContexto																			-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,A.TC_UsuarioEntrega																		-- USUARIO_LOGIN -- DACO.IDUSU
				,A.TC_Descripcion																			-- DESCRIPCION DACO.TEXTO
				,A.TF_FechaEnvio																			-- FECCREACION -- DACO:FECSYS
				,CONCAT(A.TC_IDARCHIVO, '.desconocida')														-- NOMBRE -- DACODOC.NOMBRE
				,'1'																						-- IDPATH 
				,NULL																						-- Grupo de trabajo
				,A.TF_Particion																				-- TF_Particion
				,1																							-- ES_APREMIO
				,A.TU_CodApremio																			-- TU_CodApremio
				,ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial)	-- IDDACO
				,'APREMIOSOL'																				-- CODMOD
				,NULL																						-- CODESTACO
	FROM		Expediente.ApremioLegajo		A	WITH(NOLOCK) 
	WHERE		A.TU_CodLegajo				=	@L_TU_CodLegajo;

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + DacoInicial
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP  WHERE ES_APREMIO = 1;

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
	SELECT	   @L_Carpeta						--CARPETA
			   ,D.IDACO							--IDACO
			   ,1								--IDDOC
			   ,D.IDPATH						--IDPATH
			   ,ISNULL(D.CODMOD,'SIN_CODIGO')	--CODMOD
			   ,NULL							--CODICO
			   ,LEFT(D.NOMBRE,50)				--NOMBRE
			   ,0								--PUBLICADO
			   ,NULL							--FIRMADO
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP D

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + DacoInicial
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DOCTEMP  WHERE ES_APREMIO = 1;

	-- Se llenan los escritos de los expedientes
	INSERT INTO @DACODOCR
			   ([CARPETA]
			   ,[IDACO]
			   ,[IDDOC]
			   ,[FECENTRDD]
			   ,[USURECEPTOR]
			   ,[IDPATH]
			   ,[DESCRIP]
			   ,[PUBLICADO]
			   ,[ESELECTRONICO]
			   ,[FIRMADIGITAL]
			   ,[USU_ENTREGA]
			   ,[TRAMITADO]
			   ,[USERLEIDO]
			   ,[FECLEIDO]
			   ,[RESERVADO]
			   ,[PARACESIONMASIVA]
			   ,[TU_CodArchivo]
			   )
	SELECT		@L_Carpeta																						--CARPETA
			   ,ISNULL(ROW_NUMBER() over (order by E.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial)		--IDACO
			   ,1																								--IDDOC **consecutivo genera gestion migracion no se tiene.SNUM de gestion y obtener el que corresponde y meterlo
			   ,E.TF_FechaEnvio																					--FECENTRDD
			   ,NULL																							--USURECEPTOR
			   ,1																								--IDPATH
			   ,E.TC_Descripcion																				--DESCRIP
			   ,0																								--PUBLICADO
			   ,1																								--ESELECTRONICO
			   ,null																							--FIRMADIGITAL
			   ,P.TC_UsuarioRed																					--USU_ENTREGA
			   ,CASE	E.TC_EstadoEscrito
					WHEN 'P'	THEN	'0003'	-- Según lo indicó Olger Ovares y con visto bueno de Sigifredo, se aplica estado tramitándose cuando en SIAGPJ está Pendiente, pues en gestión no calza con Pendiente de Distribuir
					WHEN 'T'	THEN	'0003'	-- Tramitándose
					WHEN 'R'	THEN	'0004'	-- Resuelto					
					ELSE 'R'					-- Se pone por defecto en Resuelto
			    END																								--TRAMITADO
			   ,NULL																							--USERLEIDO
			   ,NULL																							--FECLEIDO
			   ,0																								--RESERVADO
			   ,0																								--PARACESIONMASIVA
			   ,E.TC_IDARCHIVO																					--IDArchivo
	FROM		Expediente.EscritoExpediente		E WITH(NOLOCK) 
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	P WITH(NOLOCK) 
	ON			E.TC_CodPuestoTrabajo				= P.TC_CodPuestoTrabajo 
	AND			(
					E.TF_FechaRegistro					>= P.TF_Inicio_Vigencia 
						AND (
								E.TF_FechaRegistro		<= P.TF_Fin_Vigencia 
								OR P.TF_Fin_Vigencia	IS NULL
						)
				)
	LEFT JOIN	Expediente.EscritoLegajo			L WITH(NOLOCK) 
	ON			E.TU_CodEscrito						= L.TU_CodEscrito
	WHERE		E.TC_NumeroExpediente =				CASE	WHEN @L_TU_CodLegajo IS NULL
																THEN @L_TC_NumeroExpediente 
															ELSE E.TC_NumeroExpediente 
													END
	AND
				(	
					(
						@L_TU_CodLegajo				IS NULL 
						AND	L.TU_CodLegajo			IS NULL							
					)
					OR	
					(	
						@L_TU_CodLegajo				IS NOT NULL
						AND	L.TU_CodLegajo			=  @L_TU_CodLegajo
					)
				)
	AND			E.TC_EstadoEscrito					<> 'E' -- Si está en traslado, significa que ya no pertenece al expediente, por lo que no se mapea

	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + DacoInicial
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DACODOCR;

	-- Insertamos en la tabla de DACORES las resoluciones 
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
				,OBSER_DATSENSI, 
				TU_CodArchivo)
	SELECT		@L_Carpeta																					-- [CARPETA]
				,ISNULL(ROW_NUMBER() over (order by D.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial)	-- [IDACO]
				,C.TC_CodMateria																			-- [CODJURIS]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'ResultadoResolucion', E.TN_CodResultadoResolucion,0,0)-- [CODRESUL]
				,@L_ValorDefectoCODESTRES																	-- [CODESTRES]
				,E.TF_Fecharesolucion																		-- [FECEST]
				,null																						-- [CODNUM]
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoResolucion', E.TN_CodTipoResolucion,0,0)-- [CODRES]
				,TRIM(L.TC_AnnoSentencia) + RIGHT('000000' + LEFT(TRIM(L.TC_NumeroResolucion),6),6)			-- [VOTNUM]  Da formato Gestión [Año(4 char)+Consecutivo(6 char)], trunca si se pasa de 10 caracteres
				,null																						-- [JUEZ]
				,E.TF_FechaCreacion																			-- [FECDIC]
				,null																						-- [FECPUB]
				,null																						-- [RECURRIDA]
				,null																						-- [CODRESREC]
				,E.TC_EstadoEnvioSAS																		-- [SELECCIONADO]
				,null																						-- [CODESTENV]
				,null																						-- [CODPRESENT]
				,ISNULL(P.TC_UsuarioRed, 'No identificado')													-- *[IDUSU] corresponde al usuario que genero el documento que se le va a realizar el registro de resolucion
				,null																						-- [HUBOJUICIO]	
				,ISNULL(P.TC_UsuarioRed, E.USUREDAC)														-- [USUREDAC]
				,D.IDACO																					-- *[IDACOSENDOC] corresponde al idaco del documento(daco)  
				,E.TF_FechaResolucion																		-- [FECVOTO]
				,E.TC_PorTanto																				-- [ACOPORDOC]
				,CASE																						-- [ENVIADO_SINALEVI] Si en SIAGPJ esta marcado corresponde a 'P'(si es N=0 : 1)
					WHEN E.TC_EstadoEnvioSAS = 'N' THEN 'N'
					WHEN E.TC_EstadoEnvioSAS = 'P' THEN 'P'
					WHEN E.TC_EstadoEnvioSAS = 'V' THEN 'E'
					ELSE 'A'
				END								
				,E.TC_Resumen																				-- [RESUMEN]
				,null																						-- [FECVENCE]
				,E.TC_DescripcionSensible																	-- [OBSER_DATSENSI]
				,E.TU_CodArchivo																			-- Llaves de documentos SIAGPJ
	FROM		Expediente.Resolucion				E WITH(NOLOCK) 
	LEFT JOIN	Expediente.LibroSentencia			L WITH(NOLOCK)
	ON			L.TU_CodResolucion					= E.TU_CodResolucion
	INNER JOIN	Expediente.Expediente				Ex WITH(NOLOCK) 
	ON			Ex.TC_NumeroExpediente				= E.TC_NumeroExpediente
	INNER JOIN	Catalogo.Contexto					C WITH(NOLOCK)
	ON			C.TC_CodContexto					= Ex.TC_CodContexto
	INNER JOIN	@DOCTEMP							D 
	ON			E.TU_CodArchivo						= D.TU_CodArchivo
	OUTER APPLY(
				SELECT	TOP 1 P.TC_UsuarioRed
				FROM	Catalogo.PuestoTrabajoFuncionario	P WITH(NOLOCK)
				WHERE	E.TU_RedactorResponsable			= P.TU_CodPuestoFuncionario) P
	WHERE		E.TC_NumeroExpediente				= @L_TC_NumeroExpediente;
	
	--Se ajusta el valor de la variable @L_DacoInicial con la cantidad de registros en DACO + DacoInicial
	SELECT @L_DacoInicial = (COUNT(*) + @L_DacoInicial ) FROM @DACORES;

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
	SELECT		D.IDACO					--id
			   ,D.IDACO					--idaco
			   ,0						--tipo
			   ,D.NOMBRE				--nombre
			   ,1						--idruta
			   ,CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
						ELSE '/'
				   END
				   ,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',D.NOMBRE)	--ruta
			   ,0						--comprimido
			   ,0						--adjunto		
			   ,@L_TC_CodContextoOrigen --coddej  
			   ,4						--ubicacion
			   ,0						--error
			   ,NULL					--errordesc
			   ,0						--tamanio
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP D;

	--Insertamos en la tabla tblArchivos los escritos 
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
	SELECT		D.IDACO			--id
			   ,D.IDACO			--idaco
			   ,0				--tipo
			   ,CONCAT(D.TU_CodArchivo, '.desconocida')--nombre
			   ,1				--idruta
			   ,CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
			   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
					ELSE '/'
			   END
			   ,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',D.TU_CodArchivo)	--ruta
			   ,0				--comprimido
			   ,0				--adjunto
			   ,COALESCE(@L_TC_CodContextoOrigen, '') --coddej
			   ,4				--ubicacion
			   ,0				--error
			   ,NULL			--errordesc
			   ,0				--tamanio
			   ,D.TU_CodArchivo
	FROM		@DACODOCR D 
	INNER JOIN	Expediente.EscritoExpediente	E WITH(NOLOCK)
	ON			D.TU_CodArchivo					= E.TC_IDARCHIVO
	Where		E.TC_NumeroExpediente			= @L_TC_NumeroExpediente;

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
	SELECT		@L_Carpeta																				--	CARPETA
				,D.IDACO																				--	IDACO				
				,D.DESPACHO_TRAMITE																		--	CODDEJ
				,COALESCE(D.FECHA, GETDATE())															--  FECHA
				,D.DESCRIPCION																			--  TEXTO
				,'EMI'																					--  CODACO
				,D.IDACO																				--  NUMACO
				,COALESCE(D.FECHA, GETDATE())															--  FECSYS
				,COALESCE(D.USUARIO_LOGIN, 'No identificado')											--  IDUSU
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
				,ISNULL(D.CODMOD,'SIN_CODIGO')															--	CODTRAM 'CODIGO DEL DOCUMENTO(REG_RESO)'	
				,NULL																					--	CODESTADIST
				,C.CODTIDEJ																				--	CODTIDEJ
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
	FROM		@DOCTEMP			D 
	INNER JOIN	Catalogo.Contexto	C WITH(NOLOCK)
	ON			D.DESPACHO_TRAMITE	= C.TC_CodContexto
	WHERE		ES_APREMIO			= 0;

	-- INSERTAMOS EN DACO Escritos 
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
	SELECT		@L_Carpeta																				-- CARPETA
				,D.IDACO																				-- IDACO
				,E.TC_CodContexto																		-- CODDEJ
				,D.FECENTRDD																			-- FECHA
				,D.DESCRIP																				-- TEXTO
				,'ESC'																					-- CODACO
				,D.IDACO																				 -- NUMACO
				,D.FECENTRDD																			-- FECSYS
				,ISNULL(D.USU_ENTREGA,'No identificado')												-- IDUSU
				,E.TC_CodContexto																		-- CODDEJUSR**
				,5																						--	CODESTACO
				,e.TF_FechaIngresoOficina																--  FECEST
				,NULL																					--	NUMFOL
				,NULL																					--	NUMFOLINI
				,NULL																					--	PIEZA
				,''																						--	CODPRO
				,NULL																					--	CODJUDEC
				,NULL																					--	CODJUTRA
				,'DOC_EXTER'																			--	CODTRAM
				,NULL																					--	CODESTADIST
				,C.CODTIDEJ																				--	CODTIDEJ
				,NULL																					--	IDACOREL
				,NULL																					--	CODREL
				,0																						--	PRIORI
				,NULL																					--	CODICO
				,'11;'																					--	AMPLIAR
				,NULL																					--	CANT
				,NULL																					--	CODGT
				,NULL																					--	CODESC
				,NULL																					--	FECENTRDD
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoEscrito', E.TN_CodTipoEscrito,0,0)--	CODTIPDOC
				,0																						--	OTRGEST
				,NULL																					--	IDENTREGA
				,NULL																					--	FINALIZAEXP
	FROM		@DACODOCR D 
	INNER JOIN	Expediente.EscritoExpediente	E WITH(NOLOCK)
	ON			E.TC_IDARCHIVO					= D.TU_CodArchivo
	INNER JOIN	Catalogo.Contexto				C WITH(NOLOCK)
	ON			E.TC_CodContexto				= C.TC_CodContexto
	WHERE		E.TC_NumeroExpediente			= @L_TC_NumeroExpediente
	AND			E.TN_CodTipoEscrito				NOT IN(
														SELECT	TC_Valor 
														FROM	Configuracion.ConfiguracionValor	WITH(NOLOCK)
														WHERE	TC_CodConfiguracion					= 'C_TipoEscritoDemandaInicial'
												);

	-- INSERTAMOS EN DACO Apremios
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
	SELECT		@L_Carpeta																					--	CARPETA
				,D.IDACO																					--	IDACO 
				,A.TC_CodContexto																			--	CODDEJ
				,A.TF_FechaIngresoOficina																	--	FECHA
				,A.TC_Descripcion																			--	TEXTO
				,'EMI'																						--	CODACO
				,D.IDACO																					--	NUMACO
				,A.TF_FechaIngresoOficina																	--	FECSYS
				,A.TC_UsuarioEntrega																		--	IDUSU
				,A.TC_CodContexto																			--	CODDEJUSR
				,5																							-- CODESTACO
				,A.TF_FechaEstado																			--	FECEST
				,NULL																						--	NUMFOL
				,NULL																						--	NUMFOLINI
				,NULL																						--	PIEZA
				,''																							--	CODPRO
				,NULL																						--	CODJUDEC
				,NULL																						--	CODJUTRA
				,'APREMIOSOL'																				--	CODTRAM
				,NULL																						--	CODESTADIST
				,C.CODTIDEJ																					--	CODTIDEJ
				,NULL																						--	IDACOREL
				,NULL																						--	CODREL
				,0																							--	PRIORI
				,NULL																						--	CODICO
				,'0;'																						--	AMPLIAR
				,NULL																						--	CANT
				,NULL																						--	CODGT
				,NULL																						--	CODESC
				,NULL																						--	FECENTRDD
				,NULL																						--	CODTIPDOC
				,0																							--	OTRGEST
				,NULL																						--	IDENTREGA
				,NULL																						--  FINALIZAEXP
	FROM		Expediente.ApremioLegajo	A WITH(NOLOCK)
	INNER JOIN	Catalogo.Contexto			C WITH(NOLOCK)
	ON			A.TC_CodContexto			= C.TC_CodContexto
	INNER JOIN	@DOCTEMP					D 
	ON			D.TU_CodApremio				= A.TU_CodApremio
	AND			D.ES_APREMIO				= 1
	WHERE		A.TU_CodLegajo				= @L_TU_CodLegajo;

	-- INSERTAMOS EN DACO Resoluciones 
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
	SELECT		DISTINCT 
				@L_Carpeta																				--	CARPETA
				,D.IDACO																				--	IDACO
				,E.TC_CodContexto																		--	CODDEJ
				,D.FECEST																				--	FECHA
				,ISNULL(E.TC_Resumen, 'Registrar Datos Resolución/Registrar Resolución/')				--	TEXTO
				,'RTS'																					--	CODACO
				,D.IDACO																				--	NUMACO
				,D.FECEST																				--	FECSYS
				,ISNULL(D.USUREDAC, 'No identificado')													--	IDUSU
				,E.TC_CodContexto																		--	CODDEJUSR
				,5																						--	CODESTACO
				,D.FECEST																				--	FECEST
				,NULL																					--	NUMFOL
				,NULL																					--	NUMFOLINI
				,NULL																					--	PIEZA
				,''																						--	CODPRO
				,NULL																					--	CODJUDEC
				,NULL																					--	CODJUTRA
				,'REG_RESO'																				--	CODTRAM
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
	FROM		@DACORES				D 
	INNER JOIN	Expediente.Resolucion	E WITH(NOLOCK)
	ON			D.TU_CodArchivo			= E.TU_CodArchivo
	INNER JOIN	Catalogo.Contexto		C WITH(NOLOCK)
	ON			E.TC_CodContexto		= C.TC_CodContexto;
				
	-- INSERTAMOS EN DACO Demandas
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
	SELECT		@L_Carpeta																				-- CARPETA
				,D.IDACO																				-- IDACO
				,E.TC_CodContexto																		-- CODDEJ
				,D.FECENTRDD																			-- FECHA
				,D.DESCRIP																				-- TEXTO
				,'ESC'																					-- CODACO
				,D.IDACO																				-- NUMACO
				,D.FECENTRDD																			-- FECSYS
				,ISNULL(D.USU_ENTREGA, 'No identificado')												-- IDUSU
				,E.TC_CodContexto																		-- CODDEJUSR**
				,5																						--	CODESTACO
				,e.TF_FechaIngresoOficina																--  FECEST
				,NULL																					--	NUMFOL
				,NULL																					--	NUMFOLINI
				,NULL																					--	PIEZA
				,''																						--	CODPRO
				,NULL																					--	CODJUDEC
				,NULL																					--	CODJUTRA
				,'DOC_DEMAN'																			--	CODTRAM
				,NULL																					--	CODESTADIST
				,C.CODTIDEJ																				--	CODTIDEJ
				,NULL																					--	IDACOREL
				,NULL																					--	CODREL
				,0																						--	PRIORI
				,NULL																					--	CODICO
				,'11;'																					--	AMPLIAR
				,NULL																					--	CANT
				,NULL																					--	CODGT
				,NULL																					--	CODESC
				,NULL																					--	FECENTRDD
				,NULL																					--	CODTIPDOC
				,0																						--	OTRGEST
				,NULL																					--	IDENTREGA
				,NULL																					--	FINALIZAEXP
	FROM		@DACODOCR D 
	INNER JOIN	Expediente.EscritoExpediente	E WITH(NOLOCK)
	ON			E.TC_IDARCHIVO					= D.TU_CodArchivo
	INNER JOIN	Catalogo.Contexto				C WITH(NOLOCK)
	ON			E.TC_CodContexto				= C.TC_CodContexto
	WHERE		E.TN_CodTipoEscrito				IN (
													SELECT	TC_Valor 
													FROM	Configuracion.ConfiguracionValor	WITH(NOLOCK)
													WHERE	TC_CodConfiguracion					= 'C_TipoEscritoDemandaInicial'
												);


	SELECT * FROM @DACO ORDER BY IDACO;
	
	SELECT * FROM @DACODOC;

	SELECT * FROM @DACODOCR;-- Escritos

	SELECT * FROM @DACORES; -- Resoluciones
	
	SELECT * FROM @tblArchivos;

	--DPATH
	SELECT  1												AS IDPATH,
			CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
						ELSE '/'
				   END
			 ,Convert(Varchar(36),@L_CodHistoricoItineracion)) AS 'PATH'

END
GO
