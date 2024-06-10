SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<16/01/2019>
-- Descripción :			<Permite consultar el expediente al cual esta acumulado otro expediente.> 
-- =================================================================================================================================================

CREATE Procedure [Expediente].[PA_ConsultarExpedienteAcumula]
	@NumeroExpediente			varchar(14)
As
Begin

	Select	TC_NumeroExpedienteAcumula
	from	Historico.ExpedienteAcumulacion 
	where	TC_NumeroExpediente				= @NumeroExpediente 
	and		TF_InicioAcumulacion			= (	select MAX(TF_InicioAcumulacion) 
												from Historico.ExpedienteAcumulacion 
												where TC_NumeroExpediente = @NumeroExpediente 
												and TF_FinAcumulacion is null)		
End
GO
