SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Miguel Avendaño Rosales>
-- Fecha de creación:	<18/10/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: EnvioCorreo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminarEnvioCorreo]
	@CodEnvioCorreo				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEnvioCorreo				UNIQUEIDENTIFIER		= @CodEnvioCorreo

	DELETE FROM Expediente.EnvioCorreo
	WHERE TU_CodEnvioCorreo	= @L_TU_CodEnvioCorreo
END
GO
