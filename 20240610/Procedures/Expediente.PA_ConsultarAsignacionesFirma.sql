SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================================================================================================================================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creacion: <13/10/2017>
-- Descripcion:	   <Consulta la lista de asignaciones (Tabla Maestra) segun el puesto de trabajo>
-- Devuelve lista de asignaciones segun el puesto de trabajo.
-- ====================================================================================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <20/09/2018> <Se cambia el nombre del sp y si actualizan los esquema de las tablas >
-- Modificación		<Isaac Dobles Mata> <24/09/2019> <Se ajusta a estructura nueva de expedientes y se corrige error de consulta de asignaciones>
-- Modificación		<Daniel Ruiz Hernandez> <07/08/2020> <Se agrega clase del expediente>
-- Modificación		<Daniel Ruiz Hernandez> <30/09/2020> <Se modifica select para obtener el codigo del archivo firmado>
-- Modificación		<Aida Elena Siles Rojas> <15/03/2021> <Se modifica para obtener el codigo del legajo del archivo>
-- Modificación		<Jose Gabriel Cordero Soto> <22/03/2021> <Se agrega campo indicador de generador de voto automatico en consulta>
-- Modificación		<Aida Elena Siles Rojas> <07/06/2021> <Se agrega el tipo puesto de trabajo en la consulta>
-- Modificación		<Roger Lara> <17/06/2021> <Se agrega validacion por contexto  y se permite consultar las firmas asigandas sin importar el orden>
-- Modificación		<Miguel Avendaño> <28/07/2021> <Se modifica para que liste correctamente las asignaciones de firma con correcciones>
-- Modificación		<Aida Elena Siles Rojas> <05/08/2021> <Se modifica para obtener si el documento a firmar falla expedientes y legajos>
-- Modificación		<Jose Gabriel Cordero Soto> <09/09/2021> <Se agrega contextos para expediente y para legajos asociados>
-- Modificación		<Jonathan Aguilar Navarro> <27/09/2021> <Se agrga a la consulta EmiteComunicacionAutomatica.>
-- Modificación		<Aida Elena Siles Rojas> <22/10/2021> <Se cambia a Left Join la consulta sobre la tabla Expediente.ExpedienteDetalle. Lo anterior 
--                  para que los documentos a firmar de legajos sin expediente puedan visualizarse. Adicionalmente se hace ajuste para tomar el contexto del legajo de la tabla Expediente.Legajo>
-- Modificación		<Luis Alonso Leiva Tames> <26/04/2022> <Se agrega la validación para ExpedienteDetalle E.TC_CodContexto = @L_CodContexto, ya que presentaba datos duplicados>
-- Modificación		<Ronny Ramírez R.> <26/07/2022> <Se aplica corrección para enviar GUID de TU_CodArchivo si el TU_CodArchivoFirmado está en 0s, en campo CodigoArchivoFirmado>
-- Modificación		<Ronny Ramírez R.> <14/07/2023> <Se aplican ajustes para optimizar la consulta, incluyendo un segundo DataSet con la lista de firmantes de cada asignación de firma e incluyendo OPTION(RECOMPILE)>
-- ====================================================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarAsignacionesFirma]
	@Codigo				UNIQUEIDENTIFIER,
	@CodEstado			VARCHAR(2),	
	@CodPuestoTrabajo	VARCHAR(14),
	@CodLegajoArchivo	UNIQUEIDENTIFIER,
	@EstadoParaFirmar	VARCHAR(2),
	@CodContexto		VARCHAR(4) = NULL
AS
BEGIN
	--VARIABLES
DECLARE 	@L_Codigo				UNIQUEIDENTIFIER	=	@Codigo,
			@L_CodEstado			VARCHAR(2)			=	@CodEstado,	
			@L_CodPuestoTrabajo		VARCHAR(14)			=	@CodPuestoTrabajo,
			@L_CodLegajoArchivo		UNIQUEIDENTIFIER	=	@CodLegajoArchivo,
			@L_EstadoParaFirmar		VARCHAR(2)			=	@EstadoParaFirmar,
			@L_CodContexto			VARCHAR(4)			=	@CodContexto

DECLARE		@Resultado TABLE	
			(
				Codigo								UNIQUEIDENTIFIER	NOT NULL,
				FechaAsignacion						DATETIME2(7)		NULL,
				Urgente								BIT					NULL,
				Observacion							VARCHAR(300)		NULL,
				--Archivo asignado												
				CodigoArchivo						UNIQUEIDENTIFIER	NULL,
				Descripcion							VARCHAR(255)		NULL,
				FechaCrea							DATETIME2(7)		NULL,
				CodigoGrupoTrabajo					SMALLINT			NULL,
				DescripcionGrupoTrabajo				VARCHAR(255)		NULL,
				--Archivo firmado
				CodigoArchivoFirmado				UNIQUEIDENTIFIER	NULL,	
				DescripcionArchivoFirmado			VARCHAR(255)		NULL,
				CodigoFS							UNIQUEIDENTIFIER	NULL,
				--Asignador por
				CodigoAsignadoPor					UNIQUEIDENTIFIER	NULL,
				UsuarioRed							VARCHAR(30)			NULL,
				Nombre								VARCHAR(50)			NULL,
				PrimerApellido						VARCHAR(50)			NULL,
				SegundoApellido						VARCHAR(50)			NULL,
				CodPuestoTrabajoAsignadoPor			VARCHAR(14)			NULL,
				DescripcionPuestoAsignadoPor		VARCHAR(75)			NULL,
				CodTipoPuestoTrabajoAsignadoPor		SMALLINT			NULL,
				DescripTipoPuestoTrabajoAsignadoPor	VARCHAR(100)		NULL,
				--Devuelto por
				CodigoDevueltoPor					UNIQUEIDENTIFIER	NULL,
				UsuarioRedDevueltoPor				VARCHAR(30)			NULL,
				NombreDevueltoPor					VARCHAR(50)			NULL,
				PrimerApellidoDevueltoPor			VARCHAR(50)			NULL,
				SegundoApellidoDevueltoPor			VARCHAR(50)			NULL,
				CodPuestoTrabajoDevueltoPor			VARCHAR(14)			NULL,
				DescripcionPuestoDevueltoPor		VARCHAR(75)			NULL,
				--Corregido por
				CodigoCorregidoPor					UNIQUEIDENTIFIER	NULL,
				UsuarioCorregidoPor					VARCHAR(30)			NULL,
				NombreCorregidoPor					VARCHAR(50)			NULL,
				PrimerApellidoCorregidoPor			VARCHAR(50)			NULL,
				SegundoApellidoCorregidoPor			VARCHAR(50)			NULL,
				CodPuestoTrabajoCorregidoPor		VARCHAR(14)			NULL,
				DescripcionPuestoCorregidoPor		VARCHAR(75)			NULL,
				--Expediente
				DescripcionExpediente				VARCHAR(255)		NULL,
				NumeroExpediente					VARCHAR(14)			NULL,
				CodigoContexto						VARCHAR(4)			NULL,
				--Legajo
				CodigoLegajo						UNIQUEIDENTIFIER	NULL,
				CodigoContextolegajo				VARCHAR(4)			NULL,
				--Clase Asunto
				CodigoClase							INT					NULL,
				DescripcionClase					VARCHAR(200)		NULL,
				Orden								TINYINT				NULL,
				FechaAplicado						DATETIME2(7)		NULL,
				--Devuelto a
				UsuarioRedDevueltoA					VARCHAR(30)			NULL,
				NombreDevueltoA						VARCHAR(50)			NULL,
				PrimerApellidoDevueltoA				VARCHAR(50)			NULL,
				SegundoApellidoDevueltoA			VARCHAR(50)			NULL,
				CodPuestoTrabajoDevueltoA			VARCHAR(14)			NULL,
				DescripcionPuestoDevueltoA			VARCHAR(75)			NULL,
				-- Estado y fecha devolución
				EstadoAsignacion					CHAR(1)				NULL,
				FechaDevolucion						DATETIME2(7)		NULL,
				--ArchivoDato
				GenerarVotoAutomatico				BIT					NULL,
				FallaExpLeg							BIT					NULL,
				EmiteComunicacionAutomatica			VARCHAR(8)			NULL
			)

	IF @L_CodPuestoTrabajo IS NULL OR @L_CodPuestoTrabajo =''
		BEGIN
		
			INSERT INTO	@Resultado 
			(
						Codigo,							
						FechaAsignacion,
						Urgente,
						Observacion,					
						CodigoArchivo,					
						Descripcion,
						FechaCrea,
						CodigoGrupoTrabajo,
						DescripcionGrupoTrabajo,
						CodigoArchivoFirmado,
						DescripcionArchivoFirmado,		
						CodigoFS,
						CodigoAsignadoPor,
						UsuarioRed,
						Nombre,
						PrimerApellido,
						SegundoApellido,
						CodPuestoTrabajoAsignadoPor,
						DescripcionPuestoAsignadoPor,
						CodTipoPuestoTrabajoAsignadoPor,
						DescripTipoPuestoTrabajoAsignadoPor,	
						CodigoDevueltoPor,					
						UsuarioRedDevueltoPor,					
						NombreDevueltoPor,
						PrimerApellidoDevueltoPor,
						SegundoApellidoDevueltoPor,			
						CodPuestoTrabajoDevueltoPor,			
						DescripcionPuestoDevueltoPor,		
						CodigoCorregidoPor,					
						UsuarioCorregidoPor,					
						NombreCorregidoPor,					
						PrimerApellidoCorregidoPor,			
						SegundoApellidoCorregidoPor,			
						CodPuestoTrabajoCorregidoPor,		
						DescripcionPuestoCorregidoPor,	
						DescripcionExpediente,				
						NumeroExpediente,					
						CodigoContexto,	
						CodigoLegajo,						
						CodigoContextolegajo,				
						CodigoClase,							
						DescripcionClase,							
						Orden,
						FechaAplicado,
						UsuarioRedDevueltoA,					
						NombreDevueltoA,						
						PrimerApellidoDevueltoA,				
						SegundoApellidoDevueltoA,			
						CodPuestoTrabajoDevueltoA,			
						DescripcionPuestoDevueltoA,			
						EstadoAsignacion,					
						FechaDevolucion,	
						GenerarVotoAutomatico,				
						FallaExpLeg,							
						EmiteComunicacionAutomatica			
			)
			SELECT		A.[TU_CodAsignacionFirmado]		AS Codigo,
						A.[TF_FechaAsigna]				AS FechaAsignacion,
						A.[TB_Urgente]					AS Urgente,
						A.[TC_Observacion]				AS Observacion,
						--'Split'							AS Split,
						B.TU_CodArchivo					AS  Codigo,
						B.TC_Descripcion				AS Descripcion,
						B.TF_FechaCrea					AS FechaCrea,
						C.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,
						C.TC_Descripcion				AS DescripcionGrupoTrabajo,
						--'Split'							AS Split,
						CASE 
							WHEN A.TU_CodArchivoFirmado = CAST(0x0 AS UNIQUEIDENTIFIER)
							THEN B.TU_CodArchivo
							ELSE ISNULL(A.TU_CodArchivoFirmado, B.TU_CodArchivo)
						END								AS CodigoArchivoFirmado,
						B.TC_Descripcion				AS Descripcion,	
						A.TU_CodArchivoFirmado			AS CodigoFS,					 
						--Asignador por
						--'Split'							AS Split,
						A.[TU_AsignadoPor]				AS CodigoAsignadoPor,				
						H.UsuarioRed,
						H.Nombre,
						H.PrimerApellido,
						H.SegundoApellido,		
						I.TC_CodPuestoTrabajo			AS CodPuestoTrabajoAsignadoPor,
						I.TC_Descripcion				AS DescripcionPuestoAsignadoPor,	
						TP.TN_CodTipoPuestoTrabajo		AS CodTipoPuestoTrabajoAsignadoPor,
						TP.TC_Descripcion				AS DescripTipoPuestoTrabajoAsignadoPor,
						--Devuelto por
						--'Split' 						AS Split,
						A.[TU_DevueltoPor]				AS CodigoDevueltoPor,
						K.UsuarioRed,
						K.Nombre,
						K.PrimerApellido,
						K.SegundoApellido,
						L.TC_CodPuestoTrabajo			AS CodPuestoTrabajoDevueltoPor,
						L.TC_Descripcion				AS DescripcionPuestoDevueltoPor,	
						--Corregido por
						--'Split' 						AS Split,
						A.[TU_CorregidoPor]				AS CodigoCorregidoPor,
						N.UsuarioRed,
						N.Nombre,
						N.PrimerApellido,
						N.SegundoApellido,	
						O.TC_CodPuestoTrabajo			AS CodPuestoTrabajoCorregidoPor,
						O.TC_Descripcion				AS DescripcionPuestoCorregidoPor,
						--'Split' 						AS Split,
						--Expediente
						R.TC_Descripcion				AS DescripcionExpediente,
						AE.TC_NumeroExpediente			AS NumeroExpediente,	
						R.TC_CodContexto				AS CodigoContexto,
						--Legajo
						LA.TU_CodLegajo					AS CodigoLegajo,
						T.TC_CodContexto				AS CodigoContextolegajo,
						--Clase Asunto
						CA.TN_CodClase					AS CodigoClase,
						CA.TC_Descripcion				AS DescripcionClase,
						NULL,
						NULL,
						P.UsuarioRed					AS UsuarioRedDevueltoA,
						P.Nombre						AS NombreDevueltoA,
						P.PrimerApellido				AS PrimerApellidoDevueltoA,		
						P.SegundoApellido				AS SegundoApellidoDevueltoA,	
						Q.TC_CodPuestoTrabajo			AS CodPuestoTrabajoDevueltoA,
						Q.TC_Descripcion				AS DescripcionPuestoDevueltoA,
						A.TC_Estado						AS EstadoAsignacion,
						A.TF_FechaDevolucion			AS FechaDevolucion,
						--ArchivoDato
						B.TB_GenerarVotoAutomatico	    AS GenerarVotoAutomatico,
						FJ.TB_PaseFallo					AS FallaExpLeg,			
						FC.TC_CodFormatoJuridico        AS EmiteComunicacionAutomatica

			FROM		[Archivo].[AsignacionFirmado]	AS A		
			INNER JOIN	[Archivo].Archivo				AS B WITH(NOLOCK)
			ON			A.TU_CodArchivo					=  B.TU_CodArchivo
			INNER JOIN	Expediente.ArchivoExpediente	AS AE WITH (Nolock)
			ON			AE.TU_CodArchivo				=  B.TU_CodArchivo
			INNER JOIN	Catalogo.GrupoTrabajo			AS C WITH(NOLOCK) 
			ON			AE.TN_CodGrupoTrabajo			=  C.TN_CodGrupoTrabajo
			LEFT JOIN	Expediente.LegajoArchivo		AS LA WITH(NOLOCK)
			ON			LA.TU_CodArchivo				=  AE.TU_CodArchivo
			LEFT JOIN	Expediente.Legajo				AS T WITH(NOLOCK)
			ON			T.TU_CodLegajo					= LA.TU_CodLegajo
			INNER JOIN	Expediente.Expediente			AS R WITH(NOLOCK)
			ON			R.TC_NumeroExpediente			=  AE.TC_NumeroExpediente
			LEFT JOIN	Expediente.ExpedienteDetalle	AS E WITH(NOLOCK)
			ON			E.TC_NumeroExpediente			=  R.TC_NumeroExpediente  AND E.TC_CodContexto = @L_CodContexto
			LEFT JOIN	Catalogo.Clase					AS CA With (NoLock)
			ON			CA.TN_CodClase					=  E.TN_CodClase
			LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
			ON			B.TC_CodFormatoJuridico			= FC.TC_CodFormatoJuridico  
			AND			B.TC_CodContextoCrea			= FC.TC_CodContexto 
			AND			FC.TF_Inicio_Vigencia			<= GETDATE()																
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario	G WITH(NOLOCK) 
			ON			A.TU_AsignadoPor				= G.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			LEFT JOIN	Catalogo.PuestoTrabajo			I WITH(NOLOCK) 
			ON			G.TC_CodPuestoTrabajo			= I.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.TipoPuestoTrabajo		TP WITH(NOLOCK)
			ON			I.TN_CodTipoPuestoTrabajo		= TP.TN_CodTipoPuestoTrabajo
			--Devuelto por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario J WITH(NOLOCK) 
			ON			A.TU_DevueltoPor = J.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			LEFT JOIN	Catalogo.PuestoTrabajo			L WITH(NOLOCK) 
			ON			J.TC_CodPuestoTrabajo			= L.TC_CodPuestoTrabajo
			--Corregido por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario M WITH(NOLOCK) 
			ON			A.[TU_CorregidoPor]				= M.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			LEFT JOIN	Catalogo.PuestoTrabajo			O WITH(NOLOCK) 
			ON			M.TC_CodPuestoTrabajo			= O.TC_CodPuestoTrabajo
			--Devuelto a
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
			LEFT JOIN	Catalogo.PuestoTrabajo			Q WITH(NOLOCK) 
			ON			A.TU_DevueltoA					= Q.TC_CodPuestoTrabajo
			LEFT JOIN   Catalogo.FormatoJuridico		FJ WITH(NOLOCK)
			ON			B.TC_CodFormatoJuridico			= FJ.TC_CodFormatoJuridico

			WHERE		A.TU_CodAsignacionFirmado		= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) 
			AND			A.TC_Estado						= ISNULL(@L_CodEstado, A.TC_Estado) 
			AND			B.TU_CodArchivo					= ISNULL(@L_CodLegajoArchivo, B.TU_CodArchivo)
			AND			B.TC_CodContextoCrea			= COALESCE(@L_CodContexto, B.TC_CodContextoCrea)
			OPTION(RECOMPILE)
		END
	ELSE
		BEGIN
		IF @L_CodEstado = @L_EstadoParaFirmar
			BEGIN
				INSERT INTO	@Resultado
				(
						Codigo,							
						FechaAsignacion,
						Urgente,
						Observacion,					
						CodigoArchivo,					
						Descripcion,
						FechaCrea,
						CodigoGrupoTrabajo,
						DescripcionGrupoTrabajo,
						CodigoArchivoFirmado,
						DescripcionArchivoFirmado,		
						CodigoFS,
						CodigoAsignadoPor,
						UsuarioRed,
						Nombre,
						PrimerApellido,
						SegundoApellido,
						CodPuestoTrabajoAsignadoPor,
						DescripcionPuestoAsignadoPor,
						CodTipoPuestoTrabajoAsignadoPor,
						DescripTipoPuestoTrabajoAsignadoPor,	
						CodigoDevueltoPor,					
						UsuarioRedDevueltoPor,					
						NombreDevueltoPor,
						PrimerApellidoDevueltoPor,
						SegundoApellidoDevueltoPor,			
						CodPuestoTrabajoDevueltoPor,			
						DescripcionPuestoDevueltoPor,		
						CodigoCorregidoPor,					
						UsuarioCorregidoPor,					
						NombreCorregidoPor,					
						PrimerApellidoCorregidoPor,			
						SegundoApellidoCorregidoPor,			
						CodPuestoTrabajoCorregidoPor,		
						DescripcionPuestoCorregidoPor,	
						DescripcionExpediente,				
						NumeroExpediente,					
						CodigoContexto,	
						CodigoLegajo,						
						CodigoContextolegajo,				
						CodigoClase,							
						DescripcionClase,							
						Orden,
						FechaAplicado,
						UsuarioRedDevueltoA,					
						NombreDevueltoA,						
						PrimerApellidoDevueltoA,				
						SegundoApellidoDevueltoA,			
						CodPuestoTrabajoDevueltoA,			
						DescripcionPuestoDevueltoA,			
						EstadoAsignacion,					
						FechaDevolucion,	
						GenerarVotoAutomatico,				
						FallaExpLeg,							
						EmiteComunicacionAutomatica
			)
				SELECT		A.[TU_CodAsignacionFirmado]					AS Codigo,
							A.[TF_FechaAsigna]							AS FechaAsignacion,
							A.[TB_Urgente]								AS Urgente,
							A.[TC_Observacion]							AS Observacion,		
							--'Split' 									AS Split,
							B.TU_CodArchivo								AS  Codigo,
							B.TC_Descripcion							AS Descripcion,
							B.TF_FechaCrea								AS FechaCrea,
							D.TN_CodGrupoTrabajo						AS CodigoGrupoTrabajo,
							D.TC_Descripcion							AS DescripcionGrupoTrabajo,
							--'Split' 									AS Split,
							CASE 
								WHEN A.TU_CodArchivoFirmado = CAST(0x0 AS UNIQUEIDENTIFIER)
								THEN B.TU_CodArchivo
								ELSE ISNULL(A.TU_CodArchivoFirmado, B.TU_CodArchivo)
							END											AS  CodigoArchivoFirmado,			
							B.TC_Descripcion							AS Descripcion,
							A.TU_CodArchivoFirmado						AS CodigoFS,						 
							--Asignado por
							--'Split' 									AS Split,
							A.[TU_AsignadoPor]							AS CodigoAsignadoPor,				
							H.UsuarioRed,
							H.Nombre,
							H.PrimerApellido,
							H.SegundoApellido,		
							G.TC_CodPuestoTrabajo						AS CodPuestoTrabajoAsignadoPor,
							I.TC_Descripcion							AS DescripcionPuestoAsignadoPor,
							TP.TN_CodTipoPuestoTrabajo					AS CodTipoPuestoTrabajoAsignadoPor,
							TP.TC_Descripcion							AS DescripTipoPuestoTrabajoAsignadoPor,
							--Devuelto por
							--'Split' 									AS Split,
							A.TU_DevueltoPor							AS CodigoDevueltoPor,
							K.UsuarioRed,
							K.Nombre,
							K.PrimerApellido,
							K.SegundoApellido,
							J.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoPor,
							L.TC_Descripcion							AS DescripcionPuestoDevueltoPor,			
							--Corregido por
							--'Split' 									AS Split,
							A.TU_CorregidoPor							AS CodigoCorregidoPor,
							N.UsuarioRed,
							N.Nombre,
							N.PrimerApellido,
							N.SegundoApellido,	
							O.TC_CodPuestoTrabajo						AS CodPuestoTrabajoCorregidoPor,
							O.TC_Descripcion							AS DescripcionPuestoBCorregidoPor,			
							--'Split' 									AS Split,
							--Expediente
							R.TC_Descripcion							AS DescripcionExpediente,
							AE.TC_NumeroExpediente						AS NumeroExpediente,
							R.TC_CodContexto							AS CodigoContexto,
							--Legajo
							LA.TU_CodLegajo								AS CodigoLegajo,
							T.TC_CodContexto							AS CodigoContextolegajo,
							--Clase Asunto
							CA.TN_CodClase								AS CodigoClase,
							CA.TC_Descripcion							AS DescripcionClase,
							C.TN_Orden									AS Orden,
							C.TF_FechaAplicado							AS FechaAplicado,
							S.UsuarioRed								AS UsuarioRedDevueltoA,
							S.Nombre									AS NombreDevueltoA,
							S.PrimerApellido							AS PrimerApellidoDevueltoA,		
							S.SegundoApellido							AS SegundoApellidoDevueltoA,	
							Q.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoA,
							Q.TC_Descripcion							AS DescripcionPuestoDevueltoA,
							A.TC_Estado									AS EstadoAsignacion,
							A.TF_FechaDevolucion						AS FechaDevolucion,
							--ArchivoDato
							B.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico,
							FJ.TB_PaseFallo								AS FallaExpLeg,
							FC.TC_CodFormatoJuridico					AS EmiteComunicacionAutomatica
						
				FROM		[Archivo].[AsignacionFirmado]				AS A		
				INNER JOIN	[Archivo].Archivo							B WITH(NOLOCK)
				ON			A.TU_CodArchivo								= B.TU_CodArchivo
				INNER JOIN	Expediente.ArchivoExpediente				AS AE WITH(NOLOCK)
				ON			AE.TU_CodArchivo							= B.TU_CodArchivo
				LEFT JOIN	Expediente.LegajoArchivo					AS LA WITH(NOLOCK)
				ON			LA.TU_CodArchivo							= AE.TU_CodArchivo
				LEFT JOIN	Expediente.Legajo							AS T WITH(NOLOCK)
				ON			T.TU_CodLegajo								= LA.TU_CodLegajo
				INNER JOIN	Archivo.AsignacionFirmante					C WITH(NOLOCK)
				ON			A.TU_CodAsignacionFirmado					= C.TU_CodAsignacionFirmado 
				AND			C.TC_CodPuestoTrabajo						= @L_CodPuestoTrabajo
				INNER JOIN	Catalogo.GrupoTrabajo						D WITH(NOLOCK) 
				ON			AE.TN_CodGrupoTrabajo						= D.TN_CodGrupoTrabajo
				INNER JOIN	Expediente.Expediente						AS R WITH(NOLOCK)
				ON			R.TC_NumeroExpediente						= AE.TC_NumeroExpediente
				LEFT JOIN	Expediente.ExpedienteDetalle				AS E WITH(NOLOCK)
				ON			E.TC_NumeroExpediente						= R.TC_NumeroExpediente AND E.TC_CodContexto = @L_CodContexto
				LEFT JOIN	Catalogo.Clase								AS CA WITH(NOLOCK)
				ON			CA.TN_CodClase								= E.TN_CodClase
				LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto	FC WITH(NOLOCK)   
				ON			B.TC_CodFormatoJuridico						= FC.TC_CodFormatoJuridico  
				AND			B.TC_CodContextoCrea						= FC.TC_CodContexto 
				AND			FC.TF_Inicio_Vigencia						<= GETDATE()																	
				--Asignador por
				INNER JOIN  Catalogo.PuestoTrabajoFuncionario			G WITH(NOLOCK) 
				ON			A.TU_AsignadoPor							= G.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
				LEFT JOIN	Catalogo.PuestoTrabajo						I WITH(NOLOCK) 
				ON			G.TC_CodPuestoTrabajo						= I.TC_CodPuestoTrabajo
				LEFT JOIN	Catalogo.TipoPuestoTrabajo					TP WITH(NOLOCK)
				ON			I.TN_CodTipoPuestoTrabajo					= TP.TN_CodTipoPuestoTrabajo
				--Devuelto por
				LEFT JOIN	Catalogo.PuestoTrabajoFuncionario			J WITH(NOLOCK) 
				ON			A.TU_DevueltoPor							= J.TU_CodPuestoFuncionario
				OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
				LEFT JOIN	Catalogo.PuestoTrabajo						L WITH(NOLOCK) 
				ON			J.TC_CodPuestoTrabajo						= L.TC_CodPuestoTrabajo
				--Corregido por
				LEFT JOIN	Catalogo.PuestoTrabajoFuncionario			M WITH(NOLOCK) 
				ON			A.[TU_CorregidoPor]							= M.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
				LEFT JOIN	Catalogo.PuestoTrabajo						O WITH(NOLOCK) 
				ON			M.TC_CodPuestoTrabajo						= O.TC_CodPuestoTrabajo
				--Devuelto a
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) S
				LEFT JOIN	Catalogo.PuestoTrabajo						Q WITH(NOLOCK) 
				ON			A.TU_DevueltoA								= Q.TC_CodPuestoTrabajo
				LEFT JOIN   Catalogo.FormatoJuridico					FJ WITH(NOLOCK)
				ON			B.TC_CodFormatoJuridico						= FJ.TC_CodFormatoJuridico

				WHERE		A.TU_CodAsignacionFirmado					= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado)
				AND			A.TC_Estado									= ISNULL(@L_CodEstado, A.TC_Estado) 
				AND			B.TU_CodArchivo								= ISNULL(@L_CodLegajoArchivo, B.TU_CodArchivo) 
				AND			C.TF_FechaAplicado IS NULL
				AND			B.TC_CodContextoCrea						= COALESCE(@L_CodContexto, B.TC_CodContextoCrea)
				ORDER BY	C.TU_CodAsignacionFirmado, C.TN_Orden
				OPTION(RECOMPILE)
			END
		ELSE
			BEGIN
				INSERT INTO	@Resultado
				(
						Codigo,							
						FechaAsignacion,
						Urgente,
						Observacion,					
						CodigoArchivo,					
						Descripcion,
						FechaCrea,
						CodigoGrupoTrabajo,
						DescripcionGrupoTrabajo,
						CodigoArchivoFirmado,
						DescripcionArchivoFirmado,		
						CodigoFS,
						CodigoAsignadoPor,
						UsuarioRed,
						Nombre,
						PrimerApellido,
						SegundoApellido,
						CodPuestoTrabajoAsignadoPor,
						DescripcionPuestoAsignadoPor,
						CodTipoPuestoTrabajoAsignadoPor,
						DescripTipoPuestoTrabajoAsignadoPor,	
						CodigoDevueltoPor,					
						UsuarioRedDevueltoPor,					
						NombreDevueltoPor,
						PrimerApellidoDevueltoPor,
						SegundoApellidoDevueltoPor,			
						CodPuestoTrabajoDevueltoPor,			
						DescripcionPuestoDevueltoPor,		
						CodigoCorregidoPor,					
						UsuarioCorregidoPor,					
						NombreCorregidoPor,					
						PrimerApellidoCorregidoPor,			
						SegundoApellidoCorregidoPor,			
						CodPuestoTrabajoCorregidoPor,		
						DescripcionPuestoCorregidoPor,	
						DescripcionExpediente,				
						NumeroExpediente,					
						CodigoContexto,	
						CodigoLegajo,						
						CodigoContextolegajo,				
						CodigoClase,							
						DescripcionClase,							
						Orden,
						FechaAplicado,
						UsuarioRedDevueltoA,					
						NombreDevueltoA,						
						PrimerApellidoDevueltoA,				
						SegundoApellidoDevueltoA,			
						CodPuestoTrabajoDevueltoA,			
						DescripcionPuestoDevueltoA,			
						EstadoAsignacion,					
						FechaDevolucion,	
						GenerarVotoAutomatico,				
						FallaExpLeg,							
						EmiteComunicacionAutomatica			
			)
				SELECT		A.[TU_CodAsignacionFirmado]					AS Codigo,
							A.[TF_FechaAsigna]							AS FechaAsignacion,
							A.[TB_Urgente]								AS Urgente,
							A.[TC_Observacion]							AS Observacion,		
							--'Split' 									AS Split,
							B.TU_CodArchivo								AS  Codigo,
							B.TC_Descripcion							AS Descripcion,
							B.TF_FechaCrea								AS FechaCrea, 
							D.TN_CodGrupoTrabajo						AS CodigoGrupoTrabajo,
							D.TC_Descripcion							AS DescripcionGrupoTrabajo,
							--'Split' 									AS Split,
							CASE 
								WHEN A.TU_CodArchivoFirmado = CAST(0x0 AS UNIQUEIDENTIFIER)
								THEN B.TU_CodArchivo
								ELSE ISNULL(A.TU_CodArchivoFirmado, B.TU_CodArchivo)
							END											AS  CodigoArchivoFirmado,			
							B.TC_Descripcion							AS Descripcion,
							A.TU_CodArchivoFirmado						AS CodigoFS,						 
							--Asignado por
							--'Split' 									AS Split,
							A.[TU_AsignadoPor]							AS CodigoAsignadoPor,				
							H.UsuarioRed,
							H.Nombre,
							H.PrimerApellido,
							H.SegundoApellido,		
							G.TC_CodPuestoTrabajo						AS CodPuestoTrabajoAsignadoPor,
							I.TC_Descripcion							AS DescripcionPuestoAsignadoPor,
							TP.TN_CodTipoPuestoTrabajo					AS CodTipoPuestoTrabajoAsignadoPor,
							TP.TC_Descripcion							AS DescripTipoPuestoTrabajoAsignadoPor,

							--Devuelto por
							--'Split' 									AS Split,
							A.TU_DevueltoPor							AS CodigoDevueltoPor,
							K.UsuarioRed,
							K.Nombre,
							K.PrimerApellido,
							K.SegundoApellido,
							J.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoPor,
							L.TC_Descripcion							AS DescripcionPuestoDevueltoPor,			
							--Corregido por
							--'Split' 									AS Split,
							A.TU_CorregidoPor							AS CodigoCorregidoPor,
							N.UsuarioRed,
							N.Nombre,
							N.PrimerApellido,
							N.SegundoApellido,	
							O.TC_CodPuestoTrabajo						AS CodPuestoTrabajoCorregidoPor,
							O.TC_Descripcion							AS DescripcionPuestoCorregidoPor,			
							--'Split' 									AS Split,
							--Expediente
							R.TC_Descripcion							AS DescripcionExpediente,
							AE.TC_NumeroExpediente						AS NumeroExpediente,	
							NULL,
							--Legajo
							LA.TU_CodLegajo								AS CodigoLegajo,
							NULL,
							--Clase Asunto
							CA.TN_CodClase								AS CodigoClase,
							CA.TC_Descripcion							AS DescripcionClase,
							C.TN_Orden,
							C.TF_FechaAplicado,
							S.UsuarioRed								AS UsuarioRedDevueltoA,
							S.Nombre									AS NombreDevueltoA,
							S.PrimerApellido							AS PrimerApellidoDevueltoA,		
							S.SegundoApellido							AS SegundoApellidoDevueltoA,	
							Q.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoA,
							Q.TC_Descripcion							AS DescripcionPuestoDevueltoA,
							A.TC_Estado									AS EstadoAsignacion,
							A.TF_FechaDevolucion						AS FechaDevolucion,
							--ArchivoDato
							B.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico,
							FJ.TB_PaseFallo								AS FallaExpLeg,
							FC.TC_CodFormatoJuridico                    AS EmiteComunicacionAutomatica

				FROM		[Archivo].[AsignacionFirmado]				AS A
				CROSS APPLY (	Select	Top(1) * 
								From	Archivo.AsignacionFirmado
								Where	TU_CodArchivoAsignado		= A.TU_CodArchivoAsignado
								And		TC_Estado					= @L_CodEstado) X
				INNER JOIN	[Archivo].Archivo							B WITH(NOLOCK)
				ON			A.TU_CodArchivo								= B.TU_CodArchivo
				INNER JOIN	Expediente.ArchivoExpediente				AS AE WITH(NOLOCK)
				ON			AE.TU_CodArchivo							= B.TU_CodArchivo
				LEFT JOIN	Expediente.LegajoArchivo					AS LA WITH(NOLOCK)
				ON			LA.TU_CodArchivo							= AE.TU_CodArchivo
				INNER JOIN	Archivo.AsignacionFirmante					C WITH(NOLOCK)
				ON			A.TU_CodAsignacionFirmado					= C.TU_CodAsignacionFirmado 
				AND			C.TC_CodPuestoTrabajo						= @L_CodPuestoTrabajo
				INNER JOIN	Catalogo.GrupoTrabajo						D WITH(NOLOCK) 
				ON			AE.TN_CodGrupoTrabajo						= D.TN_CodGrupoTrabajo
				INNER JOIN	Expediente.Expediente						AS R WITH(NOLOCK)
				ON			R.TC_NumeroExpediente						= AE.TC_NumeroExpediente
				LEFT JOIN	Expediente.ExpedienteDetalle				AS E WITH(NOLOCK)
				ON			E.TC_NumeroExpediente						= R.TC_NumeroExpediente AND E.TC_CodContexto = @L_CodContexto
				LEFT JOIN	Catalogo.Clase								AS CA WITH(NOLOCK)
				ON			CA.TN_CodClase								= E.TN_CodClase
				LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto	FC WITH(NOLOCK)   
				ON			B.TC_CodFormatoJuridico						= FC.TC_CodFormatoJuridico  
				AND			B.TC_CodContextoCrea						= FC.TC_CodContexto 
				AND			FC.TF_Inicio_Vigencia						<= GETDATE()																		
				--Asignador por
				INNER JOIN  Catalogo.PuestoTrabajoFuncionario			G WITH(NOLOCK) 
				ON			A.TU_AsignadoPor							= G.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
				LEFT JOIN	Catalogo.PuestoTrabajo						I WITH(NOLOCK) 
				ON			G.TC_CodPuestoTrabajo						= I.TC_CodPuestoTrabajo
				LEFT JOIN	Catalogo.TipoPuestoTrabajo					TP WITH(NOLOCK)
				ON			I.TN_CodTipoPuestoTrabajo					= TP.TN_CodTipoPuestoTrabajo
				--Devuelto por
				LEFT JOIN	Catalogo.PuestoTrabajoFuncionario			J WITH(NOLOCK) 
				ON			A.TU_DevueltoPor							= J.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
				LEFT JOIN	Catalogo.PuestoTrabajo						L WITH(NOLOCK) 
				ON			J.TC_CodPuestoTrabajo						= L.TC_CodPuestoTrabajo
				--Corregido por
				LEFT JOIN	Catalogo.PuestoTrabajoFuncionario			M WITH(NOLOCK) 
				ON			A.[TU_CorregidoPor]							= M.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
				LEFT JOIN	Catalogo.PuestoTrabajo						O WITH(NOLOCK) 
				ON			M.TC_CodPuestoTrabajo						= O.TC_CodPuestoTrabajo
				--Devuelto a
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) S
				LEFT JOIN	Catalogo.PuestoTrabajo						Q WITH(NOLOCK) 
				ON			A.TU_DevueltoA								= Q.TC_CodPuestoTrabajo
				LEFT JOIN   Catalogo.FormatoJuridico					FJ WITH(NOLOCK)
				ON			B.TC_CodFormatoJuridico						= FJ.TC_CodFormatoJuridico

				WHERE		A.TU_CodAsignacionFirmado					= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) AND			
							A.TC_Estado									= ISNULL('P', A.TC_Estado) AND
							B.TU_CodArchivo								= ISNULL(@L_CodLegajoArchivo, B.TU_CodArchivo) AND
							B.TC_CodContextoCrea						= COALESCE(@L_CodContexto, B.TC_CodContextoCrea)
				OPTION(RECOMPILE)
			END							
	END

	-- DataSet 0: Asignaciones de firma
	SELECT	Codigo,							
			FechaAsignacion,
			Urgente,
			Observacion,
			'Split'							AS Split,	--Archivo asignado
			CodigoArchivo,					
			Descripcion,
			FechaCrea,
			CodigoGrupoTrabajo,
			DescripcionGrupoTrabajo,
			'Split'							AS Split,	--Archivo firmado
			CodigoArchivoFirmado,
			DescripcionArchivoFirmado,		
			CodigoFS,
			'Split'							AS Split,	--Asignador por
			CodigoAsignadoPor,
			UsuarioRed,
			Nombre,
			PrimerApellido,
			SegundoApellido,
			CodPuestoTrabajoAsignadoPor,
			DescripcionPuestoAsignadoPor,
			CodTipoPuestoTrabajoAsignadoPor,
			DescripTipoPuestoTrabajoAsignadoPor,
			'Split'							AS Split,	--Devuelto por
			CodigoDevueltoPor,					
			UsuarioRedDevueltoPor,					
			NombreDevueltoPor,
			PrimerApellidoDevueltoPor,
			SegundoApellidoDevueltoPor,			
			CodPuestoTrabajoDevueltoPor,			
			DescripcionPuestoDevueltoPor,
			'Split'							AS Split,	--Corregido por
			CodigoCorregidoPor,					
			UsuarioCorregidoPor,					
			NombreCorregidoPor,					
			PrimerApellidoCorregidoPor,			
			SegundoApellidoCorregidoPor,			
			CodPuestoTrabajoCorregidoPor,		
			DescripcionPuestoCorregidoPor,	
			'Split'							AS Split,	--Expediente
			DescripcionExpediente,				
			NumeroExpediente,					
			CodigoContexto,	
			CodigoLegajo,								--Legajo	
			CodigoContextolegajo,				
			CodigoClase,								--Clase Asunto
			DescripcionClase,							
			Orden,
			FechaAplicado,								--Devuelto a
			UsuarioRedDevueltoA,					
			NombreDevueltoA,						
			PrimerApellidoDevueltoA,				
			SegundoApellidoDevueltoA,			
			CodPuestoTrabajoDevueltoA,			
			DescripcionPuestoDevueltoA,			
			EstadoAsignacion,							-- Estado y fecha devolución
			FechaDevolucion,	
			GenerarVotoAutomatico,						--ArchivoDato
			FallaExpLeg,							
			EmiteComunicacionAutomatica
	FROM
	@Resultado


	-- DataSet 1: Firmantes de cada asignación de firma
	SELECT 
		A.TN_Orden							AS Orden,
		A.TF_FechaAplicado					AS FechaAplicado,
		A.TF_FechaRevisado					AS FechaRevisado,
		A.TB_Nota							AS IndicaSiEsNotas,
		A.TB_Salva							AS IndicaSiEsVoto,
		A.TC_JustificacionSalvaVotoNota		AS ObservacionNotaVoto,
		A.TB_EsFirmaDigital					AS EsFirmaDigital,
		A.TB_BloqueaArchivo					AS BloqueaFirma,
		A.TC_CodBarras						AS CodigoBarras,
		--Asignación Firma
		'Split'								AS Split,		
		A.TU_CodAsignacionFirmado			AS Codigo,
		--Puesto de trabajo asignado
		'Split'								AS Split,		
		A.TC_CodPuestoTrabajo				AS Codigo,
		F.TC_Descripcion					AS Descripcion,		 
		 --Firmado por
		'Split'								AS Split,
		A.TU_FirmadoPor						AS CodigoFirmadoPor,			
		C.UsuarioRed						AS UsuarioRed,
		C.Nombre							AS Nombre,
		C.PrimerApellido					AS PrimerApellido,
		C.SegundoApellido					AS SegundoApellido
	FROM 		[Archivo].[AsignacionFirmante]	A		
	INNER JOIN 	[Archivo].[AsignacionFirmado] 	B WITH(NOLOCK) 
	ON			A.TU_CodAsignacionFirmado		= B.TU_CodAsignacionFirmado	
	--Firmado por
	CROSS APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
	LEFT JOIN  	Catalogo.PuestoTrabajo 		F WITH(NOLOCK) 
	ON			F.TC_CodPuestoTrabajo		= A.TC_CodPuestoTrabajo			
	WHERE		A.TU_CodAsignacionFirmado	IN (SELECT Codigo FROM @Resultado)
	ORDER BY 	TN_Orden
END
GO
