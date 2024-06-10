SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<26/05/2021>
-- Descripción :			<Permite eliminar un expediente y datos asociados.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarExpediente]  
   @NumeroExpediente char(14)
AS 
BEGIN 

    DECLARE @L_NumeroExpediente char(14) = @NumeroExpediente
	DECLARE @ERRORMESSAGE 	NVARCHAR(4000)
	DECLARE @ERRORSEVERITY	INT
	DECLARE @ERRORSTATE		INT
   
	BEGIN TRY
				BEGIN TRANSACTION Borrar_Expediente	

				   	DELETE 
					FROM	Historico.ExpedienteMovimientoCirculanteFase
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

				   	DELETE 
					FROM	Historico.ExpedienteFase
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

				    DELETE 
					FROM	Historico.ExpedienteMovimientoCirculante
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

					DELETE ID
					FROM Expediente.IntervinienteDelito ID 
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = ID.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE IM
					FROM Expediente.IntervencionMedioComunicacion IM
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = IM.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE IDO
					FROM Expediente.IntervinienteDomicilio IDO
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = IDO.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE IV
					FROM Expediente.IntervinienteVulnerabilidad IV
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = IV.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE IDIS
					FROM Expediente.IntervinienteDiscapacidad IDIS
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = IDIS.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE IBT
					FROM Expediente.IntervinienteBoletaTransito IBT
					INNER JOIN Expediente.Intervencion I WITH (NOLOCK)
					ON I.TU_CodInterviniente = IBT.TU_CodInterviniente
					WHERE I.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE 
					FROM	Historico.ExpedienteAsignado
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

					DELETE IA
					FROM Expediente.IntervencionArchivo IA
					INNER JOIN Archivo.Archivo AA WITH (NOLOCK)
					ON AA.TU_CodArchivo = IA.TU_CodArchivo
					INNER JOIN Expediente.ArchivoExpediente EAE  WITH (NOLOCK)
					ON EAE.TU_CodArchivo = AA.TU_CodArchivo
					WHERE EAE.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE 
					FROM Expediente.ConsecutivoHistorialProcesal
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE 
					FROM Expediente.ExclusionHistorialProcesal
					WHERE TC_NumeroExpediente = @L_NumeroExpediente


					DELETE 
					FROM Expediente.ArchivoExpediente
					WHERE TC_NumeroExpediente= @L_NumeroExpediente


					DELETE AA
					FROM Archivo.Archivo AA
					INNER JOIN Expediente.ArchivoExpediente AE WITH (NOLOCK)
					ON AE.TU_CodArchivo= AA.TU_CodArchivo
					WHERE AE.TC_NumeroExpediente = @L_NumeroExpediente

					DELETE EINTERV
					FROM Expediente.Interviniente EINTERV
					INNER JOIN Expediente.Intervencion EINTERO WITH (NOLOCK)
					ON EINTERO.TU_CodInterviniente = EINTERV.TU_CodInterviniente
					WHERE EINTERO.TC_NumeroExpediente= @L_NumeroExpediente

					DELETE
					FROM Expediente.Intervencion 
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE 
					FROM Historico.ExpedienteEntradaSalida
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

				    DELETE 
					FROM Historico.ExpedienteMovimientoCirculante
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE
					FROM Expediente.Bloqueo
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE
					FROM Historico.ExpedienteUbicacion
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE
					FROM Expediente.Deuda
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE 
					FROM Historico.HistoricoReparto
					WHERE TC_NumeroExpediente = @L_NumeroExpediente

					DELETE 
					FROM	Expediente.ExpedienteDetalle
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

					DELETE 
					FROM	Expediente.Expediente
					WHERE	TC_NumeroExpediente		= @L_NumeroExpediente

				COMMIT TRANSACTION Borrar_Expediente
	END TRY
	BEGIN CATCH
				ROLLBACK TRANSACTION Borrar_Expediente
				SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
						@ERRORSTATE = ERROR_STATE(),
						@ERRORMESSAGE = 'El código de error es: ' + CONVERT(NVARCHAR(10),ERROR_NUMBER()) + '. El error es: ' + ERROR_MESSAGE()
			   
				RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END
GO
