SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<18/03/2020>
-- Descripción:			<Permite registrar datos de autorización o no de una entidad de SolicitudTraslado.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarSolicitudTraslado]
	@Codigo								UNIQUEIDENTIFIER,
	@UsuarioRedAutorizaSolicitud		VARCHAR(30),
	@Estado								CHAR(1),
	@ObservacionesAutorizacion			VARCHAR(250)	= NULL
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION TransaccionModificacion;
	BEGIN TRY
		--Variables
		DECLARE	@L_TU_CodSolicitudTraslado			UNIQUEIDENTIFIER	= @Codigo,
				@L_TC_UsuarioRedAutorizaSolicitud	VARCHAR(30)			= @UsuarioRedAutorizaSolicitud,
				@L_TC_Estado						CHAR(1)				= @Estado,
				@L_TC_ObservacionesAutorizacion		VARCHAR(250)		= @ObservacionesAutorizacion,
				@L_TF_FechaAutorizacion				DATETIME2(7) 		= GETDATE(),
				@L_TF_Actualizacion					DATETIME2(7) 		= GETDATE()
				
		
		--Lógica
		-- Se actualiza la observación de la tabla Objeto.SolicitudTraslado
		UPDATE	Objeto.SolicitudTraslado		WITH (ROWLOCK)
		SET		TC_UsuarioRedAutorizaSolicitud	= @L_TC_UsuarioRedAutorizaSolicitud,
				TC_Estado						= @L_TC_Estado,
				TC_ObservacionesAutorizacion	= @L_TC_ObservacionesAutorizacion,
				TF_Actualizacion				= @L_TF_Actualizacion,
				TF_FechaAutorizacion			= @L_TF_FechaAutorizacion
		WHERE	TU_CodSolicitudTraslado			= @L_TU_CodSolicitudTraslado
		
		
		COMMIT TRANSACTION
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION TransaccionModificacion; -- rollback a TransaccionModificacion
        END
    END CATCH
END
GO
