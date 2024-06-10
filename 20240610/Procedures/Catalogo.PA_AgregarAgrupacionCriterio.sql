SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<24/08/2021>
-- Descripción :			<Agrega un criterio de reparto agrupado> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarAgrupacionCriterio]
	@CodAgrupacion					UNIQUEIDENTIFIER,
	@CodCriterio					UNIQUEIDENTIFIER,
	@CodClase						INT,
	@CodProceso						SMALLINT,
	@CodFase						SMALLINT,
	@CodCriterioRepartoManual		INT,
	@CodConfiguracionReparto		UNIQUEIDENTIFIER,
	@CodClaseAsunto					INT,
	@NombreCriterio					VARCHAR(250) 
AS  
BEGIN  
	DECLARE 
			@L_CodAgrupacion				UNIQUEIDENTIFIER	= @CodAgrupacion,
			@L_CodCriterio					UNIQUEIDENTIFIER	= @CodCriterio,
			@L_CodClase						INT					= @CodClase,
			@L_CodProceso					SMALLINT			= @CodProceso,
			@L_CodFase						SMALLINT			= @CodFase,
		    @L_CodCriterioRepartoManual		INT					= @CodCriterioRepartoManual,		
			@L_CodConfiguracionReparto		UNIQUEIDENTIFIER	= @CodConfiguracionReparto,
			@L_CodClaseAsunto				INT					= @CodClaseAsunto,	
			@L_NombreCriterio				VARCHAR(250)		= @NombreCriterio

	
	INSERT INTO Catalogo.AgrupacionCriterio
				   (TU_CodAgrupacion,	TU_CodCriterio,					TN_CodClase,				TN_CodProceso,
					TN_CodFase,			TN_CodCriterioRepartoManual,	TU_CodConfiguracionReparto,	TN_CodClaseAsunto,
					TC_Nombre)
	VALUES(			@L_CodAgrupacion,	@L_CodCriterio,						@L_CodClase,				@L_CodProceso,
					@L_CodFase,			@L_CodCriterioRepartoManual,		@L_CodConfiguracionReparto,	@L_CodClaseAsunto,
					@L_NombreCriterio)

END
GO
