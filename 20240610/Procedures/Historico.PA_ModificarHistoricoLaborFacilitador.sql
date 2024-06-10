SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<22/03/2023>
-- Descripción:		<SP que	permite modificar un registro del historico de labores de facilitador judicial>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Historico].[PA_ModificarHistoricoLaborFacilitador]
	@CodLaborFacilitador  SMALLINT,
	@TotalRealizado       SMALLINT,
	@ParticipantesHombres SMALLINT=NULL,
	@ParticipantesMujeres SMALLINT=NULL,
	@CodLaborRealizada    UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	
	DECLARE	@L_TN_CodLaborFacilitador  SMALLINT		    = @CodLaborFacilitador,
			@L_TN_TotalRealizado       SMALLINT		    = @TotalRealizado,
			@L_TN_ParticipantesHombres SMALLINT         = @ParticipantesHombres,
			@L_TN_ParticipantesMujeres SMALLINT         = @ParticipantesMujeres,
			@L_TU_CodLaborRealizada	   UNIQUEIDENTIFIER = @CodLaborRealizada

			update Historico.LaborRealizadaFacilitador  WITH (ROWLOCK)
			SET	TN_CodLaborFacilitador                  = @L_TN_CodLaborFacilitador,
				TN_TotalRealizado                       = @L_TN_TotalRealizado,      
				TN_ParticipantesHombres                 = @L_TN_ParticipantesHombres,
				TN_ParticipantesMujeres                 = @L_TN_ParticipantesMujeres,
				TF_Actualizacion                        = GETDATE()
			WHERE						                
				TU_CodLaborRealizada                    = @L_TU_CodLaborRealizada	 
END
GO
