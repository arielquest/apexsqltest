SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<14/02/2020>
-- Descripción:			<Permite agregar un registro en la tabla: IntervencionesSolicitud.>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><20/04/2020><Se ajusta nombramiento de parametros recibidos para coincidir con nombre en campo de tabla, objetivo seguir el estandar>
-- =================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_AgregarIntervencionSolicitud]
	@CodSolicitudExpediente		UNIQUEIDENTIFIER,
	@CodInterviniente			UNIQUEIDENTIFIER

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodSolicitudExpediente		UNIQUEIDENTIFIER		= @CodSolicitudExpediente,
			@L_TU_CodInterviniente				UNIQUEIDENTIFIER		= @CodInterviniente
	
	--Cuerpo
	INSERT INTO	Expediente.IntervencionSolicitud	WITH (ROWLOCK)
	(
		TU_CodSolicitudExpediente,			TU_CodInterviniente				
	)
	VALUES
	(
		@L_TU_CodSolicitudExpediente,			@L_TU_CodInterviniente			
	)
END
GO
