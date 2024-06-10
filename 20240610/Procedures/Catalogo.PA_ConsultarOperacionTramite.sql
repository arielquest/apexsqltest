SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<08/04/2022>
-- Descripcion:			<Consulta operaciones para trámites de encadenamiento>
-- =========================================================================================================================================
-- Modificacion:		<Jose Gabriel Cordero Soto><28/04/2022><Se ajusta tamaño variable @ExpresionLike para que soporte tamaño completo Nombre de 255 caracteres>
-- Modificacion:		<Rafa Badilla Alvarado><30/05/2022><Se ajusta el ordenamiento por el campo nombre de forma ascendente>
-- Modificacion:		<Karol Jiménez Sánchez><13/06/2022><Se agrega funcionalidad para poder consultar una lista de formatos jurídicos por el parámetro @CodigosOperaciones, enviandolos separados por ',' (coma) cuando se requieren consultar varios>
-- =========================================================================================================================================
CREATE        PROCEDURE [Catalogo].[PA_ConsultarOperacionTramite] 
	@CodOperacionTramite		SMALLINT		= NULL,
	@Descripcion				VARCHAR(255)	= NULL,
	@Pantalla					INT				= NULL,
	@FechaActivacion			DATETIME2(7)	= NULL,
	@FechaDesactivacion			DATETIME2(7)	= NULL,
	@CodigosOperaciones			VARCHAR(2000)	= NULL
AS
BEGIN
	--Variables locales
	DECLARE @L_CodOperacionTramite		SMALLINT		= @CodOperacionTramite,
			@L_Pantalla					VARCHAR(8)		= @Pantalla,
			@L_FechaActivacion			DATETIME2(7)	= @FechaActivacion,
			@L_FechaDesactivacion		DATETIME2(7)	= @FechaDesactivacion,
			@ExpresionLike				VARCHAR(260)    = null,
			@L_CodigosOperaciones		VARCHAR(2000)	= @CodigosOperaciones

	--Filtro por descripción
	Set	@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')


	IF (@L_CodigosOperaciones IS NOT NULL) 
	BEGIN
				SELECT  O.[TN_CodOperacionTramite]				Codigo,
						O.[TC_Nombre]							Nombre,	
						O.[TC_Descripcion]						Descripcion,
						O.[TF_Inicio_Vigencia]					FechaActivacion,
						O.[TF_Fin_Vigencia]						FechaDesactivacion,
						'Split'									Split,
						O.[TN_Pantalla]							Pantalla
				FROM	Catalogo.OperacionTramite				O	WITH(NOLOCK)
				WHERE	O.TN_CodOperacionTramite				In (	SELECT	value  
																		FROM	STRING_SPLIT(@L_CodigosOperaciones, ','))	
				ORDER BY O.[TC_Nombre]	
	END
	ELSE
	BEGIN
		--Todos
		IF  @L_FechaActivacion IS NULL AND  @L_FechaDesactivacion IS NULL
		BEGIN
				SELECT  O.[TN_CodOperacionTramite]				Codigo,
						O.[TC_Nombre]							Nombre,	
						O.[TC_Descripcion]						Descripcion,
						O.[TF_Inicio_Vigencia]					FechaActivacion,
						O.[TF_Fin_Vigencia]						FechaDesactivacion,
						'Split'									Split,
						O.[TN_Pantalla]							Pantalla
				FROM	Catalogo.OperacionTramite				O	WITH(NOLOCK)
				WHERE	O.[TN_CodOperacionTramite]				= COALESCE(@L_CodOperacionTramite, O.[TN_CodOperacionTramite])								
				AND		O.[TN_Pantalla]	  						= COALESCE(@L_Pantalla, O.[TN_Pantalla]	)
				AND		( dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
				OR	dbo.FN_RemoverTildes(TC_Nombre) like dbo.FN_RemoverTildes(@ExpresionLike))
				ORDER BY O.[TC_Nombre]	
		END
	
		--Activos
		ELSE IF  @L_FechaActivacion IS NOT NULL AND  @L_FechaDesactivacion IS NULL 
		BEGIN
				SELECT  O.[TN_CodOperacionTramite]				Codigo,
						O.[TC_Nombre]							Nombre,	
						O.[TC_Descripcion]						Descripcion,
						O.[TF_Inicio_Vigencia]					FechaActivacion,
						O.[TF_Fin_Vigencia]						FechaDesactivacion,
						'Split'									Split,
						O.[TN_Pantalla]							Pantalla
				FROM	Catalogo.OperacionTramite				O	WITH(NOLOCK)
				WHERE	O.[TN_CodOperacionTramite]				=  COALESCE(@L_CodOperacionTramite, O.[TN_CodOperacionTramite])								
				AND		O.[TN_Pantalla]	  						=  COALESCE(@L_Pantalla, O.[TN_Pantalla])
				AND		O.[TF_Inicio_Vigencia]					<= GETDATE()
				AND		(O.[TF_Fin_Vigencia]	IS	NULL OR O.[TF_Fin_Vigencia]  >= GETDATE())
				AND		( dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
				OR	dbo.FN_RemoverTildes(TC_Nombre) like dbo.FN_RemoverTildes(@ExpresionLike))
				ORDER BY O.[TC_Nombre]	

		END

		--Inactivos
		ELSE IF  @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NOT NULL
		BEGIN
				SELECT  O.[TN_CodOperacionTramite]				Codigo,
						O.[TC_Nombre]							Nombre,	
						O.[TC_Descripcion]						Descripcion,
						O.[TF_Inicio_Vigencia]					FechaActivacion,
						O.[TF_Fin_Vigencia]						FechaDesactivacion,
						'Split'									Split,
						O.[TN_Pantalla]							Pantalla
				FROM	Catalogo.OperacionTramite				O	WITH(NOLOCK)
				WHERE	O.[TN_CodOperacionTramite]				= COALESCE(@L_CodOperacionTramite, O.[TN_CodOperacionTramite])								
				AND		O.[TN_Pantalla]	  						= COALESCE(@L_Pantalla, O.[TN_Pantalla]	)
				AND		(O.[TF_Inicio_Vigencia]					> GETDATE()
				OR		O.[TF_Fin_Vigencia]						< GETDATE())
				AND		( dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
				OR	dbo.FN_RemoverTildes(TC_Nombre) like dbo.FN_RemoverTildes(@ExpresionLike))
				ORDER BY O.[TC_Nombre]	
		END

		--Por rango de fechas
		Else If  @FechaActivacion IS NOT NULL AND @FechaDesactivacion  IS NOT NULL		
		BEGIN
				SELECT  O.[TN_CodOperacionTramite]				Codigo,
						O.[TC_Nombre]							Nombre,	
						O.[TC_Descripcion]						Descripcion,
						O.[TF_Inicio_Vigencia]					FechaActivacion,
						O.[TF_Fin_Vigencia]						FechaDesactivacion,
						'Split'									Split,
						O.[TN_Pantalla]							Pantalla
				FROM	Catalogo.OperacionTramite				O	WITH(NOLOCK)
				WHERE	O.[TN_CodOperacionTramite]				= COALESCE(@L_CodOperacionTramite, O.[TN_CodOperacionTramite])									
				AND		O.[TN_Pantalla]	  						= COALESCE(@L_Pantalla, O.[TN_Pantalla]	)
				AND		(O.[TF_Inicio_Vigencia]					>= @L_FechaActivacion
				AND		O.[TF_Fin_Vigencia]						<= @L_FechaDesactivacion)
				AND		( dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
				OR	dbo.FN_RemoverTildes(TC_Nombre) like dbo.FN_RemoverTildes(@ExpresionLike))
				ORDER BY O.[TC_Nombre]	
		END	
	END
END

GO
