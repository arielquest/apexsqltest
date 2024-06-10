SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez >
-- Fecha de creación:		<16/12/2020>
-- Descripción :			<Permite consultar comunicaciones de una Itineración de Gestión con catálogos o tablas equivalentes del SIAGPJ>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_RecibirComunicaciones]
	@CodItineracion			Uniqueidentifier
AS 

BEGIN
	--Variables 
	DECLARE	@L_CodItineracion		Uniqueidentifier	= @CodItineracion, 
			@L_ContextoDestino		VARCHAR(4),
			@L_XML					XML, 
			@L_NumeroExpediente		VARCHAR(14)

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
										FECCOMUNIC						DATETIME2(3)		NULL,		
										MEDPRIMARIO						BIT					NULL,				
										LUGAR							VARCHAR(255)		NULL,		
										PRIORI							VARCHAR(1)			NULL,
										FECSYS							DATETIME2(3)		NULL,
										TIPO							CHAR(1)				NOT NULL,
										TU_CodInterviniente				UNIQUEIDENTIFIER	NULL,
										TC_CodMedio						SMALLINT			NULL,
										TN_CodProvincia					SMALLINT			NULL,
										TN_CodCanton					SMALLINT			NULL,
										TN_CodDistrito					SMALLINT			NULL,
										TN_CodBarrio					SMALLINT			NULL,
										TN_CodSector					SMALLINT			NULL,--PENDIENTE
										TB_TienePrioridad				BIT					NOT NULL DEFAULT 0,--PENDIENTE
										TN_PrioridadMedio				TINYINT				NULL,--PENDIENTE
										TC_Estado						CHAR(1)				NULL,--PENDIENTE
										TN_CodHorarioMedio				SMALLINT			NULL,--PENDDIENTE
										TB_RequiereCopias				BIT					NOT NULL DEFAULT 0,
										TC_Resultado					CHAR(1)				NULL, --PENDIENTE
										TU_CodPuestoFuncionarioRegistro	UNIQUEIDENTIFIER	NULL,--PENDIENTE
										TU_CodPuestoFuncionarioEnvio	UNIQUEIDENTIFIER	NULL,--PENDIENTE
										TC_TipoComunicacion				CHAR(1)				NULL
									);

	DECLARE	@l_tblIntervinientes	TABLE	(IDINT INT NOT NULL, 
											GUID_IDINT UNIQUEIDENTIFIER NOT NULL);

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SELECT	@L_XML							= VALUE 
	FROM	ITINERACIONES.dbo.ATTACHMENTS	WITH(NOLOCK) 
	WHERE	ID								= @L_CodItineracion

	SELECT	@L_ContextoDestino				= RECIPIENTADDRESS
	FROM	ITINERACIONES.DBO.[MESSAGES]	WITH(NOLOCK) 
	WHERE	ID								= @L_CodItineracion

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');
	
	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DACONOT AS (
		SELECT	X.Y.value('(IDACO)[1]',			'INT')				IDACO,
				X.Y.value('(IDINT)[1]',			'INT')				IDINT,
				X.Y.value('(CODMEDCOM)[1]',		'VARCHAR(1)')		CODMEDCOM,
				X.Y.value('(NUMDIR)[1]',		'VARCHAR(255)')		NUMDIR,
				X.Y.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
				X.Y.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
				X.Y.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
				X.Y.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV,
				X.Y.value('(SECTOR)[1]',		'VARCHAR(5)')		SECTOR,
				X.Y.value('(FECRES)[1]',		'DATETIME2(3)')		FECRES,
				X.Y.value('(Horario)[1]',		'CHAR(1)')			HORARIO,
				X.Y.value('(COPIAS)[1]',		'VARCHAR(1)')		COPIAS,
				X.Y.value('(CODESTNOT)[1]',		'VARCHAR(1)')		CODESTNOT,
				X.Y.value('(FECDEVOCN)[1]',		'DATETIME2(3)')		FECDEVOCN,
				X.Y.value('(FECCOMUNIC)[1]',	'DATETIME2(3)')		FECCOMUNIC,
				X.Y.value('(MEDPRIMARIO)[1]',	'BIT')				MEDPRIMARIO,
				X.Y.value('(LUGAR)[1]',			'VARCHAR(255)')		LUGAR,
				X.Y.value('(NOTPRI)[1]',		'VARCHAR(1)')		PRIORI				
		FROM	@L_XML.nodes('(/*/DACONOT)')	AS X(Y)
	),
	DACOCIT AS (
		SELECT	X.Y.value('(IDACO)[1]',			'INT')				IDACO,
				X.Y.value('(IDINT)[1]',			'INT')				IDINT,
				X.Y.value('(IDINTREP)[1]',		'INT')				IDINTREP,
				X.Y.value('(CODMEDCOM)[1]',		'VARCHAR(1)')		CODMEDCOM,
				X.Y.value('(NUMDIR)[1]',		'VARCHAR(255)')		NUMDIR,
				X.Y.value('(CODBARRIO)[1]',		'VARCHAR(5)')		CODBARRIO,
				X.Y.value('(CODDISTRITO)[1]',	'VARCHAR(5)')		CODDISTRITO,
				X.Y.value('(CODCANTON)[1]',		'VARCHAR(5)')		CODCANTON,
				X.Y.value('(CODPROV)[1]',		'VARCHAR(5)')		CODPROV,
				X.Y.value('(SECTOR)[1]',		'VARCHAR(5)')		SECTOR,				
				X.Y.value('(CITLUGAR)[1]',		'VARCHAR(255)')		LUGAR,
				X.Y.value('(CITPRIORI)[1]',		'VARCHAR(1)')		PRIORI			
		FROM	@L_XML.nodes('(/*/DACOCIT)')	AS X(Y)
	),
	DACO AS  (
		SELECT		X.Y.value('(FECSYS)[1]',		'DATETIME2(3)')		FECSYS,
					X.Y.value('(IDACO)[1]',			'INT')				IDACO--,
					--X.Y.value('(IDACO)[1]',			'INT')				IDACO
		FROM		DACONOT							A
		OUTER APPLY	@L_XML.nodes('(/*/DACO)')		X(Y)
		WHERE		X.Y.value('(IDACO)[1]',			'INT')	= A.IDACO 
		UNION
		SELECT		X.Y.value('(FECSYS)[1]',		'DATETIME2(3)')		FECSYS,
					X.Y.value('(IDACO)[1]',			'INT')				IDACO
		FROM		DACOCIT							A
		OUTER APPLY	@L_XML.nodes('(/*/DACO)')		X(Y)
		WHERE		X.Y.value('(IDACO)[1]',			'INT')	= A.IDACO 
	),
	COMUNICACIONES AS
	(
		SELECT			N.IDACO,		N.IDINT,			N.CODMEDCOM,		N.NUMDIR,
						N.CODBARRIO,	N.CODDISTRITO,		N.CODCANTON,		N.CODPROV,
						N.SECTOR,		N.FECRES,			N.HORARIO,			N.COPIAS,			
						N.CODESTNOT,	N.FECDEVOCN,		N.FECCOMUNIC,		N.MEDPRIMARIO,		
						N.LUGAR,		N.PRIORI,			D.FECSYS,			'N' TIPO
		FROM			DACONOT			N
		INNER JOIN		DACO			D
		ON				D.IDACO			= N.IDACO
		UNION
		SELECT			C.IDACO,		C.IDINT,			C.CODMEDCOM,		C.NUMDIR,
						C.CODBARRIO,	C.CODDISTRITO,		C.CODCANTON,		C.CODPROV,
						C.SECTOR,		NULL,				NULL,				NULL,				
						NULL,			NULL,				NULL,				NULL,				
						LUGAR,			PRIORI,				D.FECSYS,			'I' TIPO
		FROM			DACOCIT			C
		INNER JOIN		DACO			D
		ON				D.IDACO			= C.IDACO
	)
	INSERT INTO @L_tblComunicaciones
				(ID,				IDACO,			IDINT,				CODMEDCOM,		
				NUMDIR,				CODBARRIO,		CODDISTRITO,		CODCANTON,		
				CODPROV,			SECTOR,			FECRES,				HORARIO,		
				COPIAS,				CODESTNOT,		FECDEVOCN,			FECCOMUNIC,		
				MEDPRIMARIO,		LUGAR,			PRIORI,				FECSYS,			
				TIPO,				TC_CodMedio,	TN_CodProvincia,	TN_CodCanton,
				TN_CodDistrito,		TN_CodBarrio)
	SELECT		NEWID() ID,			A.IDACO,		A.IDINT,			A.CODMEDCOM,		
				A.NUMDIR,			A.CODBARRIO,	A.CODDISTRITO,		A.CODCANTON,		
				A.CODPROV,			A.SECTOR,		A.FECRES,			A.HORARIO,		
				A.COPIAS,			A.CODESTNOT,	A.FECDEVOCN,		A.FECCOMUNIC,		
				A.MEDPRIMARIO,		A.LUGAR,		A.PRIORI,			A.FECSYS,			
				A.TIPO,				B.TN_CodMedio,	C.TN_CodProvincia,	D.TN_CodCanton,
				E.TN_CodDistrito,	F.TN_CodBarrio
	FROM		COMUNICACIONES					A
	LEFT JOIN	Catalogo.TipoMedioComunicacion	B	WITH(NOLOCK)
	ON			B.CODMEDCOM						=	A.CODMEDCOM
	LEFT JOIN	Catalogo.Provincia				C	WITH(NOLOCK)
	ON			C.CODPROV						=	A.CODPROV
	LEFT JOIN	Catalogo.Canton					D	WITH(NOLOCK)
	ON			D.CODPROV						=	A.CODPROV
	AND			D.CODCANTON						=	A.CODCANTON
	LEFT JOIN	Catalogo.Distrito				E	WITH(NOLOCK)
	ON			E.CODPROV						=	A.CODPROV
	AND			E.CODCANTON						=	A.CODCANTON
	AND			E.CODDISTRITO					=	A.CODDISTRITO
	LEFT JOIN	Catalogo.Barrio					F	WITH(NOLOCK)
	ON			F.CODPROV						=	A.CODPROV
	AND			F.CODCANTON						=	A.CODCANTON
	AND			F.CODDISTRITO					=	A.CODDISTRITO
	AND			F.CODBARRIO						=	A.CODBARRIO
	
	/*Se actualiza el id del interviniente*/
	INSERT INTO @l_tblIntervinientes
	SELECT	C.IDINT,	NEWID() GUID_INTERVINIENTE
	FROM	(	SELECT	DISTINCT				IDINT
				FROM	@L_tblComunicaciones	) C
	
	UPDATE		A
	SET			A.TU_CodInterviniente = B.GUID_IDINT
	FROM		@L_tblComunicaciones	A
	INNER JOIN	@l_tblIntervinientes	B
	ON			B.IDINT					= A.IDINT

	/*Obtiene valor por defecto para TC_TipoMedio*/
	UPDATE		A
	SET			A.TC_CodMedio					=	B.TC_ValorPorDefecto
	FROM		@L_tblComunicaciones			A
	INNER JOIN	Migracion.ValoresDefecto		B	WITH(NOLOCK)
	ON			B.TC_NombreCampo				=	'TN_CodMedio'
	AND			B.TC_ValoresActuales			=	'#Cualquiera'
	WHERE		A.TC_CodMedio					IS	NULL

	/*Obtiene valor por defecto para TB_TienePrioridad,TN_PrioridadMedio*/ --PENDIENTE

	/*Obtiene equivalencia y valor por defecto para TC_Estado*/
	UPDATE		A
	SET			A.TC_Estado					=	B.TC_ValorPorDefecto
	FROM		@L_tblComunicaciones			A
	INNER JOIN	Migracion.ValoresDefecto		B	WITH(NOLOCK)
	ON			B.TC_NombreCampo				=	'TC_Estado'
	AND			B.TC_ValoresActuales			=	A.CODESTNOT

	UPDATE		A
	SET			A.TC_Estado					=	B.TC_ValorPorDefecto
	FROM		@L_tblComunicaciones			A
	INNER JOIN	Migracion.ValoresDefecto		B	WITH(NOLOCK)
	ON			B.TC_NombreCampo				=	'TC_Estado'
	AND			B.TC_ValoresActuales			=	'#Cualquiera'
	WHERE		A.TC_Estado						IS	NULL

	/*Obtiene equivalencia para TN_CodHorarioMedio*/
	UPDATE		A
	SET			A.TN_CodHorarioMedio			=	B.TC_ValorPorDefecto
	FROM		@L_tblComunicaciones			A
	INNER JOIN	Migracion.ValoresDefecto		B	WITH(NOLOCK)
	ON			B.TC_NombreCampo				=	'TN_CodHorario'
	AND			B.TC_ValoresActuales			=	A.HORARIO

	/*Obtiene valor por defecto para TB_RequiereCopias, TC_Resultado*/ --PENDIENTE

	SELECT	ID						CodigoComunicacion,
			@L_NumeroExpediente		NumeroExpediente,
			NUMDIR					Valor,
			LUGAR					Rotulado,
			TB_TienePrioridad		TienePrioridad,--PENDIENTE
			FECRES					FechaResolucion,
			TB_RequiereCopias		RequiereCopias,--PENDIENTE
			GETDATE()				FechaActualizacion,
			FECDEVOCN				FechaDevolucion,
			--TU_CodPuestoFuncionarioRegistro PENDIENTE
			FECSYS					FechaRegistro,
			FECCOMUNIC				FechaEnvio,
			--TU_CodPuestoFuncionarioEnvio	PENDIENTE,
			0						Cancelar,
			'SplitTipoMedio'		SplitTipoMedio,
			TC_CodMedio				Codigo,--falta valor por defecto
			'SplitContextoEnvia'	SplitContextoEnvia,
			@L_ContextoDestino		Codigo,
			'SplitContextoOCJ'		SplitContextoOCJ,
			@L_ContextoDestino		Codigo,
			'SplitProvincia'		SplitProvincia,
			TN_CodProvincia			Codigo,
			'SplitCanton'			SplitCanton,
			TN_CodCanton			Codigo,
			'SplitOtros'			SplitOtros,
			TIPO					TipoComunicacion,
			TN_PrioridadMedio		PrioridadMedio,--PENDIENTE
			TC_Estado				Estado,--PENDIENTE
			TC_Resultado			Resultado,--PENDIENTE
			TN_CodDistrito			TN_CodDistrito,
			TN_CodBarrio			TN_CodBarrio,
			--TN_CodSector PENDIENTE
			TN_CodHorarioMedio		TN_CodHorarioMedio,
			TU_CodInterviniente		TU_CodInterviniente,
			MEDPRIMARIO				EsPrincipal
	FROM	@L_tblComunicaciones				

		
	/*PENDIENTE REVISAR CON ELIZANDRO COMO OBTENER EL DOCUMENTO DE ACTA Y EL PRINCIPAL DE LA COMUNICACION */
	SELECT	ID				CodComunicacion,
			1				EsActa,
			GETDATE()		FechaAsociacion, --PENDIENTE
			0				EsPrincipal,
			'SplitArchivo'	SplitArchivo,
			NEWID()			Codigo
	FROM	@L_tblComunicaciones

END
GO
