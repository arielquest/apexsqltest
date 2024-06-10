SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					 1.0
-- Creado por:				<Aarón Ríos Retana>
-- Fecha de creación:		<08/12/2021>
-- Descripción :			<Permite mover un escrito a un expediente o un legajo y cambiar la descripción del escrito>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ReubicarEscrito]
	@CodEscrito uniqueidentifier,
	@DescripcionEscrito varchar(255),
	@NumeroExpedienteOrigen char(14),
	@CodLegajoOrigen uniqueidentifier,
	@NumeroExpedienteDestino char(14),
	@CodLegajoDestino uniqueidentifier,
	@ConsecutivoHistorialProcesal	int
AS
BEGIN TRANSACTION

	BEGIN TRY
		--Variables
		DECLARE	@L_TU_CodEscrito				UNIQUEIDENTIFIER		= @CodEscrito,
				@L_TC_NumeroExpedienteOrigen	CHAR(14)				= @NumeroExpedienteOrigen,
				@L_TU_CodLegajoOrigen			UNIQUEIDENTIFIER		= @CodLegajoOrigen,
				@L_TC_NumeroExpedienteDestino   CHAR(14)				= @NumeroExpedienteDestino,
				@L_TU_CodLegajoDestino			UNIQUEIDENTIFIER		= @CodLegajoDestino,
				@L_TN_Consecutivo				INT						= @ConsecutivoHistorialProcesal,
				@L_DescripcionEscrito			varchar(255)			= @DescripcionEscrito

		--Validamos si el origen es un expediente
		IF @L_TU_CodLegajoOrigen is null
		BEGIN 
			-- Validamos si el destino es un expediente
			IF @L_TU_CodLegajoDestino IS NULL
			BEGIN
				--Se actualiza el número de expediente y el consecutivo del historial procesal 
				UPDATE  Expediente.EscritoExpediente
				SET TC_NumeroExpediente = @L_TC_NumeroExpedienteDestino, 
					TN_Consecutivo	= @L_TN_Consecutivo,
					TC_Descripcion = @L_DescripcionEscrito	
				where TU_CodEscrito = @L_TU_CodEscrito
			END
			ELSE --El destino es un legajo, no importa si es del mismo número de expediente u otro, igual se actualiza el TC_NumeroExpediente
			BEGIN
				--Se actualiza el número de expediente y el consecutivo del historial procesal 
				UPDATE  Expediente.EscritoExpediente
				SET TC_NumeroExpediente = @L_TC_NumeroExpedienteDestino, 
					TN_Consecutivo	= @L_TN_Consecutivo,
					TC_Descripcion = @L_DescripcionEscrito
				WHERE TU_CodEscrito = @L_TU_CodEscrito
				-- Se Registra la relación con el legajo 
				INSERT  INTO  Expediente.EscritoLegajo
					(TU_CodEscrito,TU_CodLegajo)
				VALUES 
					(@L_TU_CodEscrito,@L_TU_CodLegajoDestino)
			END
		END
		ELSE --El origen es un legajo
		BEGIN 
			-- Validamos si el destino es un expediente
			IF @L_TU_CodLegajoDestino IS NULL
			BEGIN
				--Se actualiza el número de expediente y el consecutivo del historial procesal 
				UPDATE  Expediente.EscritoExpediente
				SET TC_NumeroExpediente = @L_TC_NumeroExpedienteDestino, 
					TN_Consecutivo	= @L_TN_Consecutivo,
					TC_Descripcion = @L_DescripcionEscrito
				where TU_CodEscrito = @L_TU_CodEscrito
				-- Se elimina la relación del legajo origen con el escrito
				DELETE FROM Expediente.EscritoLegajo
				WHERE TU_CodEscrito = @L_TU_CodEscrito AND TU_CodLegajo = @L_TU_CodLegajoOrigen
			END
			ELSE --El destino es un legajo
			BEGIN
				--Validamos si el destino es un legajo de otro expediente
				IF @L_TC_NumeroExpedienteOrigen <> @L_TC_NumeroExpedienteDestino
				BEGIN
					--Se actualiza el número de expediente y el consecutivo del historial procesal 
					UPDATE  Expediente.EscritoExpediente
					SET TC_NumeroExpediente = @L_TC_NumeroExpedienteDestino, 
						TN_Consecutivo	= @L_TN_Consecutivo,
						TC_Descripcion = @L_DescripcionEscrito
					where TU_CodEscrito = @L_TU_CodEscrito
					-- Se actualiza para relacionarlo al otro legajo 
					UPDATE Expediente.EscritoLegajo 
					SET TU_CodLegajo = @L_TU_CodLegajoDestino
					WHERE TU_CodEscrito = @L_TU_CodEscrito
				END 
				ELSE -- El destino es un legajo del mismo expediente 
				BEGIN 
					--Se actualiza  el consecutivo del historial procesal 
					UPDATE  Expediente.EscritoExpediente
					SET  TN_Consecutivo	= @L_TN_Consecutivo,
						 TC_Descripcion = @L_DescripcionEscrito
					WHERE TU_CodEscrito = @L_TU_CodEscrito
					-- Se actualiza para relacionarlo al otro legajo 
					UPDATE Expediente.EscritoLegajo 
					SET TU_CodLegajo = @L_TU_CodLegajoDestino
					WHERE TU_CodEscrito = @L_TU_CodEscrito
				END
			END
		END

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION

	END CATCH  
GO
