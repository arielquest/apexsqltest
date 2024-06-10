SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================================================================================
-- Versión:				<1.2>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<15/11/2019>
-- Descripción:			<Permite listar los recursos del expediente>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><04-12-2019><Se realiza inclusión de los valores de Oficina destino y se valida valores devueltos>
-- Modificado por:		<Jose Gabriel Cordero Soto><16-01-2019><Se realiza ajuste y se incluyen campos en consulta para la resolucion a mostrar>
-- Modificado por:		<Jose Gabriel Cordero Soto><16-01-2019><Se ajusta procedimiento para poder enviar fecha envio y fecha recepcion del recurso>
-- Modificado por:		<Jonathan Aguilar Navarro><07/05/2020><Se agrega a la consulta el codigo de contexto origen.>
-- Modificación:		<Aida E Siles R> <26/02/2021> <Se agrega el número de expediente en el join con tabla Expediente.ArchivoExpediente, ya que se presentaban registros duplicados>
-- Modificación:		<Jose Gabriel Cordero Soto><13/08/2021><Se agrega descripcion del resultado del recurso para mostrarse en listado de recursos de un expediente>
-- Modificación:		<Aarón Ríos Retana><18/07/2022><HU 264789 - Se modifica para habilitar la consulta de los legajos>
-- Modificación:		<Aarón Ríos Retana><18/07/2022><Bug 269091 - Se modifica para obtener de manera correcta el estado de la itineración>
-- Modificación:		<Aarón Ríos Retana><15/11/2022><Version 2.3.0.0 - Se modifica para obtener el código del legajo asociado al recurso>
-- ==================================================================================================================================================================================

CREATE PROCEDURE		[Expediente].[PA_ConsultarRecursoExpediente]
@NumeroExpediente	CHAR(14) = NULL,
@CodLegajo			UNIQUEIDENTIFIER = NULL
AS
BEGIN
	--Variables	
	DECLARE @L_TC_NumeroExpediente		CHAR(14)				= @NumeroExpediente
DECLARE @L_TU_CodLegajo				UNIQUEIDENTIFIER		= @CodLegajo

	--Lógica
	IF @L_TU_CodLegajo IS NULL
	BEGIN
		SELECT	
						A.TU_CodRecurso					Codigo,
						A.TF_Fecha_Creacion				FechaCreacion,
						'splitOtros'					splitOtros,
						A.TU_CodLegajo					CodigoLegajo,
						A.TF_Fecha_Envio				FechaEnvio,
						A.TF_Fecha_Recepcion			FechaRecepcion,
						A.TU_CodHistoricoItineracion	CodHistoricoItineracion,
						A.TU_CodResultadoRecurso		CodResultadoRecurso,
						Y.TN_CodResultadoLegajo			CodigoTipoResultadoRecurso,
						Y.TC_Descripcion				DescripcionTipoResultadoRecurso,
						B.TN_CodClaseAsunto				CodigoClase,
						B.TC_Descripcion				DescripcionClase,
						M.TC_CodContexto				CodigoContextoOrigen,
						M.TC_Descripcion				DescripcionContextoOrigen,		
						C.TC_CodContexto				CodigoContextoDestino,
						C.TC_Descripcion				DescripcionContextoDestino,					
						I.TC_CodOficina					OficinaDestino,
						I.TC_Nombre						DescripcionOficina,
						D.TN_CodTipoIntervencion		CodigoTipoIntervencion,
						D.TC_Descripcion				DescripcionTipoIntervencion,					
						E.TC_NumeroExpediente			NumeroExpediente,
						E.TC_Descripcion				DescripcionExpediente,								
						G.TN_CodMotivoItineracion		CodigoMotivoItineracion,
						G.TC_Descripcion				DescripcionMotivoItineracion,					
						H.TN_CodEstadoItineracion		CodigoEstadoItineracion,
						H.TC_Descripcion				DescripcionEstadoItineracion,
						J.TU_CodArchivo					CodigoArchivo, 
					    J.TC_Descripcion				DescripcionArchivo,
					    J.TN_CodEstado					EstadoArchivo,
						UPPER(FU.TC_Nombre)				NombreFuncionario,
						UPPER(FU.TC_PrimerApellido)		PrimerApellidoFuncionario,
						UPPER(FU.TC_SegundoApellido)	SegundoApellidoFuncionario,
						F.TU_CodResolucion				CodigoResolucion,
						F.TC_DescripcionSensible		DescripcionSensible,					
						F.TF_FechaResolucion			FechaResolucion,
						TR.TN_CodTipoResolucion			CodigoTipoResolucion,
						TR.TC_Descripcion				DescripcionTipoResolucion,
						RR.TN_CodResultadoResolucion    CodigoResultadoResolucion,
						UPPER(RR.TC_Descripcion)		DescripcionResultadoResolucion,
						L.TC_NumeroResolucion			NumeroResolucion
						

		FROM			Expediente.RecursoExpediente			A WITH(NOLOCK)
		LEFT JOIN		Catalogo.ClaseAsunto B 
		ON				A.TN_CodClaseAsunto					  = B.TN_CodClaseAsunto

		LEFT JOIN		Catalogo.Contexto						C WITH(NOLOCK)	
		ON				A.TC_CodContextoDestino				  = C.TC_CodContexto

		LEFT JOIN		Catalogo.Oficina						I WITH(NOLOCK)
		ON				C.TC_CodOficina					  	  = I.TC_CodOficina	

		LEFT JOIN		Catalogo.TipoIntervencion				D WITH(NOLOCK)	
		ON				A.TN_CodTipoIntervencion			  = D.TN_CodTipoIntervencion

		LEFT JOIN		Expediente.Expediente					E WITH(NOLOCK)	
		ON				A.TC_NumeroExpediente				  = E.TC_NumeroExpediente

		LEFT JOIN		Expediente.Resolucion					F WITH(NOLOCK)	
		ON				A.TU_CodResolucion					  = F.TU_CodResolucion

		LEFT JOIN		Expediente.LibroSentencia				L WITH(NOLOCK)
		ON				L.TU_CodResolucion					  = F.TU_CodResolucion

		LEFT JOIN		Catalogo.TipoResolucion					TR WITH(NOLOCK)	
		ON				F.TN_CodTipoResolucion				  = TR.TN_CodTipoResolucion

		LEFT JOIN		Catalogo.ResultadoResolucion			RR WITH(NOLOCK)	
		ON				F.TN_CodResultadoResolucion			  = RR.TN_CodResultadoResolucion

		LEFT JOIN		Catalogo.PuestoTrabajoFuncionario       PTF WITH(NOLOCK)  
		ON				F.TU_RedactorResponsable			  = PTF.TU_CodPuestoFuncionario

		LEFT JOIN       Catalogo.Funcionario				    FU  WITH(NOLOCK)
		ON				PTF.TC_UsuarioRed					  = FU.TC_UsuarioRed	

		LEFT JOIN		Expediente.ArchivoExpediente			K WITH(NOLOCK)
		ON				F.TU_CodArchivo						  = K.TU_CodArchivo
		AND				K.TC_NumeroExpediente				  = @L_TC_NumeroExpediente
			
		LEFT JOIN		Archivo.Archivo							J WITH(NOLOCK) 
		ON				K.TU_CodArchivo						  = J.TU_CodArchivo

		LEFT JOIN		Catalogo.MotivoItineracion				G WITH(NOLOCK)		   
		ON				A.TN_CodMotivoItineracion			  = G.TN_CodMotivoItineracion	

		LEFT JOIN		Catalogo.EstadoItineracion				H WITH(NOLOCK)	
		ON				H.TN_CodEstadoItineracion			  =	A.TN_CodEstadoItineracion

		INNER JOIN		Catalogo.Contexto						M WITH(NOLOCK)	
		ON				A.TC_CodContextoOrigen				  = M.TC_CodContexto

		LEFT JOIN		Expediente.ResultadoRecurso				Z WITH(NOLOCK)
		ON				Z.TU_CodResultadoRecurso				= A.TU_CodResultadoRecurso

		LEFT JOIN		Catalogo.ResultadoLegajo				Y WITH(NOLOCK)
		ON				Y.TN_CodResultadoLegajo					= Z.TN_CodResultadoLegajo

		WHERE	  	    A.TC_NumeroExpediente					= @L_TC_NumeroExpediente
		AND				A.TU_CodLegajo							IS NULL
		END
	ELSE
	BEGIN
		SELECT	
						A.TU_CodRecurso					Codigo,
						A.TF_Fecha_Creacion				FechaCreacion,					
						'splitOtros'					splitOtros,
						A.TU_CodLegajo					CodigoLegajo,
						A.TF_Fecha_Envio				FechaEnvio,
						A.TF_Fecha_Recepcion			FechaRecepcion,
						A.TU_CodHistoricoItineracion	CodHistoricoItineracion,
						A.TU_CodResultadoRecurso		CodResultadoRecurso,
						Y.TN_CodResultadoLegajo			CodigoTipoResultadoRecurso,
						Y.TC_Descripcion				DescripcionTipoResultadoRecurso,
						B.TN_CodClaseAsunto				CodigoClase,
						B.TC_Descripcion				DescripcionClase,
						M.TC_CodContexto				CodigoContextoOrigen,
						M.TC_Descripcion				DescripcionContextoOrigen,		
						C.TC_CodContexto				CodigoContextoDestino,
						C.TC_Descripcion				DescripcionContextoDestino,					
						I.TC_CodOficina					OficinaDestino,
						I.TC_Nombre						DescripcionOficina,
						D.TN_CodTipoIntervencion		CodigoTipoIntervencion,
						D.TC_Descripcion				DescripcionTipoIntervencion,					
						E.TC_NumeroExpediente			NumeroExpediente,
						E.TC_Descripcion				DescripcionExpediente,								
						G.TN_CodMotivoItineracion		CodigoMotivoItineracion,
						G.TC_Descripcion				DescripcionMotivoItineracion,					
						H.TN_CodEstadoItineracion		CodigoEstadoItineracion,
						H.TC_Descripcion				DescripcionEstadoItineracion,
						J.TU_CodArchivo					CodigoArchivo, 
					    J.TC_Descripcion				DescripcionArchivo,
					    J.TN_CodEstado					EstadoArchivo,
						UPPER(FU.TC_Nombre)				NombreFuncionario,
						UPPER(FU.TC_PrimerApellido)		PrimerApellidoFuncionario,
						UPPER(FU.TC_SegundoApellido)	SegundoApellidoFuncionario,
						F.TU_CodResolucion				CodigoResolucion,
						F.TC_DescripcionSensible		DescripcionSensible,					
						F.TF_FechaResolucion			FechaResolucion,
						TR.TN_CodTipoResolucion			CodigoTipoResolucion,
						TR.TC_Descripcion				DescripcionTipoResolucion,
						RR.TN_CodResultadoResolucion    CodigoResultadoResolucion,
						UPPER(RR.TC_Descripcion)		DescripcionResultadoResolucion,
						L.TC_NumeroResolucion			NumeroResolucion
						

		FROM			Expediente.RecursoExpediente			A WITH(NOLOCK)
		LEFT JOIN		Catalogo.ClaseAsunto B 
		ON				A.TN_CodClaseAsunto					  = B.TN_CodClaseAsunto

		LEFT JOIN		Catalogo.Contexto						C WITH(NOLOCK)	
		ON				A.TC_CodContextoDestino				  = C.TC_CodContexto

		LEFT JOIN		Catalogo.Oficina						I WITH(NOLOCK)
		ON				C.TC_CodOficina					  	  = I.TC_CodOficina	

		LEFT JOIN		Catalogo.TipoIntervencion				D WITH(NOLOCK)	
		ON				A.TN_CodTipoIntervencion			  = D.TN_CodTipoIntervencion

		LEFT JOIN		Expediente.Expediente					E WITH(NOLOCK)	
		ON				A.TC_NumeroExpediente				  = E.TC_NumeroExpediente

		LEFT JOIN		Expediente.Resolucion					F WITH(NOLOCK)	
		ON				A.TU_CodResolucion					  = F.TU_CodResolucion

		LEFT JOIN		Expediente.LibroSentencia				L WITH(NOLOCK)
		ON				L.TU_CodResolucion					  = F.TU_CodResolucion

		LEFT JOIN		Catalogo.TipoResolucion					TR WITH(NOLOCK)	
		ON				F.TN_CodTipoResolucion				  = TR.TN_CodTipoResolucion

		LEFT JOIN		Catalogo.ResultadoResolucion			RR WITH(NOLOCK)	
		ON				F.TN_CodResultadoResolucion			  = RR.TN_CodResultadoResolucion

		LEFT JOIN		Catalogo.PuestoTrabajoFuncionario       PTF WITH(NOLOCK)  
		ON				F.TU_RedactorResponsable			  = PTF.TU_CodPuestoFuncionario

		LEFT JOIN       Catalogo.Funcionario				    FU  WITH(NOLOCK)
		ON				PTF.TC_UsuarioRed					  = FU.TC_UsuarioRed	

		LEFT JOIN		Expediente.ArchivoExpediente			K WITH(NOLOCK)
		ON				F.TU_CodArchivo						  = K.TU_CodArchivo
		AND				K.TC_NumeroExpediente				  = @L_TC_NumeroExpediente
			
		LEFT JOIN		Archivo.Archivo							J WITH(NOLOCK) 
		ON				K.TU_CodArchivo						  = J.TU_CodArchivo

		LEFT JOIN		Catalogo.MotivoItineracion				G WITH(NOLOCK)		   
		ON				A.TN_CodMotivoItineracion			  = G.TN_CodMotivoItineracion	

		LEFT JOIN		Catalogo.EstadoItineracion				H WITH(NOLOCK)	
		ON				H.TN_CodEstadoItineracion			  =	A.TN_CodEstadoItineracion

		INNER JOIN		Catalogo.Contexto						M WITH(NOLOCK)	
		ON				A.TC_CodContextoOrigen				  = M.TC_CodContexto

		LEFT JOIN		Expediente.ResultadoRecurso				Z WITH(NOLOCK)
		ON				Z.TU_CodResultadoRecurso				= A.TU_CodResultadoRecurso

		LEFT JOIN		Catalogo.ResultadoLegajo				Y WITH(NOLOCK)
		ON				Y.TN_CodResultadoLegajo					= Z.TN_CodResultadoLegajo

		WHERE	  	    A.TU_CodLegajo							= @L_TU_CodLegajo
	END
	
END
GO
