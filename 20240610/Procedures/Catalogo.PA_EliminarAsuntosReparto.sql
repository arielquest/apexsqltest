SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:				<Johan Manuel  Acosta Ibañez>
-- Fecha Creación:		<30/07/2021>
-- Descripcion:			<Permite eliminar un registro de la tabla Catalogo.AsuntosReparto>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarAsuntosReparto]
	@CodAsunto					INT = NULL,
	@CodConfiguracionReparto	UNIQUEIDENTIFIER
AS
BEGIN

	DELETE
	FROM		Catalogo.AsuntosReparto	
	WHERE		TN_CodAsunto				=	COALESCE(@CodAsunto, TN_CodAsunto)
	AND			TU_CodConfiguracionReparto	=	@CodConfiguracionReparto

End
GO
