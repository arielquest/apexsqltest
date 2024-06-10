SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<17/12/2019>
-- Descripción:			<Permite agregar un registro en la tabla: ContraparteTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_AgregarContraparteTelefono]
	@CodTelefono				UNIQUEIDENTIFIER,
	@CodTipoTelefono			SMALLINT,
	@CodContraparte				UNIQUEIDENTIFIER,
	@CodArea					VARCHAR(5),
	@Numero						VARCHAR(8),
	@Extension					VARCHAR(3),
	@SMS						BIT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTelefono			UNIQUEIDENTIFIER	= @CodTelefono,
			@L_TN_CodTipoTelefono		SMALLINT			= @CodTipoTelefono,
			@L_TU_CodContraparte		UNIQUEIDENTIFIER	= @CodContraparte,
			@L_TC_CodArea				VARCHAR(5)			= @CodArea,
			@L_TC_Numero				VARCHAR(8)			= @Numero,
			@L_TC_Extension				VARCHAR(3)			= @Extension,
			@L_TB_SMS					BIT					= @SMS			
	--Cuerpo
	INSERT INTO	DefensaPublica.ContraparteTelefono	WITH (ROWLOCK)
	(
		TU_CodTelefono,					TN_CodTipoTelefono,				TU_CodContraparte,				TC_CodArea,						
		TC_Numero,						TC_Extension,					TB_SMS,							TF_Actualizacion				
	)
	VALUES
	(
		@L_TU_CodTelefono,				@L_TN_CodTipoTelefono,			@L_TU_CodContraparte,			@L_TC_CodArea,					
		@L_TC_Numero,					@L_TC_Extension,				@L_TB_SMS,						GETDATE()				
	)
END
GO
