SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <13/09/2017>
-- Descripcion:	   Modificar el detalle de los firmantes en la asignación de la firma de documentos en el expediente
-- 

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarAsignacionFirmante] 
	   @CodAsignacionFirmado uniqueidentifier,
       @CodPuestoTrabajo varchar(14),
       @Orden tinyint,
	   @FirmadoPor uniqueidentifier
AS

BEGIN
	
	IF (NOT EXISTS(SELECT * FROM [Expediente].[AsignacionFirmante] WHERE @CodAsignacionFirmado = TU_CodAsignacionFirmado AND @CodPuestoTrabajo = TC_CodPuestoTrabajo))
		INSERT INTO [Expediente].[AsignacionFirmante]
			   ([TU_CodAsignacionFirmado]
			   ,[TC_CodPuestoTrabajo]
			   ,[TN_Orden]
			   ,[TU_FirmadoPor])
		 VALUES
			  (@CodAsignacionFirmado,
			   @CodPuestoTrabajo,
			   @Orden,
			   @FirmadoPor)
	ELSE
		UPDATE [Expediente].[AsignacionFirmante]
		SET TN_Orden =@Orden
		WHERE 
			@CodAsignacionFirmado = TU_CodAsignacionFirmado AND 
			@CodPuestoTrabajo = TC_CodPuestoTrabajo
END
GO
