SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<08/05/2020>
-- Descripción :			<Permite consultar los registro para el buzón de itineraciones>
-- ===============================================================================================================================================================================
-- Modificación:			<Andrew Allen Dawson> <18/06/2020>
-- Modificación:			<Jonathan Aguilar Navarro> <07/08/2020> <Se agrega al sp la consulta de la información de la resolución asociada al recurso>
-- Modificación:			<Aida Elena Siles R> <13/08/2020> <Se agrega par˜metro ListaEstados para realizar la consulta de acuerdo a los estados definidos variable config>
-- Modificación:			<Aida Elena Siles R> <19/08/2020> <Se quita el par˜metro ListaEstados. Y se envia el estadoPendEnviar y el estadoErrorEnviar>
-- Modificación:			<Jonathan Aguilar Navarro> <03/09/2020> <Se agrega a la consuta la información del documento de la solicitud>
-- Modificación:			<Jonathan Aguilar Navarro> <09/09/2020> <Se agrega a la consulta el código de histórico itineración de cada uno de las itineraciones>
-- Modificación:			<Jonathan Aguilar Navarro> <19/09/2020> <Se realizan modificacones varðas para mejeroar el rendimiento de la consulta. Me ayudó Esteban Cordero.>
-- Modificación:			<Ronny Ramírez R.> <24/09/2020> <Se agrega a la consulta los registros de Resultado, tanto de Recurso, como de Solicitud>
-- Modificación:			<Andrew Allen Dawson> <04/11/2020> <Se modifica la consulta de Resultado y Recursos para que contemple el contexto del legajo>
-- Modificación:			<Aida Elena Siles R> <06/11/2020> <Se modifica la consulta para incorporar datos de resultado solicitud y resultado recurso>
-- Modificación:			<Aida Elena Siles R> <25/11/2020> <Se modifica TF_Entrada por TF_CreacionItineracion para expediente y legajo. Ya que estaba mal.>
-- Modificación:			<08/12/2020> <Aida Elena Siles R> <Se corrige el nombre de CodigoItineracion por CodigoEntradaSalida.>
-- Modificación:			<10/12/2020> <Karol Jim‚nez S˜nchez> <Se consulta si el contexto destino de la itineración utiliza SIAGPJ.>
-- Modificación:			<20/01/2021> <Aida Elena Siles R> <Se modifica el tipo de dato del codigo clase asunto por INT ya que se cambio en la tabla cat˜logo>
-- Modificación:			<19/02/2021> <Aida Elena Siles R> <Se agrega contexto del expediente y se realiza corrección tamaÏo campos nombre, apell1 y apell2>
-- Modificación:			<15/07/2021> <Jose Gabriel Cordero Soto> <Se ajusta para que ordenamiento de FECHACREACION sea descendente>
-- Modificación:			<30/07/2021> <Aida Elena Siles R> <Se confirma cambio perdido realizado el 25/11/2020.>
-- Modificación:			<06/08/2021> <Ronny Ramírez R.> <Se agrega FechaEntrada para Expedientes y Legajos>
-- Modificación:			<26/01/2023> <Josu‚ Quirós Batista> <Se agrega la instrucción WITH(NOLOCK) en las subConsultas faltantes.>
-- Modificación:			<28/02/2023> <Ronny Ramírez R.> <Se elimina filtro por TC_CodContexto del JOIN entre Recurso y Solicitud contra Expediente, pues hay veces que el
--							Recurso/Solicitud se genera desde un Legajo que no estÿ en el mismo contexto que el Expediente>
-- Modificación:			<23/05/2023> <Luis Alonso Leiva Tames> <Se modifica para tomar en cuenta en expediente y legajos que dieron error>
-- Modificación:			<23/06/2023> <Ronny Ramírez R.> <PBI: 325393 - Se aplica filtrado adicional Top 1 en la subconsulta de Resultado de Recurso, 
--							para que no traiga registros duplicados al consultar el contexto>
-- ===============================================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonItineracionesEnviar]
	@NumeroPagina		SMALLINT,
	@CantidadRegistros	SMALLINT,
	@OficinaDestino		Varchar(4)		= NULL,
	@ContextoOrigen		Varchar(4)		= NULL,
	@Numeroexpediente	char(14)		= NULL,
	@FechaInicio		DATETIME2(3)	= NULL,
	@FechaFinal			DATETIME2(3)	= NULL,
	@EstadoPendEnv      SMALLINT,
	@EstadoErrorEnv     SMALLINT
AS 

BEGIN
			DECLARE	
			@L_NumeroExpediente					CHAR(14)		= @NumeroExpediente,
			@L_FechaInicio						DATETIME2(3)	= @FechaInicio,
			@L_FechaFinal						DATETIME2(3)	= @FechaFinal,
			@L_TotalRegistros					SMALLINT		= 0,
			@L_ContextoOrigen					VARCHAR(4)		= @ContextoOrigen,
			@L_NumeroPagina						INT				= IIF((@NumeroPagina IS NULL OR @NumeroPagina <= 0), 1, @NumeroPagina),
			@L_CantidadRegistros				INT				= IIF((@CantidadRegistros IS NULL OR @CantidadRegistros <= 0), 50, @CantidadRegistros),
			@L_EstadoPendEnv					SMALLINT		= @EstadoPendEnv,
			@L_EstadoErrorEnv					SMALLINT		= @EstadoErrorEnv,
			@L_OficinaDestino					VARCHAR(4)		= @OficinaDestino,
			@L_CodigoTipoItineracionExpediente	INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionExpediente'																		
																	),
			@L_CodigoEstadoPendItineracion		INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_EstadoPendItineracion'
																	),
			@L_CodigoTipoItineracionLegajo      INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionLegajo'																		
																	),
			@L_CodigoTipoItineracionRecurso		INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionRecurso'																		
																	),
			@L_CodigoTipoItineracionSolicitud	INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionSolicitud'
																	),
			@L_CodigoTipoItineracionResultadoSolicitud	INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionResultadoS'
																	),
			@L_CodigoTipoItineracionResultadoRecurso	INT				=	(
																		SELECT		A.TC_Valor
																		FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																		WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionResultadoR'
																	)
	DECLARE @Result TABLE	(
								FechaCreacion					DATETIME2(3)		NOT NULL,
								Acumulado						BIT					NOT NULL	DEFAULT 0,
								MensajeError					VARCHAR(255)		NULL,
								HistoricoItineracionExp         UNIQUEIDENTIFIER	NULL,
								HistoricoItineracionLeg         UNIQUEIDENTIFIER	NULL,
								HistoricoItineracionRec         UNIQUEIDENTIFIER	NULL,
								HistoricoItineracionSol         UNIQUEIDENTIFIER	NULL,
								HistoricoItineracionResultRec   UNIQUEIDENTIFIER	NULL,
								HistoricoItineracionResultSol   UNIQUEIDENTIFIER	NULL,	                            
								CodigoEntradaSalida				UNIQUEIDENTIFIER	NULL,
								TipoItineracionDescripcion		VARCHAR(255)		NULL,
								CodigoMotivoItineracion			SMALLINT            NULL,
								DescripcionMotivoItineracion	VARCHAR(255)		NULL,
								CodigoOficina					VARCHAR(4)          NULL,
								DescripcionOficina				VARCHAR(255)		NULL,          
								CodigoContextoDestino			VARCHAR(4)          NULL,
								ContextoDestinoUtilizaSiagpj	BIT					NOT NULL DEFAULT 0,
								CodigoEstadoItineracion			SMALLINT			NOT NULL,
								CodigoTipoItineracion			SMALLINT			NOT NULL,
								DescripcionEstadoItineracion	VARCHAR(255)		NULL,
	                            Numero							CHAR(14)			NOT NULL,
								DescripcionExpediente			VARCHAR(255)		NULL,
								CodigoContextoExpediente		VARCHAR(4)          NULL,
								CodigoClase						INT                 NULL,
								DescripcionClase				VARCHAR(200)		NULL,
                                CodigoProceso					SMALLINT            NULL,
                                DescripcionProceso				VARCHAR(100)		NULL,
								CodigoAsunto                    INT                 NULL,
                                DescripcionAsunto               VARCHAR(200)		NULL,
                                CodigoClaseAsunto               INT		            NULL,
                                DescripcionClaseAsunto          VARCHAR(200)		NULL,
								CodigoLegajo					UNIQUEIDENTIFIER	NULL,
								CodigoContextoLegajo			VARCHAR(4)          NULL,
								DescripcionLegajo				VARCHAR(255)		NULL,
	                            CodigoRecurso					UNIQUEIDENTIFIER	NULL,
								CodigoClaseAsuntoRecurso        INT		            NULL,
                                DescripcionClaseAsuntoRecurso   VARCHAR(255)		NULL,
								CodigoResolicion				UNIQUEIDENTIFIER	NULL,
								NumeroResolucion                CHAR(14)            NULL,
								TipoResolucionRecurso           VARCHAR(255)		NULL,
                                TipoResultadoRecurso            VARCHAR(255)		NULL,
                                FechaResolucion					DATETIME2(7)		NULL,
								CodigoArchivoResolucion			UNIQUEIDENTIFIER	NULL,
	                            CodigoSolicitud					UNIQUEIDENTIFIER	NULL,
								CodigoClaseAsuntoSolicitud      INT		            NULL,
								DescripcionClaseAsuntoSolicitud VARCHAR(255)		NULL,--ESTE CAMPO NO TIENE SENTIDO, SE REPITE VARIAS VECES, ES EL MISMO QUE CodigoClaseAsunto Y DescripcionClaseAsuntoRecurso
								DescripcionSolicitud            VARCHAR(255)		NULL,
								CodigoArchivoSolicitud			UNIQUEIDENTIFIER	NULL,
								DescripcionDocumento            VARCHAR(255)		NULL,
								NombreUsuario					VARCHAR(50)         NULL,
                                PrimerApellido					VARCHAR(50)         NULL,
                                SegundoApellido					VARCHAR(50)         NULL,
                                FechaDocumento					DATETIME2(3)		NULL,
								UsuarioRed						VARCHAR(30)         NULL,
								CodigoResultadoRecurso			UNIQUEIDENTIFIER	NULL,
								CodigoResultadoSolicitud		UNIQUEIDENTIFIER	NULL,
								CodResultadoLegajo				SMALLINT            NULL,
								DescripcionResultadoLegajo		VARCHAR(255)		NULL,
								CodigoLegajoResultadoRecurso	UNIQUEIDENTIFIER	NULL,
								CodigoLegajoResultadoSolicitud	UNIQUEIDENTIFIER	NULL,
								CodigoRecursoResultadoLegajo	UNIQUEIDENTIFIER    NULL,
								CodigoSolicitudResultadoLegajo	UNIQUEIDENTIFIER	NULL,
								FechaEntrada					DATETIME2(3)		NULL
							)
	--Expedientes.
	INSERT INTO	@Result	(
							CodigoEntradaSalida,
							FechaCreacion,                                                
							Numero,
							CodigoContextoExpediente,
							DescripcionExpediente,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							MensajeError,
							CodigoClase,
							CodigoProceso,
							HistoricoItineracionExp,
							FechaEntrada
						)
	SELECT				A.TU_CodExpedienteEntradaSalida			CodigoItineracion,
						A.TF_CreacionItineracion				FechaCreacion,
						B.TC_NumeroExpediente					Numero,
						D.TC_CodContexto						CodigoContextoExpediente,
						B.TC_Descripcion						DescripcionExpediente,						
						@L_CodigoTipoItineracionExpediente		CodigoTipoItineracion,
						IIF(A.TU_CodHistoricoItineracion IS NULL, @L_CodigoEstadoPendItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
						A.TN_CodMotivoItineracion				CodigoMotivoItineracion,
						A.TC_CodContextoDestino					CodigoContextoDestino,
						C.TC_MensajeError						MensajeError,
						D.TN_CodClase							CodigoClase,
						D.TN_CodProceso							CodigoProceso,
						C.TU_CodHistoricoItineracion			HistoricoItineracionExp,
						A.TF_Entrada							FechaEntrada
	FROM				Historico.ExpedienteEntradaSalida		A WITH(NOLOCK)
	INNER JOIN			Expediente.Expediente					B WITH(NOLOCK)
	ON					B.TC_NumeroExpediente					= A.TC_NumeroExpediente
	AND					B.TC_CodContexto						= A.TC_CodContexto
	LEFT JOIN			Historico.Itineracion					C WITH(NOLOCK)
	ON					C.TC_NumeroExpediente					= A.TC_NumeroExpediente
	AND					C.TC_CodContextoOrigen					= A.TC_CodContexto
	AND					C.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	INNER JOIN			Expediente.ExpedienteDetalle			D WITH(NOLOCK)
	ON					D.TC_NumeroExpediente					= A.TC_NumeroExpediente
	AND					D.TC_CodContexto						= A.TC_CodContexto
	WHERE				A.TC_CodContexto						= @ContextoOrigen
	AND					A.TC_CodContextoDestino					IS NOT NULL
	AND					(A.TF_Salida							IS NULL OR C.TN_CodEstadoItineracion = @L_EstadoErrorEnv)
	AND					A.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,A.TC_NumeroExpediente)
	AND					A.TF_CreacionItineracion				>= COALESCE (@L_FechaInicio,A.TF_CreacionItineracion)	
	AND					A.TF_CreacionItineracion				<= COALESCE (@L_FechaFinal,A.TF_CreacionItineracion)
	UNION --- VALIDANDO LAS QUE MOSTRARON ERROR
	SELECT				A.TU_CodExpedienteEntradaSalida			CodigoItineracion,
						A.TF_CreacionItineracion				FechaCreacion,
						C.TC_NumeroExpediente					Numero,
						D.TC_CodContexto						CodigoContextoExpediente,
						B.TC_Descripcion						DescripcionExpediente,						
						@L_CodigoTipoItineracionExpediente		CodigoTipoItineracion,
						IIF(A.TU_CodHistoricoItineracion IS NULL, @L_CodigoEstadoPendItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
						A.TN_CodMotivoItineracion				CodigoMotivoItineracion,
						A.TC_CodContextoDestino					CodigoContextoDestino,
						C.TC_MensajeError						MensajeError,
						D.TN_CodClase							CodigoClase,
						D.TN_CodProceso							CodigoProceso,
						C.TU_CodHistoricoItineracion			HistoricoItineracionExp,
						A.TF_Entrada							FechaEntrada
	FROM				Historico.ExpedienteEntradaSalida		A WITH(NOLOCK)
	INNER JOIN			Historico.Itineracion					C WITH(NOLOCK)
	ON					C.TC_NumeroExpediente					= A.TC_NumeroExpediente
	AND					C.TC_CodContextoOrigen					= A.TC_CodContexto
	AND					C.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	INNER JOIN Expediente.Expediente					B WITH(NOLOCK)
	ON					B.TC_NumeroExpediente					= C.TC_NumeroExpediente
	INNER JOIN			Expediente.ExpedienteDetalle			D WITH(NOLOCK)
	ON					D.TC_NumeroExpediente					= A.TC_NumeroExpediente
	AND					D.TC_CodContexto						= A.TC_CodContexto
	WHERE				A.TC_CodContexto						= @ContextoOrigen
	AND					A.TC_CodContextoDestino					IS NOT NULL
	AND					(A.TF_Salida							IS NULL OR C.TN_CodEstadoItineracion = @L_EstadoErrorEnv)
	AND					A.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,A.TC_NumeroExpediente)
	AND					A.TF_CreacionItineracion				>= COALESCE (@L_FechaInicio,A.TF_CreacionItineracion)	
	AND					A.TF_CreacionItineracion				<= COALESCE (@L_FechaFinal,A.TF_CreacionItineracion)
	AND					C.TC_CodContextoOrigen					=  COALESCE (@L_ContextoOrigen,C.TC_CodContextoOrigen)
	AND					C.TN_CodEstadoItineracion = 7

	--Legajos.
	INSERT INTO	@Result	(
							CodigoEntradaSalida,
							FechaCreacion,
							Numero,
							CodigoLegajo,
							DescripcionLegajo,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							CodigoContextoLegajo,
							MensajeError,
							CodigoAsunto,
							CodigoClaseAsunto,
							HistoricoItineracionLeg,
							FechaEntrada
						)
	SELECT				A.TU_CodLegajoEntradaSalida				CodigoItineracion,
						A.TF_CreacionItineracion				FechaCreacion,
						B.TC_NumeroExpediente					Numero,
						A.TU_CodLegajo							CodigoLegajo,
						B.TC_Descripcion						DescripcionLegajo,
						@L_CodigoTipoItineracionLegajo			CodigoTipoItineracion,
						IIF(A.TU_CodHistoricoItineracion IS NULL, @L_CodigoEstadoPendItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
						A.TN_CodMotivoItineracion				CodigoMotivoItineracion,
						A.TC_CodContextoDestino					CodigoContextoDestino,
						B.TC_CodContexto						CodigoContextoLegajo,
						C.TC_MensajeError						MensajeError,
						D.TN_CodAsunto							CodigoAsunto,
						D.TN_CodClaseAsunto						CodigoClaseAsunto,
						C.TU_CodHistoricoItineracion			HistoricoItineracionLeg,
						A.TF_Entrada							FechaEntrada
	FROM				Historico.LegajoEntradaSalida			A WITH(NOLOCK)
	INNER JOIN			Expediente.Legajo						B WITH(NOLOCK)
	ON					B.TU_CodLegajo							= A.TU_CodLegajo
	AND					B.TC_CodContexto						= A.TC_CodContexto
	LEFT JOIN			Historico.Itineracion					C WITH(NOLOCK)
	ON					C.TC_NumeroExpediente					= B.TC_NumeroExpediente
	AND					C.TC_CodContextoOrigen					= A.TC_CodContexto
	AND					C.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	INNER JOIN			Expediente.LegajoDetalle				D WITH(NOLOCK)
	ON					D.TU_CodLegajo							= A.TU_CodLegajo
	AND					D.TC_CodContexto						= A.TC_CodContexto
	WHERE				A.TC_CodContexto						= @L_ContextoOrigen
	AND					A.TC_CodContextoDestino					IS NOT NULL
	AND					(A.TF_Salida							IS NULL OR C.TN_CodEstadoItineracion = @L_EstadoErrorEnv)
	AND					B.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND					A.TF_CreacionItineracion				>= COALESCE (@L_FechaInicio,A.TF_CreacionItineracion)	
	AND					A.TF_CreacionItineracion				<= COALESCE (@L_FechaFinal,A.TF_CreacionItineracion)
	UNION 
	SELECT				A.TU_CodLegajoEntradaSalida				CodigoItineracion,
						A.TF_CreacionItineracion				FechaCreacion,
						B.TC_NumeroExpediente					Numero,
						A.TU_CodLegajo							CodigoLegajo,
						B.TC_Descripcion						DescripcionLegajo,
						@L_CodigoTipoItineracionLegajo			CodigoTipoItineracion,
						IIF(A.TU_CodHistoricoItineracion IS NULL, @L_CodigoEstadoPendItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
						A.TN_CodMotivoItineracion				CodigoMotivoItineracion,
						A.TC_CodContextoDestino					CodigoContextoDestino,
						B.TC_CodContexto						CodigoContextoLegajo,
						C.TC_MensajeError						MensajeError,
						D.TN_CodAsunto							CodigoAsunto,
						D.TN_CodClaseAsunto						CodigoClaseAsunto,
						C.TU_CodHistoricoItineracion			HistoricoItineracionLeg,
						A.TF_Entrada							FechaEntrada
	FROM				Historico.LegajoEntradaSalida			A WITH(NOLOCK)
	INNER JOIN			Expediente.Legajo						B WITH(NOLOCK)
	ON					B.TU_CodLegajo							= A.TU_CodLegajo
	INNER JOIN			Historico.Itineracion					C WITH(NOLOCK)
	ON					C.TC_NumeroExpediente					= B.TC_NumeroExpediente
	AND					C.TC_CodContextoOrigen					= A.TC_CodContexto
	AND					C.TU_CodHistoricoItineracion			= A.TU_CodHistoricoItineracion
	INNER JOIN			Expediente.LegajoDetalle				D WITH(NOLOCK)
	ON					D.TU_CodLegajo							= A.TU_CodLegajo
	AND					D.TC_CodContexto						= A.TC_CodContexto
	WHERE				A.TC_CodContexto						= @L_ContextoOrigen
	AND					A.TC_CodContextoDestino					IS NOT NULL
	AND					(A.TF_Salida							IS NULL OR C.TN_CodEstadoItineracion = @L_EstadoErrorEnv)
	AND					C.TC_NumeroExpediente					=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND					A.TF_CreacionItineracion				>= COALESCE (@L_FechaInicio,A.TF_CreacionItineracion)	
	AND					A.TF_CreacionItineracion				<= COALESCE (@L_FechaFinal,A.TF_CreacionItineracion)
	AND					C.TC_CodContextoOrigen					=  COALESCE (@L_ContextoOrigen,C.TC_CodContextoOrigen)
	AND					C.TN_CodEstadoItineracion = 7


	--Recursos
	INSERT INTO	@Result	(
							FechaCreacion,                                                
							Numero,
							DescripcionExpediente,
							CodigoRecurso,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							MensajeError,
							CodigoClaseAsuntoRecurso,
							HistoricoItineracionRec,
							CodigoResolicion,
							NumeroResolucion
						)
	SELECT		A.TF_Fecha_Creacion								FechaCreacion,
				B.TC_NumeroExpediente							Numero,
				B.TC_Descripcion								DescripcionExpediente,
				A.TU_CodRecurso									CodigoRecurso,
				@L_CodigoTipoItineracionRecurso					CodigoTipoItineracion,
				IIF(A.TU_CodHistoricoItineracion IS NULL, A.TN_CodEstadoItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,
				A.TC_CodContextoDestino							CodigoContextoDestino,
				C.TC_MensajeError								MensajeError,
				A.TN_CodClaseAsunto								CodigoClaseAsuntoRecurso,
				C.TU_CodHistoricoItineracion					HistoricoItineracionRec,
				A.TU_CodResolucion								CodigoResolicion,
				D.TC_NumeroResolucion							NumeroResolucion
	FROM		Expediente.RecursoExpediente					A WITH(NOLOCK)
	INNER JOIN	Expediente.Expediente							B WITH(NOLOCK)
	ON			B.TC_NumeroExpediente							= A.TC_NumeroExpediente	
	LEFT JOIN	Historico.Itineracion							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= A.TC_NumeroExpediente
	AND			C.TC_CodContextoOrigen							= A.TC_CodContextoOrigen
	AND			C.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	LEFT JOIN	Expediente.LibroSentencia						D WITH(NOLOCK)
	ON			D.TU_CodResolucion								= A.TU_CodResolucion
	WHERE		A.TC_CodContextoDestino							IS NOT NULL
	AND			A.TC_CodContextoOrigen							= @L_ContextoOrigen
	AND			(
					A.TN_CodEstadoItineracion					= @L_EstadoPendEnv
				OR 
					C.TN_CodEstadoItineracion					= @L_EstadoErrorEnv
				)
	AND			A.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,A.TC_NumeroExpediente)
	AND			A.TF_Fecha_Creacion								>= COALESCE (@L_FechaInicio,A.TF_Fecha_Creacion)	
	AND			A.TF_Fecha_Creacion								<= COALESCE (@L_FechaFinal,A.TF_Fecha_Creacion)
	--Solicitudes
	INSERT INTO	@Result	(
							FechaCreacion,                                                
							Numero,
							DescripcionExpediente,
							CodigoSolicitud,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							MensajeError,
							CodigoClaseAsuntoSolicitud,
							DescripcionSolicitud,
							HistoricoItineracionSol,
							CodigoArchivoSolicitud,
							DescripcionDocumento,
							UsuarioRed,
							FechaDocumento
						)
	SELECT		A.TF_FechaCreacion								FechaCreacion,
				B.TC_NumeroExpediente							Numero,
				B.TC_Descripcion								DescripcionExpediente,
				A.TU_CodSolicitudExpediente						CodigoSolicitud,
				@L_CodigoTipoItineracionSolicitud				CodigoTipoItineracion,
				IIF(A.TU_CodHistoricoItineracion IS NULL, A.TN_CodEstadoItineracion, C.TN_CodEstadoItineracion) CodigoEstadoItineracion,
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,
				A.TC_CodContextoDestino							CodigoContextoDestino,
				C.TC_MensajeError								MensajeError,
				A.TN_CodClaseAsunto								CodigoClaseAsuntoSolicitud,
				A.TC_Descripcion								DescripcionSolicitud,
				C.TU_CodHistoricoItineracion					HistoricoItineracionSol,
				A.TU_CodArchivo									CodigoArchivoSolicitud,
				D.TC_Descripcion								DescripcionDocumento,
				D.TC_UsuarioCrea,
				D.TF_FechaCrea									FechaDocumento
	FROM		Expediente.SolicitudExpediente					A WITH(NOLOCK)
	INNER JOIN	Expediente.Expediente							B WITH(NOLOCK)
	ON			B.TC_NumeroExpediente							= A.TC_NumeroExpediente	
	LEFT JOIN	Historico.Itineracion							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= A.TC_NumeroExpediente
	AND			C.TC_CodContextoOrigen							= A.TC_CodContextoOrigen
	AND			C.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	LEFT JOIN	Archivo.Archivo									D WITH(NOLOCK)
	ON			D.TU_CodArchivo									= A.TU_CodArchivo
	WHERE		A.TC_CodContextoDestino							IS NOT NULL
	AND			A.TC_CodContextoOrigen							= @L_ContextoOrigen
	AND			(
					A.TN_CodEstadoItineracion					= @L_EstadoPendEnv
				OR 
					C.TN_CodEstadoItineracion					= @L_EstadoErrorEnv
				)
	AND			A.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,A.TC_NumeroExpediente)
	AND			A.TF_FechaCreacion								>= COALESCE (@L_FechaInicio,A.TF_FechaCreacion)	
	AND			A.TF_FechaCreacion								<= COALESCE (@L_FechaFinal,A.TF_FechaCreacion)
	
	--Resultado Recursos
	INSERT INTO	@Result	(
							FechaCreacion,                                                
							Numero,
							DescripcionExpediente,
							CodigoResultadoRecurso,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							MensajeError,
							HistoricoItineracionResultRec,
							CodResultadoLegajo,
							CodigoLegajoResultadoRecurso,
							CodigoRecursoResultadoLegajo,
							HistoricoItineracionRec,
							UsuarioRed
						)
	SELECT		A.TF_FechaCreacion								FechaCreacion,
				B.TC_NumeroExpediente							Numero,
				C.TC_Descripcion								DescripcionExpediente,
				A.TU_CodResultadoRecurso						CodigoResultadoRecurso,
				@L_CodigoTipoItineracionResultadoRecurso		CodigoTipoItineracion,
				IIF(A.TU_CodHistoricoItineracion IS NULL, A.TN_CodEstadoItineracion, D.TN_CodEstadoItineracion)	CodigoEstadoItineracion,
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,
				E.TC_CodContextoProcedencia						CodigoContextoDestino,
				D.TC_MensajeError								MensajeError,
				A.TU_CodHistoricoItineracion					HistoricoItineracionResultRec,
				F.TN_CodResultadoLegajo							CodResultadoLegajo,
				A.TU_CodLegajo									CodigoLegajoResultadoRecurso,
				G.TU_CodRecurso									CodigoRecursoResultadoLegajo,
				G.TU_CodItineracionRecurso						HistoricoItineracionRec,
				A.TC_UsuarioRed
	FROM		Expediente.ResultadoRecurso						A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo								B WITH(NOLOCK)
	ON			B.TU_CodLegajo									= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= B.TC_NumeroExpediente
	LEFT JOIN	Historico.Itineracion							D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle						E WITH(NOLOCK)
	ON			E.TU_CodLegajo									= B.TU_CodLegajo
	INNER JOIN	Catalogo.ResultadoLegajo						F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo							= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionRecursoResultado			G WITH(NOLOCK)
	ON			A.TU_CodLegajo									= G.TU_CodLegajo
	WHERE		E.TC_CodContextoProcedencia						IS NOT NULL
	AND			A.TC_CodContextoOrigen							= (SELECT TOP 1	K.TC_CodContextoOrigen 
													               FROM			Historico.ItineracionRecursoResultado J WITH(NOLOCK)
																   INNER JOIN	Historico.Itineracion				  K WITH(NOLOCK)			
																   ON			J.TU_CodItineracionRecurso			  = K.TU_CodHistoricoItineracion
																   WHERE		J.TU_CodLegajo						  = A.TU_CodLegajo
																   AND			K.TC_CodContextoDestino				  = @L_ContextoOrigen)
	AND			(
					A.TN_CodEstadoItineracion					= @L_EstadoPendEnv
				OR 
					D.TN_CodEstadoItineracion					= @L_EstadoErrorEnv
				)
	AND			B.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaCreacion								>= COALESCE (@L_FechaInicio,A.TF_FechaCreacion)	
	AND			A.TF_FechaCreacion								<= COALESCE (@L_FechaFinal,A.TF_FechaCreacion)
	AND			A.TU_CodLegajo									=  (SELECT TOP 1	L.TU_CodLegajo
																	FROM			Expediente.Legajo L WITH(NOLOCK)
																	WHERE			TC_CodContexto = COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
																	AND				L.TU_CodLegajo = A.TU_CodLegajo)
	
	--Resultado Solicitudes
	INSERT INTO	@Result	(
							FechaCreacion,                                                
							Numero,
							DescripcionExpediente,
							CodigoResultadoSolicitud,
							CodigoTipoItineracion,
							CodigoEstadoItineracion,
							CodigoMotivoItineracion,
							CodigoContextoDestino,
							MensajeError,
							HistoricoItineracionResultSol,
							CodResultadoLegajo,
							CodigoLegajoResultadoSolicitud,
							CodigoSolicitudResultadoLegajo,
							HistoricoItineracionSol,
							UsuarioRed
						)
	SELECT		A.TF_FechaCreacion								FechaCreacion,
				B.TC_NumeroExpediente							Numero,
				C.TC_Descripcion								DescripcionExpediente,
				A.TU_CodResultadoSolicitud						CodigoResultadoSolicitud,
				@L_CodigoTipoItineracionResultadoSolicitud		CodigoTipoItineracion,
				IIF(A.TU_CodHistoricoItineracion IS NULL, A.TN_CodEstadoItineracion, D.TN_CodEstadoItineracion) CodigoEstadoItineracion,
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,
				E.TC_CodContextoProcedencia						CodigoContextoDestino,
				D.TC_MensajeError								MensajeError,
				A.TU_CodHistoricoItineracion					HistoricoItineracionResultSol,
				F.TN_CodResultadoLegajo							CodResultadoLegajo,
				A.TU_CodLegajo									CodigoLegajoResultadoSolicitud,
				G.TU_CodSolicitud								CodigoSolicitudResultadoLegajo,
				G.TU_CodItineracionSolicitud					HistoricoItineracionSol,
				A.TC_UsuarioRed
	FROM		Expediente.ResultadoSolicitud					A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo								B WITH(NOLOCK)
	ON			B.TU_CodLegajo									= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= B.TC_NumeroExpediente
	LEFT JOIN	Historico.Itineracion							D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle						E WITH(NOLOCK)
	ON			E.TU_CodLegajo									= B.TU_CodLegajo
	INNER JOIN	Catalogo.ResultadoLegajo						F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo							= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionSolicitudResultado			G WITH(NOLOCK)
	ON			A.TU_CodLegajo									= G.TU_CodLegajo
	WHERE		E.TC_CodContextoProcedencia						IS NOT NULL
	AND			A.TC_CodContextoOrigen							= (SELECT		K.TC_CodContextoOrigen 
													               FROM			Historico.ItineracionSolicitudResultado J WITH(NOLOCK)
																   INNER JOIN Historico.Itineracion						K WITH(NOLOCK)
																   ON			J.TU_CodItineracionSolicitud			= K.TU_CodHistoricoItineracion
																   WHERE		J.TU_CodLegajo							= A.TU_CodLegajo
																   AND			K.TC_CodContextoDestino					= @L_ContextoOrigen)
	AND			(
					A.TN_CodEstadoItineracion					= @L_EstadoPendEnv
				OR 
					D.TN_CodEstadoItineracion					= @L_EstadoErrorEnv
				)
	AND			B.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaCreacion								>= COALESCE (@L_FechaInicio,A.TF_FechaCreacion)	
	AND			A.TF_FechaCreacion								<= COALESCE (@L_FechaFinal,A.TF_FechaCreacion)
	AND			A.TU_CodLegajo									=  (SELECT TOP 1	L.TU_CodLegajo
																	FROM			Expediente.Legajo	L WITH(NOLOCK)
																	WHERE			TC_CodContexto		= COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
																	AND				L.TU_CodLegajo		= A.TU_CodLegajo)

	--Actualiza la oficina destino	
	UPDATE		A
	SET			A.CodigoOficina					= B.TC_CodOficina,
				A.DescripcionOficina			= B.TC_Descripcion,
				A.ContextoDestinoUtilizaSiagpj	= B.TB_UtilizaSiagpj
	FROM		@Result							A
	INNER JOIN	Catalogo.Contexto 				B WITH(NOLOCK)
	ON			B.TC_CodContexto 				= A.CodigoContextoDestino
	INNER JOIN	Catalogo.Oficina				C WITH(NOLOCK)
	ON			C.TC_CodOficina					= B.TC_CodOficina

	--Aplica filtro de oficina destino en especðfico.
	IF	@L_OficinaDestino IS NOT NULL
	BEGIN
		DELETE
		FROM	@Result
		WHERE	CodigoOficina	<> @L_OficinaDestino
	END
	--Actualización de acumulados.
	UPDATE		A
	SET			A.Acumulado						= 1
	FROM		@Result							A
	INNER JOIN	Historico.ExpedienteAcumulacion	D WITH(NOLOCK)
	ON			D.TC_NumeroExpedienteAcumula	= A.Numero
	AND			D.TF_InicioAcumulacion			IS NOT NULL
	AND			D.TF_FinAcumulacion				IS NULL
	WHERE		A.CodigoTipoItineracion			= @L_CodigoTipoItineracionExpediente
	--Actualiza todas las descripciones de el tipo de itineración.
	UPDATE		A
	SET			A.TipoItineracionDescripcion	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.TipoItineracion		B WITH(NOLOCK)
	ON			B.TN_CodTipoItineracion			= A.CodigoTipoItineracion
	--Actualiza las descripciones de estado de itineración.
	UPDATE		A
	SET			A.DescripcionEstadoItineracion	= ISNULL(B.TC_Descripcion, 'Pendiente de enviar')
	FROM		@Result							A
	INNER JOIN	Catalogo.EstadoItineracion		B WITH(NOLOCK)
	ON			B.TN_CodEstadoItineracion		= A.CodigoEstadoItineracion
	--Actualiza el motivo de la itineración.
	UPDATE		A
	SET			A.DescripcionMotivoItineracion	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.MotivoItineracion 		B WITH(NOLOCK)
	ON			B.TN_CodMotivoItineracion 		= A.CodigoMotivoItineracion
	--Actualización de descripción de clase
	UPDATE		A
	SET			A.DescripcionClase	= B.TC_Descripcion
	FROM		@Result				A
	INNER JOIN	Catalogo.Clase		B
	ON			B.TN_CodClase		= A.CodigoClase
	--Actualización de descripción de proceso
	UPDATE		A
	SET			A.DescripcionProceso	= B.TC_Descripcion
	FROM		@Result					A
	INNER JOIN	Catalogo.Proceso		B
	ON			B.TN_CodProceso			= A.CodigoProceso
	--
	--Actualización de descripción de asunto
	UPDATE		A
	SET			A.DescripcionAsunto	= B.TC_Descripcion
	FROM		@Result				A
	INNER JOIN	Catalogo.Asunto		B
	ON			B.TN_CodAsunto		= A.CodigoAsunto
	--Actualización de descripción de clases de asunto
	UPDATE		A
	SET			A.DescripcionClaseAsunto	= B.TC_Descripcion
	FROM		@Result						A
	INNER JOIN	Catalogo.ClaseAsunto		B
	ON			B.TN_CodClaseAsunto			= A.CodigoClaseAsunto
	--Actualización de descripción de clases de asunto
	UPDATE		A
	SET			A.DescripcionClaseAsuntoSolicitud	= B.TC_Descripcion
	FROM		@Result								A
	INNER JOIN	Catalogo.ClaseAsunto				B
	ON			B.TN_CodClaseAsunto					= A.CodigoClaseAsuntoSolicitud
	--Actualización de descripción de clases de asunto para los recursos
	UPDATE		A
	SET			A.DescripcionClaseAsuntoRecurso	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.ClaseAsunto			B
	ON			B.TN_CodClaseAsunto				= A.CodigoClaseAsuntoRecurso
	--Completa los datos de los recursos
	UPDATE		A
	SET			TipoResolucionRecurso	= C.TC_Descripcion,
				TipoResultadoRecurso	= D.TC_Descripcion,
				UsuarioRed				= E.TC_UsuarioRed,
				FechaResolucion			= B.TF_FechaResolucion,
				CodigoArchivoResolucion	= B.TU_CodArchivo
	FROM		@Result	A
	INNER JOIN	Expediente.Resolucion				B WITH(NOLOCK)
	ON			B.TU_CodResolucion					= A.CodigoResolicion
	INNER JOIN	Catalogo.TipoResolucion				C WITH(NOLOCK)
	ON			C.TN_CodTipoResolucion				= B.TN_CodTipoResolucion
	INNER JOIN	Catalogo.ResultadoResolucion		D WITH(NOLOCK)
	ON			D.TN_CodResultadoResolucion			= B.TN_CodResultadoResolucion
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario	E WITH(NOLOCK)
	ON			E.TU_CodPuestoFuncionario			= B.TU_RedactorResponsable
	--Completa los datos de las personas
	UPDATE		A
	SET			Nombreusuario			= REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.TC_Nombre)), CHAR(9), ''), CHAR(10),''), CHAR(13), ''),
				PrimerApellido			= REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(B.TC_PrimerApellido)), CHAR(9), ''), CHAR(10),''), CHAR(13), ''),
				SegundoApellido			= REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(ISNULL(B.TC_SegundoApellido, ''))), CHAR(9), ''), CHAR(10),''), CHAR(13), '')
	FROM		@Result					A
	INNER JOIN	Catalogo.Funcionario	B WITH(NOLOCK)
	ON			B.TC_UsuarioRed			= A.UsuarioRed
	
	--Actualización de descripción de ResultadoLegajo
	UPDATE		A
	SET			A.DescripcionResultadoLegajo	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.ResultadoLegajo		B  WITH(NOLOCK)
	ON			B.TN_CodResultadoLegajo			= A.CodResultadoLegajo

	--
	SELECT	@L_TotalRegistros = COUNT(*)
	FROM	@Result
	--
	SELECT		@L_TotalRegistros TotalRegistros,	FechaCreacion,						Acumulado,							MensajeError,
				'SplitDatos' SplitDatos,			
				CodigoEntradaSalida,				HistoricoItineracionExp,			HistoricoItineracionLeg,			HistoricoItineracionRec,
				HistoricoItineracionSol,			HistoricoItineracionResultRec,		HistoricoItineracionResultSol,		CodigoTipoItineracion,			
				TipoItineracionDescripcion,			CodigoEstadoItineracion,			DescripcionEstadoItineracion,		CodigoMotivoItineracion,			
				DescripcionMotivoItineracion,		CodigoContextoDestino,				CodigoOficina,						DescripcionOficina,
				ContextoDestinoUtilizaSiagpj,		CodigoClase,						DescripcionClase,					CodigoProceso,					
				DescripcionProceso,					CodigoAsunto,						DescripcionAsunto,					CodigoClaseAsunto,					
				DescripcionClaseAsunto,				CodigoClaseAsuntoRecurso,			DescripcionClaseAsuntoRecurso,		CodigoClaseAsuntoSolicitud,			
				DescripcionClaseAsuntoSolicitud,	TipoResolucionRecurso,				TipoResultadoRecurso,				CodResultadoLegajo,					
				DescripcionResultadoLegajo,			Nombreusuario + ' ' + PrimerApellido + ' ' + SegundoApellido RedactorRecurso,								
				FechaResolucion,					NumeroResolucion,					CodigoArchivoResolucion,			Numero NumeroExpedienteRecurso,		
				CodigoArchivoSolicitud,				NombreUsuario,						PrimerApellido,						SegundoApellido,				
				FechaDocumento,						DescripcionDocumento,				CodigoLegajoResultadoRecurso,		CodigoLegajoResultadoSolicitud,		
				CodigoRecursoResultadoLegajo,		CodigoSolicitudResultadoLegajo,		CodigoContextoExpediente,			CodigoContextoLegajo,
				FechaEntrada,
				'SplitExpediente' SplitExpediente,	
				Numero,								DescripcionExpediente Descripcion,	
				'SplitLegajo' SplitLegajo,			
				CodigoLegajo  Codigo,				DescripcionLegajo Descripcion,
				'SplitRecurso' SplitRecurso,		
				CodigoRecurso Codigo,				
				'SplitSolicitud' SplitSolicitud,	
				CodigoSolicitud Codigo,				DescripcionSolicitud Descripcion,	
				'SplitResultadoSolicitud' SplitResultadoSolicitud,	
				CodigoResultadoSolicitud Codigo,
				'SplitResultadoRecurso' SplitResultadoRecurso,	
				CodigoResultadoRecurso Codigo
    FROM		@Result
	GROUP BY	FechaCreacion,						Acumulado,							MensajeError,						CodigoEntradaSalida,
				HistoricoItineracionExp,			HistoricoItineracionLeg,			HistoricoItineracionRec,			HistoricoItineracionSol,
				HistoricoItineracionResultRec,		HistoricoItineracionResultSol,		CodigoTipoItineracion,				TipoItineracionDescripcion,			
				CodigoEstadoItineracion,			DescripcionEstadoItineracion,		CodigoMotivoItineracion,			DescripcionMotivoItineracion,		
				CodigoContextoDestino,				CodigoOficina,						DescripcionOficina,					ContextoDestinoUtilizaSiagpj,
				CodigoClase,						DescripcionClase,					CodigoProceso,						DescripcionProceso,					
				CodigoAsunto,                 		DescripcionAsunto,					CodigoClaseAsunto,					DescripcionClaseAsunto,				
				CodigoClaseAsuntoRecurso,			DescripcionClaseAsuntoRecurso,		CodigoClaseAsuntoSolicitud,			DescripcionClaseAsuntoSolicitud,	
				TipoResolucionRecurso,				TipoResultadoRecurso,				CodResultadoLegajo,					DescripcionResultadoLegajo,		
				FechaResolucion,					NumeroResolucion,					CodigoArchivoResolucion,			CodigoArchivoSolicitud,				
				NombreUsuario,						PrimerApellido,						SegundoApellido,					FechaDocumento,						
				DescripcionDocumento, 				Numero,								DescripcionExpediente,				CodigoLegajo,						
				DescripcionLegajo,					CodigoRecurso,						CodigoSolicitud,					DescripcionSolicitud,				
				CodigoResultadoSolicitud,			CodigoResultadoRecurso,				CodigoLegajoResultadoRecurso,		CodigoLegajoResultadoSolicitud,	
				CodigoRecursoResultadoLegajo,		CodigoSolicitudResultadoLegajo,		CodigoContextoExpediente,			CodigoContextoLegajo,
				FechaEntrada
    ORDER By	FechaCreacion DESC
    OFFSET      (@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS
    FETCH NEXT  @L_CantidadRegistros ROWS ONLY
END
GO
