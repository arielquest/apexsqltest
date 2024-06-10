SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<12/10/2021> 
-- Descripción:   		<Elimina la información de los archivos de la tabla: ExpedienteConsolidadoArchivos para el código de solicitud indicado> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_EliminarExpedienteConsolidadoArchivos]   
 @CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER
AS 
BEGIN  
	--Variables  
	DECLARE	@L_TU_CodSolicitudDocumentoConsolidado  	UNIQUEIDENTIFIER  	= @CodSolicitudDocumentoConsolidado 
			 
	--Lógica  
	DELETE  FROM Expediente.ExpedienteConsolidadoArchivo WITH (ROWLOCK)  
	WHERE TU_CodSolicitudDocumentoConsolidado  = @L_TU_CodSolicitudDocumentoConsolidado
END
GO
