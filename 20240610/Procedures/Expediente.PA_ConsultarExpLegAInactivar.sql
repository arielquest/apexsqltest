SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:		Isaac Dobles Mata
-- Create date: 23/12/2022
-- Description:	Procedimiento para para realizar la consulta de los expedientes por filtros de la solicitud de carga
-- ====================================================================================================================================================================================
-- Modificado por:			<08/05/2023><Jefferson Parker Cortes><Se modifica estado default de la carga de P a estado de error X , esto por si algun motivo no llega a consultar los apis>
-- Modificado por:          <24/05/2023><Jose Gabriel Cordero Soto><BUG 318069 - Se modifica consulta para obtener registros de expedientes y legajos candidatos para obtener solo 
--							los que tienen registros en movimiento activo>
-- Modificado por:          <10/07/2023><Jefferson Parker Cortes><BUG 328575 - Se modifica mensaje de error al mostrar despues de la carga, cuando es error de embargos, depósitos y mandamientos>
-- Modificado por:          <06/10/2023><Karol Jiménez Sánchez><PBI 300119 - Se agrega a la consulta el indicador de Embargos físicos de expedientes y legajos>
-- ====================================================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_ConsultarExpLegAInactivar]
	@CodigoSolicitud	BIGINT,
	@ValidarDocumento	BIT,
	@ValidarEscrito		BIT,
	@FechaCorte			DATETIME2(3),
	@CodigoContexto		VARCHAR(4)
AS
BEGIN
--=============================================================================================================
		--SECCION DE LAS DECLARACIONES DE VARIABLES Y TABLAS TEMPORALES

		--Variables
		DECLARE 
		@L_CodSolicitud			BIGINT			=   @CodigoSolicitud,
		@L_ValidarDocumento		BIT				=	@ValidarDocumento,
		@L_ValidarEscrito		BIT				=	@ValidarEscrito,
		@L_Corte				DATETIME2(3)	=	@FechaCorte,
		@L_CodContexto			VARCHAR(4)		=	@CodigoContexto,
		@L_EstadoCirculante		CHAR(1)			=	'A',
		@L_FechaMinima			DATETIME2(3)	=	CONVERT(DATETIME, -53690)

		--Creación de tabla temporal.
		DECLARE	@ExpLegajosCandidatos TABLE
		(
			NumeroExpediente		CHAR(14),
			CodigoLegajo			UNIQUEIDENTIFIER,
			FechaMovCirculante		DATETIME2(7),
			CodContexto				VARCHAR(4),
			Movimiento				CHAR(1),
			Estado					INT,
			EstadoDescripcion		VARCHAR(150),
			FechaUltimoDocumento	DATETIME2(7),
			FechaUltimoEscrito		DATETIME2(7),
			TieneEmbargos			BIT
		);

		--=============================================================================================================
		-- ELIMINAR REGISTROS DE LA DEPURACION ANTES DE VOLVER A CARGAR

		--Elimina todo registro que esté relacionado a la solicitud
		DELETE 
		FROM	[Expediente].[DetalleDepuracionInactivo] 
		WHERE	[TN_CodSolicitud]							=	@L_CodSolicitud
				
		--=============================================================================================================
		--CARGA DE REGISTROS DE EXPEDIENTES Y LEGAJOS CANDIDATOS A INACTIVAR

		--Si se debe validar tanto los documentos como los escritos
		IF(@ValidarDocumento = 1 AND @ValidarEscrito = 1)
		BEGIN
			--Expedientes
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT  	A.TC_NumeroExpediente,
						NULL,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						ISNULL(MAX(E.TF_FechaCrea), CAST(@L_FechaMinima AS VARCHAR)),
						ISNULL(MAX(D.TF_FechaIngresoOficina), CAST(@L_FechaMinima AS VARCHAR)),
						A.TB_EmbargosFisicos
			FROM		Expediente.Expediente							A WITH(NOLOCK)
			OUTER APPLY (
							SELECT  TOP(1)	Y.TC_Movimiento,
											Y.TN_CodEstado,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.ExpedienteMovimientoCirculante Y WITH(NOLOCK)
							WHERE		    Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente						
							ORDER BY		Y.TF_Fecha DESC, 
											Y.TN_CodExpedienteMovimientoCirculante DESC
						) Z

			INNER JOIN  Catalogo.Estado									B WITH (NOLOCK) 
			ON			B.TN_CodEstado									= Z.TN_CodEstado 
			AND			B.TC_Circulante									= @L_EstadoCirculante

			LEFT JOIN	Expediente.ArchivoExpediente					C WITH(NOLOCK)
			ON			C.TC_NumeroExpediente							= A.TC_NumeroExpediente 
			AND			C.TU_CodArchivo NOT IN(
													SELECT LEA.TU_CodArchivo
													FROM   Expediente.LegajoArchivo LEA WITH(NOLOCK)
													WHERE  LEA.TU_CodArchivo		= C.TU_CodArchivo 
													AND	   LEA.TC_NumeroExpediente	= C.TC_NumeroExpediente
												)
			LEFT JOIN	Expediente.EscritoExpediente					D WITH(NOLOCK) 
			ON			D.TC_NumeroExpediente							= A.TC_NumeroExpediente 
			AND			D.TC_CodContexto								= A.TC_CodContexto
			AND			D.TU_CodEscrito NOT IN(
													SELECT LEE.TU_CodEscrito 
													FROM   Expediente.EscritoLegajo LEE WITH(NOLOCK)
													WHERE  LEE.TU_CodEscrito	= D.TU_CodEscrito
												)
			LEFT JOIN	Archivo.Archivo									E WITH(NOLOCK) 
			ON			E.TU_CodArchivo									= C.TU_CodArchivo

			WHERE		A.TC_CodContexto								= @L_CodContexto

			GROUP BY
						A.TC_NumeroExpediente,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						A.TB_EmbargosFisicos

			--Legajos
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT	 	A.TC_NumeroExpediente,	
						A.TU_CodLegajo,	
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,	
						B.TN_CodEstado,
						B.TC_Descripcion,	
						ISNULL(MAX(E.TF_FechaCrea), 
						CAST(@L_FechaMinima AS VARCHAR)),
						ISNULL(MAX(G.TF_FechaIngresoOficina), 
						CAST(@L_FechaMinima AS VARCHAR))						AS FechaUltimoEscrito,
						A.TB_EmbargosFisicos
			FROM		Expediente.Legajo										A WITH(NOLOCK) 						
			OUTER APPLY(
							SELECT  TOP(1)	Y.TC_NumeroExpediente, 
											Y.TC_CodContexto,						
											Y.TN_CodEstado,	
											Y.TC_Movimiento,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.LegajoMovimientoCirculante	 Y WITH(NOLOCK)
							WHERE		    Y.TC_CodContexto						 = A.TC_CodContexto 
							AND				Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente								
							ORDER BY		Y.TF_Fecha DESC, 
											Y.TN_CodLegajoMovimientoCirculante DESC
						) Z												
			INNER JOIN  Catalogo.Estado											B WITH(NOLOCK) 
			ON			B.TN_CodEstado											= Z.TN_CodEstado 
			AND			B.TC_Circulante											= @L_EstadoCirculante
			
			LEFT JOIN	Expediente.LegajoArchivo								C WITH(NOLOCK) 
			ON			C.TU_CodLegajo											= A.TU_CodLegajo 
			AND			C.TC_NumeroExpediente									= A.TC_NumeroExpediente
			
			LEFT JOIN	Expediente.ArchivoExpediente							D WITH(NOLOCK) 
			ON			D.TU_CodArchivo											= C.TU_CodArchivo 
			AND			D.TC_NumeroExpediente									= C.TC_NumeroExpediente
			
			LEFT JOIN	Archivo.Archivo											E WITH(NOLOCK) 
			ON			E.TU_CodArchivo											= D.TU_CodArchivo
			
			LEFT JOIN	Expediente.EscritoLegajo								F WITH(NOLOCK) 
			ON			F.TU_CodLegajo  										= A.TU_CodLegajo 
			
			LEFT JOIN	Expediente.EscritoExpediente							G WITH(NOLOCK) 
			ON			G.TU_CodEscrito											= F.TU_CodEscrito 
			AND			G.TC_CodContexto										= A.TC_CodContexto
			
			WHERE		A.TC_CodContexto										= @L_CodContexto	
			
			GROUP BY
						A.TC_NumeroExpediente,	
						A.TU_CodLegajo,
						Z.Fecha,
						A.TC_CodContexto,
						Z.TC_Movimiento,
						B.TN_CodEstado,
						B.TC_Descripcion,
						A.TB_EmbargosFisicos
		END

		--Si se debe validar sólo los documentos
		ELSE IF(@ValidarDocumento = 1 AND @ValidarEscrito = 0)
		BEGIN			
			--Expedientes
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT  	A.TC_NumeroExpediente,
						NULL,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						ISNULL(MAX(E.TF_FechaCrea), CAST(@L_FechaMinima AS VARCHAR)),												
						CAST(@L_FechaMinima AS VARCHAR),
						A.TB_EmbargosFisicos
			FROM		Expediente.Expediente										A WITH(NOLOCK) 						
			OUTER APPLY(
							SELECT  TOP(1)	Y.TC_NumeroExpediente, 
											Y.TC_CodContexto,						
											Y.TN_CodEstado,	
											Y.TC_Movimiento,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.ExpedienteMovimientoCirculante Y WITH(NOLOCK)
							WHERE		    Y.TF_Fecha								 = A.TF_Inicio 
							AND				Y.TC_CodContexto						 = A.TC_CodContexto 
							AND				Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente								
							ORDER BY		Y.TF_Fecha DESC,
											Y.TN_CodExpedienteMovimientoCirculante DESC
						) Z																																		
			
			INNER JOIN  Catalogo.Estado												B WITH(NOLOCK) 
			ON			B.TN_CodEstado												= Z.TN_CodEstado 
			AND			B.TC_Circulante												= @L_EstadoCirculante

			LEFT JOIN	Expediente.ArchivoExpediente								C WITH(NOLOCK)
			ON			C.TC_NumeroExpediente										= A.TC_NumeroExpediente 
			AND			C.TU_CodArchivo NOT IN(
													SELECT LEA.TU_CodArchivo
													FROM   Expediente.LegajoArchivo LEA WITH(NOLOCK)
													WHERE  LEA.TU_CodArchivo		= C.TU_CodArchivo 
													AND	   LEA.TC_NumeroExpediente	= C.TC_NumeroExpediente
											  )

			LEFT JOIN	Archivo.Archivo												E WITH(NOLOCK) 
			ON			E.TU_CodArchivo												= C.TU_CodArchivo

			WHERE		A.TC_CodContexto											= @L_CodContexto
			
			GROUP BY
						A.TC_NumeroExpediente,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						A.TB_EmbargosFisicos

			--Legajos
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT	 	A.TC_NumeroExpediente,	
						A.TU_CodLegajo,	
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,	
						B.TN_CodEstado,
						B.TC_Descripcion,	
						ISNULL(MAX(E.TF_FechaCrea),	CAST(@L_FechaMinima AS VARCHAR)),						
						CAST(@L_FechaMinima AS VARCHAR),
						A.TB_EmbargosFisicos
			FROM		Expediente.Legajo											 A WITH(NOLOCK) 						
			OUTER APPLY(
							SELECT  TOP(1)	Y.TC_NumeroExpediente, 
											Y.TC_CodContexto,						
											Y.TN_CodEstado,	
											Y.TC_Movimiento,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.LegajoMovimientoCirculante	 Y WITH(NOLOCK)
							WHERE		    Y.TC_CodContexto						 = A.TC_CodContexto 
							AND				Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente								
							ORDER BY		Y.TF_Fecha DESC,
											Y.TN_CodLegajoMovimientoCirculante DESC

						) Z
			
			INNER JOIN  Catalogo.Estado												 B WITH(NOLOCK) 
			ON			B.TN_CodEstado												 = Z.TN_CodEstado 
			AND			B.TC_Circulante												 = @L_EstadoCirculante
																					 
			LEFT JOIN	Expediente.LegajoArchivo									 C WITH(NOLOCK) 
			ON			C.TU_CodLegajo												 = A.TU_CodLegajo 
			AND			C.TC_NumeroExpediente										 = A.TC_NumeroExpediente
																					 
			LEFT JOIN	Expediente.ArchivoExpediente								 D WITH(NOLOCK) 
			ON			D.TU_CodArchivo												 = C.TU_CodArchivo 
			AND			D.TC_NumeroExpediente										 = C.TC_NumeroExpediente
																					 
			LEFT JOIN	Archivo.Archivo												 E WITH(NOLOCK) 
			ON			E.TU_CodArchivo												 = D.TU_CodArchivo
																					 
			WHERE		A.TC_CodContexto											 = @L_CodContexto
			
			GROUP BY	A.TC_NumeroExpediente,	
						A.TU_CodLegajo,
						Z.Fecha,
						A.TC_CodContexto,
						Z.TC_Movimiento,
						B.TN_CodEstado,
						B.TC_Descripcion,
						A.TB_EmbargosFisicos
		END

		--Si se debe validar sólo los escritos
		ELSE IF(@ValidarDocumento = 0 AND @ValidarEscrito = 1)
		BEGIN
			--Expedientes
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT  	A.TC_NumeroExpediente,
						NULL,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						ISNULL(MAX(E.TF_FechaCrea), CAST(@L_FechaMinima AS VARCHAR)),
						ISNULL(MAX(D.TF_FechaIngresoOficina), CAST(@L_FechaMinima AS VARCHAR)),
						A.TB_EmbargosFisicos
			FROM		Expediente.Expediente										 A WITH(NOLOCK)						
			OUTER APPLY (
							SELECT  TOP(1)	Y.TC_Movimiento,
											Y.TN_CodEstado,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.ExpedienteMovimientoCirculante Y WITH(NOLOCK)
							WHERE		    Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente						
							ORDER BY		Y.TF_Fecha DESC,
											Y.TN_CodExpedienteMovimientoCirculante DESC
						) Z
			
			INNER JOIN  Catalogo.Estado												B WITH (NOLOCK) 
			ON			B.TN_CodEstado												= Z.TN_CodEstado 
			AND			B.TC_Circulante												= @L_EstadoCirculante

			LEFT JOIN	Expediente.ArchivoExpediente								C WITH(NOLOCK)
			ON			C.TC_NumeroExpediente										= A.TC_NumeroExpediente 
			AND			C.TU_CodArchivo NOT IN(
													SELECT LEA.TU_CodArchivo
													FROM   Expediente.LegajoArchivo LEA WITH(NOLOCK)
													WHERE  LEA.TU_CodArchivo		= C.TU_CodArchivo 
													AND	   LEA.TC_NumeroExpediente	= C.TC_NumeroExpediente
												)
			
			LEFT JOIN	Expediente.EscritoExpediente								D WITH(NOLOCK) 
			ON			D.TC_NumeroExpediente										= A.TC_NumeroExpediente 
			AND			D.TC_CodContexto											= A.TC_CodContexto
			AND			D.TU_CodEscrito NOT IN(
													SELECT LEE.TU_CodEscrito 
													FROM   Expediente.EscritoLegajo LEE WITH(NOLOCK)
													WHERE  LEE.TU_CodEscrito		= D.TU_CodEscrito
												)

			LEFT JOIN	Archivo.Archivo												E WITH(NOLOCK) 
			ON			E.TU_CodArchivo												= C.TU_CodArchivo

			WHERE		A.TC_CodContexto											= @L_CodContexto
			
			GROUP BY	A.TC_NumeroExpediente,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						A.TB_EmbargosFisicos

			--Legajos
			INSERT INTO @ExpLegajosCandidatos 
			(
				NumeroExpediente,
				CodigoLegajo,
				FechaMovCirculante,
				CodContexto,
				Movimiento,
				Estado,
				EstadoDescripcion,
				FechaUltimoDocumento,
				FechaUltimoEscrito,
				TieneEmbargos
			)
			SELECT	 
					A.TC_NumeroExpediente,	
					A.TU_CodLegajo,	
					Z.Fecha,
					A.TC_CodContexto,			
					Z.TC_Movimiento,	
					B.TN_CodEstado,
					B.TC_Descripcion,				
					CAST(@L_FechaMinima AS VARCHAR),
					ISNULL(MAX(F.TF_FechaIngresoOficina), CAST(@L_FechaMinima AS VARCHAR)) 	AS FechaUltimoEscrito,
					A.TB_EmbargosFisicos
			FROM		Expediente.Legajo														A WITH(NOLOCK) 						
			OUTER APPLY(
							SELECT  TOP(1)	Y.TC_NumeroExpediente, 
											Y.TC_CodContexto,						
											Y.TN_CodEstado,	
											Y.TC_Movimiento,
											Y.TF_Fecha							 	 AS Fecha
							FROM			Historico.LegajoMovimientoCirculante	 Y WITH(NOLOCK)
							WHERE		    Y.TC_CodContexto						 = A.TC_CodContexto 
							AND				Y.TC_NumeroExpediente					 = A.TC_NumeroExpediente															
							ORDER BY		Y.TF_Fecha DESC,
											Y.TN_CodLegajoMovimientoCirculante DESC
						) Z								
			
			INNER JOIN  Catalogo.Estado														B WITH(NOLOCK) 
			ON			B.TN_CodEstado														= Z.TN_CodEstado 
			AND			B.TC_Circulante														= @L_EstadoCirculante
			
			LEFT JOIN	Expediente.LegajoArchivo											C WITH(NOLOCK) 
			ON			C.TU_CodLegajo														= A.TU_CodLegajo 
			AND			C.TC_NumeroExpediente												= A.TC_NumeroExpediente
			
			LEFT JOIN	Expediente.EscritoLegajo											D WITH(NOLOCK) 
			ON			D.TU_CodLegajo  													= A.TU_CodLegajo 
			
			LEFT JOIN	Expediente.EscritoExpediente										F WITH(NOLOCK) 
			ON			F.TU_CodEscrito														= F.TU_CodEscrito 
			AND			F.TC_CodContexto													= A.TC_CodContexto													
						
			WHERE	    A.TC_CodContexto												    = @L_CodContexto
			GROUP BY
						A.TC_NumeroExpediente,
						A.TU_CodLegajo,
						Z.Fecha,
						A.TC_CodContexto,			
						Z.TC_Movimiento,
						B.TN_CodEstado,			
						B.TC_Descripcion,
						A.TB_EmbargosFisicos
		END

		--=============================================================================================================
		--SECCION DONDE SE REALIZAR ELIMINACION DE REGISTROS QUE NO CUMPLEN CON LAS REGLAS DE NEGOCIO DE LOS EXPEDIENTES Y LEGAJOS CANDIDATOS

		--Eliminamos registros que tengan escritos pendientes
		--Expedientes
		DELETE FROM @ExpLegajosCandidatos 
		WHERE CodigoLegajo IS NULL
		AND NumeroExpediente =
		(
			SELECT TOP 1(TC_NumeroExpediente)
			FROM Expediente.EscritoExpediente EE
			WHERE TC_NumeroExpediente = NumeroExpediente
			AND TC_EstadoEscrito NOT IN ('R','E')
			AND TU_CodEscrito NOT IN
			(
				SELECT TU_CodEscrito
				FROM Expediente.EscritoLegajo EL
				WHERE EL.TU_CodEscrito = EE.TU_CodEscrito
			)
		)

		--Legajos
		DELETE FROM @ExpLegajosCandidatos
		WHERE CodigoLegajo IS NOT NULL
		AND CodigoLegajo =
		(
			SELECT TOP 1(B.TU_CodLegajo)
			FROM Expediente.EscritoExpediente A
			INNER JOIN Expediente.EscritoLegajo B
			ON A.TU_CodEscrito = B.TU_CodEscrito
			WHERE A.TC_NumeroExpediente = NumeroExpediente
			AND B.TU_CodLegajo = CodigoLegajo
			AND A.TC_EstadoEscrito NOT IN ('R','E')
		)

		--=============================================================================================================
		--INSERCION EN TABLA DEPURACIONINACTIVO

		--Se inserta los registros en la tabla de depuración
		INSERT INTO [Expediente].[DetalleDepuracionInactivo]
		(
			[TN_CodSolicitud],
			[TC_NumeroExpediente],
			[TU_CodLegajo],
			[TB_TieneMandamientos],
			[TB_TieneDepositos],
			[TB_TieneEmbargos],
			[TF_UltimoAcontecimiento],
			[TC_TipoAcontecimiento],
			[TC_Estado],
			[TC_Resultado],
			[TN_CodEstado],
			[TC_DescripcionEstado]
		)
		SELECT
			@L_CodSolicitud,
			NumeroExpediente,
			CodigoLegajo,
			0,
			0,
			TieneEmbargos,
			(
				SELECT CASE 
					WHEN MAX(FechaUltimoDocumento) > MAX(FechaUltimoEscrito)
						THEN MAX(FechaUltimoDocumento)
					WHEN MAX(FechaUltimoEscrito) > MAX(FechaUltimoDocumento)  
						THEN MAX(FechaUltimoEscrito)
					ELSE 
						CAST(@L_FechaMinima as varchar)
				END
			),
			(
				SELECT CASE	
					WHEN MAX(FechaUltimoDocumento) > MAX(FechaUltimoEscrito)  
						THEN 'D'
					WHEN MAX(FechaUltimoEscrito) > MAX(FechaUltimoDocumento)  
						THEN 'E'
					ELSE NULL
			END
			),
			'E',
			'Se ha presentado un error al consultar los mandamientos del expediente y depósitos del expediente.',
			Estado, 
			EstadoDescripcion
		FROM @ExpLegajosCandidatos
		GROUP BY NumeroExpediente, CodigoLegajo, FechaUltimoDocumento, FechaUltimoEscrito, Estado, EstadoDescripcion, TieneEmbargos
		HAVING MAX(FechaUltimoDocumento) < CAST(@L_Corte AS VARCHAR)
		AND MAX(FechaUltimoEscrito) < CAST(@L_Corte AS VARCHAR)

		--=============================================================================================================
		--CONSULTA FINAL 

		--Se devuelven los datos
		SELECT 
			A.[TN_CodSolicitud]				AS	CodigoSolicitud,
			A.[TN_CodDetalleDepuracion]		AS  CodigoDepuracionInactivo,
			B.[TC_CodContexto]				AS  CodigoContexto,
			[TC_NumeroExpediente]			AS	NumeroExpediente,
			[TU_CodLegajo]					AS	CodigoLegajo,
			[TB_TieneMandamientos]			AS	TieneMandamientos,
			[TB_TieneDepositos]				AS	TieneDepositos,
			[TB_TieneEmbargos]				AS	TieneEmbargos,
			[TF_UltimoAcontecimiento]		AS	UltimoAcontecimiento,
			[TC_Resultado]					AS	ResultadoSolicitud,
			'Split'							AS  Split,
			[TC_TipoAcontecimiento]			AS	TipoAcontecimiento,
			A.[TC_Estado]					AS	EstadoSolicitud	

		FROM [Expediente].[DetalleDepuracionInactivo] AS A
		INNER JOIN [Expediente].[SolicitudCargaInactivo] AS B ON B.TN_CodSolicitud = A.TN_CodSolicitud
		WHERE A.[TN_CodSolicitud]				=	@L_CodSolicitud
		
END
GO
