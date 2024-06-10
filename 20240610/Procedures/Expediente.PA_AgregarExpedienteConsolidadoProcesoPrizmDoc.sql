SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<08/10/2021> 
-- Descripción:   		<Permite agregar un registro en la tabla: ExpedienteConsolidadoProcesoPrizmDoc.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteConsolidadoProcesoPrizmDoc]  	 
	@FechaInicioUnificacion     		DATETIME2(7),  
	@CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER,  
	@CodigoProcesoUnificadoPrizmDoc    	VARCHAR(25) 
AS BEGIN  
--Variables  
	   
	DECLARE	@L_TF_FechaInicioUnificacion  				DATETIME2(7)  		= @FechaInicioUnificacion,    
			@L_TU_CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado,    
			@L_TC_CodigoProcesoUnificadoPrizmDoc 		VARCHAR(25)  		= @CodigoProcesoUnificadoPrizmDoc  
--Cuerpo  
	INSERT INTO Expediente.ExpedienteConsolidadoProcesoPrizmdoc WITH (ROWLOCK)  
	(       		
				TF_FechaInicioUnificacion,        	TU_CodSolicitudDocumentoConsolidado,   		TC_CodProcesoUnificadoPrimzDoc       
	)  
	VALUES  (      
				@L_TF_FechaInicioUnificacion ,       @L_TU_CodSolicitudDocumentoConsolidado,	@L_TC_CodigoProcesoUnificadoPrizmDoc      ) 
END
GO
