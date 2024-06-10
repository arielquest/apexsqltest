SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<02/04/2020>
-- Descripción:				<Consulta el Código del grupo de trabajo por medio de la resolución principal> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ObtenerGrupoTrabajo]
(
	@CodigoComunicacion         VARCHAR(65)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @TempCodigoComunicacion VARCHAR(165)
	SELECT @TempCodigoComunicacion = @CodigoComunicacion
	
SELECT 
		E.TN_CodGrupoTrabajo CodigoGrupoTrabajo
	FROM Comunicacion.ArchivoComunicacion AS C WITH(NOLOCK)

	INNER JOIN Expediente.ArchivoExpediente AS E WITH(NOLOCK)
	ON E.TU_CodArchivo = C.TU_CodArchivo

	WHERE C.TU_CodComunicacion = @TempCodigoComunicacion
	AND C.TB_EsPrincipal = 1

END
GO
