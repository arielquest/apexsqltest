SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.3>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<05/12/2019>
-- Descripción:			<Permite consultar y armar una lista de resoluciones según los criterios establecidos>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><17-12-2019><Se agregan valores correspondientes al redactor>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><08-01-2020><Se ajusta consulta por observaciones en revision par>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jonathan Aguilar Navarro><22/04/2020><Se ajusta consulta para que solo reciba el número de expediente>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><18/08/2020><Se agrega parametro contexto para la busqueda de la variable de configuración>
-- ==================================================================================================================================================================================
-- Modificado por:		<Oscar Sánchez Hernández><20/07/2022><HU 264630- Se agrega parametro CodLegajo para la busqueda del recurso en el legajo del expediente>
-- ==================================================================================================================================================================================
-- Modificado por:		<Aaron Rios Retana><26/08/2022><Bug 274455- Se agrega en el where la validación por contexto, ya que estaba mostrando resoluciones de otros expedientes con el mismo número>
-- ==================================================================================================================================================================================
-- Modificado por:		<Aaron Rios Retana><29/08/2022><Bug 269091- Se agrega en el where la validación para que se muestren las resoluciones asociadas a un recurso que fue rechazado en el historial de itineraciones >
-- ==================================================================================================================================================================================
-- Modificado por:		<Aaron Rios Retana><01/09/2022><Bug 269091- Se agrega en el where la validación para que no se muestre la resolución que está asociada a un recurso rechazado, pero fue asignada a un recurso nuevo >
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarResolucionesRecursos]
(
	@NumeroExpediente			VARCHAR(14) = null,
	@CodContexto			    VARCHAR(4),
	@CodLegajo			UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
		DECLARE @L_NumeroExpediente				CHAR(14)			=	@NumeroExpediente
		DECLARE @L_CodEstadoItineracionRechazo	SMALLINT			=	(SELECT TC_Valor FROM Configuracion.ConfiguracionValor WITH(NOLOCK)	WHERE TC_CodConfiguracion = 'C_EstadoRechazoRecurso' and TC_CodContexto = @CodContexto)
		DECLARE @L_TU_CodLegajo					UNIQUEIDENTIFIER	=	@CodLegajo
		DECLARE @L_CodContexto					VARCHAR(4)			=	@CodContexto

	IF @L_TU_CodLegajo IS NULL
	BEGIN
		SELECT		
					DISTINCT r.TU_CodResolucion				AS		CodigoResolucion, 			   
					r.TC_NumeroExpediente					AS		NumeroExpediente,			  
					'splitOtros'							AS		splitOtros,
					r.TC_ObservacionSAS						AS		ObservacionesSAS,
					r.TC_UsuarioRedSAS						AS		UsuarioRedSAS, 
					r.TB_Relevante							AS		Relevante,
					r.TF_FechaEnvioSAS						AS		FechaEnvioSAS,
					r.TC_PorTanto							AS		PorTanto, 
					r.TC_Resumen							AS		Resumen,
					r.TF_FechaCreacion						AS		FechaCreacion, 
					r.TF_FechaResolucion					AS		FechaResolucion, 
					r.TB_DatoSensible						AS		DatoSensible, 
					r.TC_DescripcionSensible				AS		DescripcionSensible,
					r.TC_EstadoEnvioSAS						AS		EstadoEnvioSAS,
					c.TC_CodContexto 						AS		CodigoContexto,
					c.TC_Descripcion						AS		DescripcionContexto,
					r.TU_RedactorResponsable				AS		RedactorResponsable, 
					tr.TN_CodTipoResolucion					AS		CodigoTipoResolucion,
					tr.TC_Descripcion						AS		DescripcionTipoResolucion,
					rr.TN_CodResultadoResolucion			AS		CodigoResultadoResolucion,
					rr.TC_Descripcion						AS		DescripcionResultadoResolucion,			   			   			   			   
					r.TF_Actualizacion						AS		FechaActualizacion,
					cr.TN_CodCategoriaResolucion			AS		CodigoCategoriaResolucion,
					cr.TC_Descripcion						AS		DescripcionCategorioResolucion,			   
					aa.TU_CodArchivo						AS		CodigoArchivo, 
					aa.TC_Descripcion						AS		DescripcionArchivo,
					aa.TN_CodEstado							AS		EstadoArchivo,
					ls.TC_NumeroResolucion					AS		NumeroResolucion,
					cpt.TC_CodPuestoTrabajo					AS		CodigoPuestoTrabajo,
					fu.TC_Nombre							AS		NombreFuncionario,
					fu.TC_PrimerApellido					AS		PrimerApellidoFuncionario,
					fu.TC_SegundoApellido					AS		SegundoApellidoFuncionario
			   
		FROM		Expediente.Resolucion					r		
		LEFT JOIN	Expediente.RecursoExpediente			er	WITH(NOLOCK)
		ON			r.TU_CodResolucion						=	er.TU_CodResolucion
		LEFT JOIN	Historico.Itineracion					HI	WITH(NOLOCK)
		ON			HI.TU_CodRegistroItineracion			=	ER.TU_CodRecurso
		AND			HI.TN_CodEstadoItineracion				=	@L_CodEstadoItineracionRechazo
		INNER JOIN	Catalogo.Contexto						c	WITH(NOLOCK)
		ON			c.TC_CodContexto						=	r.TC_CodContexto
		INNER JOIN	Catalogo.TipoResolucion					tr	WITH(NOLOCK)
		ON			r.TN_CodTipoResolucion					=	tr.TN_CodTipoResolucion
		INNER JOIN	Catalogo.ResultadoResolucion			rr	WITH(NOLOCK)
		ON			r.TN_CodResultadoResolucion				=	rr.TN_CodResultadoResolucion
		LEFT JOIN	Catalogo.CategoriaResolucion			cr	WITH(NOLOCK)
		ON			r.TN_CodCategoriaResolucion				=	cr.TN_CodCategoriaResolucion
		INNER JOIN	Expediente.ArchivoExpediente			a	WITH(NOLOCK)
		ON			r.TU_CodArchivo							=	a.TU_CodArchivo
		AND			R.TU_CodArchivo							NOT IN 
															(SELECT LA.TU_CodArchivo  
															FROM Expediente.LegajoArchivo LA 
															where TC_NumeroExpediente = R.TC_NumeroExpediente)
		INNER JOIN	Catalogo.PuestoTrabajoFuncionario		cptf	WITH(NOLOCK)
		ON			r.TU_RedactorResponsable				= cptf.TU_CodPuestoFuncionario
		INNER JOIN	Catalogo.PuestoTrabajo cpt				WITH(NOLOCK)
		ON			cptf.TC_CodPuestoTrabajo				= cpt.TC_CodPuestoTrabajo
		INNER JOIN	Catalogo.Funcionario					fu	WITH(NOLOCK)
		ON			fu.TC_UsuarioRed						= cptf.TC_UsuarioRed
		LEFT JOIN	Expediente.LibroSentencia				ls	WITH(NOLOCK)
		ON			r.TU_CodResolucion						= ls.TU_CodResolucion
		INNER JOIN	Expediente.ArchivoExpediente			ae	WITH(NOLOCK)
		ON			r.TU_CodArchivo							= ae.TU_CodArchivo		
		INNER JOIN	Archivo.Archivo							aa	WITH(NOLOCK) 
		ON			ae.TU_CodArchivo						= aa.TU_CodArchivo 
		AND			aa.TN_CodEstado							= 4
				
		WHERE	  r.TC_NumeroExpediente						= @L_NumeroExpediente		
		AND		  r.TC_CodContexto							= @L_CodContexto
		-- Para que se muestren las resoluciones que no tienen asociadas un recurso o que el recurso asociado fue rechazado
		AND		(ER.TU_CodResolucion						IS NULL 
		OR		ER.TN_CodEstadoItineracion					= @L_CodEstadoItineracionRechazo)
		-- para que no se muestre la resolución que está asociada a un recurso rechazado, pero fue asignada a un recurso nuevo
		AND		AA.TU_CodArchivo							NOT IN 
															(select R.TU_CodArchivo 
															from Expediente.RecursoExpediente RE		WITH(NOLOCK)
															INNER JOIN Expediente.Resolucion R			WITH(NOLOCK)
															ON	RE.TU_CodResolucion = R.TU_CodResolucion
															INNER JOIN Expediente.ArchivoExpediente A	WITH(NOLOCK)
															ON	R.TU_CodArchivo = A.TU_CodArchivo 
															where RE.TN_CodEstadoItineracion <> @L_CodEstadoItineracionRechazo)
		AND		ER.TU_CodLegajo								IS	NULL
	END
  ELSE
    BEGIN
			SELECT	  
					DISTINCT r.TU_CodResolucion				AS		CodigoResolucion, 			   
					r.TC_NumeroExpediente					AS		NumeroExpediente,			  
					'splitOtros'							AS		splitOtros,
					r.TC_ObservacionSAS						AS		ObservacionesSAS,
					r.TC_UsuarioRedSAS						AS		UsuarioRedSAS, 
					r.TB_Relevante							AS		Relevante,
					r.TF_FechaEnvioSAS						AS		FechaEnvioSAS,
					r.TC_PorTanto							AS		PorTanto, 
					r.TC_Resumen							AS		Resumen,
					r.TF_FechaCreacion						AS		FechaCreacion, 
					r.TF_FechaResolucion					AS		FechaResolucion, 
					r.TB_DatoSensible						AS		DatoSensible, 
					r.TC_DescripcionSensible				AS		DescripcionSensible,
					r.TC_EstadoEnvioSAS						AS		EstadoEnvioSAS,
					c.TC_CodContexto 						AS		CodigoContexto,
					c.TC_Descripcion						AS		DescripcionContexto,
					r.TU_RedactorResponsable				AS		RedactorResponsable, 
					tr.TN_CodTipoResolucion					AS		CodigoTipoResolucion,
					tr.TC_Descripcion						AS		DescripcionTipoResolucion,
					rr.TN_CodResultadoResolucion			AS		CodigoResultadoResolucion,
					rr.TC_Descripcion						AS		DescripcionResultadoResolucion,			   			   			   			   
					r.TF_Actualizacion						AS		FechaActualizacion,
					cr.TN_CodCategoriaResolucion			AS		CodigoCategoriaResolucion,
					cr.TC_Descripcion						AS		DescripcionCategorioResolucion,			   
					aa.TU_CodArchivo						AS		CodigoArchivo, 
					aa.TC_Descripcion						AS		DescripcionArchivo,
					aa.TN_CodEstado							AS		EstadoArchivo,
					ls.TC_NumeroResolucion					AS		NumeroResolucion,
					cpt.TC_CodPuestoTrabajo					AS		CodigoPuestoTrabajo,
					fu.TC_Nombre							AS		NombreFuncionario,
					fu.TC_PrimerApellido					AS		PrimerApellidoFuncionario,
					fu.TC_SegundoApellido					AS		SegundoApellidoFuncionario
			   
		FROM		Expediente.Resolucion R		
		LEFT JOIN	Expediente.RecursoExpediente			ER	WITH(NOLOCK)
		ON			r.TU_CodResolucion						=	er.TU_CodResolucion 
		INNER JOIN	Catalogo.Contexto						C WITH(NOLOCK)
		ON			C.TC_CodContexto							= R.TC_CodContexto
		INNER JOIN	Catalogo.TipoResolucion					tr WITH(NOLOCK)
		ON			r.TN_CodTipoResolucion					= tr.TN_CodTipoResolucion
		INNER JOIN	Catalogo.ResultadoResolucion rr			WITH(NOLOCK)
		ON			r.TN_CodResultadoResolucion				= rr.TN_CodResultadoResolucion
		LEFT JOIN	Catalogo.CategoriaResolucion cr			WITH(NOLOCK)
		ON			r.TN_CodCategoriaResolucion				= cr.TN_CodCategoriaResolucion
		INNER JOIN	Expediente.ArchivoExpediente a			WITH(NOLOCK)
		ON			r.TU_CodArchivo							= a.TU_CodArchivo
		INNER JOIN	Catalogo.PuestoTrabajoFuncionario cptf  WITH(NOLOCK)
		ON			r.TU_RedactorResponsable					= cptf.TU_CodPuestoFuncionario
		INNER JOIN	Catalogo.PuestoTrabajo cpt				WITH(NOLOCK)
		ON			cptf.TC_CodPuestoTrabajo					= cpt.TC_CodPuestoTrabajo
		INNER JOIN	Catalogo.Funcionario fu					WITH(NOLOCK)
		ON			fu.TC_UsuarioRed							= cptf.TC_UsuarioRed
		LEFT JOIN	Expediente.LibroSentencia ls			WITH(NOLOCK)
		ON			r.TU_CodResolucion						= ls.TU_CodResolucion
		INNER JOIN	Expediente.LegajoArchivo la				WITH(NOLOCK)
		ON			r.TU_CodArchivo							= la.TU_CodArchivo		
		INNER JOIN	Archivo.Archivo aa						WITH(NOLOCK) 
		ON			la.TU_CodArchivo							= aa.TU_CodArchivo 
		AND			aa.TN_CodEstado							= 4
				
		WHERE		r.TC_NumeroExpediente					= @L_NumeroExpediente
		AND			r.TC_CodContexto						= @L_CodContexto
		AND			la.TU_CodLegajo                         = @L_TU_CodLegajo
		-- Para que se muestren las resoluciones que no tienen asociadas un recurso o que el recurso asociado fue rechazado
		AND		(ER.TU_CodResolucion						IS NULL 
		OR		ER.TN_CodEstadoItineracion					= @L_CodEstadoItineracionRechazo)
		-- para que no se muestre la resolución que está asociada a un recurso rechazado, pero fue asignada a un recurso nuevo
		AND		AA.TU_CodArchivo							NOT IN 
															(select R.TU_CodArchivo 
															from Expediente.RecursoExpediente RE		WITH(NOLOCK)
															INNER JOIN Expediente.Resolucion R			WITH(NOLOCK)
															ON	RE.TU_CodResolucion				= R.TU_CodResolucion
															INNER JOIN Expediente.ArchivoExpediente AE	WITH(NOLOCK)
															ON	R.TU_CodArchivo					= AE.TU_CodArchivo 
															INNER JOIN Expediente.LegajoArchivo LA		WITH(NOLOCK)
															ON	AE.TU_CodArchivo				=	LA.TU_CodArchivo 
															where RE.TN_CodEstadoItineracion	<> @L_CodEstadoItineracionRechazo)
	END

END
GO
