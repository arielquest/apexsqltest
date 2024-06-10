SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <21/12/2017>
-- Descripcion:	   <Eliminar la asignación de la firma de documentos en el expediente>
-- ================================================================================================================================================================
-- Modificación	   <Jonathan Aguilar Navarro> <18/09/2018> <Se crea el esquema Archivo y se renombra respectivamente en los sp y tablas> 
-- Modificación	   <Aida Elena Siles R> <09/07/2021> <Se agrega la tabla Comunicacion.ComunicacionRegistroAutomatica para que elimine el registro en caso de existir>
-- ================================================================================================================================================================
CREATE PROCEDURE [Archivo].[PA_EliminarAsignacionFirmado] 
	   @CodAsignacionFirmado 			UNIQUEIDENTIFIER
AS
BEGIN
--Variables
DECLARE	@L_CodAsignacionFirmado		UNIQUEIDENTIFIER = @CodAsignacionFirmado
BEGIN TRY
	BEGIN TRANSACTION EliminarAsignacion		

		DELETE		ACR
		FROM		Comunicacion.ArchivoComunicacionRegistroAutomatico	ACR WITH (ROWLOCK)
		INNER JOIN	Comunicacion.ComunicacionRegistroAutomatico			CRA	WITH (NOLOCK)
		ON			ACR.TU_CodComunicacionAut							= CRA.TU_CodComunicacionAut
		WHERE		CRA.TU_CodAsignacionFirmado							= @L_CodAsignacionFirmado

		DELETE
		FROM	Comunicacion.ComunicacionRegistroAutomatico WITH(ROWLOCK)	
		WHERE	TU_CodAsignacionFirmado						= @L_CodAsignacionFirmado
		
		DELETE 
		FROM	Archivo.AsignacionFirmante	WITH(ROWLOCK)	  
		WHERE	TU_CodAsignacionFirmado		= @L_CodAsignacionFirmado
		
		DELETE 
		FROM	Archivo.AsignacionFirmado	WITH(ROWLOCK)
		WHERE	TU_CodAsignacionFirmado		= @L_CodAsignacionFirmado

	COMMIT TRANSACTION EliminarAsignacion
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION EliminarAsignacion
END CATCH
END

GO
