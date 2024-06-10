SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<23/10/2018>
-- Descripción :			<Permite eliminar la relación de un legajo con un documento y eliminar el ArchivoExpediente> 
-- Modificacion:			<Jonathan Aguilar Navarro> <07/08/2019> <Ya no se elimina del LegajoArchivo> 
-- Modificación				<Jonathan Aguilar Navarro> <06/10/2020> <Se camba la eliminación fisica del archivo por eliminación lógica>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_EliminarLegajoArchivo]
	@CodArchivo					uniqueidentifier,
	@NumeroExpediente			varchar(14)
AS  
BEGIN  
	BEGIN TRY
	BEGIN tran
		declare @L_CodArchivo	uniqueidentifier	= @CodArchivo
		declare @L_NumeroExpediente	varchar(14)		= @NumeroExpediente

			update	[Expediente].[ArchivoExpediente]
			set		[TB_Eliminado]				= 1
			where	TU_CodArchivo				= @L_CodArchivo
			and		TC_NumeroExpediente			= @L_NumeroExpediente

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
