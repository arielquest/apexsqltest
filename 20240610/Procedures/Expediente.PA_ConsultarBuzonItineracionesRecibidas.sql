SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<04/12/2020>
-- Descripción :			<Permite consultar las itineraciones recibidas.>
-- =============================================================================================================================================================================
-- Modificación:			<09/12/2020> <Henry Méndez Ch> <Se agrega el campo FechaEnvio para los expedientes>
-- Modificación:			<17/12/2020> <Jose Gabriel Cordero Soto> <Se agrega los valores necesarios para el arhivo asociado a la solicitud (documento)>
-- Modificación:			<25/01/2021> <Aida Elena Siles R> <Se modifica el tipo de dato del codigo clase asunto por INT ya que se cambio en la tabla catálogo>
-- Modificación:			<25/02/2021> <Aida Elena Siles R> <Ajuste en los tamaÏos de los campos nombre, apellido1 y apellido2>
-- Modificación:			<24/06/2021> <Ronny Ram­írez R.> <Se agrega la consulta para las itineraciones recibidas desde la BD de Itineraciones de Gestión>
-- Modificación:			<07/07/2021> <Ronny Ram­írez R.> <Se agrega Motivo de itineración por defecto en caso de no encontrar equivalencia para los registros de Gestión>
-- Modificación:			<12/07/2021> <Luis Alonso Leiva Tames> <Se aplica cambio para que los recursos  de GESTION puedan mostrar los datos>
-- Modificación:			<23/07/2021> <Luis Alonso Leiva Tames> <Se aplica cambio para que los resultados de recursos y solicitud de GESTION>
-- Modificación:			<11/08/2021> <Luis Alonso Leiva Tames> <Se aplica cambio para Ordenamiento en el resultado>
-- Modificación:			<23/08/2021> <Ronny Ram­írez R.> <Se aplica filtro para que las itineraciones recibidas desde la BD de Itineraciones de Gestión no se consulten desde
--							la BD de SIAGPJ, para que se vean los datos igual a como llegaron al buzon de recibir, esto mientras no se tenga una mejora para esto>
-- Modificación:			<29/09/2022> <Josué Quirós Batista><Se valida la fecha de la resolución y fecha de creación de documento en caso de ser vac¡o.>	
-- Modificación:			<10/03/2023> <Josué Quirós Batista> <Se agrega la instrucción WITH(NOLOCK) en las subConsultas faltantes.>
-- Modificación:			<14/06/2023> <Ronny Ram­írez R.> <Se aplica optimización en la consulta para mejorar los tiempos de respuesta, con 50 registros tarda <= 1 segundo> 
-- Modificación:			<30/10/2023> <Josué Quirós Batista> <Se agrega la descripción del archivo asociado.>
-- =============================================================================================================================================================================
 CREATE   PROCEDURE [Expediente].[PA_ConsultarBuzonItineracionesRecibidas]
	@NumeroPagina		SMALLINT,
	@CantidadRegistros	SMALLINT,
	@ContextoDestino	VARCHAR(4)					= NULL,
	@ContextoOrigen		VARCHAR(4)					= NULL,
	@NumeroExpediente	CHAR(14)					= NULL,
	@FechaInicio		DATETIME2(3)				= NULL,
	@FechaFinal			DATETIME2(3)				= NULL,
	@ListaEstados		EstadosBuzPendRecibirType	READONLY
AS 

BEGIN
--Variables 
DECLARE	@L_ContextoDestino				VARCHAR(4)				= @ContextoDestino,
		@L_ContextoOrigen				VARCHAR(4)				= @ContextoOrigen,
		@L_NumeroExpediente				CHAR(14)				= @NumeroExpediente,
		@L_FechaInicio					DATETIME2(3)			= @FechaInicio,
		@L_FechaFinal					DATETIME2(3)			= @FechaFinal,
		@L_NumeroPagina					INT = Iif((@NumeroPagina IS NULL OR @NumeroPagina <= 0), 1, @NumeroPagina),
		@L_CantidadRegistros			INT = Iif((@CantidadRegistros IS NULL OR @CantidadRegistros <= 0), 50, @CantidadRegistros),
		@L_GuidEmpty					UNIQUEIDENTIFIER		= '00000000-0000-0000-0000-000000000000',
		@L_MotivoItineracionOtro		VARCHAR(9)				= NULL,
		@L_MotivoItineracionOtroSIAGPJ	SMALLINT				= NULL

	-- Se consulta las equivalencias entre catálogos de Itineraciones y SIAGPJ
	DECLARE	@EquivalenciasCatalogosItineracionSIAGPJ TABLE
		(
				CodigoCatalogo					VARCHAR(255)		NOT NULL,
				CodConfiguracion                VARCHAR(27)			NOT NULL
		)

	INSERT INTO @EquivalenciasCatalogosItineracionSIAGPJ
	SELECT	TC_Valor, TC_CodConfiguracion
	FROM	Configuracion.ConfiguracionValor		WITH(NOLOCK)
	WHERE	TC_CodConfiguracion						IN	(	
															'C_EstadoItineracionRecibida', 
															'C_EstadoItineracErrorRecibi', 
															'C_TipoItineracionRecurso',
															'C_TipoItineracionExpediente',
															'C_TipoItineracionSolicitud',
															'C_TipoItineracionLegajo',
															'C_TipoItineracionResultadoS',
															'C_TipoItineracionResultadoR',
															'C_MotivoItineracionOtro',
															'U_IndicadorExpGestion'
														)
	AND		TF_FechaActivacion						<=	GETDATE() 
	AND		(
					TF_FechaCaducidad				IS NULL 
				OR	TF_FechaCaducidad				>	GETDATE()
			)

	-- Se obtiene el código de motivo de itineración de la BD de itineraciones para la equivalencia con SIAGPJ
	SELECT	@L_MotivoItineracionOtro		= M.CODMOT,
			@L_MotivoItineracionOtroSIAGPJ	= M.TN_CodMotivoItineracion
	FROM	Catalogo.MotivoItineracion		M WITH(NOLOCK) 
	WHERE	M.TN_CodMotivoItineracion = (
		SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_MotivoItineracionOtro'
	)		

	DECLARE	@ResultadoTodo TABLE
	(
			FechaCreacion					DATETIME2(3)		NOT NULL,
			FechaRecibido                   DATETIME2(3)        NOT NULL,   
			Acumulado						BIT					NOT NULL DEFAULT 0,
			MensajeError					VARCHAR(255)        NULL,
			SplitDatos						CHAR(15)			NOT NULL DEFAULT 'SplitDatos',
			CodigoItineracion				UNIQUEIDENTIFIER	NOT NULL,
			CodigoHistoricoItineracion		UNIQUEIDENTIFIER	NOT NULL,
			CodigoTipoItineracion			SMALLINT			NOT NULL,
			TipoItineracionDescripcion		VARCHAR(255)		NULL,
			CodigoEstadoItineracion			SMALLINT			NULL, 
			DescripcionEstadoItineracion	VARCHAR(255)		NULL, 
			CodigoMotivoItineracion			SMALLINT			NULL,
			DescripcionMotivoItineracion	VARCHAR(255)		NULL,	
			CodigoOficinaDestino			VARCHAR(4)			NOT NULL,
			DescripcionOficinaDestino		VARCHAR(255)		NOT NULL,
			CodigoContextoDestino			VARCHAR(4)			NOT NULL,
			DescripcionContextoDestino		VARCHAR(255)		NOT NULL,
			CodigoTipoOficinaDestino		SMALLINT			NOT NULL,
			CodigoMateriaOficinaDest		VARCHAR(5)			NOT NULL,
			CodigoOficinaOrigen				VARCHAR(4)			NOT NULL,
			DescripcionOficinaOrigen		VARCHAR(255)		NULL,
			CodigoContextoOrigen			VARCHAR(4)			NOT NULL,
			DescripcionContextoOrigen       VARCHAR(255)		NOT NULL,
			CodigoContextoLegajo			VARCHAR(4)			NULL,
			Confidencial					BIT                 NOT NULL,
			CodigoResultadoRecurso			UNIQUEIDENTIFIER	NULL,
		    CodigoResultadoSolicitud		UNIQUEIDENTIFIER	NULL,
			CodResultadoLegajo				SMALLINT            NULL,
			DescripcionResultadoLegajo		VARCHAR(255)		NULL,
			CodigoLegajoResultadoRecurso	UNIQUEIDENTIFIER	NULL,
			CodigoLegajoResultadoSolicitud	UNIQUEIDENTIFIER	NULL,
			CodigoRecursoResultadoLegajo	UNIQUEIDENTIFIER    NULL,
			CodigoSolicitudResultadoLegajo	UNIQUEIDENTIFIER	NULL,
			DescripcionSolicitud			VARCHAR(255)		NULL, 			
			CodigoArchivoSolicitud			UNIQUEIDENTIFIER	NULL,
			DescripcionArchivoSolicitud     VARCHAR(255)		NULL,
			NombreUsuarioDocumento			VARCHAR(50)         NULL,
            PrimerApellidoDocumento			VARCHAR(50)         NULL,
            SegundoApellidoDocumento		VARCHAR(50)         NULL,
            FechaCreacionDocumento			DATETIME2(3)		NULL,
			UsuarioRedDocumento				VARCHAR(30)         NULL,
			UsuarioResuelve					VARCHAR(30)			NULL,
			NombreUsuarioResuelve			VARCHAR(30)			NULL,
			PrimerApellidoResuelve			VARCHAR(30)         NULL,
			SegundoApellidoResuelve			VARCHAR(30)         NULL,     
			SplitExpediente					CHAR(15)			NOT NULL DEFAULT 'SplitExpediente',
			Numero							CHAR(14)			NOT NULL,
			Descripcion						VARCHAR(255)		NULL,
			CodigoClase						INT					NULL,
			DescripcionClase				VARCHAR(200)		NULL,
			CodigoProceso					SMALLINT			NULL,
			DescripcionProceso				VARCHAR(100)		NULL,
			CodigoFase						smallint			NULL,
			SplitLegajo						CHAR(15)			NOT NULL DEFAULT 'SplitLegajo',
			CodigoLegajo					UNIQUEIDENTIFIER	NULL,
			CodigoAsunto					INT					NULL,
			DescripcionLegajo				VARCHAR(255)		NULL,
			DescripcionAsunto				VARCHAR(200)		NULL,
			CodigoClaseAsunto				INT					NULL,
			DescripcionClaseAsunto			VARCHAR(200)		NULL,
			SplitRecurso					CHAR(15)			NOT NULL DEFAULT 'SplitRecurso',
			CodigoRecurso					UNIQUEIDENTIFIER	NULL,
			CodigoClaseAsuntoRecurso		INT			NULL,
			DescripcionClaseAsuntoRecurso	VARCHAR(255)		NULL,
			CodigoAsuntoRecurso				INT					NULL,
			DescripcionAsuntoRecurso		VARCHAR(255)        NULL,
			TipoResolucionRecurso			VARCHAR(255)		NULL,
			TipoResultadoRecurso			VARCHAR(255)		NULL,
			RedactorRecurso					VARCHAR(255)		NULL,
			FechaResolucion					DATETIME2(7)		NULL,
			HoraResolucion					VARCHAR(50)			NULL,
			NumeroResolucion				CHAR(14)			NULL,
			NumeroExpedienteRecurso			VARCHAR(14)			NULL,
			CodigoArchivoResolucion			UNIQUEIDENTIFIER	NULL,
			SplitSolicitud					CHAR(15)			NOT NULL DEFAULT 'SplitSolicitud',
			CodigoSolicitud					UNIQUEIDENTIFIER	NULL,
			CodigoClaseAsuntoSolicitud		INT					NULL,
			DescripcionClaseAsuntoSolicitud	VARCHAR(255)		NULL,			
			FechaEnvio                      DATETIME2(3)        NULL,			
			CodigoItineracionGestion		UNIQUEIDENTIFIER	NULL
	)

	DECLARE	@Result TABLE
	(
			FechaCreacion					DATETIME2(3)		NOT NULL,
			FechaRecibido                   DATETIME2(3)        NOT NULL,   
			Acumulado						BIT					NOT NULL DEFAULT 0,
			MensajeError					VARCHAR(255)        NULL,
			SplitDatos						CHAR(15)			NOT NULL DEFAULT 'SplitDatos',
			CodigoItineracion				UNIQUEIDENTIFIER	NOT NULL,
			CodigoHistoricoItineracion		UNIQUEIDENTIFIER	NOT NULL,
			CodigoTipoItineracion			SMALLINT			NOT NULL,
			TipoItineracionDescripcion		VARCHAR(255)		NULL,
			CodigoEstadoItineracion			SMALLINT			NULL, 
			DescripcionEstadoItineracion	VARCHAR(255)		NULL, 
			CodigoMotivoItineracion			SMALLINT			NULL,
			DescripcionMotivoItineracion	VARCHAR(255)		NULL,	
			CodigoOficinaDestino			VARCHAR(4)			NOT NULL,
			DescripcionOficinaDestino		VARCHAR(255)		NOT NULL,
			CodigoContextoDestino			VARCHAR(4)			NOT NULL,
			DescripcionContextoDestino		VARCHAR(255)		NOT NULL,
			CodigoTipoOficinaDestino		SMALLINT			NOT NULL,
			CodigoMateriaOficinaDest		VARCHAR(5)			NOT NULL,
			CodigoOficinaOrigen				VARCHAR(4)			NOT NULL,
			DescripcionOficinaOrigen		VARCHAR(255)		NULL,
			CodigoContextoOrigen			VARCHAR(4)			NOT NULL,
			DescripcionContextoOrigen       VARCHAR(255)		NOT NULL,
			CodigoContextoLegajo			VARCHAR(4)			NULL,
			Confidencial					BIT                 NOT NULL,
			CodigoResultadoRecurso			UNIQUEIDENTIFIER	NULL,
		    CodigoResultadoSolicitud		UNIQUEIDENTIFIER	NULL,
			CodResultadoLegajo				SMALLINT            NULL,
			DescripcionResultadoLegajo		VARCHAR(255)		NULL,
			CodigoLegajoResultadoRecurso	UNIQUEIDENTIFIER	NULL,
			CodigoLegajoResultadoSolicitud	UNIQUEIDENTIFIER	NULL,
			CodigoRecursoResultadoLegajo	UNIQUEIDENTIFIER    NULL,
			CodigoSolicitudResultadoLegajo	UNIQUEIDENTIFIER	NULL,
			DescripcionSolicitud			VARCHAR(255)		NULL, 			
			CodigoArchivoSolicitud			UNIQUEIDENTIFIER	NULL,
			DescripcionArchivoSolicitud     VARCHAR(255)		NULL,
			NombreUsuarioDocumento			VARCHAR(50)         NULL,
            PrimerApellidoDocumento			VARCHAR(50)         NULL,
            SegundoApellidoDocumento		VARCHAR(50)         NULL,
            FechaCreacionDocumento			DATETIME2(3)		NULL,
			UsuarioRedDocumento				VARCHAR(30)         NULL,
			UsuarioResuelve					VARCHAR(30)			NULL,
			NombreUsuarioResuelve			VARCHAR(30)			NULL,
			PrimerApellidoResuelve			VARCHAR(30)         NULL,
			SegundoApellidoResuelve			VARCHAR(30)         NULL,    
			SplitExpediente					CHAR(15)			NOT NULL DEFAULT 'SplitExpediente',
			Numero							CHAR(14)			NOT NULL,
			Descripcion						VARCHAR(255)		NULL,
			CodigoClase						INT					NULL,
			DescripcionClase				VARCHAR(200)		NULL,
			CodigoProceso					SMALLINT			NULL,
			DescripcionProceso				VARCHAR(100)		NULL,
			CodigoFase						smallint			NULL,
			SplitLegajo						CHAR(15)			NOT NULL DEFAULT 'SplitLegajo',
			CodigoLegajo					UNIQUEIDENTIFIER	NULL,
			CodigoAsunto					INT					NULL,
			DescripcionLegajo				VARCHAR(255)		NULL,
			DescripcionAsunto				VARCHAR(200)		NULL,
			CodigoClaseAsunto				INT					NULL,
			DescripcionClaseAsunto			VARCHAR(200)		NULL,
			SplitRecurso					CHAR(15)			NOT NULL DEFAULT 'SplitRecurso',
			CodigoRecurso					UNIQUEIDENTIFIER	NULL,
			CodigoClaseAsuntoRecurso		INT			NULL,
			DescripcionClaseAsuntoRecurso	VARCHAR(255)		NULL,
			CodigoAsuntoRecurso				INT					NULL,
			DescripcionAsuntoRecurso		VARCHAR(255)        NULL,
			TipoResolucionRecurso			VARCHAR(255)		NULL,
			TipoResultadoRecurso			VARCHAR(255)		NULL,
			RedactorRecurso					VARCHAR(255)		NULL,
			FechaResolucion					DATETIME2(7)		NULL,
			HoraResolucion					VARCHAR(50)			NULL,
			NumeroResolucion				CHAR(14)			NULL,
			NumeroExpedienteRecurso			VARCHAR(14)			NULL,
			CodigoArchivoResolucion			UNIQUEIDENTIFIER	NULL,
			SplitSolicitud					CHAR(15)			NOT NULL DEFAULT 'SplitSolicitud',
			CodigoSolicitud					UNIQUEIDENTIFIER	NULL,
			CodigoClaseAsuntoSolicitud		INT					NULL,
			DescripcionClaseAsuntoSolicitud	VARCHAR(255)		NULL,			
			FechaEnvio                      DATETIME2(3)        NULL,			
			CodigoItineracionGestion		UNIQUEIDENTIFIER	NULL
	)

	INSERT INTO	@ResultadoTodo
	(
				CodigoItineracion,
				CodigoHistoricoItineracion,
				FechaCreacion,	
				FechaRecibido,
				Numero,
				Descripcion,
				CodigoLegajo,				
				DescripcionLegajo,
				CodigoRecurso,
				CodigoSolicitud,
				CodigoTipoItineracion,
				TipoItineracionDescripcion,	
				CodigoEstadoItineracion,			
				DescripcionEstadoItineracion,
				CodigoMotivoItineracion,
				CodigoOficinaDestino,
				DescripcionOficinaDestino,
				CodigoContextoDestino,					
				DescripcionContextoDestino,
				CodigoTipoOficinaDestino,
				CodigoMateriaOficinaDest,
				CodigoOficinaOrigen,
				DescripcionOficinaOrigen,
				CodigoContextoOrigen,
				DescripcionContextoOrigen,
				CodigoContextoLegajo,
				Acumulado,
				Confidencial,
				MensajeError,
				CodigoResultadoRecurso,			
				CodigoResultadoSolicitud,
				CodResultadoLegajo,			
				DescripcionResultadoLegajo,		
				CodigoLegajoResultadoRecurso,	
				CodigoLegajoResultadoSolicitud,	
				CodigoRecursoResultadoLegajo,
				CodigoSolicitudResultadoLegajo,			    
				FechaEnvio, 
				CodigoItineracionGestion,
				UsuarioResuelve			,
				NombreUsuarioResuelve	,
				PrimerApellidoResuelve	,
				SegundoApellidoResuelve	   
	)

	-- Expedientes
	SELECT		I.TU_CodItineracion					CodigoItineracion,
				I.TU_CodHistoricoItineracion		CodigoHistoricoItineracion,
				ES.TF_CreacionItineracion			FechaCreacion,
				I.TF_FechaEstado 					FechaRecibido,
				I.TC_NumeroExpediente				Numero,
				E.TC_Descripcion					Descripcion,
				@L_GuidEmpty						CodigoLegajo,
				NULL								DescripcionLegajo,
				@L_GuidEmpty						CodigoRecurso,
				@L_GuidEmpty						CodigoSolicitud,
				I.TN_CodTipoItineracion				CodigoTipoItineracion,
				NULL								TipoItineracionDescripcion,	
				I.TN_CodEstadoItineracion			CodigoEstadoItineracion,		
				NULL								DescripcionEstadoItineracion,
				ES.TN_CodMotivoItineracion			CodigoMotivoItineracion,
				OD.TC_CodOficina					CodigoOficinaDestino,
				OD.TC_Nombre						DescripcionOficinaDestino,
				I.TC_CodContextoDestino				CodigoContextoDestino,			
				CD.TC_Descripcion					DescripcionContextoDestino,
				OD.TN_CodTipoOficina				CodigoTipoOficinaDestino,
				CD.TC_CodMateria					CodigoMateriaOficinaDest,
				CO.TC_CodOficina					CodigoOficinaOrigen,
				NULL								DescripcionOficinaOrigen,
				I.TC_CodContextoOrigen				CodigoContextoOrigen,
				CO.TC_Descripcion					DescripcionContextoOrigen,
				NULL								CodigoContextoLegajo,
				EA.Acumulados						Acumulado,
				E.TB_Confidencial					Confidencial,
				I.TC_MensajeError					MensajeError,
				NULL								CodigoResultadoRecurso,			
				NULL								CodigoResultadoSolicitud,
				NULL								CodResultadoLegajo,			
				NULL								DescripcionResultadoLegajo,		
				NULL								CodigoLegajoResultadoRecurso,
				NULL								CodigoLegajoResultadoSolicitud,
				NULL								CodigoRecursoResultadoLegajo,
				NULL								CodigoSolicitudResultadoLegajo,		 				
				ES.TF_Salida						FechaEnvio, 
				NULL								CodigoItineracionGestion,
			    NULL                                UsuarioResuelve					,
			    NULL                                NombreUsuarioResuelve			,
			    NULL                                PrimerApellidoResuelve			,
			    NULL                                SegundoApellidoResuelve			    
	FROM		Historico.ExpedienteEntradaSalida	ES WITH(NOLOCK)
	OUTER APPLY	(
					SELECT		CASE
									WHEN COUNT(*) > 0 THEN 1
									ELSE 0
								END Acumulados
					FROM		Historico.ExpedienteAcumulacion		H WITH(NOLOCK)
					WHERE		H.TC_NumeroExpedienteAcumula		= ES.TC_NumeroExpediente
					AND			H.TF_InicioAcumulacion				IS NOT NULL
					AND			H.TF_FinAcumulacion					IS NULL
				) EA
	INNER JOIN  Historico.Itineracion				I WITH(NOLOCK)
	ON			ES.TU_CodHistoricoItineracion       = I.TU_CodHistoricoItineracion
	INNER JOIN	Catalogo.Contexto					CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino				= CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto					CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen				= CO.TC_CodContexto	
	INNER JOIN	Expediente.Expediente				E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente				= ES.TC_NumeroExpediente
	INNER JOIN	Catalogo.Oficina					OD WITH(NOLOCK)
	ON			CD.TC_CodOficina					= OD.TC_CodOficina
	WHERE		I.ID_NAUTIUS						IS NULL
	AND			I.TF_FechaEstado					IS NOT NULL
	AND			I.TC_CodContextoDestino				= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion			IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente				=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			I.TF_FechaEstado 					>= COALESCE (@L_FechaInicio, I.TF_FechaEstado)	
	AND			I.TF_FechaEstado					<= COALESCE (@L_FechaFinal, I.TF_FechaEstado)	
	AND			I.TC_CodContextoOrigen  			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)
	
	UNION
	
	--Legajos
	SELECT		I.TU_CodItineracion				CodigoItineracion,
				I.TU_CodHistoricoItineracion	CodigoHistoricoItineracion,
				ES.TF_CreacionItineracion		FechaCreacion,
				I.TF_FechaEstado 				FechaRecibido,
				I.TC_Numeroexpediente			Numero,
				NULL							Descripcion,
				L.TU_CodLegajo					CodigoLegajo,
				L.TC_Descripcion				DescripcionLegajo,
				@L_GuidEmpty					CodigoRecurso,
				@L_GuidEmpty					CodigoSolicitud,
				I.TN_CodTipoItineracion			CodigoTipoItineracion,
				NULL							TipoItineracionDescripcion,	
				I.TN_CodEstadoItineracion		CodigoEstadoItineracion,	
				NULL							DescripcionEstadoItineracion,
				ES.TN_CodMotivoItineracion		CodigoMotivoItineracion,
				OD.TC_CodOficina				CodigoOficinaDestino,
				OD.TC_Nombre					DescripcionOficinaDestino,
				I.TC_CodContextoDestino			CodigoContextoDestino,		
				CD.TC_Descripcion				DescripcionContextoDestino,
				OD.TN_CodTipoOficina			CodigoTipoOficinaDestino,
				CD.TC_CodMateria				CodigoMateriaOficinaDest,
				CO.TC_CodOficina				CodigoOficinaOrigen,
				NULL							DescripcionOficinaOrigen,
				I.TC_CodContextoOrigen			CodigoContextoOrigen,
				CO.TC_Descripcion				DescripcionContextoOrigen,
				L.TC_CodContextoCreacion		CodigoContextoLegajo,
				0								Acumulado,
				0								Confidencial,
				I.TC_MensajeError				MensajeError,
				NULL							CodigoResultadoRecurso,		
				NULL							CodigoResultadoSolicitud,
				NULL							CodResultadoLegajo,			
				NULL							DescripcionResultadoLegajo,	
				NULL							CodigoLegajoResultadoRecurso,
				NULL							CodigoLegajoResultadoSolicitud,
				NULL							CodigoRecursoResultadoLegajo,
				NULL							CodigoSolicitudResultadoLegajo,			 				
				ES.TF_Salida					FechaEnvio, 
				NULL							CodigoItineracionGestion,
				NULL                            UsuarioResuelve					,
			    NULL                            NombreUsuarioResuelve			,
			    NULL                            PrimerApellidoResuelve			,
			    NULL                            SegundoApellidoResuelve			
	FROM		Historico.LegajoEntradaSalida	ES WITH(NOLOCK)
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON          ES.TU_CodHistoricoItineracion   = I.TU_CodHistoricoItineracion
	INNER JOIN	Catalogo.Contexto				CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino         = CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto               CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen			= CO.TC_CodContexto
	INNER JOIN	Expediente.Legajo				L WITH(NOLOCK)
	ON			L.TU_CodLegajo					= ES.TU_CodLegajo
	INNER JOIN	Catalogo.Oficina				OD WITH(NOLOCK)
	ON			CD.TC_CodOficina				= OD.TC_CodOficina
	WHERE		I.ID_NAUTIUS					IS NULL
	AND			I.TF_FechaEstado				IS NOT NULL
	AND			I.TC_CodContextoDestino			= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			I.TF_FechaEstado				>= COALESCE (@L_FechaInicio, I.TF_FechaEstado)	
	AND			I.TF_FechaEstado				<= COALESCE (@L_FechaFinal, I.TF_FechaEstado)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION 

	--Recursos 
	SELECT		I.TU_CodItineracion				CodigoItineracion,
				I.TU_CodHistoricoItineracion	CodigoHistoricoItineracion,
				RE.TF_Fecha_Creacion			FechaCreacion,
				I.TF_FechaEstado				FechaRecibido,
				I.TC_NumeroExpediente			Numero,
				E.TC_Descripcion				Descripcion,
				@L_GuidEmpty					CodigoLegajo,
				NULL							DescripcionLegajo,
				RE.TU_CodRecurso				CodigoRecurso,
				@L_GuidEmpty					CodigoSolicitud,
				I.TN_CodTipoItineracion			CodigoTipoItineracion,
				NULL							TipoItineracionDescripcion,	
				I.TN_CodEstadoItineracion		CodigoEstadoItineracion,	
				NULL							DescripcionEstadoItineracion,
				RE.TN_CodMotivoItineracion		CodigoMotivoItineracion,
				OD.TC_CodOficina				CodigoOficinaDestino,
				OD.TC_Nombre					DescripcionOficinaDestino,
				RE.TC_CodContextoDestino		CodigoContextoDestino,		
				CD.TC_Descripcion				DescripcionContextoDestino,
				OD.TN_CodTipoOficina			CodigoTipoOficinaDestino,
				CD.TC_CodMateria				CodigoMateriaOficinaDest,
				CO.TC_CodOficina				CodigoOficinaOrigen,
				NULL							DescripcionOficinaOrigen,
				RE.TC_CodContextoOrigen			CodigoContextoOrigen,
				CO.TC_Descripcion				DescripcionContextoOrigen,
				NULL							CodigoContextoLegajo,
				0								Acumulado,
				0								Confidencial,
				I.TC_MensajeError				MensajeError,
				NULL							CodigoResultadoRecurso,		
				NULL							CodigoResultadoSolicitud,
				NULL							CodResultadoLegajo,			
				NULL							DescripcionResultadoLegajo,	
				NULL							CodigoLegajoResultadoRecurso,
				NULL							CodigoLegajoResultadoSolicitud,
				NULL							CodigoRecursoResultadoLegajo,
				NULL							CodigoSolicitudResultadoLegajo,				
				RE.TF_Fecha_Envio				FechaEnvio, 
				NULL							CodigoItineracionGestion,
			    NULL                            UsuarioResuelve					,
			    NULL                            NombreUsuarioResuelve			,
			    NULL                            PrimerApellidoResuelve			,
			    NULL                            SegundoApellidoResuelve			
	FROM		Expediente.RecursoExpediente	RE WITH(NOLOCK)
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON			RE.TU_CodHistoricoItineracion	= I.TU_CodHistoricoItineracion
	INNER JOIN	Catalogo.Contexto				CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino         = CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto               CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen			= CO.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				OD WITH(NOLOCK)
	ON			CD.TC_CodOficina				= OD.TC_CodOficina
	INNER JOIN	Expediente.Expediente			E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= RE.TC_Numeroexpediente
	WHERE		I.ID_NAUTIUS					IS NULL
	AND			I.TF_FechaEstado                IS NOT NULL
	AND			RE.TC_CodContextoDestino		= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			I.TF_FechaEstado				>= COALESCE (@L_FechaInicio, I.TF_FechaEstado)	
	AND			I.TF_FechaEstado				<= COALESCE (@L_FechaFinal, I.TF_FechaEstado)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION

	--Solicitudes 
	SELECT		I.TU_CodItineracion				CodigoItineracion,
				I.TU_CodHistoricoItineracion	CodigoHistoricoItineracion,
				SE.TF_FechaCreacion				FechaCreacion,
				I.TF_FechaEstado 				FechaRecibido,
				I.TC_Numeroexpediente			Numero,
				E.TC_Descripcion				Descripcion,
				@L_GuidEmpty					CodigoLegajo,
				SE.TC_Descripcion				DescripcionLegajo,
				@L_GuidEmpty					CodigoRecurso,
				SE.TU_CodSolicitudExpediente	CodigoSolicitud,
				I.TN_CodTipoItineracion			CodigoTipoItineracion,
				NULL							TipoItineracionDescripcion,	
				I.TN_CodEstadoItineracion		CodigoEstadoItineracion,	
				NULL							DescripcionEstadoItineracion,
				SE.TN_CodMotivoItineracion		CodigoMotivoItineracion,
				OD.TC_CodOficina				CodigoOficinaDestino,
				OD.TC_Nombre					DescripcionOficinaDestino,
				I.TC_CodContextoDestino			CodigoContextoDestino,		
				CD.TC_Descripcion				DescripcionContextoDestino,
				OD.TN_CodTipoOficina			CodigoTipoOficinaDestino,
				CD.TC_CodMateria				CodigoMateriaOficinaDest,
				CO.TC_CodOficina				CodigoOficinaOrigen,
				NULL							DescripcionOficinaOrigen,
				I.TC_CodContextoOrigen			CodigoContextoOrigen,
				CO.TC_Descripcion				DescripcionContextoOrigen,
				NULL							CodigoContextoLegajo,
				0								Acumulado,
				0								Confidencial,
				I.TC_MensajeError				MensajeError,
				NULL							CodigoResultadoRecurso,		
				NULL							CodigoResultadoSolicitud,
				NULL							CodResultadoLegajo,			
				NULL							DescripcionResultadoLegajo,	
				NULL							CodigoLegajoResultadoRecurso,
				NULL							CodigoLegajoResultadoSolicitud,
				NULL							CodigoRecursoResultadoLegajo,
				NULL							CodigoSolicitudResultadoLegajo,		
				SE.TF_FechaEnvio				FechaEnvio, 
				NULL							CodigoItineracionGestion,
			    NULL                            UsuarioResuelve					,
			    NULL                            NombreUsuarioResuelve			,
			    NULL                            PrimerApellidoResuelve			,
			    NULL                            SegundoApellidoResuelve			
	FROM		Expediente.SolicitudExpediente	SE WITH(NOLOCK)
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON			SE.TU_CodHistoricoItineracion	= I.TU_CodHistoricoItineracion
	INNER JOIN	Catalogo.Contexto				CO WITH(NOLOCK)
	ON			CO.TC_CodContexto				= SE.TC_CodContextoOrigen
	INNER JOIN	Catalogo.Contexto				CD with(Nolock)
	ON			CD.TC_CodContexto				= SE.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina				OD with(Nolock)
	ON			OD.TC_codOficina				= CD.TC_CodOficina
	INNER JOIN	Expediente.Expediente			E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= SE.TC_Numeroexpediente
	WHERE		I.ID_NAUTIUS					IS NULL
	AND			SE.TC_CodContextoDestino		= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			I.TF_FechaEstado				>= COALESCE (@L_FechaInicio, I.TF_FechaEstado)	
	AND			I.TF_FechaEstado				<= COALESCE (@L_FechaFinal, I.TF_FechaEstado)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION

	--Resultado Recursos
	SELECT		HI.TU_CodItineracion					CodigoItineracion,
				HI.TU_CodHistoricoItineracion			CodigoHistoricoItineracion,
				RR.TF_FechaCreacion						FechaCreacion,
				HI.TF_FechaEstado						FechaRecibido,
				L.TC_NumeroExpediente					Numero,
				E.TC_Descripcion						Descripcion,
				@L_GuidEmpty							CodigoLegajo,
				L.TC_Descripcion						DescripcionLegajo,
				G.TU_CodRecurso							CodigoRecurso,
				@L_GuidEmpty							CodigoSolicitud,
				HI.TN_CodTipoItineracion				CodigoTipoItineracion,
				NULL									TipoItineracionDescripcion,	
				HI.TN_CodEstadoItineracion				CodigoEstadoItineracion,	
				NULL									DescripcionEstadoItineracion,
				RR.TN_CodMotivoItineracion				CodigoMotivoItineracion,
				OD.TC_CodOficina						CodigoOficinaDestino,
				OD.TC_Nombre							DescripcionOficinaDestino,
				HI.TC_CodContextoDestino				CodigoContextoDestino,		
				CD.TC_Descripcion						DescripcionContextoDestino,
				OD.TN_CodTipoOficina					CodigoTipoOficinaDestino,
				CD.TC_CodMateria						CodigoMateriaOficinaDest,
				CO.TC_CodOficina						CodigoOficinaOrigen,
				NULL									DescripcionOficinaOrigen,
				HI.TC_CodContextoOrigen					CodigoContextoOrigen,
				CO.TC_Descripcion						DescripcionContextoOrigen,
				L.TC_CodContexto						CodigoContextoLegajo,
				0										Acumulado,
				0										Confidencial,
				HI.TC_MensajeError						MensajeError,
				RR.TU_CodResultadoRecurso				CodigoResultadoRecurso,		
				@L_GuidEmpty							CodigoResultadoSolicitud,
				RR.TN_CodResultadoLegajo				CodResultadoLegajo,			
				NULL									DescripcionResultadoLegajo,	
				RR.TU_CodLegajo							CodigoLegajoResultadoRecurso,
				@L_GuidEmpty							CodigoLegajoResultadoSolicitud,
				G.TU_CodRecurso							CodigoRecursoResultadoLegajo,
				@L_GuidEmpty							CodigoSolicitudResultadoLegajo,				
				RR.TF_FechaEnvio						FechaEnvio, 
				NULL								    CodigoItineracionGestion,
			    NULL                                    UsuarioResuelve					,
			    NULL                                    NombreUsuarioResuelve			,
			    NULL                                    PrimerApellidoResuelve			,
			    NULL                                    SegundoApellidoResuelve			
	FROM		Expediente.ResultadoRecurso				RR WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo						L WITH(NOLOCK)
	ON			L.TU_CodLegajo							= RR.TU_CodLegajo
	INNER JOIN	Expediente.Expediente					E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente					= L.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion					HI WITH(NOLOCK)
	ON			HI.TU_CodHistoricoItineracion			= RR.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle				LD WITH(NOLOCK)
	ON			LD.TU_CodLegajo							= L.TU_CodLegajo
	INNER JOIN	Catalogo.Contexto						CD with(Nolock)
	ON			CD.TC_CodContexto						= HI.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina						OD with(Nolock)
	ON			OD.TC_codOficina						= CD.TC_CodOficina
	INNER JOIN	Catalogo.Contexto						CO WITH(NOLOCK)
	ON			CO.TC_CodContexto						= HI.TC_CodContextoOrigen
	INNER JOIN	Historico.ItineracionRecursoResultado	G WITH(NOLOCK)
	ON			RR.TU_CodLegajo							= G.TU_CodLegajo
	WHERE		HI.ID_NAUTIUS							IS NULL
	AND			LD.TC_CodContextoProcedencia			IS NOT NULL
	AND			HI.TC_CodContextoDestino				= @L_ContextoDestino
	AND			HI.TN_CodEstadoItineracion				IN (SELECT Codigo FROM @ListaEstados)
	AND			HI.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,HI.TC_NumeroExpediente)
	AND			HI.TF_FechaEstado						>= COALESCE (@L_FechaInicio,HI.TF_FechaEstado)	
	AND			HI.TF_FechaEstado						<= COALESCE (@L_FechaFinal,HI.TF_FechaEstado)
	AND			HI.TC_CodContextoOrigen					=  COALESCE (@L_ContextoOrigen, HI.TC_CodContextoOrigen)
	
	UNION

	--Resultado Solicitudes
	SELECT		D.TU_CodItineracion						CodigoItineracion,
				D.TU_CodHistoricoItineracion			CodigoHistoricoItineracion,
				A.TF_FechaCreacion						FechaCreacion,
				D.TF_FechaEstado						FechaRecibido,
				B.TC_NumeroExpediente					Numero,
				C.TC_Descripcion						Descripcion,
				@L_GuidEmpty							CodigoLegajo,
				B.TC_Descripcion						DescripcionLegajo,
				@L_GuidEmpty							CodigoRecurso,
				G.TU_CodSolicitud						CodigoSolicitud,
				D.TN_CodTipoItineracion					CodigoTipoItineracion,
				NULL									TipoItineracionDescripcion,	
				D.TN_CodEstadoItineracion				CodigoEstadoItineracion,	
				NULL									DescripcionEstadoItineracion,
				A.TN_CodMotivoItineracion				CodigoMotivoItineracion,
				OD.TC_CodOficina						CodigoOficinaDestino,
				OD.TC_Nombre							DescripcionOficinaDestino,
				D.TC_CodContextoDestino					CodigoContextoDestino,		
				CD.TC_Descripcion						DescripcionContextoDestino,
				OD.TN_CodTipoOficina					CodigoTipoOficinaDestino,
				CD.TC_CodMateria						CodigoMateriaOficinaDest,
				OO.TC_CodOficina						CodigoOficinaOrigen,
				OO.TC_Nombre							DescripcionOficinaOrigen,
				D.TC_CodContextoOrigen					CodigoContextoOrigen,
				CO.TC_Descripcion						DescripcionContextoOrigen,
				B.TC_CodContexto						CodigoContextoLegajo,
				0										Acumulado,
				0										Confidencial,
				D.TC_MensajeError						MensajeError,
				@L_GuidEmpty							CodigoResultadoRecurso,		
				A.TU_CodResultadoSolicitud				CodigoResultadoSolicitud,
				A.TN_CodResultadoLegajo					CodResultadoLegajo,			
				F.TC_Descripcion						DescripcionResultadoLegajo,	
				@L_GuidEmpty							CodigoLegajoResultadoRecurso,
				A.TU_CodLegajo							CodigoLegajoResultadoSolicitud,
				@L_GuidEmpty							CodigoRecursoResultadoLegajo,
				G.TU_CodSolicitud						CodigoSolicitudResultadoLegajo, 				
				A.TF_FechaEnvio							FechaEnvio, 
				NULL									CodigoItineracionGestion,
				A.TC_UsuarioRed                         UsuarioResuelve					,
			    NULL                                    NombreUsuarioResuelve			,
			    NULL                                    PrimerApellidoResuelve			,
			    NULL                                   SegundoApellidoResuelve			
	FROM		Expediente.ResultadoSolicitud			A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo						B WITH(NOLOCK)
	ON			B.TU_CodLegajo							= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente					C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente					= B.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion					D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle				E WITH(NOLOCK)
	ON			E.TU_CodLegajo							= B.TU_CodLegajo
	INNER JOIN	Catalogo.Contexto						CD with(Nolock)
	ON			CD.TC_CodContexto						= D.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina						OD with(Nolock)
	ON			OD.TC_codOficina						= CD.TC_CodOficina
	INNER JOIN	Catalogo.Contexto						CO WITH(NOLOCK)
	ON			CO.TC_CodContexto						= D.TC_CodContextoOrigen
	INNER JOIN	Catalogo.Oficina						OO WITH(NOLOCK)
	ON			OO.TC_CodOficina						= CO.TC_CodOficina
	INNER JOIN	Historico.ItineracionSolicitudResultado	G WITH(NOLOCK)
	ON			A.TU_CodLegajo							= G.TU_CodLegajo
	INNER JOIN	Catalogo.ResultadoLegajo				F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo					= A.TN_CodResultadoLegajo
	WHERE		D.ID_NAUTIUS							IS NULL
	AND			E.TC_CodContextoProcedencia				IS NOT NULL
	AND			D.TC_CodContextoDestino					= @L_ContextoDestino
	AND			D.TN_CodEstadoItineracion				IN (SELECT Codigo FROM @ListaEstados)
	AND			D.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,D.TC_NumeroExpediente)
	AND			D.TF_FechaEstado						>= COALESCE (@L_FechaInicio,D.TF_FechaEstado)	
	AND			D.TF_FechaEstado						<= COALESCE (@L_FechaFinal,D.TF_FechaEstado)
	AND			D.TC_CodContextoOrigen					=  COALESCE (@L_ContextoOrigen, D.TC_CodContextoOrigen)

	UNION

	-- Itineraciones de Gestión (OJO acá no se puede agregar datos que no sean códigos desde la vista, pues hace que se disparen los tiempos de respuesta)
	SELECT		'00000000-0000-0000-0000-000000000000',		-- CodigoItineracion
				'00000000-0000-0000-0000-000000000000',		-- CodigoHistoricoItineracion
				A.FechaCreacion,							-- FechaCreacion
				A.FechaRecibido,							-- FechaRecibido
				A.NumeroExpediente,							-- Numero (Expediente)
				NULL,										-- Descripcion (Expediente)
				'00000000-0000-0000-0000-000000000000',		-- CodigoLegajo
				NULL,										-- DescripcionLegajo
				'00000000-0000-0000-0000-000000000000',		-- CodigoRecurso
				NULL,										-- CodigoSolicitud
				0,											-- CodigoTipoItineracion
				NULL,										-- TipoItineracionDescripcion
				NULL,										-- CodigoEstadoItineracion
				NULL,										-- DescripcionEstadoItineracion
				NULL,										-- CodigoMotivoItineracion				
				A.CodigoOficinaDestino,						-- CodigoOficinaDestino
				'',											-- DescripcionOficinaDestino
				A.CodigoOficinaDestino,						-- CodigoContextoDestino
				'',											-- DescripcionContextoDestino
				0,											-- CodigoTipoOficinaDestino
				'',											-- CodigoMateriaOficinaDest
				A.CodigoOficinaOrigen,						-- CodigoOficinaOrigen
				NULL,										-- DescripcionOficinaOrigen
				A.CodigoOficinaOrigen,						-- CodigoContextoOrigen
				'',											-- DescripcionContextoOrigen
				NULL,										-- CodigoContextoLegajo
				A.TieneAcumulado,							-- Acumulado
				0,											-- Confidencial
				A.MensajeError,								-- MensajeError
				NULL,										-- CodigoResultadoRecurso
				NULL,										-- CodigoResultadoSolicitud
				NULL,										-- CodResultadoLegajo
				NULL,										-- DescripcionResultadoLegajo
				NULL,										-- CodigoLegajoResultadoRecurso
				NULL,										-- CodigoLegajoResultadoSolicitud
				NULL,										-- CodigoRecursoResultadoLegajo
				NULL,										-- CodigoSolicitudResultadoLegajo
				A.FechaEnvio,								-- FechaEnvio, 
				A.CodigoItineracion,						-- CodigoItineracionGestion,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Itineracion.V_ItineracionesRecibidas	A	WITH(NOLOCK) -- VISTA DESDE BD ITINERACIONES
	WHERE		A.CodOficinaConsulta					=	@L_ContextoDestino
	AND			A.NumeroExpediente						=	COALESCE (@L_NumeroExpediente, A.NumeroExpediente)
	AND			(@L_FechaInicio IS NULL					OR 	DATEDIFF(DAY, A.FechaRecibido,@L_FechaInicio) <= 0)
	AND			(@L_FechaFinal	IS NULL					OR 	DATEDIFF(DAY, A.FechaRecibido,@L_FechaFinal) >= 0)
	AND			A.CodigoOficinaOrigen					=	COALESCE (@L_ContextoOrigen, A.CodigoOficinaOrigen)	  

	DECLARE @TotalRegistros				AS INT = @@ROWCOUNT; 

	INSERT INTO @Result
	SELECT		*
	FROM		@ResultadoTodo
	ORDER BY	FechaCreacion DESC
	OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
	FETCH NEXT	@L_CantidadRegistros ROWS ONLY

	-- Se completan los datos de las @L_CantidadRegistros itineraciones recibidas de Gestión
	UPDATE		A
	SET			A.CodigoTipoItineracion			=	TI.TN_CodTipoItineracion,																			-- CodigoTipoItineracion
				A.TipoItineracionDescripcion	=	TI.TC_Descripcion,																					-- TipoItineracionDescripcion
				A.CodigoEstadoItineracion		=	EI.TN_CodEstadoItineracion,																			-- CodigoEstadoItineracion
				A.DescripcionEstadoItineracion	=	EI.TC_Descripcion,																					-- DescripcionEstadoItineracion
				A.CodigoMotivoItineracion		=	ISNULL(MI.TN_CodMotivoItineracion, @L_MotivoItineracionOtroSIAGPJ),									-- CodigoMotivoItineracion		
				A.DescripcionOficinaDestino		=	ISNULL(OD.TC_Nombre, '-'),																			-- DescripcionOficinaDestino
				A.DescripcionContextoDestino	=	ISNULL(CD.TC_Descripcion, '-'),																		-- DescripcionContextoDestino
				A.CodigoTipoOficinaDestino		=	ISNULL(T.TN_CodTipoOficina, 0),																		-- CodigoTipoOficinaDestino
				A.CodigoMateriaOficinaDest		=	ISNULL(CD.TC_CodMateria, 0),																		-- CodigoMateriaOficinaDest
				A.DescripcionOficinaOrigen		=	ISNULL(OO.TC_Nombre, CONCAT('La oficina ', A.CodigoOficinaOrigen, ' no existe en catalogo')),		-- DescripcionOficinaOrigen
				A.DescripcionContextoOrigen		=	ISNULL(CO.TC_Descripcion, CONCAT('El contexto ', A.CodigoOficinaOrigen, ' no existe en catalogo'))	-- DescripcionContextoOrigen				
	FROM		@Result	A	
	INNER JOIN	Itineracion.V_ItineracionesRecibidas	V	WITH(NOLOCK) -- VISTA DESDE BD ITINERACIONES
	ON			V.CodigoItineracion						=	A.CodigoItineracionGestion
	LEFT JOIN	Catalogo.TipoItineracion				TI	WITH(NOLOCK)
	ON			TI.TN_CodTipoItineracion				=	CASE 
																WHEN V.TipoItineracion = 'EnvioRecurso' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionRecurso')
																WHEN V.TipoItineracion = 'EnvioCarpeta' THEN (
																		SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = CASE 
																																										WHEN V.CodAsu IN 
																																										(
																																											SELECT CodigoCatalogo 
																																											FROM @EquivalenciasCatalogosItineracionSIAGPJ 
																																											WHERE CodConfiguracion = 'U_IndicadorExpGestion'
																																										) THEN 'C_TipoItineracionExpediente' 
																																										ELSE 'C_TipoItineracionLegajo' 
																																									END
																	)
																WHEN V.TipoItineracion = 'EnvioSolicitud' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionSolicitud')
																WHEN V.TipoItineracion = 'DevolucionSolicitud' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionResultadoS')
																WHEN V.TipoItineracion = 'DevolucionRecurso' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionResultadoR')
																ELSE NULL
															END
	LEFT JOIN	Catalogo.EstadoItineracion				EI	WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion				=	(SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_EstadoItineracionRecibida')
	LEFT JOIN	Catalogo.Oficina						OD	WITH(NOLOCK)
	ON			OD.TC_codOficina						=	A.CodigoOficinaDestino
	LEFT JOIN	Catalogo.Contexto						CD  WITH(NOLOCK)
	ON			CD.TC_CodContexto						=	A.CodigoOficinaDestino
	LEFT JOIN	Catalogo.Contexto						CO	WITH(NOLOCK)
	ON			CO.TC_CodContexto						=	A.CodigoOficinaOrigen
	LEFT JOIN	Catalogo.Oficina						OO	WITH(NOLOCK)
	ON			OO.TC_CodOficina						=	A.CodigoOficinaOrigen 
	LEFT JOIN	Catalogo.MotivoItineracion				MI	WITH(NOLOCK)
	ON			MI.CODMOT								=	ISNULL(V.CodMotivoItineracion, @L_MotivoItineracionOtro)
	LEFT JOIN	Catalogo.TipoOficina					T	WITH(NOLOCK)
	ON			T.TN_CodTipoOficina						=	OD.TN_CodTipoOficina	
	WHERE		A.CodigoItineracionGestion	IS NOT NULL
	AND			A.CodigoItineracion			= '00000000-0000-0000-0000-000000000000'

	-- Se completan los datos de recursos de Gestión
	UPDATE		A
SET
				A.CodigoClaseAsuntoRecurso			= C.TN_CodClaseAsunto,
A.DescripcionClaseAsuntoRecurso		= C.TC_Descripcion,
A.CodigoAsuntoRecurso				= D.TN_CodAsunto,
				A.DescripcionAsuntoRecurso			= D.TC_Descripcion,
				A.CodigoClaseAsunto					= C.TN_CodClaseAsunto,
				A.DescripcionAsunto					= C.TC_Descripcion, 
				A.CodigoClase						= C.TN_CodClaseAsunto, 
				A.DescripcionClase					= C.TC_Descripcion, 
				A.TipoResolucionRecurso				= (SELECT T.TC_Descripcion FROM Catalogo.TipoResolucion T WITH(NOLOCK) WHERE T.CODRES = R.VALUE.value('(/*/DACOREC/CODRES)[1]','VARCHAR(4)')), 
				A.FechaResolucion					= GETDATE(), 
				A.HoraResolucion					= GETDATE(), 
				A.NumeroResolucion					= NULL
	FROM		@Result	A	
	INNER JOIN	Itineracion.V_ItineracionesRecibidas	V	WITH(NOLOCK) -- VISTA DESDE BD ITINERACIONES
	ON			V.CodigoItineracion						=	A.CodigoItineracionGestion	
	LEFT JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS 	R	WITH(NOLOCK)
	ON			R.ID									=	V.CodigoItineracion
	LEFT JOIN	Catalogo.ClaseAsunto					C	WITH(NOLOCK)
	ON			C.TN_CodClaseAsunto						=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(V.CodigoOficinaDestino,'ClaseAsunto', R.VALUE.value('(/*/DCAR/CODCLAS)[1]','VARCHAR(9)'),0,0))
	LEFT JOIN	Catalogo.Asunto							D	WITH(NOLOCK) 
	ON			D.TN_CodAsunto							=	ISNULL(CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(V.CodigoOficinaDestino,'Asunto', R.VALUE.value('(/*/DCAR/CODASU)[1]','VARCHAR(3)'),0,0)),Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoRecurso',V.CodigoOficinaDestino))
	WHERE		A.CodigoItineracionGestion				IS NOT NULL
	AND			A.CodigoItineracion						=	'00000000-0000-0000-0000-000000000000'
	AND			A.CodigoTipoItineracion					=	(SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionRecurso')


	-- Se completan los datos de resultado de recursos o de solicitudes de Gestión
	UPDATE		A
	SET			A.DescripcionResultadoLegajo			= C.TC_Descripcion,
				A.RedactorRecurso						= F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + F.TC_SegundoApellido + ' (' + F.TC_UsuarioRed + ')'	-- Usuario			
	FROM		@Result	A	
	INNER JOIN	Itineracion.V_ItineracionesRecibidas	V	WITH(NOLOCK) -- VISTA DESDE BD ITINERACIONES
	ON			V.CodigoItineracion						=	A.CodigoItineracionGestion	
	LEFT JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS 	R	WITH(NOLOCK)
	ON			R.ID									=	V.CodigoItineracion
	LEFT JOIN	Catalogo.ResultadoResolucion			C	WITH(NOLOCK)
	ON			C.TN_CodResultadoResolucion				=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(V.CodigoOficinaDestino,'ResultadoResolucion', R.VALUE.value('(/*/DACORES/CODRESUL)[1]','VARCHAR(35)'),0,0))
	LEFT JOIN	Catalogo.Funcionario					F	WITH(NOLOCK)
	ON			F.TC_UsuarioRed							=	R.VALUE.value('(/*/DACO/IDUSU)[1]','VARCHAR(25)')
	WHERE		A.CodigoItineracionGestion				IS NOT NULL
	AND			A.CodigoItineracion						=	'00000000-0000-0000-0000-000000000000'
	AND			A.CodigoTipoItineracion					IN	(SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion IN ('C_TipoItineracionResultadoR','C_TipoItineracionResultadoS'))

	--Acutalización catalogos Expediente
	UPDATE			A
	SET				A.CodigoClase					= B.TN_CodClase,		
					A.DescripcionClase				= C.TC_Descripcion,			
					A.CodigoProceso					= B.TN_CodProceso,		
					A.DescripcionProceso			= D.TC_Descripcion,
					A.CodigoFase					= B.TN_CodFase,
					A.DescripcionOficinaDestino     = OD.TC_Nombre,
					A.DescripcionContextoDestino    = CD.TC_Descripcion,
					A.DescripcionOficinaOrigen      = OO.TC_Nombre,
					A.DescripcionContextoOrigen     = CO.TC_Descripcion
	FROM			@Result							A
	INNER JOIN		Expediente.ExpedienteDetalle	B WITH(NOLOCK)
	ON				A.Numero						= B.TC_NumeroExpediente
	INNER JOIN		Catalogo.Clase					C WITH(NOLOCK)
	ON				C.TN_CodClase					= B.TN_CodClase
	INNER JOIN		Catalogo.Proceso				D WITH(NOLOCK)
	ON				D.TN_CodProceso					= B.TN_CodProceso
	INNER JOIN		Catalogo.Contexto				CD WITH(NOLOCK)
	ON				CD.TC_CodContexto				= A.CodigoContextoDestino	
	INNER JOIN		Catalogo.Oficina				OD WITH(NOLOCK)
	ON				OD.TC_CodOficina			    = A.CodigoOficinaDestino
	INNER JOIN      Catalogo.Contexto				CO WITH(NOLOCK)
	ON				CO.TC_CodContexto				= A.CodigoContextoOrigen
	INNER JOIN		Catalogo.Oficina				OO WITH(NOLOCK)
	ON				OO.TC_CodOficina				= A.CodigoOficinaOrigen

	--Actualizacion catalogos Legajo
	UPDATE			A
	SET				A.CodigoAsunto					= B.TN_CodAsunto,		
					A.DescripcionAsunto				= C.TC_Descripcion,
					A.CodigoClaseAsunto				= B.TN_CodClaseAsunto,
					A.DescripcionClaseAsunto		= D.TC_Descripcion
	FROM			@Result							A					
	INNER JOIN		Expediente.LegajoDetalle		B WITH(NOLOCK)
	ON				B.TU_CodLegajo					= A.CodigoLegajo
	INNER JOIN		Catalogo.Asunto					C WITH(NOLOCK)
	ON				C.TN_CodAsunto					= B.TN_CodAsunto
	INNER JOIN		Catalogo.ClaseAsunto			D WITH(NOLOCK)
	ON				D.TN_CodClaseAsunto				= B.TN_CodClaseAsunto

	UPDATE			A
	SET				A.TipoResolucionRecurso				= D.TC_Descripcion,
					A.TipoResultadoRecurso				= E.TC_Descripcion,
					A.RedactorRecurso					= G.TC_Nombre + ' ' + ISNULL(G.TC_PrimerApellido,'') + ' ' + ISNULL(G.TC_SegundoApellido,''),
					A.FechaResolucion					= C.TF_FechaResolucion,
					A.NumeroResolucion					= H.TC_NumeroResolucion,
					A.CodigoArchivoResolucion			= C.TU_CodArchivo,
					A.NumeroExpedienteRecurso			= C.TC_NumeroExpediente
	FROM			@Result								A
	INNER JOIN		Expediente.RecursoExpediente		B WITH(NOLOCK)
	ON				B.TU_CodRecurso						= A.CodigoRecurso
	INNER JOIN		Expediente.Resolucion				C WITH(NOLOCK)
	ON				C.TU_CodResolucion					= B.TU_CodResolucion
	INNER JOIN		Catalogo.TipoResolucion				D WITH(NOLOCK)
	ON				D.TN_CodTipoResolucion				= C.TN_CodTipoResolucion
	INNER JOIN		Catalogo.ResultadoResolucion		E WITH(NOLOCK)
	ON				E.TN_CodResultadoResolucion			= C.TN_CodResultadoResolucion
	INNER JOIN		Catalogo.PuestoTrabajoFuncionario	F WITH(NOLOCK)
	ON				C.TU_RedactorResponsable			= F.TU_CodPuestoFuncionario
	INNER JOIN		Catalogo.Funcionario				G WITH(NOLOCK)
	ON				G.TC_UsuarioRed						= F.TC_UsuarioRed
	LEFT JOIN		Expediente.LibroSentencia			H WITH(NOLOCK)
	ON				H.TU_CodResolucion					= C.TU_CodResolucion

	--Acutalización catálogos recurso
	UPDATE			A
	SET				A.CodigoClaseAsuntoRecurso		= B.TN_CodClaseAsunto,		
					A.DescripcionClaseAsuntoRecurso	= C.TC_Descripcion,
					A.CodigoAsuntoRecurso           = C.TN_CodAsunto,
					A.DescripcionAsuntoRecurso		= D.TC_Descripcion
	FROM			@Result							A
	INNER JOIN		Expediente.RecursoExpediente	B WITH(NOLOCK)
	ON				B.TU_CodRecurso					= A.CodigoRecurso
	INNER JOIN		Catalogo.ClaseAsunto			C WITH(NOLOCK)
	ON				C.TN_CodClaseAsunto				= B.TN_CodClaseAsunto
	INNER JOIN		Catalogo.Asunto					D WITH (NOLOCK)
	ON				D.TN_CodAsunto					= C.TN_CodAsunto

	--Actualización catálogos solicitud
	UPDATE			A
	SET				A.CodigoClaseAsuntoSolicitud		= B.TN_CodClaseAsunto,		
					A.DescripcionClaseAsuntoSolicitud	= C.TC_Descripcion,
					A.DescripcionSolicitud				= B.TC_Descripcion,
					A.CodigoArchivoResolucion			= B.TU_CodArchivo
	FROM			@Result							A
	INNER JOIN		Expediente.SolicitudExpediente	B WITH(NOLOCK)
	ON				B.TU_CodSolicitudExpediente		= A.CodigoSolicitud
	INNER JOIN		Catalogo.ClaseAsunto			C WITH(NOLOCK)
	ON				C.TN_CodClaseAsunto				= B.TN_CodClaseAsunto

	--Actualización arhivos solicitud
	UPDATE			A
	SET				A.CodigoArchivoSolicitud		= B.TU_CodArchivo,
					A.DescripcionArchivoSolicitud	= C.TC_Descripcion,
					A.NombreUsuarioDocumento		= D.TC_Nombre,
					A.PrimerApellidoDocumento		= D.TC_PrimerApellido,
					A.SegundoApellidoDocumento		= D.TC_SegundoApellido,
					A.FechaCreacionDocumento		= C.TF_FechaCrea,
					A.UsuarioRedDocumento			= C.TC_UsuarioCrea
	FROM			@Result							A
	INNER JOIN		Expediente.SolicitudExpediente	B WITH(NOLOCK)
	ON				B.TU_CodSolicitudExpediente		= A.CodigoSolicitud
	LEFT JOIN		Expediente.ArchivoExpediente	E WITH(NOLOCK)
	ON				E.TU_CodArchivo					= B.TU_CodArchivo
	INNER JOIN		Archivo.Archivo					C WITH(NOLOCK)
	ON				E.TU_CodArchivo					= C.TU_CodArchivo	
	INNER JOIN		Catalogo.Funcionario			D WITH(NOLOCK)
	ON				D.TC_UsuarioRed					= C.TC_UsuarioCrea

	--Actualización catalogos
	UPDATE			A
	SET				A.CodigoMotivoItineracion		= B.TN_CodMotivoItineracion,
					A.DescripcionMotivoItineracion	= B.TC_Descripcion
	FROM			@Result							A
	INNER JOIN		Catalogo.MotivoItineracion		B WITH(NOLOCK)
	ON				B.TN_CodMotivoItineracion		= A.CodigoMotivoItineracion
	
	UPDATE			A
	SET				A.TipoItineracionDescripcion	= B.TC_Descripcion 
	FROM			@Result							A
	INNER JOIN		Catalogo.TipoItineracion		B WITH(NOLOCK)
	ON				B.TN_CodTipoItineracion			= A.CodigoTipoItineracion;

	UPDATE			A
	SET				A.DescripcionEstadoItineracion	= B.TC_Descripcion 
	FROM			@Result							A
	INNER JOIN		Catalogo.EstadoItineracion		B WITH(NOLOCK)
	ON				B.TN_CodEstadoItineracion		= A.CodigoEstadoItineracion;

	UPDATE			A
	SET				A.DescripcionOficinaOrigen		= B.TC_Nombre 
	FROM			@Result							A
	INNER JOIN		Catalogo.Oficina				B WITH(NOLOCK)
	ON				B.TC_CodOficina					= A.CodigoOficinaOrigen
	WHERE			A.DescripcionOficinaOrigen		IS NULL;

	UPDATE			A
	SET				A.DescripcionResultadoLegajo	= B.TC_Descripcion
	FROM			@Result							A
	INNER JOIN		Catalogo.ResultadoLegajo		B WITH(NOLOCK)
	ON				B.TN_CodResultadoLegajo			= A.CodResultadoLegajo
	WHERE			A.CodResultadoLegajo			IS NOT NULL;

	-- Se obtiene al usuario que resolvió la solicitud.
	UPDATE		A
	SET
				A.NombreUsuarioResuelve		= F.TC_Nombre, 
				A.PrimerApellidoResuelve	= F.TC_PrimerApellido, 
				A.SegundoApellidoResuelve	= F.TC_SegundoApellido
	FROM		@Result	A 
	INNER JOIN  Catalogo.Funcionario		F WITH(NOLOCK) 
	ON			F.TC_UsuarioRed				= A.UsuarioResuelve

	--

	SELECT		@TotalRegistros					AS	TotalRegistros,
				FechaCreacion,	
				FechaRecibido,
				Acumulado,
				MensajeError,
				CodigoItineracionGestion,
				FechaEnvio,
				SplitDatos, --SPLITDATOS
				CodigoItineracion,
				CodigoHistoricoItineracion,
				CodigoTipoItineracion,
				TipoItineracionDescripcion,	
				CodigoEstadoItineracion,
				DescripcionEstadoItineracion,		
				CodigoMotivoItineracion,	
				DescripcionMotivoItineracion,
				CodigoOficinaOrigen,
				DescripcionOficinaOrigen,
				CodigoContextoOrigen,
				DescripcionContextoOrigen,
				CodigoOficinaDestino,
				DescripcionOficinaDestino,
				CodigoContextoDestino,
				DescripcionContextoDestino,
				CodigoTipoOficinaDestino,
				CodigoMateriaOficinaDest,
				CodigoClase,	
				DescripcionClase,
				CodigoProceso,	
				DescripcionProceso,
				CodigoFase,
				CodigoAsunto,		
				DescripcionAsunto, 
				CodigoClaseAsunto, 
				DescripcionClaseAsunto,
				CodigoClaseAsuntoRecurso,	
				DescripcionClaseAsuntoRecurso,
				CodigoAsuntoRecurso,
				DescripcionAsuntoRecurso,
				TipoResolucionRecurso,
				TipoResultadoRecurso,
				RedactorRecurso,
				CASE WHEN FechaResolucion IS NULL THEN CAST('' AS datetime2) ELSE FechaResolucion END As FechaResolucion,
				NumeroResolucion,
				CodigoArchivoResolucion,
				NumeroExpedienteRecurso,
				CodigoClaseAsuntoSolicitud , 
				DescripcionClaseAsuntoSolicitud, 
				CodigoResultadoRecurso,			
				CodigoResultadoSolicitud,
				CodResultadoLegajo,			
				DescripcionResultadoLegajo,		
				CodigoLegajoResultadoRecurso,	
				CodigoLegajoResultadoSolicitud,	
				CodigoRecursoResultadoLegajo,
				CodigoSolicitudResultadoLegajo,
				CodigoArchivoSolicitud,		
				DescripcionArchivoSolicitud,
				NombreUsuarioDocumento,
				PrimerApellidoDocumento,
				SegundoApellidoDocumento,
				UsuarioRedDocumento,
				FechaCreacionDocumento,
				UsuarioResuelve,			
				NombreUsuarioResuelve,
				PrimerApellidoResuelve,	
				SegundoApellidoResuelve,	
				SplitExpediente,			--SPLIT EXPEDIENTE		
				Numero,	
				Descripcion,
				Confidencial,
				SplitLegajo,				--SPLIT LEGAJO
				CodigoLegajo				Codigo,			
				DescripcionLegajo			Descripcion,
				SplitRecurso,				--SPLIT RECURSO
				CodigoRecurso				Codigo,	
				SplitSolicitud,				--SPLIT SOLICITUD
				CodigoSolicitud				Codigo, 
				DescripcionSolicitud		Descripcion				
				
	FROM		@Result

END
GO
