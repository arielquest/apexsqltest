SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<13/07/2021>
-- Descripción:			<Permite consultar los registros en la tabla: CriterioRepartoManual.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCriterioRepartoManual]
	@TN_CodCriterioRepartoManual	INT,
	@TC_Descripcion					VARCHAR(120),
	@TF_Inicio_Vigencia				DATETIME2(3),
	@TF_Fin_Vigencia				DATETIME2(3)	=	NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodCriterioRepartoManual	INT			=	@TN_CodCriterioRepartoManual,
			@L_TF_Inicio_Vigencia			DATETIME2(3)=	@TF_Inicio_Vigencia,
			@L_TF_Fin_Vigencia				DATETIME2(3)=	@TF_Fin_Vigencia,
			@L_TC_Descripcion				VARCHAR(Max)=	Iif (@TC_Descripcion IS NOT NULL, '%' + @TC_Descripcion + '%', '%')
	--Lógica.
	If  @L_TF_Inicio_Vigencia IS NULL
	AND @L_TF_Fin_Vigencia IS NULL
	AND @L_TN_CodCriterioRepartoManual IS NULL
	BEGIN --Todos:
		SELECT		TN_CodCriterioRepartoManual		Codigo,
					TC_Descripcion					Descripcion,
					TF_Inicio_Vigencia				FechaActivacion,
					TF_Fin_Vigencia					FechaDesactivacion
		FROM		Catalogo.CriterioRepartoManual	With(NoLock)
		WHERE		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
		ORDER BY	TC_Descripcion
	END ELSE
	BEGIN --Por llave:
		IF @L_TN_CodCriterioRepartoManual IS NOT NULL
		BEGIN
			SELECT		TN_CodCriterioRepartoManual		Codigo,
						TC_Descripcion					Descripcion,
						TF_Inicio_Vigencia				FechaActivacion,
						TF_Fin_Vigencia					FechaDesactivacion
			FROM		Catalogo.CriterioRepartoManual	With(NoLock)
			WHERE		TN_CodCriterioRepartoManual		=	@L_TN_CodCriterioRepartoManual
			ORDER BY	TC_Descripcion
		END ELSE
		BEGIN --Por activos y filtro de descripción:
			If @L_TF_Inicio_Vigencia IS NOT NULL
			AND @L_TF_Fin_Vigencia IS NULL
			BEGIN
				SELECT	TN_CodCriterioRepartoManual		Codigo,
						TC_Descripcion					Descripcion,
						TF_Inicio_Vigencia				FechaActivacion,
						TF_Fin_Vigencia					FechaDesactivacion
				FROM	Catalogo.CriterioRepartoManual	With(NoLock)
				WHERE	dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
				AND		TF_Inicio_Vigencia	< GetDate()
				AND		(
							TF_Fin_Vigencia	IS NULL
				OR		
							TF_Fin_Vigencia	>= GetDate()
						)
				ORDER BY	TC_Descripcion
			END ELSE
			BEGIN --Por activos:
				If @L_TF_Fin_Vigencia IS NULL
				BEGIN
					SELECT	TN_CodCriterioRepartoManual		Codigo,
							TC_Descripcion					Descripcion,
							TF_Inicio_Vigencia				FechaActivacion,
							TF_Fin_Vigencia					FechaDesactivacion
					FROM	Catalogo.CriterioRepartoManual	With(NoLock)
					WHERE	dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion)
					AND			(
									TF_Fin_Vigencia	> GetDate()
					OR
									TF_Fin_Vigencia	< GetDate()
								)
					ORDER BY	TC_Descripcion
				END 
				ELSE				
				--Inactivos
				If @L_TF_Inicio_Vigencia IS NULL AND @L_TF_Fin_Vigencia IS NOT NULL	
					BEGIN
						SELECT		TN_CodCriterioRepartoManual		Codigo,				
									TC_Descripcion					Descripcion,
									TF_Inicio_Vigencia				FechaActivacion,	
									TF_Fin_Vigencia					FechaDesactivacion
						FROM		Catalogo.CriterioRepartoManual	With(Nolock) 
						WHERE		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
						AND			(
										TF_Inicio_Vigencia  > GETDATE () 
						OR 
										TF_Fin_Vigencia  < GETDATE ()
									)
						ORDER BY	TC_Descripcion;
					END	
				Else
					BEGIN --Si las dos fechas no son nulas, se listan los datos por rango de fechas de los inactivos
					IF @L_TF_Inicio_Vigencia IS NOT NULL	AND	@L_TF_Fin_Vigencia IS NOT NULL
					BEGIN
						SELECT		TN_CodCriterioRepartoManual		Codigo,
									TC_Descripcion					Descripcion,
									TF_Inicio_Vigencia				FechaActivacion,
									TF_Fin_Vigencia					FechaDesactivacion
						FROM		Catalogo.CriterioRepartoManual	With(NoLock)
						WHERE		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@L_TC_Descripcion) 
						AND			(
										TF_Fin_Vigencia		<= @L_TF_Fin_Vigencia
						AND
										TF_Inicio_Vigencia	>= @L_TF_Inicio_Vigencia
									)
						ORDER BY	TC_Descripcion
					END
				END
			END
		END
	END
END
GO
