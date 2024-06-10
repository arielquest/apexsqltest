SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <31/10/2017>
-- Descripcion:	   <Devuelve un documento para corregir en una asignación de firma>

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_DevolverLegajoArchivoAsignado]
	@CodAsignacionFirmado uniqueidentifier,
	@CodDevueltoPor uniqueidentifier,
	@CodDevueltoA varchar(14),
	@FechaDevuelto datetime2,
	@Observacion VARCHAR(300),
	@EstadoDevolucion VARCHAR(2)
	
WITH RECOMPILE
AS
BEGIN

UPDATE Expediente.AsignacionFirmado
   SET	TC_Estado = @EstadoDevolucion,
		TU_DevueltoPor = @CodDevueltoPor,
		TU_DevueltoA = @CodDevueltoA,
		TC_Observacion = @Observacion,
		TF_FechaDevolucion= @FechaDevuelto
 WHERE  TU_CodAsignacionFirmado = @CodAsignacionFirmado

END

GO
