SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<20/11/2019>
-- Descripción:			<Permite agregar un registro en la tabla: RepresentacionDomicilio.>
-- Modificación:		<22/11/2019> <Aida E Siles> <Se agregan campos faltantes>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[DefensaPublica].[PA_AgregarRepresentacionDomicilio]
	@TU_CodDomicilio			UNIQUEIDENTIFIER,
	@TU_CodRepresentacion		UNIQUEIDENTIFIER,
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
			@L_TU_CodRepresentacion		UNIQUEIDENTIFIER	= @TU_CodRepresentacion,
			@L_TN_CodTipoDomicilio		SMALLINT			= @TN_CodTipoDomicilio,
			@L_TC_CodPais				VARCHAR(3)			= @TC_CodPais,
			@L_TN_CodProvincia			SMALLINT			= @TN_CodProvincia,
			@L_TN_CodCanton				SMALLINT			= @TN_CodCanton,
			@L_TN_CodDistrito			SMALLINT			= @TN_CodDistrito,
			@L_TN_CodBarrio				SMALLINT			= @TN_CodBarrio,
			@L_TC_Direccion				VARCHAR(500)		= @TC_Direccion,
			@L_TB_Activo				BIT					= @TB_Activo			
	--Cuerpo
	INSERT INTO	DefensaPublica.RepresentacionDomicilio	WITH (ROWLOCK)
	(
		TU_CodDomicilio,				TU_CodRepresentacion,			TN_CodTipoDomicilio,			TC_CodPais,						
		TN_CodProvincia,				TN_CodCanton,					TN_CodDistrito,					TN_CodBarrio,					
		TC_Direccion,					TB_Activo,						TF_Actualizacion				
	)
	VALUES
	(
		@L_TU_CodDomicilio,				@L_TU_CodRepresentacion,		@L_TN_CodTipoDomicilio,			@L_TC_CodPais,					
		@L_TN_CodProvincia,				@L_TN_CodCanton,				@L_TN_CodDistrito,				@L_TN_CodBarrio,				
		@L_TC_Direccion,				@L_TB_Activo,					GETDATE()				
	)
END
GO
