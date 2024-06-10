SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==============================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<09/06/2020>
-- Descripción:				<Permite consultar los documentos asociados a las intervenciones de un legajo o expediente en el historial procesal>
-- ==============================================================================================================================================================
-- Modificar por:			<Jose Gabriel Cordero Soto><16-03-2021><Se ajusta consulta de documentos sobre las intervenciones para delimitar si es para legajo
--																	o es para expediente, ademas de reorganizar el código del procedimiento almacenado>
-- Modificar por:			<Ronny Ramírez R.><12-04-2021><Se completa consulta de documentos sobre las intervenciones, pues solo estaba la parte de las actas>
-- Modificar por:			<Ronny Ramírez R.><21-04-2021><Se elimina la fecha que se asociaba a las actas de notificación para evitar que saliera duplicada en
--												la interfaz, además se pone un DISTINCT a la consulta de documentos para que no salgan duplicados>
-- Modificar por:			<Ronny Ramírez R.><21-04-2021><Se corrige consulta de documentos del legajo pues no se estaba filtrando por intervinientes>
-- Modificar por:			<Ronny Ramírez R.><31-03-2023><Se agrega filtro por estado, y se corrige consulta para evitar producto cartesiano por intervinientes>
-- ==============================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarDocIntervinientesHistorialProcesal]
(
	@NumeroExpediente		char(14)							= NULL,
	@UsuarioCrea			varchar(30),
	@ListaLegajo			Expediente.ListaLegajosType			READONLY,
	@ListaIntervinientes	Expediente.ListaIntervinientesType  READONLY,
	@EstadoDocumento		tinyint								= NULL
)
AS
BEGIN	

--************************************************************************************************************
--DEFINICION DE VARIABLES Y TABLAS TEMPORALES

DECLARE	@L_NumeroExpediente			CHAR(14)				= @NumeroExpediente,
@L_UsuarioCrea				varchar(30)				= @UsuarioCrea,
@L_EstadoDocumento			tinyint					= @EstadoDocumento

Declare	@Result Table
(
		Descripcion						varchar(MAX)		NOT NULL,
		Clasificacion					Char(1)				NOT NULL,
		FechaCreacion					Datetime2(7)		NOT NULL,
		ConsecutivoAsignado				Int					NULL,
		Identificador					varchar(50)			NOT NULL,
		Estado							tinyint				NULL,
		GrupoTrabajoDocumento			smallint			NULL,
		UsuarioCrea						varchar(30)			NULL,
		CodigoInterviniente				uniqueidentifier	NULL,
		CodigoLegajo					uniqueidentifier	NULL,
		ArchivoComunicado				uniqueidentifier	NULL,
		CodigoComunicacion				uniqueidentifier	NULL
)
		

--************************************************************************************************************
-- CONSULTA DE DOCUMENTOS ASOCIADOS A INTERVENCIONES DE UN LEGAJO

IF((SELECT COUNT(*) FROM @ListaLegajo) > 0)
	BEGIN

			--************************************************************************************************************************
			-- INSERCION DE DATOS PARA CONSULTA FINAL

			--INSERCICIONES SOBRE TABLA TEMPORAL FINAL
			INSERT INTO	@Result
			(
				Descripcion,
				Clasificacion,
				FechaCreacion,
				ConsecutivoAsignado,
				Identificador,
				Estado,
				GrupoTrabajoDocumento,
				UsuarioCrea
			)				
			-- CONSULTA DE DOCUMENTOS TOTALES
			SELECT		DISTINCT A.TC_Descripcion,
						'D',
						A.TF_FechaCrea,
						B.TN_Consecutivo,
						convert(varchar(50), B.TU_CodArchivo),
						A.TN_CodEstado,
						B.TN_CodGrupoTrabajo,
						A.TC_UsuarioCrea
			FROM		Archivo.Archivo								A	WITH(NOLOCK)
			INNER JOIN	Expediente.ArchivoExpediente				B	WITH(NOLOCK)
			ON			B.TU_CodArchivo						     	=	A.TU_CodArchivo
			INNER JOIN	Expediente.LegajoArchivo					C	WITH(NOLOCK)
			ON			C.TU_CodArchivo							    =	A.TU_CodArchivo
			AND			C.TU_CodLegajo								IN  (SELECT TU_CodLegajo FROM @ListaLegajo)
			INNER JOIN	Expediente.Expediente						D	WITH(NOLOCK)
			ON			D.TC_NumeroExpediente						=	B.TC_NumeroExpediente			
			INNER JOIN	Expediente.IntervencionArchivo				Y	WITH(NOLOCK)
			ON			Y.TU_CodArchivo								=   C.TU_CodArchivo
			AND			Y.TU_CodInterviniente						IN  (SELECT TU_CodInterviniente FROM @ListaIntervinientes)
			WHERE		B.TC_NumeroExpediente						=	@L_NumeroExpediente
			AND			A.TN_CodEstado								=  COALESCE (@L_EstadoDocumento, A.TN_CodEstado)
					
			--INSERCICIONES SOBRE TABLA TEMPORAL FINAL
			INSERT INTO	@Result
			(
				Descripcion,
				Clasificacion,
				FechaCreacion,
				ConsecutivoAsignado,
				Identificador,
				CodigoInterviniente,
				CodigoComunicacion
			)	
			--SE INSERTAN ACTAS DE NOTIFICACION CON BASE EN LOS DOCUMENTOS INSERTADOS Y QUE SEAN DE TIPO RESOLUCION			
			SELECT		'Acta de notificación - ' + 
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
						END,
						'N',
						AC.TF_FechaAsociacion,
						NULL,
						convert(varchar(50), A.TU_CodArchivo),
						EI.TU_CodInterviniente,
						AC.TU_CodComunicacion
			FROM		Comunicacion.Comunicacion				C		WITH(NOLOCK)
			INNER JOIN	Comunicacion.ArchivoComunicacion		AC		WITH(NOLOCK)
			ON			C.TU_CodComunicacion					=		AC.TU_CodComunicacion
			INNER JOIN  @Result									RES
			ON			AC.TU_CodArchivo						=		RES.Identificador
			AND			RES.Clasificacion						=		'D'
			LEFT JOIN	Archivo.Archivo							AR		WITH(NOLOCK)
			ON			AC.TU_CodArchivo						=		AR.TU_CodArchivo
			INNER JOIN	Comunicacion.ComunicacionIntervencion	CI		WITH(NOLOCK)
			ON			CI.TU_CodComunicacion					=		C.TU_CodComunicacion
			INNER JOIN	Expediente.Intervencion					EI		WITH(NOLOCK)
			ON			EI.TU_CodInterviniente					=		CI.TU_CodInterviniente
			LEFT JOIN	Expediente.Interviniente				EINT	WITH(NOLOCK)
			ON			EI.TU_CodInterviniente					=		EINT.TU_CodInterviniente
			LEFT JOIN	Catalogo.TipoIntervencion				TI		WITH(NOLOCK)
			ON			EINT.TN_CodTipoIntervencion				=		TI.TN_CodTipoIntervencion
			INNER JOIN	Persona.Persona							P		WITH(NOLOCK)
			ON			EI.TU_CodPersona						=		P.TU_CodPersona
			LEFT JOIN	Persona.PersonaFisica					PF		WITH(NOLOCK)
			ON			PF.TU_CodPersona						=		P.TU_CodPersona
			LEFT JOIN	Persona.PersonaJuridica					PJ		WITH(NOLOCK)
			ON			PJ.TU_CodPersona						=		P.TU_CodPersona
			INNER JOIN	Archivo.Archivo							A		WITH(NOLOCK)
			ON			AC.TU_CodArchivo						=		A.TU_CodArchivo
			INNER JOIN	Expediente.Expediente					E		WITH(NOLOCK)
			ON			C.TC_NumeroExpediente					=		E.TC_NumeroExpediente
			INNER JOIN	Expediente.Resolucion					R		WITH(NOLOCK)
			ON			A.TU_CodArchivo							=		R.TU_CodArchivo
			WHERE		C.TC_NumeroExpediente					=		@L_NumeroExpediente
			AND			AC.TB_EsActa							=		1
			AND			EI.TU_CodInterviniente					IN	   (SELECT TU_CodInterviniente FROM @ListaIntervinientes)

			--************************************************************************************************************************
			--SE REALIZA ACTUALIZACIONES DE DATOS EN TABLA FINAL DE RESULTADOS

			--Se actualiza el documento padre del acta de notificacion
			UPDATE			A
			SET				A.ArchivoComunicado					= B.TU_CodArchivo
			FROM			@Result								A
			INNER JOIN		Comunicacion.ArchivoComunicacion	B WITH(NOLOCK)
			ON				A.CodigoComunicacion				= B.TU_CodComunicacion
			WHERE			A.Clasificacion						= 'N'
			AND				B.TB_EsPrincipal					= 1

			--Se actualiza la descripcion del elemento de historial procesal en caso de que tenga intervenciones 
			UPDATE		A
			SET			A.Descripcion	= B.Descripcion
			FROM		@Result			A
			INNER JOIN	(
						SELECT				A.Descripcion + ' - ' + F.NOMBRE Descripcion,
											A.Identificador
						FROM				@Result				A
						OUTER APPLY			(
											SELECT TOP (1)
											CASE WHEN C.TC_TipoParticipacion = 'P' THEN
													TI.TC_Descripcion
													ELSE
														'REPRESENTANTE'
													END
													+ ' - ' +
													ISNULL
													(
														ISNULL(
															D.TC_Nombre 
															+ ' ' + 
															D.TC_PrimerApellido + ' ' 
															+ ISNULL(D.TC_SegundoApellido, ''), E.TC_Nombre), '') NOMBRE
															FROM			Expediente.IntervencionArchivo	B WITH(NOLOCK)
															INNER JOIN		Expediente.LegajoArchivo		LA
															ON				B.TU_CodArchivo					= LA.TU_CodArchivo
															INNER JOIN		Expediente.Intervencion			C WITH(NOLOCK)
															ON				C.TU_CodInterviniente			= B.TU_CodInterviniente
															LEFT JOIN		Expediente.Interviniente		EI WITH(NOLOCK)
															ON				C.TU_CodInterviniente			= EI.TU_CodInterviniente
															LEFT JOIN		Catalogo.TipoIntervencion		TI WITH(NOLOCK)
															ON				EI.TN_CodTipoIntervencion		= TI.TN_CodTipoIntervencion
															LEFT JOIN		Persona.PersonaFisica			D WITH(NOLOCK)
															ON				D.TU_CodPersona					= C.TU_CodPersona
															LEFT JOIN		Persona.PersonaJuridica			E WITH(NOLOCK)
															ON				E.TU_CodPersona					= C.TU_CodPersona
															WHERE			B.TU_CodArchivo					= A.Identificador
														) F
								)				B
					On			B.Identificador	=	A.Identificador
					AND			B.Descripcion	IS NOT NULL
					WHERE		A.Clasificacion = 'D'
	END
ELSE
	BEGIN
			IF(@L_NumeroExpediente IS NOT NULL)
				BEGIN
						--************************************************************************************************************************
						-- INSERCION DE DATOS PARA CONSULTA FINAL
						INSERT INTO	@Result
						(
							Descripcion,
							Clasificacion,
							FechaCreacion,
							ConsecutivoAsignado,
							Identificador,
							Estado,
							GrupoTrabajoDocumento,
							UsuarioCrea
						)				
						-- CONSULTA DE DOCUMENTOS TOTALES
						SELECT		DISTINCT A.TC_Descripcion,
									'D',
									A.TF_FechaCrea,
									B.TN_Consecutivo,
									convert(varchar(50), B.TU_CodArchivo),
									A.TN_CodEstado,
									B.TN_CodGrupoTrabajo,
									A.TC_UsuarioCrea
						FROM		Archivo.Archivo								A	WITH(NOLOCK)
						INNER JOIN	Expediente.ArchivoExpediente				B	WITH(NOLOCK)
						ON			B.TU_CodArchivo						     	=	A.TU_CodArchivo
						INNER JOIN	Expediente.Expediente						D	WITH(NOLOCK)
						ON			D.TC_NumeroExpediente						=	B.TC_NumeroExpediente
						INNER JOIN	Expediente.IntervencionArchivo				Y	WITH(NOLOCK)						
						ON			Y.TU_CodArchivo								=	A.TU_CodArchivo
						AND			Y.TU_CodInterviniente						IN (SELECT TU_CodInterviniente FROM @ListaIntervinientes)
						WHERE		B.TC_NumeroExpediente						=	@L_NumeroExpediente
						AND			A.TN_CodEstado								=  COALESCE (@L_EstadoDocumento, A.TN_CodEstado)
						AND			A.TU_CodArchivo	NOT IN						(SELECT TU_CodArchivo 
																						FROM Expediente.LegajoArchivo 
																						WHERE TU_CodArchivo = A.TU_CodArchivo)

						-- INSERCIONES SOBRE TABLA TEMPORAL FINAL	
						INSERT INTO	@Result
						(
							Descripcion,
							Clasificacion,
							FechaCreacion,
							ConsecutivoAsignado,
							Identificador,
							CodigoInterviniente,
							CodigoComunicacion
						)
						--Se insertan Actas	de notificación con base en los documentos insertados y que sean de tipo resolución
						SELECT		'Acta de notificación - ' + 
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
									END,
									'N',
									AC.TF_FechaAsociacion,
									NULL,
									convert(varchar(50), A.TU_CodArchivo),
									EI.TU_CodInterviniente,
									AC.TU_CodComunicacion
						FROM		Comunicacion.Comunicacion				C		WITH(NOLOCK)
						INNER JOIN	Comunicacion.ArchivoComunicacion		AC		WITH(NOLOCK)
						ON			C.TU_CodComunicacion					=		AC.TU_CodComunicacion
						INNER JOIN  @Result									RES
						ON			AC.TU_CodArchivo						=		RES.Identificador
						AND			RES.Clasificacion						=		'D'
						LEFT JOIN	Archivo.Archivo							AR		WITH(NOLOCK)
						ON			AC.TU_CodArchivo						=		AR.TU_CodArchivo
						INNER JOIN	Comunicacion.ComunicacionIntervencion	CI		WITH(NOLOCK)
						ON			CI.TU_CodComunicacion					=		C.TU_CodComunicacion
						INNER JOIN	Expediente.Intervencion					EI		WITH(NOLOCK)
						ON			EI.TU_CodInterviniente					=		CI.TU_CodInterviniente
						LEFT JOIN	Expediente.Interviniente				EINT	WITH(NOLOCK)
						ON			EI.TU_CodInterviniente					=		EINT.TU_CodInterviniente
						LEFT JOIN	Catalogo.TipoIntervencion				TI		WITH(NOLOCK)
						ON			EINT.TN_CodTipoIntervencion				=		TI.TN_CodTipoIntervencion
						INNER JOIN	Persona.Persona							P		WITH(NOLOCK)
						ON			EI.TU_CodPersona						=		P.TU_CodPersona
						LEFT JOIN	Persona.PersonaFisica					PF		WITH(NOLOCK)
						ON			PF.TU_CodPersona						=		P.TU_CodPersona
						LEFT JOIN	Persona.PersonaJuridica					PJ		WITH(NOLOCK)
						ON			PJ.TU_CodPersona						=		P.TU_CodPersona
						INNER JOIN	Archivo.Archivo							A		WITH(NOLOCK)
						ON			AC.TU_CodArchivo						=		A.TU_CodArchivo
						INNER JOIN	Expediente.Expediente					E		WITH(NOLOCK)
						ON			C.TC_NumeroExpediente					=		E.TC_NumeroExpediente
						INNER JOIN	Expediente.Resolucion					R		WITH(NOLOCK)
						ON			A.TU_CodArchivo							=		R.TU_CodArchivo
						WHERE		C.TC_NumeroExpediente					=		@L_NumeroExpediente
						AND			AC.TB_EsActa							=		1
						AND			EI.TU_CodInterviniente					IN		(SELECT TU_CodInterviniente FROM @ListaIntervinientes)

						--************************************************************************************************************************
						--SE REALIZA ACTUALIZACIONES DE DATOS EN TABLA FINAL DE RESULTADOS

						--Se actualiza el documento padre del acta de notificacion
						UPDATE			A
						SET				A.ArchivoComunicado					= B.TU_CodArchivo
						FROM			@Result								A
						INNER JOIN		Comunicacion.ArchivoComunicacion	B WITH(NOLOCK)
						ON				A.CodigoComunicacion				= B.TU_CodComunicacion
						AND				B.TB_EsPrincipal					= 1
						WHERE			A.Clasificacion						= 'N'

						--Se actualiza la descripcion del elemento de historial procesal en caso de que tenga intervenciones 
						UPDATE		A
						SET			A.Descripcion	= B.Descripcion
						FROM		@Result			A
						INNER JOIN	(
										SELECT				A.Descripcion + ' - ' + F.NOMBRE Descripcion,
															A.Identificador
										FROM				@Result				A
										OUTER APPLY			(
																SELECT TOP (1)
																CASE WHEN C.TC_TipoParticipacion = 'P' THEN
																	TI.TC_Descripcion
																ELSE
																	'REPRESENTANTE'
																END
																+ ' - ' +
																ISNULL
																(
																ISNULL(
																D.TC_Nombre 
																+ ' ' + 
																D.TC_PrimerApellido + ' ' 
																+ ISNULL(D.TC_SegundoApellido, ''), E.TC_Nombre), '') NOMBRE
																FROM			Expediente.IntervencionArchivo	B WITH(NOLOCK)
																INNER JOIN		Expediente.Intervencion			C WITH(NOLOCK)
																ON				C.TU_CodInterviniente			= B.TU_CodInterviniente
																LEFT JOIN		Expediente.Interviniente		EI WITH(NOLOCK)
																ON				C.TU_CodInterviniente			= EI.TU_CodInterviniente
																LEFT JOIN		Catalogo.TipoIntervencion		TI WITH(NOLOCK)
																ON				EI.TN_CodTipoIntervencion		= TI.TN_CodTipoIntervencion
																LEFT JOIN		Persona.PersonaFisica			D WITH(NOLOCK)
																ON				D.TU_CodPersona					= C.TU_CodPersona
																LEFT JOIN		Persona.PersonaJuridica			E WITH(NOLOCK)
																ON				E.TU_CodPersona					= C.TU_CodPersona
																WHERE			B.TU_CodArchivo					= A.Identificador
															) F
									)				B
						On			B.Identificador	=	A.Identificador
						AND			B.Descripcion	IS NOT NULL
						WHERE		A.Clasificacion = 'D'
				END
	END
	
	--************************************************************************************************************************
	--SE ACTUALIZA LOS REGISTROS ELIMINANDO DOC EN ESTADO PRIVADO Y QUE NO LOS CREO EL USUARIO DE A CONSULTA	
	DELETE		FROM			@Result
	WHERE		Estado			=	1
	AND			UsuarioCrea		<> @L_UsuarioCrea
	AND			Clasificacion	= 'D'


	--************************************************************************************************************************
	--RESULTADO FINAL 
	SELECT	
			Descripcion,
			FechaCreacion,
			ConsecutivoAsignado,
			Identificador,
			ArchivoComunicado,
			CodigoComunicacion,
			GrupoTrabajoDocumento,
			'Split' as Split,
			Clasificacion,
			Estado,
			'Split' as Split,
			CodigoInterviniente,
			CodigoLegajo
	FROM	@Result
	ORDER By ConsecutivoAsignado
END 
GO
