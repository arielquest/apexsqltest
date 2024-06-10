SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Historico].[PA_AgregarHistoricoLaborFacilitador]
	@Anno                 SMALLINT,	
	@Mes                  SMALLINT,	
	@CodFacilitador       INT,	
	@CodLaborFacilitador  SMALLINT,
	@TotalRealizado       SMALLINT,
	@ParticipantesHombres SMALLINT=NULL,
	@ParticipantesMujeres SMALLINT=NULL,
	@CodLaborRealizada    UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	
	DECLARE @L_TN_Anno                 SMALLINT	 	    = @Anno,
			@L_TN_Mes                  SMALLINT		    = @Mes,
			@L_TN_CodFacilitador       INT			    = @CodFacilitador,
			@L_TN_CodLaborFacilitador  SMALLINT		    = @CodLaborFacilitador,
			@L_TN_TotalRealizado       SMALLINT		    = @TotalRealizado,
			@L_TN_ParticipantesHombres SMALLINT         = @ParticipantesHombres,
			@L_TN_ParticipantesMujeres SMALLINT         = @ParticipantesMujeres,
			@L_TU_CodLaborRealizada	   UNIQUEIDENTIFIER = @CodLaborRealizada

	INSERT INTO Historico.LaborRealizadaFacilitador
	(  
		TN_Anno,                
		TN_Mes,                 
		TN_CodFacilitador,      
		TN_CodLaborFacilitador, 
		TN_TotalRealizado,      
		TN_ParticipantesHombres,
		TN_ParticipantesMujeres,
		TU_CodLaborRealizada ,
		TF_FechaRegistro,
		TF_Actualizacion 
	)VALUES(    
		@L_TN_Anno,                
		@L_TN_Mes,                 
		@L_TN_CodFacilitador,      
		@L_TN_CodLaborFacilitador, 
		@L_TN_TotalRealizado,      
		@L_TN_ParticipantesHombres,
		@L_TN_ParticipantesMujeres,    
		@L_TU_CodLaborRealizada,
		GETDATE(),
		GETDATE()
		)  
END
GO
