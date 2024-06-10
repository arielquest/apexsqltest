SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creaci�n: <21/12/2017>
-- Descripcion:	   <Eliminar la asignaci�n de la firma de documentos en el expediente>
-- 

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarExpedienteAsignacionFirmado]
	   @CodAsignacionFirmado 			uniqueidentifier
AS
BEGIN
	DECLARE @ERRORMESSAGE 	NVARCHAR(4000)
	DECLARE @ERRORSEVERITY	INT
	DECLARE @ERRORSTATE		INT

	BEGIN TRY
		BEGIN TRANSACTION Borrar_Asignacion
			DELETE [Expediente].[AsignacionFirmante]	  
			WHERE 
					@CodAsignacionFirmado = TU_CodAsignacionFirmado
					
			DELETE [Expediente].[AsignacionFirmado] 
			WHERE 
					@CodAsignacionFirmado = TU_CodAsignacionFirmado
		COMMIT TRANSACTION Borrar_Asignacion
	END TRY
	BEGIN CATCH
				ROLLBACK TRANSACTION Borrar_Asignacion
				SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
						@ERRORSTATE = ERROR_STATE(),
						@ERRORMESSAGE = ERROR_MESSAGE()
			   
				RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END

GO
