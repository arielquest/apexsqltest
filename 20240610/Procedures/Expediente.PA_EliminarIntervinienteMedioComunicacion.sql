SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<10/03/2016>
-- Descripción :			<Permite eliminar un Medio de Comunicacion del interviniente.> 
-- Modificación:			<Andrés Díaz><14/03/2016><Se modifica la llave primaria de la tabla.>
-- Modificación:			<Juan Ramírez V><24/09/2018> <Se modifica la estructura debido al cambio de interviniente a intervenciones>
-- Modificación:			<Isaac Dobles Mata><17/09/2019> <Se agrega borrado en cascada para eliminar medio del legajo también>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarIntervinienteMedioComunicacion] 
	@CodMedioComunicacion	uniqueidentifier,
	@BorradoCompleto		bit
AS
BEGIN

	BEGIN TRANSACTION

	BEGIN TRY

		IF(@BorradoCompleto = 1) 
		BEGIN
			DELETE FROM Expediente.IntervencionMedioComunicacionLegajo
			WHERE TU_CodMedioComunicacion = @CodMedioComunicacion
		END
		DELETE FROM Expediente.IntervencionMedioComunicacion
		WHERE TU_CodMedioComunicacion = @CodMedioComunicacion;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			THROW;	
	END CATCH
END
GO
