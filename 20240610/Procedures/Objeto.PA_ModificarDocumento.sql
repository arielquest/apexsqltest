SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<12/02/2020>
-- Descripción:			<Permite actualizar el nombre y descripción en las tablas: Objeto.Documento y Archivo.Archivo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ModificarDocumento]
	@Codigo						UNIQUEIDENTIFIER,
	@Nombre						VARCHAR(255)	= NULL,
	@Descripcion				VARCHAR(300)	= NULL
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION TransaccionModificacion;
	BEGIN TRY
		--Variables
		DECLARE	@L_TU_CodArchivo		UNIQUEIDENTIFIER	= @Codigo,
				@L_TC_Nombre			VARCHAR(255)		= @Nombre,
				@L_TC_Descripcion		VARCHAR(300)		= @Descripcion,
				@L_TF_Actualizacion		DATETIME2(7) 		= GETDATE()
		
		--Lógica
		-- Se actualiza la descripción de la tabla Objeto.Documento
		UPDATE	Objeto.Documento	WITH (ROWLOCK)
		SET		TC_Descripcion				= @L_TC_Descripcion,
				TF_Actualizacion			= @L_TF_Actualizacion
		WHERE	TU_CodArchivo				= @L_TU_CodArchivo
		
		-- Si el parámetro del nombre no viene nulo (pues es requerido), se actualiza en la tabla de Archivo.Archivo
		IF @L_TC_Nombre IS NOT NULL
		BEGIN
			UPDATE	Archivo.Archivo		WITH (ROWLOCK)
			SET		TC_Descripcion				= @L_TC_Nombre,
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
