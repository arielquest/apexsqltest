SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<18/05/2021>
-- Descripción :			<Permite consultar las audiencias una itineracion de expediente o legajo para enviarlas a Gestión>
--==============================================================================================================================================================================
-- Modificación:			<10/08/2021><Jonathan Aguilar Navarro><Se agregar a la tabla DACODOCR el campo TU_CodArchvivo>
-- Modificación:			<13/07/2022><Luis Alonso Leiva Tames><Se modifica la ruta para tblArchivo>
-- Modificación:			<09/08/2022><Luis Alonso Leiva Tames><Se agrega un nuevo parametro recibe la direccion de los multimedios>
-- Modificación:			<06/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo TipoAudiencia)>
--==============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarAudienciasSIAGPJ]
	@CodHistoricoItineracion					UNIQUEIDENTIFIER	= NULL,
	@DacoInicial								INT					= 1, 
	@ValorDefectoRutaDescargaDocumentosFTP		VARCHAR(255)		= NULL
AS
BEGIN

	--VARIABLES LOCALES
	DECLARE	@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,		
			@L_CodLegajo								UNIQUEIDENTIFIER	= NULL,
			@L_CodContextoOrigen						VARCHAR(4)			= NULL,
			@L_CODTIDEJDESTINO							VARCHAR(2)			= NULL,
			@L_CodContextoDestino						VARCHAR(4)			= NULL,
			@L_Carpeta									VARCHAR(14)			= NULL,
			@L_NumeroExpediente							VARCHAR(14),		
			@L_DacoInicial								INT					= @DacoInicial, 
			@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= @ValorDefectoRutaDescargaDocumentosFTP;
		
	--OBTIENE EL USUARIO DEL HISTORICO DE ITINERACION
	SELECT		@L_CodContextoDestino			=	A.TC_CodContextoDestino,
				@L_CODTIDEJDESTINO				=	B.CODTIDEJ
	FROM		Historico.Itineracion			A	WITH(NOLOCK)
	INNER JOIN	Catalogo.Contexto				B	WITH(NOLOCK)
	ON			B.TC_CodContexto				=	A.TC_CodContextoDestino
	WHERE		A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion

	--SE OBTIENE EL NÚMERO DE EXPEDIENTE Y CÓDIGO DE LEGAJO SI EL HISTÓRICO ESTÁ RELACIONADO A UN LEGAJO
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_CodContextoOrigen	= TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

	--Definición de tablas temporales 
	DECLARE @AUDIENCIAS AS TABLE
	(
		TEXTO			VARCHAR (255),
		NOMBREARCHIVO	VARCHAR	(255),
		IDACO			INT,
		CODDEJ			VARCHAR(4),
		FECHA			DATETIME2(3),
		NUMACO			INT,
		IDUSU			VARCHAR(25),
		CODTIPDOC		INT,
		CANTARCH		INT,
		DURACION		VARCHAR(50),
		ESTADO			CHAR(1),
		ESTADOPUBLICACION INT,
		SISTEMA			CHAR(1),
		IDACO_ORIGINAL	INT,
		IDMULTI			NUMERIC(12, 0) IDENTITY(1,1) NOT NULL,
		NUMEROEXPEDIENTE VARCHAR(14)
	)

	IF @L_CodLegajo IS NULL
	BEGIN 
		INSERT INTO	@AUDIENCIAS
		SELECT		A.TC_Descripcion,
					A.TC_NombreArchivo,
					ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),
					A.TC_CodContextoCrea,
					A.TF_FechaCrea,
					ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),
					A.TC_UsuarioRedCrea,
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoAudiencia', A.TN_CodTipoAudiencia,0,0), --CODTIPDOC
					A.TN_CantidadArchivos - 1,
					TC_Duracion,
					CASE WHEN A.TC_Estado = 'N' THEN 0
						  WHEN A.TC_Estado = 'S' THEN 1
					END,
					A.TN_EstadoPublicacion,
					A.SISTEMA,
					A.TN_CodAudiencia,
					A.TC_NumeroExpediente
		FROM		Expediente.Audiencia	A	WITH(NOLOCK)
		WHERE		TC_NumeroExpediente		=	@L_NumeroExpediente
		AND			A.TN_CodAudiencia		NOT IN	(SELECT TN_CodAudiencia FROM Expediente.AudienciaLegajo WITH(NOLOCK))
	END
	ELSE
	BEGIN 
		INSERT INTO	@AUDIENCIAS
		SELECT		B.TC_Descripcion,
					B.TC_NombreArchivo,
					ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),
					B.TC_CodContextoCrea,
					B.TF_FechaCrea,
					ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial),
					B.TC_UsuarioRedCrea,
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoAudiencia', B.TN_CodTipoAudiencia,0,0), --CODTIPDOC
					B.TN_CantidadArchivos - 1,
					TC_Duracion,
					CASE WHEN B.TC_Estado = 'N' THEN 0
						  WHEN B.TC_Estado = 'S' THEN 1
					END,
					B.TN_EstadoPublicacion,
					B.SISTEMA,
					B.TN_CodAudiencia,
					B.TC_NumeroExpediente
		FROM		Expediente.AudienciaLegajo	A	WITH(NOLOCK)
		INNER JOIN  Expediente.Audiencia		B	WITH(NOLOCK)
		ON			B.TN_CodAudiencia			=	A.TN_CodAudiencia
		WHERE		A.TU_CodLegajo				=	@L_CodLegajo
	END

	DECLARE @DACO AS TABLE (
			[FECDOC]		[datetime2](7)	NULL,
			[CARPETA]		[varchar](14)	NULL,
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
			[CODTIDEJ]		[varchar](2)	NULL,
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
	)

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
			[TU_CodArchivo] [uniqueidentifier]	NULL); 				

	DECLARE @DMULTIMEDIA AS TABLE (
			[IDMULTI]			[numeric](12, 0) IDENTITY(1,1) NOT NULL,
			[CARPETA]			[varchar](14)		NOT NULL,
			[IDACO]				[int]			NOT NULL,
			[CODDEJ]			[varchar](4)	NOT NULL,
			[CANTARCH]			[int]			NOT NULL,
			[DURACION]			[varchar](50)	NOT NULL,
			[TAMANNO]			[varchar](50)	NOT NULL,
			[DESCRIP]			[varchar](255)	NOT NULL,
			[BLOQUEADO]			[bit]			NOT NULL,
			[SINCRONIZADO]		[bit]			NOT NULL,
			[RUTAORIGEN]		[varchar](260)	NULL,
			[MAQUINA]			[varchar](16)	NULL,
			[ESTADO]			[smallint]		NOT NULL,
			[DESPACHO_CREA]		[varchar](4)	NULL,
			[SISTEMA]			[char](1)		NOT NULL,
			[IDACO_ORIGINAL]	[int]			NOT NULL);	

	DECLARE @DMULTIMEDIANOTA AS TABLE
	(
		[IDMULTI]			[numeric](12, 0)	NOT NULL,
		[IDNOTA]			[int]				NOT NULL,
		[DESCRIP]			[varchar](255)		NOT NULL,
		[TIEMPOGRABACION]	[varchar](50)		NOT NULL,
		[TIEMPOARCHIVO]		[varchar](50)		NOT NULL,
		[NOMBREARCH]		[varchar](50)		NOT NULL,
		[PRIVADO]			[bit]				NOT NULL
	)

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
	
	INSERT INTO @DACO
	SELECT		A.FECHA					AS FECDOC,
				@L_CARPETA				AS CARPETA,
				A.IDACO					AS IDACO,
				@L_CodContextoDestino	AS CODDEJ,
				A.FECHA					AS FECHA,
				A.TEXTO					AS DESCRIPCION,
				'INDOMULT'				AS CODACO,
				A.IDACO					AS NUMACO,
				A.FECHA					AS FECHASYS,
				A.IDUSU					AS IDUSU,
				@L_CodContextoOrigen	AS CODDEJUSR,
				'5'						AS CODESTACO,
				A.FECHA					AS FECEST,
				0						AS NUMFOL,
				NULL					AS NUMFOLINI,
				1						AS PIEZA,
				NULL					AS CODPRO,
				NULL					AS CODJUDEC,
				NULL					AS CODJUTRA,
				'DOC_EXTER'				AS CODTRAM,
				NULL					AS CODESTADIST,
				@L_CODTIDEJDESTINO		AS CODTIDEJ,
				NULL					AS IDACOREL,
				NULL					AS CODREL,
				0						AS PRIORI,
				NULL					AS CODICO,
				'11;'					AS AMPLIAR,
				NULL					AS CANT,
				NULL					AS CODGT,
				NULL					AS CODESC,
				NULL					AS FECENTRDD,
				CODTIPDOC				AS CODTIPDOC,
				1						AS OTRGEST,
				NULL					AS IDENTREGA,
				NULL					AS FINALIZAEXP
	FROM		@AUDIENCIAS	A 

	INSERT INTO @DACODOCR
	SELECT		@L_Carpeta		AS CARPETA,
				A.IDACO			AS IDACO,
				2				AS IDDOC,
				NULL			AS FECENTRDD,
				NULL			AS USURECEPTOR,
				1				AS IDPTAH,
				A.NOMBREARCHIVO	AS DESCRIPCION,
				0				AS PUBLICADO,
				1				AS ESELECTRONICO,
				'N'				AS FIRMADIGITAL,
				A.IDUSU			AS USU_ENTREGA,
				'N'				AS TRAMITADO,
				NULL			AS USERLEIDO,
				NULL			AS FECLEIDO,
				0				AS RESERVADO,
				0				AS PARACESIONMASIVA,
				'00000000-0000-0000-0000-000000000000' AS TU_CodArchivo
	FROM		@AUDIENCIAS			A

	INSERT INTO @DMULTIMEDIA
	SELECT		@L_Carpeta					AS CARPETA,
				A.IDACO						AS IDACO,
				@L_CodContextoDestino		AS CODDEJ,
				CANTARCH					AS CANTARCH,
				DURACION					AS DURACION,
				1							AS TAMANNO,
				TEXTO						AS DESCRIP,
				0							AS BLOQUEADO,
				ESTADO						AS SINCRONIZADO,
				NULL						AS RUTAORIGEN,
				NULL						AS MAQUINA,
				A.ESTADOPUBLICACION			AS ESTADO,
				A.CODDEJ					AS DESPACHO_CREA,
				A.SISTEMA					AS SISTEMA,
				A.IDACO_ORIGINAL			AS IDACO_ORIGINAL	
	FROM		@AUDIENCIAS					A

	INSERT INTO @DMULTIMEDIANOTA
	SELECT		B.IDMULTI						AS IDMULTI,
				ISNULL(ROW_NUMBER() over (PARTITION BY A.TN_CodAudiencia order by A.TF_Particion),0)	AS IDNOTA,
				A.TC_Etiqueta					AS DESCRIP,
				A.TC_TiempoArchivo				AS TIEMPOGRABACION,
				A.TN_TiempoMilisegundos 		AS TIEMPOARCHIVO,
				A.TC_NombreArchivo				AS NOMBREARCH,
				A.TB_TipoEtiqueta				AS PRIVADO
	FROM		Expediente.EtiquetaAudiencia	A WITH(NOLOCK)
	INNER JOIN	@AUDIENCIAS						B
	ON			B.IDACO_ORIGINAL				= A.TN_CodAudiencia
	where		B.NUMEROEXPEDIENTE				= @L_NumeroExpediente

	INSERT INTO @tblArchivos
	SELECT		A.IDACO						AS ID,
				A.IDACO						AS IDACO,
				1							AS TIPO,
				A.NOMBREARCHIVO				AS NOMBRE,
				1							AS IDRUTA,
				CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
				CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
				ELSE '/'
	     		   END
				,A.NOMBREARCHIVO) AS RUTA,
				0							AS COMPRIMIDO,
				0							AS ADJUNTO,
				@L_CodContextoDestino		AS CODDEJ,
				4							AS UBICACION,
				0							AS ERROR,
				NULL						AS ERRODESC,
				0							AS TAMANIO,
				'00000000-0000-0000-0000-000000000000' AS TU_CodArchivo
	FROM		@AUDIENCIAS					A


	SELECT * FROM @DACO;
	SELECT * FROM @DACODOCR;
	SELECT * FROM @DMULTIMEDIA;
	SELECT * FROM @DMULTIMEDIANOTA
	SELECT * FROM @tblArchivos
END
GO
