SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez S>
-- Fecha de creación:		<16/12/2020>
-- Descripción :			<Permite consultar comunicaciones de una Itineración de Gestión con cat logos o tablas equivalentes del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación :			<11/02/2020><Karol Jiménez S><Se excluye de este mapeo la tabla DACOCIT, según acuerdo con jefatura porque es un tramite que no se utiliza en Gestión>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<22/03/2021><Karol Jiménez S.> <Se corrije forma de obtener las fechas del XML, agregando uso de Try_Convert>
-- Modificación:			<29/04/2021><Karol Jiménez S.> <Se corrije para que el FechaEnvio se lea de FECENTOCN y FechaResultado de FECCOMUNIC de DACONOT>
-- Modificación:			<31/05/2021><Karol Jiménez S.> <Se corrije para los documentos notificados (EsPrincipal=1) se obtengan del idacorel del DACO, con CODACO = EMI y 
--							NUMACO = NUMACO del daco de la notificación, al igual que como indicó Sigifredo en migración>
-- Modificación:			<07/07/2021><Karol Jiménez S.> <Se agrega a la consulta de comunicación el campo IDACO, a recomendación de Paulo Murillo>
-- Modificación:			<15/10/2021><Ronny Ramírez R.> <Se aplica corrección para convertir todos los CTE's a tablas en memoria @ para optimizar el rendimiento>
-- Modificación:			<01/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Provincia, 
--							TipoMedioComunicacion y HorarioMedioComunicacion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarComunicacionesGestion]
	@CodItineracion			Uniqueidentifier
AS 
BEGIN
	--Variables 
	DECLARE	@L_CodItineracion						VARCHAR(36)			= @CodItineracion, 
			@L_ContextoDestino						VARCHAR(4),
			@L_XML									XML, 
			@L_NumeroExpediente						VARCHAR(14),
			@L_ValorDefectoTipoMedioComunicacion	SMALLINT			= NULL; 

	DECLARE	@L_tblComunicaciones	TABLE (
										ID								UNIQUEIDENTIFIER	NOT NULL,
										IDACO							INT					NOT NULL,				
										IDINT							INT					NOT NULL,				
										CODMEDCOM						VARCHAR(1)			NULL,		
										NUMDIR							VARCHAR(255)		NULL,		
										CODBARRIO						VARCHAR(5)			NULL,	
										CODDISTRITO						VARCHAR(5)			NULL,	
										CODCANTON						VARCHAR(5)			NULL,		
										CODPROV							VARCHAR(5)			NULL,	
										SECTOR							VARCHAR(5)			NULL,		
										FECRES							DATETIME2(3)		NULL,		
										HORARIO							CHAR(1)				NULL,			
										COPIAS							VARCHAR(1)			NULL,		
										CODESTNOT						VARCHAR(1)			NULL,		
										FECDEVOCN						DATETIME2(3)		NULL,		
										FECENTOCN						DATETIME2(3)		NULL,		
										FECCOMUNIC						DATETIME2(3)		NULL,		
										MEDPRIMARIO						BIT					NULL,				
										LUGAR							VARCHAR(255)		NULL,		
										PRIORI							VARCHAR(1)			NULL,
										IDUSU_ENVIO						VARCHAR(25)			NULL,
										FECSYS							DATETIME2(3)		NULL,
										IDUSU_REGISTRO					VARCHAR(25)			NULL,
										IDACOREL						INT					NULL,
										NUMACO							VARCHAR(10)			NULL,
										TIPO							CHAR(1)				NOT NULL,
										TC_CodMedio						SMALLINT			NULL,
										TN_CodProvincia					SMALLINT			NULL,
										TN_CodCanton					SMALLINT			NULL,
										TN_CodDistrito					SMALLINT			NULL,
										TN_CodBarrio					SMALLINT			NULL,
										TN_CodSector					SMALLINT			NULL,
										TN_CodHorarioMedio				SMALLINT			NULL,
										TC_TipoComunicacion				CHAR(1)				NULL
									);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML								= VALUE 
	FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion

	-- Se obtiene el contexto al que se est  itinerando y el # de expediente
	SELECT	@L_ContextoDestino					= RECIPIENTADDRESS,
			@L_NumeroExpediente					= NUE
	FROM	ItineracionesSIAGPJ.DBO.[MESSAGES]	WITH(NOLOCK) 
	WHERE	ID									= @L_CodItineracion

	/*SE OBTIENEN VALORES POR DEFECTO, SEGéN CONFIGURACIONES*/
	SELECT	@L_ValorDefectoTipoMedioComunicacion	= CONVERT(SMALLINT, Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITI_TipoMedioComunicacion',@L_ContextoDestino))
	
	-- Se mapean los campos a tablas en memoria para facilitar y optimizar los joins de múltiples nodos
	
	-- DACO
	DECLARE @DACO TABLE (IDACO int, IDUSU_REGISTRO VARCHAR(25), IDACOREL INT, NUMACO VARCHAR(10), FECSYS VARCHAR(35), CODACO VARCHAR(9))
	INSERT INTO @DACO
	SELECT	A.B.value('(IDACO)[1]', 'INT'),
			A.B.value('(IDUSU)[1]', 'VARCHAR(25)'),
			A.B.value('(IDACOREL)[1]', 'INT'),
			A.B.value('(NUMACO)[1]', 'VARCHAR(10)'),
			TRY_CONVERT(DATETIME2(3), A.B.value('(FECSYS)[1]','VARCHAR(35)')),
			A.B.value('(CODACO)[1]','VARCHAR(9)')
	FROM @L_XML.nodes('(/*/DACO)') AS A(B)

	-- DACONOT
	DECLARE @DACONOT TABLE (IDACO INT, IDINT INT, CODMEDCOM VARCHAR(1), NUMDIR VARCHAR(255), CODBARRIO VARCHAR(5), CODDISTRITO VARCHAR(5), CODCANTON VARCHAR(5), CODPROV VARCHAR(5), SECTOR VARCHAR(5), FECRES VARCHAR(35), HORARIO CHAR(1), COPIAS VARCHAR(1), CODESTNOT VARCHAR(1), FECDEVOCN VARCHAR(35), FECENTOCN VARCHAR(35), FECCOMUNIC VARCHAR(35), MEDPRIMARIO BIT, LUGAR VARCHAR(255), PRIORI VARCHAR(1), IDUSU_ENVIO VARCHAR(25))
	INSERT INTO @DACONOT
	SELECT			X.Y.value('(IDACO)[1]',			'INT')										IDACO,
					X.Y.value('(IDINT)[1]',			'INT')										IDINT,
					X.Y.value('(CODMEDCOM)[1]',		'VARCHAR(1)')								CODMEDCOM,
					X.Y.value('(NUMDIR)[1]',		'VARCHAR(255)')								NUMDIR,
					X.Y.value('(CODBARRIO)[1]',		'VARCHAR(5)')								CODBARRIO,
					X.Y.value('(CODDISTRITO)[1]',	'VARCHAR(5)')								CODDISTRITO,
					X.Y.value('(CODCANTON)[1]',		'VARCHAR(5)')								CODCANTON,
					X.Y.value('(CODPROV)[1]',		'VARCHAR(5)')								CODPROV,
					X.Y.value('(SECTOR)[1]',		'VARCHAR(5)')								SECTOR,
					TRY_CONVERT(DATETIME2(3),		X.Y.value('(FECRES)[1]','VARCHAR(35)'))		FECRES,
					X.Y.value('(Horario)[1]',		'CHAR(1)')									HORARIO,
					X.Y.value('(COPIAS)[1]',		'VARCHAR(1)')								COPIAS,
					X.Y.value('(CODESTNOT)[1]',		'VARCHAR(1)')								CODESTNOT,
					TRY_CONVERT(DATETIME2(3),		X.Y.value('(FECDEVOCN)[1]','VARCHAR(35)'))	FECDEVOCN,
					TRY_CONVERT(DATETIME2(3),		X.Y.value('(FECENTOCN)[1]','VARCHAR(35)'))	FECENTOCN,
					TRY_CONVERT(DATETIME2(3),		X.Y.value('(FECCOMUNIC)[1]','VARCHAR(35)'))	FECCOMUNIC,
					X.Y.value('(MEDPRIMARIO)[1]',	'BIT')										MEDPRIMARIO,
					X.Y.value('(LUGAR)[1]',			'VARCHAR(255)')								LUGAR,
					X.Y.value('(NOTPRI)[1]',		'VARCHAR(1)')								PRIORI,
					X.Y.value('(ENVIADO)[1]',		'VARCHAR(25)')								IDUSU_ENVIO
	FROM		@L_XML.nodes('(/*/DACONOT)')	AS X(Y)
	
	
	-- Se insertan los datos en una tabla variable temporal
	INSERT INTO @L_tblComunicaciones
				(ID,				IDACO,				IDINT,				CODMEDCOM,		
				NUMDIR,				CODBARRIO,			CODDISTRITO,		CODCANTON,		
				CODPROV,			SECTOR,				FECRES,				HORARIO,		
				COPIAS,				CODESTNOT,			FECDEVOCN,			FECENTOCN,
				FECCOMUNIC,			MEDPRIMARIO,		LUGAR,				PRIORI,				
				IDUSU_ENVIO,		FECSYS,				IDUSU_REGISTRO,		IDACOREL,			
				NUMACO, 			TIPO,				TC_CodMedio,		TN_CodProvincia,	
				TN_CodCanton,		TN_CodDistrito,		TN_CodBarrio,		TN_CodHorarioMedio)
	SELECT		NEWID() ID,			A.IDACO,			A.IDINT,			A.CODMEDCOM,		
				A.NUMDIR,			A.CODBARRIO,		A.CODDISTRITO,		A.CODCANTON,		
				A.CODPROV,			A.SECTOR,			A.FECRES,			A.HORARIO,		
				A.COPIAS,			A.CODESTNOT,		A.FECDEVOCN,		A.FECENTOCN,
				A.FECCOMUNIC,		A.MEDPRIMARIO,		A.LUGAR,			A.PRIORI,			
				A.IDUSU_ENVIO,		H.FECSYS,			H.IDUSU_REGISTRO,	H.IDACOREL,			
				H.NUMACO,			'N' TIPO,			B.TN_CodMedio,		C.TN_CodProvincia,	
				D.TN_CodCanton,		E.TN_CodDistrito,	F.TN_CodBarrio,		G.TN_CodHorario
	FROM		@DACONOT							A
	OUTER APPLY	@DACO								H
	LEFT JOIN	Catalogo.TipoMedioComunicacion		B	WITH(NOLOCK)
	ON			B.TN_CodMedio						=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'TipoMedioComunicacion', A.CODMEDCOM,0,0))
	LEFT JOIN	Catalogo.Provincia					C	WITH(NOLOCK)
	ON			C.TN_CodProvincia					=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Provincia', A.CODPROV,0,0))
	LEFT JOIN	Catalogo.Canton						D	WITH(NOLOCK)
	ON			D.CODPROV							=	A.CODPROV
	AND			D.CODCANTON							=	A.CODCANTON
	LEFT JOIN	Catalogo.Distrito					E	WITH(NOLOCK)
	ON			E.CODPROV							=	A.CODPROV
	AND			E.CODCANTON							=	A.CODCANTON
	AND			E.CODDISTRITO						=	A.CODDISTRITO
	LEFT JOIN	Catalogo.Barrio						F	WITH(NOLOCK)
	ON			F.CODPROV							=	A.CODPROV
	AND			F.CODCANTON							=	A.CODCANTON
	AND			F.CODDISTRITO						=	A.CODDISTRITO
	AND			F.CODBARRIO							=	A.CODBARRIO
	LEFT JOIN	Catalogo.HorarioMedioComunicacion	G	WITH(NOLOCK)
	ON			G.TN_CodHorario						=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'HorarioMedioComunicacion', A.HORARIO,0,0))
	WHERE		A.IDACO								=	H.IDACO

	-- Se realiza las consultas de las comunicaciones, actas y resoluciones de las notificaciones

	SELECT	ID										CodigoComunicacion,
			@L_NumeroExpediente						NumeroExpediente,
			REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(NUMDIR)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') Valor,
			REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(LUGAR)), CHAR(9), ''), CHAR(10),''), CHAR(13), '') 	Rotulado,
			CASE 
				WHEN PRIORI IN ('U', 'E','u', 'e')--U=urgente, E=extraurgente
					THEN 1
				ELSE 0
			END										TienePrioridad,
			CASE 
				WHEN MEDPRIMARIO = 1
					THEN 1 --PRIMARIO
				ELSE 2--ACCESORIO
			END										PrioridadMedio,
			FECRES									FechaResolucion,
			CASE WHEN COPIAS IN ('1', 'S', 's')
					THEN 1
				ELSE 0
			END										RequiereCopias,
			GETDATE()								FechaActualizacion,
			FECDEVOCN								FechaDevolucion,
			IDUSU_REGISTRO							UsuarioRegistroGestion,
			FECSYS									FechaRegistro,
			FECENTOCN								FechaEnvio,
			FECCOMUNIC								FechaResultado,
			IDUSU_ENVIO								UsuarioEnvioGestion,
			0										Cancelar,
			'SplitTipoMedio'						SplitTipoMedio,
			ISNULL(TC_CodMedio, @L_ValorDefectoTipoMedioComunicacion)	Codigo,
			'SplitContextoEnvia'					SplitContextoEnvia,
			@L_ContextoDestino						Codigo,
			'SplitContextoOCJ'						SplitContextoOCJ,
			@L_ContextoDestino						Codigo,
			'SplitProvincia'						SplitProvincia,
			TN_CodProvincia							Codigo,
			'SplitCanton'							SplitCanton,
			TN_CodCanton							Codigo,
			'SplitOtros'							SplitOtros,
			TN_CodDistrito							TN_CodDistrito,
			TN_CodBarrio							TN_CodBarrio,
			NULL									TN_CodSector, --TODO: CUANDO SE CAMBIE LA FORMA DE REGISTRAR LOS SECTORES EN SIAGPJ, SE PUEDE VALORAR RETOMARLO, HAY UNA MEJORA PENDIENTE SOBRE ESTO. POR EL MOMENTO SE ACORDà PONERLO EN NULL
			TN_CodHorarioMedio						TN_CodHorarioMedio,
			TIPO									TipoComunicacion,
			'J'										Estado,-- 'J'=Entregada, SE DEFINE ESTE VALOR POR DEFECTO DADO QUE AL RECIBIR ITINERACIONES LAS NOTIFICACIONES Y COMUNICACIONES YA TUVIERON QUE DILIGENCIARSE EN LA OFICINA ORIGEN
			CASE 
				WHEN CODESTNOT = '+'
					THEN 'P' --Positivo
				WHEN CODESTNOT = '-'
					THEN 'N' --Negativo
				ELSE NULL
			END										Resultado,
			IDINT									CodigoIntervinienteGestion,
			CASE WHEN MEDPRIMARIO = 1
					THEN 1
				ELSE
					0
			END										EsPrincipal,
			IDACO									Idaco
	FROM	@L_tblComunicaciones				

	/*ACTAS DE LAS NOTIFICACIONES*/
	SELECT		ID									CodComunicacion,
				1									EsActa,
				ISNULL(X.FECSYS, A.FECSYS)			FechaAsociacion, 
				0									EsPrincipal,
				'SplitArchivo'						SplitArchivo,
				A.IDACOREL							CodigoGestion
	FROM		@L_tblComunicaciones				A
	OUTER APPLY	@DACO								X
	WHERE		X.IDACO								= A.IDACOREL
	AND			A.TIPO								= 'N'--NOTIFICACIONES
	UNION
	/*RESOLUCION DE LAS NOTIFICACIONES*/
	SELECT		ID									CodComunicacion,
				0									EsActa,
				ISNULL(X.FECSYS, A.FECSYS)			FechaAsociacion, 
				1									EsPrincipal,
				'SplitArchivo'						SplitArchivo,
				X.IDACOREL							CodigoGestion
	FROM		@L_tblComunicaciones				A
	OUTER APPLY	@DACO								X
	WHERE		X.NUMACO							= A.NUMACO
	AND			X.CODACO							= 'EMI'
	AND			A.TIPO								= 'N'--NOTIFICACIONES

END
GO
