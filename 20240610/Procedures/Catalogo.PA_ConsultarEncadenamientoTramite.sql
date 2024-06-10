SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================
-- Autor:		   <Rafa Badilla>
-- Fecha Creación: <17/06/2022> 
-- Descripcion:    <Consultar Trámites>
-- =========================================================================================================================================
-- Modificación:   <15-07-2022> <Jose Gabriel Cordero> <Se incluye ajuste de consulta cuando se va filtros de Materia o Tipo OFicina en Listar Tramites>
-- Modificación:   <21-07-2022> <Karol Jiménez S.> <Se incluye ajuste de consulta para filtrar por vigentes>
-- Modificación:   <26-07-2022> <Jose Gabriel Cordero> <Se corrige IF sobre filtrado con materia y tipo de oficina por duplicidad que evitaba el filtrado correcto por vigencia>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEncadenamientoTramite] 
	@InicioVigencia						datetime2		= Null,
	@FinVigencia						datetime2		= Null,
	@Codigo								Varchar(500)	= Null,
	@CodigoGrupo						Varchar(500)	= Null,
	@CodMateria							Varchar(5)		= Null, 
	@CodTipoOficina						Smallint		= Null
AS
BEGIN

	-- Variables locales
	DECLARE @L_InicioVigencia					datetime2			= @InicioVigencia,
			@L_FinVigencia						datetime2			= @FinVigencia,
			@L_CodEncadenamientoTramite			Varchar(500)		= @Codigo,
			@L_CodGrupoEncadenamientoTramite	Varchar(500)		= @CodigoGrupo,
			@L_CodMateria						Varchar(5)			= @CodMateria,
			@L_CodTipoOficina					Smallint			= @CodTipoOficina

	--Consulta un trámite en específico sin importar otras condiciones
	IF @L_CodEncadenamientoTramite IS NOT NULL
	BEGIN
		SELECT		 ET.TU_CodEncadenamientoTramite						AS Codigo				
					,ET.TF_Inicio_Vigencia								AS FechaActivacion
					,ET.TF_Fin_Vigencia									AS FechaDesactivacion			
					,ET.TC_Nombre										AS Nombre			
					,ET.[TC_Descripcion]								AS Descripcion
					,ET.TF_Actualizacion								AS FechaActualizacion 
					,'SplitGrupo'										AS SplitGrupo
					,A.TU_CodGrupoEncadenamientoTramite					AS Codigo	
					,A.TC_Nombre										AS Nombre
					,A.TC_Descripcion									AS Descripcion
		FROM		Catalogo.EncadenamientoTramite		   ET			WITH(NOLOCK)
		INNER JOIN  Catalogo.GrupoEncadenamientoTramite		A			WITH(NOLOCK)
		ON			A.TU_CodGrupoEncadenamientoTramite					= ET.TU_CodGrupoEncadenamientoTramite
		WHERE		ET.TU_CodEncadenamientoTramite						IN (SELECT	value  
																			FROM	STRING_SPLIT(@L_CodEncadenamientoTramite, ','))	
		ORDER BY	ET.TC_Nombre
	END	
	ELSE	
	--Consulta todos los trámites relacionados a un mismo grupo padre
	IF @L_CodGrupoEncadenamientoTramite IS NOT NULL
	BEGIN
		SELECT	 ET.TU_CodEncadenamientoTramite				 AS Codigo			
				,ET.TF_Inicio_Vigencia						 AS FechaActivacion
				,ET.TF_Fin_Vigencia							 AS FechaDesactivacion			
				,ET.TC_Nombre								 AS Nombre			
				,ET.[TC_Descripcion]						 AS Descripcion
				,ET.TF_Actualizacion						 AS FechaActualizacion  
				,'SplitGrupo'								 AS SplitGrupo
				,A.TU_CodGrupoEncadenamientoTramite			 AS Codigo	
				,A.TC_Nombre								 AS Nombre
				,A.TC_Descripcion							 AS Descripcion
		FROM		Catalogo.EncadenamientoTramite		ET	 WITH(NOLOCK)
		INNER JOIN  Catalogo.GrupoEncadenamientoTramite A	 WITH(NOLOCK)
		ON			A.TU_CodGrupoEncadenamientoTramite		 = ET.TU_CodGrupoEncadenamientoTramite		
		WHERE		ET.TU_CodGrupoEncadenamientoTramite		 IN (SELECT	value  
															 	 FROM	STRING_SPLIT(@L_CodGrupoEncadenamientoTramite, ','))	
		ORDER BY ET.TC_Nombre
	END
	
	--Consulta todos los trámites registrados según filtros establecidos de materia y Tipooficina
    IF (@L_CodMateria IS NOT NULL OR @L_CodTipoOficina IS NOT NULL) AND @L_InicioVigencia IS NULL
    BEGIN
        SELECT         A.TU_CodEncadenamientoTramite                    AS Codigo              
                    ,A.TF_Inicio_Vigencia                            AS FechaActivacion
                    ,A.TF_Fin_Vigencia                                AS FechaDesactivacion          
                    ,A.TC_Nombre                                    AS Nombre          
                    ,A.TC_Descripcion                                AS Descripcion
                    ,A.TF_Actualizacion                                AS FechaActualizacion
                    ,'SplitGrupo'                                    AS SplitGrupo
                    ,B.TU_CodGrupoEncadenamientoTramite                AS Codigo  
                    ,B.TC_Nombre                                    AS Nombre
                    ,B.TC_Descripcion                                AS Descripcion
        FROM        Catalogo.EncadenamientoTramite        A            WITH(NOLOCK)
        INNER JOIN  Catalogo.GrupoEncadenamientoTramite B            WITH(NOLOCK)
        ON            B.TU_CodGrupoEncadenamientoTramite                = A.TU_CodGrupoEncadenamientoTramite
        INNER JOIN    Catalogo.EncadenamientoTramiteMateriaOficina C    WITH(NOLOCK)
        ON            C.TU_CodEncadenamientoTramite                    = A.TU_CodEncadenamientoTramite

        WHERE        C.TC_CodMateria                                    = COALESCE(@L_CodMateria, C.TC_CodMateria)
        AND            C.TN_CodTipoOficina                                = COALESCE(@L_CodTipoOficina, C.TN_CodTipoOficina)

        GROUP BY    A.TU_CodEncadenamientoTramite,A.TF_Inicio_Vigencia,A.TF_Fin_Vigencia,A.TC_Nombre,A.TC_Descripcion,A.TF_Actualizacion,
                    B.TU_CodGrupoEncadenamientoTramite,B.TC_Nombre,B.TC_Descripcion

        ORDER BY    A.TC_Nombre                        
    END


	--Consulta todos los trámites registrados según filtros establecidos de materia y Tipooficina y por vigencia
	ELSE IF (@L_CodMateria IS NOT NULL OR @L_CodTipoOficina IS NOT NULL) AND @L_InicioVigencia IS NOT NULL
	BEGIN
		SELECT		 A.TU_CodEncadenamientoTramite					AS Codigo				
					,A.TF_Inicio_Vigencia							AS FechaActivacion
					,A.TF_Fin_Vigencia								AS FechaDesactivacion			
					,A.TC_Nombre									AS Nombre			
					,A.TC_Descripcion								AS Descripcion
					,A.TF_Actualizacion								AS FechaActualizacion  
					,'SplitGrupo'									AS SplitGrupo
					,B.TU_CodGrupoEncadenamientoTramite				AS Codigo	
					,B.TC_Nombre									AS Nombre
					,B.TC_Descripcion								AS Descripcion
		FROM		Catalogo.EncadenamientoTramite					A WITH(NOLOCK)
		INNER JOIN  Catalogo.GrupoEncadenamientoTramite				B WITH(NOLOCK)
		ON		    B.TU_CodGrupoEncadenamientoTramite				= A.TU_CodGrupoEncadenamientoTramite
		INNER JOIN	Catalogo.EncadenamientoTramiteMateriaOficina C	WITH(NOLOCK)
		ON			C.TU_CodEncadenamientoTramite					= A.TU_CodEncadenamientoTramite
		
		WHERE		C.TC_CodMateria									= COALESCE(@L_CodMateria, C.TC_CodMateria)
		AND			C.TN_CodTipoOficina								= COALESCE(@L_CodTipoOficina, C.TN_CodTipoOficina)
		AND			B.TF_Inicio_Vigencia							<= GETDATE()
		AND		   (B.TF_Fin_Vigencia								IS NULL
		OR  		B.TF_Fin_Vigencia								>= GETDATE()) 
		AND			A.TF_Inicio_Vigencia							<= GETDATE()
		AND		   (A.TF_Fin_Vigencia								IS NULL
		OR			A.TF_Fin_Vigencia								>= GETDATE()) 
		GROUP BY	A.TU_CodEncadenamientoTramite,A.TF_Inicio_Vigencia,A.TF_Fin_Vigencia,A.TC_Nombre,A.TC_Descripcion,A.TF_Actualizacion,
					B.TU_CodGrupoEncadenamientoTramite,B.TC_Nombre,B.TC_Descripcion
		
		ORDER BY	A.TC_Nombre						 
	END
	ELSE
		BEGIN
		-- No vigentes hoy
		IF @L_InicioVigencia IS NULL AND @L_FinVigencia IS NOT NULL
		BEGIN
			SELECT	 ET.TU_CodEncadenamientoTramite				AS Codigo					
					,ET.TF_Inicio_Vigencia						AS FechaActivacion
					,ET.TF_Fin_Vigencia							AS FechaDesactivacion			
					,ET.TC_Nombre								AS Nombre			
					,ET.[TC_Descripcion]						AS Descripcion
					,ET.TF_Actualizacion						AS FechaActualizacion  
					,'SplitGrupo'								AS SplitGrupo
					,TU_CodGrupoEncadenamientoTramite			AS Codigo	
			FROM	Catalogo.EncadenamientoTramite		ET		WITH(NOLOCK)
			WHERE	(ET.TF_Inicio_Vigencia						>= GETDATE() 
			OR	 	 ET.TF_Fin_Vigencia							< GETDATE())
			ORDER BY ET.TC_Nombre
		END		
		ELSE 
		-- Vigentes	
		IF @L_InicioVigencia IS NOT NULL AND @L_FinVigencia IS NULL
		BEGIN
			SELECT		 ET.TU_CodEncadenamientoTramite				AS Codigo				
						,ET.TF_Inicio_Vigencia						AS FechaActivacion
						,ET.TF_Fin_Vigencia							AS FechaDesactivacion			
						,ET.TC_Nombre								AS Nombre			
						,ET.[TC_Descripcion]						AS Descripcion
						,ET.TF_Actualizacion						AS FechaActualizacion  		
						,'SplitGrupo'								AS SplitGrupo
						,A.TU_CodGrupoEncadenamientoTramite			AS Codigo	
						,A.TC_Nombre								AS Nombre
						,A.TC_Descripcion							AS Descripcion
			FROM		Catalogo.EncadenamientoTramite		ET		WITH(NOLOCK)
			INNER JOIN  Catalogo.GrupoEncadenamientoTramite A		WITH(NOLOCK)
			ON			A.TU_CodGrupoEncadenamientoTramite			= ET.TU_CodGrupoEncadenamientoTramite	
			WHERE		ET.TF_Inicio_Vigencia						<= GETDATE()
			AND			(ET.TF_Fin_Vigencia							IS NULL
			OR			 ET.TF_Fin_Vigencia							>= GETDATE()) 
			ORDER BY ET.TC_Nombre
		END		
		ELSE
		-- TODOS
		IF @L_InicioVigencia IS NULL AND @L_FinVigencia IS NULL
		BEGIN
			SELECT		 ET.TU_CodEncadenamientoTramite				AS Codigo				
						,ET.TF_Inicio_Vigencia						AS FechaActivacion
						,ET.TF_Fin_Vigencia							AS FechaDesactivacion			
						,ET.TC_Nombre								AS Nombre			
						,ET.[TC_Descripcion]						AS Descripcion
						,ET.TF_Actualizacion						AS FechaActualizacion  
						,'SplitGrupo'								AS SplitGrupo
						,A.TU_CodGrupoEncadenamientoTramite			AS Codigo	
						,A.TC_Nombre								AS Nombre
						,A.TC_Descripcion							AS Descripcion
			FROM		Catalogo.EncadenamientoTramite		ET		WITH(NOLOCK)
			INNER JOIN  Catalogo.GrupoEncadenamientoTramite A		WITH(NOLOCK)
			ON			A.TU_CodGrupoEncadenamientoTramite			= ET.TU_CodGrupoEncadenamientoTramite
			ORDER BY	ET.TC_Nombre						 
		END	

	END
END


GO
