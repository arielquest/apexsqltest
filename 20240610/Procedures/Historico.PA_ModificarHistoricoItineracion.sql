SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<04/08/2020>
-- Descripción :			<Actualiza el estado y el usuario a un registro de un hitorico de itineracion> 
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <21/08/2020> <Se agrega el campo TC_Mensaje en caso que quiera registrarse el mensaje error.>
-- Modificación:			<Karol Jiménez S> <01/03/2021> <Se agregan coalesce para determinar si parámetros vienen nulos, y se agrega parámetro IdNaitius 
--							para actualizar el histórico con el identificador de la itineración generado al enviar a Gestión>
-- Modificación:			<Ronny Ramírez R.> <06/09/2021> <Se aplica ajuste para agregar nuevo campo de fecha de envío de la itineración>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ModificarHistoricoItineracion] 
	@CodHistoricoItineracion	UNIQUEIDENTIFIER, 
	@CodEstadoItineracion		SMALLINT,
	@UsuarioRed					VARCHAR(30),
	@MensajeError               VARCHAR(255) = NULL,
	@IdNautius					VARCHAR(255),
	@FechaEnvio 				DATETIME2(3) = NULL
	
AS
BEGIN

	DECLARE @L_CodHistoricoItineracion	UNIQUEIDENTIFIER	= @CodHistoricoItineracion,
			@L_CodEstadoItineracion		SMALLINT			= @CodEstadoItineracion,
			@L_UsuarioRed				VARCHAR(30)			= @UsuarioRed,
			@L_MensajeError				VARCHAR(255)		= @MensajeError,
			@L_IdNautius				VARCHAR(255)		= @IdNautius,
			@L_FechaEnvio				DATETIME2(3)		= @FechaEnvio

	UPDATE [Historico].[Itineracion] WITH (ROWLOCK)
	   SET [TC_UsuarioRed]				= COALESCE(@L_UsuarioRed, TC_UsuarioRed) 
	      ,[TN_CodEstadoItineracion]	= COALESCE(@L_CodEstadoItineracion, TN_CodEstadoItineracion)
	      ,[TF_FechaEstado]				= IIF(@L_CodEstadoItineracion IS NULL, TF_FechaEstado, GETDATE())
	      ,[TF_Actualizacion]			= GETDATE()
		  ,[TC_MensajeError]			= COALESCE(@L_MensajeError, TC_MensajeError)
		  ,[ID_NAUTIUS]					= COALESCE(@L_IdNautius, ID_NAUTIUS)
		  ,[TF_FechaEnvio]				= COALESCE(@L_FechaEnvio, TF_FechaEnvio)
	 WHERE TU_CodHistoricoItineracion	= @L_CodHistoricoItineracion
END


GO
