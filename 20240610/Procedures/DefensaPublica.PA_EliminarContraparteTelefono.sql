SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<07/01/2020>
-- Descripción:			<Permite eliminar un registro en la tabla: ContraparteTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_EliminarContraparteTelefono]
	@CodTelefono				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTelefono	UNIQUEIDENTIFIER	= @CodTelefono

	--Lógica
	DELETE
	FROM	DefensaPublica.ContraparteTelefono	WITH (ROWLOCK)
	WHERE	TU_CodTelefono						= @L_TU_CodTelefono
END
GO
