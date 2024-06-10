SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================================================================================================
-- Version:				<1.0>
-- Creado por:			<Karol Jimenez >
-- Fecha de creacion:	<15/01/2021>
-- Descripcion :		<Permite consultar intervenciones de tipo Parte y Representante de SIAGPJ con cat logos o tablas equivalentes del Gestión>
-- =======================================================================================================================================================================================
-- Modificacion: 		<22/01/2021><Jose Gabriel Cordero Soto><Se realiza la inclusion del resultao de DINTENT> 
-- Modificacion:		<28/01/2021><Jose Gabriel Cordero Soto><Se realiza ajuste en consulta de DINTPER actualizando los registros de ESDISCAPAC> 
-- Modificacion:		<09/02/2021><Karol Jimenez Sanchez> <Se modifica para incluir consulta de CARPETA>
-- Modificacion:		<11/02/2021><Karol Jimenez Sanchez> <Se modifica para incluir consulta de IDINT>
-- Modificacion:		<16/02/2021><Karol Jimenez Sanchez> <Se modifica para incluir consulta de DDOM>
-- Modificacion:		<03/03/2021><Karol Jimenez Sanchez> <Se modifica para corregir consulta de domicilios -y tel‚fonos, evitar duplicados, y separarlos en querys distintos>
-- Modificacion:		<12/03/2021><Jonathan Aguilar Navarro> <Se agrega al mapeo el campo lugar de trabajo del interviniente>
-- Modificacion:		<19/03/2021><Karol Jimenez Sanchez> <Se ajusta DINT de representantes, se agrega DPROF de representantes y se corrije CODREP de DINTREP (estaba retornando 0)>
-- Modificacion:		<09/06/2021><Karol Jimenez Sanchez> <Se ajusta para que se consulten los medios de comunicación propios del legajo o expediente, segun sea el caso>
-- Modificacion:		<28/06/2021><Jose Gabriel Cordero Soto> <Se agrega campo IND_TURISTA para mapero hacia gestion sobre los interveinientes>
-- Modificacion:		<16/07/2021><Jose Gabriel Cordero Soto> <Se ajusta para que en caso de que IND_TURISTA sea NULL coloque 0, porque en Gestion el campo no admite nulos>
-- Modificacion:		<13/08/2021><Ronny Ramirez R.> <Se aplica un truncado al asignar el # de identificación en el campo NUMLIC de DINTPER, pues tiene m ximo 20 caracteres>
-- Modificacion:		<02/03/2022><Luis Alonso Leiva Tames> <Se aplica cambio en la subconsulta al obtener medios de comunicación>
-- Modificacion:		<21/03/2022><Luis Alonso Leiva Tames> <Valida si es Expediente o Legajo, en caso del expediente excluir los intervinientes del legajos>
-- Modificación:		<08/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos TipoMedioComunicacion, 
--						SituacionLaboral, Parentesco, TipoIntervencion, TipoIdentificacion, EstadoCivil, Etnia, Escolaridad, Profesion, Provincia y Licencia)>
-- =======================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarIntervencionesSiagpj]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS 
BEGIN
	--Variables 
	DECLARE	@L_TC_NumeroExpediente					CHAR(14),
			@L_TU_CodLegajo							UNIQUEIDENTIFIER	= NULL,
			@L_Carpeta								VARCHAR(14),
			@L_ValorDefectoTipoRepresentacion		VARCHAR(3)			= NULL,
			@L_ValorDefectoTipoIntervencionRep		VARCHAR(3)			= NULL,
			@L_ValorDefectoSexo						VARCHAR(3)			= NULL,
			@L_ValorDefectoCodProfRepresentantes	VARCHAR(3)			= NULL,
			@L_TC_CodContextoOrigen					VARCHAR(4)			= NULL;

	--SE REALIZA LA CREACION DE LAS TABLAS TEMPORALES QUE RETORNARAN RESULTADOS
	Declare @Intervinientes As Table (
		TU_CodInterviniente			VARCHAR(36)		NOT NULL,
		IDINT						BIGINT			NULL);

	Declare @DINTREP As Table (
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

	Declare @DINT As Table (
		CARPETA						VARCHAR(14)			NOT NULL,
		IDINT						INT					NOT NULL,
		CODINT						VARCHAR(3)			NOT NULL,
		CODMEDCOM					VARCHAR(1)			NULL,
		IDDOMI						INT					NULL,--SE LLENA EN MAPEO DE DOMICILIOS
		IDDOMINOT					INT					NULL,
		CODSIT						VARCHAR(9)			NULL,
		FECSIT						DATETIME2(3)		NULL,
		CODECO						VARCHAR(4)			NULL,
		CODFIJU						VARCHAR(1)			NOT NULL,
		ALIAS						VARCHAR(255)		NULL,
		OBSERV						VARCHAR(255)		NULL,
		EDAD						INT					NULL,
		CODCATBEN					VARCHAR(2)			NULL,
		RECURRENTE					BIT					NOT NULL,
		LUGRESIDE					VARCHAR(255)		NULL,
		CODLAB						VARCHAR(3)			NULL,
		LUGTRAB						VARCHAR(255)		NULL,
		DIRLUGTRAB					VARCHAR(255)		NULL,
		CODMEDCOMACC				VARCHAR(1)			NULL,
		IDDOMINOTACC				INT					NULL,
		CODRELAC					VARCHAR(9)			NULL,
		DESISTE						BIT					NOT NULL,
		NOTIFICADO					BIT					NOT NULL,
		DESHABILITADA				BIT					NOT NULL,
		IND_TURISTA					BIT					NULL,
		TU_CodMedioComunicacion		UNIQUEIDENTIFIER	NULL,
		TU_CodMedioComunicacionAcc	UNIQUEIDENTIFIER	NULL,
		TU_CodDomicilio				UNIQUEIDENTIFIER	NULL);

	Declare @DINTPER As Table (
		IDINT					INT				NOT NULL,
		NOMBRE					VARCHAR(50)		NOT NULL,
		APE1					VARCHAR(50)		NOT NULL,
		APE2					VARCHAR(50)		NULL,
		CODTIPIDE				VARCHAR(1)		NULL,
		NUMINT					VARCHAR(21)		NULL,
		CODPAIS					VARCHAR(5)		NULL,
		CODSEX					VARCHAR(1)		NOT NULL,
		FECNAC					DATETIME2(3)	NULL,
		LUGNAC					VARCHAR(50)		NULL,
		NOMRESP					VARCHAR(60)		NULL,
		NOMPAD					VARCHAR(60)		NULL,
		NOMMAD					VARCHAR(60)		NULL,
		CODESCIV				VARCHAR(1)		NULL,
		PROFES					VARCHAR(255)	NULL,
		FECDEF					DATETIME2(3)	NULL,
		LUGDEF					VARCHAR(50)		NULL,
		NUMLIC					VARCHAR(20)		NULL,
		FECEXPLIC				DATETIME2(3)	NULL,
		FECCADLIC				DATETIME2(3)	NULL,
		TIPLIC					VARCHAR(2)		NULL,
		REINCIDENTE				VARCHAR(1)		NULL,
		OBSERV					VARCHAR(255)	NULL,
		CODPROINT				VARCHAR(4)		NULL,
		REBELDE					VARCHAR(1)		NULL,
		CODETN					VARCHAR(2)		NULL,
		ESDISCAPAC				VARCHAR(1)		NULL,
		CODRESUL				VARCHAR(9)		NULL,
		FECACTUAL				DATETIME2(3)	NULL,
		FECRESOL				DATETIME2(3)	NULL,
		CODESCO					VARCHAR(2)		NULL,
		CODMONINT				VARCHAR(3)		NULL,
		TU_CodInterviniente		UNIQUEIDENTIFIER	NOT NULL);

	DECLARE @DINTENT AS TABLE (
		IDINT					INT					NOT NULL,
		NOMBRE					VARCHAR(100)		NOT NULL,
		NOMCIAL					VARCHAR(100)		NULL, 
		CODTIPIDE				VARCHAR(1)			NULL, 
		NUMINT					VARCHAR(21)			NULL,
		NOMRESP					VARCHAR(60)			NULL,
		CARRESP					VARCHAR(15)			NULL, 
		DESCRIP					VARCHAR(255)		NULL,
		TU_CodInterviniente		UNIQUEIDENTIFIER	NOT NULL
	);

	Declare @DDOM As Table (
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

	Declare @DPROF As Table (
		IDINT					INT					NOT NULL,
		CODPROF					VARCHAR(3)			NOT NULL,
		CODORGCOL				VARCHAR(10)			NULL);

	SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
			@L_TU_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_TC_CodContextoOrigen = TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@CodHistoricoItineracion);

	/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoTipoRepresentacion	= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_TipoRepresentacion','');
	SELECT	@L_ValorDefectoTipoIntervencionRep	= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_TipoIntervencionRep','');
	SELECT	@L_ValorDefectoSexo					= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_Sexo','');
	SELECT	@L_ValorDefectoCodProfRepresentantes= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CODPROF_Representant','');

	-- Valida si es Expediente o Legajo (En caso del expediente excluir los legajos) 
	IF(@L_TU_CodLegajo IS NULL) 
	BEGIN
		--SE CARGA TODAS LAS INTERVENCIONES QUE SE ENCUENTRE SEGUN LOS FILTROS INDICADOS 
		INSERT INTO @Intervinientes
					(TU_CodInterviniente,			IDINT)
		SELECT		A.TU_CodInterviniente,			A.IDINT
		FROM		Expediente.Intervencion			A WITH(NOLOCK)
		Left Join	Expediente.LegajoIntervencion	B WITH (NOLOCK)
		On			B.TU_CodInterviniente			= A.TU_CodInterviniente
		And			B.TU_CodLegajo					= @L_TU_CodLegajo
		WHERE		A.TC_NumeroExpediente			= @L_TC_NumeroExpediente
		AND			A.TU_CodInterviniente			NOT IN 
													(SELECT TU_CodInterviniente FROM Expediente.LegajoIntervencion WITH(NOLOCK) WHERE TU_CodLegajo in 
													(SELECT TU_CodLegajo from Expediente.Legajo WITH(NOLOCK) WHERE TC_NumeroExpediente = @L_TC_NumeroExpediente))	 
	END 
	ELSE BEGIN 
		--SE CARGA TODAS LAS INTERVENCIONES QUE SE ENCUENTRE SEGUN LOS FILTROS INDICADOS 
		INSERT INTO @Intervinientes
					(TU_CodInterviniente,			IDINT)
		SELECT		A.TU_CodInterviniente,			A.IDINT
		FROM		Expediente.Intervencion			A WITH(NOLOCK)
		INNER JOIN	Expediente.LegajoIntervencion	B WITH (NoLock)
		On			B.TU_CodInterviniente			= A.TU_CodInterviniente
		And			B.TU_CodLegajo					= @L_TU_CodLegajo
		WHERE		A.TC_NumeroExpediente			= @L_TC_NumeroExpediente
	END

	--INSERCION EN TABLA INTERVINIENTES DE TIPO REPRESENTANTES
	INSERT INTO @DINTREP
		(CARPETA,					IDINT,								IDINTREP,					CODREP,	 
		 FECINI,					FECFIN,								CODMEDCOM,					CODMEDCOMACC,
		 TU_CodMedioComunicacion,	TU_CodMedioComunicacionAcc,			TU_CodDomicilio)						
	SELECT		@L_Carpeta											CARPETA,
				A.IDINT												IDINT,
				H.IDINT												IDINTREP,
				ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoRepresentacion', B.TN_CodTipoRepresentacion,0,0),@L_ValorDefectoTipoRepresentacion)	CODREP,
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
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoMedioComunicacion', D.TN_CodMedio,0,0) CODMEDCOM,
							D.TU_CodMedioComunicacion
				FROM		Expediente.IntervencionMedioComunicacion D WITH(NOLOCK)
				WHERE		D.TU_CodInterviniente					 = B.TU_CodIntervinienteRepresentante
				AND			D.TN_PrioridadExpediente				 = 1
				) F
	OUTER APPLY	(
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoMedioComunicacion', D.TN_CodMedio,0,0) CODMEDCOM,
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

	--INSERCIÓN EN LA TABLA DE PROFESIONALES (PARA LOS REPRESENTANTES)
	INSERT INTO @DPROF
			(IDINT,		CODPROF,								CODORGCOL)
	SELECT	IDINTREP,	@L_ValorDefectoCodProfRepresentantes,	NULL
	FROM	@DINTREP

	--INSERCION EN TABLA INTERVINIENTES
	INSERT INTO @DINT
		(CARPETA,					IDINT,			CODINT,						CODMEDCOM, 
		CODFIJU,					EDAD,			RECURRENTE,					DESISTE,	
		NOTIFICADO, 				DESHABILITADA,	ALIAS,						CODLAB,	
		CODMEDCOMACC,				CODRELAC,		TU_CodMedioComunicacion,	TU_CodMedioComunicacionAcc,
		TU_CodDomicilio,			LUGTRAB,		IND_TURISTA)
	SELECT		@L_Carpeta																CARPETA,
				A.IDINT																	IDINT,
				ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoIntervencion', E.TN_CodTipoIntervencion,0,0), @L_ValorDefectoTipoIntervencionRep)	CODINT,
				K.CODMEDCOM																CODMEDCOM,
				C.TC_CodTipoPersona														CODFIJU,
				CASE WHEN C.TC_CodTipoPersona = 'F' THEN
					CAST(DATEDIFF(DAY,D.TF_FechaNacimiento,GETDATE())/365.25 AS INT)
					ELSE NULL
				END																		EDAD,
				0																		RECURRENTE,
				0																		DESISTE,
				0																		NOTIFICADO,
				0																		DESHABILITADA,
				E.TC_Alias																ALIAS,
				CASE WHEN B.TC_TipoParticipacion = 'R' -- REPRESENTANTE
					THEN ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'SituacionLaboral', E.TN_CodSituacionLaboral,0,0), '01')--Empleado
					ELSE Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'SituacionLaboral', E.TN_CodSituacionLaboral,0,0)
				END																		CODLAB,
				L.CODMEDCOM																CODMEDCOMACC,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Parentesco', E.TU_CodParentesco,0,0)	CODRELAC,
				K.TU_CodMedioComunicacion												TU_CodMedioComunicacion,
				L.TU_CodMedioComunicacion												TU_CodMedioComunicacionAcc,
				M.TU_CodDomicilio														TU_CodDomicilio,
				E.TC_LugarTrabajo														LUGTRAB,
				ISNULL(E.TB_Turista, 0)													IND_TURISTA	
	FROM		@Intervinientes				A
	INNER JOIN	Expediente.Intervencion		B WITH(NOLOCK)
	ON			B.TU_CodInterviniente		= A.TU_CodInterviniente
	INNER JOIN	Persona.Persona				C WITH(NOLOCK)
	ON			C.TU_CodPersona				= B.TU_CodPersona
	LEFT JOIN	Persona.PersonaFisica		D WITH(NOLOCK)
	ON			D.TU_CodPersona				= C.TU_CodPersona
	LEFT JOIN	Expediente.Interviniente	E WITH(NOLOCK)
	ON			E.TU_CodInterviniente		= B.TU_CodInterviniente
	OUTER APPLY	(
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoMedioComunicacion', I.TN_CodMedio,0,0) CODMEDCOM,	
							I.TU_CodMedioComunicacion
				FROM		Expediente.IntervencionMedioComunicacion	I WITH(NOLOCK)
				WHERE		I.TU_CodInterviniente						= B.TU_CodInterviniente
				AND			I.TN_PrioridadExpediente					= 1
				AND			I.TB_PerteneceExpediente =					CASE WHEN @L_TU_CodLegajo IS NULL then 1 else I.TB_PerteneceExpediente END
				)  K
	OUTER APPLY	(
				SELECT		Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoMedioComunicacion', I.TN_CodMedio,0,0) CODMEDCOM,	
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
				)  M;
	
	--INSERCION EN INTERVINIENTES DE TIPO FISICO
	INSERT INTO @DINTPER
		(IDINT,		NOMBRE,				APE1,		APE2,
		CODTIPIDE,	NUMINT,				CODSEX,		FECNAC,
		LUGNAC,		NOMPAD,				NOMMAD,		PROFES,
		CODESCIV,	FECDEF,				LUGDEF,		FECEXPLIC,	
		FECCADLIC,	NUMLIC,				TIPLIC,		CODETN,		
		CODPAIS,	OBSERV,				CODPROINT,	REBELDE,	
		CODESCO,	TU_CodInterviniente)
	SELECT		A.IDINT													IDINT,
				D.TC_Nombre												NOMBRE,
				D.TC_PrimerApellido										APE1,
				D.TC_SegundoApellido									APE2,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoIdentificacion', C.TN_CodTipoIdentificacion,0,0) CODTIPIDE,
				C.TC_Identificacion										NUMINT,
				ISNULL(D.TC_CodSexo,@L_ValorDefectoSexo)				CODSEX,
				D.TF_FechaNacimiento									FECNAC,
				D.TC_LugarNacimiento									LUGNAC,
				SUBSTRING(D.TC_NombrePadre,0,60)						NOMPAD, 
				SUBSTRING(D.TC_NombreMadre,0,60)						NOMMAD,
				J.TC_Descripcion										PROFES,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'EstadoCivil', D.TN_CodEstadoCivil,0,0) CODESCIV,
				D.TF_FechaDefuncion										FECDEF,
				D.TC_LugarDefuncion										LUGDEF,
				G.TF_Expedicion											FECEXPLIC,
				G.TF_Caducidad											FECCADLIC,
				LEFT(C.TC_Identificacion, 20)							NUMLIC,
				G.TIPLIC												TIPLIC,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Etnia', D.TN_CodEtnia,0,0)	CODETN,
				I.TC_CodPais											CODPAIS,
				I.TC_Caracteristicas									OBSERV,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Profesion', I.TN_CodProfesion,0,0)	CODPROINT,
				CASE 
					WHEN I.TB_Rebeldia IS NULL THEN NULL
					WHEN I.TB_Rebeldia = 1 THEN 'S' 
					WHEN I.TB_Rebeldia = 0 THEN 'N' 
				END														REBELDE,
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Escolaridad', I.TN_CodEscolaridad,0,0)	CODESCO,
				A.TU_CodInterviniente									TU_CodInterviniente
	FROM		@Intervinientes				A
	INNER JOIN	Expediente.Intervencion		B WITH(NOLOCK)
	ON			B.TU_CodInterviniente		= A.TU_CodInterviniente
	INNER JOIN	Persona.Persona				C WITH(NOLOCK)
	ON			C.TU_CodPersona				= B.TU_CodPersona
	INNER JOIN	Persona.PersonaFisica		D WITH(NOLOCK)
	ON			D.TU_CodPersona				= C.TU_CodPersona
	OUTER APPLY	(
				SELECT		TOP 1 X.TF_Caducidad,	X.TF_Expedicion, 
							Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoLicencia', X.TN_CodTipoLicencia,0,0) TIPLIC
				FROM		Persona.Licencia		X WITH(NOLOCK)
				WHERE		X.TU_CodPersona			= B.TU_CodPersona
				AND			X.TF_Caducidad			>= GETDATE()
				ORDER BY	TF_Expedicion
				) G
	LEFT JOIN	Expediente.Interviniente	I WITH(NOLOCK)
	ON			I.TU_CodInterviniente		= B.TU_CodInterviniente
	LEFT JOIN	Catalogo.Profesion			J WITH(NOLOCK)
	ON			J.TN_CodProfesion			= I.TN_CodProfesion
	
	--INSERCION DE INTERVINIENTES DE TIPO JURIDICO
	INSERT INTO @DINTENT 
	(
		IDINT, NOMBRE, NOMCIAL, CODTIPIDE, NUMINT, NOMRESP,
		CARRESP, DESCRIP, TU_CodInterviniente
	)
	SELECT			I.IDINT							AS IDINT,
					PJ.TC_Nombre					AS NOMBRE,
					PJ.TC_NombreComercial			AS NOMCIAL,
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'TipoIdentificacion', P.TN_CodTipoIdentificacion,0,0)	AS CODTIPIDE,
					P.TC_Identificacion				AS NUMINT,					
					PJ.TC_NombreRepresentante		AS NOMRESP,
					PJ.TC_CargoRepresentante		AS CARRESP,
					NULL							AS DESRP,
					I.TU_CodInterviniente			AS TU_CodInterviniente
	FROM			@Intervinientes					I	
	INNER JOIN		Expediente.Intervencion			IT  WITH(NOLOCK)
	ON				IT.TU_CodInterviniente			=	I.TU_CodInterviniente
	INNER JOIN		Persona.Persona					P   WITH(NOLOCK)
	ON				P.TU_CodPersona					=	IT.TU_CodPersona	
	INNER JOIN		Persona.PersonaJuridica			PJ  WITH(NOLOCK)
	ON				PJ.TU_CodPersona				=   P.TU_CodPersona	
	
	--ACTUALIZACION PARA MAPEO DE DISCAPACIDAD EN DINTPER
	UPDATE		@DINTPER								 
	SET			ESDISCAPAC = 1
	FROM		@DINTPER								 AS A
	INNER JOIN  Expediente.IntervinienteDiscapacidad	 AS B WITH(NOLOCK)
	ON			A.TU_CodInterviniente					 =	B.TU_CodInterviniente
	INNER JOIN  Catalogo.Discapacidad					 AS C WITH(NOLOCK)
	ON			B.TN_CodDiscapacidad					 =	C.TN_CodDiscapacidad

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
				Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Provincia', C.TN_CodProvincia,0,0)	CODPROV,
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
	FROM		@Intervinientes									A
	INNER JOIN	Expediente.Intervencion							B WITH(NOLOCK)
	ON			B.TU_CodInterviniente							= A.TU_CodInterviniente
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
	LEFT JOIN	Expediente.IntervencionMedioComunicacionLegajo	J WITH(NOLOCK)
	ON			J.TU_CodMedioComunicacion						= C.TU_CodMedioComunicacion
	
	WHERE		(@L_TU_CodLegajo								IS NOT NULL	
				AND J.TU_CodLegajo								= @L_TU_CodLegajo
				AND	C.TB_PerteneceExpediente					= 0)
	OR			(@L_TU_CodLegajo								IS NULL
				AND	C.TB_PerteneceExpediente					= 1)


	--INSERCION DE LOS DOMICILIOS
	INSERT INTO @DDOM 
			(CODCLADOM,				CLAVDOM,				NOMVIA,				CODBARRIO,				
			CODDISTRITO,			CODCANTON,				CODPROV,			APAPOS,					
			BANCO,					CUENTA,					TELEFONO,			FAX,					
			OTROS,					TELEFONOCEL,			MENSCELULAR,		CODAUTORIDAD,			
			TU_CodDomicilio)
	SELECT			CASE I.TC_TipoParticipacion			
						WHEN 'R' THEN 'P'
						WHEN 'P' THEN 'I'
					END												AS CODCLADOM,
					I.IDINT											AS CLAVDOM,
					PD.TC_Direccion									AS NOMVIA,
					B.CODBARRIO										AS CODBARRIO,
					D.CODDISTRITO									AS CODDISTRITO,
					C.CODCANTON										AS CODCANTON,
					Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_TC_CodContextoOrigen,'Provincia', PD.TN_CodProvincia,0,0)	AS CODPROV,
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
	FROM			@Intervinientes									A 		
	INNER JOIN		Expediente.Intervencion							I   WITH(NOLOCK)
	ON				I.TU_CodInterviniente							=   A.TU_CodInterviniente
	INNER JOIN		Expediente.IntervinienteDomicilio				ID	WITH(NOLOCK)
	ON				ID.TU_CodInterviniente							=	I.TU_CodInterviniente
	INNER JOIN		Persona.Persona									PE	WITH(NOLOCK)
	ON				PE.TU_CodPersona								=   I.TU_CodPersona
	INNER JOIN		Persona.Domicilio								PD	WITH(NOLOCK)
	ON				PD.TU_CodPersona								=	PE.TU_CodPersona
	AND				PD.TU_CodDomicilio								=	ID.TU_CodDomicilio 
	LEFT JOIN		Catalogo.Canton									C	WITH(NOLOCK)
	ON				C.TN_CodProvincia								=	PD.TN_CodProvincia
	AND				C.TN_CodCanton									=	PD.TN_CodCanton
	LEFT JOIN		Catalogo.Distrito								D	WITH(NOLOCK)
	ON				D.TN_CodProvincia								=	PD.TN_CodProvincia
	AND				D.TN_CodCanton									=	PD.TN_CodCanton
	AND				D.TN_CodDistrito								=	PD.TN_CodDistrito
	LEFT JOIN		Catalogo.Barrio									B	WITH(NOLOCK)
	ON				B.TN_CodProvincia								=	PD.TN_CodProvincia
	AND				B.TN_CodCanton									=	PD.TN_CodCanton
	AND				B.TN_CodDistrito								=	PD.TN_CodDistrito
	AND				B.TN_CodBarrio									=	PD.TN_CodBarrio	

	--INSERCION DE LOS TELÉFONOS
	INSERT INTO @DDOM 
			(CODCLADOM,				CLAVDOM,				NOMVIA,				CODBARRIO,				
			CODDISTRITO,			CODCANTON,				CODPROV,			APAPOS,					
			BANCO,					CUENTA,					TELEFONO,			FAX,					
			OTROS,					TELEFONOCEL,			MENSCELULAR,		CODAUTORIDAD,			
			TU_CodDomicilio)
	SELECT			CASE I.TC_TipoParticipacion			
						WHEN 'R' THEN 'P'
						WHEN 'P' THEN 'I'
					END												AS CODCLADOM,
					I.IDINT											AS CLAVDOM,
					CASE WHEN TC_Extension IS NOT NULL
						THEN 'Ext. ' + TC_Extension 	
					END												AS NOMVIA,
					NULL											AS CODBARRIO,
					NULL											AS CODDISTRITO,
					NULL											AS CODCANTON,
					NULL											AS CODPROV,
					NULL											AS APAPOS,
					NULL											AS BANCO,
					NULL											AS CUENTA,
					CASE 
						WHEN PT.TN_CodTipoTelefono = 2	THEN PT.TC_Numero	--2 = Domiciliar
					END												AS TELEFONO,
					CASE 
						WHEN PT.TN_CodTipoTelefono = 6	THEN PT.TC_Numero   -- 6 = FAX
					END												AS FAX,				
					CASE 
						WHEN PT.TN_CodTipoTelefono NOT IN (2, 4, 6)	THEN PT.TC_Numero -- Si no es Domiciliar, Móvil o Fax
					END												AS OTROS,
					CASE 
						WHEN PT.TN_CodTipoTelefono = 4				THEN PT.TC_Numero	--4 = Móvil
					END												AS TELEFONOCEL,
					PT.TB_SMS										AS MENSCELULAR,
					NULL											AS CODAUTORIDAD,
					NULL											AS TU_CodDomicilio
	FROM			@Intervinientes									A 		
	INNER JOIN		Expediente.Intervencion							I   WITH(NOLOCK)
	ON				I.TU_CodInterviniente							=   A.TU_CodInterviniente
	INNER JOIN		Persona.Persona									PE	WITH(NOLOCK)
	ON				PE.TU_CodPersona								=   I.TU_CodPersona
	LEFT JOIN		Persona.Telefono								PT  WITH(NOLOCK)
	ON				PT.TU_CodPersona								=	PE.TU_CodPersona

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

	--RETORNO DE RESULTADOS OBTENIDOS
	Select * from @DINT;
	Select * from @DINTREP;
	Select * from @DINTPER;
	Select * from @DINTENT;
	Select * from @DDOM;
	Select * from @DPROF;

END
GO
