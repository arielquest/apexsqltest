SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez/Jonathan Aguilar Navarro>
-- Fecha de creación:	<05/07/2021>
-- Descripción:			<Actualiza la fecha de envío o Fecha de Salida con NULL, del registro asociado a la itineración cuando existe error, para poder volver a enviar la itineración
--						de nuevo, lo anterior cuando el destino de la Itineración es Gestión/SSC>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ActualizarFechaItineracionConError]
    @CodHistoricoItineracion	UNIQUEIDENTIFIER = NULL
AS
BEGIN
	--variables
	DECLARE		@L_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
				@RowCount					INTEGER				= 0

	UPDATE		A
	SET			A.TF_Salida							= NULL
	FROM		Historico.ExpedienteEntradaSalida	A 
	INNER JOIN	Historico.Itineracion				B
	ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
	WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion

	SELECT		@RowCount = @@ROWCOUNT;
	
	IF (@RowCount <= 0)
	BEGIN 
		UPDATE		A
		SET			A.TF_Salida							= NULL
		FROM		Historico.LegajoEntradaSalida		A 
		INNER JOIN	Historico.Itineracion				B 
		ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
		WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion

		SELECT		@RowCount = @@ROWCOUNT;

		IF (@RowCount <= 0)
		BEGIN 

			UPDATE		A
			SET			A.TF_Fecha_Envio					= NULL
			FROM		Expediente.RecursoExpediente		A 
			INNER JOIN	Historico.Itineracion				B 
			ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
			WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion

			SELECT		@RowCount = @@ROWCOUNT;

			IF (@RowCount <= 0)
			BEGIN 
				UPDATE		A
				SET			A.TF_FechaEnvio						= NULL
				FROM		Expediente.SolicitudExpediente		A 
				INNER JOIN	Historico.Itineracion				B
				ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
				WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion

				SELECT		@RowCount = @@ROWCOUNT;

				IF (@RowCount <= 0)
				BEGIN 

					UPDATE		A
					SET			A.TF_FechaEnvio						= NULL
					FROM		Expediente.ResultadoRecurso			A
					INNER JOIN	Historico.Itineracion				B
					ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
					WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion

					SELECT		@RowCount = @@ROWCOUNT;

					IF (@RowCount <= 0)
					BEGIN 
						UPDATE		A
						SET			A.TF_FechaEnvio						= NULL
						FROM		Expediente.ResultadoSolicitud		A
						INNER JOIN	Historico.Itineracion				B
						ON			A.TU_CodHistoricoItineracion		= B.TU_CodHistoricoItineracion
						WHERE		B.TU_CodHistoricoItineracion		= @L_CodHistoricoItineracion
					END
				END
			END
		END
	END
END
GO
