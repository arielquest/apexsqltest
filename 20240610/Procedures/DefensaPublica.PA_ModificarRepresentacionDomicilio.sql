SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E. Siles>
-- Fecha de creación:	<29/11/2019>
-- Descripción:			<Permite actualizar un registro en la tabla: RepresentacionDomicilio.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ModificarRepresentacionDomicilio]
	@TU_CodDomicilio			UNIQUEIDENTIFIER,	
	@TN_CodTipoDomicilio		SMALLINT,
	@TC_CodPais					VARCHAR(3),
	@TN_CodProvincia			SMALLINT,
	@TN_CodCanton				SMALLINT,
	@TN_CodDistrito				SMALLINT,
	@TN_CodBarrio				SMALLINT,
	@TC_Direccion				VARCHAR(500),
	@TB_Activo					BIT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodDomicilio			UNIQUEIDENTIFIER	= @TU_CodDomicilio,			
			@L_TN_CodTipoDomicilio		SMALLINT			= @TN_CodTipoDomicilio,
			@L_TC_CodPais				VARCHAR(3)			= @TC_CodPais,
			@L_TN_CodProvincia			SMALLINT			= @TN_CodProvincia,
			@L_TN_CodCanton				SMALLINT			= @TN_CodCanton,
			@L_TN_CodDistrito			SMALLINT			= @TN_CodDistrito,
			@L_TN_CodBarrio				SMALLINT			= @TN_CodBarrio,
			@L_TC_Direccion				VARCHAR(500)		= @TC_Direccion,
			@L_TB_Activo				BIT					= @TB_Activo
	--Lógica
	UPDATE	DefensaPublica.RepresentacionDomicilio	WITH (ROWLOCK)
	SET		TN_CodTipoDomicilio						= @L_TN_CodTipoDomicilio,
			TC_CodPais								= @L_TC_CodPais,
			TN_CodProvincia							= @L_TN_CodProvincia,
			TN_CodCanton							= @L_TN_CodCanton,
			TN_CodDistrito							= @L_TN_CodDistrito,
			TN_CodBarrio							= @L_TN_CodBarrio,
			TC_Direccion							= @L_TC_Direccion,
			TB_Activo								= @L_TB_Activo,
			TF_Actualizacion						= GETDATE()
	WHERE	TU_CodDomicilio							= @L_TU_CodDomicilio
END
GO
