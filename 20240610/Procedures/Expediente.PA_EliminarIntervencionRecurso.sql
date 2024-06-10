SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<19/02/2020>
-- Descripción:			<Permite eliminar un registro en la tabla: IntervencionRecurso.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_EliminarIntervencionRecurso]

	@CodRecurso					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodRecurso			UNIQUEIDENTIFIER		= @CodRecurso

	--Lógica
	DELETE
	FROM	Expediente.IntervencionRecurso	WITH (ROWLOCK)
	WHERE	TU_CodRecurso				= @L_TU_CodRecurso
END
GO
