SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<04/07/2022>
-- Descripción :		<Permite consultar los documentos de tipo multimedia asociados a un expediente / legajo de SIAGPJ mapeado a registros de Gestión con sus catálogos respectivos>
-- ======================================================================================================================================================================================================
-- Modificación:		<08/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos GrupoTrabajo y FormatoJuridico)>
-- ======================================================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarMultimediosItineracionSIAGPJ]
 	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@DacoInicial				INT = 1,
	@RutaFTPMultimedia			VARCHAR(255)
AS 
BEGIN
	--Variables 
	DECLARE	@L_TC_NumeroExpediente						CHAR(14),
			@L_TU_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= @RutaFTPMultimedia,
			@L_Carpeta									VARCHAR(14)			= NULL, 
			@L_DacoInicial								INT					= @DacoInicial,
			@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_TC_CodContextoOrigen						VARCHAR(4)			= NULL;

	-- Se consulta si la itineración está ligada a un Expediente o a un Legajo
	-- Siempre retorna el numero del Expediente
    SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--*********************************************************************************************************************************
	--Definición de tabla temporal de documentos multimedia

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

	--Definición de tabla DACODOCR para documentos multimedia
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


	--DOCUMENTOS multimedia asociados a un Expediente o Legajo
	INSERT INTO	@DOCTEMP
	SELECT		 D.TU_CodArchivo																			-- ID SIAGPJ
				,D.TC_CodContextoCrea																		-- DESPACHO_TRAMITE -- DACO.CODDEJ
				,D.TC_UsuarioCrea																			-- USUARIO_LOGIN -- IDUSU
				,D.TC_Descripcion																			-- DESCRIPCION DACO.TEXTO
				,D.TF_FechaCrea																				-- FECHA -- DACO:FECSYS
				,CONCAT(E.TC_NumeroExpediente, '_', D.TU_CodArchivo, F.TC_Extensiones) AS NombreArchivo		-- NOMBRE -- DACODOC.NOMBRE
				,'1'																						-- IDPATH 
				,Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'GrupoTrabajo', E.TN_CodGrupoTrabajo,0,0)-- CODGT - Grupo de trabajo
				,D.TF_Particion																				-- TF_Particion
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
	AND			D.TB_Multimedia					=	1
	AND			(	
					(
						@L_TU_CodLegajo					IS NULL 
						AND	L.TU_CodLegajo				IS NULL							
					)
					OR	
					(	
						@L_TU_CodLegajo					IS NOT NULL
						AND	L.TU_CodLegajo				=	@L_TU_CodLegajo
					)
				)
	AND			E.TB_Eliminado					=	0
	AND			NOT EXISTS(SELECT K.TU_CodArchivo FROM Comunicacion.ArchivoComunicacion K WITH(NOLOCK)
						   WHERE K.TU_CodArchivo = D.TU_CodArchivo) ;

	-- Se llenan los documentos multimedia
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
	SELECT
			    @L_Carpeta																						--CARPETA
			   ,D.IDACO																							--IDACO
			   ,1																								--IDDOC **consecutivo genera gestion migracion no se tiene.SNUM de gestion y obtener el que corresponde y meterlo
			   ,NULL																							--FECENTRDD
			   ,NULL																							--USURECEPTOR
			   ,1																								--IDPATH
			   ,D.NOMBRE																						--DESCRIP
			   ,0																								--PUBLICADO
			   ,NULL																							--ESELECTRONICO
			   ,'N'																								--FIRMADIGITAL
			   ,NULL																							--USU_ENTREGA
			   ,NULL																							--TRAMITADO
			   ,NULL																							--USERLEIDO
			   ,NULL																							--FECLEIDO
			   ,0																								--RESERVADO
			   ,0																								--PARACESIONMASIVA
			   ,D.TU_CodArchivo																					--IDArchivo
	FROM		@DOCTEMP D;

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
			   ,1				--idruta
			   ,CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
						ELSE '/'
				   END
				   ,D.NOMBRE)	--ruta
			   ,0				--comprimido
			   ,0				--adjunto		
			   ,D.DESPACHO_TRAMITE  --coddej 
			   ,4				--ubicacion
			   ,0				--error
			   ,NULL			--errordesc
			   ,0				--tamanio
			   ,D.TU_CodArchivo
	FROM		@DOCTEMP D;

	-- INSERTAMOS EN DACO Todos los documentos multimedia
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
				@L_Carpeta											--	CARPETA
				,D.IDACO											--	IDACO				
				,D.DESPACHO_TRAMITE									--	CODDEJ
				,COALESCE(D.FECHA, GETDATE())						--  FECHA
				,D.DESCRIPCION										--  TEXTO
				,'INDO'												--  CODACO
				,D.IDACO											--  NUMACO
				,COALESCE(D.FECHA, GETDATE())						--  FECSYS
				,COALESCE(D.USUARIO_LOGIN, 'No identificado')		--  IDUSU
				,D.DESPACHO_TRAMITE									--  CODDEJUSR
				,CASE D.CODESTACO			
					WHEN 4 THEN '5'
					ELSE D.CODESTACO			
				 END												--	CODESTACO
				,COALESCE(D.FECHA, GETDATE())						--	FECEST
				,NULL												--	NUMFOL
				,NULL												--	NUMFOLINI
				,NULL												--	PIEZA
				,''													--	CODPRO
				,NULL												--	CODJUDEC
				,NULL												--	CODJUTRA
				,'DOC_SEN'											--	CODTRAM	
				,NULL												--	CODESTADIST
				,C.CODTIDEJ											--	CODTIDEJ
				,NULL												--	IDACOREL
				,NULL												--	CODREL
				,0													--	PRIORI
				,NULL												--	CODICO
				,'0;'												--	AMPLIAR
				,NULL												--	CANT
				,NULL												--	CODGT
				,NULL												--	CODESC
				,NULL												--	FECENTRDD
				,NULL												--	CODTIPDOC
				,0													--	OTRGEST			   
				,NULL												--	IDENTREGA
				,NULL												--	FINALIZAEXP
	FROM		@DOCTEMP			D 
	INNER JOIN	Catalogo.Contexto	C WITH(NOLOCK)
	ON			D.DESPACHO_TRAMITE	= C.TC_CodContexto


	SELECT * FROM @DACO ORDER BY IDACO;

	SELECT * FROM @DACODOCR;
		
	SELECT * FROM @tblArchivos;

	--DPATH
	SELECT  1												AS IDPATH,
			CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
						ELSE '/'
				   END
				   ) AS 'PATH'

END
GO
