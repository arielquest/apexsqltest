SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<12/12/2019>
-- Descripción:			<Permite agregar un registro en la tabla: ContraparteDomicilio.>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[DefensaPublica].[PA_AgregarContraparteDomicilio]
	@CodDomicilio			UNIQUEIDENTIFIER,
	@CodContraparte			UNIQUEIDENTIFIER,
	@CodTipoDomicilio		SMALLINT,
	@CodPais				VARCHAR(3),
	@CodProvincia			SMALLINT,
	@CodCanton				SMALLINT,
	@CodDistrito			SMALLINT,
	@CodBarrio				SMALLINT,
	@Direccion				VARCHAR(500),
	@Activo					BIT	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodDomicilio			UNIQUEIDENTIFIER	= @CodDomicilio,
			@L_TU_CodContraparte		UNIQUEIDENTIFIER	= @CodContraparte,
			@L_TN_CodTipoDomicilio		SMALLINT			= @CodTipoDomicilio,
			@L_TC_CodPais				VARCHAR(3)			= @CodPais,
			@L_TN_CodProvincia			SMALLINT			= @CodProvincia,
			@L_TN_CodCanton				SMALLINT			= @CodCanton,
			@L_TN_CodDistrito			SMALLINT			= @CodDistrito,
			@L_TN_CodBarrio				SMALLINT			= @CodBarrio,
			@L_TC_Direccion				VARCHAR(500)		= @Direccion,
			@L_TB_Activo				BIT					= @Activo			
	--Cuerpo
	INSERT INTO	DefensaPublica.ContraparteDomicilio	WITH (ROWLOCK)
	(
		TU_CodDomicilio,				TU_CodContraparte,				TN_CodTipoDomicilio,			TC_CodPais,						
		TN_CodProvincia,				TN_CodCanton,					TN_CodDistrito,					TN_CodBarrio,					
		TC_Direccion,					TB_Activo,						TF_Actualizacion				
	)
	VALUES
	(
		@L_TU_CodDomicilio,				@L_TU_CodContraparte,			@L_TN_CodTipoDomicilio,			@L_TC_CodPais,					
		@L_TN_CodProvincia,				@L_TN_CodCanton,				@L_TN_CodDistrito,				@L_TN_CodBarrio,				
		@L_TC_Direccion,				@L_TB_Activo,					GETDATE()				
	)
END
GO
