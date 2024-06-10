SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<08/10/2019>
-- Descripción :			<Permite eliminar una contraparte>
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_EliminarContraparte]
   @CodContraparte uniqueidentifier,
   @NRD varchar(14),
   @CodPersona uniqueidentifier 
AS 
BEGIN
	DECLARE @ERRORMESSAGE 	NVARCHAR(4000)
	DECLARE @ERRORSEVERITY	INT
	DECLARE @ERRORSTATE		INT
   
	BEGIN TRY
		BEGIN TRANSACTION Borrar_Contraparte
					DELETE 
					FROM	DefensaPublica.Contraparte
					WHERE	TU_CodContraparte	= @CodContraparte
					And		TC_NRD				= @NRD
					And		TU_CodPersona		= @CodPersona
		COMMIT TRANSACTION Borrar_Contraparte
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION Borrar_Contraparte
			SELECT	@ERRORSEVERITY = ERROR_SEVERITY(),
					@ERRORSTATE = ERROR_STATE(),
					@ERRORMESSAGE = ERROR_MESSAGE()
					RAISERROR(@ERRORMESSAGE, @ERRORSEVERITY, @ErrorState)
	END CATCH 
END
GO
