SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <08/01/2019>
-- Descripcion:	   <Consulta de archivos por expediente borrados lógicamente>
-- Devuelve lista de archivos por expediente que están borrados lógicamente
-- Modificación:	<01/06/2022> <Mario Camacho Flores> <Se modifica para poder filtrar solo los documentos del expediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivoExpedienteEliminado] 
	@NumeroExpediente				char(14)
AS
BEGIN
			SELECT		A.TU_CodArchivo					AS  Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaCrea					AS FechaCrea, 
						A.TN_CodEstado					AS Estado,
						'Split'							As	Split,
								
						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							As	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							As	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							As	Split,

						G.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,
						G.TC_Descripcion				AS DescripcionGrupoTrabajo,
						G.TF_Inicio_Vigencia			AS FechaActivacionGrupoTrabajo,
						G.TF_Fin_Vigencia				AS FechaDesactivacionGrupoTrabajo,
						COUNT(*) OVER()					AS	Total

			FROM		Archivo.Archivo				A WITH(NOLOCK)

			INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo
						
			INNER JOIN  [Expediente].[Expediente]		EX WITH(NOLOCK)
			ON			AE.TC_NumeroExpediente			= EX.TC_NumeroExpediente

			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			A.TC_CodContextoCrea			= D.TC_CodContexto
	
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			A.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
	
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed
	
			INNER JOIN	Catalogo.GrupoTrabajo			G WITH(NOLOCK)
			ON			AE.TN_CodGrupoTrabajo			= G.TN_CodGrupoTrabajo

			LEFT JOIN	Expediente.LegajoArchivo        LA with(nolock)
			on			A.TU_CodArchivo	                = LA.TU_CodArchivo	

			WHERE		EX.TC_NumeroExpediente			= @NumeroExpediente
			AND			AE.TB_Eliminado					= 1	
			AND         LA.TU_CodArchivo	            IS NULL
			ORDER BY	A.TF_FechaCrea					Asc
END
GO
