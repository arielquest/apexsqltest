SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<08/03/2021> 
-- Descripción:   		<Permite consultar un registro en la tabla: ExpedienteConsolidadoArchivo.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteConsolidadoArchivo]  
	@CodigoSolicitudDocumentoConsolidado uniqueidentifier
AS BEGIN  
	--Variables  
	DECLARE   
	@L_CodigoSolicitudDocumentoConsolidado uniqueidentifier = @CodigoSolicitudDocumentoConsolidado
	
	--Lógica  
	SELECT   					   				   
				A.TU_CodArchivo   						CodigoArchivo,    
				A.TU_CodSolicitudDocumentoConsolidado  	CodigoSolicitudDocumentoConsolidado,    
				A.TU_CodArchivoEnPrimzDoc   			CodigoArchivoEnPrimzdoc 
				FROM Expediente.ExpedienteConsolidadoArchivo  A 
				WITH (NOLOCK)  
				WHERE A.TU_CodSolicitudDocumentoConsolidado = @L_CodigoSolicitudDocumentoConsolidado
END
GO
