SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<10/12/2019>
-- Descripción:			<Permite eliminar un registro en la tabla: RepresentacionTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_EliminarRepresentacionTelefono]
	@CodTelefono						UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodTelefono			UNIQUEIDENTIFIER		= @CodTelefono

	--Lógica
	DELETE
	FROM	DefensaPublica.RepresentacionTelefono	WITH (ROWLOCK)
	WHERE	TU_CodTelefono							= @L_TU_CodTelefono
END
GO
