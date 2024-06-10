SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<26/11/2018>
-- Descripción :			<Permite modificar la asociación de una intervención con un expediente> 
-- Modificación:			<02/07/2019> Juan Ramírez - Se ajusta a la nueva estructura de intervenciones.
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarIntervencionExpediente]
	@CodigoInterviniente		uniqueidentifier,
	@CodigoTipoParticipacion	char(1),
	@CodigoPersona				uniqueidentifier,
	@CodigoNumeroExpediente		varchar(15),
	@FechaInicioVigencia		DateTime2=null,
	@FechaFinVigencia			DateTime2=null
AS  
BEGIN  
	BEGIN TRY
		BEGIN tran
		
				update	 [Expediente].[Intervencion] 
				set		 TF_Actualizacion	= GETDATE()
					    ,TC_TipoParticipacion = @CodigoTipoParticipacion
					    ,TU_CodPersona = @CodigoPersona
					    ,TC_NumeroExpediente = @CodigoNumeroExpediente
					    ,TF_Inicio_Vigencia = @FechaInicioVigencia
					    ,TF_Fin_Vigencia = @FechaFinVigencia					  					  
				where	 TU_CodInterviniente = @CodigoInterviniente				
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
