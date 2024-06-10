SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versi¢n:			<1.0>
-- Creado por:		<Aar¢n R¡os Retana>
-- Fecha creaci¢n:	<07/07/2021>
-- Descripci¢n :	<ME0045-2021: Permite modificar el estado de publicaci¢n de una audiencia.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarEstadoPublicacionExpedienteAudiencia]
	@TN_CodAudiencia bigint,
	@TC_EstadoPublicacion char(1)
AS
BEGIN
--Variables
	Declare @L_CodAudiencia bigint = @TN_CodAudiencia,
	@L_EstadoPublicacion char(1) = @TC_EstadoPublicacion
--L¢gica
	UPDATE	[Expediente].[Audiencia]
	SET		[TN_EstadoPublicacion]		= @L_EstadoPublicacion
	WHERE	[TN_CodAudiencia]			= @L_CodAudiencia
END
GO
