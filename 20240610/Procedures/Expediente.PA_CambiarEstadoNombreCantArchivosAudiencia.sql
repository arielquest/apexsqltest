SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- VersiÃ³n:			<1.0>
-- Creado por:		<Richard ZÃºÃ±iga Segura>
-- Fecha creaciÃ³n:	<27/04/2021>
-- DescripciÃ³n :	<Permite cambiar el nombre del archivo multimedia, la cantidad de archivos y el estado de una audiencia
--					el cual indica si ya fue convertida una audiencia para que sea sincronizada al servidor de streaming> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_CambiarEstadoNombreCantArchivosAudiencia]
		@TN_CodAudiencia		bigint,
		@TC_NombreArchivo		varchar(255),
		@TN_EstadoPublicacion	smallint,
		@TN_CantidadArchivos	tinyint
AS
BEGIN
	UPDATE	Expediente.Audiencia
	SET		TN_EstadoPublicacion	=	@TN_EstadoPublicacion,
			TN_CantidadArchivos		=	@TN_CantidadArchivos,
			TC_NombreArchivo		=	@TC_NombreArchivo
	WHERE	TN_CodAudiencia			=	@TN_CodAudiencia
END
GO
