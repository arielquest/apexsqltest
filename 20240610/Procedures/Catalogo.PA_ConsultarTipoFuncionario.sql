SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:    <1.0>  
-- Creado por:   <Alejandro Villalta>  
-- Fecha de creación: <13/08/2015>  
-- Descripción :  <Permite Consultar tipos de funcionario>   
-- ================================================================================================================================================= 
-- Modificado por:  <Sigifredo Leitón Luna.>  <06/01/2016>  <Se modifica para autogenerar el código de tipo de funcionario - item 5678.>  
-- Modificación:	<Andrés Díaz>	<24/05/2016>	<Se agregan los parametros @FechaActivacion y @FechaDesactivacion, y sus correspondientes consultas.>  
-- Modificación:	<Andrés Díaz>	<08/07/2016>	<Se modifican las consultas para que devuelvan los valores ordenados por descripción.>  
-- Modificado :		<Johan Acosta>  <02/12/2016>	<Se cambio nombre de TC a TN>   
-- Modificado por:  <Diego Chavarria>	<4/10/2017>  <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,  
--													también se elimina el IF Null de Código del select Todos>  
-- Modificación:    <Ailyn López>	<14/12/2017>	<Se ajusta para que al filtrar por descripción se ignoren los acentos>  
-- Modificado por:  <Xinia Soto V.>	<28/05/2020>	<Se agrega filtro de código de oficina>  
-- Modificación:	<Aida Elena Siles>	<29/04/2021>	<Ajuste para que filtre correctamente cuando el parámetro TipoOficina viene NULL>  
-- =================================================================================================================================================  

CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoFuncionario]  
  @Codigo				SMALLINT		= NULL,  
  @Descripcion			VARCHAR(255)	= NULL,  
  @FechaActivacion		DATETIME2		= NULL,  
  @FechaDesactivacion	DATETIME2		= NULL ,
  @TipoOficina			INT				= NULL
 AS  
 BEGIN  
	--Variable para almacenar la descripcion   
	DECLARE @ExpresionLike Varchar(257)  
	SET  @ExpresionLike = iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')  
   
	--Si todo es nulo se devuelven todos los registros  
	 IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL AND @TipoOficina IS NULL   
	 BEGIN   
	   SELECT	TN_CodTipoFuncionario   AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					TF WITH(NOLOCK)
	   WHERE	(TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)) 
	   AND		dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   ORDER BY TC_Descripcion   
	 END 
	 
	 --Si todo es nulo se devuelven todos los registros - Filtro para cuando viene el parámetro TipoOficina  
	 IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL AND @TipoOficina IS NOT NULL   
	 BEGIN   
	   SELECT	TN_CodTipoFuncionario   AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					TF WITH(NOLOCK)
	   WHERE	(TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)  
	   AND		TN_CodTipoFuncionario						IN (SELECT	C.TN_CodTipoFuncionario 
																FROM	Catalogo.TipoOficinaTipoFuncionario C 
																WHERE	C.TN_CodTipoOficina = @TipoOficina)) 
	   AND		dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   ORDER BY TC_Descripcion   
	 END
   
	 --Por activos y filtro por descripcion  
	 ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NULL AND @TipoOficina IS NULL  
	 BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		TF_Inicio_Vigencia							< GETDATE ()  
	   AND		(TF_Fin_Vigencia IS NULL					OR TF_Fin_Vigencia  >= GETDATE ())  
	   AND		(TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)) 
	   ORDER BY TC_Descripcion;  
	 END  

	 --Por activos y filtro por descripcion  - Filtro para cuando viene el parámetro TipoOficina 
	 ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NULL AND @TipoOficina IS NOT NULL  
	 BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		TF_Inicio_Vigencia							< GETDATE ()  
	   AND		(TF_Fin_Vigencia IS NULL					OR TF_Fin_Vigencia	>= GETDATE ())  
	   AND		(TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)  
	   AND		TN_CodTipoFuncionario						IN (SELECT	C.TN_CodTipoFuncionario 
																FROM	Catalogo.TipoOficinaTipoFuncionario C 
																WHERE	C.TN_CodTipoOficina = @TipoOficina)) 
	   ORDER BY TC_Descripcion;  
	 END 
   
	 --Por inactivos y filtro por descripcion  
	 ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL AND @TipoOficina IS NULL    
	 BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		(TF_Inicio_Vigencia							> GETDATE () OR TF_Fin_Vigencia  < GETDATE ())  
	   AND		(TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)) 
	   ORDER BY TC_Descripcion;  
	 END 

	 	 --Por inactivos y filtro por descripcion  - Filtro para cuando viene el parámetro TipoOficina 
	 ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL AND @TipoOficina IS NOT NULL   
	 BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		(TF_Inicio_Vigencia							> GETDATE () OR TF_Fin_Vigencia  < GETDATE ())  
	   AND      (TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)  
	   AND		TN_CodTipoFuncionario						IN (SELECT	C.TN_CodTipoFuncionario 
																FROM	Catalogo.TipoOficinaTipoFuncionario C 
																WHERE	C.TN_CodTipoOficina = @TipoOficina)) 
	   ORDER BY TC_Descripcion;  
	 END  

	  --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos  
	 ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL AND @TipoOficina IS NULL
	  BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		(TF_Fin_Vigencia							<= @FechaDesactivacion	
	   AND		TF_Inicio_Vigencia							>= @FechaActivacion)  
	   AND      (TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)) 
	   ORDER BY TC_Descripcion;  
	  END  

	    --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos  - Filtro para cuando viene el parámetro TipoOficina
	 ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL AND @TipoOficina IS NOT NULL
	  BEGIN  
	   SELECT	TN_CodTipoFuncionario	AS Codigo,			TC_Descripcion AS Descripcion,   
				TF_Inicio_Vigencia		AS FechaActivacion, TF_Fin_Vigencia AS FechaDesactivacion  
	   FROM		Catalogo.TipoFuncionario					WITH(NOLOCK)  
	   WHERE	dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(@ExpresionLike)  
	   AND		(TF_Fin_Vigencia							<= @FechaDesactivacion	
	   AND		TF_Inicio_Vigencia							>= @FechaActivacion)  
	   AND      (TN_CodTipoFuncionario						= COALESCE(@Codigo,TN_CodTipoFuncionario)  
	   AND		TN_CodTipoFuncionario						IN (SELECT	C.TN_CodTipoFuncionario 
																FROM	Catalogo.TipoOficinaTipoFuncionario C 
																WHERE	C.TN_CodTipoOficina = @TipoOficina)) 
	   ORDER BY TC_Descripcion;  
	  END  
 End  
  
  
  
GO
