SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<06/10/2021>
-- Descripción:			<Permite agregar un registro en la tabla: EnvioCorreoDocumento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarEnvioCorreoDocumento]
	@CodEnvioCorreo				UNIQUEIDENTIFIER,
	@CodArchivo					UNIQUEIDENTIFIER,
	@Tamanio					BIGINT				= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEnvioCorreo		UNIQUEIDENTIFIER		= @CodEnvioCorreo,
			@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo,
			@L_TN_Tamanio				BIGINT					= @Tamanio
	
	--Cuerpo
	INSERT INTO	Expediente.EnvioCorreoDocumento	WITH (ROWLOCK)
	(
		TU_CodEnvioCorreo,		TU_CodArchivo,		TN_Tamanio						
	)
	VALUES
	(
		@L_TU_CodEnvioCorreo,	@L_TU_CodArchivo,	@L_TN_Tamanio					
	)
END
GO
