SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<09/12/2019>
-- Descripción:			<Permite actualizar un registro en la tabla: Objeto.>
-- ==================================================================================================================================================================================
-- Modificación:		<16/01/2020> <Ronny Ramírez R.> <Se agrega el campo TF_Actualizacion para cumplir con el requerimiento de SIGMA, para registrar última actualización >
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarObjeto]
	@Codigo					UNIQUEIDENTIFIER,
	@Descripcion			VARCHAR(255),
	@Observacion			VARCHAR(500),
	@Marca					VARCHAR(255),
	@Modelo					VARCHAR(255),
	@Serie					VARCHAR(255),
	@Color					VARCHAR(50),
	@Peritaje				BIT,
	@CodMoneda				SMALLINT,
	@Valor					DECIMAL,
	@Ley					BIT
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER	= @Codigo,
			@L_TC_Descripcion			VARCHAR(255)		= @Descripcion,
			@L_TC_Observacion			VARCHAR(500)		= @Observacion,
			@L_TC_Marca					VARCHAR(255)		= @Marca,
			@L_TC_Modelo				VARCHAR(255)		= @Modelo,
			@L_TC_Serie					VARCHAR(255)		= @Serie,
			@L_TC_Color					VARCHAR(50)			= @Color,
			@L_TB_Peritaje				BIT					= @Peritaje,
			@L_TN_CodMoneda				SMALLINT			= @CodMoneda,
			@L_TN_Valor					DECIMAL				= @Valor,		
			@L_TB_Ley					BIT					= @Ley
	--Lógica
	UPDATE	Objeto.Objeto				WITH (ROWLOCK)
	SET		TC_Descripcion				= @L_TC_Descripcion,
			TC_Observacion				= @L_TC_Observacion,
			TC_Marca					= @L_TC_Marca,
			TC_Modelo					= @L_TC_Modelo,
			TC_Serie					= @L_TC_Serie,
			TC_Color					= @L_TC_Color,
			TB_Peritaje					= @L_TB_Peritaje,
			TN_CodMoneda				= @L_TN_CodMoneda,
			TN_Valor					= @L_TN_Valor,		
			TB_Ley						= @L_TB_Ley,			
			TF_Actualizacion			= GETDATE()
	WHERE	TU_CodObjeto				= @L_TU_CodObjeto
END
GO
