SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Menedez Chavarria>
-- Fecha de creación:		<22/11/2017>
-- Descripción:				<Permite agregar un registro a la tabla [Comunicacion].[IntentoComunicacion]> 
-- Modificación:            <Cristian Cerdas Camacho> <31/03/2020> <Se cambia el parámetro de entrada para que reciba el código del intento de envío>
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_AgregarIntentoComunicacion]
(		
	@CodigoIntento		 VARCHAR(100),
	@CodigoComunicacion  VARCHAR(100),
	@Observaciones		 VARCHAR(150) = Null,	
	@Positivo			 BIT,
	@FechaIntento		 DATETIME
)
AS
BEGIN
SET NOCOUNT ON;
		
		DECLARE @TempCodigoIntento		 VARCHAR(100)
		DECLARE @TempCodigoComunicacion  VARCHAR(100)
		DECLARE @TempObservaciones		 VARCHAR(150)
		DECLARE @TempPositivo			 BIT
		DECLARE @TempFechaIntento		 DATETIME

		SELECT @TempCodigoIntento		 = @CodigoIntento		
        SELECT @TempCodigoComunicacion 	 = @CodigoComunicacion 
		SELECT @TempObservaciones		 = @Observaciones		
		SELECT @TempPositivo			 = @Positivo			
		SELECT @TempFechaIntento		 = @FechaIntento	

	INSERT INTO	[Comunicacion].[IntentoComunicacion]
	(	
		[TU_CodIntento],		[TU_CodComunicacion] ,		[TC_Observaciones],		[TF_FechaIntento],
		[TC_UsuarioRed],		[TB_Positivo],				[TC_NombreRecibe],		[TI_FirmaDestinatario],
		[TC_NombreTestigo],		[TG_UbicacionPuntoVisita]
	)
	Values
	(
		@TempCodigoIntento ,				@TempCodigoComunicacion,		@TempObservaciones,			@TempFechaIntento,
		Null,					@TempPositivo,					Null,					Null,
		Null,					Null
	)
END
GO
