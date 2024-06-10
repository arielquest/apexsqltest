SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<20/11/2018>
-- Descripción :			<Permite consultar las tasas de interés> 
-- =================================================================================================================================================
-- Modificación:			<Johan Manuel Acosta Ibañez> <07/02/2019> <Permite consultar las tasas de interés por un rango de fechas> 
-- Modificación:			<>Aiada Elena Siles R> <15/12/2020> <Filtrar tasa de interés por moneda, banco, valor.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTasaInteres]
	@Codigo					UNIQUEIDENTIFIER	=	NULL,
	@CodigoBanco			CHAR(4)				=	NULL,
	@CodigoMoneda			SMALLINT			=	NULL,			
	@FechaInicio			DATETIME2			=	NULL,
	@FechaFin				DATETIME2			=	NULL,
	@Valor					DECIMAL(8,5)		=	NULL
 AS
 BEGIN
 --VARIABLES LOCALES
 DECLARE	@L_Codigo				UNIQUEIDENTIFIER	=	@Codigo,
			@L_CodigoBanco			CHAR(4)				=	@CodigoBanco,
			@L_CodigoMoneda			SMALLINT			=	@CodigoMoneda,			
			@L_FechaInicio			DATETIME2			=	@FechaInicio,
			@L_FechaFin				DATETIME2			=	@FechaFin,
			@L_Valor				DECIMAL(8,5)		=	0

	SET @L_Valor =  IIF(@Valor = @L_Valor, NULL, @Valor)

	IF @L_FechaFin IS NULL AND @L_FechaInicio IS NOT NULL  --ACTIVOS
	BEGIN  
		SELECT		A.TN_CodigoTasaInteres	AS	Codigo,				A.TF_Inicio_Vigencia	AS	FechaActivacion,	
					A.TF_Fin_Vigencia		AS	FechaDesactivacion,	A.TN_Valor				AS	Valor,
					'Split'					AS	SplitBanco,			B.TC_CodigoBanco		AS	Codigo,
					B.TC_Descripcion		AS	Descripcion,		'Split'					AS	SplitMoneda,
					C.TN_CodMoneda			AS	Codigo,				C.TC_Descripcion		AS	Descripcion	
		FROM		Catalogo.TasaInteres	AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.Banco			AS	B	WITH(NOLOCK) 	
		ON			B.TC_CodigoBanco		=	A.TC_CodigoBanco	
		INNER JOIN	Catalogo.Moneda			AS	C	WITH(NOLOCK) 	
		ON			C.TN_CodMoneda			=	A.TN_CodMoneda
		WHERE		A.TN_CodigoTasaInteres	=	COALESCE(@L_Codigo, A.TN_CodigoTasaInteres) 
		AND			A.TN_CodMoneda			=	COALESCE(@L_CodigoMoneda, A.TN_CodMoneda) 	
		AND			A.TC_CodigoBanco		=	COALESCE(@L_CodigoBanco, A.TC_CodigoBanco) 	
		AND			A.TN_Valor				=	COALESCE(@L_Valor, A.TN_Valor)
		AND			A.TF_Inicio_Vigencia	<	GETDATE ()  
		AND			( A.TF_Fin_Vigencia		IS NULL   
					  OR 
					  A.TF_Fin_Vigencia		>=	GETDATE () )
	END
	ELSE IF  @L_FechaFin IS NOT NULL AND @L_FechaInicio IS NULL  --INACTIVOS
	BEGIN
		SELECT		A.TN_CodigoTasaInteres	AS	Codigo,				A.TF_Inicio_Vigencia	AS	FechaActivacion,	
					A.TF_Fin_Vigencia		AS	FechaDesactivacion,	A.TN_Valor				AS	Valor,
					'Split'					AS	SplitBanco,			B.TC_CodigoBanco		AS	Codigo,
					B.TC_Descripcion		AS	Descripcion,		'Split'					AS	SplitMoneda,
					C.TN_CodMoneda			AS	Codigo,				C.TC_Descripcion		AS	Descripcion	
		FROM		Catalogo.TasaInteres	AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.Banco			AS	B	WITH(NOLOCK) 	
		ON			B.TC_CodigoBanco		=	A.TC_CodigoBanco	
		INNER JOIN	Catalogo.Moneda			AS	C	WITH(NOLOCK) 	
		ON			C.TN_CodMoneda			=	A.TN_CodMoneda
		WHERE		A.TN_CodigoTasaInteres	=	COALESCE(@L_Codigo, A.TN_CodigoTasaInteres) 
		AND			A.TN_CodMoneda			=	COALESCE(@L_CodigoMoneda, A.TN_CodMoneda) 	
		AND			A.TC_CodigoBanco		=	COALESCE(@L_CodigoBanco, A.TC_CodigoBanco) 	
		AND			A.TN_Valor				=	COALESCE(@L_Valor, A.TN_Valor)
		AND			( A.TF_Inicio_Vigencia	>	GETDATE ()  
					  OR
					  A.TF_Fin_Vigencia		<	GETDATE() )
	END
	ELSE IF (@L_FechaInicio IS NULL AND @L_FechaFin IS NULL) --ACTIVOS E INACTIVOS
	BEGIN
		SELECT		A.TN_CodigoTasaInteres	AS	Codigo,				A.TF_Inicio_Vigencia	AS	FechaActivacion,	
					A.TF_Fin_Vigencia		AS	FechaDesactivacion,	A.TN_Valor				AS	Valor,
					'Split'					AS	SplitBanco,			B.TC_CodigoBanco		AS	Codigo,
					B.TC_Descripcion		AS	Descripcion,		'Split'					AS	SplitMoneda,
					C.TN_CodMoneda			AS	Codigo,				C.TC_Descripcion		AS	Descripcion					
		FROM		Catalogo.TasaInteres	AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.Banco			AS	B	WITH(NOLOCK) 	
		ON			B.TC_CodigoBanco		=	A.TC_CodigoBanco	
		INNER JOIN	Catalogo.Moneda			AS	C	WITH(NOLOCK) 	
		ON			C.TN_CodMoneda			=	A.TN_CodMoneda
		WHERE		A.TN_CodigoTasaInteres	=	COALESCE(@L_Codigo, A.TN_CodigoTasaInteres) 
		AND			A.TN_CodMoneda			=	COALESCE(@L_CodigoMoneda, A.TN_CodMoneda) 	
		AND			A.TC_CodigoBanco		=	COALESCE(@L_CodigoBanco, A.TC_CodigoBanco)
		AND			A.TN_Valor				=	COALESCE(@L_Valor, A.TN_Valor)
		ORDER BY	A.TF_Inicio_Vigencia,	A.TF_Fin_Vigencia;
	END
	ELSE
	BEGIN
		SET @L_FechaInicio = CONVERT(DATE, @L_FechaInicio)
		SET @L_FechaFin = CONVERT(DATE, @L_FechaFin)

		SELECT		A.TN_CodigoTasaInteres				AS	Codigo,				A.TF_Inicio_Vigencia	AS	FechaActivacion,	
					A.TF_Fin_Vigencia					AS	FechaDesactivacion,	A.TN_Valor				AS	Valor,
					'Split'								AS	SplitBanco,			B.TC_CodigoBanco		AS	Codigo,
					B.TC_Descripcion					AS	Descripcion,		'Split'					AS	SplitMoneda,
					C.TN_CodMoneda						AS	Codigo,				C.TC_Descripcion		AS	Descripcion					
		FROM		Catalogo.TasaInteres				AS	A	WITH(NOLOCK) 	
		INNER JOIN	Catalogo.Banco						AS	B	WITH(NOLOCK) 	
		ON			B.TC_CodigoBanco					=	A.TC_CodigoBanco	
		INNER JOIN	Catalogo.Moneda						AS	C	WITH(NOLOCK) 	
		ON			C.TN_CodMoneda						=	A.TN_CodMoneda
		Where		((CONVERT(DATE, A.TF_Inicio_Vigencia)	BETWEEN @L_FechaInicio And @L_FechaFin) 
		OR			(CONVERT(DATE, A.TF_Fin_Vigencia)		BETWEEN @L_FechaInicio And @L_FechaFin) 
		OR			(@L_FechaInicio <= CONVERT(DATE, A.TF_Inicio_Vigencia) AND @L_FechaFin >= CONVERT(DATE, A.TF_Fin_Vigencia)) 
		OR			(@L_FechaInicio >= CONVERT(DATE, A.TF_Inicio_Vigencia) AND @L_FechaFin <= CONVERT(DATE, A.TF_Fin_Vigencia)))
		AND			A.TN_CodMoneda						=	COALESCE(@L_CodigoMoneda, A.TN_CodMoneda) 	
		AND			A.TC_CodigoBanco					=	COALESCE(@L_CodigoBanco, A.TC_CodigoBanco) 	
		ORDER BY	A.TF_Inicio_Vigencia,				A.TF_Fin_Vigencia;
	END
END


GO
