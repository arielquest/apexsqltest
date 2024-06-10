SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <18/12/2017>
-- Descripcion:	   <Modificar los datos generales de la asignación de la firma de documentos en el expediente>
-- =================================================================================================================================================
-- Modificación:	<30/09/2020>	<Daniel Ruiz Hernández> <Se agrega el dato CodArchivoFirmado para poder actualizarlo.>
-- =================================================================================================================================================
-- Modificación:	<08/03/2021>	<Daniel Ruiz Hernández> <Se modifican los parametros para actualizar solo el estado sin necesidad de enviar todos los datos>
-- =================================================================================================================================================
-- Modificación:    <25/03/2021>    <Miguel Avendaño Rosales> <Se modifican los parametros para actualizar tambien el archivo asignado>
-- =================================================================================================================================================
CREATE PROCEDURE [Archivo].[PA_ModificarAsignacionFirmado] 
       @CodAsignacionFirmado            UNIQUEIDENTIFIER,
       @CodArchivo                      UNIQUEIDENTIFIER,
       @AsignadoPor                     UNIQUEIDENTIFIER = null,
       @FechaAsigna                     DATETIME2(7) = null,
       @Urgente                         BIT = null,
       @Estado                          CHAR(1) = null,
       @CodArchivoFirmado               UNIQUEIDENTIFIER = null,
       @CodArchivoAsignado              UNIQUEIDENTIFIER = null
AS

 

BEGIN
    UPDATE [Archivo].[AsignacionFirmado] 
    SET    [TU_AsignadoPor]				= ISNULL(@AsignadoPor,TU_AsignadoPor), 
           [TF_FechaAsigna]				= ISNULL(@FechaAsigna,TF_FechaAsigna),
           [TB_Urgente]					= ISNULL(@Urgente,TB_Urgente),
           [TC_Estado]					= ISNULL(@Estado,TC_Estado),
           TU_CodArchivoFirmado			= ISNULL(@CodArchivoFirmado,TU_CodArchivoFirmado),
           TU_CodArchivoAsignado		= ISNULL(@CodArchivoAsignado,TU_CodArchivoAsignado)    
    WHERE 
            @CodAsignacionFirmado		= TU_CodAsignacionFirmado AND 
            @CodArchivo					= TU_CodArchivo
END
GO
