SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles R>
-- Fecha de creación:		<07/06/2021>
-- Descripción :			<Permite eliminar un legajo y sus datos asociados.> 
-- =================================================================================================================================================
-- Modificación:			<20/03/2023> <Josué Quirós Batista> <Se incluye la eliminación de la tabla Expediente.Intervencion>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarLegajo]  
   @CodLegajo UNIQUEIDENTIFIER
AS 
BEGIN 

    DECLARE @L_CodLegajo		UNIQUEIDENTIFIER = @CodLegajo
	DECLARE @ERRORMESSAGE 		NVARCHAR(4000)
	DECLARE @ERRORSEVERITY		INT
	DECLARE @ERRORSTATE			INT
   
	BEGIN TRY
				BEGIN TRANSACTION BORRAR_LEGAJO
				
					DELETE
					FROM	Historico.ItineracionSolicitudResultado WITH(ROWLOCK)
					WHERE   TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Historico.ItineracionRecursoResultado WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

				   	DELETE 
					FROM	Historico.LegajoMovimientoCirculanteFase WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Historico.LegajoAsignado WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

				   	DELETE 
					FROM	Historico.LegajoFase WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

				    DELETE 
					FROM	Historico.LegajoMovimientoCirculante WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.IntervencionMedioComunicacionLegajo WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Historico.LegajoEntradaSalida WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Historico.HistoricoReparto WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					SELECT	TU_CodEscrito
					INTO	#TempEscritosLegajo
					FROM	Expediente.EscritoLegajo WITH(NOLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.EscritoLegajo WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.EscritoExpediente WITH(ROWLOCK)
					WHERE	TU_CodEscrito			IN (SELECT	* 
														FROM	#TempEscritosLegajo)

					DELETE
					FROM	Expediente.ResultadoRecurso WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.ResultadoSolicitud WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					SELECT	TN_CodAudiencia
					INTO	#TempAudienciasLegajo
					FROM	Expediente.AudienciaLegajo WITH(NOLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.AudienciaLegajo WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.EtiquetaAudiencia WITH(ROWLOCK)
					WHERE	TN_CodAudiencia			IN (SELECT	* 
														FROM	#TempAudienciasLegajo)					

					DELETE
					FROM	Expediente.Audiencia WITH(ROWLOCK)
					WHERE	TN_CodAudiencia			IN (SELECT	*	 
														FROM	#TempAudienciasLegajo)

					DELETE
					FROM	Expediente.ObservacionExpedienteLegajo WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE
					FROM	Expediente.ApremioLegajo WITH(ROWLOCK)
					WHERE	TU_CodLegajo			= @L_CodLegajo

					DELETE		IMC
					FROM		Expediente.IntervencionMedioComunicacion IMC WITH(ROWLOCK)
					INNER JOIN	Expediente.LegajoIntervencion B WITH (NOLOCK)
					ON			IMC.TU_CodInterviniente		= B.TU_CodInterviniente
					WHERE		B.TU_CodLegajo				= @L_CodLegajo
					AND			IMC.TB_PerteneceExpediente	= 0

					DELETE
					FROM		Comunicacion.Comunicacion WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.DetalleDepuracionInactivo WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.Bloqueo WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.ConsecutivoHistorialProcesal WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					SELECT		A.TU_CodInterviniente
					INTO		#TempIntervinientesLegajo
					From		Expediente.Intervencion A
					Inner Join  Expediente.Legajo		B
					On			B.TU_CodLegajo			= @L_CodLegajo
					Outer Apply (
					select		C.TU_CodInterviniente
					From		Expediente.LegajoIntervencion  C
					Where		C.TU_CodLegajo				 = @L_CodLegajo) OA
					Where		A.TU_CodInterviniente		 = OA.TU_CodInterviniente
					And		    A.TC_NumeroExpediente		 = B.TC_NumeroExpediente
									   
					DELETE
					FROM		Expediente.LegajoIntervencion WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.TareaPendiente WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.ExpedienteSolicitudAcceso WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.LegajoDetalle WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					SELECT		TU_CodArchivo
					INTO		#TempArchivosLegajo
					FROM		Expediente.LegajoArchivo WITH(NOLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					--Se utiliza el CodArchivo para eliminar en Expediente.ExclusionHistorialProcesal y no el codLegajo, ya que se hizo una prueba de eliminación-y el CodLegajo no se esta registrando
					DELETE
					FROM	Expediente.ExclusionHistorialProcesal WITH(ROWLOCK)
					WHERE	TU_CodArchivo					IN (SELECT	* 
																FROM	#TempArchivosLegajo)

				    --Eliminación de los documentos asociados a las intervenciones del legajo
					DELETE		IA
					FROM		Expediente.IntervencionArchivo IA WITH(ROWLOCK)
					INNER JOIN	Expediente.LegajoIntervencion LI WITH(NOLOCK)
					ON			IA.TU_CodInterviniente	= LI.TU_CodInterviniente
					AND			LI.TU_CodLegajo			= @L_CodLegajo
					WHERE		IA.TU_CodArchivo			IN (SELECT	* 
																FROM	#TempArchivosLegajo)

					DELETE
					FROM		Expediente.LegajoArchivo WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.ArchivoExpediente WITH(ROWLOCK)
					WHERE		TU_CodArchivo				IN (SELECT	* 
																FROM	#TempArchivosLegajo)
					DELETE
					FROM		Expediente.Legajo WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Historico.LegajoUbicacion WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo

					DELETE
					FROM		Expediente.ExpedienteConsolidado WITH(ROWLOCK)
					WHERE		TU_CodLegajo				= @L_CodLegajo
										
					Delete 
					From		Expediente.Intervencion 
					Where		TU_CodInterviniente In ( Select TU_CodInterviniente From #TempIntervinientesLegajo)

					Delete 
					From		Expediente.Interviniente 
					Where		TU_CodInterviniente In ( Select TU_CodInterviniente From #TempIntervinientesLegajo)
	
				COMMIT TRANSACTION BORRAR_LEGAJO
				DROP TABLE #TempEscritosLegajo
				DROP TABLE #TempAudienciasLegajo
				DROP TABLE #TempArchivosLegajo
				DROP TABLE #TempIntervinientesLegajo
	END TRY
	BEGIN CATCH
				ROLLBACK TRANSACTION BORRAR_LEGAJO
				SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
						@ERRORSTATE = ERROR_STATE(),
						@ERRORMESSAGE = 'El código de error es: ' + CONVERT(NVARCHAR(10),ERROR_NUMBER()) + '. El error es: ' + ERROR_MESSAGE()
			   
				RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END
GO
