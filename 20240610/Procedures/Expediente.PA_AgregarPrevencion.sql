SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Luis Alonso Leiva Tames>
-- Fecha de creación:	<21/03/2021>
-- Descripción:			<Permite agregar una prevención en la tabla: Prevencion.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarPrevencion]
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
		@L_NumeroExpediente		varchar(14)			= @NumeroExpediente, 
		@L_CodContexto			varchar(4)			= @CodContexto,	 
		@L_CodInterviniente		UNIQUEIDENTIFIER	= @CodInterviniente, 
		@L_CodTipoPrevencion	INT					= @CodTipoPrevencion, 
		@L_Monto				DECIMAL				= @Monto, 
		@L_Activa				BIT					= @Activa, 
		@L_Actualizacion		DATETIME2(7)		= GETDATE()


	INSERT INTO Expediente.Prevencion	
	(	 
		[TU_CodPrevencion],
		[TC_NumeroExpediente], 
		[TC_CodContexto], 
		[TU_CodInterviniente], 
		[TN_CodTipoPrevencion], 
		[TN_Monto], 
		[TB_Activa], 
		[TF_Actualizacion]
	)
	VALUES
	(
		NEWID(),
		@L_NumeroExpediente,
		@L_CodContexto,
		@L_CodInterviniente,
		@L_CodTipoPrevencion,
		@L_Monto,
		@L_Activa,
		@L_Actualizacion
	);

END



GO
