SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Historico].[PA_AgregarHistoricoLaborPersonalJudicial]
	@CodLabor                 UNIQUEIDENTIFIER,
	@Anno                     SMALLINT,
	@Mes                      SMALLINT,
	@UsuarioRed               VARCHAR(30),
	@CodContexto              VARCHAR(4),
	@CodLaborPersonalJudicial SMALLINT,
	@HorasOficina             SMALLINT,
	@HorasFueraOficina        SMALLINT 

AS
BEGIN
	--Variables
	
	DECLARE @L_TU_CodLabor                 UNIQUEIDENTIFIER = @CodLabor,                 
			@L_TN_Anno                     SMALLINT         = @Anno,                     
			@L_TN_Mes                      SMALLINT         = @Mes,                      
			@L_TC_UsuarioRed               VARCHAR(30)      = @UsuarioRed,                     
			@L_TC_CodContexto              VARCHAR(4)       = @CodContexto,              
			@L_TN_CodLaborPersonalJudicial SMALLINT         = @CodLaborPersonalJudicial, 
			@L_TN_HorasOficina             SMALLINT         = @HorasOficina,             
			@L_TN_HorasFueraOficina        SMALLINT         = @HorasFueraOficina
			
	INSERT INTO Historico.LaborRealizadaPersonalJudicial
	(  
		TU_CodLabor,                
		TN_Anno,                    
		TN_Mes,                     
		TC_UsuarioRed,
		TC_CodContexto,             
		TN_CodLaborPersonalJudicial,
		TN_HorasOficina,            
		TN_HorasFueraOficina,
		TF_FechaRegistro,
		TF_Actualizacion
	)VALUES(    
		@L_TU_CodLabor,                
		@L_TN_Anno,                    
		@L_TN_Mes,                     
		@L_TC_UsuarioRed,
		@L_TC_CodContexto,             
		@L_TN_CodLaborPersonalJudicial,
		@L_TN_HorasOficina,            
		@L_TN_HorasFueraOficina,      
		GETDATE(),    
		GETDATE()
		)  
END
GO
