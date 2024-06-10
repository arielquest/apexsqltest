SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===================================================================================================================================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <13/10/2017>
-- Descripcion:	   <Consulta la lista de asignaciones (Tabla Maestra) segun el puesto de trabajo>
-- Devuelve lista de asignaciones segun el puesto de trabajo.
-- ===================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <20/09/2018> <Se cambia el nombre del sp y si actualizan los esquema de las tablas >
-- Modificación		<Ronny Ram¡rez Rojas> <24/10/2019> <Se actualizan campos de Expediente y ExpedienteDetalle que ya no existen y se elimina legajo>
-- Modificación		<Ronny Ram¡rez Rojas> <28/11/2019> <Se realizan ajustes al script, para que coincida con las correcciones realizadas en el AD>
-- Modificación		<Daniel Ruiz Hernandez> <02/10/2020> <Se realizan ajustes al script, para que obtenga el codigo de archivo firmado>
-- Modificación		<Jose Gabriel Cordero Soto> <02/10/2020> <Se realizan ajustes al script, para que obtenga el codigo de archivo firmado>
-- Modificación		<Jose Gabriel Cordero Soto> <22/03/2021> <Se agrega campo indicador de generear voto automatico en consulta>
-- Modificación		<Aida Elena Siles R> <22/06/2021> <Se agrega lógica para consultar las devoluciones para un legajo>
-- Modificacion:    <Aida Elena Siles R> <18/10/2021> <Se modifica la consulta unicamente para Legajo. Se cambia a Left Join sobre las tablas Expediente.ExpedienteDetalle y Catalogo.Clase
--					Lo anterior, porque se implementa en el SIAGPJ la opción de crear legajos sin tener un expediente creado.>
-- Modificacion:    <Elías González Porras> <10/03/2023> <PBI 293660 - Se agrega la consulta el campo EmiteComunicacionAutomatica, 
--					con el fin del validar si el documento para corregir genera notificación automatica>
-- Modificacion:    <Elías González Porras> <10/03/2023> <Se optimiza la consulta del SP eliminando la sentencia WITH RECOMPILE y se agrega un cambio 
--														 para realizar la consulta del numero de expediente>
-- Modificación		<Ronny Ramírez R.> <14/07/2023>  <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- ===================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteDevolucionesparaCorregir]
	@Codigo				UNIQUEIDENTIFIER,
	@CodEstado			VARCHAR(2),	
	@CodPuestoTrabajo	VARCHAR(14),
	@NumeroExpediente	CHAR(14)			= NULL,
	@CodArchivo			UNIQUEIDENTIFIER,
	@EstadoDevolver		VARCHAR(2),
	@CodLegajo			UNIQUEIDENTIFIER	= NULL
	
AS
BEGIN
DECLARE
--VARIABLES LOCALES
	@L_Codigo				UNIQUEIDENTIFIER	= @Codigo,
	@L_CodEstado			VARCHAR(2)			= @CodEstado,	
	@L_CodPuestoTrabajo		VARCHAR(14)			= @CodPuestoTrabajo,
	@L_NumeroExpediente		CHAR(14)			= @NumeroExpediente,
	@L_CodArchivo			UNIQUEIDENTIFIER	= @CodArchivo,
	@L_EstadoDevolver		VARCHAR(2)			= @EstadoDevolver,
	@L_CodLegajo			UNIQUEIDENTIFIER	= @CodLegajo


	IF @L_CodPuestoTrabajo IS NULL OR @L_CodPuestoTrabajo =''
	BEGIN
		IF (@L_CodLegajo IS NULL)
		BEGIN
			SELECT  A.[TU_CodAsignacionFirmado]					AS Codigo,
					A.[TF_FechaAsigna]							AS FechaAsignacion,
					A.[TB_Urgente]								AS Urgente,
					A.[TC_Observacion]							AS Observacion,
					'Split' AS Split,
					B.TU_CodArchivo								AS  Codigo,
					B.TC_Descripcion							AS Descripcion,
					B.TF_FechaCrea								AS FechaCrea,
					C.TN_CodGrupoTrabajo						AS CodigoGrupoTrabajo,
					C.TC_Descripcion							AS DescripcionGrupoTrabajo,
					'Split' AS Split,
					A.TU_CodArchivoFirmado						As CodigoArchivoFirmado,
					B.TC_Descripcion							AS Descripcion,	
					A.TU_CodArchivoFirmado						AS CodigoFS,					 
					--Asignador por
					'Split' AS Split,
					A.[TU_AsignadoPor]							AS CodigoAsignadoPor,				
					H.UsuarioRed,
					H.Nombre,
					H.PrimerApellido,
					H.SegundoApellido,							
					I.TC_CodPuestoTrabajo						AS CodPuestoTrabajoAsignadoPor,
					I.TC_Descripcion							AS DescripcionPuestoAsignadoPor,	
					--Devuelto por
					'Split' AS Split,
					A.[TU_DevueltoPor]							As CodigoDevueltoPor,
					K.UsuarioRed,
					K.Nombre,
					K.PrimerApellido,
					K.SegundoApellido,
					L.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoPor,
					L.TC_Descripcion							AS DescripcionPuestoDevueltoPor,	
					--Corregido por
					'Split' AS Split,
					A.[TU_CorregidoPor]							As CodigoCorregidoPor,
					N.UsuarioRed,
					N.Nombre,
					N.PrimerApellido,
					N.SegundoApellido,	
					O.TC_CodPuestoTrabajo						AS CodPuestoTrabajoCorregidoPor,
					O.TC_Descripcion							AS DescripcionPuestoCorregidoPor,
					'Split' AS Split,
					--Expediente
					X.TC_Descripcion							As DescripcionExpediente,
					E.TC_NumeroExpediente						AS NumeroExpediente,
					--Clase
					F.TN_CodClase								AS CodigoClase,				 
					F.TC_Descripcion							AS DescripcionClase,
					--Otros datos
					P.UsuarioRed								As UsuarioRedDevueltoA,
					P.Nombre									As NombreDevueltoA,
					P.PrimerApellido							As PrimerApellidoDevueltoA,		
					P.SegundoApellido							As SegundoApellidoDevueltoA,	
					Q.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoA,
					Q.TC_Descripcion							AS DescripcionPuestoDevueltoA,
					A.TC_Estado									AS EstadoAsignacion,
					A.TF_FechaDevolucion						AS FechaDevolucion,
					B.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico,
					FC.TC_CodFormatoJuridico					AS EmiteComunicacionAutomatica

			FROM		[Archivo].[AsignacionFirmado]					AS A		
			INNER JOIN	[Archivo].Archivo								AS B WITH(NOLOCK)
			ON			A.TU_CodArchivo									= B.TU_CodArchivo
			
			INNER JOIN	Expediente.ArchivoExpediente					AS AE WITH(NOLOCK)
			ON			AE.TU_CodArchivo								= B.TU_CodArchivo						
			
			INNER JOIN	Catalogo.GrupoTrabajo							AS C WITH(NOLOCK)
			ON			AE.TN_CodGrupoTrabajo							= C.TN_CodGrupoTrabajo
			
			INNER JOIN	Expediente.Expediente							AS X WITH(NOLOCK)
			ON			X.TC_NumeroExpediente							= AE.TC_NumeroExpediente
				
			INNER JOIN	Expediente.ExpedienteDetalle					AS E WITH(NOLOCK)
			ON			E.TC_NumeroExpediente							= AE.TC_NumeroExpediente
				
			INNER JOIN	Catalogo.Clase									AS  F WITH(NOLOCK)
			ON			F.TN_CodClase									= E.TN_CodClase
			
			OUTER APPLY (
							SELECT	Z.TU_CodLegajo
							FROM	Expediente.LegajoArchivo			Z WITH(NOLOCK)
							WHERE	Z.TC_NumeroExpediente				= X.TC_NumeroExpediente
							AND		Z.TU_CodArchivo						= AE.TU_CodArchivo
						) LA
			
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario				G WITH(NOLOCK) 
			ON			A.TU_AsignadoPor								= G.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			LEFT JOIN	Catalogo.PuestoTrabajo							I WITH(NOLOCK) 
			ON			G.TC_CodPuestoTrabajo							= I.TC_CodPuestoTrabajo
			--Devuelto por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				J WITH(NOLOCK) 
			ON			A.TU_DevueltoPor								= J.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			LEFT JOIN	Catalogo.PuestoTrabajo							L WITH(NOLOCK) 
			ON			J.TC_CodPuestoTrabajo							= L.TC_CodPuestoTrabajo
			--Corregido por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				M WITH(NOLOCK) 
			ON			A.[TU_CorregidoPor]								= M.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			LEFT JOIN	Catalogo.PuestoTrabajo							O WITH(NOLOCK) 
			ON			M.TC_CodPuestoTrabajo							= O.TC_CodPuestoTrabajo
			--Devuelto a
			OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
			LEFT JOIN	Catalogo.PuestoTrabajo							Q WITH(NOLOCK) 
			ON			A.TU_DevueltoA									= Q.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
			ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
			AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
			AND			FC.TF_Inicio_Vigencia							<= GETDATE()	
			WHERE		A.TU_CodAsignacionFirmado						= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) 
			AND			E.TC_NumeroExpediente							= ISNULL(@L_NumeroExpediente, E.TC_NumeroExpediente)
			AND			AE.TC_NumeroExpediente							= ISNULL(@L_NumeroExpediente, AE.TC_NumeroExpediente)
			AND			A.TC_Estado										= ISNULL(@L_CodEstado, A.TC_Estado) 
			AND			B.TU_CodArchivo									= ISNULL(@L_CodArchivo, B.TU_CodArchivo)
			AND			LA.TU_CodLegajo									IS NULL
			OPTION(RECOMPILE);
		END
		ELSE
		BEGIN
			SELECT  A.[TU_CodAsignacionFirmado]					AS Codigo,
					A.[TF_FechaAsigna]							AS FechaAsignacion,
					A.[TB_Urgente]								AS Urgente,
					A.[TC_Observacion]							AS Observacion,
					'Split' AS Split,
					B.TU_CodArchivo								AS  Codigo,
					B.TC_Descripcion							AS Descripcion,
					B.TF_FechaCrea								AS FechaCrea,
					C.TN_CodGrupoTrabajo						AS CodigoGrupoTrabajo,
					C.TC_Descripcion							AS DescripcionGrupoTrabajo,
					'Split' AS Split,
					A.TU_CodArchivoFirmado						As CodigoArchivoFirmado,
					B.TC_Descripcion							AS Descripcion,	
					A.TU_CodArchivoFirmado						AS CodigoFS,					 
					--Asignador por
					'Split' AS Split,
					A.[TU_AsignadoPor]							AS CodigoAsignadoPor,				
					H.UsuarioRed,
					H.Nombre,
					H.PrimerApellido,
					H.SegundoApellido,							
					I.TC_CodPuestoTrabajo						AS CodPuestoTrabajoAsignadoPor,
					I.TC_Descripcion							AS DescripcionPuestoAsignadoPor,	
					--Devuelto por
					'Split' AS Split,
					A.[TU_DevueltoPor]							As CodigoDevueltoPor,
					K.UsuarioRed,
					K.Nombre,
					K.PrimerApellido,
					K.SegundoApellido,
					L.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoPor,
					L.TC_Descripcion							AS DescripcionPuestoDevueltoPor,	
					--Corregido por
					'Split' AS Split,
					A.[TU_CorregidoPor]							As CodigoCorregidoPor,
					N.UsuarioRed,
					N.Nombre,
					N.PrimerApellido,
					N.SegundoApellido,	
					O.TC_CodPuestoTrabajo						AS CodPuestoTrabajoCorregidoPor,
					O.TC_Descripcion							AS DescripcionPuestoCorregidoPor,
					'Split' AS Split,
					--Expediente
					X.TC_Descripcion							As DescripcionExpediente,
					E.TC_NumeroExpediente						AS NumeroExpediente,
					--Clase
					F.TN_CodClase								AS CodigoClase,				 
					F.TC_Descripcion							AS DescripcionClase,
					--Otros datos
					P.UsuarioRed								As UsuarioRedDevueltoA,
					P.Nombre									As NombreDevueltoA,
					P.PrimerApellido							As PrimerApellidoDevueltoA,		
					P.SegundoApellido							As SegundoApellidoDevueltoA,	
					Q.TC_CodPuestoTrabajo						AS CodPuestoTrabajoDevueltoA,
					Q.TC_Descripcion							AS DescripcionPuestoDevueltoA,
					A.TC_Estado									AS EstadoAsignacion,
					A.TF_FechaDevolucion						AS FechaDevolucion,
					B.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico,
					FC.TC_CodFormatoJuridico					AS EmiteComunicacionAutomatica

			FROM		[Archivo].[AsignacionFirmado]					AS A		
			INNER JOIN	[Archivo].Archivo								AS B WITH(NOLOCK)
			ON			A.TU_CodArchivo									= B.TU_CodArchivo
			
			INNER JOIN	Expediente.ArchivoExpediente					AS AE WITH(NOLOCK)
			ON			AE.TU_CodArchivo								= B.TU_CodArchivo
			
			INNER JOIN	Expediente.LegajoArchivo						AS LA WITH(NOLOCK)
			ON			LA.TU_CodArchivo								= AE.TU_CodArchivo
			AND			LA.TU_CodLegajo									= ISNULL(@L_CodLegajo, LA.TU_CodLegajo)			
			
			INNER JOIN	Catalogo.GrupoTrabajo							AS C WITH(NOLOCK)
			ON			AE.TN_CodGrupoTrabajo							= C.TN_CodGrupoTrabajo

			INNER JOIN	Expediente.Legajo								AS LEG WITH(NOLOCK)
			ON			LEG.TU_CodLegajo								= LA.TU_CodLegajo
			
			INNER JOIN	Expediente.Expediente							AS X WITH(NOLOCK)
			ON			X.TC_NumeroExpediente							= LEG.TC_NumeroExpediente
				
			LEFT JOIN	Expediente.ExpedienteDetalle					AS E WITH(NOLOCK)
			ON			E.TC_NumeroExpediente							= LEG.TC_NumeroExpediente
				
			LEFT JOIN	Catalogo.Clase									AS  F With(Nolock)
			ON			F.TN_CodClase									= E.TN_CodClase 				
			
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario				G WITH(NOLOCK) 
			ON			A.TU_AsignadoPor								= G.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			LEFT JOIN	Catalogo.PuestoTrabajo							I WITH(NOLOCK) 
			ON			G.TC_CodPuestoTrabajo							= I.TC_CodPuestoTrabajo
			--Devuelto por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				J WITH(NOLOCK) 
			ON			A.TU_DevueltoPor								= J.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			LEFT JOIN	Catalogo.PuestoTrabajo							L WITH(NOLOCK) 
			ON			J.TC_CodPuestoTrabajo							= L.TC_CodPuestoTrabajo
			--Corregido por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				M WITH(NOLOCK) 
			ON			A.[TU_CorregidoPor]								= M.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			LEFT JOIN	Catalogo.PuestoTrabajo							O WITH(NOLOCK) 
			ON			M.TC_CodPuestoTrabajo							= O.TC_CodPuestoTrabajo
			--Devuelto a
			OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
			LEFT JOIN	Catalogo.PuestoTrabajo							Q WITH(NOLOCK) 
			ON			A.TU_DevueltoA									= Q.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
			ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
			AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
			AND			FC.TF_Inicio_Vigencia							<= GETDATE()
			WHERE		A.TU_CodAsignacionFirmado						= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) 
			AND			LEG.TU_CodLegajo								= ISNULL(@L_CodLegajo, LA.TU_CodLegajo)
			AND			A.TC_Estado										= ISNULL(@L_CodEstado, A.TC_Estado) 
			AND			B.TU_CodArchivo									= ISNULL(@L_CodArchivo, B.TU_CodArchivo)
			OPTION(RECOMPILE);
		END
	END
	ELSE
	BEGIN
		IF(@L_CodLegajo IS NULL)
		BEGIN
			SELECT	A.[TU_CodAsignacionFirmado]			AS Codigo,
					A.[TF_FechaAsigna]					AS FechaAsignacion,
					A.[TB_Urgente]						AS Urgente,
					A.[TC_Observacion]					AS Observacion,		
					'Split' AS Split,
					B.TU_CodArchivo						AS  Codigo,
					B.TC_Descripcion					AS Descripcion,
					B.TF_FechaCrea						AS FechaCrea,
					D.TN_CodGrupoTrabajo				AS CodigoGrupoTrabajo,
					D.TC_Descripcion					AS DescripcionGrupoTrabajo,
					'Split' AS Split,
					A.TU_CodArchivoFirmado				AS  CodigoArchivoFirmado,			
					B.TC_Descripcion					AS Descripcion,
					A.TU_CodArchivoFirmado				AS CodigoFS,						 
					--Asignado por
					'Split' AS Split,
					A.[TU_AsignadoPor]					AS CodigoAsignadoPor,				
					H.UsuarioRed,
					H.Nombre,
					H.PrimerApellido,
					H.SegundoApellido,		
					G.TC_CodPuestoTrabajo				AS CodPuestoTrabajoAsignadoPor,
					I.TC_Descripcion					AS DescripcionPuestoAsignadoPor,			
					--Devuelto por
					'Split' AS Split,
					A.TU_DevueltoPor					As CodigoDevueltoPor,
					K.UsuarioRed,
					K.Nombre,
					K.PrimerApellido,
					K.SegundoApellido,
					J.TC_CodPuestoTrabajo				AS CodPuestoTrabajoDevueltoPor,
					L.TC_Descripcion					AS DescripcionPuestoDevueltoPor,			
					--Corregido por
					'Split' AS Split,
					A.TU_CorregidoPor					As CodigoCorregidoPor,
					N.UsuarioRed,
					N.Nombre,
					N.PrimerApellido,
					N.SegundoApellido,	
					O.TC_CodPuestoTrabajo				AS CodPuestoTrabajoCorregidoPor,
					O.TC_Descripcion					AS DescripcionPuestoCorregidoPor,			
					'Split' AS Split,
					--Expediente		
					X.TC_Descripcion					As DescripcionExpediente,
					E.TC_NumeroExpediente				AS NumeroExpediente,			
					--Clase
					F.TN_CodClase						As CodigoClase,				 
					F.TC_Descripcion					As DescripcionClase,
					--Otros datos
					S.UsuarioRed						As UsuarioRedDevueltoA,
					S.Nombre							As NombreDevueltoA,
					S.PrimerApellido					As PrimerApellidoDevueltoA,		
					S.SegundoApellido					As SegundoApellidoDevueltoA,	
					Q.TC_CodPuestoTrabajo				AS CodPuestoTrabajoDevueltoA,
					Q.TC_Descripcion					AS DescripcionPuestoDevueltoA,
					A.TC_Estado							AS EstadoAsignacion,
					A.TF_FechaDevolucion			    AS FechaDevolucion,
					B.TB_GenerarVotoAutomatico			AS GenerarVotoAutomatico,
					FC.TC_CodFormatoJuridico			AS EmiteComunicacionAutomatica

			FROM		[Archivo].[AsignacionFirmado]					A		
			INNER JOIN	[Archivo].Archivo								B WITH(NOLOCK)
			ON			A.TU_CodArchivo									= B.TU_CodArchivo
			INNER JOIN	Expediente.ArchivoExpediente					AS AE WITH(NOLOCK)
			ON			AE.TU_CodArchivo								= B.TU_CodArchivo
				
			INNER JOIN	Catalogo.GrupoTrabajo							D WITH(NOLOCK) 
			ON			AE.TN_CodGrupoTrabajo							= D.TN_CodGrupoTrabajo
				
			INNER JOIN	Expediente.Expediente							AS X WITH(NOLOCK)
			ON			X.TC_NumeroExpediente							= AE.TC_NumeroExpediente
				
			INNER JOIN	Expediente.ExpedienteDetalle					AS E WITH(NOLOCK)
			ON			E.TC_NumeroExpediente							= AE.TC_NumeroExpediente
				
			INNER JOIN	Catalogo.Clase									AS  F WITH(NOLOCK)
			ON			F.TN_CodClase									= E.TN_CodClase 
			
			OUTER APPLY (
							SELECT	Z.TU_CodLegajo
							FROM	Expediente.LegajoArchivo			Z WITH(NOLOCK)
							WHERE	Z.TC_NumeroExpediente				= X.TC_NumeroExpediente
							AND		Z.TU_CodArchivo						= AE.TU_CodArchivo
						) LA
			
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario				G WITH(NOLOCK) 
			ON			A.TU_AsignadoPor								= G.TU_CodPuestoFuncionario

			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			
			LEFT JOIN	Catalogo.PuestoTrabajo							I WITH(NOLOCK) 
			ON			G.TC_CodPuestoTrabajo							= I.TC_CodPuestoTrabajo
			
			--Devuelto por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				J WITH(NOLOCK) 
			ON			A.TU_DevueltoPor								= J.TU_CodPuestoFuncionario
			
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			
			LEFT JOIN	Catalogo.PuestoTrabajo							L WITH(NOLOCK) 
			ON			J.TC_CodPuestoTrabajo							= L.TC_CodPuestoTrabajo
			
			--Corregido por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				M WITH(NOLOCK) 
			ON			A.[TU_CorregidoPor]								= M.TU_CodPuestoFuncionario
			
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			
			LEFT JOIN	Catalogo.PuestoTrabajo							O WITH(NOLOCK) 
			ON			M.TC_CodPuestoTrabajo							= O.TC_CodPuestoTrabajo
			
			--Devuelto a
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) S
			
			LEFT JOIN	Catalogo.PuestoTrabajo							Q WITH(NOLOCK) 
			ON			A.TU_DevueltoA									= Q.TC_CodPuestoTrabajo 
			AND			A.TU_DevueltoA									= @CodPuestoTrabajo
			LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
			ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
			AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
			AND			FC.TF_Inicio_Vigencia							<= GETDATE()
			WHERE		A.TU_CodAsignacionFirmado						= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) 
			AND			E.TC_NumeroExpediente							= ISNULL(@L_NumeroExpediente, E.TC_NumeroExpediente)
			AND			AE.TC_NumeroExpediente							= ISNULL(@L_NumeroExpediente, AE.TC_NumeroExpediente)
			AND			A.TC_Estado										= ISNULL(@L_EstadoDevolver, A.TC_Estado) 
			AND			B.TU_CodArchivo									= ISNULL(@L_CodArchivo, B.TU_CodArchivo)
			AND			LA.TU_CodLegajo									IS NULL
			ORDER BY	A.TU_CodAsignacionFirmado
			OPTION(RECOMPILE);
		END
		ELSE
		BEGIN
			SELECT	A.[TU_CodAsignacionFirmado]			AS Codigo,
					A.[TF_FechaAsigna]					AS FechaAsignacion,
					A.[TB_Urgente]						AS Urgente,
					A.[TC_Observacion]					AS Observacion,		
					'Split' AS Split,
					B.TU_CodArchivo						AS  Codigo,
					B.TC_Descripcion					AS Descripcion,
					B.TF_FechaCrea						AS FechaCrea,
					D.TN_CodGrupoTrabajo				AS CodigoGrupoTrabajo,
					D.TC_Descripcion					AS DescripcionGrupoTrabajo,
					'Split' AS Split,
					A.TU_CodArchivoFirmado				AS  CodigoArchivoFirmado,			
					B.TC_Descripcion					AS Descripcion,
					A.TU_CodArchivoFirmado				AS CodigoFS,						 
					--Asignado por
					'Split' AS Split,
					A.[TU_AsignadoPor]					AS CodigoAsignadoPor,				
					H.UsuarioRed,
					H.Nombre,
					H.PrimerApellido,
					H.SegundoApellido,		
					G.TC_CodPuestoTrabajo				AS CodPuestoTrabajoAsignadoPor,
					I.TC_Descripcion					AS DescripcionPuestoAsignadoPor,			
					--Devuelto por
					'Split' AS Split,
					A.TU_DevueltoPor					As CodigoDevueltoPor,
					K.UsuarioRed,
					K.Nombre,
					K.PrimerApellido,
					K.SegundoApellido,
					J.TC_CodPuestoTrabajo				AS CodPuestoTrabajoDevueltoPor,
					L.TC_Descripcion					AS DescripcionPuestoDevueltoPor,			
					--Corregido por
					'Split' AS Split,
					A.TU_CorregidoPor					As CodigoCorregidoPor,
					N.UsuarioRed,
					N.Nombre,
					N.PrimerApellido,
					N.SegundoApellido,	
					O.TC_CodPuestoTrabajo				AS CodPuestoTrabajoCorregidoPor,
					O.TC_Descripcion					AS DescripcionPuestoCorregidoPor,			
					'Split' AS Split,
					--Expediente		
					X.TC_Descripcion					As DescripcionExpediente,
					E.TC_NumeroExpediente				AS NumeroExpediente,			
					--Clase
					F.TN_CodClase						As CodigoClase,				 
					F.TC_Descripcion					As DescripcionClase,
					--Otros datos
					S.UsuarioRed						As UsuarioRedDevueltoA,
					S.Nombre							As NombreDevueltoA,
					S.PrimerApellido					As PrimerApellidoDevueltoA,		
					S.SegundoApellido					As SegundoApellidoDevueltoA,	
					Q.TC_CodPuestoTrabajo				AS CodPuestoTrabajoDevueltoA,
					Q.TC_Descripcion					AS DescripcionPuestoDevueltoA,
					A.TC_Estado							AS EstadoAsignacion,
					A.TF_FechaDevolucion			    AS FechaDevolucion,
					B.TB_GenerarVotoAutomatico			AS GenerarVotoAutomatico,
					FC.TC_CodFormatoJuridico			AS EmiteComunicacionAutomatica
			
			FROM		[Archivo].[AsignacionFirmado]					A		
			INNER JOIN	[Archivo].Archivo								B WITH(NOLOCK)
			ON			A.TU_CodArchivo									= B.TU_CodArchivo

			INNER JOIN	Expediente.ArchivoExpediente					AS AE WITH(NOLOCK)
			ON			AE.TU_CodArchivo								= B.TU_CodArchivo

			INNER JOIN	Expediente.LegajoArchivo						AS LA WITH(NOLOCK)
			ON			LA.TU_CodArchivo								= AE.TU_CodArchivo
			AND			LA.TU_CodLegajo									= ISNULL(@L_CodLegajo, LA.TU_CodLegajo)	
				
			INNER JOIN	Catalogo.GrupoTrabajo							D WITH(NOLOCK) 
			ON			AE.TN_CodGrupoTrabajo							= D.TN_CodGrupoTrabajo

			INNER JOIN	Expediente.Legajo								AS LEG WITH(NOLOCK)
			ON			LEG.TU_CodLegajo								= LA.TU_CodLegajo
				
			INNER JOIN	Expediente.Expediente							AS X WITH(NOLOCK)
			ON			X.TC_NumeroExpediente							= LA.TC_NumeroExpediente
				
			LEFT JOIN	Expediente.ExpedienteDetalle					AS E WITH(NOLOCK)
			ON			E.TC_NumeroExpediente							= LA.TC_NumeroExpediente
				
			LEFT JOIN	Catalogo.Clase									AS  F With(Nolock)
			ON			F.TN_CodClase									= E.TN_CodClase 					
			
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario				G WITH(NOLOCK) 
			ON			A.TU_AsignadoPor								= G.TU_CodPuestoFuncionario

			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			
			LEFT JOIN	Catalogo.PuestoTrabajo							I WITH(NOLOCK) 
			ON			G.TC_CodPuestoTrabajo							= I.TC_CodPuestoTrabajo
			
			--Devuelto por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				J WITH(NOLOCK) 
			ON			A.TU_DevueltoPor								= J.TU_CodPuestoFuncionario
			
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			
			LEFT JOIN	Catalogo.PuestoTrabajo							L WITH(NOLOCK) 
			ON			J.TC_CodPuestoTrabajo							= L.TC_CodPuestoTrabajo
			
			--Corregido por
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario				M WITH(NOLOCK) 
			ON			A.[TU_CorregidoPor]								= M.TU_CodPuestoFuncionario
			
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			
			LEFT JOIN	Catalogo.PuestoTrabajo							O WITH(NOLOCK) 
			ON			M.TC_CodPuestoTrabajo							= O.TC_CodPuestoTrabajo
			
			--Devuelto a
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) S
			
			LEFT JOIN	Catalogo.PuestoTrabajo							Q WITH(NOLOCK) 
			ON			A.TU_DevueltoA									= Q.TC_CodPuestoTrabajo 
			AND			A.TU_DevueltoA									= @L_CodPuestoTrabajo
			LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
			ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
			AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
			AND			FC.TF_Inicio_Vigencia							<= GETDATE()
			WHERE		A.TU_CodAsignacionFirmado						= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) 
			AND			LEG.TU_CodLegajo								= ISNULL(@L_CodLegajo, LA.TU_CodLegajo)
			AND			A.TC_Estado										= ISNULL(@L_EstadoDevolver, A.TC_Estado) 
			AND			B.TU_CodArchivo									= ISNULL(@L_CodArchivo, B.TU_CodArchivo)
			ORDER BY	A.TU_CodAsignacionFirmado
			OPTION(RECOMPILE);
		END				
	END
END
GO
