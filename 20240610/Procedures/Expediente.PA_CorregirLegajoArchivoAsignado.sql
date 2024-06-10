SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <31/10/2017>
-- Descripcion:	   <Corrige un documento en una asignaci�n de firma>

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_CorregirLegajoArchivoAsignado]
	@CodAsignacionFirmado uniqueidentifier,
	@CodCorregidoPor uniqueidentifier,
	@EstadoCorregir VARCHAR(2)
	
WITH RECOMPILE
AS
BEGIN

UPDATE Expediente.AsignacionFirmado
   SET	TC_Estado = @EstadoCorregir,
		TU_CorregidoPor = @CodCorregidoPor
 WHERE  TU_CodAsignacionFirmado = @CodAsignacionFirmado

END

GO
