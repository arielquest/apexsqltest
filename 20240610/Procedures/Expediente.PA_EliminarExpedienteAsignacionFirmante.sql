SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <21/12/2017>
-- Descripción:	   <Eliminar la asignación de la firma de documentos en el expediente>
-- 

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarExpedienteAsignacionFirmante] 
	   @CodAsignacionFirmado 			uniqueidentifier,
	   @CodPuestoTrabajo 				varchar(14)
AS

BEGIN
	DECLARE @ERRORMESSAGE 	NVARCHAR(4000)
	DECLARE @ERRORSEVERITY	INT
	DECLARE @ERRORSTATE		INT
   
	BEGIN TRY
				BEGIN TRANSACTION Eliminar_Firmante
					DELETE [Expediente].[AsignacionFirmante]	  
					WHERE 
							@CodAsignacionFirmado = TU_CodAsignacionFirmado AND 
							@CodPuestoTrabajo = TC_CodPuestoTrabajo	

					UPDATE [Expediente].[AsignacionFirmante]
					SET [Expediente].[AsignacionFirmante].TN_Orden = ListaOrdenada.NuevoOrden
					FROM 
						(
							SELECT [Expediente].[AsignacionFirmante].TU_CodAsignacionFirmado, 
									ROW_NUMBER() OVER (ORDER BY [Expediente].[AsignacionFirmante].TN_Orden ASC) AS NuevoOrden, 
									[Expediente].[AsignacionFirmante].TC_CodPuestoTrabajo
							FROM [Expediente].[AsignacionFirmante]
							WHERE
								TU_CodAsignacionFirmado = @CodAsignacionFirmado
						) AS ListaOrdenada
					WHERE 
							[Expediente].[AsignacionFirmante].TU_CodAsignacionFirmado = ListaOrdenada.TU_CodAsignacionFirmado AND
							[Expediente].[AsignacionFirmante].TC_CodPuestoTrabajo = ListaOrdenada.TC_CodPuestoTrabajo
				COMMIT TRANSACTION Eliminar_Firmante
	END TRY
	BEGIN CATCH
				ROLLBACK TRANSACTION Eliminar_Firmante
				SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
						@ERRORSTATE = ERROR_STATE(),
						@ERRORMESSAGE = ERROR_MESSAGE()
			   
				RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END

GO
