SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Facilitador].[PA_AgregarFacilitador]
	@CodEscolaridad SMALLINT,	
	@CodProfesion   SMALLINT,	
	@Email          VARCHAR(255) = null,	
	@Observaciones  VARCHAR(255) = null,
	@CodContexto    VARCHAR(4),
	@Activo         BIT,
	@CodPersona     UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TN_CodEscolaridad SMALLINT         = @CodEscolaridad,
			@L_TN_CodProfesion   SMALLINT		  = @CodProfesion,
			@L_TC_Email          VARCHAR(255)     = @Email,
			@L_TC_Observaciones  VARCHAR(255)     = @Observaciones,
			@L_TC_CodContexto    VARCHAR(4)       = @CodContexto,
			@L_TC_Activo         BIT              = @Activo,
			@L_TU_CodPersona     UNIQUEIDENTIFIER = @CodPersona

	INSERT INTO Facilitador.Facilitador
	(      
		TN_CodEscolaridad,
		TN_CodProfesion,  
		TC_Observaciones, 
		TC_Email,
		TC_CodContexto,   
		TB_Activo,  
		TU_CodPersona,
		TF_Actualizacion
	)VALUES(
		@L_TN_CodEscolaridad,
		@L_TN_CodProfesion,  
		@L_TC_Observaciones,
		@L_TC_Email,
		@L_TC_CodContexto,   
		@L_TC_Activo,        
		@L_TU_CodPersona,  
		GETDATE()
	)
	
END
GO
