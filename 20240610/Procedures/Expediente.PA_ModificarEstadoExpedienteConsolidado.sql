SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    				<1.0> 
-- Creado por:   			<Ricardo Gutiérrez Peña> 
-- Fecha de creación:	 	<05/03/2021> 
-- Descripción:   			<Permite actualizar un registro en la tabla: ExpedienteConsolidado.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ModificarEstadoExpedienteConsolidado]  
	@CodSolicitudDocumentoConsolidado  		UNIQUEIDENTIFIER,      
	@Estado      							CHAR(1),  
	@FechaGenerado   						DATETIME2(6) = NULL,  
	@FechaVencimiento   					DATETIME2(6) = NULL, 
	@CodDocumentoConsolidado  				VARCHAR(50)  = NULL,
	@Session                                VARCHAR(100) = NULL
AS 
BEGIN  
	--Variables  
	DECLARE @L_TU_CodSolicitudDocumentoConsolidado  UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado,      
			@L_TC_Estado    						CHAR(1)  			= @Estado,   
			@L_TF_FechaGenerado  					DATETIME2(6)  		= @FechaGenerado,    
			@L_TF_FechaVencimiento  				DATETIME2(6)  		= @FechaVencimiento,    
			@L_TC_CodDocumentoConsolidado  			VARCHAR(50)  		= @CodDocumentoConsolidado,
			@L_TC_SessionPrimzDoc 					VARCHAR(100)  		= @Session
	--Lógica  
	UPDATE 	Expediente.ExpedienteConsolidado WITH (ROWLOCK)  
	SET   	TC_Estado     							= 	@L_TC_Estado,    
			TF_FechaGenerado   						= 	@L_TF_FechaGenerado,    
			TF_FechaVencimiento   					= 	@L_TF_FechaVencimiento,    
			TC_CodDocumentoConsolidado  			= 	@L_TC_CodDocumentoConsolidado,
			TC_SessionPrimzDoc                      =   @L_TC_SessionPrimzDoc
	WHERE 	TU_CodSolicitudDocumentoConsolidado  	= 	@L_TU_CodSolicitudDocumentoConsolidado 
END
GO
