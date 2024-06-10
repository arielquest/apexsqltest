SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Miguel Avendaño Rosales>
-- Fecha de creación:	<18/10/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: EnvioCorreoDocumento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarEnvioCorreoDocumento]
	@CodEnvioCorreo				UNIQUEIDENTIFIER	= NULL,
	@CodArchivo					UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEnvioCorreo				UNIQUEIDENTIFIER		= @CodEnvioCorreo,
			@L_TU_CodArchivo					UNIQUEIDENTIFIER		= @CodArchivo

	IF (@L_TU_CodEnvioCorreo IS NULL)
	BEGIN
		DELETE FROM Expediente.EnvioCorreoDocumento
		WHERE TU_CodArchivo	= @L_TU_CodArchivo
	END

	IF (@L_TU_CodArchivo IS NULL)
	BEGIN
		DELETE FROM Expediente.EnvioCorreoDocumento
		WHERE TU_CodEnvioCorreo	= @L_TU_CodEnvioCorreo
	END
END
GO
