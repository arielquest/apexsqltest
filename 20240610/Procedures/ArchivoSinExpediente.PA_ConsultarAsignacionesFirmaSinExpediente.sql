SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Autor:     <Isaac Dobles Mata>  
-- Fecha Creacion: <29/10/2018>  
-- Descripcion:    <Consulta la lista de asignaciones de archivos sin expediente (Tabla Maestra) segun el puesto de trabajo>  
-- Modificación    <Xinia Soto V.> <06/08/2020> <Se modifica para que retorne si ya ha sido firmado>  
-- =================================================================================================================================================  
-- Modificación    <05/10/2020>	<Daniel Ruiz Hdz.>		<Se modifica para que retorne el archivo firmado.>  
-- Modificación				<Ronny Ramírez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE en el WHERE>
-- =================================================================================================================================================  
CREATE PROCEDURE [ArchivoSinExpediente].[PA_ConsultarAsignacionesFirmaSinExpediente]  
 @CodArchivo uniqueidentifier,  
 @CodEstado char(1),  
 @CodPuestoTrabajo VARCHAR(14)  
  
WITH RECOMPILE  
AS  
BEGIN   
   SELECT A.[TU_CodAsignacionFirmado]   AS	Codigo,  
   A.[TF_FechaAsigna]					AS	FechaAsignacion,  
   A.[TB_Urgente]						AS	Urgente,  
   A.[TC_Observacion]					AS	Observacion,  
   A.[TF_FechaDevolucion]				AS	FechaDevolucion,  
     
   'Split'								AS	Split,  
   A.TU_CodArchivoAsignado				AS	Codigo,  
   AR.TC_Descripcion					AS	Descripcion,  
   AR.TF_FechaCrea						AS	FechaCrea,  
            
   --Asignado por  
   'Split'								AS	Split,  
   A.[TU_AsignadoPor]					AS	CodigoAsignadoPor,      
   E.UsuarioRed,  
   E.Nombre,  
   E.PrimerApellido,  
   E.SegundoApellido,    
   F.TC_CodPuestoTrabajo				AS	CodPuestoTrabajoAsignadoPor,  
   F.TC_Descripcion						AS	DescripcionPuestoAsignadoPor,   
     
   --Devuelto por     
   'Split'								AS	Split,  
   A.[TU_DevueltoPor]					AS	CodigoDevueltoPor,  
   H.UsuarioRed,  
   H.Nombre,  
   H.PrimerApellido,  
   H.SegundoApellido,  
   I.TC_CodPuestoTrabajo				AS	CodPuestoTrabajoDevueltoPor,  
   I.TC_Descripcion						AS	DescripcionPuestoDevueltoPor,   
     
   --Corregido por     
   'Split'								AS	Split,  
   A.[TU_CorregidoPor]					AS	CodigoCorregidoPor,  
   K.UsuarioRed,  
   K.Nombre,  
   K.PrimerApellido,  
   K.SegundoApellido,   
   L.TC_CodPuestoTrabajo				AS	CodPuestoTrabajoCorregidoPor,  
   L.TC_Descripcion						AS	DescripcionPuestoCorregidoPor,     
  
   --DevueltoA  
   --C.TF_FechaAplicado,  
  
   --DevueltoA  
   'Split'								AS	Split,  
   A.[TU_DevueltoA]						AS	CodigoDevueltoA,  
   M.UsuarioRed,         
   M.Nombre,          
   M.PrimerApellido,          
   M.SegundoApellido,        
   N.TC_CodPuestoTrabajo				AS	CodPuestoTrabajoDevueltoA,  
   N.TC_Descripcion						AS	DescripcionPuestoDevueltoA,  
  
   'Split'								AS	Split,  
   A.[TC_Estado]						AS	Estado,  
   ISNULL((SELECT 2 --si ya ha sido firmado  
         FROM Archivo.AsignacionFirmante O  
         INNER JOIN Archivo.AsignacionFirmado P  
         ON P.TU_CodAsignacionFirmado = O.TU_CodAsignacionFirmado  
         WHERE O.TU_CodAsignacionFirmado = A.TU_CodAsignacionFirmado   
           AND O.TF_FechaAplicado IS NOT NULL ), 1) AS TN_Orden,
	A.TU_CodArchivoFirmado				AS	CodArchivoFirmado
  
   FROM [Archivo].[AsignacionFirmado]     AS A    
   INNER JOIN [ArchivoSinExpediente].ArchivoSinExpediente AS B WITH(NOLOCK)  
   ON A.TU_CodArchivo          = B.TU_CodArchivo  
  
   INNER JOIN [Archivo].[Archivo]       AS AR  
   ON  A.TU_CodArchivo          = AR.TU_CodArchivo  
  
   INNER JOIN Archivo.AsignacionFirmante     C WITH(NOLOCK)  
   ON A.TU_CodAsignacionFirmado       = C.TU_CodAsignacionFirmado   
  
   --Asignador por  
   INNER JOIN  Catalogo.PuestoTrabajoFuncionario   D WITH(NOLOCK)   
   ON A.TU_AsignadoPor         = D.TU_CodPuestoFuncionario  
   OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(D.TC_CodPuestoTrabajo) E  
   LEFT JOIN  Catalogo.PuestoTrabajo      F WITH(NOLOCK)   
   ON D.TC_CodPuestoTrabajo        = F.TC_CodPuestoTrabajo  
     
   --Devuelto por  
   LEFT JOIN  Catalogo.PuestoTrabajoFuncionario   G WITH(NOLOCK)   
   ON A.TU_DevueltoPor         = G.TU_CodPuestoFuncionario  
   OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(G.TC_CodPuestoTrabajo) H  
   LEFT JOIN  Catalogo.PuestoTrabajo      I WITH(NOLOCK)   
   ON I.TC_CodPuestoTrabajo        = G.TC_CodPuestoTrabajo  
     
   --Corregido por  
   LEFT JOIN  Catalogo.PuestoTrabajoFuncionario   J WITH(NOLOCK)   
   ON A.[TU_CorregidoPor]         = J.TU_CodPuestoFuncionario  
   OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(J.TC_CodPuestoTrabajo) K  
   LEFT JOIN  Catalogo.PuestoTrabajo      L WITH(NOLOCK)   
   ON J.TC_CodPuestoTrabajo        = L.TC_CodPuestoTrabajo  
     
   --Devuelto a  
   OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TU_DevueltoA) M  
   LEFT JOIN  Catalogo.PuestoTrabajo      N WITH(NOLOCK)   
   ON A.TU_DevueltoA          = N.TC_CodPuestoTrabajo  
  
   WHERE   
   A.TU_CodArchivoAsignado			= COALESCE(@CodArchivo, A.TU_CodArchivoAsignado)  
   AND A.TC_Estado					= COALESCE(@CodEstado, A.TC_Estado)  
   AND C.TC_CodPuestoTrabajo		= COALESCE(@CodPuestoTrabajo, C.TC_CodPuestoTrabajo)  
   ORDER BY A.TF_FechaAsigna		DESC  
   OPTION(RECOMPILE);
END  
GO
