SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<16/11/2018>
-- Descripción :		<Permite actualizar el registro de una solicitud de desacumulación, elimina la relación de archivos e intervenciiones> 
-- ==============================================================================================================================================================================
-- Modificación:		<Jonathan Aguilar Navarro> <04/10/2019> <Se agrega tipo de descumulación a modificar>
-- Modificación:		<Aida Elena Siles Rojas> <14/10/2020> <Se agrega lógica para el manejo de las audiencias en la solicitud de desacumulación>
-- Modificación:		<Aida Elena Siles Rojas> <28/10/2020> <Ajuste en el tipo de dato de los parámetros fechas se pasa a DATETIME2(7) por observación de Fabian Sequeira>
-- Modificación:		<Daniel Ruiz Hernández> <18/12/2020> <Se agrega la actualización del codigo de la fase.>
-- ==============================================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ModificarSolicitudDesacumulacion]
	@CodSolicitud			UNIQUEIDENTIFIER,
	@EstadoSolicitud		CHAR(1),
	@NumeroExpediente		VARCHAR(14),
	@UsuarioRed				VARCHAR(30),
	@FechaSolicitud			DATETIME2(7),
	@FechaActualizacion		DATETIME2(7),
	@PuestoTrabajoAsignado	VARCHAR(14),
	@AsignadoPor			VARCHAR(14),
	@Observaciones			VARCHAR(255),
	@TipoDesacumulacion		CHAR(1),
	@CodFase				SMALLINT
AS
BEGIN
--Variables
	DECLARE	
	@L_CodSolicitud				UNIQUEIDENTIFIER	= @CodSolicitud,
	@L_EstadoSolicitud			CHAR				= @EstadoSolicitud,
	@L_NumeroExpediente			VARCHAR(14)			= @NumeroExpediente,
	@L_UsuarioRed				VARCHAR(30)			= @UsuarioRed,
	@L_FechaSolicitud			DATETIME2			= @FechaSolicitud,
	@L_FechaActualizacion		DATETIME2			= @FechaActualizacion,
	@L_PuestoTrabajoAsignado	VARCHAR(14)			= @PuestoTrabajoAsignado,
	@L_AsignadoPor				VARCHAR(14)			= @AsignadoPor,
	@L_Observaciones			VARCHAR(255)		= @Observaciones,
	@L_TipoDesacumulacion		CHAR(1)				= @TipoDesacumulacion,
	@L_CodFase					SMALLINT			= @CodFase
--Lógica
	BEGIN TRY
		BEGIN TRAN
			UPDATE	Historico.SolicitudDesacumulacion	WITH(ROWLOCK)
			SET		TC_Estado							= @L_EstadoSolicitud,
					TC_NumeroExpediente					= @L_NumeroExpediente,
					TC_UsuarioRed						= @L_UsuarioRed,
					TF_FechaSolicitud					= @L_FechaSolicitud,
					TF_Actualizacion					= @L_FechaActualizacion,
					TC_CodPuestoTrabajo					= @L_PuestoTrabajoAsignado,
					TC_AsignadoPor						= @L_AsignadoPor,
					TC_Observaciones					= @L_Observaciones,
					TC_TipoDesacumulacion				= @L_TipoDesacumulacion,
					TN_CodFase							= @L_CodFase
			WHERE	TU_CodSolicitud						= @L_CodSolicitud

			DELETE	Historico.ArchivoSolicitudDesacumulacion
			WHERE	TU_CodSolicitud	= @L_CodSolicitud

			DELETE	Historico.IntervinienteSolicitudDesacumulacion
			WHERE	TU_CodSolicitud	= @L_CodSolicitud

			DELETE	Historico.AudienciaSolicitudDesacumulacion
			WHERE	TU_CodSolicitud	= @L_CodSolicitud

		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRAN;
		END;
	THROW;
	END CATCH	
END
GO
