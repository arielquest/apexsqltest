SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<15/07/2019>
-- Descripción :			<Permite eliminar un Medio de Comunicacion del interviniente en un legajo.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarIntervencionMedioComunicacionLegajo] 
	@CodMedioComunicacion	uniqueidentifier,
	@CodLegajo				uniqueidentifier
AS
BEGIN
	DELETE	
	FROM			Expediente.IntervencionMedioComunicacionLegajo
	WHERE			TU_CodMedioComunicacion							=	@CodMedioComunicacion
	AND				TU_CodLegajo									=	@CodLegajo	
END
GO
