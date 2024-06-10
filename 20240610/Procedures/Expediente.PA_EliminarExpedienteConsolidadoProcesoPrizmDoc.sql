SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<11/10/2021> 
-- Descripción:   		<Elimina la información de un proceso de la tabla: ExpedienteConsolidadoProcesoPrizmDoc.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_EliminarExpedienteConsolidadoProcesoPrizmDoc]   
 @CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER
AS 
BEGIN  
	--Variables  
	DECLARE	@L_TU_CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado 
			 
	--Lógica  
	DELETE  FROM Expediente.ExpedienteConsolidadoProcesoPrizmdoc WITH (ROWLOCK)  
	WHERE TU_CodSolicitudDocumentoConsolidado  = @L_TU_CodSolicitudDocumentoConsolidado
END
GO
