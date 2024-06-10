SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<03/09/2018>
-- Descripción :			<Permite Consultar categorias de resolución> 

CREATE PROCEDURE [Catalogo].[PA_ConsultarCategoriaResolucion]
	@Codigo				int = NULL,
	@Descripcion		varchar(255) = NULL,
	@FechaActivacion	datetime2(7) = NULL,
	@FechaDesactivacion datetime2(7) = NULL

AS
BEGIN

	-- No vigentes hoy
	IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		SELECT 
				A.TN_CodCategoriaResolucion			AS Codigo,
				A.TC_Descripcion					AS Descripcion,
				A.TF_Inicio_Vigencia				AS FechaActivacion,
				A.TF_Fin_Vigencia					AS FechaDesactivacion
		FROM	[Catalogo].[CategoriaResolucion]	AS A WITH(NOLOCK)
		WHERE
				A.TN_CodCategoriaResolucion			= COALESCE(@Codigo, A.TN_CodCategoriaResolucion) AND
				dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(ISNULL(@Descripcion, A.TC_Descripcion)) + '%' AND
				(
					A.TF_Inicio_Vigencia			> GETDATE() OR
					A.TF_Fin_Vigencia				< GETDATE()
				) 
		Order By	A.TC_Descripcion;
	END

	-- Vigentes en las fechas dadas
	ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		SELECT 
				A.TN_CodCategoriaResolucion			AS Codigo,
				A.TC_Descripcion					AS Descripcion,
				A.TF_Inicio_Vigencia				AS FechaActivacion,
				A.TF_Fin_Vigencia					AS FechaDesactivacion
		FROM	[Catalogo].[CategoriaResolucion]	AS A WITH(NOLOCK)
		WHERE
				A.TN_CodCategoriaResolucion			= COALESCE(@Codigo, A.TN_CodCategoriaResolucion) AND
				dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(ISNULL(@Descripcion, A.TC_Descripcion)) + '%' AND
				A.TF_Inicio_Vigencia				<= COALESCE(@FechaActivacion, A.TF_Inicio_Vigencia) AND
				((A.TF_Fin_Vigencia					>= COALESCE(@FechaDesactivacion, A.TF_Fin_Vigencia)))
		Order By	A.TC_Descripcion;
	END

	ELSE
	BEGIN

		-- Vigentes hoy		
		IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NULL
		BEGIN
			SET @FechaActivacion = GETDATE()
			SET @FechaDesactivacion = GETDATE()
		END

		-- Si los dos parámetros de fechas son nulos, devuelve todos
		SELECT 
				A.TN_CodCategoriaResolucion			AS Codigo,
				A.TC_Descripcion					AS Descripcion,
				A.TF_Inicio_Vigencia				AS FechaActivacion,
				A.TF_Fin_Vigencia					AS FechaDesactivacion
		FROM	[Catalogo].[CategoriaResolucion]	AS A WITH(NOLOCK)
		WHERE
				A.TN_CodCategoriaResolucion				= COALESCE(@Codigo, A.TN_CodCategoriaResolucion) AND
				dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(COALESCE(@Descripcion, A.TC_Descripcion)) + '%' AND
				A.TF_Inicio_Vigencia				<= COALESCE(@FechaActivacion, A.TF_Inicio_Vigencia) AND
				((A.TF_Fin_Vigencia IS NULL) 
				OR (A.TF_Fin_Vigencia				>= COALESCE(@FechaDesactivacion, A.TF_Fin_Vigencia)))
		Order By	A.TC_Descripcion;

	END

END
GO
