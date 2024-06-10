SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<23/08/2021>
-- Descripción :			<Agrega un criterio de reparto> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarCriterioReparto]
	@CodConfiguracionReparto    UNIQUEIDENTIFIER,
	@CodCriterio			    UNIQUEIDENTIFIER,
	@CodFase					SMALLINT,
	@CodProceso					SMALLINT,
	@CodClase					INT,
	@CodClaseAsunto				INT,
    @CodCriterioManual			INT,
	@NombreCriterio			    VARCHAR(100),
	@Agrupacion					BIT
AS  
BEGIN  
	DECLARE 
			@L_CodFase						SMALLINT = @CodFase,
			@L_CodCriterio					UNIQUEIDENTIFIER = @CodCriterio,
			@L_CodProceso					SMALLINT = @CodProceso,
			@L_CodClase						INT = @CodClase,
			@L_CodClaseAsunto				INT = @CodClaseAsunto,
		    @L_CodCriterioManual			INT = @CodCriterioManual,
			@L_CodConfiguracionReparto		UNIQUEIDENTIFIER = @CodConfiguracionReparto,
			@L_NombreCriterio				VARCHAR(100) = @NombreCriterio,
			@L_Agrupacion					BIT = @Agrupacion


	
	
	INSERT INTO Catalogo.CriteriosReparto
				   (TU_CodCriterio,				TN_CodClase,                         TN_CodProceso,    TN_CodFase,
				   TN_CodCriterioRepartoManual, TU_CodConfiguracionReparto,          TC_Nombre,        TB_Herencia,
				   TB_Agrupacion,				TF_FechaParticion,					  TN_CodClaseAsunto)
	VALUES(
				   @L_CodCriterio,				@L_CodClase,						 @L_CodProceso,     @L_CodFase,
				   @L_CodCriterioManual,		@L_CodConfiguracionReparto,          @L_NombreCriterio, 0,
				   @L_Agrupacion,				GETDATE(),							 @L_CodClaseAsunto)
END
GO
