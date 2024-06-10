SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<20/04/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: ArchivoCarpeta.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_EliminarArchivoCarpeta]
(
	@CodArchivo							UNIQUEIDENTIFIER,	
	@NRD								VARCHAR(14)
)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER	= @CodArchivo,
			@L_TC_NRD					VARCHAR(14)			= @NRD

	--Lógica
	DELETE	
	FROM	DefensaPublica.ArchivoCarpeta	WITH (ROWLOCK)
	WHERE	TU_CodArchivo					= @L_TU_CodArchivo
	AND		TC_NRD							= @L_TC_NRD
END
GO
