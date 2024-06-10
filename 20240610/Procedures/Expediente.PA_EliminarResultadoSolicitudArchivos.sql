SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Aida Elena Siles Rojas>-- Fecha de creación:	<05/11/2020>-- Descripción:			<Permite eliminar un registro en la tabla: ResultadoSolicitudArchivos.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[Expediente].[PA_EliminarResultadoSolicitudArchivos]	@CodResultadoSolicitud		UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodResultadoSolicitud		UNIQUEIDENTIFIER		= @CodResultadoSolicitud	--Lógica	DELETE	FROM	Expediente.ResultadoSolicitudArchivos	WITH (ROWLOCK)	WHERE	TU_CodResultadoSolicitud				= @L_TU_CodResultadoSolicitudEND
GO
