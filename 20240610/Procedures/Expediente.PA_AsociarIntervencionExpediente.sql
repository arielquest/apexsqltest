SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<23/10/2018>
-- Descripción :			<Permite actualizar el número de expediente en la tabla intervencion y con esto asociar la intervencion a otro expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AsociarIntervencionExpediente]
	@CodInterviniente		uniqueidentifier,
	@TipoParticipacion		char(1),
	@CodPersona				Uniqueidentifier,
	@NumeroExpediente		varchar(15)

AS  
BEGIN  
	BEGIN TRY
	BEGIN tran
		update	[Expediente].[Intervencion] 
		set		TF_Fin_Vigencia	= GETDATE()
		where	TU_CodInterviniente = @CodInterviniente

		insert into [Expediente].[Intervencion] 
		(
			[TU_CodInterviniente],
			[TC_TipoParticipacion],
			[TU_CodPersona],
			[TC_NumeroExpediente],
			[TF_Inicio_Vigencia],
			[TF_Fin_Vigencia],
			[TF_Actualizacion]
		)
		values
		(
			NEWID(),
			@TipoParticipacion,		
			@CodPersona,
			@NumeroExpediente,					
			GETDATE(),	
			NULL,	
			GETDATE()	
		)
	
	COMMIT TRAN;
	END TRY
		BEGIN CATCH
		IF (@@TRANCOUNT > 0)
		BEGIN
			ROLLBACK TRAN;
		END;
		THROW;
	END CATCH
END
GO
