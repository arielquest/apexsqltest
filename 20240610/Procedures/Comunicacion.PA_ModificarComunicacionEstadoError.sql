SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--===================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<03/03/2023>
-- Descripción:				<Actualiza los campos TC_Estado, TC_MensajeError y TC_MensajeUsuario de una notificación con error.
--===================================================================================================================================

CREATE     PROCEDURE [Comunicacion].[PA_ModificarComunicacionEstadoError]
(
	@TU_CodComunicacion		VARCHAR(36),
	@TC_Estado				CHAR(1),
	@TC_MensajeError		VARCHAR(MAX),
	@TC_MensajeUsuario		VARCHAR(MAX)
)
AS
	DECLARE @L_TU_CodComunicacion		AS UNIQUEIDENTIFIER	=			CONVERT(UNIQUEIDENTIFIER,@TU_CodComunicacion); 
	DECLARE @L_TC_Estado				AS CHAR(1)					=	@TC_Estado; 
	DECLARE @L_TC_MensajeError			AS VARCHAR(MAX)				=	@TC_MensajeError; 
	DECLARE @L_TC_MensajeUsuario		AS VARCHAR(MAX)				=	@TC_MensajeUsuario;
BEGIN

	UPDATE		Comunicacion.Comunicacion
	SET			TC_Estado			=	@L_TC_Estado,
				TC_MensajeError		=	@L_TC_MensajeError,
				TC_MensajeUsuario	=	@L_TC_MensajeUsuario
	WHERE		TU_CodComunicacion	=	@L_TU_CodComunicacion

END
GO
