SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Aida Elena Siles Rojas>
-- Fecha de creación:		<26/11/2020>
-- Descripción :			<Permite consultar los registros para el buzón de itineraciones enviados>
-- =======================================================================================================================================================================================
-- Modificado por:			<03/12/2020><Henry M'ndez Ch><Se agrega en la consulta DescripcionMotivoRechazoItineracion y los datos del recurso>
-- Modificado por:			<09/12/2020><Aida Elena Siles R><Se quita de la consulta la validación del contexto contra la tabla Expediente.Expediente>
-- Modificado por:			<17/12/2020><Jose Gabriel Cordero Soto><Se agrega campos referentes al documento de la solicitud para ver detalle de la solicitud>
-- Modificación:			<27/01/2021> <Aida Elena Siles R> <Se modifica el tipo de dato del codigo clase asunto por INT ya que se cambio en la tabla catÿlogo>
-- Modificación:			<25/01/2021> <Aida Elena Siles R> <Ajuste en los tamaños de los campos nombre, apellido1 y apellido2>
-- Modificación:			<16/07/2021> <Jose Gabriel Cordero Soto> <Se ajusta ordenamiento de select final por FECHACREACION de forma DESCENDENTE>
-- Modificacion:			<21/05/2021> <Miguel Avendaño> <Se modifica para que liste correctamente el historico de envios de expediente, legajo, recurso,
--															solicitud cuando se han rechazado>
-- Modificado por:			<09/08/2021><Luis Alonso Leiva Tames><Se modifica para mostrar el redactor en el recurso>
-- Modificado por:			<31/08/2021><Ronny Ram­rez R.><Se aplican ajustes para agregar nuevos campos para mantener relación y datos con registros rechazados>
-- Modificación:			<10/03/2023> <Josué Quirós Batista> <Se agrega la instrucción WITH(NOLOCK) en las subConsultas faltantes.>
-- Modificación:			<31/07/2023> <Ronny Ramírez R.> <Se aplica optimización en la consulta para mejorar los tiempos de respuesta, con 50 registros tarda <= 1 segundo> 
-- Modificación:			<30/10/2023> <Josué Quirós Batista> <Se agrega la descripción del archivo asociado.>
-- =======================================================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonItineracionesEnviados]
	@NumeroPagina			SMALLINT,
	@CantidadRegistros		SMALLINT,
	@OficinaDestino			VARCHAR(4)		= NULL,
	@ContextoOrigen			VARCHAR(4)		= NULL,
	@NumeroExpediente		CHAR(14)		= NULL,
	@FechaInicio			DATETIME2(3)	= NULL,
	@FechaFinal				DATETIME2(3)	= NULL,
	@CodEstadoItineracion	SMALLINT		= NULL,
	@ListaEstados			EstadosBuzEnviadosType	READONLY
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
	@L_CodEstadoItineacion				SMALLINT		= @CodEstadoItineracion,
	@L_OficinaDestino					VARCHAR(4)		= @OficinaDestino,
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
	@L_CodigoTipoItineracionExpediente	INT				=	(
																SELECT		A.TC_Valor
																FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionExpediente'																		
															),
	@L_CodigoTipoItineracionLegajo		INT				=	(
																SELECT		A.TC_Valor
																FROM		Configuracion.ConfiguracionValor	A WITH(NOLOCK)
																WHERE		A.TC_CodConfiguracion				= 'C_TipoItineracionLegajo'
															)


	DECLARE @Result TABLE	(
								FechaCreacion						DATETIME2(3)		NOT NULL,
								FechaEnvio							DATETIME2(3)		NOT NULL,
								Acumulado							BIT					NOT NULL	DEFAULT 0,
								MensajeError						VARCHAR(255)		NULL,
								HistoricoItineracion				UNIQUEIDENTIFIER	NULL,
								CodigoEntradaSalida					UNIQUEIDENTIFIER	NULL,
								CodigoMotivoItineracion				SMALLINT            NULL,
								DescripcionMotivoItineracion		VARCHAR(255)		NULL,
								CodigoMotivoRechazo					SMALLINT            NULL,
								DescripcionMotivoRechazo			VARCHAR(255)		NULL,
								CodigoOficina						VARCHAR(4)          NULL,
								DescripcionOficina					VARCHAR(255)		NULL,     
								CodigoContextoDestino				VARCHAR(4)          NULL,
								CodigoEstadoItineracion				SMALLINT			NOT NULL,
								DescripcionEstadoItineracion		VARCHAR(255)		NULL,
								CodigoTipoItineracion				SMALLINT			NOT NULL,
								TipoItineracionDescripcion			VARCHAR(255)		NULL,
								Numero								CHAR(14)			NOT NULL,
								DescripcionExpediente				VARCHAR(255)		NULL,
								CodigoClase							INT                 NULL,
								DescripcionClase					VARCHAR(200)		NULL,
								CodigoProceso						SMALLINT            NULL,
								DescripcionProceso					VARCHAR(100)		NULL,
								CodigoAsunto						INT                 NULL,
								DescripcionAsunto					VARCHAR(200)		NULL,
								CodigoClaseAsunto					INT		            NULL,
								DescripcionClaseAsunto				VARCHAR(200)		NULL,
								CodigoLegajo						UNIQUEIDENTIFIER	NULL,
								DescripcionLegajo					VARCHAR(255)		NULL,
								CodigoRecurso						UNIQUEIDENTIFIER	NULL,
								TipoResultadoRecurso				VARCHAR(255)		NULL,
								CodigoSolicitud						UNIQUEIDENTIFIER	NULL,
								DescripcionSolicitud				VARCHAR(255)		NULL,
								CodigoArchivoSolicitud				UNIQUEIDENTIFIER	NULL,
								DescripcionArchivoSolicitud			VARCHAR(255)		NULL,
								NombreUsuarioDocumento				VARCHAR(50)         NULL,
								PrimerApellidoDocumento				VARCHAR(50)         NULL,
								SegundoApellidoDocumento			VARCHAR(50)         NULL,   
								FechaCreacionDocumento				DATETIME2(3)		NULL,
								UsuarioRedDocumento					VARCHAR(30)         NULL,
								NombreUsuario						VARCHAR(30)         NULL,
								PrimerApellido						VARCHAR(30)         NULL,
								SegundoApellido						VARCHAR(30)         NULL,                                
								UsuarioRed							VARCHAR(30)         NULL,
								CodigoResultadoRecurso				UNIQUEIDENTIFIER	NULL,
								CodigoResultadoSolicitud			UNIQUEIDENTIFIER	NULL,
								CodResultadoLegajo					SMALLINT            NULL,
								DescripcionResultadoLegajo			VARCHAR(255)		NULL,
								CodigoLegajoResultadoRecurso		UNIQUEIDENTIFIER	NULL,
								CodigoLegajoResultadoSolicitud		UNIQUEIDENTIFIER	NULL,
								CodigoRecursoResultadoLegajo		UNIQUEIDENTIFIER    NULL,
								CodigoSolicitudResultadoLegajo		UNIQUEIDENTIFIER	NULL,
								DescripcionMotivoRechazoItineracion	VARCHAR(255)		NULL,
								CodigoClaseAsuntoRecurso			INT		            NULL,
								DescripcionClaseAsuntoRecurso		VARCHAR(255)		NULL,
								TipoResolucionRecurso				VARCHAR(255)		NULL,
								FechaResolucion						DATETIME2(7)		NULL,
								CodigoArchivoResolucion				UNIQUEIDENTIFIER	NULL,
								CodigoResolicion					UNIQUEIDENTIFIER	NULL,
								NumeroResolucion					CHAR(14)            NULL
							)
	--EXPEDIENTES.
	INSERT INTO	@Result	(
							FechaCreacion,						
							FechaEnvio,							
							Acumulado,							
							MensajeError,						
							HistoricoItineracion,				
							CodigoEntradaSalida,					
							CodigoMotivoItineracion,				
							DescripcionMotivoItineracion,		
							CodigoMotivoRechazo,					
							DescripcionMotivoRechazo,			
							CodigoOficina,						
							DescripcionOficina,					
							CodigoContextoDestino,				
							CodigoEstadoItineracion,				
							DescripcionEstadoItineracion,		
							CodigoTipoItineracion,				
							TipoItineracionDescripcion,			
							Numero,								
							DescripcionExpediente,				
							CodigoClase,							
							DescripcionClase,					
							CodigoProceso,						
							DescripcionProceso,					
							CodigoAsunto,						
							DescripcionAsunto,					
							CodigoClaseAsunto,					
							DescripcionClaseAsunto,				
							CodigoLegajo,						
							DescripcionLegajo,					
							CodigoRecurso,						
							TipoResultadoRecurso,				
							CodigoSolicitud,						
							DescripcionSolicitud,				
							CodigoArchivoSolicitud,				
							DescripcionArchivoSolicitud,			
							NombreUsuarioDocumento,				
							PrimerApellidoDocumento,				
							SegundoApellidoDocumento,			
							FechaCreacionDocumento,				
							UsuarioRedDocumento,					
							NombreUsuario,						
							PrimerApellido,						
							SegundoApellido,						
							UsuarioRed,							
							CodigoResultadoRecurso,				
							CodigoResultadoSolicitud,			
							CodResultadoLegajo,					
							DescripcionResultadoLegajo,			
							CodigoLegajoResultadoRecurso,		
							CodigoLegajoResultadoSolicitud,		
							CodigoRecursoResultadoLegajo,		
							CodigoSolicitudResultadoLegajo,		
							DescripcionMotivoRechazoItineracion,	
							CodigoClaseAsuntoRecurso,			
							DescripcionClaseAsuntoRecurso,		
							TipoResolucionRecurso,				
							FechaResolucion,						
							CodigoArchivoResolucion,				
							CodigoResolicion,					
							NumeroResolucion
						)
	SELECT				A.TF_Entrada													FechaCreacion,
						ISNULL(C.TF_FechaEnvio, C.TF_FechaEstado)						FechaEnvio,
						0,																-- Acumulado
						C.TC_MensajeError												MensajeError,
						C.TU_CodHistoricoItineracion									HistoricoItineracion,
						A.TU_CodExpedienteEntradaSalida									CodigoEntradaSalida,
						ISNULL(C.TN_CodMotivoItineracion, A.TN_CodMotivoItineracion)	CodigoMotivoItineracion,
						NULL,															-- DescripcionMotivoItineracion
						C.TN_CodMotivoRechazoItineracion								CodigoMotivoRechazo,
						NULL,															-- DescripcionMotivoRechazo
						NULL,															-- CodigoOficina
						NULL,															-- DescripcionOficina
						C.TC_CodContextoDestino											CodigoContextoDestino,
						C.TN_CodEstadoItineracion										CodigoEstadoItineracion,
						NULL,															-- DescripcionEstadoItineracion
						C.TN_CodTipoItineracion											CodigoTipoItineracion,
						NULL,															-- TipoItineracionDescripcion
						B.TC_NumeroExpediente											Numero,
						B.TC_Descripcion												DescripcionExpediente,
						D.TN_CodClase													CodigoClase,
						NULL,															-- DescripcionClase
						D.TN_CodProceso													CodigoProceso,						
						NULL,															-- DescripcionProceso					
						NULL,															-- CodigoAsunto						
						NULL,															-- DescripcionAsunto					
						NULL,															-- CodigoClaseAsunto					
						NULL,															-- DescripcionClaseAsunto				
						NULL,															-- CodigoLegajo						
						NULL,															-- DescripcionLegajo					
						NULL,															-- CodigoRecurso						
						NULL,															-- TipoResultadoRecurso				
						NULL,															-- CodigoSolicitud						
						NULL,															-- DescripcionSolicitud				
						NULL,															-- CodigoArchivoSolicitud				
						NULL,															-- DescripcionArchivoSolicitud			
						NULL,															-- NombreUsuarioDocumento				
						NULL,															-- PrimerApellidoDocumento				
						NULL,															-- SegundoApellidoDocumento			
						NULL,															-- FechaCreacionDocumento				
						NULL,															-- UsuarioRedDocumento					
						NULL,															-- NombreUsuario						
						NULL,															-- PrimerApellido						
						NULL,															-- SegundoApellido						
						NULL,															-- UsuarioRed							
						NULL,															-- CodigoResultadoRecurso				
						NULL,															-- CodigoResultadoSolicitud			
						NULL,															-- CodResultadoLegajo					
						NULL,															-- DescripcionResultadoLegajo			
						NULL,															-- CodigoLegajoResultadoRecurso		
						NULL,															-- CodigoLegajoResultadoSolicitud		
						NULL,															-- CodigoRecursoResultadoLegajo		
						NULL,															-- CodigoSolicitudResultadoLegajo		
						C.TC_DescripcionMotivoRechazoItineracion						DescripcionMotivoRechazoItineracion,
						NULL,															-- CodigoClaseAsuntoRecurso			
						NULL,															-- DescripcionClaseAsuntoRecurso		
						NULL,															-- TipoResolucionRecurso				
						NULL,															-- FechaResolucion						
						NULL,															-- CodigoArchivoResolucion				
						NULL,															-- CodigoResolicion					
						NULL															-- NumeroResolucion
	FROM				Historico.Itineracion						C	WITH(NOLOCK)		
	INNER JOIN			Historico.ExpedienteEntradaSalida			A	WITH(NOLOCK)	
	ON					C.TU_CodRegistroItineracion					=	A.TU_CodExpedienteEntradaSalida
	INNER JOIN			Expediente.Expediente						B	WITH(NOLOCK)
	ON					B.TC_NumeroExpediente						=	C.TC_NumeroExpediente
	INNER JOIN			Expediente.ExpedienteDetalle				D	WITH(NOLOCK)
	ON					D.TC_NumeroExpediente						=	A.TC_NumeroExpediente
	AND					D.TC_CodContexto							=	A.TC_CodContexto
	WHERE				A.TF_Entrada								IS NOT NULL
	AND					C.TN_CodTipoItineracion						=	@L_CodigoTipoItineracionExpediente
	AND					C.TC_CodContextoOrigen						=	@L_ContextoOrigen
	AND					C.TN_CodEstadoItineracion					NOT IN (SELECT Codigo FROM @ListaEstados)				
	AND					C.TC_NumeroExpediente						=	COALESCE (@L_NumeroExpediente,C.TC_NumeroExpediente)
	AND					(
							(	
								C.TF_FechaEnvio IS NOT NULL
								AND 
								C.TF_FechaEnvio						>=	COALESCE (@L_FechaInicio, C.TF_FechaEnvio)
								AND
								C.TF_FechaEnvio						<=	COALESCE (@L_FechaFinal, C.TF_FechaEnvio)
							)
							OR
							(
								C.TF_FechaEnvio IS NULL
								AND
								C.TF_FechaEstado					>=	COALESCE (@L_FechaInicio, C.TF_FechaEstado)	
								AND
								C.TF_FechaEstado					<=	COALESCE (@L_FechaFinal, C.TF_FechaEstado)
							)
						)
	AND					C.TN_CodEstadoItineracion					=	COALESCE (@L_CodEstadoItineacion,C.TN_CodEstadoItineracion)

UNION

	--LEGAJOS
	SELECT				A.TF_Entrada														FechaCreacion,						
						ISNULL(C.TF_FechaEnvio, C.TF_FechaEstado)							FechaEnvio,							
						0,																	-- Acumulado							
						C.TC_MensajeError													MensajeError,						
						C.TU_CodHistoricoItineracion										HistoricoItineracion,				
						A.TU_CodLegajoEntradaSalida											CodigoEntradaSalida,					
						ISNULL(C.TN_CodMotivoItineracion, A.TN_CodMotivoItineracion)		CodigoMotivoItineracion,				
						NULL,																-- DescripcionMotivoItineracion		
						C.TN_CodMotivoRechazoItineracion									CodigoMotivoRechazo,					
						NULL,																-- DescripcionMotivoRechazo			
						NULL,																-- CodigoOficina						
						NULL,																-- DescripcionOficina					
						C.TC_CodContextoDestino												CodigoContextoDestino,				
						C.TN_CodEstadoItineracion											CodigoEstadoItineracion,				
						NULL,																-- DescripcionEstadoItineracion		
						C.TN_CodTipoItineracion												CodigoTipoItineracion,				
						NULL,																-- TipoItineracionDescripcion			
						ISNULL(B.TC_NumeroExpediente, C.TC_NumeroExpediente)				Numero,							
						NULL,																-- DescripcionExpediente				
						NULL,																-- CodigoClase							
						NULL,																-- DescripcionClase					
						NULL,																-- CodigoProceso						
						NULL,																-- DescripcionProceso					
						D.TN_CodAsunto														CodigoAsunto,						
						NULL,																-- DescripcionAsunto					
						D.TN_CodClaseAsunto													CodigoClaseAsunto,				
						NULL,																-- DescripcionClaseAsunto				
						A.TU_CodLegajo														CodigoLegajo,						
						B.TC_Descripcion													DescripcionLegajo,					
						NULL,																-- CodigoRecurso						
						NULL,																-- TipoResultadoRecurso				
						NULL,																-- CodigoSolicitud						
						NULL,																-- DescripcionSolicitud				
						NULL,																-- CodigoArchivoSolicitud				
						NULL,																-- DescripcionArchivoSolicitud			
						NULL,																-- NombreUsuarioDocumento				
						NULL,																-- PrimerApellidoDocumento				
						NULL,																-- SegundoApellidoDocumento			
						NULL,																-- FechaCreacionDocumento				
						NULL,																-- UsuarioRedDocumento					
						NULL,																-- NombreUsuario						
						NULL,																-- PrimerApellido						
						NULL,																-- SegundoApellido						
						NULL,																-- UsuarioRed							
						NULL,																-- CodigoResultadoRecurso				
						NULL,																-- CodigoResultadoSolicitud			
						NULL,																-- CodResultadoLegajo					
						NULL,																-- DescripcionResultadoLegajo			
						NULL,																-- CodigoLegajoResultadoRecurso		
						NULL,																-- CodigoLegajoResultadoSolicitud		
						NULL,																-- CodigoRecursoResultadoLegajo		
						NULL,																-- CodigoSolicitudResultadoLegajo		
						C.TC_DescripcionMotivoRechazoItineracion							DescripcionMotivoRechazoItineracion,
						NULL,																-- CodigoClaseAsuntoRecurso			
						NULL,																-- DescripcionClaseAsuntoRecurso		
						NULL,																-- TipoResolucionRecurso				
						NULL,																-- FechaResolucion						
						NULL,																-- CodigoArchivoResolucion				
						NULL,																-- CodigoResolicion					
						NULL																-- NumeroResolucion
	FROM				Historico.Itineracion						C	WITH(NOLOCK)
	LEFT JOIN			Historico.LegajoEntradaSalida				A	WITH(NOLOCK)
	ON					C.TU_CodRegistroItineracion					=	A.TU_CodLegajoEntradaSalida	
	LEFT JOIN			Expediente.Legajo							B	WITH(NOLOCK)
	ON					B.TU_CodLegajo								=	A.TU_CodLegajo	
	LEFT JOIN			Expediente.LegajoDetalle					D	WITH(NOLOCK)
	ON					D.TU_CodLegajo								=	A.TU_CodLegajo
	AND					D.TC_CodContexto							=	A.TC_CodContexto
	WHERE				A.TF_Entrada								IS NOT NULL
	AND					C.TN_CodTipoItineracion						=	@L_CodigoTipoItineracionLegajo
	AND					C.TC_CodContextoOrigen						=	@L_ContextoOrigen	
	AND					C.TN_CodEstadoItineracion					NOT IN (SELECT Codigo FROM @ListaEstados)
	AND					C.TC_NumeroExpediente						=	COALESCE (@L_NumeroExpediente,C.TC_NumeroExpediente)
	AND					(
							(	
								C.TF_FechaEnvio IS NOT NULL
								AND 
								C.TF_FechaEnvio						>=	COALESCE (@L_FechaInicio, C.TF_FechaEnvio)
								AND
								C.TF_FechaEnvio						<=	COALESCE (@L_FechaFinal, C.TF_FechaEnvio)
							)
							OR
							(
								C.TF_FechaEnvio IS NULL
								AND
								C.TF_FechaEstado					>=	COALESCE (@L_FechaInicio, C.TF_FechaEstado)	
								AND
								C.TF_FechaEstado					<=	COALESCE (@L_FechaFinal, C.TF_FechaEstado)
							)
						)
	AND					C.TN_CodEstadoItineracion					=	COALESCE (@L_CodEstadoItineacion,C.TN_CodEstadoItineracion)
	
UNION

	--RECURSOS
	SELECT		
				A.TF_Fecha_Creacion													FechaCreacion,						
				ISNULL(C.TF_FechaEnvio, C.TF_FechaEstado)							FechaEnvio,						
				0,																	-- Acumulado							
				C.TC_MensajeError													MensajeError,						
				C.TU_CodHistoricoItineracion										HistoricoItineracion,				
				NULL,																-- CodigoEntradaSalida					
				ISNULL(C.TN_CodMotivoItineracion, A.TN_CodMotivoItineracion)		CodigoMotivoItineracion,				
				NULL,																-- DescripcionMotivoItineracion		
				C.TN_CodMotivoRechazoItineracion									CodigoMotivoRechazo,					
				NULL,																-- DescripcionMotivoRechazo			
				NULL,																-- CodigoOficina						
				NULL,																-- DescripcionOficina					
				C.TC_CodContextoDestino												CodigoContextoDestino,				
				C.TN_CodEstadoItineracion											CodigoEstadoItineracion,				
				NULL,																-- DescripcionEstadoItineracion		
				C.TN_CodTipoItineracion												CodigoTipoItineracion,			
				NULL,																-- TipoItineracionDescripcion			
				B.TC_NumeroExpediente												Numero,							
				B.TC_Descripcion													DescripcionExpediente,			
				NULL,																-- CodigoClase							
				NULL,																-- DescripcionClase					
				NULL,																-- CodigoProceso						
				NULL,																-- DescripcionProceso					
				NULL,																-- CodigoAsunto						
				NULL,																-- DescripcionAsunto					
				NULL,																-- CodigoClaseAsunto					
				NULL,																-- DescripcionClaseAsunto				
				NULL,																-- CodigoLegajo						
				NULL,																-- DescripcionLegajo					
				A.TU_CodRecurso														CodigoRecurso,						
				NULL,																-- TipoResultadoRecurso				
				NULL,																-- CodigoSolicitud						
				NULL,																-- DescripcionSolicitud				
				NULL,																-- CodigoArchivoSolicitud				
				NULL,																-- DescripcionArchivoSolicitud			
				NULL,																-- NombreUsuarioDocumento				
				NULL,																-- PrimerApellidoDocumento				
				NULL,																-- SegundoApellidoDocumento			
				NULL,																-- FechaCreacionDocumento				
				NULL,																-- UsuarioRedDocumento					
				NULL,																-- NombreUsuario						
				NULL,																-- PrimerApellido						
				NULL,																-- SegundoApellido						
				NULL,																-- UsuarioRed							
				NULL,																-- CodigoResultadoRecurso				
				NULL,																-- CodigoResultadoSolicitud			
				NULL,																-- CodResultadoLegajo					
				NULL,																-- DescripcionResultadoLegajo			
				NULL,																-- CodigoLegajoResultadoRecurso		
				NULL,																-- CodigoLegajoResultadoSolicitud		
				NULL,																-- CodigoRecursoResultadoLegajo		
				NULL,																-- CodigoSolicitudResultadoLegajo		
				C.TC_DescripcionMotivoRechazoItineracion							DescripcionMotivoRechazoItineracion,	
				A.TN_CodClaseAsunto													CodigoClaseAsuntoRecurso,			
				NULL,																-- DescripcionClaseAsuntoRecurso		
				NULL,																-- TipoResolucionRecurso				
				NULL,																-- FechaResolucion						
				NULL,																-- CodigoArchivoResolucion				
				A.TU_CodResolucion													CodigoResolicion,					
				D.TC_NumeroResolucion												NumeroResolucion
	FROM		Historico.Itineracion							C	WITH(NOLOCK)
	INNER JOIN	Expediente.RecursoExpediente					A	WITH(NOLOCK)
	ON			C.TU_CodRegistroItineracion						=	A.TU_CodRecurso			
	INNER JOIN	Expediente.Expediente							B	WITH(NOLOCK)
	ON			B.TC_NumeroExpediente							=	C.TC_NumeroExpediente	
	LEFT JOIN	Expediente.LibroSentencia						D	WITH(NOLOCK)
	ON			D.TU_CodResolucion								=	A.TU_CodResolucion
	WHERE		C.TN_CodTipoItineracion							=	@L_CodigoTipoItineracionRecurso
	AND			C.TC_CodContextoOrigen							=	@L_ContextoOrigen	
	AND			C.TN_CodEstadoItineracion						NOT IN (SELECT Codigo FROM @ListaEstados)
	AND			C.TC_NumeroExpediente							=	COALESCE (@L_NumeroExpediente,C.TC_NumeroExpediente)
	AND			(
					(	
						C.TF_FechaEnvio IS NOT NULL
						AND 
						C.TF_FechaEnvio							>=	COALESCE (@L_FechaInicio, C.TF_FechaEnvio)
						AND
						C.TF_FechaEnvio							<=	COALESCE (@L_FechaFinal, C.TF_FechaEnvio)
					)
					OR
					(
						C.TF_FechaEnvio IS NULL
						AND
						C.TF_FechaEstado						>=	COALESCE (@L_FechaInicio, C.TF_FechaEstado)	
						AND
						C.TF_FechaEstado						<=	COALESCE (@L_FechaFinal, C.TF_FechaEstado)
					)
				)
	AND			C.TN_CodEstadoItineracion						=	COALESCE (@L_CodEstadoItineacion,C.TN_CodEstadoItineracion)

UNION

	--SOLICITUDES.
	SELECT		
				A.TF_FechaCreacion													FechaCreacion,					
				ISNULL(C.TF_FechaEnvio, C.TF_FechaEstado)							FechaEnvio,						
				0,																	-- Acumulado							
				C.TC_MensajeError													MensajeError,					
				C.TU_CodHistoricoItineracion										HistoricoItineracion,				
				NULL,																-- CodigoEntradaSalida					
				ISNULL(C.TN_CodMotivoItineracion, A.TN_CodMotivoItineracion)		CodigoMotivoItineracion,				
				NULL,																-- DescripcionMotivoItineracion		
				C.TN_CodMotivoRechazoItineracion									CodigoMotivoRechazo,					
				NULL,																-- DescripcionMotivoRechazo			
				NULL,																-- CodigoOficina						
				NULL,																-- DescripcionOficina					
				C.TC_CodContextoDestino												CodigoContextoDestino,			
				C.TN_CodEstadoItineracion											CodigoEstadoItineracion,				
				NULL,																-- DescripcionEstadoItineracion		
				C.TN_CodTipoItineracion												CodigoTipoItineracion,			
				NULL,																-- TipoItineracionDescripcion			
				B.TC_NumeroExpediente												Numero,								
				B.TC_Descripcion													DescripcionExpediente,		
				NULL,																-- CodigoClase							
				NULL,																-- DescripcionClase					
				NULL,																-- CodigoProceso						
				NULL,																-- DescripcionProceso					
				NULL,																-- CodigoAsunto						
				NULL,																-- DescripcionAsunto					
				A.TN_CodClaseAsunto													CodigoClaseAsunto,					
				NULL,																-- DescripcionClaseAsunto				
				NULL,																-- CodigoLegajo						
				NULL,																-- DescripcionLegajo					
				NULL,																-- CodigoRecurso						
				NULL,																-- TipoResultadoRecurso				
				A.TU_CodSolicitudExpediente											CodigoSolicitud,					
				A.TC_Descripcion													DescripcionSolicitud,				
				A.TU_CodArchivo														CodigoArchivoSolicitud,			
				NULL,																-- DescripcionArchivoSolicitud			
				NULL,																-- NombreUsuarioDocumento				
				NULL,																-- PrimerApellidoDocumento				
				NULL,																-- SegundoApellidoDocumento			
				NULL,																-- FechaCreacionDocumento				
				NULL,																-- UsuarioRedDocumento					
				NULL,																-- NombreUsuario						
				NULL,																-- PrimerApellido						
				NULL,																-- SegundoApellido						
				NULL,																-- UsuarioRed							
				NULL,																-- CodigoResultadoRecurso				
				NULL,																-- CodigoResultadoSolicitud			
				NULL,																-- CodResultadoLegajo					
				NULL,																-- DescripcionResultadoLegajo			
				NULL,																-- CodigoLegajoResultadoRecurso		
				NULL,																-- CodigoLegajoResultadoSolicitud		
				NULL,																-- CodigoRecursoResultadoLegajo		
				NULL,																-- CodigoSolicitudResultadoLegajo		
				C.TC_DescripcionMotivoRechazoItineracion							DescripcionMotivoRechazoItineracion,
				NULL,																-- CodigoClaseAsuntoRecurso			
				NULL,																-- DescripcionClaseAsuntoRecurso		
				NULL,																-- TipoResolucionRecurso				
				NULL,																-- FechaResolucion						
				NULL,																-- CodigoArchivoResolucion				
				NULL,																-- CodigoResolicion					
				NULL																-- NumeroResolucion
	FROM		Historico.Itineracion							C	WITH(NOLOCK)
	INNER JOIN	Expediente.SolicitudExpediente					A	WITH(NOLOCK)
	ON			C.TU_CodRegistroItineracion						=	A.TU_CodSolicitudExpediente	
	INNER JOIN	Expediente.Expediente							B	WITH(NOLOCK)
	ON			B.TC_NumeroExpediente							=	C.TC_NumeroExpediente	
	WHERE		C.TN_CodTipoItineracion							=	@L_CodigoTipoItineracionSolicitud
	AND			C.TC_CodContextoOrigen							=	@L_ContextoOrigen		
	AND			C.TN_CodEstadoItineracion						NOT IN (SELECT Codigo FROM @ListaEstados)
	AND			C.TC_NumeroExpediente							=	COALESCE (@L_NumeroExpediente, C.TC_NumeroExpediente)
	AND			(
					(	
						C.TF_FechaEnvio IS NOT NULL
						AND 
						C.TF_FechaEnvio							>=	COALESCE (@L_FechaInicio, C.TF_FechaEnvio)
						AND
						C.TF_FechaEnvio							<=	COALESCE (@L_FechaFinal, C.TF_FechaEnvio)
					)
					OR
					(
						C.TF_FechaEnvio IS NULL
						AND
						C.TF_FechaEstado						>=	COALESCE (@L_FechaInicio, C.TF_FechaEstado)	
						AND
						C.TF_FechaEstado						<=	COALESCE (@L_FechaFinal, C.TF_FechaEstado)
					)
				)
	AND			C.TN_CodEstadoItineracion						=	COALESCE (@L_CodEstadoItineacion, C.TN_CodEstadoItineracion)

UNION

	--RESULTADO RECURSOS	
	SELECT		
				A.TF_FechaCreacion								FechaCreacion,						
				A.TF_FechaEnvio									FechaEnvio,							
				0,												-- Acumulado							
				D.TC_MensajeError								MensajeError,						
				A.TU_CodHistoricoItineracion					HistoricoItineracion,				
				NULL,											-- CodigoEntradaSalida					
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,				
				NULL,											-- DescripcionMotivoItineracion		
				D.TN_CodMotivoRechazoItineracion				CodigoMotivoRechazo,					
				NULL,											-- DescripcionMotivoRechazo			
				NULL,											-- CodigoOficina						
				NULL,											-- DescripcionOficina					
				D.TC_CodContextoDestino							CodigoContextoDestino,			
				D.TN_CodEstadoItineracion						CodigoEstadoItineracion,				
				NULL,											-- DescripcionEstadoItineracion		
				D.TN_CodTipoItineracion							CodigoTipoItineracion,			
				NULL,											-- TipoItineracionDescripcion			
				B.TC_NumeroExpediente							Numero,							
				C.TC_Descripcion								DescripcionExpediente,			
				NULL,											-- CodigoClase							
				NULL,											-- DescripcionClase					
				NULL,											-- CodigoProceso						
				NULL,											-- DescripcionProceso					
				NULL,											-- CodigoAsunto						
				NULL,											-- DescripcionAsunto					
				NULL,											-- CodigoClaseAsunto					
				NULL,											-- DescripcionClaseAsunto				
				NULL,											-- CodigoLegajo						
				NULL,											-- DescripcionLegajo					
				NULL,											-- CodigoRecurso						
				NULL,											-- TipoResultadoRecurso				
				NULL,											-- CodigoSolicitud						
				NULL,											-- DescripcionSolicitud				
				NULL,											-- CodigoArchivoSolicitud				
				NULL,											-- DescripcionArchivoSolicitud			
				NULL,											-- NombreUsuarioDocumento				
				NULL,											-- PrimerApellidoDocumento				
				NULL,											-- SegundoApellidoDocumento			
				NULL,											-- FechaCreacionDocumento				
				NULL,											-- UsuarioRedDocumento					
				NULL,											-- NombreUsuario						
				NULL,											-- PrimerApellido						
				NULL,											-- SegundoApellido						
				A.TC_UsuarioRed									UsuarioRed,
				A.TU_CodResultadoRecurso						CodigoResultadoRecurso,			
				NULL,											-- CodigoResultadoSolicitud			
				F.TN_CodResultadoLegajo							CodResultadoLegajo,				
				NULL,											-- DescripcionResultadoLegajo			
				A.TU_CodLegajo									CodigoLegajoResultadoRecurso,		
				NULL,											-- CodigoLegajoResultadoSolicitud		
				G.TU_CodRecurso									CodigoRecursoResultadoLegajo,		
				NULL,											-- CodigoSolicitudResultadoLegajo		
				D.TC_DescripcionMotivoRechazoItineracion		DescripcionMotivoRechazoItineracion,	
				NULL,											-- CodigoClaseAsuntoRecurso			
				NULL,											-- DescripcionClaseAsuntoRecurso		
				NULL,											-- TipoResolucionRecurso				
				NULL,											-- FechaResolucion						
				NULL,											-- CodigoArchivoResolucion				
				NULL,											-- CodigoResolicion					
				NULL											-- NumeroResolucion
	FROM		Expediente.ResultadoRecurso						A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo								B WITH(NOLOCK)
	ON			B.TU_CodLegajo									= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= B.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion							D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle						E WITH(NOLOCK)
	ON			E.TU_CodLegajo									= B.TU_CodLegajo
	INNER JOIN	Catalogo.ResultadoLegajo						F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo							= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionRecursoResultado			G WITH(NOLOCK)
	ON			A.TU_CodLegajo									= G.TU_CodLegajo
	AND			A.TU_CodHistoricoItineracion					= G.TU_CodItineracionResultado
	WHERE		A.TF_FechaEnvio									IS NOT NULL
	AND			D.TC_CodContextoDestino							IS NOT NULL
	AND			D.TC_CodContextoOrigen							= @L_ContextoOrigen
	AND			D.TN_CodEstadoItineracion						NOT IN (SELECT Codigo FROM @ListaEstados)			
	AND			B.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaEnvio									>= COALESCE (@L_FechaInicio,A.TF_FechaEnvio)	
	AND			A.TF_FechaEnvio									<= COALESCE (@L_FechaFinal,A.TF_FechaEnvio)
	AND			D.TN_CodEstadoItineracion						=  COALESCE (@L_CodEstadoItineacion,D.TN_CodEstadoItineracion)
	AND			A.TU_CodLegajo									=  (SELECT TOP 1	L.TU_CodLegajo
																	FROM			Expediente.Legajo L  WITH(NOLOCK)
																	WHERE			TC_CodContexto = COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
																	AND				L.TU_CodLegajo = A.TU_CodLegajo)	
UNION

	--RESULTADO SOLICITUDES

	SELECT		
				A.TF_FechaCreacion								FechaCreacion,					
				A.TF_FechaEnvio									FechaEnvio,						
				0,												-- Acumulado							
				D.TC_MensajeError								MensajeError,						
				A.TU_CodHistoricoItineracion					HistoricoItineracion,				
				NULL,											-- CodigoEntradaSalida					
				A.TN_CodMotivoItineracion						CodigoMotivoItineracion,				
				NULL,											-- DescripcionMotivoItineracion		
				D.TN_CodMotivoRechazoItineracion				CodigoMotivoRechazo,					
				E.TC_CodContextoProcedencia						CodigoContextoDestino,			
				NULL,											-- CodigoOficina						
				NULL,											-- DescripcionOficina					
				NULL,											-- CodigoContextoDestino				
				D.TN_CodEstadoItineracion						CodigoEstadoItineracion,				
				NULL,											-- DescripcionEstadoItineracion		
				D.TN_CodTipoItineracion							CodigoTipoItineracion,			
				NULL,											-- TipoItineracionDescripcion			
				B.TC_NumeroExpediente							Numero,							
				C.TC_Descripcion								DescripcionExpediente,				
				NULL,											-- CodigoClase							
				NULL,											-- DescripcionClase					
				NULL,											-- CodigoProceso						
				NULL,											-- DescripcionProceso					
				NULL,											-- CodigoAsunto						
				NULL,											-- DescripcionAsunto					
				NULL,											-- CodigoClaseAsunto					
				NULL,											-- DescripcionClaseAsunto				
				NULL,											-- CodigoLegajo						
				NULL,											-- DescripcionLegajo					
				NULL,											-- CodigoRecurso						
				NULL,											-- TipoResultadoRecurso				
				NULL,											-- CodigoSolicitud						
				NULL,											-- DescripcionSolicitud				
				NULL,											-- CodigoArchivoSolicitud				
				NULL,											-- DescripcionArchivoSolicitud			
				NULL,											-- NombreUsuarioDocumento				
				NULL,											-- PrimerApellidoDocumento				
				NULL,											-- SegundoApellidoDocumento			
				NULL,											-- FechaCreacionDocumento				
				NULL,											-- UsuarioRedDocumento					
				NULL,											-- NombreUsuario						
				NULL,											-- PrimerApellido						
				NULL,											-- SegundoApellido						
				A.TC_UsuarioRed									UsuarioRed,						
				NULL,											-- CodigoResultadoRecurso				
				A.TU_CodResultadoSolicitud						CodigoResultadoSolicitud,			
				F.TN_CodResultadoLegajo							CodResultadoLegajo,				
				NULL,											-- DescripcionResultadoLegajo			
				NULL,											-- CodigoLegajoResultadoRecurso		
				A.TU_CodLegajo									CodigoLegajoResultadoSolicitud,	
				NULL,											-- CodigoRecursoResultadoLegajo		
				G.TU_CodSolicitud								CodigoSolicitudResultadoLegajo,	
				D.TC_DescripcionMotivoRechazoItineracion		DescripcionMotivoRechazoItineracion,	
				NULL,											-- CodigoClaseAsuntoRecurso			
				NULL,											-- DescripcionClaseAsuntoRecurso		
				NULL,											-- TipoResolucionRecurso				
				NULL,											-- FechaResolucion						
				NULL,											-- CodigoArchivoResolucion				
				NULL,											-- CodigoResolicion					
				NULL											-- NumeroResolucion
	FROM		Expediente.ResultadoSolicitud					A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo								B WITH(NOLOCK)
	ON			B.TU_CodLegajo									= A.TU_CodLegajo
	INNER JOIN	Expediente.Expediente							C WITH(NOLOCK)
	ON			C.TC_NumeroExpediente							= B.TC_NumeroExpediente
	INNER JOIN	Historico.Itineracion							D WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion					= A.TU_CodHistoricoItineracion
	INNER JOIN	Expediente.LegajoDetalle						E WITH(NOLOCK)
	ON			E.TU_CodLegajo									= B.TU_CodLegajo
	INNER JOIN	Catalogo.ResultadoLegajo						F WITH(NOLOCK)
	ON			F.TN_CodResultadoLegajo							= A.TN_CodResultadoLegajo
	INNER JOIN	Historico.ItineracionSolicitudResultado			G WITH(NOLOCK)
	ON			A.TU_CodLegajo									= G.TU_CodLegajo
	AND			D.TU_CodHistoricoItineracion					= G.TU_CodItineracionResultado
	WHERE		A.TF_FechaEnvio									IS NOT NULL
	AND			D.TC_CodContextoDestino							IS NOT NULL
	AND			D.TC_CodContextoOrigen							= @L_ContextoOrigen
	AND			D.TN_CodEstadoItineracion						NOT IN (SELECT Codigo FROM @ListaEstados)			
	AND			B.TC_NumeroExpediente							=  COALESCE (@L_NumeroExpediente,B.TC_NumeroExpediente)
	AND			A.TF_FechaEnvio									>= COALESCE (@L_FechaInicio,A.TF_FechaEnvio)	
	AND			A.TF_FechaEnvio									<= COALESCE (@L_FechaFinal,A.TF_FechaEnvio)
	AND			D.TN_CodEstadoItineracion						=  COALESCE (@L_CodEstadoItineacion,D.TN_CodEstadoItineracion)
	AND			A.TU_CodLegajo									=  (SELECT TOP 1	L.TU_CodLegajo
																	FROM			Expediente.Legajo L WITH(NOLOCK)
																	WHERE			TC_CodContexto = COALESCE (@L_ContextoOrigen, L.TC_CodContexto)
																	AND				L.TU_CodLegajo = A.TU_CodLegajo)
	ORDER BY	FechaEnvio	DESC
    OFFSET      (@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS
    FETCH NEXT  @L_CantidadRegistros ROWS ONLY


	--Actualiza la oficina destino	
	UPDATE		A
	SET			A.CodigoOficina			= B.TC_CodOficina,
				A.DescripcionOficina	= B.TC_Descripcion
	FROM		@Result					A
	INNER JOIN	Catalogo.Contexto 		B WITH(NOLOCK)
	ON			B.TC_CodContexto 		= A.CodigoContextoDestino
	INNER JOIN	Catalogo.Oficina		C WITH(NOLOCK)
	ON			C.TC_CodOficina			= B.TC_CodOficina

	--Aplica filtro de oficina destino en espec­fico.
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
	--Actualiza todas las descripciones de el tipo de itineración.
	UPDATE		A
	SET			A.TipoItineracionDescripcion	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.TipoItineracion		B WITH(NOLOCK)
	ON			B.TN_CodTipoItineracion			= A.CodigoTipoItineracion
	--Actualiza las descripciones de estado de itineración.
	UPDATE		A
	SET			A.DescripcionEstadoItineracion	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.EstadoItineracion		B WITH(NOLOCK)
	ON			B.TN_CodEstadoItineracion		= A.CodigoEstadoItineracion
	--Actualiza el motivo de la itineración.
	UPDATE		A
	SET			A.DescripcionMotivoItineracion	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.MotivoItineracion 		B WITH(NOLOCK)
	ON			B.TN_CodMotivoItineracion 		= A.CodigoMotivoItineracion
	--Actualiza todas las descripciones del Motivo de rechazo
	UPDATE		A
	SET			A.DescripcionMotivoRechazo			= B.TC_Descripcion
	FROM		@Result								A
	INNER JOIN	Catalogo.MotivoRechazoItineracion	B WITH(NOLOCK)
	ON			B.TN_CodMotivoRechazoItineracion	= A.CodigoMotivoRechazo
	--Actualización de descripción de clase
	UPDATE		A
	SET			A.DescripcionClase	= B.TC_Descripcion
	FROM		@Result				A
	INNER JOIN	Catalogo.Clase		B WITH(NOLOCK)
	ON			B.TN_CodClase		= A.CodigoClase
	--Actualización de descripción de proceso
	UPDATE		A
	SET			A.DescripcionProceso	= B.TC_Descripcion
	FROM		@Result					A
	INNER JOIN	Catalogo.Proceso		B WITH(NOLOCK)
	ON			B.TN_CodProceso			= A.CodigoProceso
	--Actualización de descripción de asunto
	UPDATE		A
	SET			A.DescripcionAsunto	= B.TC_Descripcion
	FROM		@Result				A
	INNER JOIN	Catalogo.Asunto		B WITH(NOLOCK)
	ON			B.TN_CodAsunto		= A.CodigoAsunto
	--Actualización de descripción de clases de asunto
	UPDATE		A
	SET			A.DescripcionClaseAsunto	= B.TC_Descripcion
	FROM		@Result						A
	INNER JOIN	Catalogo.ClaseAsunto		B WITH(NOLOCK)
	ON			B.TN_CodClaseAsunto			= A.CodigoClaseAsunto

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
	INNER JOIN	Catalogo.ResultadoLegajo		B WITH(NOLOCK)
	ON			B.TN_CodResultadoLegajo			= A.CodResultadoLegajo


		--Actualización de descripción de clases de asunto para los recursos
	UPDATE		A
	SET			A.DescripcionClaseAsuntoRecurso	= B.TC_Descripcion
	FROM		@Result							A
	INNER JOIN	Catalogo.ClaseAsunto			B WITH(NOLOCK)
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
	-- Agregamos al redactor para los recursos
	
	UPDATE	A
	SET
		A.NombreUsuario = F.TC_Nombre, 
		A.PrimerApellido =  F.TC_PrimerApellido, 
		A.SegundoApellido = F.TC_SegundoApellido
	FROM @Result	A INNER JOIN Expediente.RecursoExpediente RE WITH(NOLOCK) ON RE.TU_CodResolucion = A.CodigoResolicion 
	INNER join  Expediente.Resolucion R  WITH(NOLOCK) ON RE.TU_CodResolucion = R.TU_CodResolucion 
	INNER JOIN Catalogo.PuestoTrabajoFuncionario PT WITH(NOLOCK) on R.TU_RedactorResponsable = PT.TU_CodPuestoFuncionario
	INNER JOIN Catalogo.Funcionario F WITH(NOLOCK) on F.TC_UsuarioRed = PT.TC_UsuarioRed
	

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


	SELECT	@L_TotalRegistros = COUNT(*)
	FROM	@Result
	SELECT		@L_TotalRegistros TotalRegistros,	
				FechaCreacion,						
				FechaEnvio,							
				Acumulado,
				MensajeError,						
				DescripcionMotivoRechazoItineracion,
				'SplitDatos' SplitDatos,			
				CodigoEntradaSalida,				
				HistoricoItineracion,				
				CodigoTipoItineracion,				
				TipoItineracionDescripcion,
				CodigoEstadoItineracion,			
				DescripcionEstadoItineracion,		
				CodigoMotivoItineracion,			
				DescripcionMotivoItineracion,
				CodigoContextoDestino,				
				CodigoOficina,						
				DescripcionOficina,					
				CodigoClase,
				DescripcionClase,					
				CodigoProceso,						
				DescripcionProceso,					
				CodigoAsunto,
				DescripcionAsunto,					
				CodigoClaseAsunto,					
				DescripcionClaseAsunto,				
				TipoResultadoRecurso,
				CodResultadoLegajo,					
				DescripcionResultadoLegajo,			
				Numero NumeroExpedienteRecurso,		
				CodigoArchivoSolicitud,				
				NombreUsuario,						
				PrimerApellido,						
				SegundoApellido,					
				CodigoLegajoResultadoRecurso,		
				CodigoLegajoResultadoSolicitud,		
				CodigoRecursoResultadoLegajo,		
				CodigoSolicitudResultadoLegajo,
				CodigoMotivoRechazo,				
				DescripcionMotivoRechazo,			
				CodigoClaseAsuntoRecurso,			
				DescripcionClaseAsuntoRecurso,
				TipoResolucionRecurso,				
				FechaResolucion,					
				CodigoArchivoResolucion,			
				CodigoResolicion,
				NombreUsuario + ' ' + PrimerApellido + ' ' + SegundoApellido RedactorRecurso,
				NumeroResolucion,
				NombreUsuarioDocumento,				
				PrimerApellidoDocumento,			
				SegundoApellidoDocumento,			
				UsuarioRedDocumento,
				DescripcionArchivoSolicitud,		
				FechaCreacionDocumento,
				'SplitExpediente' SplitExpediente,	
				Numero,								
				DescripcionExpediente Descripcion,	
				'SplitLegajo' SplitLegajo,			
				CodigoLegajo  Codigo,				
				DescripcionLegajo Descripcion,
				'SplitRecurso' SplitRecurso,		
				CodigoRecurso Codigo,				
				'SplitSolicitud' SplitSolicitud,	
				CodigoSolicitud Codigo,				
				DescripcionSolicitud Descripcion,	
				'SplitResultadoSolicitud' SplitResultadoSolicitud,	
				CodigoResultadoSolicitud Codigo,
				'SplitResultadoRecurso' SplitResultadoRecurso,	
				CodigoResultadoRecurso Codigo			
				
    FROM		@Result
	WHERE		FechaCreacion IS NOT NULL
	GROUP BY	FechaCreacion,						FechaEnvio,							Acumulado,							MensajeError,
				CodigoEntradaSalida,				HistoricoItineracion,				CodigoTipoItineracion,				TipoItineracionDescripcion,			
				CodigoEstadoItineracion,			DescripcionEstadoItineracion,		CodigoMotivoItineracion,			DescripcionMotivoItineracion,		
				CodigoContextoDestino,				CodigoOficina,						DescripcionOficina,					CodigoClase,					
				DescripcionClase,					CodigoProceso,						DescripcionProceso,					CodigoAsunto,                 		
				DescripcionAsunto,					CodigoClaseAsunto,					DescripcionClaseAsunto,				TipoResultadoRecurso,
				CodResultadoLegajo,					DescripcionResultadoLegajo,			CodigoArchivoSolicitud,				
				NombreUsuario,						PrimerApellido,						SegundoApellido,											 
				Numero,								DescripcionExpediente,				CodigoLegajo,						DescripcionLegajo,
				CodigoRecurso,						CodigoSolicitud,					DescripcionSolicitud,				CodigoResultadoSolicitud,
				CodigoResultadoRecurso,				CodigoLegajoResultadoRecurso,		CodigoLegajoResultadoSolicitud,		CodigoRecursoResultadoLegajo,
				CodigoSolicitudResultadoLegajo,		CodigoMotivoRechazo,				DescripcionMotivoRechazo,			DescripcionMotivoRechazoItineracion,
				CodigoClaseAsuntoRecurso,			DescripcionClaseAsuntoRecurso,		TipoResolucionRecurso,				FechaResolucion,					
				CodigoArchivoResolucion,			CodigoResolicion,					NumeroResolucion,					NombreUsuarioDocumento,				
				PrimerApellidoDocumento,			SegundoApellidoDocumento,			UsuarioRedDocumento,				DescripcionArchivoSolicitud, 
				FechaCreacionDocumento
END
GO
