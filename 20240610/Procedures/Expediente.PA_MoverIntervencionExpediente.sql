SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<16/01/2019>
-- Descripción :			<Permite mover intervenciones entre expedientes> 
-- =================================================================================================================================================

CREATE Procedure [Expediente].[PA_MoverIntervencionExpediente]
	@CodInterviniente			Uniqueidentifier,
	@NumeroExpediente			varchar(14)
As
Begin
declare @NumeroExpedienteAcumula varchar(14)
BEGIN TRY
	BEGIN TRAN
		begin
			update	Expediente.Intervencion
			set		TU_RelacionIntervencion =	null
			where	TU_CodInterviniente		=	@CodInterviniente			

			Select @NumeroExpedienteAcumula = TC_NumeroExpediente from Historico.ExpedienteAcumulacion where TC_NumeroExpedienteAcumula = @NumeroExpediente and TF_InicioAcumulacion = (select MAX(TF_InicioAcumulacion) from Historico.ExpedienteAcumulacion where TC_NumeroExpedienteAcumula = @NumeroExpediente and TF_FinAcumulacion is null)			

			update	Expediente.Intervencion
			set		TC_NumeroExpediente		= 	@NumeroExpedienteAcumula
			where	TU_CodInterviniente		=	@CodInterviniente
					
		end
	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK TRAN;
	END;
	THROW;
END CATCH	
End
GO
