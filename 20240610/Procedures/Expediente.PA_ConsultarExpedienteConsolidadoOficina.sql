SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================================================================================================================= 
-- Versión:    	      <1.0> 
-- Creado por:        <Ricardo Gutiérrez Peña> 
-- Fecha de creación: <18/02/2021> 
-- Descripción:       <Permite consultar para un contexto las solicitudes pendientes de generación del expediente consolidado   
-- ========================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteConsolidadoOficina]  
		@Contexto  varchar(4) 
AS BEGIN  
	--Variables  
	DECLARE @L_Contexto  varchar(14)  = @Contexto  

	--Lógica  
	SELECT   		A.TU_CodSolicitudDocumentoConsolidado  		Codigo,				     
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
	WHERE TC_CodContexto  = @L_Contexto
    AND   TC_Estado  = 'P'	
	ORDER BY TF_FechaSolicitud desc
END
GO
