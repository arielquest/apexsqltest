SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <12/09/2017>
-- Descripcion:	   <Agregar los datos generales de la asignación de la firma de documentos en el expediente>
-- 

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteAsignacionFirmado] 
	   @CodAsignacionFirmado 			uniqueidentifier,
       @CodArchivo 						uniqueidentifier,
       @AsignadoPor 					uniqueidentifier,
       @FechaAsigna 					datetime2(7),
       @Urgente 						bit,
       @Estado 							char(1),
	   @CodArchivoAsignado  			uniqueidentifier,	  
	   @CodArchivoFirmado  				uniqueidentifier
AS

BEGIN

		INSERT INTO [Expediente].[AsignacionFirmado]
           ([TU_CodAsignacionFirmado]
           ,[TU_CodArchivo]
           ,[TU_AsignadoPor]
           ,[TF_FechaAsigna]
           ,[TB_Urgente]
           ,[TC_Estado]
		   ,[TU_CodArchivoAsignado]
		   ,[TU_CodArchivoFirmado])
     VALUES
           (	
		   @CodAsignacionFirmado,
		   @CodArchivo,
		   @AsignadoPor,
		   @FechaAsigna,
		   @Urgente,
		   @Estado,
		   @CodArchivoAsignado,
		   @CodArchivoFirmado)
	END

GO
