SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Aida Elena Siles Rojas>-- Fecha de creación:	<30/10/2020>-- Descripción:			<Permite eliminar un registro en la tabla: ResultadoRecursosArchivos.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[Expediente].[PA_EliminarResultadoRecursosArchivos]	@CodResultadoRecurso		UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodResultadoRecurso		UNIQUEIDENTIFIER	= @CodResultadoRecurso	--Lógica	DELETE	FROM	Expediente.ResultadoRecursosArchivos	WITH (ROWLOCK)	WHERE	TU_CodResultadoRecurso		= @L_TU_CodResultadoRecursoEND
GO
