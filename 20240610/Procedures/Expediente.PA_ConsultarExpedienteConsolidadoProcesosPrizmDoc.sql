SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




-- ========================================================================================================================================================================================= 
-- Versión:    	      <1.0> 
-- Creado por:        <Ricardo Gutiérrez Peña> 
-- Fecha de creación: <11/10/2021> 
-- Descripción:       <Permite consultar los procesos de PrizmDoc de los expedientes consolidados que se han generado 
-- ========================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteConsolidadoProcesosPrizmDoc]   
		
AS BEGIN  
	--Variables  
	 

	--Lógica  
	SELECT DISTINCT  A.TF_FechaInicioUnificacion  FechaInicioUnificacion,
	A.TU_CodSolicitudDocumentoConsolidado CodigoSolicitudDocumentoConsolidado,
	A.TC_CodProcesoUnificadoPrimzDoc CodigoProcesoUnificadoPrizmDoc
	FROM Expediente.ExpedienteConsolidadoProcesoPrizmdoc  A 
	WITH (NOLOCK)  
	ORDER BY   A.TF_FechaInicioUnificacion ASC	

END
GO
