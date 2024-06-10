SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<04/03/2020>
-- Descripción :			<Permite agregar el estado de la solicitud de defensor para un interviniente.> 
-- Modificación:			<20/03/2020> <Aida E Siles> Se agregan las variables locales. Observación revisión par.
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarEstadoSolicitudInterviniente]
	@CodSolicitudDefensor			UNIQUEIDENTIFIER,
	@CodInterviniente				UNIQUEIDENTIFIER,
	@EstadoSolicitudInterviniente	CHAR(1)
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudDefensor			UNIQUEIDENTIFIER	=	@CodSolicitudDefensor,
			@L_TU_CodInterviniente				UNIQUEIDENTIFIER	=	@CodInterviniente,
			@L_TC_EstadoSolicitudInterviniente	CHAR(1)				=	@EstadoSolicitudInterviniente
    --Lógica
	UPDATE	Expediente.SolicitudDefensorInterviniente
	SET		TC_EstadoSolicitudInterviniente				=	@L_TC_EstadoSolicitudInterviniente
	WHERE	TU_CodSolicitudDefensor						=	@L_TU_CodSolicitudDefensor
	AND		TU_CodInterviniente							=	@L_TU_CodInterviniente
END
GO
