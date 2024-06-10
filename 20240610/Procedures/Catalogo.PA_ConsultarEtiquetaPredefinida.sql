SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<09/12/2019>
-- Descripción:			<Permite consultar un registro en la tabla: EtiquetaPredefinida.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEtiquetaPredefinida]
	@Codigo				SMALLINT			= NULL,
	@Descripcion		VARCHAR(150)		= NULL,
	@InicioVigencia		DATETIME2(3)		= NULL,
	@FinVigencia		DATETIME2(3)		= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodEtiquetaPredefinida	SMALLINT		= @Codigo,
			@L_TF_Inicio_Vigencia	DATETIME2(3)			= @InicioVigencia,
			@L_TF_Fin_Vigencia		DATETIME2(3)			= @FinVigencia,
			@L_TC_Descripcion		VARCHAR(MAX)			= IIF (@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')
	--Lógica.
	--Todos.
	IF	@L_TF_Inicio_Vigencia	IS NULL
	AND	@L_TF_Fin_Vigencia		IS NULL
	BEGIN
		SELECT		TN_CodEtiquetaPredefinida							Codigo,
					TC_Descripcion							Descripcion,
					TF_Inicio_Vigencia						FechaActivacion,
					TF_Fin_Vigencia							FechaDesactivacion
		FROM		Catalogo.EtiquetaPredefinida							WITH(NOLOCK)
		WHERE		dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
		AND			TN_CodEtiquetaPredefinida							= COALESCE(@L_TN_CodEtiquetaPredefinida, TN_CodEtiquetaPredefinida)
		ORDER BY	TC_Descripcion
	END ELSE
	BEGIN
		--Activos.
		IF	@L_TF_Inicio_Vigencia	IS NOT NULL
		AND	@L_TF_Fin_Vigencia		IS NULL
		BEGIN
			SELECT			TN_CodEtiquetaPredefinida							Codigo,
							TC_Descripcion							Descripcion,
							TF_Inicio_Vigencia						FechaActivacion,
							TF_Fin_Vigencia							FechaDesactivacion
			FROM			Catalogo.EtiquetaPredefinida							WITH(NOLOCK)
			WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
			AND				TF_Inicio_Vigencia						< GETDATE()
			AND				(
								TF_Fin_Vigencia						IS NULL
							OR
								TF_Fin_Vigencia						>= GETDATE()
							)
			AND				TN_CodEtiquetaPredefinida							= COALESCE(@L_TN_CodEtiquetaPredefinida, TN_CodEtiquetaPredefinida)
			ORDER BY		TC_Descripcion
		END ELSE
		BEGIN
			--Inactivos.
			IF	@L_TF_Inicio_Vigencia	IS NULL
			AND	@L_TF_Fin_Vigencia		IS NOT NULL
			BEGIN
				SELECT			TN_CodEtiquetaPredefinida							Codigo,
								TC_Descripcion							Descripcion,
								TF_Inicio_Vigencia						FechaActivacion,
								TF_Fin_Vigencia							FechaDesactivacion
				FROM			Catalogo.EtiquetaPredefinida							WITH(NOLOCK)
				WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
				AND				(
									TF_Inicio_Vigencia					> GETDATE()
								OR
									TF_Fin_Vigencia						< GETDATE()
								)
				AND				TN_CodEtiquetaPredefinida							= COALESCE(@L_TN_CodEtiquetaPredefinida, TN_CodEtiquetaPredefinida)
				ORDER BY		TC_Descripcion
			END ELSE
			BEGIN
				--Inactivos por fecha.
				IF	@L_TF_Inicio_Vigencia	IS NOT NULL
				AND	@L_TF_Fin_Vigencia		IS NOT NULL
				BEGIN
					SELECT			TN_CodEtiquetaPredefinida							Codigo,
									TC_Descripcion							Descripcion,
									TF_Inicio_Vigencia						FechaActivacion,
									TF_Fin_Vigencia							FechaDesactivacion
					FROM			Catalogo.EtiquetaPredefinida							WITH(NOLOCK)
					WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
					AND				(
										TF_Inicio_Vigencia					> @L_TF_Inicio_Vigencia
									OR
										TF_Fin_Vigencia						< @L_TF_Fin_Vigencia
									)
					AND				TN_CodEtiquetaPredefinida							= COALESCE(@L_TN_CodEtiquetaPredefinida, TN_CodEtiquetaPredefinida)
					ORDER BY		TC_Descripcion
				END
			END
		END
	END
END
GO
