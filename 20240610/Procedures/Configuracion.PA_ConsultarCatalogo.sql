SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<31/12/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Catalogo.>
--
-- Modificacion: [27/01/2021] Miguel Avendaño : Se mueve a esquema configuracion y se agrega enlace con catalodo de sistemas
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarCatalogo]
	@Sistema			SMALLINT		NULL,
	@CodCatalogo		SMALLINT		NULL,
	@Descripcion		VARCHAR(150)	NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TC_Descripcion		VARCHAR(MAX)	= IIF(@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%'),
			@L_TN_CodCatalogo		SMALLINT		= @CodCatalogo,
			@L_TN_CodSistema		SMALLINT		= @Sistema
	
	--Listar por descripcion
	IF	@Descripcion	IS NOT NULL
		BEGIN
			SELECT		A.TN_CodCatalogo						As Codigo,
						A.TC_Descripcion						As Descripcion,
						A.TB_Controlador						As Controlador,
						A.TC_DescripcionUrl						As DescripcionUrl,
						A.TC_CatalogoSiagpj						As CatalogoSiagpj,
						'Split'									As Split,
						B.TN_CodSistema							As Codigo,
						B.TC_Siglas								As Siglas,
						B.TC_Descripcion						As Descripcion,
						B.TF_Inicio_Vigencia					As FechaActivacion,
						B.TF_Fin_Vigencia						As FechaDesactivacion
			FROM		Configuracion.Catalogo					A WITH(NOLOCK)
			INNER JOIN	Configuracion.Sistema					B WITH(NOLOCK)
			ON			B.TN_CodSistema							= A.TN_CodSistema
			WHERE		A.TN_CodSistema							= COALESCE(@L_TN_CodSistema, A.TN_CodSistema)
			AND			A.TC_Descripcion						LIKE @L_TC_Descripcion 
			ORDER BY	A.TC_Descripcion
		END
	ELSE IF	@CodCatalogo	IS NOT NULL
				BEGIN
					SELECT	A.TN_CodCatalogo						As Codigo,
							A.TC_Descripcion						As Descripcion,
							A.TB_Controlador						As Controlador,
							A.TC_DescripcionUrl						As DescripcionUrl,
							A.TC_CatalogoSiagpj						As CatalogoSiagpj,
							'Split'									As Split,
							B.TN_CodSistema							As Codigo,
							B.TC_Siglas								As Siglas,
							B.TC_Descripcion						As Descripcion,
							B.TF_Inicio_Vigencia					As FechaActivacion,
							B.TF_Fin_Vigencia						As FechaDesactivacion
				FROM		Configuracion.Catalogo					A WITH(NOLOCK)
				INNER JOIN	Configuracion.Sistema					B WITH(NOLOCK)
				ON			B.TN_CodSistema							= A.TN_CodSistema
				WHERE		A.TN_CodSistema							= COALESCE(@L_TN_CodSistema, A.TN_CodSistema)
				AND			A.TN_CodCatalogo						= COALESCE(@L_TN_CodCatalogo, A.TN_CodCatalogo) 
				ORDER BY	A.TC_Descripcion
			END
		ELSE
			BEGIN
				SELECT		A.TN_CodCatalogo						As Codigo,
							A.TC_Descripcion						As Descripcion,
							A.TB_Controlador						As Controlador,
							A.TC_DescripcionUrl						As DescripcionUrl,
							A.TC_CatalogoSiagpj						As CatalogoSiagpj,
							'Split'									As Split,
							B.TN_CodSistema							As Codigo,
							B.TC_Siglas								As Siglas,
							B.TC_Descripcion						As Descripcion,
							B.TF_Inicio_Vigencia					As FechaActivacion,
							B.TF_Fin_Vigencia						As FechaDesactivacion
				FROM		Configuracion.Catalogo					A WITH(NOLOCK)
				INNER JOIN	Configuracion.Sistema					B WITH(NOLOCK)
				ON			B.TN_CodSistema							= A.TN_CodSistema
				WHERE		A.TN_CodSistema							= COALESCE(@L_TN_CodSistema, A.TN_CodSistema)
				ORDER BY	A.TC_Descripcion
			END
END
GO
