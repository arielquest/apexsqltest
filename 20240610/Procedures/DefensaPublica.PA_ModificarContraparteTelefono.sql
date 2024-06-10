SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<06/01/2020>
-- Descripción:			<Permite actualizar un registro en la tabla: ContraparteTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ModificarContraparteTelefono]
	@CodTelefono				UNIQUEIDENTIFIER,
	@CodTipoTelefono			SMALLINT,	
	@CodArea					VARCHAR(5),
	@Numero						VARCHAR(8),
	@Extension					VARCHAR(3),
	@SMS						BIT	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTelefono			UNIQUEIDENTIFIER	= @CodTelefono,
			@L_TN_CodTipoTelefono		SMALLINT			= @CodTipoTelefono,			
			@L_TC_CodArea				VARCHAR(5)			= @CodArea,
			@L_TC_Numero				VARCHAR(8)			= @Numero,
			@L_TC_Extension				VARCHAR(3)			= @Extension,
			@L_TB_SMS					BIT					= @SMS			
	--Lógica
	UPDATE	DefensaPublica.ContraparteTelefono	WITH (ROWLOCK)
	SET		TN_CodTipoTelefono					= @L_TN_CodTipoTelefono,			
			TC_CodArea							= @L_TC_CodArea,
			TC_Numero							= @L_TC_Numero,
			TC_Extension						= @L_TC_Extension,
			TB_SMS								= @L_TB_SMS,
			TF_Actualizacion					= GETDATE()
	WHERE	TU_CodTelefono						= @L_TU_CodTelefono
END
GO
