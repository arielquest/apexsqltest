SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jeffry Hernández>
-- Fecha de creación:	<02/05/2018>
-- Descripción:			<Permite consultar uno o varios registros a la tabla Configuracion.ConfiguracionValor>
-- ==========================================================================================================================================
-- Modificación:        <Tatiana Flores><17/08/2018> Se agrega relación a tabla Contexto y de ahí se toman los datos de la oficina
-- Modificación:		<Luis Alonso Leiva Tames><30/07/2020> Se agrega en la condición para validar la fecha de activacion y fecha de cadusidad
-- Modificación:		<Aida Elena Siles R><17/06/2021> <Se modifica la validación del AND TF_FechaCaducidad = null por TF_FechaCaducidad IS NULL>
-- ==========================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarConfiguracionValor]
@CodConfiguracion		VARCHAR(27),
@CodContexto			VARCHAR(4) = NULL,
@EsValorGeneral			BIT, 
@ValidarFecha			BIT = 0
AS
BEGIN

	DECLARE @FechaActual DATETIME
	SET @FechaActual = GETDATE()	

	IF(@EsValorGeneral = 0)
	BEGIN

		IF(@CodContexto IS NULL)
		BEGIN
			--Se obtienen los valores por código de configuración
			SELECT 
			TU_Codigo			AS Codigo,			TF_FechaCreacion	AS FechaCreacion,
			TF_FechaActivacion	AS FechaActivacion, TF_FechaCaducidad	AS FechaCaducidad,		
			TC_Valor			AS Valor,			'SplitOficina'		AS SplitOficina,		
			CO.TC_CodOficina	AS Codigo,			'SplitConfiguracion'AS SplitConfiguracion,	
			TC_CodConfiguracion	AS Codigo,			'SplitMateria'		AS SplitMateria,
			CO.TC_CodMateria	AS Codigo,			'SplitContexto'		AS SplitContexto,
			CO.TC_CodContexto	AS Codigo	
			FROM		Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
			INNER JOIN	[Catalogo].[Contexto]				CO WITH(NOLOCK)
			ON			CV.TC_CodContexto		= CO.TC_CodContexto
			WHERE		TC_CodConfiguracion		= @CodConfiguracion
			AND			(TF_FechaActivacion <= @FechaActual OR @ValidarFecha = 0) 
			AND			(TF_FechaCaducidad  >= @FechaActual OR @ValidarFecha = 0 OR TF_FechaCaducidad IS NULL)

		END
		ELSE
		BEGIN
			--Se obtienen los valores por código de configuración y por código de oficina
			SELECT 
			TU_Codigo			AS Codigo,			TF_FechaCreacion	AS FechaCreacion,
			TF_FechaActivacion	AS FechaActivacion, TF_FechaCaducidad	AS FechaCaducidad,		
			TC_Valor			AS Valor,			'SplitOficina'		AS SplitOficina,		
			CO.TC_CodOficina	AS Codigo,			'SplitConfiguracion'AS SplitConfiguracion,	
			TC_CodConfiguracion	AS Codigo,			'SplitMateria'		AS SplitMateria,
			CO.TC_CodMateria	AS Codigo,			'SplitContexto'		AS SplitContexto,
			CO.TC_CodContexto	AS Codigo

			FROM		Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
			INNER JOIN	[Catalogo].[Contexto]				CO WITH(NOLOCK)
			ON			CV.TC_CodContexto				= CO.TC_CodContexto
			WHERE		TC_CodConfiguracion				= @CodConfiguracion
			AND			CV.TC_CodContexto				= @CodContexto	
			AND			(TF_FechaActivacion <= @FechaActual OR @ValidarFecha = 0) 
			AND			(TF_FechaCaducidad  >= @FechaActual OR @ValidarFecha = 0 OR TF_FechaCaducidad IS NULL)
		END	

	END

	ELSE
		BEGIN
			SELECT 
			TU_Codigo			AS Codigo,			TF_FechaCreacion	AS FechaCreacion,
			TF_FechaActivacion	AS FechaActivacion, TF_FechaCaducidad	AS FechaCaducidad,		
			TC_Valor			AS Valor,			'SplitOficina'		AS SplitOficina,		
			NULL				AS Codigo,			'SplitConfiguracion'AS SplitConfiguracion,	
			TC_CodConfiguracion	AS Codigo,			'SplitMateria'		AS SplitMateria,
			NULL				AS Codigo,			'SplitContexto'		AS SplitContexto,
			TC_CodContexto		AS Codigo

			FROM	Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
			WHERE	TC_CodConfiguracion		= @CodConfiguracion
			AND		(TF_FechaActivacion <= @FechaActual OR @ValidarFecha = 0) 
			AND		(TF_FechaCaducidad  >= @FechaActual OR @ValidarFecha = 0 OR TF_FechaCaducidad IS NULL)
		END
END

GO
