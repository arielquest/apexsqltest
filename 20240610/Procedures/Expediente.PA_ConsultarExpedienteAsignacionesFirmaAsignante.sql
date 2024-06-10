SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Juan Ramirez V.>
-- Fecha Creacion:		<13/10/2017>
-- Descripcion:			<Consulta la lista de asignaciones realizadas por un asignante>
-- Devuelve lista de asignaciones realizadas por un asignante.
-- =================================================================================================================================================
-- Modificación:		<20/09/2018> <Jonathan Aguilar Navarro> <Se cambia el nombre del sp y si actualizan los esquema de las tablas >
-- Modificación:		<01/11/2019> <Isaac Dobles> <Se ajusta a estructura de expedientes y legajos>
-- Modificación:		<29/09/2020> <Daniel Ruiz H.> <Se modifica el select para obtener el codigo del archivo firmado>
-- Modificación:		<11/03/2021> <Aida Elena Siles R> <Se agregan variable locales y se permite NULL en el parámetro CodArchivo>
-- Modificación:		<22/03/2021> <Jose Gabriel Cordero Soto> <Se retorna el indicador de voto generado automaticamente>
-- Modificación:		<02/06/2021> <Aida Elena Siles R> <Se agrega el parámetro Codlegajo para filtrar la consulta si viene el dato>
-- Modificación:		<23/06/2021> <Aida Elena Siles R> <Se filtra la consulta por expediente para que muestre unicamente los documentos del expediente>
-- Modificación:		<05/08/2021> <Fabian Sequeira Gamboa> <Se elimina la duplicidad de los documentos asigandos>
-- Modificación:		<18/10/2021> <Aida Elena Siles R> <Se modifica la consulta unicamente para Legajo. Se cambia a Left Join sobre las tablas Expediente.ExpedienteDetalle y Catalogo.Clase.
--						Lo anterior, porque se implementa en el SIAGPJ la opción de crear legajos sin tener un expediente creado.>
-- Modificación:		<23/06/2023> <Luis Alonso Leiva Tames> <PBI 388537 Se corrige para excluir los documentos que no tienen codigo asignado>
-- Modificación:		<13/07/2023> <Elías González Porras> <Se agrega la consulta el campo EmiteComunicacionAutomatica, 
--						con el fin del validar si el documento para corregir genera notificación automatica y se quita la sentencia WITH RECOMPILE>
-- Modificación:		<14/07/2023> <Gabriel Arnaez Hodgson> Se agrega columna de pase a fallo del formato jurídico.
-- Modificación			<14/07/2023> <Ronny Ramírez R.>   <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- Modificación:		<10/08/2023> <Gabriel Arnaez Hodgson> <Se agrega columna del codigo del legajo>
-- Modificación:		<04/09/2023> <Francisco Martínez Hernández> <Se agrega ordenamiento por campo FechaAsigna>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteAsignacionesFirmaAsignante]
	@Codigo				UNIQUEIDENTIFIER,
	@CodEstado			VARCHAR(2),	
	@CodPuestoTrabajo	VARCHAR(14),
	@NumeroExpediente	CHAR(14),
	@CodArchivo			UNIQUEIDENTIFIER = NULL,
	@CodLegajo			UNIQUEIDENTIFIER = NULL

AS
BEGIN
DECLARE
--VARIABLES LOCALES
	@L_Codigo				UNIQUEIDENTIFIER	=	@Codigo,
	@L_CodEstado			VARCHAR(2)			=	@CodEstado,	
	@L_CodPuestoTrabajo		VARCHAR(14)			=	@CodPuestoTrabajo,
	@L_NumeroExpediente		CHAR(14)			=	@NumeroExpediente,
	@L_CodArchivo			UNIQUEIDENTIFIER	=	@CodArchivo,
	@L_CodLegajo			UNIQUEIDENTIFIER	=	@CodLegajo

--LÓGICA

IF (@L_CodLegajo IS NULL)
	BEGIN
		SELECT A.[TU_CodAsignacionFirmado]				AS Codigo,
				A.[TF_FechaAsigna]						AS FechaAsignacion,
				A.[TB_Urgente]							AS Urgente,
				A.[TC_Observacion]						AS Observacion,
				'Split' AS Split,
				B.TU_CodArchivo							AS  Codigo,
				B.TC_Descripcion						AS Descripcion,
				B.TF_FechaCrea							AS FechaCrea, 
				C.TN_CodGrupoTrabajo					AS CodigoGrupoTrabajo,
				C.TC_Descripcion						AS DescripcionGrupoTrabajo,
				'Split' AS Split,
				A.TU_CodArchivoFirmado					As CodigoArchivoFirmado,
				B.TC_Descripcion						AS Descripcion,	
				A.TU_CodArchivoFirmado					AS CodigoFS,					 
				--Asignador por
				'Split' AS Split,
				A.[TU_AsignadoPor]						AS CodigoAsignadoPor,				
				H.UsuarioRed,
				H.Nombre,
				H.PrimerApellido,
				H.SegundoApellido,						
				I.TC_CodPuestoTrabajo					AS CodPuestoTrabajoAsignadoPor,
				I.TC_Descripcion						AS DescripcionPuestoAsignadoPor,	
				--Devuelto por
				'Split' AS Split,
				A.[TU_DevueltoPor]						As CodigoDevueltoPor,
				K.UsuarioRed,
				K.Nombre,
				K.PrimerApellido,
				K.SegundoApellido,
				L.TC_CodPuestoTrabajo					AS CodPuestoTrabajoDevueltoPor,
				L.TC_Descripcion						AS DescripcionPuestoDevueltoPor,	
				--Corregido por
				'Split' AS Split,
				A.[TU_CorregidoPor]						As CodigoCorregidoPor,
				N.UsuarioRed,
				N.Nombre,
				N.PrimerApellido,
				N.SegundoApellido,	
				O.TC_CodPuestoTrabajo					AS CodPuestoTrabajoCorregidoPor,
				O.TC_Descripcion						AS DescripcionPuestoCorregidoPor,
				'Split' AS Split,
				--Expediente
				D.TC_Descripcion						As DescripcionExpediente,
				E.TC_NumeroExpediente					AS NumeroExpediente,			
				--Clase Asunto
				F.TN_CodClase							As CodigoClase,				 
				F.TC_Descripcion						As DescripcionClase,
				P.UsuarioRed							As UsuarioRedDevueltoA,
				P.Nombre								As NombreDevueltoA,
				P.PrimerApellido						As PrimerApellidoDevueltoA,		
				P.SegundoApellido						As SegundoApellidoDevueltoA,	
				Q.TC_CodPuestoTrabajo					AS CodPuestoTrabajoDevueltoA,
				Q.TC_Descripcion						AS DescripcionPuestoDevueltoA,
				A.TC_Estado								AS EstadoAsignacion,
				A.TF_FechaDevolucion					AS FechaDevolucion,
				B.TB_GenerarVotoAutomatico				AS GenerarVotoAutomatico,
				FC.TC_CodFormatoJuridico				AS EmiteComunicacionAutomatica,
				--Formato Juridico
				FJ.TB_PaseFallo							AS FallaExpLeg
			
		FROM	[Archivo].[AsignacionFirmado]			AS A		
				INNER JOIN [Archivo].Archivo			AS B WITH(NOLOCK)
				ON A.TU_CodArchivo						= B.TU_CodArchivo
				INNER JOIN Expediente.ArchivoExpediente	AS AE WITH(NOLOCK)
				ON	AE.TU_CodArchivo					= B.TU_CodArchivo
				INNER JOIN Catalogo.GrupoTrabajo		AS C WITH(NOLOCK) 
				ON AE.TN_CodGrupoTrabajo				= C.TN_CodGrupoTrabajo
				INNER JOIN Expediente.Expediente		AS D WITH(NOLOCK)
				ON D.TC_NumeroExpediente				= AE.TC_NumeroExpediente
				INNER JOIN Expediente.ExpedienteDetalle	AS E WITH(NOLOCK)
				ON E.TC_NumeroExpediente				= AE.TC_NumeroExpediente
				AND E.TC_CodContexto					= D.TC_CodContexto
				INNER JOIN Catalogo.Clase				As  F With(Nolock)
				ON F.TN_CodClase						= E.TN_CodClase 
				OUTER APPLY 
				(
					SELECT	Z.TU_CodLegajo
					FROM	Expediente.LegajoArchivo	Z WITH(NOLOCK)
					WHERE	Z.TC_NumeroExpediente		= D.TC_NumeroExpediente
					AND		Z.TU_CodArchivo				= AE.TU_CodArchivo
				) LA
				--Asignador por
				INNER JOIN  Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK) 
				ON	A.TU_AsignadoPor					= G.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
				LEFT JOIN  Catalogo.PuestoTrabajo		I WITH(NOLOCK) 
				ON	G.TC_CodPuestoTrabajo				= I.TC_CodPuestoTrabajo AND I.TC_CodPuestoTrabajo = @CodPuestoTrabajo
				--Devuelto por
				LEFT JOIN  Catalogo.PuestoTrabajoFuncionario J WITH(NOLOCK) 
				ON	A.TU_DevueltoPor					= J.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
				LEFT JOIN  Catalogo.PuestoTrabajo		L WITH(NOLOCK) 
				ON	J.TC_CodPuestoTrabajo				= L.TC_CodPuestoTrabajo
				--Corregido por
				LEFT JOIN  Catalogo.PuestoTrabajoFuncionario M WITH(NOLOCK) 
				ON	A.[TU_CorregidoPor]					= M.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
				LEFT JOIN  Catalogo.PuestoTrabajo		O WITH(NOLOCK) 
				ON	M.TC_CodPuestoTrabajo				= O.TC_CodPuestoTrabajo
				--Devuelto a
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
				LEFT JOIN  Catalogo.PuestoTrabajo		Q WITH(NOLOCK) 
				ON	A.TU_DevueltoA						= Q.TC_CodPuestoTrabajo
				LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
				ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
				AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
				AND			FC.TF_Inicio_Vigencia							<= GETDATE()
				--Agrega formato juridico
				LEFT JOIN   Catalogo.FormatoJuridico		FJ WITH(NOLOCK)
				ON			B.TC_CodFormatoJuridico			= FJ.TC_CodFormatoJuridico

												  

		WHERE	A.TU_CodAsignacionFirmado				= COALESCE(@L_Codigo, A.TU_CodAsignacionFirmado) 
		AND		AE.TC_NumeroExpediente				    = COALESCE(@L_NumeroExpediente, AE.TC_NumeroExpediente) 
		AND		A.TU_CodArchivo							= COALESCE(@L_CodArchivo, A.TU_CodArchivo) 
		AND		A.TC_Estado								= COALESCE(@L_CodEstado, A.TC_Estado)
		AND		A.TU_CodArchivo							<> '00000000-0000-0000-0000-000000000000'															   
		AND		LA.TU_CodLegajo							IS NULL
		ORDER BY A.TF_FechaAsigna				   
		OPTION(RECOMPILE);
	END
ELSE
	BEGIN
		SELECT A.[TU_CodAsignacionFirmado]				AS Codigo,
				A.[TF_FechaAsigna]						AS FechaAsignacion,
				A.[TB_Urgente]							AS Urgente,
				A.[TC_Observacion]						AS Observacion,
				'Split' AS Split,
				B.TU_CodArchivo							AS Codigo,
				B.TC_Descripcion						AS Descripcion,
				B.TF_FechaCrea							AS FechaCrea, 
				C.TN_CodGrupoTrabajo					AS CodigoGrupoTrabajo,
				C.TC_Descripcion						AS DescripcionGrupoTrabajo,
				'Split' AS Split,
				A.TU_CodArchivoFirmado					As CodigoArchivoFirmado,
				B.TC_Descripcion						AS Descripcion,	
				A.TU_CodArchivoFirmado					AS CodigoFS,					 
				--Asignador por
				'Split' AS Split,
				A.[TU_AsignadoPor]						AS CodigoAsignadoPor,				
				H.UsuarioRed,
				H.Nombre,
				H.PrimerApellido,
				H.SegundoApellido,						
				I.TC_CodPuestoTrabajo					AS CodPuestoTrabajoAsignadoPor,
				I.TC_Descripcion						AS DescripcionPuestoAsignadoPor,	
				--Devuelto por
				'Split' AS Split,
				A.[TU_DevueltoPor]						As CodigoDevueltoPor,
				K.UsuarioRed,
				K.Nombre,
				K.PrimerApellido,
				K.SegundoApellido,
				L.TC_CodPuestoTrabajo					AS CodPuestoTrabajoDevueltoPor,
				L.TC_Descripcion						AS DescripcionPuestoDevueltoPor,	
				--Corregido por
				'Split' AS Split,
				A.[TU_CorregidoPor]						As CodigoCorregidoPor,
				N.UsuarioRed,
				N.Nombre,
				N.PrimerApellido,
				N.SegundoApellido,	
				O.TC_CodPuestoTrabajo					AS CodPuestoTrabajoCorregidoPor,
				O.TC_Descripcion						AS DescripcionPuestoCorregidoPor,
				'Split' AS Split,
				--Expediente
				D.TC_Descripcion						As DescripcionExpediente,
				E.TC_NumeroExpediente					AS NumeroExpediente,			
				--Clase Asunto
				F.TN_CodClase							As CodigoClase,				 
				F.TC_Descripcion						As DescripcionClase,
				P.UsuarioRed							As UsuarioRedDevueltoA,
				P.Nombre								As NombreDevueltoA,
				P.PrimerApellido						As PrimerApellidoDevueltoA,		
				P.SegundoApellido						As SegundoApellidoDevueltoA,	
				Q.TC_CodPuestoTrabajo					AS CodPuestoTrabajoDevueltoA,
				Q.TC_Descripcion						AS DescripcionPuestoDevueltoA,
				A.TC_Estado								AS EstadoAsignacion,
				A.TF_FechaDevolucion					AS FechaDevolucion,
				B.TB_GenerarVotoAutomatico				AS GenerarVotoAutomatico,
				FC.TC_CodFormatoJuridico				AS EmiteComunicacionAutomatica,
				FJ.TB_PaseFallo							AS FallaExpLeg,
				LA.TU_CodLegajo							AS CodLegajo
			
		FROM	[Archivo].[AsignacionFirmado]			AS A		
				INNER JOIN [Archivo].Archivo			AS B WITH(NOLOCK)
				ON	A.TU_CodArchivo						= B.TU_CodArchivo
				INNER JOIN Expediente.ArchivoExpediente	AS AE WITH(NOLOCK)
				ON	AE.TU_CodArchivo					= B.TU_CodArchivo
				INNER JOIN Expediente.LegajoArchivo     AS LA WITH(NOLOCK)
				ON  AE.TU_CodArchivo					= LA.TU_CodArchivo
				INNER JOIN Catalogo.GrupoTrabajo		AS C WITH(NOLOCK) 
				ON AE.TN_CodGrupoTrabajo				= C.TN_CodGrupoTrabajo
				INNER JOIN Expediente.Expediente		AS D WITH(NOLOCK)
				ON D.TC_NumeroExpediente				= AE.TC_NumeroExpediente
				LEFT JOIN Expediente.ExpedienteDetalle	AS E WITH(NOLOCK)
				ON E.TC_NumeroExpediente				= AE.TC_NumeroExpediente
				AND E.TC_CodContexto					= B.TC_CodContextoCrea
				LEFT JOIN Catalogo.Clase				AS F With(Nolock)
				ON F.TN_CodClase						= E.TN_CodClase 					 
				--Asignador por
				INNER JOIN  Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK) 
				ON	A.TU_AsignadoPor					= G.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
				LEFT JOIN  Catalogo.PuestoTrabajo		I WITH(NOLOCK) 
				ON	G.TC_CodPuestoTrabajo				= I.TC_CodPuestoTrabajo AND I.TC_CodPuestoTrabajo = @CodPuestoTrabajo
				--Devuelto por
				LEFT JOIN  Catalogo.PuestoTrabajoFuncionario J WITH(NOLOCK) 
				ON	A.TU_DevueltoPor					= J.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
				LEFT JOIN  Catalogo.PuestoTrabajo		L WITH(NOLOCK) 
				ON	J.TC_CodPuestoTrabajo				= L.TC_CodPuestoTrabajo
				--Corregido por
				LEFT JOIN  Catalogo.PuestoTrabajoFuncionario M WITH(NOLOCK) 
				ON	A.[TU_CorregidoPor]					= M.TU_CodPuestoFuncionario
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
				LEFT JOIN  Catalogo.PuestoTrabajo		O WITH(NOLOCK) 
				ON	M.TC_CodPuestoTrabajo				= O.TC_CodPuestoTrabajo
				--Devuelto a
				OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
				LEFT JOIN  Catalogo.PuestoTrabajo		Q WITH(NOLOCK) 
				ON	A.TU_DevueltoA						= Q.TC_CodPuestoTrabajo
				LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		FC WITH(NOLOCK)   
				ON			FC.TC_CodFormatoJuridico						= B.TC_CodFormatoJuridico  
				AND			FC.TC_CodContexto  								= B.TC_CodContextoCrea
				AND			FC.TF_Inicio_Vigencia							<= GETDATE()
				--Agrega formato juridico
				LEFT JOIN   Catalogo.FormatoJuridico		FJ WITH(NOLOCK)
				ON			B.TC_CodFormatoJuridico			= FJ.TC_CodFormatoJuridico

												  

		WHERE	A.TU_CodAsignacionFirmado				= COALESCE(@L_Codigo, A.TU_CodAsignacionFirmado) 
		AND		LA.TU_CodLegajo							= @L_CodLegajo 
		AND		A.TU_CodArchivo							= COALESCE(@L_CodArchivo, A.TU_CodArchivo) 
		AND		A.TC_Estado								= COALESCE(@L_CodEstado, A.TC_Estado)
		AND		A.TU_CodArchivo							<> '00000000-0000-0000-0000-000000000000'
		ORDER BY A.TF_FechaAsigna
		OPTION(RECOMPILE);
	END	
END
GO
