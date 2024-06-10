SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<20/09/2021>
-- Descripción:				<Obtiene el grupo de trabajo de un documento> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ObtenerGrupoTrabajoArchivo]
(
	@CodigoArchivo         uniqueidentifier
)
AS
BEGIN

	DECLARE @L_CodigoArchivo uniqueidentifier = @CodigoArchivo

	SELECT 
	G.TN_CodGrupoTrabajo				Codigo,
	G.TC_Descripcion					Descripcion,
	G.TF_Inicio_Vigencia				FechaActivacion,
	G.TF_Fin_Vigencia					FechaDesactivacion
	FROM Expediente.ArchivoExpediente	AE WITH(NOLOCK)
	INNER JOIN Archivo.Archivo A
	ON AE.TU_CodArchivo					= A.TU_CodArchivo
	INNER JOIN Catalogo.GrupoTrabajo G
	ON AE.TN_CodGrupoTrabajo			= G.TN_CodGrupoTrabajo
	AND AE.TU_CodArchivo				= @L_CodigoArchivo

END
GO
