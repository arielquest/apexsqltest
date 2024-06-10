SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================================================================================================
-- Versión:					<1.2>
-- Creado por:				<Aida Elena Siles Rojas>
-- Fecha de creación:		<21/07/2020>
-- Descripción :			<Permite consultar las itineraciones pendientes de recibir.>
-- ===================================================================================================================================================================================
-- Modificación:			<07/08/2020> <Aida Elena Siles R> <Se agregan campos Confidencial y mensaje error.>
-- Modificación:			<14/08/2020> <Aida Elena Siles R> <Se agrega parámetro ListaEstados para realizar la consulta de acuerdo a los estados definidos variable config>
-- Modificación:			<26/08/2020> <Aida Elena Siles R> <Se agregan datos para el tipo de itinerción recurso>
-- Modificación:			<02/10/2020> <Aida Elena Siles R> <Se realiza ajuste en la consulta debido al cambio en la tabla Historico.Itineracion campo TU_CodItineracion>
-- Modificación:			<03/11/2020> <Aida Elena Siles R> <Se cambia en la consulta la descripción de la oficna por TC_Nombre en lugar de TC_DescripcionAbreviada>
-- Modificación:			<06/11/2020> <Andrew Allen Dawson> <Se agrega la consulta de resultado de recurso y solicitud>
-- Modificación:			<09/11/2020> <Aida Elena Siles R> <Se agrega la consulta de resultado de recurso y solicitud con más datos requeridos para la consulta.>
-- Modificación:			<16/11/2020> <Aida Elena Siles R> <Se agrega la consulta para el legajo la materia de la oficina destino.>
-- Modificación:			<08/12/2020> <Aida Elena Siles R> <Se agrega el codigo entrada salida para mapearlo correctamente en metodo AD>
-- Modificación:			<09/12/2020> <Ronny Ramírez R.> <Se agrega la consulta para las itineraciones desde la BD de Itineraciones de Gestión>
-- Modificación:			<09/12/2020> <Ronny Ramírez R.> <Se agrega fecha de error para utilizarla en el filtrado por fecha cuando es una itineración con error>
-- Modificación:			<25/01/2021> <Aida Elena Siles R> <Se modifica el tipo de dato del codigo clase asunto por INT ya que se cambio en la tabla catálogo>
-- Modificación:			<08/02/2021> <Ronny Ramírez R.> <Se aplica corrección en consulta de itineraciones que vienen de gestión, si no exista oficina origen en SIAGPJ>
-- Modificación:			<22/02/2021> <Ronny Ramírez R.> <Se agrega dato de la CARPETA desde DCAR para utilizar en proceso de itineración>
-- Modificación:			<28/06/2021> <Ronny Ramírez R.> <Se toma en cuenta propiedad Procesando de la vista de itineraciones de Gestión, para saber si una itineración se 
--							encuentra ya procesando en BT>
-- Modificación:			<02/07/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en consulta de legajo para contemplar el Asunto como la descripcion del tipo de itineracion
-- Modificación:			<06/07/2021> <Luis Alonso Leiva Tames> <Se aplica cambio para que los recursos y solicitudes de GESTION puedan mostrar los datos>
-- Modificación:			<07/07/2021> <Ronny Ramírez R.> <Se agrega Motivo de itineración por defecto en caso de no encontrar equivalencia para los registros de Gestión>
-- Modificación:			<08/07/2021> <Luis Alonso Leiva Tames> <Se realiza ajuste en las asocianciones de asunto en recursos y solicitudes>
-- Modificación:			<15/07/2021> <Ronny Ramírez R.> <Se aplica corrección para que se traiga el valor de la clase de asunto del recurso en itineraciones internas de SIAGPJ
--							pues había un problema porque ya no se usa la relación del código de asunto en el catálogo ClaseAsunto>
-- Modificación:			<16/07/2021> <Luis Alonso Leiva Tames> <Ajuste en la actualizacion de datos para ver el detalle de recurso>
-- Modificación:			<23/07/2021> <Luis Alonso Leiva Tames> <Ajuste mostrar el detalle del resultado de recurso y resultado solicitud>
-- Modificación:			<10/08/2021> <Jose Gabriel Cordero Soto> <Se ajuste el ordenamiento en la consulta final para que sea descendente>
-- Modificación:			<27/07/2022> <Ronny Ramírez R.> <Se agrega fecha por defecto GETDATE() para FechaCreacion y FechaEnvio, en caso de venir NULL desde V_ItineracionesEntrantes>
-- Modificación:			<17/08/2022> <Aaron Rios Retana> <HU 270202 - Se agrega un inner join cuando es un resultado de recurso para obtener el legajo asociado a Expediente.RecursoExpediente>
-- Modificación:			<11/05/2023> <Karol Jiménez S.> <BUG 312924 - Se agrega Proceso a resultado consulta de solicitudes (Variable tabla @ResultSolicitudGestion)>
-- Modificación:			<06/09/2023> <Luis Alonso Leiva Tames> <PBI 339328 Se realiza cambio para cuando se itineren acumulados no aparezca el expediente que se encuentra acumulado, solo muestre el padre>
-- Modificación:			<30/10/2023> <Josué Quirós Batista> <Itineración tipo: solicitud y resultado de solicitud. Retornar el código del legajo origen desde donde se presentó la solicitud.
--																 Retornar datos de la persona que resuelve.>
-- ===================================================================================================================================================================================
 CREATE   PROCEDURE [Expediente].[PA_ConsultarBuzonItineracionesRecibir]
	@NumeroPagina		SMALLINT,
	@CantidadRegistros	SMALLINT,
	@ContextoDestino	VARCHAR(4)		= NULL,
	@ContextoOrigen		VARCHAR(4)		= NULL,
	@NumeroExpediente	CHAR(14)		= NULL,
	@FechaInicio		DATETIME2(3)	= NULL,
	@FechaFinal			DATETIME2(3)	= NULL,
	@ListaEstados		EstadosBuzPendRecibirType	READONLY
AS 

BEGIN
--Variables 
DECLARE	@L_ContextoDestino				VARCHAR(4)				= @ContextoDestino
DECLARE	@L_ContextoOrigen				VARCHAR(4)				= @ContextoOrigen
DECLARE	@L_NumeroExpediente				CHAR(14)				= @NumeroExpediente
DECLARE @L_FechaInicio					DATETIME2(3)			= @FechaInicio
DECLARE @L_FechaFinal					DATETIME2(3)			= @FechaFinal
Declare @L_NumeroPagina					INT = Iif((@NumeroPagina IS NULL OR @NumeroPagina <= 0), 1, @NumeroPagina)
Declare @L_CantidadRegistros			INT = Iif((@CantidadRegistros IS NULL OR @CantidadRegistros <= 0), 50, @CantidadRegistros)
Declare @L_MotivoItineracionOtro		VARCHAR(9)				= NULL,
		@L_MotivoItineracionOtroSIAGPJ	SMALLINT				= NULL,
		@L_DescripcionMotivoItineracion	VARCHAR(255)			= NULL
		
	-- Se consulta las equivalencias entre catálogos de Itineraciones y SIAGPJ
	DECLARE	@EquivalenciasCatalogosItineracionSIAGPJ TABLE
		(
				CodigoCatalogo					VARCHAR(255)		NOT NULL,
				CodConfiguracion                VARCHAR(27)			NOT NULL
		)

	INSERT INTO @EquivalenciasCatalogosItineracionSIAGPJ
	SELECT	TC_Valor, TC_CodConfiguracion
	FROM	Configuracion.ConfiguracionValor 
	WHERE	TC_CodConfiguracion						IN	(	
															'C_EstadoItineracPendRecibir', 
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
			@L_MotivoItineracionOtroSIAGPJ	= M.TN_CodMotivoItineracion,
			@L_DescripcionMotivoItineracion = M.TC_Descripcion
	FROM Catalogo.MotivoItineracion M 
	WHERE M.TN_CodMotivoItineracion = (
		SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_MotivoItineracionOtro'
	)																			

	DECLARE	@Result TABLE
	(
			FechaCreacion					DATETIME2(3)		NOT NULL,
			FechaEnvio                      DATETIME2(3)        NOT NULL,   
			Acumulado						BIT					NOT NULL DEFAULT 0,
			MensajeError					VARCHAR(255)        NULL,
			SplitDatos						CHAR(15)			NOT NULL DEFAULT 'SplitDatos',
			CodigoItineracion				UNIQUEIDENTIFIER	NOT NULL,
			CodigoHistoricoItineracion		UNIQUEIDENTIFIER	NOT NULL,
			CodigoEntradaSalida				UNIQUEIDENTIFIER	NULL,
			CodigoTipoItineracion			SMALLINT			NOT NULL,
			TipoItineracionDescripcion		VARCHAR(255)		NOT NULL,
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
			DescripcionOficinaOrigen		VARCHAR(255)		NOT NULL,
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
			CodigoClaseAsuntoRecurso		INT					NULL,
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
			CodigoLegajoRecurso				UNIQUEIDENTIFIER	NULL,
			SplitSolicitud					CHAR(15)			NOT NULL DEFAULT 'SplitSolicitud',
			CodigoSolicitud					UNIQUEIDENTIFIER	NULL,
			CodigoClaseAsuntoSolicitud		INT					NULL,
			DescripcionClaseAsuntoSolicitud	VARCHAR(255)		NULL,
			DescripcionSolicitud			VARCHAR(255)		NULL,
			CodigoLegajoSolicitudOrigen		UNIQUEIDENTIFIER	NULL,
			UsuarioResuelve					VARCHAR(30)			NULL,
			NombreUsuarioResuelve			VARCHAR(30)			NULL,
			PrimerApellidoResuelve			VARCHAR(30)         NULL,
			SegundoApellidoResuelve			VARCHAR(30)         NULL,                                
			CodigoItineracionGestion		UNIQUEIDENTIFIER	NULL,
			CarpetaGestion					VARCHAR(14)			NULL
	)

	INSERT INTO	@Result
	(
				CodigoItineracion,
				CodigoHistoricoItineracion,
				CodigoEntradaSalida,
				FechaCreacion,	
				FechaEnvio,
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
				DescripcionMotivoItineracion,								 
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
				CodigoItineracionGestion,
				CarpetaGestion,
				CodigoLegajoRecurso,
				CodigoLegajoSolicitudOrigen,
				UsuarioResuelve,
				NombreUsuarioResuelve,
				PrimerApellidoResuelve,
				SegundoApellidoResuelve
	)

	-- Expedientes
	SELECT		I.TU_CodItineracion,
				I.TU_CodHistoricoItineracion,
				ES.TU_CodExpedienteEntradaSalida,
				ES.TF_CreacionItineracion,
				ES.TF_Salida,
				I.TC_NumeroExpediente,
				E.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				NULL,
				'00000000-0000-0000-0000-000000000000',
				'00000000-0000-0000-0000-000000000000',
				TI.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				I.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				ES.TN_CodMotivoItineracion,		 
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				I.TC_CodContextoDestino,
				CD.TC_Descripcion,
				S.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				I.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				NULL,
				EA.Acumulados,
				E.TB_Confidencial,
				I.TC_MensajeError,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
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
	INNER JOIN  Catalogo.TipoItineracion			TI WITH(NOLOCK)
	ON			I.TN_CodTipoItineracion				= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.EstadoItineracion			EI WITH(NOLOCK)
	ON			I.TN_CodEstadoItineracion   		= EI.TN_CodEstadoItineracion
	INNER JOIN	Catalogo.Contexto					CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino				= CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto					CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen				= CO.TC_CodContexto	
	INNER JOIN	Expediente.Expediente				E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente				= ES.TC_NumeroExpediente
	INNER JOIN	Catalogo.Oficina					OD WITH(NOLOCK)
	ON			CD.TC_CodOficina					= OD.TC_CodOficina
	INNER JOIN	Catalogo.Oficina					OO WITH(NOLOCK)
	ON			CO.TC_CodOficina					= OO.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina				S with(Nolock)
	ON			S.TN_CodTipoOficina					= OD.TN_CodTipoOficina
	LEFT JOIN   Historico.ExpedienteAcumulacion		A with(Nolock)
	ON			I.TC_NumeroExpediente				= A.TC_NumeroExpediente
	WHERE		ES.TF_Salida						IS NOT NULL
	AND			I.TC_CodContextoDestino				= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion			IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente				=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			ES.TF_Salida						>= COALESCE (@L_FechaInicio, ES.TF_Salida)	
	AND			ES.TF_Salida						<= COALESCE (@L_FechaFinal, ES.TF_Salida)	
	AND			I.TC_CodContextoOrigen  			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)
	AND			A.TU_CodAcumulacion					IS NULL


	UNION
	
	--Legajos
	SELECT		I.TU_CodItineracion,
				I.TU_CodHistoricoItineracion,
				ES.TU_CodLegajoEntradaSalida,
				ES.TF_CreacionItineracion,
				ES.TF_Salida,
				I.TC_Numeroexpediente,
				NULL,
				L.TU_CodLegajo,
				L.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				'00000000-0000-0000-0000-000000000000',
				TI.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				I.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				ES.TN_CodMotivoItineracion,
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				I.TC_CodContextoDestino,
				CD.TC_Descripcion,
				S.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				I.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				L.TC_CodContextoCreacion,
				0,
				0,
				I.TC_MensajeError,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Historico.LegajoEntradaSalida	ES WITH(NOLOCK)
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON          ES.TU_CodHistoricoItineracion   = I.TU_CodHistoricoItineracion
	INNER JOIN  Catalogo.TipoItineracion		TI WITH(NOLOCK)
	ON			I.TN_CodTipoItineracion			= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.EstadoItineracion		EI WITH(NOLOCK)
	ON			I.TN_CodEstadoItineracion   	= EI.TN_CodEstadoItineracion
	INNER JOIN	Catalogo.Contexto				CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino         = CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto               CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen			= CO.TC_CodContexto
	INNER JOIN	Expediente.Legajo				L WITH(NOLOCK)
	ON			L.TU_CodLegajo					= ES.TU_CodLegajo
	INNER JOIN	Catalogo.Oficina				OD WITH(NOLOCK)
	ON			CD.TC_CodOficina				= OD.TC_CodOficina
	INNER JOIN	Catalogo.Oficina				OO WITH(NOLOCK)
	ON			CO.TC_CodOficina				= OO.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			S with(Nolock)
	ON			S.TN_CodTipoOficina				= OD.TN_CodTipoOficina
	WHERE		ES.TF_Salida					IS NOT NULL
	AND			I.TC_CodContextoDestino			= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			ES.TF_Salida					>= COALESCE (@L_FechaInicio, ES.TF_Salida)	
	AND			ES.TF_Salida					<= COALESCE (@L_FechaFinal, ES.TF_Salida)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION 

	--Recursos 
	SELECT		I.TU_CodItineracion,
				I.TU_CodHistoricoItineracion,
				NULL,
				RE.TF_Fecha_Creacion,
				RE.TF_Fecha_Envio,
				I.TC_NumeroExpediente,
				E.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				NULL,
				RE.TU_CodRecurso,
				'00000000-0000-0000-0000-000000000000',
				TI.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				I.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				RE.TN_CodMotivoItineracion,
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				RE.TC_CodContextoDestino,
				CD.TC_Descripcion,
				S.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				RE.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				NULL,
				EA.Acumulados,
				0,
				I.TC_MensajeError,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Expediente.RecursoExpediente	RE WITH(NOLOCK)
	OUTER APPLY	(
					SELECT		CASE
									WHEN COUNT(*) > 0 THEN 1
									ELSE 0
								END Acumulados
					FROM		Historico.ExpedienteAcumulacion		H WITH(NOLOCK)
					WHERE		H.TC_NumeroExpedienteAcumula		= RE.TC_NumeroExpediente
					AND			H.TF_InicioAcumulacion				IS NOT NULL
					AND			H.TF_FinAcumulacion					IS NULL
				) EA
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON			RE.TU_CodHistoricoItineracion	= I.TU_CodHistoricoItineracion
	INNER JOIN  Catalogo.TipoItineracion		TI WITH(NOLOCK)
	ON			I.TN_CodTipoItineracion			= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.EstadoItineracion		EI WITH(NOLOCK)
	ON			I.TN_CodEstadoItineracion   	= EI.TN_CodEstadoItineracion
	INNER JOIN	Catalogo.Contexto				CD WITH(NOLOCK)
	ON			I.TC_CodContextoDestino         = CD.TC_CodContexto
	INNER JOIN	Catalogo.Contexto               CO WITH(NOLOCK)
	ON			I.TC_CodContextoOrigen			= CO.TC_CodContexto
	INNER JOIN	Catalogo.Oficina				OD WITH(NOLOCK)
	ON			CD.TC_CodOficina				= OD.TC_CodOficina
	INNER JOIN	Catalogo.Oficina				OO WITH(NOLOCK)
	ON			CO.TC_CodOficina				= OO.TC_CodOficina
	INNER JOIN	Expediente.Expediente			E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= RE.TC_Numeroexpediente
	INNER JOIN	Catalogo.TipoOficina			S with(Nolock)
	ON			S.TN_CodTipoOficina				= OD.TN_CodTipoOficina
	WHERE		RE.TF_Fecha_Envio                IS NOT NULL
	AND			RE.TC_CodContextoDestino		= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			RE.TF_Fecha_Envio				>= COALESCE (@L_FechaInicio, RE.TF_Fecha_Envio)	
	AND			RE.TF_Fecha_Envio				<= COALESCE (@L_FechaFinal, RE.TF_Fecha_Envio)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION

	--Solicitudes 
	SELECT		I.TU_CodItineracion,
				I.TU_CodHistoricoItineracion,
				NULL,
				SE.TF_FechaCreacion,
				SE.TF_FechaEnvio,
				I.TC_Numeroexpediente,
				E.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				SE.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				SE.TU_CodSolicitudExpediente,
				I.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				I.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				SE.TN_CodMotivoItineracion,
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				I.TC_CodContextoDestino,
				CD.TC_Descripcion,
				S.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				I.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				NULL,
				EA.Acumulados,
				0,
				I.TC_MensajeError,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				SE.TU_CodLegajo,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Expediente.SolicitudExpediente	SE WITH(NOLOCK)
	OUTER APPLY	(
					SELECT		CASE
									WHEN COUNT(*) > 0 THEN 1
									ELSE 0
								END Acumulados
					FROM		Historico.ExpedienteAcumulacion		H WITH(NOLOCK)
					WHERE		H.TC_NumeroExpedienteAcumula		= SE.TC_NumeroExpediente
					AND			H.TF_InicioAcumulacion				IS NOT NULL
					AND			H.TF_FinAcumulacion					IS NULL
				) EA
	INNER JOIN  Historico.Itineracion			I WITH(NOLOCK)
	ON			SE.TU_CodHistoricoItineracion	= I.TU_CodHistoricoItineracion
	INNER JOIN  Catalogo.TipoItineracion		TI WITH(NOLOCK)
	ON			I.TN_CodTipoItineracion			= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.EstadoItineracion		EI WITH(NOLOCK)
	ON			I.TN_CodEstadoItineracion   	= EI.TN_CodEstadoItineracion
	INNER JOIN	Catalogo.Contexto				CO WITH(NOLOCK)
	ON			CO.TC_CodContexto				= SE.TC_CodContextoOrigen
	INNER JOIN	Catalogo.Oficina				OO WITH(NOLOCK)
	ON			OO.TC_CodOficina				= CO.TC_CodOficina
	INNER JOIN	Catalogo.Contexto				CD with(Nolock)
	ON			CD.TC_CodContexto				= SE.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina				OD with(Nolock)
	ON			OD.TC_codOficina				= CD.TC_CodOficina
	INNER JOIN	Expediente.Expediente			E WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= SE.TC_Numeroexpediente
	INNER JOIN	Catalogo.TipoOficina			S with(Nolock)
	ON			S.TN_CodTipoOficina				= OD.TN_CodTipoOficina
	WHERE		SE.TC_CodContextoDestino		= @L_ContextoDestino
	AND			I.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			I.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente, I.TC_NumeroExpediente)
	AND			SE.TF_FechaEnvio				>= COALESCE (@L_FechaInicio, SE.TF_FechaEnvio)	
	AND			SE.TF_FechaEnvio				<= COALESCE (@L_FechaFinal, SE.TF_FechaEnvio)	
	AND			I.TC_CodContextoOrigen			=  COALESCE (@L_ContextoOrigen, I.TC_CodContextoOrigen)

	UNION

	--Resultado Recursos
	SELECT		D.TU_CodItineracion,
				D.TU_CodHistoricoItineracion,
				NULL,
				A.TF_FechaCreacion,
				A.TF_FechaEnvio,
				B.TC_NumeroExpediente,
				C.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				B.TC_Descripcion,
				(SELECT TU_CodRecurso
				 FROM	Expediente.RecursoExpediente RE
				 JOIN	Expediente.ResultadoRecurso RR
				 ON		RE.TU_CodResultadoRecurso = RR.TU_CodResultadoRecurso
				 WHERE	RR.TU_CodLegajo = A.TU_CodLegajo),
				'00000000-0000-0000-0000-000000000000',
				D.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				D.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				A.TN_CodMotivoItineracion,
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				D.TC_CodContextoDestino,
				CD.TC_Descripcion,
				S.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				D.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				B.TC_CodContexto,
				0,
				0,
				D.TC_MensajeError,
				A.TU_CodResultadoRecurso,
				'00000000-0000-0000-0000-000000000000',
				F.TN_CodResultadoLegajo,
				F.TC_Descripcion,
				A.TU_CodLegajo,
				'00000000-0000-0000-0000-000000000000',
				G.TU_CodRecurso,
				'00000000-0000-0000-0000-000000000000',
				NULL,
				NULL,
				RE.TU_CodLegajo,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Expediente.ResultadoRecurso		A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo				B WITH(NOLOCK)
	ON			B.TU_CodLegajo					= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente			C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente			= B.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion			D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion	= A.TU_CodHistoricoItineracion
	INNER JOIN  Catalogo.TipoItineracion		TI WITH(NOLOCK)
	ON			D.TN_CodTipoItineracion			= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.EstadoItineracion		EI WITH(NOLOCK)
	ON			D.TN_CodEstadoItineracion   	= EI.TN_CodEstadoItineracion
	INNER JOIN	Expediente.LegajoDetalle		E WITH(NOLOCK)
	ON			E.TU_CodLegajo					= B.TU_CodLegajo
	INNER JOIN	Catalogo.Contexto				CD with(Nolock)
	ON			CD.TC_CodContexto				= D.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina				OD with(Nolock)
	ON			OD.TC_codOficina				= CD.TC_CodOficina
	INNER JOIN	Catalogo.Contexto				CO WITH(NOLOCK)
	ON			CO.TC_CodContexto				= D.TC_CodContextoOrigen
	INNER JOIN	Catalogo.Oficina				OO WITH(NOLOCK)
	ON			OO.TC_CodOficina				= CO.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			S with(Nolock)
	ON			S.TN_CodTipoOficina				= OD.TN_CodTipoOficina
	INNER JOIN	Catalogo.ResultadoLegajo		F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo			= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionRecursoResultado	G
	ON			A.TU_CodLegajo					= G.TU_CodLegajo
	INNER JOIN	Expediente.RecursoExpediente	RE
	ON			G.TU_CodRecurso					= RE.TU_CodRecurso 
	WHERE		E.TC_CodContextoProcedencia		IS NOT NULL
	AND			D.TC_CodContextoDestino			= @L_ContextoDestino
	AND			D.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			B.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaCreacion				>= COALESCE (@L_FechaInicio,A.TF_FechaCreacion)	
	AND			A.TF_FechaCreacion				<= COALESCE (@L_FechaFinal,A.TF_FechaCreacion)
	AND			A.TU_CodLegajo					=  (SELECT TOP 1	L.TU_CodLegajo
												    FROM			Expediente.Legajo L
												    WHERE			TC_CodContexto = COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
													AND				L.TU_CodLegajo = A.TU_CodLegajo)
	
	UNION

	--Resultado Solicitudes
	SELECT		D.TU_CodItineracion,
				D.TU_CodHistoricoItineracion,
				NULL,
				A.TF_FechaCreacion,
				A.TF_FechaEnvio,
				B.TC_NumeroExpediente,
				C.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				B.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				NULL,
				D.TN_CodTipoItineracion,
				TI.TC_Descripcion,
				D.TN_CodEstadoItineracion,
				EI.TC_Descripcion,
				A.TN_CodMotivoItineracion,
				NULL,
				OD.TC_CodOficina,
				OD.TC_Nombre,
				D.TC_CodContextoDestino,
				CD.TC_Descripcion,
				T.TN_CodTipoOficina,
				CD.TC_CodMateria,
				OO.TC_CodOficina,
				OO.TC_Nombre,
				D.TC_CodContextoOrigen,
				CO.TC_Descripcion,
				B.TC_CodContexto,
				0,
				0,
				D.TC_MensajeError,
				'00000000-0000-0000-0000-000000000000',
				a.TU_CodResultadoSolicitud,
				F.TN_CodResultadoLegajo,
				F.TC_Descripcion,
				'00000000-0000-0000-0000-000000000000',
				A.TU_CodLegajo,
				'00000000-0000-0000-0000-000000000000',
				G.TU_CodSolicitud,
				NULL,
				NULL,
				NULL,
				S.TU_CodLegajo,
				A.TC_UsuarioRed,
				NULL,
				NULL,
				NULL
	FROM		Expediente.ResultadoSolicitud	A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo				B WITH(NOLOCK)
	ON			B.TU_CodLegajo					= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente			C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente			= B.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion			D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion	= A.TU_CodHistoricoItineracion
	INNER JOIN	Catalogo.EstadoItineracion		EI WITH(NOLOCK)
	ON			D.TN_CodEstadoItineracion   	= EI.TN_CodEstadoItineracion
	INNER JOIN	Expediente.LegajoDetalle		E WITH(NOLOCK)
	ON			E.TU_CodLegajo					= B.TU_CodLegajo
	INNER JOIN  Catalogo.TipoItineracion		TI WITH(NOLOCK)
	ON			D.TN_CodTipoItineracion			= TI.TN_CodTipoItineracion
	INNER JOIN	Catalogo.Contexto				CD with(Nolock)
	ON			CD.TC_CodContexto				= D.TC_CodContextoDestino
	INNER JOIN	Catalogo.Oficina				OD with(Nolock)
	ON			OD.TC_codOficina				= CD.TC_CodOficina
	INNER JOIN	Catalogo.TipoOficina			T with(Nolock)
	ON			T.TN_CodTipoOficina				= OD.TN_CodTipoOficina
	INNER JOIN	Catalogo.Contexto				CO WITH(NOLOCK)
	ON			CO.TC_CodContexto				= D.TC_CodContextoOrigen
	INNER JOIN	Catalogo.Oficina				OO WITH(NOLOCK)
	ON			OO.TC_CodOficina				= CO.TC_CodOficina
	INNER JOIN	Catalogo.ResultadoLegajo		F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo			= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionSolicitudResultado	G WITH(NOLOCK)
	ON			A.TU_CodLegajo					= G.TU_CodLegajo
    INNER JOIN  Expediente.SolicitudExpediente	S WITH(NOLOCK)
	On			S.TU_CodSolicitudExpediente		= G.TU_CodSolicitud
	WHERE		E.TC_CodContextoProcedencia		IS NOT NULL
	AND			D.TC_CodContextoDestino			= @L_ContextoDestino
	AND			D.TN_CodEstadoItineracion		IN (SELECT Codigo FROM @ListaEstados)
	AND			B.TC_NumeroExpediente			=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaCreacion				>= COALESCE (@L_FechaInicio,A.TF_FechaCreacion)	
	AND			A.TF_FechaCreacion				<= COALESCE (@L_FechaFinal,A.TF_FechaCreacion)
	AND			A.TU_CodLegajo					=  (SELECT TOP 1	L.TU_CodLegajo
												    FROM			Expediente.Legajo L
												    WHERE			TC_CodContexto = COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
													AND				L.TU_CodLegajo = A.TU_CodLegajo)

UNION

	-- Itineraciones de Gestión
	SELECT		'00000000-0000-0000-0000-000000000000',		-- CodigoItineracion
				'00000000-0000-0000-0000-000000000000',		-- CodigoHistoricoItineracion
				NULL,										-- CodigoEntradaSalida
				ISNULL(A.FechaCreacion, GETDATE()),			-- FechaCreacion
				ISNULL(A.FechaEnvio, GETDATE()),			-- FechaEnvio
				A.NumeroExpediente,							-- Numero (Expediente)
				NULL,										-- Descripcion (Expediente)
				'00000000-0000-0000-0000-000000000000',		-- CodigoLegajo
				NULL,										-- DescripcionLegajo
				'00000000-0000-0000-0000-000000000000',		-- CodigoRecurso
				NULL,										-- CodigoSolicitud
				TI.TN_CodTipoItineracion,					-- CodigoTipoItineracion
				ISNULL(Z.TC_Descripcion, TI.TC_Descripcion) TC_Descripcion,-- TipoItineracionDescripcion
				EI.TN_CodEstadoItineracion,					-- CodigoEstadoItineracion
				ISNULL(EI.TC_Descripcion, 'Procesando'),	-- DescripcionEstadoItineracion
				ISNULL(MI.TN_CodMotivoItineracion, @L_MotivoItineracionOtroSIAGPJ),	-- CodigoMotivoItineracion				
				ISNULL(MI.TC_Descripcion, @L_DescripcionMotivoItineracion),				-- DescripcionMotivoItineracion
				A.CodigoOficinaDestino,						-- CodigoOficinaDestino
				ISNULL(OD.TC_Nombre, '-'),					-- DescripcionOficinaDestino
				A.CodigoOficinaDestino,						-- CodigoContextoDestino
				ISNULL(CD.TC_Descripcion, '-'),				-- DescripcionContextoDestino
				ISNULL(T.TN_CodTipoOficina, 0),				-- CodigoTipoOficinaDestino
				ISNULL(CD.TC_CodMateria, 0),				-- CodigoMateriaOficinaDest
				A.CodigoOficinaOrigen,						-- CodigoOficinaOrigen
				ISNULL(OO.TC_Nombre, CONCAT('La oficina ', A.CodigoOficinaOrigen, ' no existe en catalogo')),	-- DescripcionOficinaOrigen
				A.CodigoOficinaOrigen,						-- CodigoContextoOrigen
				ISNULL(CO.TC_Descripcion, CONCAT('El contexto ', A.CodigoOficinaOrigen, ' no existe en catalogo')),	-- DescripcionContextoOrigen
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
				A.CodigoItineracion,						-- CodigoItineracionGestion
				A.Carpeta,									-- CarpetaGestion de DCAR (para detectar legajo en proceso de itineraciones)
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL
	FROM		Itineracion.V_ItineracionesEntrantes	A	WITH(NOLOCK) -- VISTA DESDE BD ITINERACIONES
	LEFT JOIN	Catalogo.TipoItineracion				TI	WITH(NOLOCK)
	ON			TI.TN_CodTipoItineracion				=	CASE 
																WHEN A.TipoItineracion = 'EnvioRecurso' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionRecurso')
																WHEN A.TipoItineracion = 'EnvioCarpeta' THEN (
																		SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = CASE 
																																										WHEN A.CodAsu IN 
																																										(
																																											SELECT CodigoCatalogo 
																																											FROM @EquivalenciasCatalogosItineracionSIAGPJ 
																																											WHERE CodConfiguracion = 'U_IndicadorExpGestion'
																																										) THEN 'C_TipoItineracionExpediente' 
																																										ELSE 'C_TipoItineracionLegajo' 
																																									END
																	)
																WHEN A.TipoItineracion = 'EnvioSolicitud' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionSolicitud')
																WHEN A.TipoItineracion = 'DevolucionSolicitud' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionResultadoS')
																WHEN A.TipoItineracion = 'DevolucionRecurso' THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_TipoItineracionResultadoR')
																ELSE NULL
															END
	LEFT JOIN	Catalogo.EstadoItineracion				EI	WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion				=	CASE 
																WHEN A.TieneError = 1 THEN (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_EstadoItineracErrorRecibi')
																WHEN A.Procesando = 1 THEN NULL
																ELSE (SELECT CodigoCatalogo FROM @EquivalenciasCatalogosItineracionSIAGPJ WHERE CodConfiguracion = 'C_EstadoItineracPendRecibir')
															END
	LEFT JOIN	Catalogo.Oficina						OD	WITH(NOLOCK)
	ON			OD.TC_codOficina						=	A.CodigoOficinaDestino
	LEFT JOIN	Catalogo.Contexto						CD  WITH(NOLOCK)
	ON			CD.TC_CodContexto						=	A.CodigoOficinaDestino
	LEFT JOIN	Catalogo.Contexto						CO	WITH(NOLOCK)
	ON			CO.TC_CodContexto						=	A.CodigoOficinaOrigen
	LEFT JOIN	Catalogo.Oficina						OO	WITH(NOLOCK)
	ON			OO.TC_CodOficina						=	A.CodigoOficinaOrigen 
	LEFT JOIN	Catalogo.MotivoItineracion				MI	WITH(NOLOCK)
	ON			MI.CODMOT								=	ISNULL(A.CodMotivoItineracion, @L_MotivoItineracionOtro)
	LEFT JOIN	Catalogo.TipoOficina					T	WITH(NOLOCK)
	ON			T.TN_CodTipoOficina						=	OD.TN_CodTipoOficina	
	OUTER APPLY (
					SELECT	TOP 1  Y.TN_CodAsunto, Y.TC_Descripcion
  					FROM	       Catalogo.Asunto			Y  WITH(NOLOCK)	
					WHERE	       Y.CODASU					=  A.CodAsu
					ORDER BY	   ISNULL(T.TF_Fin_Vigencia, GETDATE()) DESC
				 ) Z

	WHERE		A.CodOficinaConsulta					=	@L_ContextoDestino
	AND			A.NumeroExpediente						=	COALESCE (@L_NumeroExpediente, A.NumeroExpediente)
	AND			(@L_FechaInicio IS NULL					OR 	DATEDIFF(DAY,
															CASE 
																WHEN	A.TieneError = 1 THEN A.FechaError
																ELSE	A.FechaEnvio
															END
															,@L_FechaInicio) <= 0)
	AND			(@L_FechaFinal	IS NULL					OR 	DATEDIFF(DAY, 
															CASE 
																WHEN	A.TieneError = 1 THEN A.FechaError
																ELSE	A.FechaEnvio
															END
															,@L_FechaFinal) >= 0)
	AND			A.CodigoOficinaOrigen					=	COALESCE (@L_ContextoOrigen, A.CodigoOficinaOrigen)	  
	
	
	
	DECLARE @TotalRegistros				AS INT = @@ROWCOUNT; 


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
	SET				A.TipoResolucionRecurso			= D.TC_Descripcion,
					A.TipoResultadoRecurso			= E.TC_Descripcion,
					A.RedactorRecurso				= G.TC_Nombre + ' ' + ISNULL(G.TC_PrimerApellido,'') + ' ' + ISNULL(G.TC_SegundoApellido,''),
					A.FechaResolucion				= C.TF_FechaResolucion,
					A.NumeroResolucion				= H.TC_NumeroResolucion,
					A.CodigoArchivoResolucion		= C.TU_CodArchivo,
					A.NumeroExpedienteRecurso		= C.TC_NumeroExpediente
	FROM			@Result							A
	INNER JOIN		Expediente.RecursoExpediente	B WITH(NOLOCK)
	ON				B.TU_CodRecurso					= A.CodigoRecurso
	INNER JOIN		Expediente.Resolucion			C
	ON				C.TU_CodResolucion				= B.TU_CodResolucion
	INNER JOIN		Catalogo.TipoResolucion			D
	ON				D.TN_CodTipoResolucion			= C.TN_CodTipoResolucion
	INNER JOIN		Catalogo.ResultadoResolucion	E
	ON				E.TN_CodResultadoResolucion		= C.TN_CodResultadoResolucion
	INNER JOIN		Catalogo.PuestoTrabajoFuncionario F
	ON				C.TU_RedactorResponsable		= F.TU_CodPuestoFuncionario
	INNER JOIN		Catalogo.Funcionario			G
	ON				G.TC_UsuarioRed					= F.TC_UsuarioRed
	LEFT JOIN		Expediente.LibroSentencia		H
	ON				H.TU_CodResolucion				= C.TU_CodResolucion


	--Acutalización catálogos recurso
	UPDATE			A
	SET				A.CodigoClaseAsuntoRecurso		= B.TN_CodClaseAsunto,		
					A.DescripcionClaseAsuntoRecurso	= C.TC_Descripcion,
					A.CodigoAsuntoRecurso           = C.TN_CodAsunto
	FROM			@Result							A
	INNER JOIN		Expediente.RecursoExpediente	B WITH(NOLOCK)
	ON				B.TU_CodRecurso					= A.CodigoRecurso
	INNER JOIN		Catalogo.ClaseAsunto			C WITH(NOLOCK)
	ON				C.TN_CodClaseAsunto				= B.TN_CodClaseAsunto

	--***********************************************
	-- obtener todos los recuros GESTION
	--***********************************************

	DECLARE @CodigoRecursosGestion  TABLE
	(
		id int identity (1,1) not null, 
		CodigoRecurso UNIQUEIDENTIFIER 
	)

	DECLARE @ResultRecursosGestion TABLE	(
			Codigo					uniqueidentifier,
			Idacorec				int,
			SplitOtros				varchar(20),
			NumeroExpediente		char(14),
			FechaInicio				datetime2(7),
			CodigoContexto			varchar(4),
			ContextoCreacion		varchar(4),
			Descripcion				varchar(255),
			Prioridad				smallint,
			Carpeta					varchar(14),
			Contexto				varchar(4),
			FechaEntrada			datetime2(7),
			Asunto					int,
			ClaseAsunto				int,
			ContextoProcedencia		varchar(4),		
			GrupoTrabajo			varchar(11),
			Habilitado				bit, 
			MateriaContexto			varchar(2),
			TipoOficina				smallint,
			CODRES					varchar(4),
			CodigoGestion			uniqueidentifier
)


	INSERT INTO @CodigoRecursosGestion
	select CodigoItineracion from Itineracion.V_ItineracionesEntrantes a
	WHERE	TipoItineracion = 'EnvioRecurso'

	Declare @count int = 1
	Declare @codigoGestion UNIQUEIDENTIFIER


	
	--Recorrer cada item para obtener los codigos de asunto y clase de asunto 
	while @count <= (select count(1) from @CodigoRecursosGestion)  
	BEGIN
	
		select @codigoGestion = CodigoRecurso from @CodigoRecursosGestion where id = @count;

		insert into @ResultRecursosGestion (Codigo,Idacorec,SplitOtros,NumeroExpediente,FechaInicio,CodigoContexto,ContextoCreacion,Descripcion,Prioridad,Carpeta,Contexto,FechaEntrada,Asunto,ClaseAsunto,ContextoProcedencia,GrupoTrabajo,Habilitado,MateriaContexto,TipoOficina,CODRES)
		EXEC [Itineracion].[PA_ConsultarDetalleItineracionRecurso] @codigoGestion 

		if( @codigoGestion != '00000000-0000-0000-0000-000000000000') begin
			update @ResultRecursosGestion set CodigoGestion = @codigoGestion where CodigoGestion is null
		end

		SET @count = @count + 1
		SET @codigoGestion = '00000000-0000-0000-0000-000000000000'

	END
	
	--- Obtener cuales son los recursos de gestion 
	--- y Actualizar los datos necesarios para el recurso

	--- Obtener cuales son los recursos de gestion 
	--- y Actualizar los datos necesarios para el recurso

		UPDATE			A
		SET				A.CodigoClaseAsuntoRecurso		= C.TN_CodClaseAsunto,		
						A.DescripcionClaseAsuntoRecurso	= C.TC_Descripcion,
						A.CodigoAsuntoRecurso           = C.TN_CodAsunto,
						A.DescripcionAsuntoRecurso		=  D.TC_Descripcion,
						A.CodigoClaseAsunto				= C.TN_CodClaseAsunto,
						A.DescripcionAsunto				= C.TC_Descripcion, 
						A.CodigoClase					= C.TN_CodClaseAsunto, 
						A.DescripcionClase				= C.TC_Descripcion, 
						A.TipoResolucionRecurso			= T.TC_Descripcion, 
						A.FechaResolucion				= R.FechaInicio, 
						A.HoraResolucion				= R.FechaInicio, 
						A.NumeroResolucion				= null
		FROM			@Result									A
		INNER JOIN		Itineracion.V_ItineracionesEntrantes	B WITH(NOLOCK)
		ON				A.CodigoItineracionGestion	= B.CodigoItineracion
		INNER JOIN		@ResultRecursosGestion	R 
		ON				B.CodigoItineracion = R.CodigoGestion
		INNER JOIN		Catalogo.ClaseAsunto			C WITH(NOLOCK)
		ON				C.TN_CodClaseAsunto				= R.ClaseAsunto
		INNER JOIN		Catalogo.TipoResolucion			 T WITH(NOLOCK)
		ON				T.CODRES						= R.CODRES
		LEFT JOIN		Catalogo.Asunto					D WITH (NOLOCK)
		ON				D.TN_CodAsunto					= C.TN_CodAsunto
		WHERE			TipoItineracion = 'EnvioRecurso'
	--***********************************************
	-- FIN obtener todos los recuros GESTION
	--***********************************************
	--***********************************************
	-- OBtener los datos de solicitudes de Gestion --

		DECLARE @CodigoSolicitudGestion  TABLE
	(
		id int identity (1,1) not null, 
		CodigoSolicitud UNIQUEIDENTIFIER 
	)

	DECLARE @ResultSolicitudGestion TABLE	(
			Codigo					uniqueidentifier,
			Idacosol				int,
			SplitOtros				varchar(10),
			NumeroExpediente		char(14),
			FechaInicio				datetime2(7),
			CodigoContexto			varchar(4),	
			ContextoCreacion		varchar(4),
			Descripcion				varchar(255),
			Prioridad				varchar(9),
			Carpeta					varchar(14),
			Contexto				varchar(4),
			FechaEntrada			datetime2(7),
			Asunto					int,
			ClaseAsunto				int,
			ContextoProcedencia		varchar(4),		
			GrupoTrabajo			varchar(11),
			Habilitado				bit, 
			MateriaContexto			varchar(2),
			TipoOficina				smallint,
			Proceso					smallint,
			CodigoGestion			uniqueidentifier
)

	INSERT INTO @CodigoSolicitudGestion
	select CodigoItineracion from Itineracion.V_ItineracionesEntrantes a
	WHERE	TipoItineracion = 'EnvioSolicitud'



	set @count = 1
	SET @codigoGestion = '00000000-0000-0000-0000-000000000000'

	
	--Recorrer cada item para obtener los codigos de asunto y clase de asunto 
	while @count <= (select count(1) from @CodigoSolicitudGestion)  
	BEGIN
	
		select @codigoGestion = CodigoSolicitud from @CodigoSolicitudGestion where id = @count;

		insert into @ResultSolicitudGestion (Codigo,Idacosol,SplitOtros,NumeroExpediente,FechaInicio,CodigoContexto,ContextoCreacion,Descripcion,Prioridad,Carpeta,Contexto,FechaEntrada,Asunto,ClaseAsunto,ContextoProcedencia,GrupoTrabajo,Habilitado,MateriaContexto,TipoOficina, Proceso)
		EXEC [Itineracion].[PA_ConsultarDetalleItineracionSolicitud] @codigoGestion 

		update @ResultSolicitudGestion set CodigoGestion = @codigoGestion where CodigoGestion is null

		SET @count = @count + 1

	END



		UPDATE			A
					SET				A.CodigoClaseAsuntoSolicitud		=	C.TN_CodClaseAsunto,		
									A.DescripcionClaseAsuntoSolicitud	=	C.TC_Descripcion,
									A.DescripcionSolicitud				=	S.Descripcion,
									A.CodigoClase						= C.TN_CodClaseAsunto,
									A.DescripcionAsunto					= C.TC_Descripcion
		FROM			@Result							A
		INNER JOIN		Itineracion.V_ItineracionesEntrantes	B WITH(NOLOCK)
		ON				A.CodigoItineracionGestion			= B.CodigoItineracion
		INNER JOIN		@ResultSolicitudGestion	S 
		ON				B.CodigoItineracion = S.CodigoGestion
		LEFT JOIN		Catalogo.ClaseAsunto			C WITH(NOLOCK)
		ON				C.TN_CodClaseAsunto				= S.ClaseAsunto

	-- Fin modificacion de los recursos y solicitudes

	-- Obtenemos todos los resultados de recurso y solicitud ya que en Gestion los guardan en las mismas tablas 

	DECLARE @CodigoSolicitudResultadoRecurso  TABLE
	(
		id int identity (1,1) not null, 
		CodigoResultadoRecurso UNIQUEIDENTIFIER 
	)

		DECLARE @ResultResultadoRecursoGestion TABLE	(
			Codigo					uniqueidentifier,
			ResultadoCodigo			varchar(10), 
			Descripcion				varchar(255),
			UsuarioRed				varchar(300),
			CodigoGestion			uniqueidentifier
			)



	insert into @CodigoSolicitudResultadoRecurso
	select A.CodigoItineracionGestion
	From @Result A 
	where -- si cumple viene de Gestion 
	(A.CodigoTipoItineracion = '5' or A.CodigoTipoItineracion = '6')  and (CodigoItineracion is null or CodigoItineracion = '00000000-0000-0000-0000-000000000000') 

	set @count = 1
	SET @codigoGestion = '00000000-0000-0000-0000-000000000000'

	
	--Recorrer cada item para obtener los codigos de asunto y clase de asunto 
	while @count <= (select count(1) from @CodigoSolicitudResultadoRecurso)  
	BEGIN
	
		select @codigoGestion = CodigoResultadoRecurso from @CodigoSolicitudResultadoRecurso where id = @count;

		insert into @ResultResultadoRecursoGestion (Codigo, ResultadoCodigo, Descripcion, UsuarioRed)
		EXEC  [Itineracion].[PA_ConsultarResultadoGestion] @codigoGestion
	

		update @ResultResultadoRecursoGestion set CodigoGestion = @codigoGestion where CodigoGestion is null

		SET @count = @count + 1

	END

	-- Modificamos los resultados de recurso y Solicitud, ya que en gestion se guardan en la misma tabla
	update A SET 
		A.DescripcionResultadoLegajo = R.Descripcion, --Muestra el resultado
		A.RedactorRecurso = R.UsuarioRed
	From @Result A INNER JOIN 
	@ResultResultadoRecursoGestion R 
	ON A.CodigoItineracionGestion = R.CodigoGestion
	where -- si cumple viene de Gestion 
	(A.CodigoTipoItineracion = '5' or A.CodigoTipoItineracion = '6') and (CodigoItineracion is null or CodigoItineracion = '00000000-0000-0000-0000-000000000000') 



	--Acutalización catálogos solicitud
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

	-- Se obtiene al usuario que resolvió la solicitud.
	UPDATE		A
	SET
				A.NombreUsuarioResuelve		= F.TC_Nombre, 
				A.PrimerApellidoResuelve	= F.TC_PrimerApellido, 
				A.SegundoApellidoResuelve	= F.TC_SegundoApellido
	FROM		@Result	A 
	INNER JOIN  Catalogo.Funcionario		F WITH(NOLOCK) 
	ON			F.TC_UsuarioRed				= A.UsuarioResuelve
	
	--Acutalización catalogos
	UPDATE			A
	SET				A.CodigoMotivoItineracion		= F.TN_CodMotivoItineracion,
					A.DescripcionMotivoItineracion	= F.TC_Descripcion
	FROM			@Result							A
	INNER JOIN		Catalogo.MotivoItineracion		F WITH(NOLOCK)
	ON				F.TN_CodMotivoItineracion		= A.CodigoMotivoItineracion
	WHERE			A.CodigoItineracionGestion		IS NULL
	--

	SELECT	@TotalRegistros					AS	TotalRegistros,
			FechaCreacion,	
			FechaEnvio,
			Acumulado,
			MensajeError,
			CodigoItineracionGestion,
			CarpetaGestion,
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
			FechaResolucion,
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
			CodigoLegajoRecurso ,
			CodigoLegajoSolicitudOrigen,
			UsuarioResuelve,
			NombreUsuarioResuelve,
			PrimerApellidoResuelve,
			SegundoApellidoResuelve,
			SplitExpediente,	--SPLIT EXPEDIENTE		
			Numero,	
			Descripcion,
			Confidencial,
			SplitLegajo,			--SPLIT LEGAJO
			CodigoLegajo  Codigo,			
			DescripcionLegajo Descripcion,
			SplitRecurso,  --SPLIT RECURSO
			CodigoRecurso Codigo,
			SplitSolicitud,				--SPLIT SOLICITUD
			CodigoSolicitud Codigo, 
			DescripcionSolicitud Descripcion
	FROM @Result
	ORDER By FechaCreacion DESC

	OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
	FETCH NEXT	@L_CantidadRegistros ROWS ONLY

END
GO
