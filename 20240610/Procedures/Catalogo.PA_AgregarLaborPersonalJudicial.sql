SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Catalogo].[PA_AgregarLaborPersonalJudicial]
	@Descripcion             VARCHAR(255),
	@InicioVigencia          DATETIME2(7),
	@FinVigencia             DATETIME2(7)
	
	
	
AS
BEGIN
	--Variables
	
	DECLARE @L_TC_Descripcion    VARCHAR(255)	= @Descripcion,        
			@L_TF_InicioVigencia DATETIME2(7)	= @InicioVigencia,     
			@L_TF_FinVigencia    DATETIME2(7)	= @FinVigencia
			
	INSERT INTO Catalogo.LaborPersonalJudicial
	(
		TC_Descripcion, 
		TF_InicioVigencia,
		TF_FinVigencia
	)VALUES(    
		@L_TC_Descripcion,        
		@L_TF_InicioVigencia,     
		@L_TF_FinVigencia     
		)  
END
GO
