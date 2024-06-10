SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================================================================================================================= 
-- Versión:    	      <1.0> 
-- Creado por:        <Ricardo Gutiérrez Peña> 
-- Fecha de creación: <18/02/2021> 
-- Descripción:       <Permite consultar los contextos que tienen registradas una solicitud de generación del expediente consolidado en estado pendiente 
-- ========================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarContextosExpedienteConsolidado]   
		
AS BEGIN  
	--Variables  
	 

	--Lógica  
	SELECT DISTINCT  A.TC_CodContexto  Codigo			
	FROM Expediente.ExpedienteConsolidado  A 
	WITH (NOLOCK)  
	WHERE  TC_Estado = 'P'	

END
GO
