SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Xinia Soto V.>  
-- Fecha de creación:  <06/07/2020>  
-- Descripción :   <Permite Consultar las representaciones  
-- =================================================================================================================================================
-- Modificacion:	<26-10-2020> <Daniel Ruiz Hernández> <Se modifica la consulta para validar cuando el parametro numero de expediente viene null>
   -- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarRepresentacion]  
 @NumeroExpediente  varchar(14) = null,  
 @CodigoInterviniente uniqueidentifier = null,   
 @CodigoRepresentante   uniqueidentifier = null  
   
As  
Begin  
Declare @L_NumeroExpediente  varchar(14) = @NumeroExpediente
Declare @L_CodigoInterviniente uniqueidentifier = @CodigoInterviniente 
Declare @L_CodigoRepresentante   uniqueidentifier = @CodigoRepresentante  
   
   Select 
	   R.TB_Principal			   'Principal',
	   R.TB_NotificaRepresentante  'NotificaRepresentante',
	   R.TF_Fin_Vigencia		   'FechaDesactivacion',
	   R.TF_Inicio_Vigencia		   'FechaActivacion'
   From [Expediente].[Representacion] R 
   Inner Join  Expediente.Intervencion I on i.TU_CodInterviniente = r.TU_CodIntervinienteRepresentante
   Where i.TC_NumeroExpediente				= isnull(@L_NumeroExpediente,i.TC_NumeroExpediente)
   and   R.TU_CodInterviniente				= @L_CodigoInterviniente
   and   R.TU_CodIntervinienteRepresentante = @L_CodigoRepresentante

End  
GO
