SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<08/03/2021> 
-- Descripción:   		<Permite agregar un registro en la tabla: ExpedienteConsolidadoArchivo.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteConsolidadoArchivo]  	 
	@CodArchivo     					UNIQUEIDENTIFIER,  
	@CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER,  
	@CodArchivoEnPrimzDoc    			VARCHAR(25) 
AS BEGIN  
--Variables  
	   
	DECLARE	@L_TU_CodArchivo   							UNIQUEIDENTIFIER  	= @CodArchivo,    
			@L_TU_CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado,    
			@L_TC_CodArchivoEnPrimzDoc  				VARCHAR(25)  		= @CodArchivoEnPrimzDoc  
--Cuerpo  
	INSERT INTO Expediente.ExpedienteConsolidadoArchivo WITH (ROWLOCK)  
	(       		
		TU_CodArchivo,        			TU_CodSolicitudDocumentoConsolidado,   	TU_CodArchivoEnPrimzDoc       
	)  
	VALUES  (      
				@L_TU_CodArchivo,       @L_TU_CodSolicitudDocumentoConsolidado,   @L_TC_CodArchivoEnPrimzDoc       ) 
END
GO
