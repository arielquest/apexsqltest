SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Oscar Sanchez H>
-- Fecha de creación:	<12/08/2022>
-- Descripción:			<Permite eliminar un registro en la tabla: ResultadoRecursoEscrito.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_EliminarResultadoRecursoEscrito]
	@CodResultadoRecurso		UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER	= @CodResultadoRecurso

	--Lógica
	DELETE
	FROM	Expediente.ResultadoRecursoEscrito	WITH (ROWLOCK)
	WHERE	TU_CodResultadoRecurso		= @L_TU_CodResultadoRecurso
END
GO
