SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Consulta el criterio de reparto según los datos del expediente> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<17/09/2021>
-- Descripción :			<Se modifica el tipo de dato del código del criterio manual> 
-- =================================================================================================================================================
-- Versión:					<3.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<28/09/2021>
-- Descripción :			<Se modifica para obtener correctamente el código del criterio manual> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ObtenerCodigoCriterioReparto]
	@CodConfiguracionReparto    UNIQUEIDENTIFIER,
	@CodFase					SMALLINT,
	@CodProceso					SMALLINT,
	@CodClase					INT,
	@CodClaseAsunto				INT,
    @CodCriterioManual			INT,
	@EsLegajo       			BIT = 0,
	@CriterioReparto			VARCHAR(1) = 'C'
AS  
BEGIN  
	Declare 
			@L_CodFase						SMALLINT = @CodFase,
			@L_CodProceso					SMALLINT = @CodProceso,
			@L_CodClase						INT = @CodClase,
			@L_CodClaseAsunto				INT = @CodClaseAsunto,
		    @L_CodCriterioManual			INT = @CodCriterioManual,
			@L_CodConfiguracionReparto		UNIQUEIDENTIFIER = @CodConfiguracionReparto,
			@L_CriterioReparto				VARCHAR(1) = @CriterioReparto, 
			@L_EsLegajo       			    BIT = @EsLegajo, 
			@L_CodCriterio					UNIQUEIDENTIFIER 
	
	
	IF (@L_EsLegajo = 0 )
	BEGIN
		SELECT     @L_CodCriterio = TU_CodCriterio 
			FROM   Catalogo.CriteriosReparto WITH(NOLOCK)
			WHERE  TU_CodConfiguracionReparto	= @L_CodConfiguracionReparto And
				   TB_Agrupacion                = 0 And
				   ISNULL(TN_CodFase,0)			= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodFase ELSE 0 END) And
				   ISNULL(TN_CodClase,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'C'  THEN @L_CodClase    WHEN 'P' THEN @L_CodClase WHEN 'F' THEN @L_CodClase  ELSE 0 END) And 
				   ISNULL(TN_CodProceso,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodProceso  WHEN 'P' THEN @L_CodProceso ELSE 0 END) AND
				   ISNULL(TN_CodCriterioRepartoManual,0) = (CASE UPPER(@L_CriterioReparto) WHEN 'M'  THEN @L_CodCriterioManual ELSE 0 END) 
		


		IF (@L_CodCriterio Is Null)
		BEGIN
		    --Se revisa si el criterio está agrupado
			SELECT @L_CodCriterio = C.TU_CodCriterio 
			FROM   Catalogo.AgrupacionCriterio A WITH(NOLOCK)
			       Inner Join Catalogo.CriteriosReparto C WITH(NOLOCK) On A.TU_CodCriterio = C.TU_CodCriterio
			WHERE  C.TU_CodConfiguracionReparto	= @L_CodConfiguracionReparto And
			       C.TB_Agrupacion              = 1 And
				   ISNULL(A.TN_CodFase,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodFase ELSE 0 END) And
				   ISNULL(A.TN_CodClase,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'C' THEN @L_CodClase    WHEN 'P' THEN @L_CodClase WHEN 'F' THEN @L_CodClase  ELSE 0 END) And 
				   ISNULL(A.TN_CodProceso,0)	= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodProceso  WHEN 'P' THEN @L_CodProceso ELSE 0 END) AND
				   ISNULL(A.TN_CodCriterioRepartoManual,0) = (CASE UPPER(@L_CriterioReparto) WHEN 'M'  THEN @L_CodCriterioManual ELSE 0 END) 

		END
	END
	ELSE
		BEGIN
		SELECT     @L_CodCriterio = TU_CodCriterio 
			FROM   Catalogo.CriteriosReparto WITH(NOLOCK)
			WHERE  TU_CodConfiguracionReparto	= @L_CodConfiguracionReparto And
				   TB_Agrupacion                = 0 And
				   ISNULL(TN_CodFase,0)			= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodFase ELSE 0 END) And
				   ISNULL(TN_CodClaseAsunto,0)	= (CASE UPPER(@L_CriterioReparto) WHEN 'C'  THEN @L_CodClase  WHEN 'P' THEN @L_CodClase ELSE 0 END) And 
				   ISNULL(TN_CodProceso,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodProceso  WHEN 'P' THEN @L_CodProceso ELSE 0 END)  AND
				   ISNULL(TN_CodCriterioRepartoManual,0) = (CASE UPPER(@L_CriterioReparto) WHEN 'M'  THEN @L_CodCriterioManual ELSE 0 END) 
		


		IF (@L_CodCriterio Is Null)
		BEGIN
		    --Se revisa si el criterio está agrupado
			SELECT @L_CodCriterio = C.TU_CodCriterio 
			FROM   Catalogo.AgrupacionCriterio A WITH(NOLOCK)
			       Inner Join Catalogo.CriteriosReparto C WITH(NOLOCK) On A.TU_CodCriterio = C.TU_CodCriterio
			WHERE  C.TU_CodConfiguracionReparto	= @L_CodConfiguracionReparto And
			       C.TB_Agrupacion                  = 1 And
				   ISNULL(A.TN_CodFase,0)			= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodFase ELSE 0 END) And
				   ISNULL(A.TN_CodClaseAsunto,0)	= (CASE UPPER(@L_CriterioReparto) WHEN 'C'  THEN @L_CodClase WHEN 'P' THEN @L_CodClase ELSE 0 END) And 
				   ISNULL(A.TN_CodProceso,0)		= (CASE UPPER(@L_CriterioReparto) WHEN 'F'  THEN @L_CodProceso  WHEN 'P' THEN @L_CodProceso ELSE 0 END)  AND
				   ISNULL(A.TN_CodCriterioRepartoManual,0) = (CASE UPPER(@L_CriterioReparto) WHEN 'M'  THEN @L_CodCriterioManual ELSE 0 END) 
		

		END
	END

	SELECT @L_CodCriterio 

END
GO
