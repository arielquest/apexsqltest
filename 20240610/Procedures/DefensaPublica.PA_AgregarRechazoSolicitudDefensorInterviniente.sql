SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<09/03/2020>
-- Descripción:			<Permite agregar un registro en la tabla: RechazoSolicitudDefensorInterviniente.>
-- ==================================================================================================================================================================================
-- MOdificado por:      <Jose Gabriel Cordero Soto><27/03/2020><Se realiza ajuste en precision de parametro FechaCreacion a 3>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_AgregarRechazoSolicitudDefensorInterviniente]
	@CodSolicitudDefensor		UNIQUEIDENTIFIER,
	@CodInterviniente			UNIQUEIDENTIFIER,
	@CodTipoRechazoSolicitudDefensor		SMALLINT,
	@Observaciones				VARCHAR(100),
	@FechaCreacion				DATETIME2(3)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudDefensor		UNIQUEIDENTIFIER		= @CodSolicitudDefensor,
			@L_TU_CodInterviniente		UNIQUEIDENTIFIER		= @CodInterviniente,
			@L_TN_CodTipoRechazoSolicitudDefensor		SMALLINT		= @CodTipoRechazoSolicitudDefensor,
			@L_TC_Observaciones		VARCHAR(100)		= @Observaciones,
			@L_TF_FechaCreacion		DATETIME2(7)		= @FechaCreacion
	--Cuerpo
	INSERT INTO	DefensaPublica.RechazoSolicitudDefensorInterviniente	WITH (ROWLOCK)
	(
		TU_CodSolicitudDefensor,			TU_CodInterviniente,			TN_CodTipoRechazoSolicitudDefensor,			TC_Observaciones,				
		TF_FechaCreacion				
	)
	VALUES
	(
		@L_TU_CodSolicitudDefensor,			@L_TU_CodInterviniente,			@L_TN_CodTipoRechazoSolicitudDefensor,			@L_TC_Observaciones,			
		@L_TF_FechaCreacion				
	)
END
GO
