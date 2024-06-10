SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Catalogo].[PA_ConsultarLaborPersonalJudicial]
	@CodLaborPersonalJudicial SMALLINT,
	@Descripcion              VARCHAR(255),
	@InicioVigencia           DATETIME2(7),
	@FinVigencia              DATETIME2(7) 
	
	AS
	BEGIN
	--Variables
	DECLARE	@L_TN_CodLaborPersonalJudicial SMALLINT     = @CodLaborPersonalJudicial
	DECLARE	@L_TC_Descripcion              VARCHAR(255) = IIF(@Descripcion IS NOT NULL,'%' + @Descripcion + '%','%')
	DECLARE	@L_TF_InicioVigencia           DATETIME2(7) = @InicioVigencia
	DECLARE	@L_TF_FinVigencia              DATETIME2(7) = @FinVigencia
	
	--Todos
	IF @L_TF_InicioVigencia IS NULL AND @L_TF_FinVigencia IS NULL 
	BEGIN
		SELECT TN_CodLaborPersonalJudicial AS CodLaborPersonalJudicial, TC_Descripcion AS Descripcion, TF_InicioVigencia AS FechaActivacion,
			   TF_FinVigencia              AS FechaDesactivacion
		FROM Catalogo.LaborPersonalJudicial	 WITH(NOLOCK)
		WHERE TN_CodLaborPersonalJudicial =  COALESCE(@L_TN_CodLaborPersonalJudicial,TN_CodLaborPersonalJudicial)
		AND   dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)  
		ORDER BY Descripcion ASC
	END	 
	--Activos
	ELSE IF @L_TF_InicioVigencia IS NOT NULL AND @L_TF_FinVigencia IS NULL
	BEGIN
		SELECT TN_CodLaborPersonalJudicial AS CodLaborPersonalJudicial, TC_Descripcion AS Descripcion, TF_InicioVigencia AS FechaActivacion,
			   TF_FinVigencia              AS FechaDesactivacion
		FROM Catalogo.LaborPersonalJudicial  WITH(NOLOCK)
		WHERE TN_CodLaborPersonalJudicial =  COALESCE(@L_TN_CodLaborPersonalJudicial,TN_CodLaborPersonalJudicial)
		AND   dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)         
		AND	  TF_InicioVigencia      <  GETDATE ()
		AND	  (TF_FinVigencia IS NULL OR TF_FinVigencia  >= GETDATE ())
		ORDER BY Descripcion ASC
	END
	--Inactivos
	ELSE  IF @L_TF_InicioVigencia IS NULL AND @L_TF_FinVigencia IS NOT NULL	
	BEGIN
		SELECT TN_CodLaborPersonalJudicial AS CodLaborPersonalJudicial, TC_Descripcion AS Descripcion, TF_InicioVigencia AS FechaActivacion,
			   TF_FinVigencia              AS FechaDesactivacion
		FROM Catalogo.LaborPersonalJudicial	 WITH(NOLOCK)
		WHERE TN_CodLaborPersonalJudicial =  COALESCE(@L_TN_CodLaborPersonalJudicial,TN_CodLaborPersonalJudicial)
		AND   dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)         
		AND	  (TF_InicioVigencia  > GETDATE () Or TF_FinVigencia  < GETDATE ())
		ORDER BY Descripcion ASC
	END
	--Inactivos por fecha
	ELSE  IF @L_TF_InicioVigencia IS NOT NULL AND @L_TF_FinVigencia IS NOT NULL	
	BEGIN
		SELECT TN_CodLaborPersonalJudicial AS CodLaborPersonalJudicial, TC_Descripcion AS Descripcion, TF_InicioVigencia AS FechaActivacion,
			   TF_FinVigencia              AS FechaDesactivacion
		FROM Catalogo.LaborPersonalJudicial	 WITH(NOLOCK)
		WHERE TN_CodLaborPersonalJudicial =  COALESCE(@L_TN_CodLaborPersonalJudicial,TN_CodLaborPersonalJudicial)
		AND   dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)         
		AND	  (TF_InicioVigencia  > @L_TF_InicioVigencia And TF_FinVigencia  < @L_TF_FinVigencia)
		ORDER BY Descripcion ASC
	END
	
	
	END
GO
