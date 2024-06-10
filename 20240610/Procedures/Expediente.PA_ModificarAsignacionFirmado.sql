SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <18/12/2017>
-- Descripcion:	   <Modificar los datos generales de la asignación de la firma de documentos en el expediente>
-- 

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarAsignacionFirmado] 
	   @CodAsignacionFirmado 			uniqueidentifier,
       @CodArchivo 						uniqueidentifier,
       @AsignadoPor 					uniqueidentifier,
       @FechaAsigna 					datetime2(7),
       @Urgente 						bit,
       @Estado 							char(1)
	   WITH RECOMPILE
AS
BEGIN

	UPDATE [Expediente].AsignacionFirmado
	SET    [TU_AsignadoPor] = @AsignadoPor, 
           [TF_FechaAsigna] = @FechaAsigna,
           [TB_Urgente] = @Urgente,
           [TC_Estado] =@Estado   
	WHERE 
			@CodAsignacionFirmado = TU_CodAsignacionFirmado AND 
			@CodArchivo =TU_CodArchivo
END

GO
