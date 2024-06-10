SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<26/01/2021>
-- Descripción :			<Permite actualizar un registro en la tabla MESSAGES de itineraciones SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<03/02/2021><Karol Jiménez S.> <Se agregan campos adicionales para rechazo, y se pone que los demás acepten nulos, y actualicen solo si están llenos>
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<24/05/2021><Jonathan Aguilar Navarro> <Se agrega el campo ERRORDESCRIPTION para que se visualice en el detalle de "Ver itineración">
-- Modificación:			<07/06/2021><Ronny Ramírez R.> <Se aplica corrección a parámetros @L_ERRORDESCRIPTION y @L_HASERROR que estaban al contrario en el update>
-- Modificación:			<24/06/2021><Jonathan Aguilar Navarro><Se agrega al update el valor TIMEERROR>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ActualizarMensajeItineracion]
	@ID					VARCHAR(36),	
	@ISPENDING 			BIT					NULL,	
	@ISACCEPTED			BIT					NULL,
	@ISDELETED			BIT					NULL,
	@TIMEDELETED		DATETIME			NULL,
	@ISREADED			BIT					NULL,
	@TIMEREADED			DATETIME			NULL,
	@HASERROR			BIT					NULL,
	@ERRORDESCRIPTION	VARCHAR(255)		NULL,
	@ISINCOMING			BIT					NULL,
	@ISRECEIVED			BIT					NULL,		
	@ISREFUSED			BIT					NULL,	
	@REFUSEDBY			VARCHAR(255)		NULL	

AS 

BEGIN

	--Variables
	DECLARE @L_ID 					VARCHAR(36)			= @ID, 	
			@L_ISPENDING 			BIT					= @ISPENDING, 	
			@L_ISACCEPTED			BIT					= @ISACCEPTED,	
			@L_ISDELETED			BIT					= @ISDELETED,	
			@L_TIMEDELETED			DATETIME			= @TIMEDELETED,
			@L_ISREADED				BIT					= @ISREADED,	
			@L_TIMEREADED			DATETIME			= @TIMEREADED,	
			@L_HASERROR				BIT					= @HASERROR,	
			@L_ERRORDESCRIPTION		VARCHAR(255)		= @ERRORDESCRIPTION,
			@L_TIMEERROR			DATETIME			= NULL,
			@L_ISINCOMING			BIT					= @ISINCOMING,		
			@L_ISRECEIVED			BIT					= @ISRECEIVED,	
			@L_ISREFUSED			BIT					= @ISREFUSED,	
			@L_REFUSEDBY			VARCHAR(255)		= @REFUSEDBY

	--Cuerpo
	IF @L_HASERROR = 1
	begin 
		SET @L_TIMEERROR = GETDATE()
	end

	UPDATE	ItineracionesSIAGPJ.dbo.MESSAGES
	SET		ISPENDING 			=	ISNULL(@L_ISPENDING, ISPENDING), 	
			ISACCEPTED			=	ISNULL(@L_ISACCEPTED, ISACCEPTED),	
			ISDELETED			=	ISNULL(@L_ISDELETED, ISDELETED),	
			TIMEDELETED			=	ISNULL(@L_TIMEDELETED, TIMEDELETED),	
			ISREADED			=	ISNULL(@L_ISREADED, ISREADED),	
			TIMEREADED			=	ISNULL(@L_TIMEREADED, TIMEREADED),	
			ERRORDESCRIPTION	=	ISNULL(@L_ERRORDESCRIPTION, ERRORDESCRIPTION),	
			TIMEERROR			=   ISNULL(@L_TIMEERROR,TIMEERROR),
			HASERROR			=	ISNULL(@L_HASERROR, HASERROR),	
			ISINCOMING			=	ISNULL(@L_ISINCOMING, ISINCOMING),	
			ISRECEIVED			=	ISNULL(@L_ISRECEIVED, ISRECEIVED),	
			ISREFUSED			=	ISNULL(@L_ISREFUSED, ISREFUSED),	
			REFUSEDBY			=	ISNULL(@L_REFUSEDBY, REFUSEDBY)	
	WHERE	ID					= 	@L_ID	

END
GO
