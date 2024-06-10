SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen DAwson>
-- Fecha de creación:		<11/10/2019>
-- Descripción :			<Mueve un escrito de un expediente a uno de sus legajos>
-- =================================================================================================================================================
-- Modificación:			<Ronny Ramírez Rojas> <25/05/2020> <Se agrega TN_Consecutivo.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_MoverEscrito]

@CodEscrito uniqueidentifier,
@CodLegajo uniqueidentifier,
@ConsecutivoHistorialProcesal	int = null

AS
BEGIN TRANSACTION

	BEGIN TRY
		--Variables
		DECLARE	@L_TU_CodEscrito			UNIQUEIDENTIFIER		= @CodEscrito,
				@L_TU_CodLegajo				UNIQUEIDENTIFIER		= @CodLegajo,
				@L_TN_Consecutivo			INT						= @ConsecutivoHistorialProcesal

		--Lógica mover escrito a legajo
		INSERT INTO Expediente.EscritoLegajo
			   (TU_CodEscrito
			   ,TU_CodLegajo)
		 VALUES
			   (@L_TU_CodEscrito
			   ,@L_TU_CodLegajo)

		--Lógica de actualizar el # de consecutivo del Historial Procesal
		UPDATE	Expediente.EscritoExpediente	WITH (ROWLOCK)
		SET		TN_Consecutivo					= @L_TN_Consecutivo
		WHERE	TU_CodEscrito					= @L_TU_CodEscrito

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION

	END CATCH  
GO
