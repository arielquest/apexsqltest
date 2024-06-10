SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================================================================================================================================= 
-- Versión:    	      <1.0> 
-- Creado por:        <Ricardo Gutiérrez Peña> 
-- Fecha de creación: <09/03/2021> 
-- Descripción:       < Si se indica un número de expediente permite consultar si para el expediente indicado, existe un expediente consolidado vigente , en caso que no se indique número de 
--                      expediente devuelve todos los expedientes consolidados vigentes
-- Modificacion:     <Wagner Vargas> <18/08/2021> <Se modifica la consulta para que no interfiera entre legajos y el principal>
-- ========================================================================================================================================================================================== 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteConsolidadoVigente]   
		@NumeroExpediente  varchar(14),
		@CodLegajo uniqueidentifier
AS BEGIN  
--Variables  
	DECLARE @L_NumeroExpediente  varchar(14)  = @NumeroExpediente
	DECLARE @L_CodLegajo		uniqueidentifier	= @CodLegajo

		--Lógica
	IF @L_NumeroExpediente IS NULL OR @L_NumeroExpediente = ''
	BEGIN
		SELECT		  		A.TU_CodSolicitudDocumentoConsolidado  		Codigo,				     
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
					
			FROM  Expediente.ExpedienteConsolidado  A 
			WITH  (NOLOCK)  
			WHERE  TC_Estado = 'F'	
			AND   (TF_FechaVencimiento IS NULL OR TF_FechaVencimiento >= GetDate())
			ORDER BY TF_FechaSolicitud desc
	END
	ELSE
		BEGIN
			  
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
					
			FROM  Expediente.ExpedienteConsolidado  A 
			WITH  (NOLOCK)  
			WHERE TC_NumeroExpediente  = @L_NumeroExpediente and TU_CodLegajo = @L_CodLegajo
			AND   TC_Estado = 'F'	
			AND   (TF_FechaVencimiento IS NULL OR TF_FechaVencimiento >= GetDate())
			ORDER BY TF_FechaSolicitud desc
		END
END
GO
