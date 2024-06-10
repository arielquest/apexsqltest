SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Henry Mendez Chavarria>  
-- Fecha de creación:  <11/08/2015>  
-- Descripción :   <Permite Consultar las Materias de la tabla Catalogo.Materia>   
-- =================================================================================================================================================  
-- Modificación    <Sigifredo Leiton Luna><22/10/2015><Incluir los filtros para poder extraer los registros activos.>   
-- Modificación:   <Andrés Díaz><08/07/2016><Se modifican las consultas para que devuelvan los valores ordenados por descripción.>  
-- Modificación:   <Andrés Díaz><28/11/2016><Se agrega el campo TB_EjecutaRemate.>  
-- Modificación:   <Xinia Soto V.><08/09/2020><Se agrega para cuando sólo se busca por materia.>  
-- Modificación:   <Aida Elena Siles R><10/12/2020><Se agrega parámetro de EjecutaRemate>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarMateria]  
 @CodMateria			VARCHAR(5)		= NULL,  
 @Descripcion			VARCHAR(50)		= NULL,  
 @FechaActivacion		DATETIME2(3)	= NULL,  
 @FechaDesactivacion	DATETIME2		= NULL,
 @EjecutaRemate			BIT				= NULL  
 AS  
 BEGIN
 --Variables locales
 DECLARE	@L_CodMateria			VARCHAR(5)		= @CodMateria,  
			@L_Descripcion			VARCHAR(50)		= @Descripcion,  
			@L_FechaActivacion		DATETIME2(3)	= @FechaActivacion,  
			@L_FechaDesactivacion	DATETIME2		= @FechaDesactivacion,
			@L_EjecutaRemate		BIT				= @EjecutaRemate  

 --Variable para almacenar la descripcion   
 DECLARE @ExpresionLike VARCHAR(55)  
 SET  @ExpresionLike = iif(@L_Descripcion IS NOT NULL,'%' +  @L_Descripcion + '%','%')  
   
  --Si todo es nulo se devuelven todos los registros
 If @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NULL AND @L_Descripcion IS NULL AND @L_CodMateria IS NULL AND @L_EjecutaRemate IS NULL
 BEGIN   
   SELECT	TC_CodMateria		AS Codigo,      
			TC_Descripcion		AS Descripcion,  
			TB_EjecutaRemate	AS EjecutaRemate,  
			TF_Inicio_Vigencia	AS FechaActivacion,   
			TF_Fin_Vigencia		AS FechaDesactivacion  
   FROM		Catalogo.Materia	WITH(NOLOCK)
   ORDER BY TC_Descripcion;  
 END      
   
 ELSE IF @L_FechaDesactivacion IS NULL AND @L_FechaActivacion IS NOT NULL  --ACTIVOS
 BEGIN  
   SELECT	TC_CodMateria		AS Codigo,      
			TC_Descripcion		AS Descripcion,  
			TB_EjecutaRemate	AS EjecutaRemate,  
			TF_Inicio_Vigencia	AS FechaActivacion,   
			TF_Fin_Vigencia		AS FechaDesactivacion  
   FROM		Catalogo.Materia	WITH(NOLOCK)
   WHERE	TC_Descripcion		LIKE @ExpresionLike  
   AND		TF_Inicio_Vigencia  < GETDATE ()  
   AND		(TF_Fin_Vigencia	IS NULL   
			OR 
			TF_Fin_Vigencia		>= GETDATE ())  
   AND		TB_EjecutaRemate	= COALESCE(@L_EjecutaRemate, TB_EjecutaRemate)
   AND		TC_CodMateria		= COALESCE(@L_CodMateria, TC_CodMateria)
   ORDER BY TC_Descripcion;  
 END  
 ELSE IF @L_FechaDesactivacion IS NOT NULL AND @L_FechaActivacion IS NULL  --INACTIVOS
 BEGIN  
   SELECT	TC_CodMateria		AS Codigo,      
			TC_Descripcion		AS Descripcion,  
			TB_EjecutaRemate	AS EjecutaRemate,  
			TF_Inicio_Vigencia	AS FechaActivacion,   
			TF_Fin_Vigencia		AS FechaDesactivacion  
  FROM		Catalogo.Materia	WITH(NOLOCK)
  WHERE		TC_Descripcion		LIKE @ExpresionLike  
  AND		(TF_Inicio_Vigencia > GETDATE ()  
			OR 
			TF_Fin_Vigencia		< GETDATE ())  
  AND		TB_EjecutaRemate	= COALESCE(@L_EjecutaRemate, TB_EjecutaRemate)
  AND		TC_CodMateria		= COALESCE(@L_CodMateria, TC_CodMateria)
  ORDER BY	TC_Descripcion;  
 END 
 ELSE IF @L_FechaDesactivacion IS NULL AND @L_FechaActivacion IS NULL  --ACTIVOS E INACTIVOS
 BEGIN  
   SELECT	TC_CodMateria		AS Codigo,      
			TC_Descripcion		AS Descripcion,  
			TB_EjecutaRemate	AS EjecutaRemate,  
			TF_Inicio_Vigencia	AS FechaActivacion,   
			TF_Fin_Vigencia		AS FechaDesactivacion  
  FROM		Catalogo.Materia	WITH(NOLOCK)
  WHERE		TC_Descripcion		LIKE @ExpresionLike   
  AND		TB_EjecutaRemate	= COALESCE(@L_EjecutaRemate, TB_EjecutaRemate)
  AND		TC_CodMateria		= COALESCE(@L_CodMateria, TC_CodMateria)
  ORDER BY	TC_Descripcion;  
 END  
 ELSE IF @L_FechaDesactivacion IS NOT NULL AND @L_FechaActivacion IS NOT NULL  --POR RANGO FECHAS
 BEGIN  
   SELECT	TC_CodMateria		AS Codigo,      
			TC_Descripcion		AS Descripcion,  
			TB_EjecutaRemate	AS EjecutaRemate,  
			TF_Inicio_Vigencia	AS FechaActivacion,   
			TF_Fin_Vigencia		AS FechaDesactivacion  
  FROM		Catalogo.Materia	WITH(NOLOCK)
  WHERE		TC_Descripcion		LIKE @ExpresionLike  
  AND		TF_Inicio_Vigencia	>= @L_FechaActivacion  
  AND		TF_Fin_Vigencia		<= @L_FechaDesactivacion
  AND		TB_EjecutaRemate	= COALESCE(@L_EjecutaRemate, TB_EjecutaRemate)
  AND		TC_CodMateria		= COALESCE(@L_CodMateria, TC_CodMateria)
  ORDER BY	TC_Descripcion;  
 END 
 END  
  
  
  
GO
