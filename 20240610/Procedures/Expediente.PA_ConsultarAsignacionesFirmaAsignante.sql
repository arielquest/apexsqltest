SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creaci�n: <13/10/2017>
-- Descripcion:	   <Consulta la lista de asignaciones realizadas por un asignante>
-- Devuelve lista de asignaciones realizadas por un asignante.

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAsignacionesFirmaAsignante]
	@Codigo uniqueidentifier,
	@CodEstado VARCHAR(2),	
	@CodPuestoTrabajo VARCHAR(14),
	@CodLegajo uniqueidentifier,
	@CodLegajoArchivo uniqueidentifier
	
WITH RECOMPILE
AS
BEGIN
	SELECT A.[TU_CodAsignacionFirmado] AS Codigo,
			A.[TF_FechaAsigna]		AS FechaAsignacion,
			A.[TB_Urgente]			AS Urgente,
			A.[TC_Observacion]		AS Observacion,
			'Split' AS Split,
			B.TU_CodArchivo			AS  Codigo,
			B.TC_Descripcion		AS Descripcion,
			B.TF_FechaCrea			AS FechaCrea, 
			B.TU_IDArchivoFS		AS CodigoFS,
			C.TN_CodGrupoTrabajo	AS CodigoGrupoTrabajo,
			C.TC_Descripcion		AS DescripcionGrupoTrabajo,
			'Split' AS Split,
			A.TU_CodArchivo			As CodigoArchivoFirmado,
			B.TC_Descripcion		AS Descripcion,	
			A.TU_CodArchivoFirmado	AS CodigoFS,					 
			--Asignador por
			'Split' AS Split,
			A.[TU_AsignadoPor]		AS CodigoAsignadoPor,				
			H.UsuarioRed,
			H.Nombre,
			H.PrimerApellido,
			H.SegundoApellido,		
			I.TC_CodPuestoTrabajo	AS CodPuestoTrabajoAsignadoPor,
			I.TC_Descripcion		AS DescripcionPuestoAsignadoPor,	
			--Devuelto por
			'Split' AS Split,
			A.[TU_DevueltoPor]		As CodigoDevueltoPor,
			K.UsuarioRed,
			K.Nombre,
			K.PrimerApellido,
			K.SegundoApellido,
			L.TC_CodPuestoTrabajo	AS CodPuestoTrabajoDevueltoPor,
			L.TC_Descripcion		AS DescripcionPuestoDevueltoPor,	
			--Corregido por
			'Split' AS Split,
			A.[TU_CorregidoPor]		As CodigoCorregidoPor,
			N.UsuarioRed,
			N.Nombre,
			N.PrimerApellido,
			N.SegundoApellido,	
			O.TC_CodPuestoTrabajo	AS CodPuestoTrabajoCorregidoPor,
			O.TC_Descripcion		AS DescripcionPuestoCorregidoPor,
			'Split' AS Split,
			--Expediente
			B.TU_CodLegajo			AS CodigoLegajo,
			E.TC_Descripcion		As DescripcionLegajo,
			D.TC_NumeroExpediente	AS NumeroExpediente,			
			--Clase Asunto
			F.TN_CodClaseAsunto		As CodigoAsunto,				 
			F.TC_Descripcion		As DescripcionAsunto,
			P.UsuarioRed			As UsuarioRedDevueltoA,
			P.Nombre				As NombreDevueltoA,
			P.PrimerApellido		As PrimerApellidoDevueltoA,		
			P.SegundoApellido		As SegundoApellidoDevueltoA,	
			Q.TC_CodPuestoTrabajo	AS CodPuestoTrabajoDevueltoA,
			Q.TC_Descripcion		AS DescripcionPuestoDevueltoA,
			A.TC_Estado				AS EstadoAsignacion,
			A.TF_FechaDevolucion	AS FechaDevolucion						 
		FROM [Expediente].[AsignacionFirmado] AS A		
			INNER JOIN [Expediente].LegajoArchivo AS B WITH(NOLOCK)
			ON A.TU_CodArchivo = B.TU_CodArchivo
			INNER JOIN Catalogo.GrupoTrabajo AS C WITH(NOLOCK) 
			ON B.TN_CodGrupoTrabajo = C.TN_CodGrupoTrabajo
			INNER JOIN Expediente .Legajo AS D WITH(NOLOCK)
			ON D.TU_CodLegajo = B.TU_CodLegajo
			INNER JOIN Expediente.ExpedienteDetalle AS E WITH(NOLOCK)
			ON E.TU_CodLegajo = D.TU_CodLegajo
			INNER JOIN Expediente.Expediente AS R WITH(NOLOCK)
			ON R.TC_NumeroExpediente = D.TC_NumeroExpediente
			INNER JOIN Catalogo.ClaseAsunto As  F With(Nolock)
			ON F.TN_CodClaseAsunto=R.TN_CodClaseAsunto 					 
			--Asignador por
			INNER JOIN  Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK) 
			ON	A.TU_AsignadoPor = G.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H
			LEFT JOIN  Catalogo.PuestoTrabajo I WITH(NOLOCK) 
			ON	G.TC_CodPuestoTrabajo = I.TC_CodPuestoTrabajo AND I.TC_CodPuestoTrabajo = @CodPuestoTrabajo
			--Devuelto por
			LEFT JOIN  Catalogo.PuestoTrabajoFuncionario J WITH(NOLOCK) 
			ON	A.TU_DevueltoPor = J.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K
			LEFT JOIN  Catalogo.PuestoTrabajo L WITH(NOLOCK) 
			ON	J.TC_CodPuestoTrabajo = L.TC_CodPuestoTrabajo
			--Corregido por
			LEFT JOIN  Catalogo.PuestoTrabajoFuncionario M WITH(NOLOCK) 
			ON	A.[TU_CorregidoPor] = M.TU_CodPuestoFuncionario
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(M.TC_CodPuestoTrabajo) N
			LEFT JOIN  Catalogo.PuestoTrabajo O WITH(NOLOCK) 
			ON	M.TC_CodPuestoTrabajo = O.TC_CodPuestoTrabajo
			--Devuelto a
			OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) P
			LEFT JOIN  Catalogo.PuestoTrabajo Q WITH(NOLOCK) 
			ON	A.TU_DevueltoA = Q.TC_CodPuestoTrabajo
		WHERE 
			A.TU_CodAsignacionFirmado = ISNULL(@Codigo, A.TU_CodAsignacionFirmado) AND	
			B.TU_CodLegajo = ISNULL(@CodLegajo, B.TU_CodLegajo) AND	
			B.TU_CodArchivo = ISNULL(@CodLegajoArchivo, B.TU_CodArchivo) AND
			A.TC_Estado = ISNULL(@CodEstado, A.TC_Estado)			
END

GO
