SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Aida E Siles>-- Fecha de creación:	<25/05/2020>-- Descripción:			<Permite eliminar un registro en la tabla: IntervencionArchivo.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[Expediente].[PA_EliminarIntervencionArchivo]	@CodArchivo					UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo	--Lógica	DELETE	FROM	Expediente.IntervencionArchivo	WITH (ROWLOCK)	WHERE	TU_CodArchivo					= @L_TU_CodArchivoEND
GO
