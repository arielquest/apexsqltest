SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Miguel Avendaño Rosales>
-- Fecha de creación:	<07/04/2021>
-- Descripción :		<Permite registrar los archivos de una carpeta de la defensa publica> 
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarArchivoCarpeta] 
	@CodArchivo 					uniqueidentifier,		
	@NRD							varchar(14),
	@CodGrupoTrabajo				smallint
AS
BEGIN

	DECLARE
	
	@L_TU_CodArchivo                uniqueidentifier    = @CodArchivo,    
	@L_TC_NRD				        varchar(14)         = @NRD,
	@L_TN_CodGrupoTrabajo			smallint			= @CodGrupoTrabajo

	INSERT INTO DefensaPublica.ArchivoCarpeta 
		(
			 TU_CodArchivo,    		TC_NRD,				TN_CodGrupoTrabajo
		)
		VALUES
		(
			@L_TU_CodArchivo,		@L_TC_NRD,			@L_TN_CodGrupoTrabajo
		)
END
GO
