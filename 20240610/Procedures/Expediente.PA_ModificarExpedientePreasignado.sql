SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Permite modificar un expediente preasignado  > 
-- Modificado :				<Johan Acosta>	
-- Fecha Modificación :		<27/11/2015>	
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarExpedientePreasignado]
 @CodPreasignado		uniqueidentifier,
 @Estado				varchar(1),
 @FechaTramite			datetime2(3)
 
AS 
    BEGIN
          
		 Update Expediente.ExpedientePreasignado		 
		 Set	TC_Estado = @Estado,TF_Tramite = @FechaTramite
		 Where	TU_CodPreasignado = @CodPreasignado
          
    END
 

GO
