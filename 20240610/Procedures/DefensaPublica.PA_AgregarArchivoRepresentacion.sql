SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Miguel Avendaño Rosales>
-- Fecha de creación:	<07/04/2021>
-- Descripción :		<Permite registrar los archivos de una representacion de la defensa publica> 
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarArchivoRepresentacion] 
	@CodArchivo 					uniqueidentifier,		
	@CodRepresentacion				uniqueidentifier
AS
BEGIN

	DECLARE
	
	@L_TU_CodArchivo                uniqueidentifier    = @CodArchivo,    
	@L_TU_CodRepresentacion	        uniqueidentifier    = @CodRepresentacion

	INSERT INTO DefensaPublica.ArchivoRepresentacion 
		(
			 TU_CodArchivo,    		TU_CodRepresentacion			
		)
		VALUES
		(
			@L_TU_CodArchivo,		@CodRepresentacion	 
		)
END
GO
