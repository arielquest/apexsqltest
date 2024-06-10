SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa>
-- Fecha de creación:		<24/05/2021>
-- Descripción:				<<Eliminar las observaciones de un legajo o expediente> 
-- =======================================================================================================================
CREATE PROCEDURE [Expediente].[PA_EliminnarObservacionExpedieteLegajo]
(
@CodObservacionExpedienteLegajo uniqueidentifier
)
AS
DECLARE @L_CodObservacionExpedienteLegajo AS uniqueidentifier=@CodObservacionExpedienteLegajo; 
BEGIN
		DELETE Expediente.ObservacionExpedienteLegajo
		WHERE TU_CodObservacionExpedienteLegajo	 = @L_CodObservacionExpedienteLegajo
END
GO
