SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<18/12/2019>
-- Descripción:			<Permite actualizar un registro en la tabla: ContraparteDomicilio.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ModificarContraparteDomicilio]
	@CodDomicilio				UNIQUEIDENTIFIER,	
	@CodTipoDomicilio			SMALLINT,
	@CodPais					VARCHAR(3),
	@CodProvincia				SMALLINT,
	@CodCanton					SMALLINT,
	@CodDistrito				SMALLINT,
	@CodBarrio					SMALLINT,
	@Direccion					VARCHAR(500),
	@Activo						BIT	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodDomicilio			UNIQUEIDENTIFIER	= @CodDomicilio,			
			@L_TN_CodTipoDomicilio		SMALLINT			= @CodTipoDomicilio,
			@L_TC_CodPais				VARCHAR(3)			= @CodPais,
			@L_TN_CodProvincia			SMALLINT			= @CodProvincia,
			@L_TN_CodCanton				SMALLINT			= @CodCanton,
			@L_TN_CodDistrito			SMALLINT			= @CodDistrito,
			@L_TN_CodBarrio				SMALLINT			= @CodBarrio,
			@L_TC_Direccion				VARCHAR(500)		= @Direccion,
			@L_TB_Activo				BIT					= @Activo			
	--Lógica
	UPDATE	DefensaPublica.ContraparteDomicilio	WITH (ROWLOCK)
	SET		TN_CodTipoDomicilio					= @L_TN_CodTipoDomicilio,
			TC_CodPais							= @L_TC_CodPais,
			TN_CodProvincia						= @L_TN_CodProvincia,
			TN_CodCanton						= @L_TN_CodCanton,
			TN_CodDistrito						= @L_TN_CodDistrito,
			TN_CodBarrio						= @L_TN_CodBarrio,
			TC_Direccion						= @L_TC_Direccion,
			TB_Activo							= @L_TB_Activo,
			TF_Actualizacion					= GETDATE()
	WHERE	TU_CodDomicilio						= @L_TU_CodDomicilio
END
GO
