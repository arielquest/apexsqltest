SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<22/11/2018>
-- Descripción :			<Permite actualizar la fecha de fin de acumulación> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ModificarExpedienteAcumulacion]
	@NumeroExpediente			varchar(14)
AS  
BEGIN  

	declare @CodigoAcumulacion  uniqueidentifier
	
	Select @CodigoAcumulacion = TU_CodAcumulacion 
		from Historico.ExpedienteAcumulacion
		where TC_NumeroExpediente  = @NumeroExpediente
		and TF_InicioAcumulacion   = (Select max(TF_InicioAcumulacion)
									  from Historico.ExpedienteAcumulacion
									  where TC_NumeroExpediente = @NumeroExpediente)		
		
		update	Historico.ExpedienteAcumulacion
		set		TF_FinAcumulacion		= getdate()
		where	TU_CodAcumulacion		= 	@CodigoAcumulacion
END
GO
