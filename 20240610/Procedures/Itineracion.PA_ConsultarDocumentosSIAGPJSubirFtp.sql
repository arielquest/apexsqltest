SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<13/01/2021>
-- Descripción :			<Permite consultar los documentos asociados a un expediente o legajo de SIAGPJ, para poder subirlos al ftp temp, previo a enviar una itineración a Gestión>
-- =============================================================================================================================================================================
-- Modificado:				<05/03/2021><Richard Zúñiga Segura><Se agrega el parámetro TipoItineracion y las validaciones en relación a dicho parámetro>
-- Modificado:				<08/03/2021><Karol Jiménez S.><Se ajusta filtro para los escritos, según cambio realizado por Luis Alonso en Itineracion.PA_ConsultarDocumentosItineracionSIAGPJ>
-- Modificado:				<17/03/2021><Karol Jiménez S.><Se agregan las consultas para los tipos de itineración R=Recurso, D=ResultadoSolicitud y O=ResultadoRecurso>
-- Modificado:				<24/04/2021><Jonthan Aguilar Navarro><Se agrega a la consulta los documentos de los expediente acumulados de un expediente.>
-- Modificado:				<25/06/2021><Karol Jiménez S.><Se agrega split faltante en consulta de documentos para resultados de solicitudes.>
-- Modificado:				<25/06/2021><Luis Alonso Leiva Tames><Se modifica para que muestre todos los documentos sin importar el estado>
-- =============================================================================================================================================================================

 CREATE PROCEDURE [Itineracion].[PA_ConsultarDocumentosSIAGPJSubirFtp]
 	@CodHistoricoItineracion	UNIQUEIDENTIFIER,
	@TipoItineracion			CHAR
AS 

	BEGIN
		--Variables 
		DECLARE	@L_TC_NumeroExpediente						CHAR(14),
				@L_TU_CodLegajo								UNIQUEIDENTIFIER	= NULL,
				@L_ValorDefectoRutaDescargaDocumentosFTP	VARCHAR(255)		= NULL,
				@L_TipoItineracion							CHAR				= @TipoItineracion,
				@L_CodHistoricoItineracion					UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
				@L_ExpedientesAcumulados					int,
				@L_ExpedienteAcumulado						varchar(14);
			
		-- Se consulta si la itineración está ligada a un Expediente o a un Legajo
		SELECT  @L_TC_NumeroExpediente	= TC_NumeroExpediente,
				@L_TU_CodLegajo			= TU_CodLegajo
		FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@L_CodHistoricoItineracion);

		/*SE OBTIENEN VALORES POR DEFECTO, SEGÚN CONFIGURACIONES*/
		SELECT	@L_ValorDefectoRutaDescargaDocumentosFTP	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_RutaDocumentosFTP','');

		/*EXPEDIENTES Y LEGAJOS*/
		IF @L_TipoItineracion ='E'
		BEGIN
				CREATE TABLE #Documentos
				(	
					Numero varchar(14),
					Codigo uniqueidentifier,
					RutaArchivoGestion varchar(1000),
				)
				-- Se llena tabla temporal con datos de SIAGPJ
				--DOCUMENTOS asociados a un Expediente o Legajo
				insert into #Documentos
				SELECT		E.TC_NumeroExpediente			Numero,
							D.TU_CodArchivo					Codigo,	
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(D.TU_CodArchivo, F.TC_Extensiones))	RutaArchivoGestion
				FROM		Archivo.Archivo					D	WITH(NOLOCK)
				INNER JOIN	Expediente.ArchivoExpediente	E	WITH(NOLOCK)
				ON			E.TU_CodArchivo					=	D.TU_CodArchivo
				LEFT JOIN	Expediente.LegajoArchivo		L	WITH(NOLOCK)
				ON			L.TU_CodArchivo					=	E.TU_CodArchivo
				INNER JOIN	Catalogo.FormatoArchivo			F	WITH(NOLOCK)
				ON			F.TN_CodFormatoArchivo			=	D.TN_CodFormatoArchivo
				WHERE		E.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
				AND			(	
								(
									@L_TU_CodLegajo					IS NULL 
									AND	L.TU_CodLegajo				IS NULL							
								)
								OR	
								(	
									@L_TU_CodLegajo					IS NOT NULL
									AND	L.TU_CodLegajo				=	@L_TU_CodLegajo
								)
							)
				/*ESCRITOS*/
				UNION
				SELECT		E.TC_NumeroExpediente			Numero,
							E.TC_IDARCHIVO					Codigo,
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(E.TC_IDARCHIVO, '.desconocida'))	RutaArchivoGestion
				FROM		Expediente.EscritoExpediente	E	WITH(NOLOCK) 
				LEFT JOIN	Expediente.EscritoLegajo		L	WITH(NOLOCK)
				ON			L.TU_CodEscrito					=	E.TU_CodEscrito
				WHERE		E.TC_NumeroExpediente = 		CASE WHEN @L_TU_CodLegajo is null 
																THEN @L_TC_NumeroExpediente 
															ELSE E.TC_NumeroExpediente END
				AND		(	
							(
								@L_TU_CodLegajo					IS NULL 
								AND	L.TU_CodLegajo				IS NULL							
							)
							OR	
							(	
								@L_TU_CodLegajo						IS NOT NULL
								AND	L.TU_CodLegajo				=	@L_TU_CodLegajo
							)
						)
				
				--Se verifica si el expediente tiene acumulados
				CREATE TABLE #ExpedientesAcumulados
				(
					ExpedienteAcumulado varchar(14)
				)
				insert into #ExpedientesAcumulados
				select TC_NumeroExpediente from Historico.ExpedienteAcumulacion where TC_NumeroExpedienteAcumula = @L_TC_NumeroExpediente
				select @L_ExpedientesAcumulados = COUNT(*) from #ExpedientesAcumulados

				if @L_ExpedientesAcumulados > 0
				begin
						while @L_ExpedientesAcumulados > 0
						Begin
							SELECT @L_ExpedienteAcumulado = (select top(1) TC_NumeroExpediente from Historico.ExpedienteAcumulacion where TC_NumeroExpedienteAcumula = @L_TC_NumeroExpediente)
							INSERT INTO #Documentos
							SELECT		E.TC_NumeroExpediente			Numero,
										D.TU_CodArchivo					Codigo,	
										CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
										   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
												ELSE '/'
										   END
											,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(D.TU_CodArchivo, F.TC_Extensiones))	RutaArchivoGestion
							FROM		Archivo.Archivo					D	WITH(NOLOCK)
							INNER JOIN	Expediente.ArchivoExpediente	E	WITH(NOLOCK)
							ON			E.TU_CodArchivo					=	D.TU_CodArchivo
							LEFT JOIN	Expediente.LegajoArchivo		L	WITH(NOLOCK)
							ON			L.TU_CodArchivo					=	E.TU_CodArchivo
							INNER JOIN	Catalogo.FormatoArchivo			F	WITH(NOLOCK)
							ON			F.TN_CodFormatoArchivo			=	D.TN_CodFormatoArchivo
							WHERE		E.TC_NumeroExpediente			=	@L_ExpedienteAcumulado
							AND			L.TU_CodLegajo					IS NULL
							
							/*ESCRITOS*/
							UNION
							SELECT		E.TC_NumeroExpediente			Numero,
										E.TC_IDARCHIVO					Codigo,
										CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
										   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
												ELSE '/'
										   END
											,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(E.TC_IDARCHIVO, '.desconocida'))	RutaArchivoGestion
							FROM		Expediente.EscritoExpediente	E	WITH(NOLOCK) 
							LEFT JOIN	Expediente.EscritoLegajo		L	WITH(NOLOCK)
							ON			L.TU_CodEscrito					=	E.TU_CodEscrito
							WHERE		E.TC_NumeroExpediente			= 	@L_ExpedienteAcumulado 
							AND			L.TU_CodLegajo					IS NULL	

							DELETE FROM #ExpedientesAcumulados WHERE ExpedienteAcumulado = @L_ExpedienteAcumulado;
							SELECT @L_ExpedientesAcumulados = COUNT(*) FROM #ExpedientesAcumulados
						End

						SELECT  Codigo				AS Codigo,
								RutaArchivoGestion	AS RutaArchivoGestion,
								'Split'				AS Split,
								Numero				AS Numero	
						FROM #Documentos
				end
				else
				begin
						SELECT  Codigo				AS Codigo,
								RutaArchivoGestion	AS RutaArchivoGestion,
								'Split'				AS Split,
								Numero				AS Numero
						FROM				#Documentos
				end
				DROP TABLE #Documentos
				DROP TABLE #ExpedientesAcumulados
		END

		/*SOLICITUDES*/
		ELSE IF @L_TipoItineracion ='S'
		BEGIN	
				SELECT		A.TU_CodArchivo					Codigo,
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(A.TU_CodArchivo, ISNULL(C.TC_Extensiones,'.desconocida')))	RutaArchivoGestion,
								'Split'	As Split,
								A.TC_NumeroExpediente			Numero
				FROM		Expediente.SolicitudExpediente	A	WITH(NOLOCK) 
				LEFT JOIN	Archivo.Archivo					B	WITH(NOLOCK)
				ON			B.TU_CodArchivo					=	A.TU_CodArchivo
				LEFT JOIN	Catalogo.FormatoArchivo			C	WITH(NOLOCK)
				ON			C.TN_CodFormatoArchivo			=	B.TN_CodFormatoArchivo
				WHERE		A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion
		END

		/*RECURSOS*/
		ELSE IF @L_TipoItineracion ='R'
		BEGIN	
				SELECT		B.TU_CodArchivo					Codigo,
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(B.TU_CodArchivo, ISNULL(D.TC_Extensiones,'.desconocida')))	RutaArchivoGestion,
								'Split'	As Split,
								A.TC_NumeroExpediente			Numero
				FROM		Expediente.RecursoExpediente	A	WITH(NOLOCK) 
				INNER JOIN	Expediente.Resolucion			B	WITH(NOLOCK) 
				ON			B.TU_CodResolucion				=	A.TU_CodResolucion
				LEFT JOIN	Archivo.Archivo					C	WITH(NOLOCK)
				ON			C.TU_CodArchivo					=	B.TU_CodArchivo
				LEFT JOIN	Catalogo.FormatoArchivo			D	WITH(NOLOCK)
				ON			D.TN_CodFormatoArchivo			=	C.TN_CodFormatoArchivo
				WHERE		A.TU_CodHistoricoItineracion	=	@L_CodHistoricoItineracion
		END
	
		/*RESULTADOS SOLICITUDES*/
		ELSE IF @L_TipoItineracion ='D'
		BEGIN	
				SELECT		B.TU_CodArchivo					Codigo,
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(B.TU_CodArchivo, D.TC_Extensiones))	RutaArchivoGestion,
							'Split'	As Split,
							NULL as Numero
				FROM		Expediente.ResultadoSolicitud			A	WITH(NOLOCK)	
				INNER JOIN	Expediente.ResultadoSolicitudArchivos	B	WITH(NOLOCK)
				ON			B.TU_CodResultadoSolicitud				=	A.TU_CodResultadoSolicitud
				INNER JOIN	Archivo.Archivo							C	WITH(NOLOCK)
				ON			C.TU_CodArchivo							=	B.TU_CodArchivo
				INNER JOIN	Catalogo.FormatoArchivo					D	WITH(NOLOCK)
				ON			D.TN_CodFormatoArchivo					=	C.TN_CodFormatoArchivo
				WHERE		A.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;
		END

		/*RESULTADOS RECURSOS*/
		ELSE IF @L_TipoItineracion ='O'
		BEGIN
			SELECT			B.TU_CodArchivo					Codigo,
							CONCAT( @L_ValorDefectoRutaDescargaDocumentosFTP,
							   CASE WHEN RIGHT(@L_ValorDefectoRutaDescargaDocumentosFTP,1) = '/' THEN ''
									ELSE '/'
							   END
								,Convert(Varchar(36),@L_CodHistoricoItineracion),'/',CONCAT(B.TU_CodArchivo, D.TC_Extensiones))	RutaArchivoGestion,
							'Split'	As Split,
							NULL as Numero
			FROM		Expediente.ResultadoRecurso				A	WITH(NOLOCK)	
			INNER JOIN	Expediente.ResultadoRecursosArchivos	B	WITH(NOLOCK)
			ON			B.TU_CodResultadoRecurso				=	A.TU_CodResultadoRecurso
			INNER JOIN	Archivo.Archivo							C	WITH(NOLOCK)
			ON			C.TU_CodArchivo							=	B.TU_CodArchivo
			INNER JOIN	Catalogo.FormatoArchivo					D	WITH(NOLOCK)
			ON			D.TN_CodFormatoArchivo					=	C.TN_CodFormatoArchivo
			WHERE		A.TU_CodHistoricoItineracion			=	@L_CodHistoricoItineracion;
		END
	END
GO
