SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<03/09/2020>
-- Descripción :			<Consulta las actas de de notificacion dado un interviniete >
-- =================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarActasNotificacionPorInterviniente]
	@NumeroExpediente		char(14),
	@FechaInicio			datetime2(7)		= null,
	@FechaFin				datetime2(7)		= null,
	@CodigoLegajo			uniqueidentifier	= null,
	@CodigoInterviniente	uniqueidentifier	= null
AS 

BEGIN

	DECLARE	@L_NumeroExpediente		char(14)			=	@NumeroExpediente,
			@L_FechaInicio			datetime2(7)		=	@FechaInicio,	
			@L_FechaFin				datetime2(7)		=	@FechaFin,	
			@L_CodigoLegajo			uniqueidentifier	=	@CodigoLegajo,
			@L_CodigoInterviniente	uniqueidentifier	=	@CodigoInterviniente				

	IF @L_CodigoLegajo IS NULL
		SELECT		convert(varchar, AC.TF_FechaAsociacion, 3) + ' - ' + 'Acta de notificación - ' + 
							CASE WHEN EI.TC_TipoParticipacion = 'P' THEN
								TI.TC_Descripcion
							ELSE
								'REPRESENTANTE'
							END
							+ ' - ' +
							CASE WHEN P.TC_CodTipoPersona = 'F' THEN
								PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + PF.TC_SegundoApellido
							ELSE
								PJ.TC_Nombre
							END Descripcion,
							AC.TF_FechaAsociacion FechaCreacion,
							NULL ConsecutivoAsignado,
							convert(varchar(50), A.TU_CodArchivo) Identificador,
							AC.TU_CodArchivo ArchivoComunicado,
							AC.TU_CodComunicacion CodigoComunicacion,
							EA.TN_CodGrupoTrabajo	GrupoTrabajoDocumento,
							'Split' as Split,
							'N' Clasificacion,
							A.TN_CodEstado			Estado,
							'Split' as Split,
							EI.TU_CodInterviniente CodigoInterviniente,
							NULL CodigoLegajo
		FROM		Comunicacion.Comunicacion				C		WITH(NOLOCK)
		INNER JOIN	Comunicacion.ArchivoComunicacion		AC		WITH(NOLOCK)
		ON			C.TU_CodComunicacion					=		AC.TU_CodComunicacion
		INNER JOIN	Comunicacion.ComunicacionIntervencion	CI		WITH(NOLOCK)
		ON			CI.TU_CodComunicacion					=		C.TU_CodComunicacion
		INNER JOIN	Archivo.Archivo							A		WITH(NOLOCK)
		ON			AC.TU_CodArchivo						=		A.TU_CodArchivo
		INNER JOIN	Expediente.Expediente					E		WITH(NOLOCK)
		ON			C.TC_NumeroExpediente					=		E.TC_NumeroExpediente
		INNER JOIN	Expediente.ArchivoExpediente			EA		WITH(NOLOCK)
		ON		    A.TU_CodArchivo							=		EA.TU_CodArchivo
		INNER JOIN	Expediente.Intervencion					EI		WITH(NOLOCK)
		ON			EI.TU_CodInterviniente					=		CI.TU_CodInterviniente
		INNER JOIN	Persona.Persona							P		WITH(NOLOCK)
		ON			EI.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Expediente.Interviniente				EINT	WITH(NOLOCK)
		ON			EI.TU_CodInterviniente					=		EINT.TU_CodInterviniente
		LEFT JOIN	Persona.PersonaFisica					PF		WITH(NOLOCK)
		ON			PF.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Persona.PersonaJuridica					PJ		WITH(NOLOCK)
		ON			PJ.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Catalogo.TipoIntervencion				TI		WITH(NOLOCK)
		ON			EINT.TN_CodTipoIntervencion				=		TI.TN_CodTipoIntervencion
		INNER JOIN	Expediente.Resolucion					R		WITH(NOLOCK)
		ON			A.TU_CodArchivo							=		R.TU_CodArchivo
		INNER JOIN	Catalogo.Funcionario					F		WITH(NOLOCK)
		ON			F.TC_UsuarioRed							=		A.TC_UsuarioCrea
		WHERE		CI.TU_CodInterviniente					=		@L_CodigoInterviniente
		AND			AC.TB_EsActa							=		1
		AND			E.TC_NumeroExpediente					=		@L_NumeroExpediente
		AND			EA.TB_Eliminado							=		0
		AND			A.TF_FechaCrea							>=		COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
		AND			A.TF_FechaCrea							<=		COALESCE (@L_FechaFin,A.TF_FechaCrea)
		AND			A.TU_CodArchivo					   NOT IN		(SELECT LA.TU_CodArchivo
																	 FROM Expediente.LegajoArchivo LA
																	 WHERE LA.TU_CodArchivo = A.TU_CodArchivo)

	ELSE
	BEGIN
		SELECT		convert(varchar, AC.TF_FechaAsociacion, 3) + ' - ' + 'Acta de notificación - ' + 
							CASE WHEN EI.TC_TipoParticipacion = 'P' THEN
								TI.TC_Descripcion
							ELSE
								'REPRESENTANTE'
							END
							+ ' - ' +
							CASE WHEN P.TC_CodTipoPersona = 'F' THEN
								PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + PF.TC_SegundoApellido
							ELSE
								PJ.TC_Nombre
							END Descripcion,
							AC.TF_FechaAsociacion FechaCreacion,
							NULL ConsecutivoAsignado,
							convert(varchar(50), A.TU_CodArchivo) Identificador,
							AC.TU_CodArchivo ArchivoComunicado,
							AC.TU_CodComunicacion CodigoComunicacion,
							EA.TN_CodGrupoTrabajo	GrupoTrabajoDocumento,
							'Split' as Split,
							'N' Clasificacion,
							A.TN_CodEstado			Estado,
							'Split' as Split,
							EI.TU_CodInterviniente CodigoInterviniente,
							EL.TU_CodLegajo CodigoLegajo
		FROM		Comunicacion.Comunicacion				C		WITH(NOLOCK)
		INNER JOIN	Comunicacion.ArchivoComunicacion		AC		WITH(NOLOCK)
		ON			C.TU_CodComunicacion					=		AC.TU_CodComunicacion
		INNER JOIN	Comunicacion.ComunicacionIntervencion	CI		WITH(NOLOCK)
		ON			CI.TU_CodComunicacion					=		C.TU_CodComunicacion
		INNER JOIN	Archivo.Archivo							A		WITH(NOLOCK)
		ON			AC.TU_CodArchivo						=		A.TU_CodArchivo
		INNER JOIN	Expediente.Expediente					E		WITH(NOLOCK)
		ON			C.TC_NumeroExpediente					=		E.TC_NumeroExpediente
		INNER JOIN	Expediente.ArchivoExpediente			EA		WITH(NOLOCK)
		ON		    A.TU_CodArchivo							=		EA.TU_CodArchivo
		INNER JOIN	Expediente.LegajoArchivo				EL		WITH(NOLOCK)
		ON			A.TU_CodArchivo							=		EL.TU_CodArchivo
		INNER JOIN	Expediente.Intervencion					EI		WITH(NOLOCK)
		ON			EI.TU_CodInterviniente					=		CI.TU_CodInterviniente
		INNER JOIN	Persona.Persona							P		WITH(NOLOCK)
		ON			EI.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Expediente.Interviniente				EINT	WITH(NOLOCK)
		ON			EI.TU_CodInterviniente					=		EINT.TU_CodInterviniente
		LEFT JOIN	Persona.PersonaFisica					PF		WITH(NOLOCK)
		ON			PF.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Persona.PersonaJuridica					PJ		WITH(NOLOCK)
		ON			PJ.TU_CodPersona						=		P.TU_CodPersona
		LEFT JOIN	Catalogo.TipoIntervencion				TI		WITH(NOLOCK)
		ON			EINT.TN_CodTipoIntervencion				=		TI.TN_CodTipoIntervencion
		INNER JOIN	Expediente.Resolucion					R		WITH(NOLOCK)
		ON			A.TU_CodArchivo							=		R.TU_CodArchivo
		INNER JOIN	Catalogo.Funcionario					F		WITH(NOLOCK)
		ON			F.TC_UsuarioRed							=		A.TC_UsuarioCrea
		WHERE		CI.TU_CodInterviniente					=		@L_CodigoInterviniente
		AND			AC.TB_EsActa							=		1
		AND			E.TC_NumeroExpediente					=		@L_NumeroExpediente
		AND			EA.TB_Eliminado							=		0
		AND			A.TF_FechaCrea							>=		COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
		AND			A.TF_FechaCrea							<=		COALESCE (@L_FechaFin,A.TF_FechaCrea)
	END
END
GO
