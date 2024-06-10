SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<01/03/2021>
-- Descripción :			<Permite consultar los registros de SolicitudExpediente y sus dependencias para enviar a registrar en DACOSOL>
-- =============================================================================================================================================================================
-- Modificado por:			<02/03/2020><Jose Gabriel Cordero Soto><Se agrega mapeo con DACO Y DACOINT>	 
-- Modificado por:			<02/03/2020><Richard Zuñiga Segura><Se cambia el valor de IDACOSOL de tabla DACOSOL>	
-- Modificado por:			<03/03/2020><Jose Gabriel Cordero Soto><Se actualiza las consultas a retornar para envio a gestion DACOSOL, DACOINT, DACO>	
-- Modificador por:			<04-03-2021><Luis Alonso Leiva Tames><Se ajusta el SP para insertar en la tabla DACO >
-- Modificado:				<06/04/2021><Karol Jiménez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificado:				<10/06/2021><Karol Jiménez Sánchez><Se corrige campo FECHA de DACO, para que se tome del TF_FechaCreacion de Expediente.SolicitudExpediente y no de 
--							TF_FechaEnvio como estaba>
-- Modificado:				<09/07/2021><Jose Gabriel Cordero Soto><Se agrega el CODIGO ESTADO del ARCHIVO en CODESTACO en @DOCTEMP y otras tablas que se necesitan>
-- Modificado:				<11/10/2021><Jose Gabriel Cordero Soto><Se ajusta SP para correcion en calculo de IDACO y relacion con documento>
-- Modificado:				<19/11/2021><Ronny Ramírez R.><Se aplica corrección en @DACO para que no haya ambiguedad por nuevo campo IDACO en tabla de Archivo.Archivo>
-- Modificado:				<03/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Clase Asunto y
--							EstadoItineracion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarSolicitudExpedienteTodosSIAGPJ]	
	@CodItineracion					Uniqueidentifier,
	@DacoInicial					INT = 1
AS
BEGIN

	--VARIABLES LOCALES
	DECLARE	@L_CodItineracion			UNIQUEIDENTIFIER				= @Coditineracion,		
			@L_CodLegajo				UNIQUEIDENTIFIER				= NULL,
			@L_CodContextoOrigen		VARCHAR(4)						= NULL,
			@L_Carpeta					VARCHAR(14)						= NULL,
			@L_DacoInicial				INT								= @DacoInicial,
			@L_NumeroExpediente			VARCHAR(14),				
			@L_UsuarioRed				VARCHAR(30)	

	--******************************************************************************************
	--DEFINIR TABLAS TEMPORALES

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
	)

	DECLARE @DACOINT AS TABLE
	(
		[CARPETA]					[varchar](14)		NOT NULL,
		[IDACO]						[int]				NOT NULL,
		[IDINT]						[int]				NOT NULL,
		[TU_CodSolicitudExpediente] [uniqueidentifier]	NULL
	)

	DECLARE @DACOSOL AS TABLE 
	(
		[CARPETA]					[varchar](14)	NOT NULL,
		[IDACO]						[int]			NOT NULL,
		[CODDEJDES]					[varchar](4)	NOT NULL,
		[DESCRIP]					[varchar](255)  NOT NULL,
		[CODTIDEJ]					[varchar](2)	NOT NULL,
		[CODCLAS]					[varchar](9)	NOT NULL,
		[CODESTITI]					[varchar](1)		NULL,
		[FECESTITI]					[datetime2](7)		NULL,
		[CODDEJ]					[varchar](4)		NULL, 
		[ID_NAUTIUS]				[varchar](255)		NULL,
		[CODRESUL]					[varchar](9)		NULL,
		[FECDEVOL]					[datetime2](7)		NULL,
		[CODPEN]					[varchar](3)		NULL,
		[IDACOSOL]					[int]				NULL,
		[IDUSUJUEZ]					[varchar](25)		NULL,
		[TU_CodArchivo]				[Uniqueidentifier]  NULL,
		[TF_FechaCreacion]			[datetime2](3)		NULL,
		[TU_CodSolicitudExpediente]	[UNIQUEIDENTIFIER]  NULL,
		[TC_NumeroExpediente]		[varchar](14)		NULL
	)

	--******************************************************************************************
	--OBTENER VALORES PARA CONSULTAS

	--OBTIENE EL USUARIO DEL HISTORICO DE ITINERACION
	SELECT @L_UsuarioRed				= A.TC_UsuarioRed
	FROM   Historico.Itineracion		A WITH(NOLOCK)	
	WHERE  A.TU_CodHistoricoItineracion	= @L_CodItineracion

	--SE OBTIENE EL NÚMERO DE EXPEDIENTE Y CÓDIGO DE LEGAJO SI EL HISTÓRICO ESTÁ RELACIONADO A UN LEGAJO
	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_CodContextoOrigen	= TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodItineracion);


	--******************************************************************************************
	--INSERCION DE VALORES EN TABLAS TEMPORALES

	--SE GENERA CONSULTA PARA MAPEO
	INSERT INTO		@DACOSOL
	SELECT			@L_Carpeta						CARPETA,
					ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial)	IDACO,	   
					A.TC_CodContextoDestino			CODDEJDES,
					A.TC_Descripcion				DESCRIP,
					E.CODTIDEJ						CODTIDEJ,  
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ClaseAsunto', A.TN_CodClaseAsunto,0,0),
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'EstadoItineracion', A.TN_CodEstadoItineracion,0,0),
					A.TF_FechaEnvio					FECESTITI,
					A.TC_CodContextoOrigen			CODDEJ,
					A.TU_CodHistoricoItineracion	ID_NAUTIUS,
					NULL							CODRESUL,
					NULL							FECDEVOL,
					NULL							CODPEN,
					NULL							IDACOSOL,   
					NULL							IDUSUJUEZ,
					F.TU_CodArchivo					TU_CodArchivo,
					A.TF_FechaCreacion				TF_FechaCreacion,
					A.TU_CodSolicitudExpediente		TU_CodSolicitudExpediente,
					A.TC_NumeroExpediente		    TC_NumeroExpediente
	FROM 			Expediente.SolicitudExpediente  A	WITH(NOLOCK)				
	INNER JOIN		Catalogo.Contexto				E	WITH (NOLOCK)
	ON				E.TC_CodContexto				=	A.TC_CodContextoDestino
	LEFT JOIN		Expediente.ArchivoExpediente	F   WITH (NOLOCK)
	ON				F.TU_CodArchivo					=   A.TU_CodArchivo	
	WHERE			A.TC_NumeroExpediente			=	@L_NumeroExpediente				
				
	--ACONTECIMIENTOS
	INSERT INTO @DACO
	SELECT		NULL					FECDOC,
				@L_Carpeta				CARPETA,
				A.IDACO					IDACO,
				CODDEJDES				CODDEJ,
				TF_FechaCreacion		FECHA,
				'Interponer solicitud'	TEXTO,
				'SOL'					CODACO,
				A.IDACO					NUMACO,
				TF_FechaCreacion		FECSYS,
				@L_UsuarioRed			IDUSU,
				CODDEJ					CODDEJUSR,
				CASE B.TN_CodEstado
					WHEN  4 THEN '5'
					ELSE B.TN_CodEstado
				END						CODESTACO,
				FECESTITI				FECEST,
				NULL					NUMFOL,
				NULL					NUMFOLINI,
				NULL					PIEZA,
				NULL					CODPRO,
				NULL					CODJUDEC,
				NULL					CODJUTRA,
				'INTER_SOL'				CODTRAM,
				NULL					CODESTADIST,
				CODTIDEJ				CODTIDEJ,
				NULL					IDACOREL,
				NULL					CODREL,
				0						PRIORI,
				NULL					CODICO,
				'7;'					AMPLIAR,
				NULL					CANT,
				NULL					CODGT,
				NULL					CODESC,
				NULL					FECENTRDD,
				NULL					CODTIPDOC,
				0						OTRGEST,   
				NULL					IDENTREGA,
				NULL					FINALIZAEXP
	FROM		@DACOSOL				A
	LEFT JOIN   Archivo.Archivo			B WITH(NOLOCK) 
	ON			B.TU_CodArchivo			= A.TU_CodArchivo

	--INTERVENCIONES
	INSERT INTO @DACOINT
	SELECT		@L_Carpeta						CARPETA,
				A.IDACO							IDACO,
				C.IDINT							IDINT,
				A.TU_CodSolicitudExpediente		TU_CodSolicitudExpediente
	FROM		@DACOSOL						 A
	INNER JOIN	Expediente.IntervencionSolicitud B	WITH(NOLOCK)
	ON			A.TU_CodSolicitudExpediente		 = B.TU_CodSolicitudExpediente
	INNER JOIN	Expediente.Intervencion			 C WITH(NOLOCK)
	ON			B.TU_CodInterviniente			 = C.TU_CodInterviniente
	WHERE		A.TC_NumeroExpediente			 = @L_NumeroExpediente			

	--******************************************************************************************
	--RESUTLADOS DE LAS CONSULTAS

	--CONSULTA FINAL
	SELECT  CARPETA,		IDACO,			CODDEJDES,		DESCRIP,
			CODTIDEJ,		CODCLAS,		CODESTITI,		FECESTITI,
			CODDEJ,			ID_NAUTIUS,		CODRESUL,		FECDEVOL, 
			CODPEN,			IDACOSOL,		IDUSUJUEZ,		TU_CodArchivo
	FROM	@DACOSOL

	SELECT  FECDOC,			CARPETA,	    IDACO,	 	   CODDEJ,
			FECHA,	 	    TEXTO,			CODACO,		   NUMACO,
			FECSYS,			IDUSU,			CODDEJUSR,	   CODESTACO,
			FECEST,	  	    NUMFOL,			NUMFOLINI,	   PIEZA,
			CODPRO,	  	    CODJUDEC,		CODJUTRA,	   CODTRAM,
			CODESTADIST,	CODTIDEJ,       IDACOREL,	   CODREL,
			PRIORI,	  	    CODICO,		    AMPLIAR,	   CANT,
			CODGT,	 	    CODESC,  	    FECENTRDD,     CODTIPDOC,
			OTRGEST,     	IDENTREGA,      FINALIZAEXP

	FROM    @DACO

	SELECT		CARPETA,		IDACO,			IDINT,			TU_CodSolicitudExpediente
	FROM		@DACOINT
	ORDER BY	IDACO

END
GO
