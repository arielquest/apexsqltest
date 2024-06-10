SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<20/01/2020>
-- Descripción:			<Permite consultar un registro en la tabla: TipoRechazoSolicitudDefensor.>
-- Modificación:		<13/03/2020> <AIDA E SILES> <No se realiza ninguna modificación en el SP simplemente se cambia a alter para que lo vuelvan a correr, corregir BUG 115588>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoRechazoSolicitudDefensor]
	@Codigo											SMALLINT		= NULL,
	@Descripcion									VARCHAR(150)	= NULL,
	@FechaActivacion								DATETIME2(7)	= NULL,
	@FechaDesactivacion								DATETIME2(7)	= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodTipoRechazoSolicitudDefensor	SMALLINT		= @Codigo,
			@L_TF_Inicio_Vigencia					DATETIME2(7)	= @FechaActivacion,
			@L_TF_Fin_Vigencia						DATETIME2(7)	= @FechaDesactivacion,
			@L_TC_Descripcion						VARCHAR(152)	= IIF (@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')
	--Lógica.
	--Todos.
	IF	@L_TF_Inicio_Vigencia	IS NULL
	AND	@L_TF_Fin_Vigencia		IS NULL
	BEGIN
		SELECT		TN_CodTipoRechazoSolicitudDefensor		Codigo,
					TC_Descripcion							Descripcion,
					TF_Inicio_Vigencia						FechaActivacion,
					TF_Fin_Vigencia							FechaDesactivacion
		FROM		Catalogo.TipoRechazoSolicitudDefensor	WITH(NOLOCK)
		WHERE		dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
		AND			TN_CodTipoRechazoSolicitudDefensor		= COALESCE(@L_TN_CodTipoRechazoSolicitudDefensor, TN_CodTipoRechazoSolicitudDefensor)
		ORDER BY	TC_Descripcion
	END ELSE
	BEGIN
		--Activos.
		IF	@L_TF_Inicio_Vigencia	IS NOT NULL
		AND	@L_TF_Fin_Vigencia		IS NULL
		BEGIN
			SELECT			TN_CodTipoRechazoSolicitudDefensor		Codigo,
							TC_Descripcion							Descripcion,
							TF_Inicio_Vigencia						FechaActivacion,
							TF_Fin_Vigencia							FechaDesactivacion
			FROM			Catalogo.TipoRechazoSolicitudDefensor	WITH(NOLOCK)
			WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
			AND				TF_Inicio_Vigencia						< GETDATE()
			AND				(
								TF_Fin_Vigencia						IS NULL
							OR
								TF_Fin_Vigencia						>= GETDATE()
							)
			AND				TN_CodTipoRechazoSolicitudDefensor		= COALESCE(@L_TN_CodTipoRechazoSolicitudDefensor, TN_CodTipoRechazoSolicitudDefensor)
			ORDER BY		TC_Descripcion
		END ELSE
		BEGIN
			--Inactivos.
			IF	@L_TF_Inicio_Vigencia	IS NULL
			AND	@L_TF_Fin_Vigencia		IS NOT NULL
			BEGIN
				SELECT			TN_CodTipoRechazoSolicitudDefensor							Codigo,
								TC_Descripcion							Descripcion,
								TF_Inicio_Vigencia						FechaActivacion,
								TF_Fin_Vigencia							FechaDesactivacion
				FROM			Catalogo.TipoRechazoSolicitudDefensor	WITH(NOLOCK)
				WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
				AND				(
									TF_Inicio_Vigencia					> GETDATE()
								OR
									TF_Fin_Vigencia						< GETDATE()
								)
				AND				TN_CodTipoRechazoSolicitudDefensor		= COALESCE(@L_TN_CodTipoRechazoSolicitudDefensor, TN_CodTipoRechazoSolicitudDefensor)
				ORDER BY		TC_Descripcion
			END ELSE
			BEGIN
				--Inactivos por fecha.
				IF	@L_TF_Inicio_Vigencia	IS NOT NULL
				AND	@L_TF_Fin_Vigencia		IS NOT NULL
				BEGIN
					SELECT			TN_CodTipoRechazoSolicitudDefensor							Codigo,
									TC_Descripcion							Descripcion,
									TF_Inicio_Vigencia						FechaActivacion,
									TF_Fin_Vigencia							FechaDesactivacion
					FROM			Catalogo.TipoRechazoSolicitudDefensor	WITH(NOLOCK)
					WHERE			dbo.FN_RemoverTildes(TC_Descripcion)	LIKE @L_TC_Descripcion
					AND				(
										TF_Inicio_Vigencia					> @L_TF_Inicio_Vigencia
									OR
										TF_Fin_Vigencia						< @L_TF_Fin_Vigencia
									)
					AND				TN_CodTipoRechazoSolicitudDefensor			= COALESCE(@L_TN_CodTipoRechazoSolicitudDefensor, TN_CodTipoRechazoSolicitudDefensor)
					ORDER BY		TC_Descripcion
				END
			END
		END
	END
END
GO
