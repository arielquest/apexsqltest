SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<13/03/2020>
-- Descripción:			<Permite consultar un registro en la tabla: SolicitudExpediente.>
-- Modificado por:      <Jose Gabriel Cordero Soto>	<18/03/2020> <Se modifica consulta para agregar información del archivo>
-- Modificado por:      <Jose Gabriel Cordero Soto>	<30/03/2020> <Se agrega descripcion del archivo asociado a la solicitud y el usuario red del registro del archivo>
-- Modificado por:      <Ronny Ramírez R.> <14/04/2020> <Se agregan los datos de la tabla de ResultadoSolicitud, así como las tablas asociadas>
-- Modificado por:      <Aida E Siles R.> <24/06/2020> <Se agrega al LEFT JOIN de la consulta tabla ArchivoExpediente el campo numero de expediente>
-- Modificado por:		<Josué Quirós Batista> <25/09/2023> <Se agrega el parámetro para identificar legajos>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarSolicitudExpediente]
	@CodSolicitudExpediente						UNIQUEIDENTIFIER = NULL,
	@NumeroExpediente							VARCHAR(14),
	@CodigoLegajo								UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_CodSolicitudExpediente	   	    UNIQUEIDENTIFIER		= CASE @CodSolicitudExpediente
																			WHEN '00000000-0000-0000-0000-000000000000' THEN NULL
																			ELSE @CodSolicitudExpediente
																		  END
	DECLARE	@L_NumeroExpediente					VARCHAR(14)				= @NumeroExpediente
	DECLARE	@L_CodigoLegajo	   					UNIQUEIDENTIFIER		= CASE @CodigoLegajo
																			WHEN '00000000-0000-0000-0000-000000000000' THEN NULL
																			ELSE @CodigoLegajo
																		  END

If @L_CodigoLegajo IS NULL

	SELECT	  
				A.TU_CodSolicitudExpediente			AS Codigo,
				A.TF_FechaCreacion					AS FechaCreacion,
				A.TF_FechaEnvio						AS FechaEnvio,
				A.TF_FechaRecepcion					AS FechaRecepcion,
				A.TC_Descripcion					AS Descripcion,
				A.TU_CodHistoricoItineracion		AS CodHistoricoItineracion,				
				A.TU_CodSolicitudExpediente			AS Codigo,
				A.TU_CodLegajo						AS Legajo,
				'SplitEstadoItineracion'			AS SplitEstadoItineracion,	
				A.TN_CodEstadoItineracion			AS Codigo,
				E.TC_Descripcion					AS Descripcion,
				'SplitContextoOrigen'				AS SplitContextoOrigen,
				A.TC_CodContextoOrigen				AS Codigo,
				E.TC_Descripcion					AS Descripcion,
				'SplitOficinaDestino'				AS SplitOficinaDestino,
				A.TC_CodOficinaDestino				AS Codigo,
				O.TC_Nombre							AS Descripcion,
				'SplitContextoDestino'				AS SplitContextoDestino,
				A.TC_CodContextoDestino				AS Codigo,
				CD.TC_Descripcion					AS Descripcion,
				'SplitOtros'						AS SplitOtros,
				A.TN_CodMotivoItineracion			AS CodMotivoItineracion,
				MI.TC_Descripcion					AS DescripcionMotivoItineracion,				
				A.TN_CodTipoItineracion				AS CodTipoItineracion,
				TI.TC_Descripcion					AS DescripcionTipoMotivacion,			
				A.TN_CodClaseAsunto					AS CodClaseAsunto,
				CA.TC_Descripcion					AS DescripcionClaseAsunto,
				A.TU_CodArchivo						AS CodArchivo,
				AR.TC_Descripcion					AS DescripcionArchivo,
				AR.TF_FechaCrea						AS FechaCreacionArchivo,
				F.TC_Nombre							AS NombreFuncionario,
				F.TC_PrimerApellido					AS PrimerApellido,
				F.TC_SegundoApellido				AS SegundoApellido,
				AR.TN_CodFormatoArchivo				AS FormatoArchivo,
				A.TC_NumeroExpediente				AS NumeroExpediente,
				RS.TU_CodResultadoSolicitud			AS CodigoResultadoSolicitud,
				RS.TF_FechaCreacion					AS FechaCreacionResultadoSolicitud,
				RS.TF_FechaEnvio					AS FechaEnvioResultadoSolicitud,
				RS.TF_FechaRecepcion				AS FechaRecepcionResultadoSolicitud,
				RL.TN_CodResultadoLegajo			AS CodigoResultadoLegajo,
				RL.TC_Descripcion					AS DescripcionResultadoLegajo,
				EI.TN_CodEstadoItineracion			AS CodigoEstadoItineracion,
				EI.TC_Descripcion					AS DescripcionEstadoItineracion,
				RS.TC_CodContextoOrigen				AS CodigoContextoResultadoSolicitud,
				CR.TC_Descripcion					AS DescripcionContextoResultadoSolicitud,
				FR.TC_UsuarioRed					AS UsuarioRedResultadoSolicitud,
				FR.TC_Nombre						AS NombreFuncionarioResultadoSolicitud,
				FR.TC_PrimerApellido				AS PrimerApellidoResultadoSolicitud,
				FR.TC_SegundoApellido				AS SegundoApellidoResultadoSolicitud

	FROM		Expediente.SolicitudExpediente		A WITH (NOLOCK)
	INNER JOIN  Catalogo.EstadoItineracion			E WITH (NOLOCK)
	ON			E.TN_CodEstadoItineracion			= A.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Contexto					C WITH (NOLOCK)
	ON			C.TC_CodContexto					= A.TC_CodContextoOrigen
	INNER JOIN  Catalogo.Oficina 					O WITH (NOLOCK)
	ON			O.TC_CodOficina						= A.TC_CodOficinaDestino
	INNER JOIN  Catalogo.Contexto					CD WITH (NOLOCK)
	ON			CD.TC_CodContexto					= A.TC_CodContextoDestino
	INNER JOIN  Catalogo.MotivoItineracion			MI WITH (NOLOCK)
	ON			MI.TN_CodMotivoItineracion			= A.TN_CodMotivoItineracion
	INNER JOIN  Catalogo.TipoItineracion			TI WITH (NOLOCK)
	ON			TI.TN_CodTipoItineracion			= A.TN_CodTipoItineracion
	INNER JOIN  Catalogo.ClaseAsunto 				CA WITH (NOLOCK)
	ON			CA.TN_CodClaseAsunto				= A.TN_CodClaseAsunto
	LEFT JOIN   Expediente.ArchivoExpediente		AE WITH (NOLOCK)
	ON			AE.TU_CodArchivo					= A.TU_CodArchivo
	AND			AE.TC_NumeroExpediente				= @L_NumeroExpediente
	LEFT JOIN	Archivo.Archivo						AR WITH (NOLOCK)
	ON			AR.TU_CodArchivo					= AE.TU_CodArchivo
	LEFT JOIN  	Catalogo.Funcionario				F WITH (NOLOCK)
	ON			F.TC_UsuarioRed						= AR.TC_UsuarioCrea
	LEFT JOIN   Expediente.ResultadoSolicitud		RS WITH (NOLOCK)
	ON			RS.TU_CodResultadoSolicitud			= A.TU_CodResultadoSolicitud
	LEFT JOIN   Catalogo.ResultadoLegajo			RL WITH (NOLOCK)
	ON			RL.TN_CodResultadoLegajo			= RS.TN_CodResultadoLegajo
	LEFT JOIN   Catalogo.EstadoItineracion			EI WITH (NOLOCK)
	ON			EI.TN_CodEstadoItineracion			= RS.TN_CodEstadoItineracion
	LEFT JOIN  	Catalogo.Contexto					CR WITH (NOLOCK)
	ON			CR.TC_CodContexto					= RS.TC_CodContextoOrigen
	LEFT JOIN  	Catalogo.Funcionario				FR WITH (NOLOCK)
	ON			FR.TC_UsuarioRed					= RS.TC_UsuarioRed
	
	WHERE	A.TU_CodSolicitudExpediente				= COALESCE(@L_CodSolicitudExpediente, A.TU_CodSolicitudExpediente)
	AND		A.TC_NumeroExpediente					= @L_NumeroExpediente 
	And		A.TU_CodLegajo							IS NULL

Else

SELECT	  
				A.TU_CodSolicitudExpediente			AS Codigo,
				A.TF_FechaCreacion					AS FechaCreacion,
				A.TF_FechaEnvio						AS FechaEnvio,
				A.TF_FechaRecepcion					AS FechaRecepcion,
				A.TC_Descripcion					AS Descripcion,
				A.TU_CodHistoricoItineracion		AS CodHistoricoItineracion,				
				A.TU_CodSolicitudExpediente			AS Codigo,
				A.TU_CodLegajo						AS Legajo,
				'SplitEstadoItineracion'			AS SplitEstadoItineracion,	
				A.TN_CodEstadoItineracion			AS Codigo,
				E.TC_Descripcion					AS Descripcion,
				'SplitContextoOrigen'				AS SplitContextoOrigen,
				A.TC_CodContextoOrigen				AS Codigo,
				E.TC_Descripcion					AS Descripcion,
				'SplitOficinaDestino'				AS SplitOficinaDestino,
				A.TC_CodOficinaDestino				AS Codigo,
				O.TC_Nombre							AS Descripcion,
				'SplitContextoDestino'				AS SplitContextoDestino,
				A.TC_CodContextoDestino				AS Codigo,
				CD.TC_Descripcion					AS Descripcion,
				'SplitOtros'						AS SplitOtros,
				A.TN_CodMotivoItineracion			AS CodMotivoItineracion,
				MI.TC_Descripcion					AS DescripcionMotivoItineracion,				
				A.TN_CodTipoItineracion				AS CodTipoItineracion,
				TI.TC_Descripcion					AS DescripcionTipoMotivacion,			
				A.TN_CodClaseAsunto					AS CodClaseAsunto,
				CA.TC_Descripcion					AS DescripcionClaseAsunto,
				A.TU_CodArchivo						AS CodArchivo,
				AR.TC_Descripcion					AS DescripcionArchivo,
				AR.TF_FechaCrea						AS FechaCreacionArchivo,
				F.TC_Nombre							AS NombreFuncionario,
				F.TC_PrimerApellido					AS PrimerApellido,
				F.TC_SegundoApellido				AS SegundoApellido,
				AR.TN_CodFormatoArchivo				AS FormatoArchivo,
				A.TC_NumeroExpediente				AS NumeroExpediente,
				RS.TU_CodResultadoSolicitud			AS CodigoResultadoSolicitud,
				RS.TF_FechaCreacion					AS FechaCreacionResultadoSolicitud,
				RS.TF_FechaEnvio					AS FechaEnvioResultadoSolicitud,
				RS.TF_FechaRecepcion				AS FechaRecepcionResultadoSolicitud,
				RL.TN_CodResultadoLegajo			AS CodigoResultadoLegajo,
				RL.TC_Descripcion					AS DescripcionResultadoLegajo,
				EI.TN_CodEstadoItineracion			AS CodigoEstadoItineracion,
				EI.TC_Descripcion					AS DescripcionEstadoItineracion,
				RS.TC_CodContextoOrigen				AS CodigoContextoResultadoSolicitud,
				CR.TC_Descripcion					AS DescripcionContextoResultadoSolicitud,
				FR.TC_UsuarioRed					AS UsuarioRedResultadoSolicitud,
				FR.TC_Nombre						AS NombreFuncionarioResultadoSolicitud,
				FR.TC_PrimerApellido				AS PrimerApellidoResultadoSolicitud,
				FR.TC_SegundoApellido				AS SegundoApellidoResultadoSolicitud

	FROM		Expediente.SolicitudExpediente		A WITH (NOLOCK)
	INNER JOIN  Catalogo.EstadoItineracion			E WITH (NOLOCK)
	ON			E.TN_CodEstadoItineracion			= A.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Contexto					C WITH (NOLOCK)
	ON			C.TC_CodContexto					= A.TC_CodContextoOrigen
	INNER JOIN  Catalogo.Oficina 					O WITH (NOLOCK)
	ON			O.TC_CodOficina						= A.TC_CodOficinaDestino
	INNER JOIN  Catalogo.Contexto					CD WITH (NOLOCK)
	ON			CD.TC_CodContexto					= A.TC_CodContextoDestino
	INNER JOIN  Catalogo.MotivoItineracion			MI WITH (NOLOCK)
	ON			MI.TN_CodMotivoItineracion			= A.TN_CodMotivoItineracion
	INNER JOIN  Catalogo.TipoItineracion			TI WITH (NOLOCK)
	ON			TI.TN_CodTipoItineracion			= A.TN_CodTipoItineracion
	INNER JOIN  Catalogo.ClaseAsunto 				CA WITH (NOLOCK)
	ON			CA.TN_CodClaseAsunto				= A.TN_CodClaseAsunto
	LEFT JOIN   Expediente.ArchivoExpediente		AE WITH (NOLOCK)
	ON			AE.TU_CodArchivo					= A.TU_CodArchivo
	AND			AE.TC_NumeroExpediente				= @L_NumeroExpediente
	LEFT JOIN	Archivo.Archivo						AR WITH (NOLOCK)
	ON			AR.TU_CodArchivo					= AE.TU_CodArchivo
	LEFT JOIN  	Catalogo.Funcionario				F WITH (NOLOCK)
	ON			F.TC_UsuarioRed						= AR.TC_UsuarioCrea
	LEFT JOIN   Expediente.ResultadoSolicitud		RS WITH (NOLOCK)
	ON			RS.TU_CodResultadoSolicitud			= A.TU_CodResultadoSolicitud
	LEFT JOIN   Catalogo.ResultadoLegajo			RL WITH (NOLOCK)
	ON			RL.TN_CodResultadoLegajo			= RS.TN_CodResultadoLegajo
	LEFT JOIN   Catalogo.EstadoItineracion			EI WITH (NOLOCK)
	ON			EI.TN_CodEstadoItineracion			= RS.TN_CodEstadoItineracion
	LEFT JOIN  	Catalogo.Contexto					CR WITH (NOLOCK)
	ON			CR.TC_CodContexto					= RS.TC_CodContextoOrigen
	LEFT JOIN  	Catalogo.Funcionario				FR WITH (NOLOCK)
	ON			FR.TC_UsuarioRed					= RS.TC_UsuarioRed
	
	WHERE	A.TU_CodSolicitudExpediente				= COALESCE(@L_CodSolicitudExpediente, A.TU_CodSolicitudExpediente)
	AND		A.TU_CodLegajo							= @L_CodigoLegajo 

END
GO
