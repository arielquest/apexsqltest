SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite eliminar un interviniente de un legajo.> 
-- =================================================================================================================================================
-- Modificación:			<08/06/2016> <Johan Acosta> <Se pone en una transacción el borrado de las tablas asociadas>
-- Modificación:			<22/10/2019> <Isaac Dobles> <Se ajusta para estructura actual de intervenciones y expedientes>
-- Modificación:			<28/04/2021> <Isaac Santiago Méndez Castillo> <Se agrega mensaje descriptivo en RAISEERROR para incluir el código de error>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarInterviniente]  
   @CodigoInterviniente uniqueidentifier,
   @NumeroExpediente char(14),
   @CodigoPersona uniqueidentifier 
AS 
BEGIN 

	DECLARE @ERRORMESSAGE 	NVARCHAR(4000)
	DECLARE @ERRORSEVERITY	INT
	DECLARE @ERRORSTATE		INT
   
	BEGIN TRY
				BEGIN TRANSACTION Borrar_Interviniente	

					DELETE 
					FROM	Expediente.IntervinienteDiscapacidad
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Expediente.IntervinienteVulnerabilidad
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Expediente.IntervinienteDomicilio
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Expediente.IntervencionMedioComunicacion
					WHERE	TU_CodInterviniente		= @CodigoInterviniente
         
					DELETE 
					FROM	Expediente.IntervinienteVictima
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Expediente.Interviniente
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Agenda.IntervinienteEvento
					WHERE	TU_CodInterviniente		= @CodigoInterviniente

					DELETE 
					FROM	Expediente.Intervencion
					WHERE	TU_CodInterviniente		= @CodigoInterviniente
					And		TC_NumeroExpediente		= @NumeroExpediente

				COMMIT TRANSACTION Borrar_Interviniente
	END TRY
	BEGIN CATCH
				ROLLBACK TRANSACTION Borrar_Interviniente
				SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
						@ERRORSTATE = ERROR_STATE(),
						@ERRORMESSAGE = 'El código de error es: ' + CONVERT(NVARCHAR(10),ERROR_NUMBER()) + '. El error es: ' + ERROR_MESSAGE()
			   
				RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END
GO
