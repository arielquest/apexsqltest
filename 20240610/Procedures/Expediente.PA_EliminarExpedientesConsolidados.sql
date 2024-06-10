SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    			<1.0> 
-- Creado por:   		<Ricardo Gutiérrez Peña> 
-- Fecha de creación: 	<18/03/2021> 
-- Descripción:   		<Elimina los expedientes consolidados que se encuentran vencidos de la tabla: ExpedienteConsolidado.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_EliminarExpedientesConsolidados]   
 
AS 
BEGIN  
	--Variables  
	   
	
	--Lógica  
	DELETE  FROM Expediente.ExpedienteConsolidado WITH (ROWLOCK)  
	WHERE TU_CodSolicitudDocumentoConsolidado  IN (
		SELECT 	E.TU_CodSolicitudDocumentoConsolidado 
		FROM  	ExpedienteConsolidado E 
		WHERE	TF_FechaVencimiento < GETDATE()
		AND     E.TC_ESTADO = 'F'
	) 
END
GO
