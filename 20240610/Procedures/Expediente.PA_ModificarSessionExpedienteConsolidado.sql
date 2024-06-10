SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    				<1.0> 
-- Creado por:   			<Ricardo Gutiérrez Peña> 
-- Fecha de creación:	 	<16/03/2021> 
-- Descripción:   			<Permite actualizar los campos TC_SessionPrimzDoc y TC_CodDocumentoConsolidado  de un registro en la tabla: ExpedienteConsolidado.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ModificarSessionExpedienteConsolidado]  
	@CodSolicitudDocumentoConsolidado  		UNIQUEIDENTIFIER,        
	@CodDocumentoConsolidado  				VARCHAR(50)  = NULL,
	@SessionPrimzDocAnterior                VARCHAR(100) = NULL,
	@SessionPrimzDocNueva                	VARCHAR(100) = NULL
AS 
BEGIN  
	--Variables  
	DECLARE @L_TU_CodSolicitudDocumentoConsolidado  UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado,          
			@L_TC_CodDocumentoConsolidado  			VARCHAR(50)  		= @CodDocumentoConsolidado,
			@L_TC_SessionPrimzDocAnterior 			VARCHAR(100)  		= @SessionPrimzDocAnterior,
			@L_TC_SessionPrimzDocNueva              VARCHAR(100)        = @SessionPrimzDocNueva
	--Lógica  
	UPDATE 	Expediente.ExpedienteConsolidado WITH (ROWLOCK)  
		SET TC_CodDocumentoConsolidado  			= 	@L_TC_CodDocumentoConsolidado,
			TC_SessionPrimzDoc                      =   @L_TC_SessionPrimzDocNueva 
	WHERE 	TU_CodSolicitudDocumentoConsolidado  	= 	@L_TU_CodSolicitudDocumentoConsolidado 
	AND     TC_SessionPrimzDoc                      =   @L_TC_SessionPrimzDocAnterior
END
GO
