SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <03/10/2022>
-- Descripcion:	   <Consultar los datos de los estados de medidas.>
-- =================================================================================================================================================
-- Modificado por:  <Rafa Badilla Alvarado> Fecha modificación:<24/10/2022> Descripción  <Se modifica para filtrar los registros activos por materia.>
-- =================================================================================================================================================
CREATE      PROCEDURE [Catalogo].[PA_ConsultarEstadoMedida] 
	@Codigo								SMALLINT		= Null,
	@Descripcion						VARCHAR(150)	= Null,			
	@FechaActivacion					DATETIME2(7)	= Null,
	@FechaDesactivacion					DATETIME2(7)	= Null,
	@CodMateria                         VARCHAR(4)	    = Null
AS
BEGIN
	DECLARE 
	@L_ExpresionLike					VARCHAR(255)	=	IIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%'),
	@L_Codigo							SMALLINT		=	@Codigo,
	@L_Descripcion						VARCHAR(150)	=	@Descripcion,
	@L_FechaActivacion					DATETIME2(7)	=	@FechaActivacion,
	@L_FechaDesactivacion				DATETIME2(7)	=	@FechaDesactivacion,
    @L_CodMateria						VARCHAR(4)	    =	@CodMateria


	--Activos e inactivos
	IF  @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NULL  AND @L_CodMateria IS NULL
	BEGIN
			SELECT		A.TN_CodEstado				AS	Codigo,				
						A.TC_Descripcion			AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	
						A.TF_Fin_Vigencia			AS	FechaDesactivacion			
			FROM		Catalogo.EstadoMedida		A	WITH(NOLOCK)			
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) 
			LIKE		dbo.FN_RemoverTildes(@L_ExpresionLike)
			AND			A.TN_CodEstado				=	COALESCE(@L_Codigo,A.TN_CodEstado) 
			ORDER BY	A.TC_Descripcion
	End
	 
	--Activos
	ELSE IF @L_FechaActivacion IS NOT NULL AND @L_FechaDesactivacion IS NULL AND @L_CodMateria IS NULL
	BEGIN
			SELECT		A.TN_CodEstado				AS	Codigo,				
						A.TC_Descripcion			AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	
						A.TF_Fin_Vigencia			AS	FechaDesactivacion
			FROM		Catalogo.EstadoMedida		A	WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion) 
			LIKE		dbo.FN_RemoverTildes(@L_ExpresionLike)
			AND			A.TN_CodEstado				= COALESCE(@L_Codigo,A.TN_CodEstado) 
			AND			A.TF_Inicio_Vigencia		<= GETDATE ()
			AND			(A.TF_Fin_Vigencia			IS	NULL 
						OR A.TF_Fin_Vigencia		>= GETDATE ())
			ORDER BY	A.TC_Descripcion
	END
	
	--Inactivos
	ELSE IF  @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NOT NULL AND @L_CodMateria IS NULL
	BEGIN
			SELECT		A.TN_CodEstado				AS	Codigo,				
						A.TC_Descripcion			AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	
						A.TF_Fin_Vigencia			AS	FechaDesactivacion			
			FROM		Catalogo.EstadoMedida		A	WITH(NOLOCK)			
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)
			LIKE		dbo.FN_RemoverTildes(@L_ExpresionLike)
			AND			A.TN_CodEstado			= COALESCE(@L_Codigo,A.TN_CodEstado) 
			AND			(A.TF_Inicio_Vigencia 	> GETDATE () 
			OR			A.TF_Fin_Vigencia		< GETDATE ())
			ORDER BY	A.TC_Descripcion
	END

	--Por rango de fechas
	ELSE IF @L_FechaActivacion IS NOT NULL AND @L_FechaDesactivacion IS NOT NULL AND @L_CodMateria IS NULL		
	BEGIN
			Select		A.TN_CodEstado				AS	Codigo,				
						A.TC_Descripcion			AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	
						A.TF_Fin_Vigencia			AS	FechaDesactivacion
			FROM		Catalogo.EstadoMedida		A	WITH(NOLOCK)			
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)
			LIKE		dbo.FN_RemoverTildes(@L_ExpresionLike)
			AND			A.TN_CodEstado			= COALESCE(@L_Codigo,A.TN_CodEstado) 
			AND			(A.TF_Inicio_Vigencia	>= @L_FechaActivacion
			AND			A.TF_Fin_Vigencia		<= @L_FechaDesactivacion)
			ORDER BY	A.TC_Descripcion
	END	
	--Por materia
	ELSE IF @L_CodMateria IS NOT NULL		
	BEGIN
		   Select distinct		A.TN_CodEstado				AS	Codigo,				
						A.TC_Descripcion			AS	Descripcion,
						A.TF_Inicio_Vigencia		AS	FechaActivacion,	
						A.TF_Fin_Vigencia			AS	FechaDesactivacion
			FROM		Catalogo.EstadoMedida		AS	A WITH (Nolock) 
			INNER JOIN	Catalogo.EstadoMedidaMateria			AS	B WITH (Nolock)
			ON			A.TN_CodEstado				   =	B.TN_CodEstado
			INNER JOIN  Catalogo.Materia					AS	C WITH (Nolock)
			ON			C.TC_CodMateria						=	B.TC_CodMateria			
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)
			LIKE		dbo.FN_RemoverTildes(@L_ExpresionLike)
			AND			A.TN_CodEstado			= COALESCE(@L_Codigo,A.TN_CodEstado) 
			AND			A.TF_Inicio_Vigencia		<= GETDATE ()
			AND			(A.TF_Fin_Vigencia			IS	NULL 
						OR A.TF_Fin_Vigencia		>= GETDATE ())
			AND         B.TC_CodMateria			=	COALESCE(@CodMateria, B.TC_CodMateria)
			ORDER BY	A.TC_Descripcion
	END
END	
GO
