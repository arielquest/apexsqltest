SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<12/08/2015>
-- Descripción :			<Permite Consultar un Delito> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir la consulta por la fecha de activación.> 
-- Modificado por:			<Alejandro Villalta>
-- Fecha de creación:		<08/12/2015>
-- Descripción :			<Cambiar tipo de dato del campo codigo.> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:              <22/08/2017> <Se optimiza la consulta>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- Modificación:			<17/12/2020> <Aida Elena Siles R> <Se agrega filtro por categoria del delito solicitud PBI 158078>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarDelito]
	@CodDelito			INT					= NULL,
	@Descripcion		VARCHAR(255)		= NULL,		
	@FechaActivacion	DATETIME2(7)		= NULL,	
	@FechaDesactivacion DATETIME2(7)		= NULL,
	@CodCategoriaDelito	INT					= NULL
AS
BEGIN
--VARIABLES
DECLARE	@L_CodDelito			INT					= @CodDelito,
		@L_Descripcion			VARCHAR(255)		= @Descripcion,		
		@L_FechaActivacion		DATETIME2(7)		= @FechaActivacion,	
		@L_FechaDesactivacion	DATETIME2(7)		= @FechaDesactivacion,
		@L_CodCategoriaDelito	INT					= @CodCategoriaDelito
--LÓGICA
	
	DECLARE @ExpresionLike VARCHAR(257)
	SET		@ExpresionLike = IIF(@L_Descripcion IS NOT NULL,'%' + @L_Descripcion + '%','%')

	--Activos e inactivos
	If @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NULL
	BEGIN		
			SELECT		A.TN_CodDelito				AS	Codigo,				A.TC_Descripcion	AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	A.TF_Fin_Vigencia	AS	FechaDesactivacion,
						'Split'						AS	Split,
						B.TN_CodCategoriaDelito		AS	Codigo,				B.TC_Descripcion	AS	Descripcion,		
						B.TF_Inicio_Vigencia		AS	FechaActivacion,	B.TF_Fin_Vigencia	AS	FechaDesactivacion
			FROM		Catalogo.Delito				A  WITH(NOLOCK)
			JOIN		Catalogo.CategoriaDelito	B	
			ON			A.TN_CodCategoriaDelito	=	B.TN_CodCategoriaDelito
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion))
			AND			A.TN_CodDelito				=	COALESCE(@L_CodDelito, A.TN_CodDelito)
			AND			A.TN_CodCategoriaDelito		=	COALESCE(@L_CodCategoriaDelito, A.TN_CodCategoriaDelito)
			ORDER BY	A.TC_Descripcion;
	END
	--Activos 
	ELSE IF @L_FechaActivacion IS NOT NULL AND @L_FechaDesactivacion IS NULL
	BEGIN
			SELECT		A.TN_CodDelito				AS	Codigo,				A.TC_Descripcion	AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	A.TF_Fin_Vigencia	AS	FechaDesactivacion,
						'Split'						AS	Split,
						B.TN_CodCategoriaDelito		AS	Codigo,				B.TC_Descripcion	AS	Descripcion,		
						B.TF_Inicio_Vigencia		AS	FechaActivacion,	B.TF_Fin_Vigencia	AS	FechaDesactivacion
			FROM		Catalogo.Delito				A  WITH(NOLOCK)
			JOIN		Catalogo.CategoriaDelito	B	
			On			A.TN_CodCategoriaDelito	=	B.TN_CodCategoriaDelito
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion))
			AND			A.TN_CodDelito				=	COALESCE(@CodDelito,A.TN_CodDelito)
			AND			A.TN_CodCategoriaDelito		=	COALESCE(@L_CodCategoriaDelito, A.TN_CodCategoriaDelito)
			AND			A.TF_Inicio_Vigencia		<	GETDATE ()
			AND			( 
							A.TF_Fin_Vigencia		IS NULL
						 OR			
							A.TF_Fin_Vigencia		>=	GETDATE ()
						)
			ORDER BY	A.TC_Descripcion;
	END
	 --Inactivos
	ELSE IF @L_FechaDesactivacion IS NOT NULL AND @L_FechaActivacion IS NULL
	BEGIN
		SELECT		A.TN_CodDelito				AS	Codigo,				A.TC_Descripcion	AS	Descripcion,
					A.TF_Inicio_Vigencia		AS	FechaActivacion,	A.TF_Fin_Vigencia	AS	FechaDesactivacion,
					'Split'						AS	Split,
					B.TN_CodCategoriaDelito		AS	Codigo,				B.TC_Descripcion	AS	Descripcion,		
					B.TF_Inicio_Vigencia		AS	FechaActivacion,	B.TF_Fin_Vigencia	AS	FechaDesactivacion
		FROM		Catalogo.Delito				A  WITH(NOLOCK)
		JOIN		Catalogo.CategoriaDelito	B	
		On			A.TN_CodCategoriaDelito	=	B.TN_CodCategoriaDelito
		WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion)) 
		AND			A.TN_CodDelito				=	COALESCE(@CodDelito,A.TN_CodDelito)
		AND			A.TN_CodCategoriaDelito		=	COALESCE(@L_CodCategoriaDelito, A.TN_CodCategoriaDelito)
	    AND			(
						A.TF_Inicio_Vigencia		>	GETDATE () 
					 OR
						A.TF_Fin_Vigencia			<	GETDATE ()
					)
		ORDER BY	 A.TC_Descripcion;
	END	
	--Por rango
	ELSE IF @L_FechaDesactivacion IS NOT NULL AND @L_FechaActivacion IS NOT NULL
	BEGIN
		SELECT		A.TN_CodDelito			AS	Codigo,				A.TC_Descripcion	AS	Descripcion,
					A.TF_Inicio_Vigencia	AS	FechaActivacion,	A.TF_Fin_Vigencia	AS	FechaDesactivacion,
					'Split'					AS	Split,
					B.TN_CodCategoriaDelito	AS	Codigo,				B.TC_Descripcion	AS	Descripcion,		
					B.TF_Inicio_Vigencia	AS	FechaActivacion,	B.TF_Fin_Vigencia	AS	FechaDesactivacion
		FROM		Catalogo.Delito				A  WITH(NOLOCK)
		JOIN		Catalogo.CategoriaDelito	B	
		On			A.TN_CodCategoriaDelito	=	B.TN_CodCategoriaDelito
		WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,A.TC_Descripcion))
		AND			A.TN_CodDelito				=	COALESCE(@CodDelito, A.TN_CodDelito)
		AND			A.TN_CodCategoriaDelito		=	COALESCE(@L_CodCategoriaDelito, A.TN_CodCategoriaDelito)
		AND			(A.TF_Fin_Vigencia			<=	@FechaDesactivacion 
		AND			A.TF_Inicio_Vigencia		>=	@FechaActivacion) 
		ORDER BY	A.TC_Descripcion;
	END
END
		


GO
