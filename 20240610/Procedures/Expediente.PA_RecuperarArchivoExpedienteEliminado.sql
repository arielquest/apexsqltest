SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <09/01/2019>
-- Descripcion:	   <Restaura un archivo borrado lógicamente dentro de un expediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_RecuperarArchivoExpedienteEliminado] 
	@CodigoArchivo				uniqueidentifier
AS
BEGIN
		UPDATE		[Expediente].[ArchivoExpediente]
		SET			[TB_Eliminado]						=	0
		WHERE		[TU_CodArchivo]						=	@CodigoArchivo
END
GO
