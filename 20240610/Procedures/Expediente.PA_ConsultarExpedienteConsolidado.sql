SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ========================================================================================================================================================================================= 
-- Versión:    	      <1.0> 
-- Creado por:        <Ricardo Gutiérrez Peña> 
-- Fecha de creación: <18/02/2021> 
-- Descripción:       <Permite consultar si para el expediente indicado ya se encuentra registrada una solicitud de generación del expediente consolidado en estado pendiente o tramitándose  
-- Modificacion:     <Wagner Vargas> <18/08/2021> <Se modifica la consulta para que no interfiera entre legajos y el principal>
--========================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteConsolidado]   
		@NumeroExpediente  varchar(14), 
		@CodLegajo uniqueidentifier
AS BEGIN  
	--Variables  
	DECLARE @L_NumeroExpediente  varchar(14)		= @NumeroExpediente  
	DECLARE @L_CodLegajo		uniqueidentifier	= @CodLegajo
	--Lógica  
	SELECT TOP 1  	A.TU_CodSolicitudDocumentoConsolidado  		Codigo,				     
					A.TU_CodLegajo   							Codigolegajo,    
					A.TF_FechaSolicitud  						FechaSolicitud,        
					A.TC_UsuarioRed   							Usuario,        
					A.TF_FechaGenerado  						FechaGenerado,    
					A.TF_FechaVencimiento  						FechaVencimiento,    
					A.TC_CodDocumentoConsolidado  				CodigoDocumentoConsolidado, 
					A.TC_SessionPrimzDoc                        SessionPrimzDoc,
					'Split'  									As SplitExpedienteDetalle,
				     A.TC_NumeroExpediente  					Numero,
					'Split'  									As SplitContexto,
	                A.TC_CodContexto   							Codigo,  
					'Split'                                     As SplitOtrosDatos,
					A.TN_Sistema    							Sistema,
					A.TC_Estado    								Estado
					
	FROM Expediente.ExpedienteConsolidado  A 
	WITH (NOLOCK)  
	WHERE TC_NumeroExpediente  = @L_NumeroExpediente and TU_CodLegajo = @L_CodLegajo
    AND   TC_Estado IN ('P','T')	
	ORDER BY TF_FechaSolicitud desc
END
GO
