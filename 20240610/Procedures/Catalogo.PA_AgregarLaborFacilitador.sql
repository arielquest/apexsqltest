SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Catalogo].[PA_AgregarLaborFacilitador]
	@Descripcion             VARCHAR(255),
	@InicioVigencia          DATETIME2(7),
	@FinVigencia             DATETIME2(7),
	@ContabilizaGenero       BIT
	
	
	
AS
BEGIN
	--Variables
	DECLARE @L_TC_Descripcion       VARCHAR(255)	= @Descripcion,        
			@L_TF_InicioVigencia    DATETIME2(7)	= @InicioVigencia,     
			@L_TF_FinVigencia       DATETIME2(7)	= @FinVigencia,
			@L_TB_ContabilizaGenero BIT             = @ContabilizaGenero  
			
	INSERT INTO Catalogo.LaborFacilitadorJudicial 
	(
		TC_Descripcion, 
		TF_InicioVigencia,
		TF_FinVigencia, 
		TB_ContabilizaGenero
	)VALUES(    
		@L_TC_Descripcion,        
		@L_TF_InicioVigencia,     
		@L_TF_FinVigencia, 
		@L_TB_ContabilizaGenero
		)  
END
GO
