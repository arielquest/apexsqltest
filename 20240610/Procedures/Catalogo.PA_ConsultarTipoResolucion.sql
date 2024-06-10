SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Donald Vargas>
-- Fecha de creación:		<13/05/2016>
-- Descripción :			<Permite Consultar un TipoResolucion> 
-- =================================================================================================================================================
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoResolucion a TN_CodTipoResolucion de acuerdo al tipo de dato.>
-- Modificación:			<05/12/2016> <Johan Acosta> Se cambio nombre de TC a TN 
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación				<20/06/2018> <Jonathan Aguilar Navarro> <Se elimina el tipo de oficina de la consulta>  
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoResolucion]
	@Codigo SMALLINT = NULL,
	@Descripcion VARCHAR(100) = NULL,
	@FechaActivacion DATETIME2(7) = NULL,
	@FechaDesactivacion DATETIME2(7) = NULL,
	@TipoOficina SMALLINT = NULL,
	@EnvioSCIJ BIT = NULL
AS
BEGIN

	-- No vigentes hoy
	IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		SELECT 
			A.TN_CodTipoResolucion AS Codigo,
			A.TC_Descripcion AS Descripcion,
			A.TF_Inicio_Vigencia AS FechaActivacion,
			A.TF_Fin_Vigencia AS FechaDesactivacion,
			A.TB_EnvioSCIJ AS EnvioSCIJ
		FROM [Catalogo].[TipoResolucion] AS A WITH(NOLOCK)
		WHERE
			A.TN_CodTipoResolucion = ISNULL(@Codigo, A.TN_CodTipoResolucion) AND
			dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(ISNULL(@Descripcion, A.TC_Descripcion)) + '%' AND
			(
				A.TF_Inicio_Vigencia > GETDATE() OR
				A.TF_Fin_Vigencia < GETDATE()
			) AND
			A.TB_EnvioSCIJ = ISNULL(@EnvioSCIJ, A.TB_EnvioSCIJ)
		Order By	A.TC_Descripcion;
	END

	-- Vigentes en las fechas dadas
	ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		SELECT 
			A.TN_CodTipoResolucion AS Codigo,
			A.TC_Descripcion AS Descripcion,
			A.TF_Inicio_Vigencia AS FechaActivacion,
			A.TF_Fin_Vigencia AS FechaDesactivacion,
			A.TB_EnvioSCIJ AS EnvioSCIJ
		FROM [Catalogo].[TipoResolucion] AS A WITH(NOLOCK)
		WHERE
			A.TN_CodTipoResolucion = ISNULL(@Codigo, A.TN_CodTipoResolucion) AND
			dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(ISNULL(@Descripcion, A.TC_Descripcion)) + '%' AND
			A.TF_Inicio_Vigencia <= ISNULL(@FechaActivacion, A.TF_Inicio_Vigencia) AND
			((A.TF_Fin_Vigencia >= ISNULL(@FechaDesactivacion, A.TF_Fin_Vigencia))) AND
			A.TB_EnvioSCIJ = ISNULL(@EnvioSCIJ, A.TB_EnvioSCIJ)
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
			A.TN_CodTipoResolucion AS Codigo,
			A.TC_Descripcion AS Descripcion,
			A.TF_Inicio_Vigencia AS FechaActivacion,
			A.TF_Fin_Vigencia AS FechaDesactivacion,
			A.TB_EnvioSCIJ AS EnvioSCIJ
		FROM [Catalogo].[TipoResolucion] AS A WITH(NOLOCK)
		WHERE
			A.TN_CodTipoResolucion = ISNULL(@Codigo, A.TN_CodTipoResolucion) AND
			dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE '%' + dbo.FN_RemoverTildes(ISNULL(@Descripcion, A.TC_Descripcion)) + '%' AND
			A.TF_Inicio_Vigencia <= ISNULL(@FechaActivacion, A.TF_Inicio_Vigencia) AND
			((A.TF_Fin_Vigencia IS NULL) OR (A.TF_Fin_Vigencia >= ISNULL(@FechaDesactivacion, A.TF_Fin_Vigencia))) AND
			A.TB_EnvioSCIJ = ISNULL(@EnvioSCIJ, A.TB_EnvioSCIJ)
		Order By	A.TC_Descripcion;

	END

END
GO
