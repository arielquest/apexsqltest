SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<09/12/2019>
-- Descripción:			<Permite actualizar un registro en la tabla: RepresentacionTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ModificarRepresentacionTelefono]
	@TU_CodTelefono				UNIQUEIDENTIFIER,
	@TN_CodTipoTelefono			SMALLINT,
	@TC_CodArea					VARCHAR(5),
	@TC_Numero					VARCHAR(8),
	@TC_Extension				VARCHAR(3),
	@TB_SMS						BIT	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTelefono			UNIQUEIDENTIFIER	= @TU_CodTelefono,
			@L_TN_CodTipoTelefono		SMALLINT			= @TN_CodTipoTelefono,
			@L_TC_CodArea				VARCHAR(5)			= @TC_CodArea,
			@L_TC_Numero				VARCHAR(8)			= @TC_Numero,
			@L_TC_Extension				VARCHAR(3)			= @TC_Extension,
			@L_TB_SMS					BIT					= @TB_SMS			
	--Lógica
	UPDATE	DefensaPublica.RepresentacionTelefono	WITH (ROWLOCK)
	SET		TN_CodTipoTelefono						= @L_TN_CodTipoTelefono,
			TC_CodArea								= @L_TC_CodArea,
			TC_Numero								= @L_TC_Numero,
			TC_Extension							= @L_TC_Extension,
			TB_SMS									= @L_TB_SMS,			
			TF_Actualizacion						= GETDATE()
	WHERE	TU_CodTelefono							= @L_TU_CodTelefono
END
GO
