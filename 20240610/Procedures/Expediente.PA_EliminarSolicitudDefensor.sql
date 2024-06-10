SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<12/05/2017>
-- Descripción :			<Elimina un registro de la tabla [Expediente].[SolicitudDefensor] y
--							 los asociados de la tabla [Expediente].[SolicitudDefensorInterviniente] > 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarSolicitudDefensor]  
   @CodSolicitudDefensor uniqueidentifier
AS 
BEGIN 

	BEGIN TRY
		BEGIN TRANSACTION Borrar_Solicitud	

			DELETE 
			FROM	[Expediente].[SolicitudDefensorInterviniente]
			WHERE	TU_CodSolicitudDefensor = @CodSolicitudDefensor

			DELETE 
			FROM	[Expediente].[SolicitudDefensor]
			WHERE	TU_CodSolicitudDefensor = @CodSolicitudDefensor
				

		COMMIT TRANSACTION Borrar_Solicitud
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION Borrar_Solicitud
	END CATCH 
END
GO
