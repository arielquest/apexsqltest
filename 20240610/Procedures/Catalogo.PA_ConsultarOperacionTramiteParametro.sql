SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<06/04/2022>
-- Descripción:			<Permite consultar un registro en la tabla: OperacionTramiteParametro. Según los parámetros definidos>
-- ==================================================================================================================================================================================
-- Modificación:		<27/04/2022><Karol Jiménez Sánchez><Se ajusta tamaño variable @ExpresionLike para que soporte tamaño completo Nombre de 255 caracteres>
-- ==================================================================================================================================================================================
CREATE     PROCEDURE [Catalogo].[PA_ConsultarOperacionTramiteParametro]
	@CodOperacionTramiteParametro		SMALLINT		= NULL,
	@Nombre								VARCHAR(255)	= NULL,
	@FechaActivacion					DATETIME2(7)	= NULL,
	@FechaDesactivacion					DATETIME2(7)	= NULL,
	@CodOperacionTramite				SMALLINT		= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodOperacionTramiteParametro	SMALLINT		= @CodOperacionTramiteParametro,
			@L_TN_CodOperacionTramite			SMALLINT		= @CodOperacionTramite,
			@L_TF_Inicio_Vigencia				DATETIME2(3)	= @FechaActivacion,
			@L_TF_Fin_Vigencia					DATETIME2(3)	= @FechaDesactivacion,
			@ExpresionLike						VARCHAR(260)	= NULL

	--Filtro por descripción
	Set	@ExpresionLike = IIF(@Nombre Is Not Null,'%' + @Nombre + '%','%')

	--Lógica.
	--Todos.
	IF	@L_TF_Inicio_Vigencia IS NULL AND @L_TF_Fin_Vigencia IS NULL
	BEGIN
		SELECT		A.TN_CodOperacionTramiteParametro		Codigo,
					A.TC_Nombre								Nombre,
					A.TC_NombreEstructura					NombreEstructura,
					A.TC_CampoIdentificador					CampoIdentificador,
					A.TC_CampoMostrar						CampoMostrar,
					A.TF_Inicio_Vigencia					FechaActivacion,
					A.TF_Fin_Vigencia						FechaDesactivacion,
					'Split'									Split,
					A.TN_CodOperacionTramite				Codigo
		FROM		Catalogo.OperacionTramiteParametro		A WITH(NOLOCK)
		WHERE		A.TN_CodOperacionTramiteParametro		= COALESCE(@L_TN_CodOperacionTramiteParametro, A.TN_CodOperacionTramiteParametro)
		AND			A.TN_CodOperacionTramite				= COALESCE(@L_TN_CodOperacionTramite, A.TN_CodOperacionTramite)
		AND			(@Nombre								IS NULL					
					OR dbo.FN_RemoverTildes(A.TC_Nombre)	like dbo.FN_RemoverTildes(@ExpresionLike))
		ORDER BY	A.TC_Nombre
	END ELSE
	BEGIN
		--Activos.
		IF	@L_TF_Inicio_Vigencia IS NOT NULL AND @L_TF_Fin_Vigencia IS NULL
		BEGIN
			SELECT			A.TN_CodOperacionTramiteParametro		Codigo,
							A.TC_Nombre								Nombre,
							A.TC_NombreEstructura					NombreEstructura,
							A.TC_CampoIdentificador					CampoIdentificador,
							A.TC_CampoMostrar						CampoMostrar,
							A.TF_Inicio_Vigencia					FechaActivacion,
							A.TF_Fin_Vigencia						FechaDesactivacion,
							'Split'									Split,
							A.TN_CodOperacionTramite				Codigo
			FROM			Catalogo.OperacionTramiteParametro		A WITH(NOLOCK)
			WHERE			A.TF_Inicio_Vigencia					< GETDATE()
			AND				(
								A.TF_Fin_Vigencia					IS NULL
							OR
								A.TF_Fin_Vigencia					>= GETDATE()
							)
			AND				A.TN_CodOperacionTramiteParametro		= COALESCE(@L_TN_CodOperacionTramiteParametro, A.TN_CodOperacionTramiteParametro)
			AND				A.TN_CodOperacionTramite				= COALESCE(@L_TN_CodOperacionTramite, A.TN_CodOperacionTramite)
			AND				(@Nombre								IS NULL					
							OR dbo.FN_RemoverTildes(A.TC_Nombre)	like dbo.FN_RemoverTildes(@ExpresionLike))
			ORDER BY		A.TC_Nombre
		END ELSE
		BEGIN
			--Inactivos.
			IF	@L_TF_Inicio_Vigencia IS NULL AND @L_TF_Fin_Vigencia IS NOT NULL
			BEGIN
				SELECT			A.TN_CodOperacionTramiteParametro		Codigo,
								A.TC_Nombre								Nombre,
								A.TC_NombreEstructura					NombreEstructura,
								A.TC_CampoIdentificador					CampoIdentificador,
								A.TC_CampoMostrar						CampoMostrar,
								A.TF_Inicio_Vigencia					FechaActivacion,
								A.TF_Fin_Vigencia						FechaDesactivacion,
								'Split'									Split,
								A.TN_CodOperacionTramite				Codigo
				FROM			Catalogo.OperacionTramiteParametro		A WITH(NOLOCK)
				WHERE			(
									A.TF_Inicio_Vigencia				> GETDATE()
								OR
									A.TF_Fin_Vigencia					< GETDATE()
								)
				AND				A.TN_CodOperacionTramiteParametro		= COALESCE(@L_TN_CodOperacionTramiteParametro, A.TN_CodOperacionTramiteParametro)
				AND				A.TN_CodOperacionTramite				= COALESCE(@L_TN_CodOperacionTramite, A.TN_CodOperacionTramite)
				AND				(@Nombre								IS NULL					
								OR dbo.FN_RemoverTildes(A.TC_Nombre)	like dbo.FN_RemoverTildes(@ExpresionLike))
				ORDER BY		A.TC_Nombre
			END ELSE
			BEGIN
				--Inactivos por fecha.
				IF	@L_TF_Inicio_Vigencia IS NOT NULL AND @L_TF_Fin_Vigencia IS NOT NULL
				BEGIN
					SELECT			A.TN_CodOperacionTramiteParametro		Codigo,
									A.TC_Nombre								Nombre,
									A.TC_NombreEstructura					NombreEstructura,
									A.TC_CampoIdentificador					CampoIdentificador,
									A.TC_CampoMostrar						CampoMostrar,
									A.TF_Inicio_Vigencia					FechaActivacion,
									A.TF_Fin_Vigencia						FechaDesactivacion,
									'Split'									Split,
									A.TN_CodOperacionTramite				Codigo
					FROM			Catalogo.OperacionTramiteParametro		A WITH(NOLOCK)
					WHERE			(
										A.TF_Inicio_Vigencia				> @L_TF_Inicio_Vigencia
									OR
										A.TF_Fin_Vigencia					< @L_TF_Fin_Vigencia
									)
					AND				A.TN_CodOperacionTramiteParametro		= COALESCE(@L_TN_CodOperacionTramiteParametro, A.TN_CodOperacionTramiteParametro)
					AND				A.TN_CodOperacionTramite				= COALESCE(@L_TN_CodOperacionTramite, A.TN_CodOperacionTramite)
					AND				(@Nombre								IS NULL					
									OR dbo.FN_RemoverTildes(A.TC_Nombre)	like dbo.FN_RemoverTildes(@ExpresionLike))	
					ORDER BY		A.TC_Nombre
				END
			END
		END
	END
END
GO
