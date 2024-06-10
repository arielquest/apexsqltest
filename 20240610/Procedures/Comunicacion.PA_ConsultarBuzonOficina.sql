SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =====================================================================================================================================================================            
-- Versión:     <1.0>            
-- Creado por:    <Jeffry Hernández>            
-- Fecha de creación:  <30/05/2018>            
-- Descripción:    <Obtiene las comunicaciones para la consulta de buzón despacho.>             
-- Modificación:   Jeffry Hernández> <17/07/2018> <Se elimina tabla temporal >             
-- =====================================================================================================================================================================            
-- MOdificacion    <Jonathan Aguilar Navarro> <28/06/2018> < Modificaciones por cambio de oficina a contexto>             
-- Modificación    <Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>            
-- Modificación             <Jesús Campos Valle><18/02/2019> <Se modifica el sp para crearlo de forma dinamica esto para evitar realizar consultas nulas que retrasan la consulta>            
-- Modificación:   <29/10/2018> <Juan Ramírez> <Se modifica la consulta y se ajusta al módulo de intervenciones>            
-- Modificación:            <23/04/2020> <Cristian Cerdas> <Se modifica la consulta, en el cual se elimina la columna C.TU_CodLegajo            
--                                                         - Se cambia la columna L.TC_NumeroExpediente por C.TC_NumeroExpediente            
--                                                         - Se cambia en el for la columna C.TU_CodLegajo por C.TC_NumeroExpediente            
--                                                         - Se elimina la condición @NumeroExpediente IS NOT NULL            
--                                                         - Se elimina el Inner Join que hace referencia a la tabla Expediente.Legajo >            
-- Modificación:   <23/09/2020> <Xinia Soto V.> <Se modifica para que funcione para el buzón de comunicaciones>            
-- Modificación:   <04/11/2020> <Xinia Soto V.> <Se modifica para que retorne la fecha de resolución y filtre por identificación>        
-- Modificación:   <17/11/2020> <Xinia Soto V.> <Se modifica para que retorne los códigos de los archivos de la comunicación para el GL nuevo>        
-- Modificación:   <19/04/2021> <Aida Elena Siles R> <Se agregan los campos Rotulado, Observaciones, RequiereCopias, PrioridadMedio y CodigoLegajo> 
-- Modificación:   <17/05/2021> <Roger Lara> <Se agreg descripcion del documento> 
-- Modificación:   <03/06/2021> <Fabian Sequeira> <Se agrega el tipo de medio y el valor> 
-- Modificación:   <20/09/2021> <Aida Elena Siles R> <Se agrega parámetro RetornaDocPrincipal y se corrige problema de registros duplicados>
-- Modificación:   <13/10/2021> <Kirvin Bennett> <Se agrega el filtro si la notificación fue leída> 
-- Modificación:   <28/01/2022> <Michael Arroyo> <Se modifica para que funcione el filtro si la notificación fue leída>
-- Modificación:   <01/02/2022> <Michael Arroyo> <Se modifica para que funcione el filtro por FechaNotificacionHasta e incluya esa misma fecha en el resultado> 
-- Modificación:   <01/03/2022> <Jonathan Aguilar Navarro, Esteban Cordero Benavides> <Se modifica el sp para retornar correctamente el total de registros y se optimiza la consulta.> 
-- Modificación:   <04/04/2022> <Jonathan Aguilar Navarro> <Se modifica el sp para que retorne correctamente los resultados ademas se agrega filtro por identificación, por error se habia omitido>
-- Modificación:   <07/04/2022> <Jonathan Aguilar Navarro> <Se modifica el sp para que retorne correctamente los código de documentos y actas> 
-- =====================================================================================================================================================================      
CREATE   PROCEDURE [Comunicacion].[PA_ConsultarBuzonOficina]             
(            
	 @NumeroPagina					INT,            
	 @CantidadRegistros				INT,            
	 @CodigoContextoEmisor			VARCHAR(4)	= NULL,           
	 @CodigoContextoComunicacion	VARCHAR(4)  = NULL,            
	 @TipoComunicacion				CHAR(1)		= NULL,            
	 @CodigoEstado					CHAR(1)		= NULL,            
	 @CodigoMedioComunicacion		SMALLINT	= NULL,            
	 @FechaIngresoDesde				DATETIME	= NULL,            
	 @FechaIngresoHasta				DATETIME	= NULL,            
	 @NumeroExpediente				CHAR(14)	= NULL,            
	 @CodigoResultado				CHAR(1)		= NULL,  
	 @Identificacion				VARCHAR(21) = NULL,  
	 @FechaNotificacionDesde		DATETIME	= NULL,            
	 @FechaNotificacionHasta		DATETIME	= NULL,
	 @RetornaArchivos				BIT			= NULL, --Este párametro retorna el acta y el(los) documento(s) de la comunicación. Se utiliza en Gestión en Línea.
	 @RetornaDocPrincipal			BIT			= NULL,  --Retorna el documento principal de la comunicación. Se utiliza en SIAGPJ.
 	 @Leido							BIT			= NULL
)            
AS            
BEGIN            
	 DECLARE @L_NumeroPagina					INT				= @NumeroPagina				
	 DECLARE @L_CantidadRegistros				INT				= @CantidadRegistros			
	 DECLARE @L_CodigoContextoEmisor			VARCHAR(4)		= @CodigoContextoEmisor		
	 DECLARE @L_CodigoContextoComunicacion		VARCHAR(4)		= @CodigoContextoComunicacion
	 DECLARE @L_TipoComunicacion				CHAR(1)			= @TipoComunicacion		
	 DECLARE @L_CodigoEstado					CHAR(1)			= @CodigoEstado				
	 DECLARE @L_CodigoMedioComunicacion			SMALLINT		= @CodigoMedioComunicacion	
	 DECLARE @L_FechaIngresoDesde				DATETIME2(7)	= IIF (@FechaIngresoDesde IS NULL,NULL,
																	DATEFROMPARTS(
																	DATEPART(YEAR, @FechaIngresoDesde),
																	DATEPART(MONTH, @FechaIngresoDesde),
																	DATEPART(DAY, @FechaIngresoDesde)
																	))		
	 DECLARE @L_FechaIngresoHasta				DATETIME2(7)	= IIF (@FechaIngresoHasta IS NULL,NULL,
																	DATEFROMPARTS(
																	DATEPART(YEAR, dateadd(day,1,@FechaIngresoHasta)),
																	DATEPART(MONTH,dateadd(day,1,@FechaIngresoHasta)),
																	DATEPART(DAY, dateadd(day,1,@FechaIngresoHasta)	)
																	))			
	 DECLARE @L_NumeroExpediente				CHAR(14)		= @NumeroExpediente			
	 DECLARE @L_CodigoResultado					CHAR(1)			= @CodigoResultado			
	 DECLARE @L_Identificacion					VARCHAR(21)		= @Identificacion			
	 DECLARE @L_FechaNotificacionDesde			DATETIME2(7)	= IIF (@FechaNotificacionDesde IS NULL,NULL,
																	DATEFROMPARTS(
																	DATEPART(YEAR, @FechaNotificacionDesde),
																	DATEPART(MONTH, @FechaNotificacionDesde),
																	DATEPART(DAY, @FechaNotificacionDesde)
																	))	
	 DECLARE @L_FechaNotificacionHasta			DATETIME2(7)	= IIF (@FechaNotificacionHasta IS NULL,NULL,
																	DATEFROMPARTS(
																	DATEPART(YEAR, dateadd(day,1,@FechaNotificacionHasta)),
																	DATEPART(MONTH,dateadd(day,1,@FechaNotificacionHasta)),
																	DATEPART(DAY, dateadd(day,1,@FechaNotificacionHasta)	)
																	))	
	 DECLARE @L_RetornaArchivos					BIT				= @RetornaArchivos			
	 DECLARE @L_RetornaDocPrincipal				BIT				= @RetornaDocPrincipal		
 	 DECLARE @L_Leido							BIT				= @Leido
	 DECLARE @L_TotalRegistros					SMALLINT		= 0
	 ;    
	             
 	DECLARE @IDS TABLE
	(
		CodigoComunicacion	UNIQUEIDENTIFIER	NOT NULL
	);
	
	INSERT INTO	@IDS
	(
		CodigoComunicacion
	)
	SELECT		C.TU_CodComunicacion
	FROM		Comunicacion.Comunicacion	C WITH(NOLOCK)
	WHERE		C.TC_CodContexto	= ISNULL(@L_CodigoContextoEmisor,C.TC_CodContexto)   
	ORDER BY	TC_Estado					DESC, 
				TF_FechaEnvio				ASC, 
				TU_CodComunicacion			ASC;
	

	
	DECLARE @COMUNICACIONES TABLE
(
			id								INT IDENTITY,
			CodigoComunicacion	          	UNIQUEIDENTIFIER	NOT NULL,	
			ConsecutivoComunicacion			VARCHAR(35)			NOT NULL,
			Rotulado						VARCHAR(255)		NULL,	
			Observaciones					VARCHAR(255)		NULL,
			RequiereCopias					BIT					NOT NULL,	
PrioridadMedio					BIT					NOT NULL,
			CodigoLegajo					UNIQUEIDENTIFIER	NULL,
			Valor 							VARCHAR(350)		NULL,
			CodigoInterviniente         	UNIQUEIDENTIFIER	NOT NULL,
			CodigoMedioComunicacion 		SMALLINT			NOT NULL,
			DescripcionMedioComunicacion	VARCHAR(255)		NULL,
			NumeroExpediente            	VARCHAR(14)			NULL,
			FechaRegistro            		DATETIME2(7)		NULL,			
			CodigoContextoOCJ           	VARCHAR(4)			NOT NULL,	
			NombreContextoOCJ           	VARCHAR(255)		NULL,
			CodigoPuestoTrabajo         	VARCHAR(14)			NULL,
			NombreDestinatario				VARCHAR(150)		NULL,
			CodigoTipoComunicacionJudicial	CHAR(1)				NOT NULL,
			TienePrioridad					BIT					NOT NULL,
			Cancelada						BIT					NOT NULL,
			FechaIngreso					DATETIME2(7)		NULL,
			CodigoMotivoResultado			SMALLINT			NULL,
			FechaResultado					DATETIME2(7)		NULL,
			NombreComercialDestinatario		VARCHAR(150)		NULL,
			FechaResolucion					DATETIME2(7)		NULL,
			CodigoContextoEmisor			VARCHAR(4)			NOT NULL,
			NombreContextoEmisor			VARCHAR(255)		NULL,
			Leido							BIT					NULL,
			CodigoArchivoActa				UNIQUEIDENTIFIER	NULL,
			CodigoArchivoDocumento			UNIQUEIDENTIFIER	NULL,
			DescripcionDocumento			VARCHAR(255)		NULL,
			EsPrincipal						BIT					NULL,
			Split							VARCHAR(5)			NOT NULL,
			Resultado						CHAR(1)				NULL,
			SplitEstado						VARCHAR(11)			NOT NULL,            
			Estado							CHAR(1)				NOT NULL,            
			SplitTipo						VARCHAR(9)			NOT NULL,            
			TipoComunicacion				CHAR(1)				NOT NULL,  
			TipoMedio						CHAR(1)				NOT NULL,
			SplitTotalRegistros				VARCHAR(19)			NOT NULL,
			TotalRegistros					INT					NULL
	    );
	
	INSERT INTO	@COMUNICACIONES
	(
			CodigoComunicacion,									ConsecutivoComunicacion,						Rotulado,				Observaciones,					
			RequiereCopias,										PrioridadMedio,									CodigoLegajo,			Valor, 							
			CodigoInterviniente,
			CodigoMedioComunicacion,							NumeroExpediente,								FechaRegistro,			CodigoContextoOCJ,       	
			CodigoPuestoTrabajo,								CodigoTipoComunicacionJudicial,					TienePrioridad,			Cancelada,						
			FechaIngreso,										CodigoMotivoResultado,							FechaResultado,			FechaResolucion,					
			CodigoContextoEmisor,								Leido,											
			CodigoArchivoActa,									CodigoArchivoDocumento,							DescripcionDocumento,	EsPrincipal,
			Split,												Resultado,										SplitEstado,							
			Estado,												SplitTipo,										TipoComunicacion,		TipoMedio,
			SplitTotalRegistros
	)
	SELECT		C.TU_CodComunicacion,							C.TC_ConsecutivoComunicacion,					C.TC_Rotulado,			C.TC_Observaciones,
				C.TB_RequiereCopias,							C.TN_PrioridadMedio,							C.TU_CodLegajo,			C.TC_Valor,
				CI.TU_CodInterviniente,
				C.TC_CodMedio,									C.TC_NumeroExpediente,							C.TF_FechaEnvio,		C.TC_CodContextoOCJ,
				C.TC_CodPuestoTrabajo,							C.TC_TipoComunicacion,							C.TB_TienePrioridad,	C.TB_Cancelar,
				C.TF_FechaEnvio,								C.TN_CodMotivoResultado,						C.TF_FechaResultado,	C.TF_FechaResolucion,
				C.TC_CodContexto,								CI.TB_Leido,
				NULL,	 NULL,	NULL,		NULL,
				'Split',										C.TC_Resultado,									'SplitEstado',
				C.TC_Estado,									'SplitTipo',									C.TC_TipoComunicacion,	TMC.TC_TipoMedio,
				'SplitTotalRegistros'
	FROM		@IDS											ID    
	INNER JOIN	Comunicacion.Comunicacion						C WITH(NOLOCK)
	ON			C.TU_CodComunicacion							= ID.CodigoComunicacion
	INNER JOIN	Catalogo.TipoMedioComunicacion					AS TMC WITH(NOLOCK)				      
	ON			TMC.TN_CodMedio									= C.TC_CodMedio  
	AND			C.TC_CodMedio									= ISNULL(@L_CodigoMedioComunicacion, C.TC_CodMedio)
	INNER JOIN	Comunicacion.ComunicacionIntervencion			CI WITH(NOLOCK)            
	ON			CI.TU_CodComunicacion							= C.TU_CodComunicacion 
	AND			CI.TB_Principal									= 1
	AND			CI.TB_Leido										= ISNULL(@L_Leido, CI.TB_Leido)
	INNER JOIN  Expediente.Intervencion							AS I WITH(NOLOCK)
	ON			I.TU_CodInterviniente							= CI.TU_CodInterviniente
	INNER JOIN Persona.Persona									AS PP WITH(NOLOCK)
	ON			PP.TU_CodPersona								= I.TU_CodPersona
	AND			ISNULL(PP.TC_Identificacion, '')				= ISNULL(@L_Identificacion, ISNULL(PP.TC_Identificacion, ''))
	WHERE		C.TC_CodContextoOCJ								= ISNULL(@L_CodigoContextoComunicacion, C.TC_CodContextoOCJ)
	AND			C.TC_TipoComunicacion							= ISNULL(@L_TipoComunicacion, C.TC_TipoComunicacion)
	AND			C.TC_Estado										= ISNULL(@L_CodigoEstado, C.TC_Estado)
	AND			ISNULL(C.TC_Resultado, '')						= ISNULL(@L_CodigoResultado, ISNULL(C.TC_Resultado, ''))
	AND			ISNULL(C.TC_NumeroExpediente, '')				= ISNULL(@L_NumeroExpediente, ISNULL(C.TC_NumeroExpediente, ''))
	AND			(
					ISNULL(C.TF_FechaEnvio, SYSDATETIME())			>= ISNULL(@L_FechaIngresoDesde, ISNULL(C.TF_FechaEnvio, SYSDATETIME()))
				AND			
					ISNULL(C.TF_FechaEnvio, SYSDATETIME())			<= ISNULL(@L_FechaIngresoHasta, ISNULL(C.TF_FechaEnvio, SYSDATETIME()))
				)
	AND			(
					ISNULL(C.TF_FechaResultado, SYSDATETIME())		>= ISNULL(@L_FechaNotificacionDesde, ISNULL(C.TF_FechaResultado, SYSDATETIME()))
				AND			
					ISNULL(C.TF_FechaResultado, SYSDATETIME())		<= ISNULL(@L_FechaNotificacionHasta, ISNULL(C.TF_FechaResultado, SYSDATETIME())) 
)
	--
	UPDATE		A
	SET			A.TotalRegistros	= @@ROWCOUNT
	FROM		@COMUNICACIONES		A
--
	UPDATE		A
	SET			NombreDestinatario			= CASE 
												WHEN IPF.TU_CodPersona IS NOT NULL THEN IPF.TC_Nombre + ' ' + IPF.TC_PrimerApellido + ' ' + ISNULL(IPF.TC_SegundoApellido,'')
												WHEN IPJ.TU_CodPersona IS NOT NULL THEN IPJ.TC_Nombre
											  END,
				NombreComercialDestinatario	= IPJ.TC_NombreComercial
	FROM		@COMUNICACIONES	A
	INNER JOIN	Expediente.Intervencion		IT WITH(NOLOCK)
	ON			IT.TU_CodInterviniente		= A.CodigoInterviniente
	LEFT JOIN	Persona.PersonaFisica		AS IPF WITH(NOLOCK)      
	ON			IPF.TU_CodPersona			= IT.TU_CodPersona
	LEFT JOIN	Persona.PersonaJuridica		AS IPJ WITH(NOLOCK)      
	ON			IPJ.TU_CodPersona			= IT.TU_CodPersona
	--
	UPDATE		A
	SET			A.DescripcionMedioComunicacion	= B.TC_Descripcion
	FROM		@COMUNICACIONES					A
	INNER JOIN	Catalogo.TipoMedioComunicacion	B WITH(NOLOCK)
	ON			B.TN_CodMedio					= A.CodigoMedioComunicacion
	--
	UPDATE		A
	SET			A.NombreContextoOCJ	= B.TC_Descripcion
	FROM		@COMUNICACIONES		A
	INNER JOIN	Catalogo.Contexto	B WITH(NOLOCK)
	ON			B.TC_CodContexto	= A.CodigoContextoOCJ
	--
	UPDATE		A
SET			A.NombreContextoEmisor	= B.TC_Descripcion
	FROM		@COMUNICACIONES			A
	INNER JOIN	Catalogo.Contexto		B WITH(NOLOCK)
	ON			B.TC_CodContexto		= A.CodigoContextoEmisor
	--
	IF (ISNULL(@RetornaArchivos,0) <> 0 )  
	BEGIN
		UPDATE		A
		SET			A.CodigoArchivoActa		 = B.TU_CodArchivo,
					A.CodigoArchivoDocumento = ACD.TU_CodArchivo
		FROM		@COMUNICACIONES			A
		LEFT JOIN  Comunicacion.ArchivoComunicacion	B WITH(NOLOCK)            
						 ON			B.TU_CodComunicacion				= A.CodigoComunicacion 
						 AND		B.TB_EsActa							= 1 
						 LEFT JOIN  Comunicacion.ArchivoComunicacion	ACD WITH(NOLOCK)            
						 ON			ACD.TU_CodComunicacion				= A.CodigoComunicacion 
						 AND		ACD.TB_EsActa						= 0
	END

	IF (ISNULL(@RetornaDocPrincipal,0) <> 0 )  
	BEGIN
		UPDATE		A
		SET			A.CodigoArchivoDocumento		= AA.TU_CodArchivo,
					A.DescripcionDocumento			= AA.TC_Descripcion, 
					A.EsPrincipal					= B.TB_EsPrincipal
		FROM		@COMUNICACIONES			A
		LEFT JOIN  Comunicacion.ArchivoComunicacion	B WITH(NOLOCK)            
						 ON			B.TU_CodComunicacion				= A.CodigoComunicacion
						 AND		B.TB_EsPrincipal					= 1
						 LEFT JOIN  Archivo.Archivo						AA WITH(NOLOCK)
						 ON			B.TU_CodArchivo						= AA.TU_CodArchivo
	END

	SET ROWCOUNT @CantidadRegistros;

	SELECT		
	CodigoComunicacion				,      	
	ConsecutivoComunicacion			,
	Rotulado						,
	Observaciones					,
	RequiereCopias					,
	PrioridadMedio					,
	CodigoLegajo					,
	Valor 							,
	CodigoInterviniente         	,
	CodigoMedioComunicacion 		,
	DescripcionMedioComunicacion	,
	NumeroExpediente            	,
	FechaRegistro            		,
	CodigoContextoOCJ           	,
	NombreContextoOCJ           	,
	CodigoPuestoTrabajo         	,
	NombreDestinatario				,
	CodigoTipoComunicacionJudicial	,
	TienePrioridad					,
	Cancelada						,
	FechaIngreso					,
	CodigoMotivoResultado			,
	FechaResultado					,
	NombreComercialDestinatario		,
	FechaResolucion					,
	CodigoContextoEmisor			,
	NombreContextoEmisor			,
	Leido							,
	CodigoArchivoActa				,
	CodigoArchivoDocumento			,
	DescripcionDocumento			,
	EsPrincipal						,
	Split							,
	Resultado						,
	SplitEstado						,
	Estado							,
	SplitTipo						,
	TipoComunicacion				,
	TipoMedio						,
	SplitTotalRegistros				,
	TotalRegistros					

	FROM		@COMUNICACIONES
	WHERE		id > (@L_NumeroPagina -1) * @L_CantidadRegistros
	ORDER BY	Estado				DESC, 
				FechaIngreso		ASC, 
CodigoComunicacion	ASC

	SET ROWCOUNT 0;
END
GO
