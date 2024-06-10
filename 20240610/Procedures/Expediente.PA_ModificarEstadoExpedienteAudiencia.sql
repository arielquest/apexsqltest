SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Daniel Ruiz Hernández>
-- Fecha creación:	<05/02/2020>
-- Descripción :	<Permite modificar el estado de una audiencia.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarEstadoExpedienteAudiencia]
	@TN_CodAudiencia bigint,
	@TC_Estado char(1)
AS
BEGIN
	UPDATE	[Expediente].[Audiencia]
	SET		[TC_Estado]					= @TC_Estado
	WHERE	[TN_CodAudiencia]			= @TN_CodAudiencia
END
GO
