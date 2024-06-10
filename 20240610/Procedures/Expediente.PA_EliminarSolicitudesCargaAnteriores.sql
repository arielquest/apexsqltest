SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:		Isaac Dobles Mata
-- Create date: 21/02/2023
-- Description:	Elimina las solicitudes de carga previas del usuario por contexto, excepto la que se está procesando actualmente
-- ====================================================================================================================================================================================

-- ====================================================================================================================================================================================
CREATE     PROCEDURE [Expediente].[PA_EliminarSolicitudesCargaAnteriores]
	@CodigoSolicitud	BIGINT,
	@Usuario			VARCHAR(30),
	@CodigoContexto		VARCHAR(4)
AS
BEGIN
		--Variables
		DECLARE 
		@L_CodSolicitud			BIGINT				=   @CodigoSolicitud,
		@L_Usuario				VARCHAR(30)			=	@Usuario,
		@L_CodigoContexto		VARCHAR(4)			=	@CodigoContexto

		--SE OBTIENE SOLICITUDES DEL USUARIO Y CONTEXTO DISTINTAS A LA ACTUAL
		DECLARE	@SolicitudesAnteriores TABLE
		(
			CodigoSolicitud			CHAR(14)
		);

		INSERT 
		INTO		@SolicitudesAnteriores
		SELECT		[TN_CodSolicitud]	
		FROM		[Expediente].[SolicitudCargaInactivo]
		WHERE		[TC_UsuarioRed]					=	@L_Usuario
		AND			[TC_CodContexto]				=	@L_CodigoContexto
		AND			[TN_CodSolicitud]				<>	@L_CodSolicitud

		--SE ELIMINA DETALLE PRIMERO
		DELETE FROM 
		[Expediente].[DetalleDepuracionInactivo]
		WHERE [TN_CodSolicitud] IN
		(
			SELECT	CodigoSolicitud
			FROM	@SolicitudesAnteriores
		)

		--SE ELIMINA MAESTRO
		DELETE FROM 
		[Expediente].[SolicitudCargaInactivo]
		WHERE [TN_CodSolicitud] IN
		(
			SELECT	CodigoSolicitud
			FROM	@SolicitudesAnteriores
		)

END
GO
