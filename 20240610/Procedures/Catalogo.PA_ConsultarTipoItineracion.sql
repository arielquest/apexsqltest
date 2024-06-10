SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<05/09/2019>
-- Descripción :			<Permite consultar los tipos de itineración> 
-- =================================================================================================================================================
-- Modificación:            <2019/09/25> <Jose Gabriel Cordero Soto> 
--                          <Por observacion recibida en BUG 0019 - HU 26 Filtrar tipos de itineracion - Ampliacion en tamaño de variable temporal @ExpresionLike a 257
-- Modificación:			<Aida Elena Siles R> <21/09/2020> <Se modifica el nombre de los campos fecha para que cumplan con el estándar.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoItineracion]
	@Codigo				SMALLINT		=	NULL,
	@Descripcion		VARCHAR(255)	=	NULL,
	@FechaActivacion	DATETIME2		=	NULL,
	@FechaDesactivacion DATETIME2		=	NULL
 AS
 BEGIN  
 	--Variables.	DECLARE	@L_TN_Codigo				SMALLINT		= @Codigo,			@L_TF_Inicio_Vigencia		DATETIME2(3)	= @FechaActivacion,			@L_TF_Fin_Vigencia			DATETIME2(3)	= @FechaDesactivacion,			@L_TC_Descripcion			VARCHAR(257)	= IIF (@Descripcion IS NOT NULL, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')

	--Activos e inactivos
	IF  @L_TF_Inicio_Vigencia IS NULL AND  @L_TF_Fin_Vigencia  IS NULL
	BEGIN
			SELECT		A.TN_CodTipoItineracion					AS	Codigo,
						A.TC_Descripcion						AS	Descripcion,
						A.TF_Inicio_Vigencia					AS	FechaActivacion,
						A.TF_Fin_Vigencia						AS	FechaDesactivacion
			FROM		Catalogo.TipoItineracion				A	WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)
	        AND			A.TN_CodTipoItineracion					=	COALESCE(@L_TN_Codigo, A.TN_CodTipoItineracion)
			ORDER BY	A.TC_Descripcion;
	END
	 
	--Activos
	ELSE IF  @L_TF_Inicio_Vigencia IS NOT NULL AND  @L_TF_Fin_Vigencia  IS NULL
	BEGIN
			SELECT		A.TN_CodTipoItineracion					AS	Codigo,
						A.TC_Descripcion						AS	Descripcion,
						A.TF_Inicio_Vigencia					AS	FechaActivacion,
						A.TF_Fin_Vigencia						AS	FechaDesactivacion
			FROM		Catalogo.TipoItineracion				A	WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)
	        AND			A.TN_CodTipoItineracion					=	COALESCE(@L_TN_Codigo, A.TN_CodTipoItineracion)
			AND			A.TF_Inicio_Vigencia					<=	GETDATE ()
			AND			(A.TF_Fin_Vigencia		IS NULL			OR	A.TF_Fin_Vigencia  >= GETDATE ()) 
			ORDER BY	A.TC_Descripcion;
	END

	--Inactivos
	ELSE IF  @L_TF_Inicio_Vigencia IS NULL AND @L_TF_Fin_Vigencia  IS NOT NULL
	BEGIN
			SELECT		A.TN_CodTipoItineracion					AS	Codigo,
						A.TC_Descripcion						AS	Descripcion,
						A.TF_Inicio_Vigencia					AS	FechaActivacion,
						A.TF_Fin_Vigencia						AS	FechaDesactivacion
			FROM		Catalogo.TipoItineracion				A	WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)
	        AND			A.TN_CodTipoItineracion					=	COALESCE(@L_TN_Codigo, A.TN_CodTipoItineracion)
			AND			(A.TF_Inicio_Vigencia					>	GETDATE () 
			Or			A.TF_Fin_Vigencia						<	GETDATE ())
			ORDER BY	A.TC_Descripcion;
	END
	
	--Por rango de fechas
	ELSE IF  @L_TF_Inicio_Vigencia IS NOT NULL AND @L_TF_Fin_Vigencia  IS NOT NULL		
	BEGIN
			SELECT		A.TN_CodTipoItineracion					AS	Codigo,
						A.TC_Descripcion						AS	Descripcion,
						A.TF_Inicio_Vigencia					AS	FechaActivacion,
						A.TF_Fin_Vigencia						AS	FechaDesactivacion
			FROM		Catalogo.TipoItineracion				A	WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)	LIKE dbo.FN_RemoverTildes(@L_TC_Descripcion)
	        AND			A.TN_CodTipoItineracion					=	COALESCE(@L_TN_Codigo, A.TN_CodTipoItineracion)
			AND			(A.TF_Inicio_Vigencia					>=	@L_TF_Inicio_Vigencia
			AND			A.TF_Fin_Vigencia						<=	@L_TF_Fin_Vigencia )
			ORDER BY	A.TC_Descripcion;
	END				
 END
GO
