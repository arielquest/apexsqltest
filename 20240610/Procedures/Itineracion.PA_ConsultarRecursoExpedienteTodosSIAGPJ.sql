SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<03/03/2021>
-- DescripciOn :			<Permite consultar los registros de RecursoExpediente y sus dependencias para enviar a registrar en DACOREC, DACO, DACOINT>
-- =========================================================================================================================================================================================
-- Modificado por:			<03-03-2021><Jose Gabriel Cordero Soto><Se realiza actualización de campos en consulta de DACOREC con los valores no null que se pueden mapear>
-- Modificado por:			<04-03-2021><Jose Gabriel Cordero Soto><Se ajustan cambios en campos de tabla DACOREC>
-- Modificado por:			<04-03-2021><Luis Alonso Leiva Tames><Se ajusta el SP para insertar en la tabla DACO >
-- Modificado:				<06/04/2021><Karol Jimenez Sánchez><Se ajusta campos PRIORI y AMPLIAR de DACO>
-- Modificado:				<10/06/2021><Karol Jimenez Sánchez><Se corrige campo FECHA de DACO, para que se tome del TF_Fecha_Creacion de Expediente.RecursoExpediente y no de 
--							TF_Fecha_Recepcion como estaba>
-- Modificado:				<18/06/2021><Ronny Ramirez R.><Se agrega campo CODTIDEJ en tabla DACO y se pone un valor en la fecha de creación en caso que no venga>
-- Modificado:				<04/10/2021><Ronny Ramirez R.><Se aplica correcciOn en consulta final del campo CODTIDEJ en tabla DACO, ya que se le estaba asignando el valor de CODESTADIST>
-- Modificado por:			<16-06-2022><Luis Alonso Leiva Tames><Se ajusta el SP para muestre los IDACO correctos >
-- Modificado:				<03/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos TipoResolucion,
--							ResultadoResolucion y TipoIntervencion)>
-- =========================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarRecursoExpedienteTodosSIAGPJ]	
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
		[CODESTADIST]	[varchar](5)	NULL,
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
		[CARPETA]					[varchar](14)			NULL,
		[IDACO]						[int]				NOT NULL,
		[IDINT]						[int]					NULL,
		[TU_CodSolicitudExpediente] [uniqueidentifier]		NULL
	)

	DECLARE @DACOREC AS TABLE 
	(
		[CARPETA]			[varchar](14)		NULL,
		[IDACO]				[int]			NOT NULL,
		[CODDEJDES]			[varchar](4)	NOT NULL,
		[IDACOINT]			[int]				NULL,
		[VOTNUM]			[varchar](10)		NULL,
		[CODRES]			[varchar](4)		NULL,
		[CODPRESENT]		[varchar](9)		NULL,
		[CODREC]			[varchar](3)		NULL,
		[CODRESUL]			[varchar](9)		NULL,
		[FECDEVOL]			[datetime2](7)		NULL,
		[FECESTITI]			[datetime2](7)		NULL,
		[CODESTITI]			[varchar](1)		NULL,
		[IDACOREC]			[int]				NULL,
		[ID_NAUTIUS]		[varchar](255)		NULL,
		[IDUSUJUEZ]			[varchar](25)		NULL,
		TF_Fecha_Creacion	[datetime2](3)		NULL
	)

	--******************************************************************************************
	--OBTENER VALORES PARA CONSULTAS

	--OBTIENE EL USUARIO DEL HISTORICO DE ITINERACION
	SELECT @L_UsuarioRed				= A.TC_UsuarioRed
	FROM   Historico.Itineracion		A WITH(NOLOCK)
	WHERE  A.TU_CodHistoricoItineracion	= @L_CodItineracion

	--SE OBTIUENE EL NéMERO DE EXPEDIENTE Y CODIGO DE LEGAJO SI EL HISTORICO ESTA RELACIONADO A UN LEGAJO
	SELECT  @L_NumeroExpediente	= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_CodContextoOrigen	= TC_CodContextoOrigen,
			@L_Carpeta				= CARPETA
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodItineracion);

	--******************************************************************************************
	--INSERCION DE VALORES EN TABLAS TEMPORALES

	--SE GENERA CONSULTA PARA MAPEO
	INSERT INTO	@DACOREC 
	SELECT		@L_Carpeta						CARPETA,
				ISNULL(ROW_NUMBER() over (order by A.TF_Particion ASC) + @L_DacoInicial -1,@L_DacoInicial) IDACO,	   
				A.TC_CodContextoDestino			CODDEJDES,
				NULL							IDACOINT,	 
				NULL							VOTNUM,  
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoResolucion', F.TN_CodTipoResolucion,0,0),--CODRES
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'TipoIntervencion', A.TN_CodTipoIntervencion,0,0),--Aunque es CODINT es el equivalente a CODPRESENT
				'OTR'							CODREC,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'ResultadoResolucion', F.TN_CodResultadoResolucion,0,0),--CODRESUL
				A.TF_Fecha_Recepcion			FECDEVOL,
				H.TF_FechaEstado				FECESTITI,
				H.TN_CodEstadoItineracion		CODESTITI,									
				A.IDACOREC						IDACOREC,																		
				H.ID_NAUTIUS					ID_NAUTIUS,									
				NULL							IDUSUJUEZ,
				A.TF_Fecha_Creacion				TF_Fecha_Creacion
	FROM 		Expediente.RecursoExpediente    A	WITH (NOLOCK)
	LEFT JOIN	Expediente.Resolucion			F	WITH (NOLOCK)
	ON			A.TU_CodResolucion				=	F.TU_CodResolucion
	OUTER APPLY	(
					SELECT	TOP(1) Z.TF_FechaEstado, Z.TN_CodEstadoItineracion, Z.ID_NAUTIUS
					FROM	Historico.Itineracion			Z WITH (NOLOCK)
					WHERE	Z.TU_CodHistoricoItineracion	= A.TU_CodHistoricoItineracion
					ORDER BY Z.TF_FechaEstado DESC
				) H
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente					
				
	INSERT INTO @DACO
	SELECT		NULL								FECDOC,
				@L_Carpeta							CARPETA,
				A.IDACO								IDACO,
				A.CODDEJDES							CODDEJ,
				ISNULL(A.TF_Fecha_Creacion, GETDATE())		FECHA,
				'Admisión y remisión del Recurso'	TEXTO,		
				'INR'								CODACO,		
				A.IDACO								NUMACO,
				ISNULL(A.TF_Fecha_Creacion, GETDATE())		FECSYS,
				@L_UsuarioRed						IDUSU,
				A.CODDEJDES							CODDEJUSR,
				'5'									CODESTACO,
				ISNULL(A.FECDEVOL, GETDATE())		FECEST,
				NULL								NUMFOL,
				NULL								NUMFOLINI,
				NULL								PIEZA,
				''									CODPRO,
				NULL								CODJUDEC,
				NULL								CODJUTRA,
				'INTER_REC'							CODTRAM,  
				NULL								CODESTADIST,
				E.CODTIDEJ							CODTIDEJ,
				NULL								IDACOREL,
				NULL								CODREL,
				0									PRIORI,
				NULL								CODICO,
				'2;'								AMPLIAR,
				NULL								CANT,
				NULL								CODGT,
				NULL								CODESC,
				NULL								FECENTRDD,
				NULL								CODTIPDOC,
				0									OTRGEST,   
				NULL								IDENTREGA,
				NULL								FINALIZAEXP
	FROM		@DACOREC						A
	INNER JOIN	Catalogo.Contexto				E	WITH (NOLOCK)
	ON			E.TC_CodContexto				=	A.CODDEJDES;
			
	INSERT INTO @DACOINT  
	SELECT		@L_Carpeta						CARPETA,
				@L_DacoInicial					IDACO,
				C.IDINT							IDINT,
				A.TU_CodRecurso					TU_CodRecurso
	FROM		Expediente.RecursoExpediente	A
	INNER JOIN	Expediente.IntervencionRecurso  B	WITH(NOLOCK)
	ON			A.TU_CodRecurso					= B.TU_CodRecurso
	INNER JOIN	Expediente.Intervencion			C WITH(NOLOCK)
	ON			C.TU_CodInterviniente			= B.TU_CodInterviniente
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
			
	--******************************************************************************************
	--RESULtADOS DE LAS CONSULTAS

	--CONSULTA FINAL
	SELECT  CARPETA,		IDACO,	   		CODDEJDES,		IDACOINT,
			VOTNUM,  		CODRES,			CODPRESENT,		CODREC,
			CODRESUL,		FECDEVOL,		FECESTITI,		CODESTITI,	
			IDACOREC,		ID_NAUTIUS,		IDUSUJUEZ	
	FROM	@DACOREC

	SELECT FECDOC,			CARPETA,	    IDACO,	 	   CODDEJ,
		   FECHA,	 	    TEXTO,			CODACO,		   NUMACO,
		   FECSYS,			IDUSU,			CODDEJUSR,	   CODESTACO,
		   FECEST,	  	    NUMFOL,			NUMFOLINI,	   PIEZA,
		   CODPRO,	  	    CODJUDEC,		CODJUTRA,	   CODTRAM,
		   CODESTADIST,		CODTIDEJ,       IDACOREL,	   CODREL,
		   PRIORI,	  	    CODICO,		    AMPLIAR,	   CANT,
		   CODGT,	 	    CODESC,  	    FECENTRDD,     CODTIPDOC,
		   OTRGEST,     	IDENTREGA,      FINALIZAEXP
	FROM   @DACO

	SELECT CARPETA,			IDACO,			IDINT
	FROM   @DACOINT

END
GO
