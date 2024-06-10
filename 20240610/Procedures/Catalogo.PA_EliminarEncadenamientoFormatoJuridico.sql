SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<19/11/2021>
-- Descripción :			<Permite eliminar un encadenamiento completo incluyendo sus pasos> 
-- =========================================================================================================================================
-- =========================================================================================================================================
-- Modificacion:        <19/05/2022><Rafa Badilla Alvarado><Se ajusta para eliminar los parámetros de los pasos tipo operacion, en caso de existir >
-- =========================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarEncadenamientoFormatoJuridico]
	@CodigoEncadenamiento	INT
AS
BEGIN
	DECLARE	@L_CodigoEncadenamiento	INT	=	@CodigoEncadenamiento

	BEGIN TRY
		 BEGIN TRANSACTION;  

		 	DELETE FROM Catalogo.PasoEncadenamientoOperacionParametro
		    WHERE	    TN_CodEncadenamientoFormatoJuridico = @L_CodigoEncadenamiento 

			DELETE	[Catalogo].[PasoEncadenamientoFormatoJuridico]
			WHERE	TN_CodEncadenamientoFormatoJuridico		=	@L_CodigoEncadenamiento
			
			DELETE	[Catalogo].[EncadenamientoFormatoJuridico]
			WHERE	TN_CodEncadenamientoFormatoJuridico		=	@L_CodigoEncadenamiento

		COMMIT TRANSACTION;  
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		
		DECLARE @ErrorMessage	NVARCHAR(4000),  
				@ErrorSeverity	INT,  
				@ErrorState		INT  
  
		SELECT  @ErrorMessage = ERROR_MESSAGE(),  
				@ErrorSeverity = ERROR_SEVERITY(),  
				@ErrorState = ERROR_STATE();  
  
	    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
	END	CATCH
END
GO
