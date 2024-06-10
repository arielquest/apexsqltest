SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<31/12/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Catalogo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCatalogo]
	@CodCatalogo		SMALLINT		NULL,
	@Descripcion		VARCHAR(150)	NULL	
AS
BEGIN
	--Variables.
	DECLARE	@L_TC_Descripcion		VARCHAR(MAX)	= IIF(@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%'),
			@L_TN_CodCatalogo		SMALLINT		= @CodCatalogo
	
	--Lógica.
	SELECT		TN_CodCatalogo							Codigo,
				TC_Descripcion							Descripcion,
				TB_Controlador							Controlador,
				TC_DescripcionUrl						DescripcionUrl,
				TC_CatalogoSiagpj						CatalogoSiagpj,
				TF_Inicio_Vigencia						FechaActivacion,
				TF_Fin_Vigencia							FechaDesactivacion
	FROM		Catalogo.Catalogo						WITH(NOLOCK)
	WHERE		dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
	AND			TN_CodCatalogo							= COALESCE(@L_TN_CodCatalogo, TN_CodCatalogo)
	ORDER BY	TC_Descripcion
	
END
GO
