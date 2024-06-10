SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<17/02/2020>
-- Descripción:			<Permite actualizar la descripción y observación en las tablas: Objeto.Fotografia y Archivo.Archivo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarFotografia]
	@Codigo						UNIQUEIDENTIFIER,
	@Descripcion				VARCHAR(255)	= NULL,
	@Observacion				VARCHAR(200)	= NULL
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION TransaccionModificacion;
	BEGIN TRY
		--Variables
		DECLARE	@L_TU_CodArchivo		UNIQUEIDENTIFIER	= @Codigo,
				@L_TC_Descripcion		VARCHAR(255)		= @Descripcion,
				@L_TC_Observacion		VARCHAR(200)		= @Observacion,
				@L_TF_Actualizacion		DATETIME2(7) 		= GETDATE()
		
		--Lógica
		-- Se actualiza la observación de la tabla Objeto.Fotografia
		UPDATE	Objeto.Fotografia	WITH (ROWLOCK)
		SET		TC_Observacion				= @L_TC_Observacion,
				TF_Actualizacion			= @L_TF_Actualizacion
		WHERE	TU_CodArchivo				= @L_TU_CodArchivo
		
		-- Si el parámetro Descripcion no viene nulo (pues es requerido), se actualiza en la tabla de Archivo.Archivo
		IF @L_TC_Descripcion IS NOT NULL
		BEGIN
			UPDATE	Archivo.Archivo		WITH (ROWLOCK)
			SET		TC_Descripcion				= @L_TC_Descripcion,
					TF_Actualizacion			= @L_TF_Actualizacion
			WHERE	TU_CodArchivo				= @L_TU_CodArchivo
		END
		
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
