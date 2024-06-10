SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<27/06/2019>
-- Descripción :			<Permite modificar un medio de comunicacion de un interviniente en un legajo.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarMedioComunicacionLegajo] 
	@CodMedioComunicacion			uniqueidentifier,
	@CodLegajo						uniqueidentifier, 
	@PrioridadLegajo				smallint

AS
BEGIN
    Update	Expediente.IntervencionMedioComunicacionLegajo
	Set		
			TN_PrioridadLegajo		= @PrioridadLegajo
	Where	TU_CodMedioComunicacion	= @CodMedioComunicacion
	AND		TU_CodLegajo			= @CodLegajo
END



GO
