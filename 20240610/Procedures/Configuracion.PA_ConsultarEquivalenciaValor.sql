SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Daniel Ruiz Hernández>
-- Fecha de creación:	<15/02/2021>
-- Descripción:			<Permite consultar uno o varios registros a la tabla Configuracion.EquivalenciaValor>
--
-- Creado por:			<Isaac Santiago Méndez Castillo>
-- Fecha de creación:	<14/04/2021>
-- Descripción:			<-Se cambia el ALIAS de la descripción del catálogo C.TC_Descripcion de "DescripcionSistema" a "CatalogoSistemaExterno"
--						  ya que estaba repetido.
--						 -Se agrega el código de catálogo del sistema externo como "CodigoCatalogoSistemaExterno".
--                       -Se cambia el ALIAS del código del catálogo del SIAGPJ de "CodigoCatalogo" a "CodigoCatalogoSIAGPJ".>
-- Modificación:		<Karol Jiménez Sánchez><20/09/2021><Se agrega a la consulta la materia, el tipo de oficina y el contexto>
-- Modificación			<Gabriel Arnáez Hodgson><29/06/2023><Se agregan variables y lógica de paginación>
-- ======================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarEquivalenciaValor]
	@CodCodigo				uniqueidentifier	= null,
	@CodSistema				smallint			= null,
	@CodCatalogo			smallint			= null, 
	@ValorExterno			varchar(40)			= null,
	@DescripcionExterno		varchar(255)		= null,
	@ValorSIAGPJ			varchar(40)			= null,
	@NumeroPagina			INT,
	@CantidadRegistros		INT

AS
BEGIN
	IF (@NumeroPagina IS NULL)	SET @NumeroPagina = 1;

	--SE OBTIENE LA CANTIDAD DE REGISTROS
	DECLARE @TotalRegistros AS INT

	
	DECLARE @EquivalenciaValor AS TABLE
	(
		Codigo							uniqueidentifier,
		SplitOtrosDatos					varchar(5),
		CodigoSistema					smallint,
		DescripcionSistema				varchar(150),
		SiglasSistema					varchar(20),
		CodigoCatalogoSIAGPJ			smallint,
		CatalogoSIAGPJ					varchar(256),
		CodigoCatalogoSistemaExterno	smallint,
		CatalogoSistemaExterno			varchar(150),
		CodigoExterno					varchar(40),			
		ValorExterno					varchar(255),
		CodigoSIAGPJ					varchar(40),
		ValorSIAGPJ						varchar(255),	
		CodigoTipoOficina				smallint,
		DescripcionTipoOficina			varchar(255),
		CodigoMateria					varchar(5),
		DescripcionMateria				varchar(50),
		CodigoContexto					varchar(4),
		DescripcionContexto				varchar(259)	
	)

	DECLARE	@ExpresionLike	varchar(200), @L_NumeroPagina int = @NumeroPagina, @L_CantidadRegistros int = @CantidadRegistros
	SET		@ExpresionLike	= IIF(@DescripcionExterno IS NOT NULL,'%' + @DescripcionExterno + '%','%')
------------------------------------------------------------------------------------
	if (@CodCodigo IS NULL AND @CodSistema IS NULL 
		AND @CodCatalogo IS NULL AND @ValorExterno IS NULL 
		AND @DescripcionExterno IS NULL AND @ValorSIAGPJ IS NULL)
	BEGIN

		INSERT INTO @EquivalenciaValor
		(
			Codigo,
			SplitOtrosDatos,
			CodigoSistema,
			DescripcionSistema,
			SiglasSistema,
			CodigoCatalogoSIAGPJ,
			CatalogoSIAGPJ,
			CodigoCatalogoSistemaExterno,
			CatalogoSistemaExterno,
			CodigoExterno,			
			ValorExterno,
			CodigoSIAGPJ,
			ValorSIAGPJ,	
			CodigoTipoOficina,
			DescripcionTipoOficina,
			CodigoMateria,
			DescripcionMateria,
			CodigoContexto,
			DescripcionContexto
		)
			SELECT 
			A.TU_Codigo								Codigo,
			'Split'									SplitOtrosDatos,
			B.TN_CodSistema							CodigoSistema,
			B.TC_Descripcion						DescripcionSistema,
			B.TC_Siglas								SiglasSistema,
			C.TN_CodCatalogo						CodigoCatalogoSIAGPJ,
			C.TC_CatalogoSiagpj						CatalogoSIAGPJ,
			C.TN_CodSistema							CodigoCatalogoSistemaExterno,
			C.TC_Descripcion						CatalogoSistemaExterno,
			A.TC_ValorExterno						CodigoExterno,			
			A.TC_DescripcionExterno					ValorExterno,
			A.TC_ValorSIAGPJ						CodigoSIAGPJ,
			A.TC_DescripcionSIAGPJ					ValorSIAGPJ,
			A.TN_CodTipoOficina						CodigoTipoOficina,
			D.TC_Descripcion						DescripcionTipoOficina,
			A.TC_CodMateria							CodigoMateria,
			E.TC_Descripcion						DescripcionMateria,
			A.TC_CodContexto						CodigoContexto,
			CASE WHEN A.TC_CodContexto IS NOT NULL
				THEN	A.TC_CodContexto + ' - ' + F.TC_Descripcion		
				ELSE	NULL
			END										DescripcionContexto
			FROM		Configuracion.Equivalencia	A WITH(NOLOCK) 	
			JOIN		Configuracion.Sistema		B WITH(NOLOCK) 	 
			ON			A.TN_CodSistema				= B.TN_CodSistema 
			JOIN		Configuracion.Catalogo		C WITH(NOLOCK) 	
			ON			A.TN_CodCatalogo			= C.TN_CodCatalogo
			LEFT JOIN	Catalogo.TipoOficina		D WITH(NOLOCK) 	 
			ON			D.TN_CodTipoOficina			= A.TN_CodTipoOficina
			LEFT JOIN	Catalogo.Materia			E WITH(NOLOCK) 	 
			ON			E.TC_CodMateria				= A.TC_CodMateria
			LEFT JOIN	Catalogo.Contexto			F WITH(NOLOCK) 	 
			ON			F.TC_CodContexto			= A.TC_CodContexto

			--SE OBTIENE LA CANTIDAD DE REGISTROS
			SET @TotalRegistros = @@ROWCOUNT


			--RETORNAR CONSULTA
			SELECT 
				T.Codigo,
				T.SplitOtrosDatos,
				T.CodigoSistema,
				T.DescripcionSistema,
				T.SiglasSistema,
				T.CodigoCatalogoSIAGPJ,
				T.CatalogoSIAGPJ,
				T.CodigoCatalogoSistemaExterno,
				T.CatalogoSistemaExterno,
				T.CodigoExterno,			
				T.ValorExterno,
				T.CodigoSIAGPJ,
				T.ValorSIAGPJ,	
				T.CodigoTipoOficina,
				T.DescripcionTipoOficina,
				T.CodigoMateria,
				T.DescripcionMateria,
				T.CodigoContexto,
				@TotalRegistros		AS TotalRegistros

			FROM (
				SELECT
					Codigo,
					SplitOtrosDatos,
					CodigoSistema,
					DescripcionSistema,
					SiglasSistema,
					CodigoCatalogoSIAGPJ,
					CatalogoSIAGPJ,
					CodigoCatalogoSistemaExterno,
					CatalogoSistemaExterno,
					CodigoExterno,			
					ValorExterno,
					CodigoSIAGPJ,
					ValorSIAGPJ,	
					CodigoTipoOficina,
					DescripcionTipoOficina,
					CodigoMateria,
					DescripcionMateria,
					CodigoContexto
				FROM @EquivalenciaValor
				ORDER BY Codigo
				OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
				FETCH NEXT	@L_CantidadRegistros ROWS ONLY
			) As T
			ORDER BY T.Codigo

		END
	ELSE
		BEGIN

		INSERT INTO @EquivalenciaValor
		(
			Codigo,
			SplitOtrosDatos,
			CodigoSistema,
			DescripcionSistema,
			SiglasSistema,
			CodigoCatalogoSIAGPJ,
			CatalogoSIAGPJ,
			CodigoCatalogoSistemaExterno,
			CatalogoSistemaExterno,
			CodigoExterno,			
			ValorExterno,
			CodigoSIAGPJ,
			ValorSIAGPJ,	
			CodigoTipoOficina,
			DescripcionTipoOficina,
			CodigoMateria,
			DescripcionMateria,
			CodigoContexto,
			DescripcionContexto
		)
			SELECT 
			A.TU_Codigo								Codigo,
			'Split'									SplitOtrosDatos,
			B.TN_CodSistema							CodigoSistema,
			B.TC_Descripcion						DescripcionSistema,
			B.TC_Siglas								SiglasSistema,
			C.TN_CodCatalogo						CodigoCatalogoSIAGPJ,
			C.TC_CatalogoSiagpj						CatalogoSIAGPJ,
			C.TN_CodSistema							CodigoCatalogoSistemaExterno,
			C.TC_Descripcion						CatalogoSistemaExterno,
			A.TC_ValorExterno						CodigoExterno,			
			A.TC_DescripcionExterno					ValorExterno,
			A.TC_ValorSIAGPJ						CodigoSIAGPJ,
			A.TC_DescripcionSIAGPJ					ValorSIAGPJ,
			A.TN_CodTipoOficina						CodigoTipoOficina,
			D.TC_Descripcion						DescripcionTipoOficina,
			A.TC_CodMateria							CodigoMateria,
			E.TC_Descripcion						DescripcionMateria,
			A.TC_CodContexto						CodigoContexto,
			CASE WHEN A.TC_CodContexto IS NOT NULL
				THEN	A.TC_CodContexto + ' - ' + F.TC_Descripcion		
				ELSE	NULL
			END										DescripcionContexto
			FROM		Configuracion.Equivalencia	A WITH(NOLOCK) 	
			JOIN		Configuracion.Sistema		B WITH(NOLOCK) 	 
			ON			A.TN_CodSistema				= B.TN_CodSistema 
			JOIN		Configuracion.Catalogo		C WITH(NOLOCK) 	
			ON			A.TN_CodCatalogo			= C.TN_CodCatalogo
			LEFT JOIN	Catalogo.TipoOficina		D WITH(NOLOCK) 	 
			ON			D.TN_CodTipoOficina			= A.TN_CodTipoOficina
			LEFT JOIN	Catalogo.Materia			E WITH(NOLOCK) 	 
			ON			E.TC_CodMateria				= A.TC_CodMateria
			LEFT JOIN	Catalogo.Contexto			F WITH(NOLOCK) 	 
			ON			F.TC_CodContexto			= A.TC_CodContexto
			WHERE 
			A.TU_Codigo								= ISNULL(@CodCodigo, A.TU_Codigo)
			AND B.TN_CodSistema						= ISNULL(@CodSistema, B.TN_CodSistema)
			AND C.TN_CodCatalogo					= ISNULL(@CodCatalogo, C.TN_CodCatalogo)
			AND A.TC_ValorExterno					= ISNULL(@ValorExterno, A.TC_ValorExterno)
			AND A.TC_ValorSIAGPJ					= ISNULL(@ValorSIAGPJ, A.TC_ValorSIAGPJ)
			AND A.TC_DescripcionExterno				LIKE @ExpresionLike 

			--SE CUENTA LA CANTIDAD DE REGISTROS
				SET @TotalRegistros = @@ROWCOUNT

			--RETORNAR CONSULTA
			SELECT 
				T.Codigo,
				T.SplitOtrosDatos,
				T.CodigoSistema,
				T.DescripcionSistema,
				T.SiglasSistema,
				T.CodigoCatalogoSIAGPJ,
				T.CatalogoSIAGPJ,
				T.CodigoCatalogoSistemaExterno,
				T.CatalogoSistemaExterno,
				T.CodigoExterno,			
				T.ValorExterno,
				T.CodigoSIAGPJ,
				T.ValorSIAGPJ,	
				T.CodigoTipoOficina,
				T.DescripcionTipoOficina,
				T.CodigoMateria,
				T.DescripcionMateria,
				T.CodigoContexto,
				@TotalRegistros		AS TotalRegistros

			FROM (
				SELECT
					Codigo,
					SplitOtrosDatos,
					CodigoSistema,
					DescripcionSistema,
					SiglasSistema,
					CodigoCatalogoSIAGPJ,
					CatalogoSIAGPJ,
					CodigoCatalogoSistemaExterno,
					CatalogoSistemaExterno,
					CodigoExterno,			
					ValorExterno,
					CodigoSIAGPJ,
					ValorSIAGPJ,	
					CodigoTipoOficina,
					DescripcionTipoOficina,
					CodigoMateria,
					DescripcionMateria,
					CodigoContexto
				FROM @EquivalenciaValor
				ORDER BY Codigo
				OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
				FETCH NEXT	@L_CantidadRegistros ROWS ONLY
			) As T
			ORDER BY T.Codigo
			
		END
END
GO
