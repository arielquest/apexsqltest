SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Autor:			<Juan Ramirez V>  
-- Fecha Creaci¢n:	<07/09/2017>  
-- Descripcion:	     <Consulta documentos que se pueden asignar a firmar. Devuelve lista de archivos por expediente >  
-- =================================================================================================================================================  
-- Modificaci¢n: <Jonathan Aguilar Navarro> <14/05/2018> <Cambio de campos >  
-- Modificaci¢n: <Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>  
-- =================================================================================================================================================  
-- Modificaci¢n: <Isaac Dobles Mata> <21/09/2018> <Se cambia nombre del SP a PA_ConsultarArhivoExpedienteSinAsignarFirma y se ajusta para consultar a tabla ArchivoExpediente y Archivo>  
-- Modificaci¢n: <Jonathan Aguilar Navarro> <27/09/2018> <Se cambia el esquema de la tabla AsignacionFirma y se corrige nombre de Campo TN_CodEstado >  
-- Modificaci¢n: <Jonathan Aguilar Navarro> <07/01/2019><Se agrega el numero de expediente como parametro de consulta>  
-- Modificaci¢n: <Jonathan Aguilar Navarro> <29/07/2019><Se modifica para que excluya los archivos asignados a un legajo>  
-- Modificaci¢n: <Xinia Soto V> <14/07/2020><Se agrega ordenar por fecha de creaci¢n>  
-- Modificaci¢n: <Jose Gabriel Cordero Soto> <19/03/2020><Se incorpora campo indicador para determinar si el voto se genera de forma autom tica o no>  
-- Modificaci¢n: <Fabian Sequeira Gamboa> <19/08/2021><Se muestran los documentos que se desasignaron por completo >  
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivoExpedienteSinAsignarFirma]   
 @EstadoBorrador			TINYINT,  
 @EstadoBorradorPublico		TINYINT,  
 @NumeroExpediente			VARCHAR(14)  
AS  
BEGIN  
DECLARE
--VARIABLES
@L_EstadoBorrador			TINYINT			=	@EstadoBorrador,
@L_EstadoBorradorPublico	TINYINT			=	@EstadoBorradorPublico,  
@L_NumeroExpediente			VARCHAR(14)		=	@NumeroExpediente
--LàGICA

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
				A.TB_GenerarVotoAutomatico		AS GenerarVotoAutomatico,
				H.TC_CodFormatoJuridico         AS EmiteComunicacionAutomatica
  
  FROM			Archivo.Archivo					A WITH(NOLOCK)    
  INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)  
  ON			A.TU_CodArchivo					= AE.TU_CodArchivo    
  INNER JOIN   
  (  
	   SELECT	AE.TU_CodArchivo  
	   FROM		Expediente.ArchivoExpediente AE  
	   WHERE	AE.TC_NumeroExpediente			= @L_NumeroExpediente  
	   EXCEPT  
	   SELECT	LA.TU_CodArchivo  
	   FROM		Expediente.LegajoArchivo LA  
	   WHERE	LA.TC_NumeroExpediente			= @L_NumeroExpediente  
  ) AS X  
  ON			X.TU_CodArchivo								= A.TU_CodArchivo       
  INNER JOIN	Catalogo.Contexto						C WITH(NOLOCK)   
  ON			A.TC_CodContextoCrea			= C.TC_CodContexto      
  INNER JOIN	Catalogo.FormatoArchivo			D WITH(NOLOCK)   
  ON			A.TN_CodFormatoArchivo			= D.TN_CodFormatoArchivo    
  INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)   
  ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed    
  INNER JOIN	Catalogo.GrupoTrabajo			G WITH(NOLOCK)   
  ON			AE.TN_CodGrupoTrabajo			= G.TN_CodGrupoTrabajo  
  LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto		H WITH(NOLOCK)   
  ON			A.TC_CodFormatoJuridico			= H.TC_CodFormatoJuridico  
  AND			A.TC_CodContextoCrea			= H.TC_CodContexto 
  AND			H.TF_Inicio_Vigencia			<= GETDATE()
  
  WHERE			(A.TN_CodEstado					= @L_EstadoBorrador 
  OR			A.TN_CodEstado					= @L_EstadoBorradorPublico)  
  AND			AE.TC_NumeroExpediente			= ISNULL(@L_NumeroExpediente, AE.TC_NumeroExpediente)  
  AND			NOT EXISTS						(	SELECT	TU_CodArchivo   
													FROM	Archivo.AsignacionFirmado WITH(NOLOCK)   
													WHERE	TU_CodArchivo = A.TU_CodArchivo  AND TC_ESTADO <> 'C')   
  ORDER BY	A.TF_FechaCrea ASC
END  /****** Object:  StoredProcedure [Expediente].[PA_ConsultarBuzonItineracionesRecibir]    Script Date: 08/10/2021 10:56:54 ******/
SET ANSI_NULLS ON
GO
