SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Autor:			<Aida Elena Siles Rojas>  
-- Fecha Creación:	<11/03/2021>  
-- Descripcion:		<Consulta documentos que se pueden asignar a firmar para un legajo>
-- ================================================================================================================================================= 
-- Modificado por:  <Jose Gabriel Cordero Soto><22/03/2021><Asignacion de campo del indicador de voto automatico generado>
-- Modificación: <Fabian Sequeira Gamboa> <13/05/2021><Se incorpora campo indicador para determinar si el vse emite comunicacion automatica>  
-- ================================================================================================================================================= 
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivoLegajoSinAsignarFirma]   
 @EstadoBorrador			TINYINT,  
 @EstadoBorradorPublico		TINYINT,  
 @CodLegajo					UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
DECLARE
--VARIABLES
@L_EstadoBorrador			TINYINT				=	@EstadoBorrador,
@L_EstadoBorradorPublico	TINYINT				=	@EstadoBorradorPublico,  
@L_CodLegajo				UNIQUEIDENTIFIER	=	@CodLegajo
--LÓGICA

SELECT			A.TU_CodArchivo					AS  Codigo,  
				A.TC_Descripcion				AS Descripcion,  
				A.TF_FechaCrea					AS FechaCrea,   
				A.TN_CodEstado					AS Estado,  
				'Split'							AS Split,  
				C.TC_CodContexto				AS Codigo,  
				C.TC_Descripcion				AS Descripcion,    
				'Split'							AS Split,  
				D.TN_CodFormatoArchivo			AS Codigo,  
				D.TC_Descripcion				AS Descripcion,  
				D.TF_Inicio_Vigencia			AS FechaActivacion,  
				D.TF_Fin_Vigencia				AS FechaDesactivacion,  
				'Split'							AS Split,  
				F.TC_UsuarioRed					AS UsuarioRed,  
				F.TC_Nombre						AS Nombre,  
				F.TC_PrimerApellido				AS PrimerApellido,  
				F.TC_SegundoApellido			AS SegundoApellido,  
				F.TC_CodPlaza					AS CodigoPlaza,  
				F.TF_Inicio_Vigencia			AS FechaActivacion,  
				F.TF_Fin_Vigencia				AS FechaDesactivacion,  
				'Split'							AS Split,  
				G.TN_CodGrupoTrabajo			AS Codigo,  
				G.TC_Descripcion				AS Descripcion,  
				G.TF_Inicio_Vigencia			AS FechaActivacion,  
				G.TF_Fin_Vigencia				AS FechaDesactivacion,
				'Split'							AS Split,
				L.TC_NumeroExpediente			AS NumeroExpediente,
				A.TB_GenerarVotoAutomatico		AS GenerarVotoAutomatico,
				H.TC_CodFormatoJuridico         AS EmiteComunicacionAutomatica
  
  FROM			Archivo.Archivo					A WITH(NOLOCK) 
  INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)  
  ON			A.TU_CodArchivo					= AE.TU_CodArchivo  
  INNER JOIN	Expediente.LegajoArchivo		LA WITH(NOLOCK)
  ON			AE.TU_CodArchivo				= LA.TU_CodArchivo     
  INNER JOIN	Expediente.Legajo				L WITH(NOLOCK)
  ON			LA.TU_CodLegajo					= L.TU_CodLegajo
  INNER JOIN	Catalogo.Contexto			    C WITH(NOLOCK)   
  ON			A.TC_CodContextoCrea			= C.TC_CodContexto
  INNER JOIN	Catalogo.FormatoArchivo			D WITH(NOLOCK)   
  ON			A.TN_CodFormatoArchivo			= D.TN_CodFormatoArchivo    
  INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)   
  ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed 
  INNER JOIN	Catalogo.GrupoTrabajo			G WITH(NOLOCK)   
  ON			AE.TN_CodGrupoTrabajo			= G.TN_CodGrupoTrabajo
  LEFT JOIN		Catalogo.FormatoJuriComunicacionContexto		H WITH(NOLOCK)   
  ON			A.TC_CodFormatoJuridico			= H.TC_CodFormatoJuridico  
  AND			A.TC_CodContextoCrea			= H.TC_CodContexto 
  AND			H.TF_Inicio_Vigencia			<= GETDATE()
   
  WHERE			(A.TN_CodEstado					= @L_EstadoBorrador 
  OR			A.TN_CodEstado					= @L_EstadoBorradorPublico)  
  AND			LA.TU_CodLegajo					= ISNULL(@L_CodLegajo, LA.TU_CodLegajo)  
  AND			NOT EXISTS						(	SELECT	TU_CodArchivo   
													FROM	Archivo.AsignacionFirmado WITH(NOLOCK)   
													WHERE	TU_CodArchivo = LA.TU_CodArchivo  )   
  ORDER BY	A.TF_FechaCrea ASC
END  
GO
