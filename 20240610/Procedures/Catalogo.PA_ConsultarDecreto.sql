SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<07/11/2018>
-- Descripción :			<Permite consultar decretos> 
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles Rojas> <07/12/2020> <Se ajusta SP para que cumpla estandar. PBI 157471>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarDecreto]
	@Codigo				VARCHAR(15)  =	NULL,
	@Descripcion		VARCHAR(255) =	NULL,
	@FechaActivacion	DATETIME2    =	NULL,
	@FechaDesactivacion DATETIME2    =	NULL
 AS
 BEGIN

 DECLARE	@L_Codigo				VARCHAR(15)		= @Codigo,
			@L_Descripcion			VARCHAR(255)	= @Descripcion,
			@L_FechaActivacion		DATETIME2		= @FechaActivacion,
			@L_FechaDesactivacion	DATETIME2		= @FechaDesactivacion
  
	DECLARE @L_ExpresionLike VARCHAR(257)
	SET		@L_ExpresionLike = iIf(@L_Descripcion Is Not Null,'%' + @L_Descripcion + '%','%')

	--Activos e inactivos
	IF  @L_FechaActivacion IS NULL AND  @L_FechaDesactivacion IS NULL
	BEGIN
			SELECT		TC_CodigoDecreto      	AS	Codigo,				TC_Descripcion	AS	Descripcion,		
						TF_Inicio_Vigencia	    AS	FechaActivacion,	TF_Fin_Vigencia	AS	FechaDesactivacion,		
						TF_FechaPublicacion		AS	FechaPublicacion
			FROM		Catalogo.Decreto		WITH(NOLOCK) 	
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_ExpresionLike)
	        AND			TC_CodigoDecreto		=  COALESCE(@L_Codigo, TC_CodigoDecreto) 
			ORDER BY	TC_Descripcion;
	END
	 
	--Activos
	ELSE IF  @L_FechaActivacion IS NOT NULL AND @L_FechaDesactivacion IS NULL
	BEGIN
			SELECT		TC_CodigoDecreto	    AS	Codigo,				TC_Descripcion	AS	Descripcion,		
						TF_Inicio_Vigencia	    AS	FechaActivacion,	TF_Fin_Vigencia	AS	FechaDesactivacion,		
						TF_FechaPublicacion		AS	FechaPublicacion
			FROM		Catalogo.Decreto		WITH(NOLOCK) 
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_ExpresionLike)
	        AND			TC_CodigoDecreto		=	Coalesce(@L_Codigo, TC_CodigoDecreto)
			AND			TF_Inicio_Vigencia		<=	GETDATE ()
			AND			(TF_Fin_Vigencia		IS NULL OR TF_Fin_Vigencia  >= GETDATE ()) 
			ORDER BY	TC_Descripcion;
	END

	--Inactivos
	ELSE IF  @L_FechaActivacion Is Null AND @L_FechaDesactivacion  Is Not Null
	BEGIN
			SELECT		TC_CodigoDecreto	    AS	Codigo,				TC_Descripcion	AS	Descripcion,		
						TF_Inicio_Vigencia	    AS	FechaActivacion,	TF_Fin_Vigencia	AS	FechaDesactivacion,		
						TF_FechaPublicacion		AS	FechaPublicacion
			FROM		Catalogo.Decreto		WITH(NOLOCK) 
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@L_ExpresionLike)
	        AND			TC_CodigoDecreto		=	COALESCE(@L_Codigo, TC_CodigoDecreto)
			AND			(TF_Inicio_Vigencia		>	GETDATE () 
			OR			TF_Fin_Vigencia			<	GETDATE ())
			ORDER BY	TC_Descripcion;
	END
	
	--Por rango de fechas
	ELSE IF  @L_FechaActivacion IS NOT NULL AND @L_FechaDesactivacion IS NOT NULL	
	BEGIN
			SELECT		TC_CodigoDecreto		AS	Codigo,				TC_Descripcion	AS	Descripcion,		
						TF_Inicio_Vigencia		AS	FechaActivacion,	TF_Fin_Vigencia	AS	FechaDesactivacion,		
						TF_FechaPublicacion		AS	FechaPublicacion
			FROM		Catalogo.Decreto		WITH(NOLOCK) 
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion) LIKE dbo.FN_RemoverTildes(@L_ExpresionLike)
	        AND			TC_CodigoDecreto		=	COALESCE(@L_Codigo, TC_CodigoDecreto)
			AND			(TF_Inicio_Vigencia		>=	@L_FechaActivacion
			AND			TF_Fin_Vigencia			<=	@L_FechaDesactivacion )
			ORDER BY	TC_Descripcion;
	END	
			
 END
GO
