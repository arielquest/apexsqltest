SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

  -- ======================================================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creaci¢n:		<10/06/2020>
-- Descripci¢n :			<Agrega un resgitro en el historico de itineraci¢n para el expediente indicado>  
-- ======================================================================================================================================================
-- Modificaci¢n:			<Aida Elena Siles Rojas> <21/07/2020> <Se cambia el nombre de la tabla ExpedienteItineracion por Itineracion>
-- Modificaci¢n:			<Aida Elena Siles Rojas> <23/07/2020> <Se cambia el nombre del campo TC_EstadoItineracion por TN_CodEstadoItineracion>
-- Modificaci¢n:			<Jonathan Aguilar Navarro> <16/09/2020> <Se agrega el par metro "MensajError">
-- Modificaci¢n:			<Jonathan Aguilar Navarro> <03/03/2021> <Se agrega el parametro de CARPETA> 	
-- Modificaci¢n:			<Jonathan Aguilar Navarro> <23/04/2021> <Se agrega el parametro de CodigoHistoricoItineracionPadre> 	
-- Modificaci¢n:			<Ronny Ram¡rez R.> <24/08/2021> <Se agrega el par metro IdNaitius para identificar las itineraciones recibidas desde Gesti¢n> 	
-- Modificaci¢n:			<Ronny Ram¡rez R.> <30/08/2021> <Se agregan nuevos campos de la tabla Historico.Itineracion para mantener los datos del
--							hist¢rico luego de un rechazo.> 
-- ======================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarHistoricoItineracion]
	@CodItineracion					uniqueidentifier,
	@NumeroExpediente				varchar(14),
	@CodTipoItineracion				smallint,
	@CodContextoOrigen				char(4),
	@CodContextoDestino				varchar(4),
	@UsuarioRed						varchar(30),
	@EstadoItineracion				smallint,
	@MensajeError					varchar(255),
	@CARPETA						varchar(14),
	@CodHistoricoItineracionPadre	uniqueidentifier,
	@IdNautius						varchar(255) 		= NULL,
	@CodRegistroItineracion			uniqueidentifier 	= NULL,
	@FechaEnvio 					datetime2(3) 		= NULL,
	@CodMotivoItineracion 			smallint 			= NULL
	
AS  
BEGIN 

	DECLARE @L_CodItineracion				uniqueidentifier	= @CodItineracion,
			@L_NumeroExpediente				varchar(14)			= @NumeroExpediente,
			@L_CodTipoItineracion			smallint			= @CodTipoItineracion,
			@L_CodContextoOrigen			char(4)				= @CodContextoOrigen,
			@L_CodContextoDestino			varchar(4)			= @CodContextoDestino,
			@L_UsuarioRed					varchar(30)			= @UsuarioRed,
			@L_EstadoItineracion			smallint			= @EstadoItineracion,
			@L_MensajeError					varchar(255)		= @CARPETA,
			@L_CARPETA						varchar(14)			= @MensajeError,
			@L_CodHistoricoItineracionPadre	uniqueidentifier	= @CodHistoricoItineracionPadre,
			@L_CodHistoricoItineracion		uniqueidentifier	= NEWID(),
			@L_IdNautius					uniqueidentifier	= @IdNautius,
			@L_CodRegistroItineracion		uniqueidentifier	= @CodRegistroItineracion,
			@L_FechaEnvio					datetime2(3)		= @FechaEnvio,
			@L_CodMotivoItineracion			smallint			= @CodMotivoItineracion

	INSERT INTO [Historico].[Itineracion] WITH(ROWLOCK)
	(
		 [TU_CodItineracion] 
		,[TC_NumeroExpediente] 
		,[TU_CodHistoricoItineracion]
		,[TN_CodTipoItineracion]
		,[TC_CodContextoOrigen]
		,[TC_CodContextoDestino]
		,[TC_UsuarioRed]
		,[TN_CodEstadoItineracion]
		,[TF_FechaEstado]
		,[TC_MensajeError]
		,[CARPETA]
		,[TU_CodHistoricoItineracionPadre]
		,[ID_NAUTIUS]
		,[TU_CodRegistroItineracion]
		,[TF_FechaEnvio]
		,[TN_CodMotivoItineracion]
	)
	VALUES
	(
		 @L_CodItineracion
		,@L_NumeroExpediente
		,@L_CodHistoricoItineracion
		,@L_CodTipoItineracion
		,@L_CodContextoOrigen
		,@L_CodContextoDestino
		,@L_UsuarioRed
		,@L_EstadoItineracion
		,GETDATE()
		,@L_MensajeError
		,@L_CARPETA
		,@L_CodHistoricoItineracionPadre
		,@L_IdNautius
		,@L_CodRegistroItineracion
		,@L_FechaEnvio
		,@L_CodMotivoItineracion
	)

	SELECT @L_CodHistoricoItineracion

END
GO
