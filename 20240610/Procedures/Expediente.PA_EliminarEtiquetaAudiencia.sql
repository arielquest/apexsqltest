SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Aida E Siles>-- Fecha de creación:	<12/06/2020>-- Descripción:			<Permite eliminar un registro en la tabla: EtiquetaAudiencia.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[Expediente].[PA_EliminarEtiquetaAudiencia]	@CodEtiqueta				UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodEtiqueta				UNIQUEIDENTIFIER		= @CodEtiqueta	--Lógica	DELETE	FROM	Expediente.EtiquetaAudiencia	WITH (ROWLOCK)	WHERE	TU_CodEtiqueta					= @L_TU_CodEtiquetaEND
GO
