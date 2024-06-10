SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles Rojas>
-- Fecha de creación:	<16/06/2020>
-- Descripción:			<Permite consultar un registro en la tabla: TipoPuestoTrabajo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoPuestoTrabajo]
	@CodTipoPuestoTrabajo	SMALLINT			= NULL,
	@CodTipoFuncionario		SMALLINT			= NULL,
	@Descripcion			VARCHAR(100)		= NULL,
	@FechaActivacion		DATETIME2(3)		= NULL,
	@FechaDesactivacion		DATETIME2(3)		= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodTipoPuestoTrabajo	SMALLINT		= @CodTipoPuestoTrabajo,
			@L_TN_CodTipoFuncionario	SMALLINT		= @CodTipoFuncionario,
			@L_TF_Inicio_Vigencia		DATETIME2(3)	= @FechaActivacion,
			@L_TF_Fin_Vigencia			DATETIME2(3)	= @FechaDesactivacion,
			@L_TC_Descripcion			VARCHAR(102)	= IIF (@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')
	--Lógica.
	--Todos.
	IF	@L_TF_Inicio_Vigencia	IS NULL
	AND	@L_TF_Fin_Vigencia		IS NULL
	BEGIN
		SELECT		A.TN_CodTipoPuestoTrabajo			    Codigo,
					A.TC_Descripcion						Descripcion,
					A.TF_Inicio_Vigencia					FechaActivacion,
					A.TF_Fin_Vigencia						FechaDesactivacion,
					'SplitTipoFuncionario' 					SplitTipoFuncionario,
					B.TN_CodTipoFuncionario                 Codigo,
					B.TC_Descripcion						Descripcion
		FROM		Catalogo.TipoPuestoTrabajo				A WITH(NOLOCK)
		INNER JOIN	Catalogo.TipoFuncionario				B WITH(NOLOCK)
		ON			A.TN_CodTipoFuncionario					= B.TN_CodTipoFuncionario
		WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE @L_TC_Descripcion
		AND			A.TN_CodTipoPuestoTrabajo				= COALESCE(@L_TN_CodTipoPuestoTrabajo, A.TN_CodTipoPuestoTrabajo)
		AND			A.TN_CodTipoFuncionario					= COALESCE(@L_TN_CodTipoFuncionario, A.TN_CodTipoFuncionario)
		ORDER BY	A.TC_Descripcion
	END ELSE
	BEGIN
		--Activos.
		IF	@L_TF_Inicio_Vigencia	IS NOT NULL
		AND	@L_TF_Fin_Vigencia		IS NULL
		BEGIN
			SELECT			A.TN_CodTipoPuestoTrabajo			    Codigo,
							A.TC_Descripcion						Descripcion,
							A.TF_Inicio_Vigencia					FechaActivacion,
							A.TF_Fin_Vigencia						FechaDesactivacion,
							'SplitTipoFuncionario' 					SplitTipoFuncionario,
							B.TN_CodTipoFuncionario                 Codigo,
							B.TC_Descripcion						Descripcion
			FROM			Catalogo.TipoPuestoTrabajo				A WITH(NOLOCK)
			INNER JOIN		Catalogo.TipoFuncionario				B WITH(NOLOCK)
			ON				A.TN_CodTipoFuncionario					= B.TN_CodTipoFuncionario
			WHERE			dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE @L_TC_Descripcion
			AND				A.TF_Inicio_Vigencia					< GETDATE()
			AND				(
								A.TF_Fin_Vigencia					IS NULL
							OR
								A.TF_Fin_Vigencia					>= GETDATE()
							)
			AND				A.TN_CodTipoPuestoTrabajo				= COALESCE(@L_TN_CodTipoPuestoTrabajo, A.TN_CodTipoPuestoTrabajo)
			AND				A.TN_CodTipoFuncionario					= COALESCE(@L_TN_CodTipoFuncionario, A.TN_CodTipoFuncionario)
			ORDER BY		A.TC_Descripcion
		END ELSE
		BEGIN
			--Inactivos.
			IF	@L_TF_Inicio_Vigencia	IS NULL
			AND	@L_TF_Fin_Vigencia		IS NOT NULL
			BEGIN
				SELECT			A.TN_CodTipoPuestoTrabajo			    Codigo,
								A.TC_Descripcion						Descripcion,
								A.TF_Inicio_Vigencia					FechaActivacion,
								A.TF_Fin_Vigencia						FechaDesactivacion,
								'SplitTipoFuncionario' 					SplitTipoFuncionario,
								B.TN_CodTipoFuncionario                 Codigo,
								B.TC_Descripcion						Descripcion
				FROM			Catalogo.TipoPuestoTrabajo				A WITH(NOLOCK)
				INNER JOIN		Catalogo.TipoFuncionario				B WITH(NOLOCK)
				ON				A.TN_CodTipoFuncionario					= B.TN_CodTipoFuncionario
				WHERE			dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE @L_TC_Descripcion
				AND				(
									A.TF_Inicio_Vigencia				> GETDATE()
								OR
									A.TF_Fin_Vigencia					< GETDATE()
								)
				AND				A.TN_CodTipoPuestoTrabajo				= COALESCE(@L_TN_CodTipoPuestoTrabajo, A.TN_CodTipoPuestoTrabajo)
				AND				A.TN_CodTipoFuncionario					= COALESCE(@L_TN_CodTipoFuncionario, A.TN_CodTipoFuncionario)
				ORDER BY		A.TC_Descripcion
			END ELSE
			BEGIN
				--Inactivos por fecha.
				IF	@L_TF_Inicio_Vigencia	IS NOT NULL
				AND	@L_TF_Fin_Vigencia		IS NOT NULL
				BEGIN
					SELECT			A.TN_CodTipoPuestoTrabajo			    Codigo,
									A.TC_Descripcion						Descripcion,
									A.TF_Inicio_Vigencia					FechaActivacion,
									A.TF_Fin_Vigencia						FechaDesactivacion,
									'SplitTipoFuncionario' 					SplitTipoFuncionario,
									B.TN_CodTipoFuncionario                 Codigo,
									B.TC_Descripcion						Descripcion
					FROM			Catalogo.TipoPuestoTrabajo				A WITH(NOLOCK)
					INNER JOIN		Catalogo.TipoFuncionario				B WITH(NOLOCK)
					ON				A.TN_CodTipoFuncionario					= B.TN_CodTipoFuncionario
					WHERE			dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE @L_TC_Descripcion
					AND				(
										A.TF_Inicio_Vigencia				> @L_TF_Inicio_Vigencia
									OR
										A.TF_Fin_Vigencia					< @L_TF_Fin_Vigencia
									)
					AND				A.TN_CodTipoPuestoTrabajo				= COALESCE(@L_TN_CodTipoPuestoTrabajo, A.TN_CodTipoPuestoTrabajo)
					AND				A.TN_CodTipoFuncionario					= COALESCE(@L_TN_CodTipoFuncionario, A.TN_CodTipoFuncionario)
					ORDER BY		A.TC_Descripcion
				END
			END
		END
	END
END
GO
