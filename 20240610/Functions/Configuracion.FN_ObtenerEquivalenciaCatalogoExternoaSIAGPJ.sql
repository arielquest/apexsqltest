SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<28/09/2021>
-- Descripción :			<Obtiene el valor de equivalencia de SIAGPJ, para un catálogo; según el valor del catálogo del sistema externo> 
-- =================================================================================================================================================
CREATE FUNCTION [Configuracion].[FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ]
(
	@CodContexto				VARCHAR(4),	
	@CatalogoSiagpj				VARCHAR(256),
	@ValorExterno				VARCHAR(40),
	@EsEquivalenciaCronos		BIT				= 0,
	@EsEquivalenciaSSC			BIT				= 0
)
RETURNS VARCHAR(40)
AS
BEGIN
	DECLARE @L_TC_CodContexto				VARCHAR(4)		= @CodContexto,
			@L_TC_CatalogoSIAGPJ			VARCHAR(256)	= @CatalogoSiagpj,
			@L_TC_ValorExterno				VARCHAR(40)		= @ValorExterno,
			@L_EsEquivalenciaCronos			BIT				= @EsEquivalenciaCronos,
			@L_EsEquivalenciaSSC			BIT				= @EsEquivalenciaSSC,
			@L_TC_ValorSIAGPJ				VARCHAR(40),
			@L_TC_CodMateria				VARCHAR(5),
			@L_TN_CodTipoOficina			SMALLINT,
			@L_TN_CodCatalogo				SMALLINT,
			@L_CodSistemaExterno			SMALLINT
			
	IF 	(@L_EsEquivalenciaCronos = 0 AND @L_EsEquivalenciaSSC = 0)
		SELECT	TOP 1 @L_CodSistemaExterno	= CASE	WHEN C.TC_CodConfiguracion IS NULL THEN 0
												ELSE CONVERT(SMALLINT, C.TC_Valor)
											END
		FROM	Configuracion.ConfiguracionValor	C WITH(NOLOCK) 
		WHERE	C.TC_CodConfiguracion				= 'U_SistemaExternoSCGDJ';

	IF (@L_EsEquivalenciaCronos = 1)
		SELECT	TOP 1 @L_CodSistemaExterno	= CASE	WHEN C.TC_CodConfiguracion IS NULL THEN 0
												ELSE CONVERT(SMALLINT, C.TC_Valor)
											END
		FROM	Configuracion.ConfiguracionValor	C WITH(NOLOCK) 
		WHERE	C.TC_CodConfiguracion				= 'U_SistemaExternoCronos';

	IF (@L_EsEquivalenciaSSC = 1)
		SELECT	TOP 1 @L_CodSistemaExterno	= CASE	WHEN C.TC_CodConfiguracion IS NULL THEN 0
												ELSE CONVERT(SMALLINT, C.TC_Valor)
											END
		FROM	Configuracion.ConfiguracionValor	C WITH(NOLOCK) 
		WHERE	C.TC_CodConfiguracion				= 'U_SistemaExternoSSC';
	
	SELECT		TOP 1 @L_TN_CodCatalogo =	C.TN_CodCatalogo
	FROM		Configuracion.Catalogo	C	WITH(NOLOCK)
	WHERE		C.TC_CatalogoSiagpj		=	@L_TC_CatalogoSIAGPJ
	AND			C.TN_CodSistema			=	@L_CodSistemaExterno

	/*SE BUSCA EQUIVALENCIA POR CONTEXTO EN ESPECÍFICO*/
	SELECT		TOP 1 @L_TC_ValorSIAGPJ		=  E.TC_ValorSIAGPJ
	FROM		Configuracion.Equivalencia	E WITH(NOLOCK)
	WHERE		E.TN_CodCatalogo			= @L_TN_CodCatalogo
	AND			E.TC_ValorExterno			= @L_TC_ValorExterno
	AND			E.TC_CodContexto			= @L_TC_CodContexto

	IF (@L_TC_ValorSIAGPJ IS NULL)
	BEGIN
			/*SE BUSCA LA MATERIA Y TIPO DE OFICINA DEL CONTEXTO*/
			SELECT		@L_TC_CodMateria		=	CO.TC_CodMateria,
						@L_TN_CodTipoOficina	=	O.TN_CodTipoOficina
			FROM		Catalogo.Contexto		CO	WITH(NOLOCK)
			INNER JOIN	Catalogo.Oficina		O	WITH(NOLOCK)
			ON			O.TC_CodOficina			=	CO.TC_CodOficina
			WHERE		CO.TC_CodContexto		=	@L_TC_CodContexto;

			/*SE BUSCA EQUIVALENCIA POR MATERIA Y TIPO DE OFICINA DEL CONTEXTO*/
			SELECT		TOP 1 @L_TC_ValorSIAGPJ		=	E.TC_ValorSIAGPJ
			FROM		Configuracion.Equivalencia	E	WITH(NOLOCK)
			WHERE		E.TN_CodCatalogo			=	@L_TN_CodCatalogo
			AND			E.TC_ValorExterno			=	@L_TC_ValorExterno
			AND			E.TC_CodContexto			IS	NULL
			AND			E.TN_CodTipoOficina			=	@L_TN_CodTipoOficina
			AND			E.TC_CodMateria				=	@L_TC_CodMateria;
			

			IF (@L_TC_ValorSIAGPJ IS NULL)
			BEGIN
				/*SE BUSCA EQUIVALENCIA POR MATERIA DEL CONTEXTO*/
				SELECT		TOP 1 @L_TC_ValorSIAGPJ		=	E.TC_ValorSIAGPJ
				FROM		Configuracion.Equivalencia	E	WITH(NOLOCK)
				WHERE		E.TN_CodCatalogo			=	@L_TN_CodCatalogo
				AND			E.TC_ValorExterno			=	@L_TC_ValorExterno
				AND			E.TC_CodContexto			IS	NULL
				AND			E.TN_CodTipoOficina			IS	NULL
				AND			E.TC_CodMateria				=	@L_TC_CodMateria;

				IF (@L_TC_ValorSIAGPJ IS NULL)
				BEGIN
					/*SE BUSCA EQUIVALENCIA POR TIPO DE OFICINA DEL CONTEXTO*/
					SELECT		TOP 1 @L_TC_ValorSIAGPJ		=	E.TC_ValorSIAGPJ
					FROM		Configuracion.Equivalencia	E	WITH(NOLOCK)
					WHERE		E.TN_CodCatalogo			=	@L_TN_CodCatalogo
					AND			E.TC_ValorExterno			=	@L_TC_ValorExterno
					AND			E.TC_CodContexto			IS	NULL
					AND			E.TN_CodTipoOficina			=	@L_TN_CodTipoOficina
					AND			E.TC_CodMateria				IS	NULL;

					IF (@L_TC_ValorSIAGPJ IS NULL)
					BEGIN
						/*SE BUSCA EQUIVALENCIA BASE*/
						SELECT		TOP 1 @L_TC_ValorSIAGPJ		=	E.TC_ValorSIAGPJ
						FROM		Configuracion.Equivalencia	E	WITH(NOLOCK)
						WHERE		E.TN_CodCatalogo			=	@L_TN_CodCatalogo
						AND			E.TC_ValorExterno			=	@L_TC_ValorExterno
						AND			E.TC_CodContexto			IS  NULL
						AND			E.TN_CodTipoOficina			IS  NULL
						AND			E.TC_CodMateria				IS  NULL;
					END
				END
			END
	END

	RETURN @L_TC_ValorSIAGPJ;
END

GO
