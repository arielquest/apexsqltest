SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<09/06/2020>
-- Descripción :			<Permite consultar el historial procesal de un expediente>
-- ==================================================================================================================================================================================================
-- Modificación :			<17/06/2020> <Isaac Dobles Mata> <Se agrega filtros de b£squeda>
-- Modificación :			<29/06/2020> <Ronny Ram¡rez R.> <Se agrega campo de CodigoInterviniente para buscar detalle si es acta de notificación>
-- Modificación :			<06/07/2020> <Isaac Dobles Mata> <Se modifica consulta para agregar el código de legajo>
-- Modificación :			<10/07/2020> <Isaac Dobles Mata> <Se modifica consulta de actas de notificación>
-- Modificación :			<06/08/2020> <Isaac Dobles Mata> <Se elimina grupo de trabajo de la consulta>
-- Modificación :			<20/08/2020> <Isaac Dobles Mata> <Se modifica la consulta de la descripción de los escritos/audiencias/documentos>
-- Modificación :			<27/08/2020> <Andrew Allen Dawson> <Se agrega como parametro el codigo de interviniente>
-- Modificación :			<17/09/2020> <Ronny Ram¡rez R.> <Se agregan par metros para mostrar o no documentos, escritos y audiencias>
-- Modificación :			<18/09/2020> <Andrew Allen Dawson.> <Se Cambia el tipo de dato del codigo del legajo para que soporte multiples valores>
-- Modificación :           <25/09/2020> <Jose Gabriel Cordero Soto> <Se realiza ajuste en cambio de tipo de dato en parametro de interviniente>
-- Modificación :			<20/10/2020> <Isaac Dobles Mata.> <Se corrige consulta de actas de notificación>
-- Modificación :			<08/12/2020> <Roger Lara> <Se ajusta consulta por Fase, para que utilice unicamente la fecha de la fase>
-- Modificación :			<24/12/2020> <Karol Jim‚nez S nchez> <Se agrega consulta por fases, para legajos>
-- Modificación :			<08/04/2021> <Ronny Ram¡rez R.> <Se aplica validación en caso que se combinen los filtros Tipo de Escrito y Fase del Expediente>
-- Modificación :			<12/04/2021> <Ronny Ram¡rez R.> <Se agregan datos del asunto del legajo para agrupar los documentos en el buzón correspondiente>
-- Modificar por:			<21/04/2021> <Ronny Ram¡rez R.> <Se elimina la fecha que se asociaba a las actas de notificación para evitar que saliera 
--												duplicada en la interfaz>
-- Modificación :			<27/05/2021> <Luis Alonso Leiva Tames> <Se modifica para mostrar las actas de los documentos asociados para el Historial en cronologico>
--AND			EI.TU_CodInterviniente					IS		NULL
-- Modificación :			<30/07/2021> <Fabian Sequeira> <Se modifica para que se obtenga el Id del archivo del escrito y no el id del escrito>
-- Modificación :			<09/08/2021> <Fabian Sequeira> <Se modifica para que no se muestren los escritos de todo el expediente>
-- Modificación :			<08/10/2021> <Karol Jim‚nez S nchez> <Se modifica para consultar cu les son archivos multimedia (audiencias)>
-- Modificación :			<29/07/2022> <Mario Camacho Flores> <Se agrega un nuevo parametro "@ConsultaDesdeTestimonioPiezas" para indicar si la consulta proviene desde testimoio de piezas>
-- Modificación :			<31/03/2023> <Ronny Ram¡rez R.> <Se agrega par metro @ModoVisualizacion para permitir mostrar todo tipo de registro aunque se especifique el par metro @EstadoDocumento>
-- ==================================================================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarHistorialProcesal]
	@NumeroExpediente		char(14),
	@ConsultaCompleta		bit = 0,
	@UsuarioCrea			varchar(30),
	@CodigoLegajo			Expediente.ListaLegajosType			READONLY,
	@FechaInicio			datetime2(7)						= null,
	@FechaFin				datetime2(7)						= null,
	@EstadoDocumento		tinyint								= null,
	@TipoEscrito			smallint							= null,	
	@Fase					smallint							= null,
	@CodigoInterviniente	Expediente.ListaIntervinientesType  READONLY,
	@MostrarDocumentos		bit									= 1,
	@MostrarEscritos		bit									= 1,
	@MostrarAudiencias		bit									= 1,
	@ConsultaDesdeTestimonioPiezas bit = 0,
	@ModoVisualizacion		bit									= 0
AS 

BEGIN

--Variables 
DECLARE	@L_NumeroExpediente					CHAR(14)				= @NumeroExpediente,
		@L_ConsultaCompleta					bit						= @ConsultaCompleta,
		@L_UsuarioCrea						varchar(30)				= @UsuarioCrea,
		@L_FechaInicio						datetime2(7)			= @FechaInicio,
		@L_FechaFin							datetime2(7)			= @FechaFin,
		@L_EstadoDocumento					tinyint					= @EstadoDocumento,
		@L_TipoEscrito						smallint				= @TipoEscrito,
		@L_Fase								smallint				= @Fase,
		@L_MostrarDocumentos				bit						= @MostrarDocumentos,
		@L_MostrarEscritos					bit						= @MostrarEscritos,
		@L_MostrarAudiencias				bit						= @MostrarAudiencias,
		@L_FechaFase						datetime2(7),
		@L_ConsultaDesdeTestimonioPiezas	bit						= @ConsultaDesdeTestimonioPiezas,
		@L_ModoVisualizacion					bit					= @ModoVisualizacion


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
			CodigoComunicacion				uniqueidentifier	NULL,
			CodigoAsunto					int					NULL,
			AsuntoLegajo					varchar(200)		NULL,
			EsMultimedia					bit					NOT NULL DEFAULT 0,
			EstadoEscrito					Varchar(1)			NULL
	)

	-- Si no se pone ning£n filtro, por defecto se muestran todos
	IF(@L_MostrarDocumentos = 0 AND @L_MostrarEscritos = 0 AND @L_MostrarAudiencias = 0)
	BEGIN
		SET @L_MostrarDocumentos = 1;
		SET @L_MostrarEscritos = 1;
		SET @L_MostrarAudiencias = 1;
	END

	--Consulta sobre el legajo
	IF((SELECT COUNT(*) FROM @CodigoLegajo) > 0)
	BEGIN
		--Si viene el tipo de escrito sólo se consulta los escritos
		IF(@L_TipoEscrito IS NOT NULL AND @L_Fase IS NULL)
		BEGIN
			--Set @L_ConsultaCompleta = 0
			INSERT INTO	@Result
				(
					Descripcion,
					Clasificacion,
					FechaCreacion,
					ConsecutivoAsignado,
					Identificador,
					Estado,
					GrupoTrabajoDocumento,
					UsuarioCrea,
					CodigoLegajo,
					EstadoEscrito
				)

				--Consulta de escritos 
				SELECT		EE.TC_Descripcion,
							'E',
							EE.TF_FechaRegistro,
							EE.TN_Consecutivo,
							convert(varchar(50), EE.TC_IDARCHIVO),
							NULL,
							NULL,
							NULL,
							EL.TU_CodLegajo,
							EE.TC_EstadoEscrito
				FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
				INNER JOIN	Expediente.EscritoLegajo				EL	WITH(NOLOCK)
				ON			EE.TU_CodEscrito						=	EL.TU_CodEscrito
				INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
				ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
				WHERE		EE.TC_NumeroExpediente					=	@L_NumeroExpediente
				AND			EL.TU_CodLegajo							IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
				AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
				AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
				AND			EE.TN_CodTipoEscrito					= COALESCE(@L_TipoEscrito, EE.TN_CodTipoEscrito)
		END
		ELSE
		BEGIN

			IF(@L_Fase IS NOT NULL)
			BEGIN
					--Se consulta del histórico de fases las fechas en que estuvo en la fase enviada por par metro
				DECLARE Cursor_Fases CURSOR
			
				FOR 
				WITH TODOS AS (
								SELECT  ROW_NUMBER() OVER(ORDER BY TF_Fase ASC) ID,
										A.TF_Fase,
										A.TN_CodFase
								FROM    Historico.LegajoFase	A WITH(NOLOCK)
								WHERE   A.TU_CodLegajo			IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
					)
					,
					RANGOS AS (
								SELECT A.TF_Fase Fecha_Inicio,
									   A.ID ID_Inicio,
									   A.TN_CodFase,
									   LEAD(ID, 1,0) OVER (ORDER BY TF_Fase) ID_Fecha_Fin
								FROM TODOS		A WITH(NOLOCK)
					) 
					,
					FECHAS AS (
								SELECT A.Fecha_Inicio,
									   A.ID_Inicio,
									   A.TN_CodFase,
									   ISNULL(B.TF_Fase, GETDATE()) Fecha_Fin,
									   A.ID_Fecha_Fin
								FROM		RANGOS		A WITH(NOLOCK)
								LEFT JOIN	TODOS		B WITH(NOLOCK)
								ON			B.ID		= A.ID_Fecha_Fin
					)
					SELECT	A.Fecha_Inicio,
							A.Fecha_Fin
					FROM	FECHAS A WITH(NOLOCK)
					WHERE	ISNULL(A.TN_CodFase, 0)	= COALESCE(@L_Fase, ISNULL(A.TN_CodFase, 0))
					AND		A.Fecha_Inicio			>= COALESCE(@L_FechaInicio, A.Fecha_Inicio)
					AND		A.Fecha_Fin				<= COALESCE(@L_FechaFin, A.Fecha_Fin)

					OPEN Cursor_Fases

					FETCH NEXT FROM Cursor_Fases INTO
						@L_FechaInicio,
						@L_FechaFin
					
					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF(@L_MostrarDocumentos = 1)
						BEGIN

							INSERT INTO	@Result
							(
								Descripcion,
								Clasificacion,
								FechaCreacion,
								ConsecutivoAsignado,
								Identificador,
								Estado,
								GrupoTrabajoDocumento,
								UsuarioCrea,
								CodigoLegajo
							)
							-- Consulta de documentos
							SELECT		A.TC_Descripcion,
										'D',
										A.TF_FechaCrea,
										AE.TN_Consecutivo,
										convert(varchar(50), AE.TU_CodArchivo),
										A.TN_CodEstado,
										AE.TN_CodGrupoTrabajo,
										A.TC_UsuarioCrea,
										LA.TU_CodLegajo
							FROM		Archivo.Archivo								A	WITH(NOLOCK)
							INNER JOIN	Expediente.ArchivoExpediente				AE	WITH(NOLOCK)
							ON			AE.TU_CodArchivo							=	A.TU_CodArchivo
							INNER JOIN	Expediente.LegajoArchivo					LA	WITH(NOLOCK)
							ON			LA.TU_CodArchivo							=	A.TU_CodArchivo
							INNER JOIN	Expediente.Expediente						E	WITH(NOLOCK)
							ON			E.TC_NumeroExpediente						=	AE.TC_NumeroExpediente
							WHERE		AE.TC_NumeroExpediente						=	@L_NumeroExpediente
							AND			LA.TU_CodLegajo								IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
							AND			AE.TB_Eliminado								=	0
							AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
							AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
							AND			A.TN_CodEstado								=  COALESCE (@L_EstadoDocumento, A.TN_CodEstado)

						END

						--Si el estado del documento viene nulo, se consulta los escritos y las audiencias
						IF(@L_EstadoDocumento IS NULL OR @L_ModoVisualizacion = 1)
						BEGIN
							INSERT INTO	@Result
							(
								Descripcion,
								Clasificacion,
								FechaCreacion,
								ConsecutivoAsignado,
								Identificador,
								Estado,
								GrupoTrabajoDocumento,
								UsuarioCrea,
								CodigoLegajo,
								EsMultimedia,
								EstadoEscrito
							)
							--Consulta de escritos 
							SELECT		EE.TC_Descripcion,
										'E',
										EE.TF_FechaRegistro,
										EE.TN_Consecutivo,
										convert(varchar(50), EE.TC_IDARCHIVO),
										NULL,
										NULL,
										NULL,
										EL.TU_CodLegajo,
										0,
										EE.TC_EstadoEscrito
							FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
							INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
							ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
							INNER JOIN	Expediente.EscritoLegajo				EL	WITH(NOLOCK)
							ON			EE.TU_CodEscrito						=	EL.TU_CodEscrito
							WHERE		@L_MostrarEscritos						=	1	
							AND			EE.TC_NumeroExpediente					=	@L_NumeroExpediente
							AND			EL.TU_CodLegajo							IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
							AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
							AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
							AND			EE.TN_CodTipoEscrito					= COALESCE (@L_TipoEscrito, EE.TN_CodTipoEscrito)

							UNION

							--Consulta de audiencias
							SELECT		
										A.TC_Descripcion,
										CASE
											WHEN RIGHT(A.TC_NombreArchivo, Len(A.TC_NombreArchivo) - Charindex('.', A.TC_NombreArchivo)) = 'mp3' THEN 'A'
										ELSE
											'V'
										END	,
										A.TF_FechaCrea,
										A.TN_Consecutivo,
										Convert(varchar(50), A.TN_CodAudiencia),
										NULL,
										NULL,
										NULL,
										AL.TU_CodLegajo,
										1,
										NULL
							FROM		Expediente.Audiencia					A	WITH(NOLOCK)
							INNER JOIN	Expediente.AudienciaLegajo				AL	WITH(NOLOCK)
							ON			AL.TN_CodAudiencia						=	A.TN_CodAudiencia
							INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
							ON			A.TC_NumeroExpediente					=	E.TC_NumeroExpediente
							WHERE		@L_MostrarAudiencias					=	1	
							AND			A.TC_NumeroExpediente					=	@L_NumeroExpediente
							AND			AL.TU_CodLegajo							IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
							AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
							AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
						END
						
						FETCH NEXT FROM Cursor_Fases INTO
							@L_FechaInicio,
							@L_FechaFin
					END

					CLOSE Cursor_Fases
					DEALLOCATE Cursor_Fases
			END
			ELSE
			BEGIN
				-- Consulta Documentos   
				IF(@L_MostrarDocumentos = 1)
				BEGIN

					INSERT INTO	@Result
					(
						Descripcion,
						Clasificacion,
						FechaCreacion,
						ConsecutivoAsignado,
						Identificador,
						Estado,
						GrupoTrabajoDocumento,
						UsuarioCrea,
						CodigoLegajo
					)
					-- Consulta de documentos
					SELECT		A.TC_Descripcion,
								'D',
								A.TF_FechaCrea,
								AE.TN_Consecutivo,
								convert(varchar(50), AE.TU_CodArchivo),
								A.TN_CodEstado,
								AE.TN_CodGrupoTrabajo,
								A.TC_UsuarioCrea,
								LA.TU_CodLegajo
					FROM		Archivo.Archivo								A	WITH(NOLOCK)
					INNER JOIN	Expediente.ArchivoExpediente				AE	WITH(NOLOCK)
					ON			AE.TU_CodArchivo							=	A.TU_CodArchivo
					INNER JOIN	Expediente.LegajoArchivo					LA	WITH(NOLOCK)
					ON			LA.TU_CodArchivo							=	A.TU_CodArchivo
					INNER JOIN	Expediente.Expediente						E	WITH(NOLOCK)
					ON			E.TC_NumeroExpediente						=	AE.TC_NumeroExpediente
					WHERE		AE.TC_NumeroExpediente						=	@L_NumeroExpediente
					AND			LA.TU_CodLegajo								IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
					AND			AE.TB_Eliminado								=	0
					AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
					AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
					AND			A.TN_CodEstado								=  COALESCE (@L_EstadoDocumento, A.TN_CodEstado)

				END

				--Si el estado del documento viene nulo, se consulta los escritos y las audiencias
				IF(@L_EstadoDocumento IS NULL OR @L_ModoVisualizacion = 1)
				BEGIN
					INSERT INTO	@Result
					(
						Descripcion,
						Clasificacion,
						FechaCreacion,
						ConsecutivoAsignado,
						Identificador,
						Estado,
						GrupoTrabajoDocumento,
						UsuarioCrea,
						CodigoLegajo,
						EsMultimedia,
						EstadoEscrito
					)
					--Consulta de escritos 
					SELECT		EE.TC_Descripcion,
								'E',
								EE.TF_FechaRegistro,
								EE.TN_Consecutivo,
								convert(varchar(50), EE.TC_IDARCHIVO),
								NULL,
								NULL,
								NULL,
								EL.TU_CodLegajo,
								0,
								EE.TC_EstadoEscrito
					FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
					INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
					ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
					INNER JOIN	Expediente.EscritoLegajo				EL	WITH(NOLOCK)
					ON			EE.TU_CodEscrito						=	EL.TU_CodEscrito
					WHERE		@L_MostrarEscritos						=	1	
					AND			EE.TC_NumeroExpediente					=	@L_NumeroExpediente
					AND			EL.TU_CodLegajo							IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
					AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
					AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
					AND			EE.TN_CodTipoEscrito					= COALESCE (@L_TipoEscrito, EE.TN_CodTipoEscrito)

					UNION

					--Consulta de audiencias
					SELECT		
								A.TC_Descripcion,
								CASE
									WHEN RIGHT(A.TC_NombreArchivo, Len(A.TC_NombreArchivo) - Charindex('.', A.TC_NombreArchivo)) = 'mp3' THEN 'A'
								ELSE
									'V'
								END	,
								A.TF_FechaCrea,
								A.TN_Consecutivo,
								Convert(varchar(50), A.TN_CodAudiencia),
								NULL,
								NULL,
								NULL,
								AL.TU_CodLegajo,
								1,
								NULL
					FROM		Expediente.Audiencia					A	WITH(NOLOCK)
					INNER JOIN	Expediente.AudienciaLegajo				AL	WITH(NOLOCK)
					ON			AL.TN_CodAudiencia						=	A.TN_CodAudiencia
					INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
					ON			A.TC_NumeroExpediente					=	E.TC_NumeroExpediente
					WHERE		@L_MostrarAudiencias					=	1	
					AND			A.TC_NumeroExpediente					=	@L_NumeroExpediente
					AND			AL.TU_CodLegajo							IN	(SELECT TU_CodLegajo FROM @CodigoLegajo)
					AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
					AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
				END		
		END
		END
		--Si se eligió consultar datos de intervenciones de documentos y a su vez las actas de notificación
		IF @L_ConsultaCompleta = 1
		BEGIN
			INSERT INTO	@Result
			(
				Descripcion,
				Clasificacion,
				FechaCreacion,
				ConsecutivoAsignado,
				Identificador,
				CodigoInterviniente,
				CodigoLegajo,
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
						RES.CodigoLegajo,
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
			OR			EI.TU_CodInterviniente					IN	   (SELECT TU_CodInterviniente FROM @CodigoInterviniente)
																--= coalesce(@L_CodigoInterviniente,EI.TU_CodInterviniente)

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
	
		--Se actualizan los datos del asunto del legajo en caso de existir
		UPDATE			A
		SET				A.CodigoAsunto						= C.TN_CodAsunto,
						A.AsuntoLegajo						= C.TC_Descripcion
		FROM			@Result								A
		INNER JOIN		Expediente.LegajoDetalle			B WITH(NOLOCK)
		ON				B.TU_CodLegajo						= A.CodigoLegajo
		INNER JOIN		Catalogo.Asunto						C WITH(NOLOCK)
		ON				C.TN_CodAsunto						= B.TN_CodAsunto
		WHERE			A.CodigoLegajo						IS NOT NULL

	END
	ELSE

	--Consulta sobre el expediente
	BEGIN
		--Si viene el tipo de escrito sólo se consulta los escritos
		IF(@L_TipoEscrito IS NOT NULL AND @L_Fase IS NULL)
		BEGIN
			Set @L_ConsultaCompleta = 0
			INSERT INTO	@Result
				(
					Descripcion,
					Clasificacion,
					FechaCreacion,
					ConsecutivoAsignado,
					Identificador,
					Estado,
					GrupoTrabajoDocumento,
					UsuarioCrea,
					EstadoEscrito
				)

			--Consulta de escritos 
			SELECT		EE.TC_Descripcion,
							'E',
							EE.TF_FechaRegistro,
							EE.TN_Consecutivo,
							convert(varchar(50), EE.TC_IDARCHIVO),
							NULL,
							NULL,
							NULL,
							EE.TC_EstadoEscrito
				FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
				INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
				ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
				WHERE		EE.TC_NumeroExpediente					=	@L_NumeroExpediente
				AND			EE.TU_CodEscrito NOT IN					(SELECT TU_CodEscrito 
																		FROM Expediente.EscritoLegajo 
																		WHERE TU_CodEscrito = EE.TU_CodEscrito)
				AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
				AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
				AND			EE.TN_CodTipoEscrito					= COALESCE(@L_TipoEscrito, EE.TN_CodTipoEscrito)
		END
		ELSE
		BEGIN
			IF(@L_Fase IS NOT NULL)
			BEGIN
				--Se consulta del histórico de fases las fechas en que estuvo en la fase enviada por par metro
				DECLARE Cursor_Fases CURSOR
			
			FOR 
	        WITH TODOS AS (
							SELECT  ROW_NUMBER() OVER(ORDER BY TF_Fase ASC) ID,
									A.TF_Fase,
									A.TN_CodFase
							FROM    Historico.ExpedienteFase A WITH(NOLOCK)
							WHERE   A.TC_NumeroExpediente = COALESCE(@L_NumeroExpediente,A.TC_NumeroExpediente)
				)
				,
				RANGOS AS (
							SELECT A.TF_Fase Fecha_Inicio,
								   A.ID ID_Inicio,
								   A.TN_CodFase,
								   LEAD(ID, 1,0) OVER (ORDER BY TF_Fase) ID_Fecha_Fin
							FROM TODOS A WITH(NOLOCK)
				) 
				,
				FECHAS AS (
							SELECT A.Fecha_Inicio,
								   A.ID_Inicio,
								   A.TN_CodFase,
								   ISNULL(B.TF_Fase, GETDATE()) Fecha_Fin,
								   A.ID_Fecha_Fin
							FROM RANGOS     A WITH(NOLOCK)
							LEFT JOIN TODOS B WITH(NOLOCK)
							ON   B.ID     = A.ID_Fecha_Fin
				)
				SELECT A.Fecha_Inicio,
					   A.Fecha_Fin
				FROM   FECHAS A WITH(NOLOCK)
				WHERE ISNULL(A.TN_CodFase, 0)  = COALESCE(@L_Fase, ISNULL(A.TN_CodFase, 0))
					  AND A.Fecha_Inicio      >= COALESCE(@L_FechaInicio, A.Fecha_Inicio)
					  AND A.Fecha_Fin         <= COALESCE(@L_FechaFin, A.Fecha_Fin)

				OPEN Cursor_Fases

				FETCH NEXT FROM Cursor_Fases INTO
					@L_FechaInicio,
					@L_FechaFin
					
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					IF(@L_MostrarDocumentos = 1)
					BEGIN

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
						-- Consulta de documentos
						SELECT		A.TC_Descripcion,
									'D',
									A.TF_FechaCrea,
									AE.TN_Consecutivo,
									convert(varchar(50), AE.TU_CodArchivo),
									A.TN_CodEstado,
									AE.TN_CodGrupoTrabajo,
									A.TC_UsuarioCrea
						FROM		Archivo.Archivo								A	WITH(NOLOCK)
						INNER JOIN	Expediente.ArchivoExpediente				AE	WITH(NOLOCK)
						ON			AE.TU_CodArchivo							=	A.TU_CodArchivo
						INNER JOIN	Expediente.Expediente						E	WITH(NOLOCK)
						ON			E.TC_NumeroExpediente						=	AE.TC_NumeroExpediente
						WHERE		AE.TC_NumeroExpediente						=	@L_NumeroExpediente
						AND			AE.TB_Eliminado								=	0
						AND			A.TU_CodArchivo	NOT IN						(SELECT TU_CodArchivo 
																				FROM Expediente.LegajoArchivo 
																				WHERE TU_CodArchivo = A.TU_CodArchivo)
						AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
						AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
						AND			A.TN_CodEstado								= COALESCE (@L_EstadoDocumento,A.TN_CodEstado)
					
					END

					IF(@L_EstadoDocumento IS NULL OR @L_ModoVisualizacion = 1)
					BEGIN
						INSERT INTO	@Result
						(
							Descripcion,
							Clasificacion,
							FechaCreacion,
							ConsecutivoAsignado,
							Identificador,
							Estado,
							GrupoTrabajoDocumento,
							UsuarioCrea,
							EsMultimedia,
							EstadoEscrito
						)
						--Consulta de escritos 
						SELECT		EE.TC_Descripcion,
									'E',
									EE.TF_FechaRegistro,
									EE.TN_Consecutivo,
									convert(varchar(50), EE.TC_IDARCHIVO),
									NULL,
									NULL,
									NULL,
									0,
									EE.TC_EstadoEscrito
						FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
						INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
						ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
						WHERE		@L_MostrarEscritos						=	1	
						AND			EE.TC_NumeroExpediente					=	@L_NumeroExpediente
						AND			EE.TU_CodEscrito NOT IN					(SELECT TU_CodEscrito 
																				FROM Expediente.EscritoLegajo 
																				WHERE TU_CodEscrito = EE.TU_CodEscrito)
						AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
						AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
						AND			EE.TN_CodTipoEscrito					= COALESCE(@L_TipoEscrito, EE.TN_CodTipoEscrito)

						UNION 

						--Consulta de audiencias
						SELECT		
									A.TC_Descripcion,
									CASE
										WHEN RIGHT(A.TC_NombreArchivo, Len(A.TC_NombreArchivo) - Charindex('.', A.TC_NombreArchivo)) = 'mp3' THEN 'A'
									ELSE
										'V'
									END	,
									A.TF_FechaCrea,
									A.TN_Consecutivo,
									Convert(varchar(50), A.TN_CodAudiencia),
									NULL,
									NULL,
									NULL,
									1,
									NULL
						FROM		Expediente.Audiencia					A	WITH(NOLOCK)
						INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
						ON			A.TC_NumeroExpediente					=	E.TC_NumeroExpediente
						WHERE		@L_MostrarAudiencias					=	1	
						AND			A.TC_NumeroExpediente					=	@L_NumeroExpediente
						AND			A.TN_CodAudiencia NOT IN				(SELECT TN_CodAudiencia 
																				FROM Expediente.AudienciaLegajo 
																				WHERE TN_CodAudiencia = A.TN_CodAudiencia)
						AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
						AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
					END
				
					FETCH NEXT FROM Cursor_Fases INTO
				    @L_FechaInicio,
					@L_FechaFin
						
				END
				CLOSE Cursor_Fases
				DEALLOCATE Cursor_Fases
			END
			ELSE
			BEGIN
				IF((SELECT COUNT(*) FROM @CodigoInterviniente) = 0) /*@L_CodigoInterviniente IS NULL)*/
				BEGIN
					IF(@L_MostrarDocumentos = 1)
					BEGIN
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

						-- Consulta de documentos
						SELECT		A.TC_Descripcion,
									'D',
									A.TF_FechaCrea,
									AE.TN_Consecutivo,
									convert(varchar(50), AE.TU_CodArchivo),
									A.TN_CodEstado,
									AE.TN_CodGrupoTrabajo,
									A.TC_UsuarioCrea
						FROM		Archivo.Archivo								A	WITH(NOLOCK)
						INNER JOIN	Expediente.ArchivoExpediente				AE	WITH(NOLOCK)
						ON			AE.TU_CodArchivo							=	A.TU_CodArchivo
						INNER JOIN	Expediente.Expediente						E	WITH(NOLOCK)
						ON			E.TC_NumeroExpediente						=	AE.TC_NumeroExpediente
						WHERE		AE.TC_NumeroExpediente						=	@L_NumeroExpediente
						AND			AE.TB_Eliminado								=	0
						AND			A.TU_CodArchivo	NOT IN						(SELECT TU_CodArchivo 
																				FROM Expediente.LegajoArchivo 
																				WHERE TU_CodArchivo = A.TU_CodArchivo)
						AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
						AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
						AND			A.TN_CodEstado								=  COALESCE (@L_EstadoDocumento, A.TN_CodEstado)

					END
				END
				
				IF((@L_EstadoDocumento IS NULL OR @L_ModoVisualizacion = 1 OR @L_ConsultaDesdeTestimonioPiezas = 1) AND (SELECT COUNT(*) FROM @CodigoInterviniente) = 0) /*@L_CodigoInterviniente IS NULL)*/
				BEGIN
					INSERT INTO	@Result
					(
						Descripcion,
						Clasificacion,
						FechaCreacion,
						ConsecutivoAsignado,
						Identificador,
						Estado,
						GrupoTrabajoDocumento,
						UsuarioCrea,
						EsMultimedia,
						EstadoEscrito
					)

					--Consulta de escritos 
					SELECT		EE.TC_Descripcion,
								'E',
								EE.TF_FechaRegistro,
								EE.TN_Consecutivo,
								convert(varchar(50), EE.TC_IDARCHIVO),
								NULL,
								NULL,
								NULL,
								0,
								EE.TC_EstadoEscrito
					FROM		Expediente.EscritoExpediente			EE	WITH(NOLOCK)
					INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
					ON			EE.TC_NumeroExpediente					=	E.TC_NumeroExpediente
					WHERE		@L_MostrarEscritos						=	1	
					AND			EE.TC_NumeroExpediente					=	@L_NumeroExpediente
					AND			EE.TU_CodEscrito NOT IN					(SELECT TU_CodEscrito 
																			FROM Expediente.EscritoLegajo 
																			WHERE TU_CodEscrito = EE.TU_CodEscrito)
					AND			EE.TF_FechaRegistro						>= COALESCE (@L_FechaInicio,EE.TF_FechaRegistro)	
					AND			EE.TF_FechaRegistro						<= COALESCE (@L_FechaFin,EE.TF_FechaRegistro)
					AND			EE.TN_CodTipoEscrito					= COALESCE (@L_TipoEscrito, EE.TN_CodTipoEscrito)

					UNION

					--Consulta de audiencias
					SELECT		
								A.TC_Descripcion,
								CASE
									WHEN RIGHT(A.TC_NombreArchivo, Len(A.TC_NombreArchivo) - Charindex('.', A.TC_NombreArchivo)) = 'mp3' THEN 'A'
								ELSE
									'V'
								END	,
								A.TF_FechaCrea,
								A.TN_Consecutivo,
								Convert(varchar(50), A.TN_CodAudiencia),
								NULL,
								NULL,
								NULL,
								1,
								NULL
					FROM		Expediente.Audiencia					A	WITH(NOLOCK)
					INNER JOIN	Expediente.Expediente					E	WITH(NOLOCK)
					ON			A.TC_NumeroExpediente					=	E.TC_NumeroExpediente
					WHERE		@L_MostrarAudiencias					=	1	
					AND			A.TC_NumeroExpediente					=	@L_NumeroExpediente
					AND			A.TN_CodAudiencia NOT IN				(SELECT TN_CodAudiencia 
																			FROM Expediente.AudienciaLegajo 
																			WHERE TN_CodAudiencia = A.TN_CodAudiencia)
					AND			A.TF_FechaCrea								>= COALESCE (@L_FechaInicio,A.TF_FechaCrea)	
					AND			A.TF_FechaCrea								<= COALESCE (@L_FechaFin,A.TF_FechaCrea)
				END		
			
			END
		END

		--Si se eligió consultar datos de intervenciones de documentos y a su vez las actas de notificación
		IF @L_ConsultaCompleta = 1
		BEGIN
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

	--Se elimina los documentos en estado Privado que no los creó el usuario que realiza la consulta
	DELETE		FROM			@Result
	WHERE		Estado			=	1
	AND			UsuarioCrea		<> @L_UsuarioCrea
	AND			Clasificacion	= 'D'

	--Se devuelve los resultados
	SELECT	
			Descripcion,
			FechaCreacion,
			ConsecutivoAsignado,
			Identificador,
			ArchivoComunicado,
			CodigoComunicacion,
			GrupoTrabajoDocumento,
			EsMultimedia,
			'Split'					AS Split,	-- Otros
			Clasificacion,
			Estado,
			EstadoEscrito,
			'Split'					AS Split,	-- Interviniente
			CodigoInterviniente,
			'Split'					AS Split,	-- Legajo
			CodigoLegajo			AS Codigo,
			'Split'					AS Split,	-- Asunto del legajo
			CodigoAsunto			AS Codigo,
			AsuntoLegajo			AS Descripcion
	FROM	@Result
	ORDER By ConsecutivoAsignado

END
GO
