SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Luis Alonso Leiva Tames>
-- Fecha de creación:	<21/03/2021>
-- Descripción:			<Permite modificar una prevención en la tabla: Prevencion.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarPrevencion]
	@Codigo					UNIQUEIDENTIFIER,
	@NumeroExpediente		varchar(14),
	@CodContexto			varchar(4),
	@CodInterviniente		UNIQUEIDENTIFIER,
	@CodTipoPrevencion		INT,
	@Monto					DECIMAL,
	@Activa					BIT,
	@Actualizacion			DATETIME2(7)
AS
BEGIN
	DECLARE
		@L_Codigo				UNIQUEIDENTIFIER	= @Codigo,
		@L_NumeroExpediente		varchar(14)			= @NumeroExpediente, 
		@L_CodContexto			varchar(4)			= @CodContexto,	 
		@L_CodInterviniente		UNIQUEIDENTIFIER	= @CodInterviniente, 
		@L_CodTipoPrevencion	INT					= @CodTipoPrevencion, 
		@L_Monto				DECIMAL				= @Monto, 
		@L_Activa				BIT					= @Activa, 
		@L_Actualizacion		DATETIME2(7)		= GETDATE()


	UPDATE Expediente.Prevencion	
	SET	 
		[TC_NumeroExpediente]	= @L_NumeroExpediente, 
		[TC_CodContexto]		= @L_CodContexto, 
		[TU_CodInterviniente]	= @L_CodInterviniente, 
		[TN_CodTipoPrevencion]	= @L_CodTipoPrevencion, 
		[TN_Monto]				= @L_Monto, 
		[TB_Activa]				= @L_Activa, 
		[TF_Actualizacion]		= @L_Actualizacion
	WHERE 
		TU_CodPrevencion = @L_Codigo

END



GO
