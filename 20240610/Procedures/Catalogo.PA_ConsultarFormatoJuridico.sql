SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================
-- Autor:		   <Donald Vargas>
-- Fecha Creación: <03/05/2016>
-- Descripcion:	   <Consultar formato jurídico>
-- =========================================================================================================================================
-- Modificación:   <08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:   <17/07/2016> <Diego Navarrete> <Se modifica la consulta, debio a los cambios aplicados>
-- Modificación:   <21/11/2017> <Diego Navarrete> <Se agrega la condición, para Formatos positivos>
-- Modificación:   <28/11/2017> <Ailyn López> <Se agrega los filtros "@Descripcion" y "@CodGrupoFormatoJuridico", cuando no es vigente.>
-- Modificación:   <08/02/2018> <Andrés Díaz> <Se cambia el tipo del parámetro @Codigo a varchar(8).>
-- Modificación:   <13/03/2018> <Jefry Hernández> <Se cambia el ORDER BY. Se eliminan los parámetros @Codigo, @Descripcion y @CodGrupoFormatoJuridico ya que no se han utilizado.>
-- Modificación:   <24/09/2018> <Jonathan Aguilar Navarro> <Se agrega el parametro @AplicaParaExpediente y se agurega a la consulta>
-- Modificacion:   <17/03/2021> <Jose Gabriel Cordero Soto> <Se agrega en inserción el campo indicador de generardor de voto automatico>
-- Modificación:   <23/03/2021> <Jose Gabriel Cordero Soto> <Se agrega parametro de filtrado para generar voto automatico en no o si>
-- Modificacion:   <13/07/2021><Daniel Ruiz Hernández> <Se agrega el parametro PaseFallo para indicar si el formato juridico utiliza esta funcionalidad>
-- Modificacion:   <27/01/2022><Karol Jiménez Sánchez> <Se agrega el parametro @CodFormatoJuridico para realizar la consulta de un formato jurídico en específico>
-- Modificacion:   <23/02/2022><Karol Jiménez Sánchez> <Se agrega funcionalidad para poder consultar una lista de formatos jurídicos por el parámetro @CodFormatoJuridico, enviandolos separados por ',' (coma) cuando se requieren consultar varios>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridico] 
	@InicioVigencia				datetime2		= Null,
	@FinVigencia				datetime2		= Null,
	@CodGenerarVotoAutomatico	bit				= null,
	@AplicaParaExpediente       bit				= Null,
	@CodFormatoJuridico			Varchar(500)	= Null
AS
BEGIN

	-- Variables locales
	DECLARE @L_InicioVigencia				datetime2		= @InicioVigencia,
			@L_FinVigencia					datetime2		= @FinVigencia,
			@L_CodGenerarVotoAutomatico		bit				= @CodGenerarVotoAutomatico,
			@L_AplicaParaExpediente			bit				= @AplicaParaExpediente,
@L_CodFormatoJuridico			Varchar(500)		= @CodFormatoJuridico

	--Consulta un formato jurídico en específico sin importar otras condiciones
	IF @L_CodFormatoJuridico IS NOT NULL
	BEGIN
		SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
				,A.TC_Descripcion							AS Descripcion		
				,A.TF_Inicio_Vigencia						AS FechaInicio
				,A.TF_Fin_Vigencia							AS FechaFin			
				,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
				,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
				,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
				,A.TC_Nombre								AS Nombre			
				,A.TC_UsuarioRed							AS UsuarioRed
				,A.TF_Creado								AS Creado			
				,A.TB_EjecucionMasiva						AS EjecucionMasiva
				,A.TB_Notifica								AS Notifica			
				,A.TN_Ordenamiento							AS Ordenamiento
				,A.TF_Actualizacion							AS Actualizacion   			
				,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
				,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
				,A.TB_PaseFallo								AS PaseFallo
				,'SplitCategorizacion'						AS SplitCategorizacion
				,A.TC_Categorizacion						AS Categorizacion
				FROM	 Catalogo.FormatoJuridico			A WITH(NOLOCK)		
				WHERE	A.TC_CodFormatoJuridico				in (	SELECT	value  
																	FROM	STRING_SPLIT(@L_CodFormatoJuridico, ','))	
				ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
	END
	ELSE
	BEGIN
		-- No vigentes hoy
		IF @L_InicioVigencia IS NULL AND @L_FinVigencia IS NOT NULL
			BEGIN
				IF @L_AplicaParaExpediente IS NOT NULL
					BEGIN
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 
							BEGIN
								SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   			
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion
			
			
										FROM	 Catalogo.FormatoJuridico			A WITH(NOLOCK)		
			
										WHERE	(A.TF_Inicio_Vigencia				> GETDATE() 
										OR	 	 A.TF_Fin_Vigencia					< GETDATE())
										AND		 A.TB_GenerarVotoAutomatico			=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
										AND		 A.TB_DocumentoSinExpediente		=  COALESCE (@L_AplicaParaExpediente, A.TB_DocumentoSinExpediente)					
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE
							BEGIN
								SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   			
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion
			
			
										FROM	 Catalogo.FormatoJuridico			A WITH(NOLOCK)		
			
										WHERE	(A.TF_Inicio_Vigencia				> GETDATE() 
										OR	 	 A.TF_Fin_Vigencia					< GETDATE())		
										AND		 A.TB_DocumentoSinExpediente		=  COALESCE (@L_AplicaParaExpediente, A.TB_DocumentoSinExpediente)		
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END	
				ELSE
					BEGIN				
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 
							BEGIN
								SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion			
				
										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)
		
										WHERE  (A.TF_Inicio_Vigencia				> GETDATE() 
										OR		A.TF_Fin_Vigencia					< GETDATE())
										AND		A.TB_GenerarVotoAutomatico			=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)

										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE
							BEGIN
								SELECT 	 A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion			
				
										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)
		
										WHERE  (A.TF_Inicio_Vigencia				> GETDATE() 
										OR		A.TF_Fin_Vigencia					< GETDATE())

										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END
			END
		-- Vigentes
		ELSE 
			IF @L_InicioVigencia IS NOT NULL AND @L_FinVigencia IS NULL
			BEGIN
				IF @L_AplicaParaExpediente IS NOT NULL
					BEGIN
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 
							BEGIN
									SELECT	 
								  			A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion  
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion			

										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)	
			
										WHERE	A.TF_Inicio_Vigencia				<= GETDATE()
										AND   ((A.TF_Fin_Vigencia					IS NULL)
										OR	   (A.TF_Fin_Vigencia					>= GETDATE())) 
										AND	    A.TB_GenerarVotoAutomatico			=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
										AND		A.TB_DocumentoSinExpediente			=  COALESCE (@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente) 
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE
							BEGIN
									SELECT	 
											A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion  
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion
										,A.TC_Categorizacion						AS Categorizacion			

										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)	
			
										WHERE	A.TF_Inicio_Vigencia				<=	GETDATE()
										AND   ((A.TF_Fin_Vigencia					IS NULL)
										OR	   (A.TF_Fin_Vigencia					>= GETDATE())) 									
										AND		A.TB_DocumentoSinExpediente			=  COALESCE (@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente) 
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END
				ELSE
					BEGIN
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 	
							BEGIN
								SELECT	     A.TC_CodFormatoJuridico					AS Codigo			
											,A.TC_Descripcion							AS Descripcion		
											,A.TF_Inicio_Vigencia						AS FechaInicio
											,A.TF_Fin_Vigencia							AS FechaFin			
											,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
											,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
											,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
											,A.TC_Nombre								AS Nombre			
											,A.TC_UsuarioRed							AS UsuarioRed
											,A.TF_Creado								AS Creado			
											,A.TB_EjecucionMasiva						AS EjecucionMasiva
											,A.TB_Notifica								AS Notifica			
											,A.TN_Ordenamiento							AS Ordenamiento
											,A.TF_Actualizacion							AS Actualizacion  
											,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
											,A.TB_PaseFallo								AS PaseFallo
											,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
											,'SplitCategorizacion'						AS SplitCategorizacion
											,A.TC_Categorizacion						AS Categorizacion			

									FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
									WHERE	A.TF_Inicio_Vigencia						<= GETDATE()
									AND   ((A.TF_Fin_Vigencia							IS NULL)
									OR	   (A.TF_Fin_Vigencia							>= GETDATE())) 
									AND	    A.TB_GenerarVotoAutomatico					=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)			
			
									ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE
							BEGIN
								SELECT		 A.TC_CodFormatoJuridico					AS Codigo			
											,A.TC_Descripcion							AS Descripcion		
											,A.TF_Inicio_Vigencia						AS FechaInicio
											,A.TF_Fin_Vigencia							AS FechaFin			
											,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
											,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
											,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
											,A.TC_Nombre								AS Nombre			
											,A.TC_UsuarioRed							AS UsuarioRed
											,A.TF_Creado								AS Creado			
											,A.TB_EjecucionMasiva						AS EjecucionMasiva
											,A.TB_Notifica								AS Notifica			
											,A.TN_Ordenamiento							AS Ordenamiento
											,A.TF_Actualizacion							AS Actualizacion  
											,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
											,A.TB_PaseFallo								AS PaseFallo
											,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
											,'SplitCategorizacion'						AS SplitCategorizacion
											,A.TC_Categorizacion						AS Categorizacion			

									FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
									WHERE	A.TF_Inicio_Vigencia						<= GETDATE()
									AND   ((A.TF_Fin_Vigencia							IS NULL)
									OR	   (A.TF_Fin_Vigencia							>= GETDATE())) 
									
									ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END
			END		
		ELSE		
			-- TODOS
			IF @L_InicioVigencia IS NULL AND @L_FinVigencia IS NULL
			BEGIN
				IF @L_AplicaParaExpediente IS NOT NULL
					BEGIN
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 	
							BEGIN
								SELECT   A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion	
										,A.TC_Categorizacion						AS Categorizacion

										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)
			
										WHERE	A.TB_DocumentoSinExpediente			=  COALESCE (@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente)		
										AND	    A.TB_GenerarVotoAutomatico			=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE 
							BEGIN
								SELECT   A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion	
										,A.TC_Categorizacion						AS Categorizacion

										FROM	Catalogo.FormatoJuridico			A WITH(NOLOCK)
			
										WHERE	A.TB_DocumentoSinExpediente			=  COALESCE (@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente)												
			
										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END
				ELSE
					BEGIN
						IF @L_CodGenerarVotoAutomatico IS NOT NULL 	
							BEGIN
								SELECT   A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion	
										,A.TC_Categorizacion						AS Categorizacion

										FROM Catalogo.FormatoJuridico				A WITH(NOLOCK)				
										WHERE A.TB_GenerarVotoAutomatico			= COALESCE(@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)

										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
						ELSE
							BEGIN
								SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
										,A.TC_Descripcion							AS Descripcion		
										,A.TF_Inicio_Vigencia						AS FechaInicio
										,A.TF_Fin_Vigencia							AS FechaFin			
										,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
										,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
										,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
										,A.TC_Nombre								AS Nombre			
										,A.TC_UsuarioRed							AS UsuarioRed
										,A.TF_Creado								AS Creado			
										,A.TB_EjecucionMasiva						AS EjecucionMasiva
										,A.TB_Notifica								AS Notifica			
										,A.TN_Ordenamiento							AS Ordenamiento
										,A.TF_Actualizacion							AS Actualizacion   
										,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
										,A.TB_PaseFallo								AS PaseFallo
										,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
										,'SplitCategorizacion'						AS SplitCategorizacion	
										,A.TC_Categorizacion						AS Categorizacion

										FROM Catalogo.FormatoJuridico				A WITH(NOLOCK)														

										ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
							END
					END	
			END
		ELSE 
			-- Por rango
			IF @L_AplicaParaExpediente IS NOT NULL
				BEGIN
					IF @L_CodGenerarVotoAutomatico IS NOT NULL 
						BEGIN
							SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
									,A.TC_Descripcion							AS Descripcion		
									,A.TF_Inicio_Vigencia						AS FechaInicio
									,A.TF_Fin_Vigencia							AS FechaFin			
									,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
									,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
									,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
									,A.TC_Nombre								AS Nombre			
									,A.TC_UsuarioRed							AS UsuarioRed
									,A.TF_Creado								AS Creado			
									,A.TB_EjecucionMasiva						AS EjecucionMasiva
									,A.TB_Notifica								AS Notifica			
									,A.TN_Ordenamiento							AS Ordenamiento
									,A.TF_Actualizacion							AS Actualizacion   
									,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
									,A.TB_PaseFallo								AS PaseFallo
									,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
									,'SplitCategorizacion'						AS SplitCategorizacion	
									,A.TC_Categorizacion						AS Categorizacion

							FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
							WHERE	A.TF_Inicio_Vigencia						>= @L_InicioVigencia 
							AND		A.TF_Fin_Vigencia							<= @L_FinVigencia
							AND		A.TB_DocumentoSinExpediente					=  COALESCE(@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente)		
							AND	    A.TB_GenerarVotoAutomatico					=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
			
							ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
						END
					ELSE
						BEGIN
							SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
									,A.TC_Descripcion							AS Descripcion		
									,A.TF_Inicio_Vigencia						AS FechaInicio
									,A.TF_Fin_Vigencia							AS FechaFin			
									,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
									,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
									,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
									,A.TC_Nombre								AS Nombre			
									,A.TC_UsuarioRed							AS UsuarioRed
									,A.TF_Creado								AS Creado			
									,A.TB_EjecucionMasiva						AS EjecucionMasiva
									,A.TB_Notifica								AS Notifica			
									,A.TN_Ordenamiento							AS Ordenamiento
									,A.TF_Actualizacion							AS Actualizacion   
									,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
									,A.TB_PaseFallo								AS PaseFallo
									,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
									,'SplitCategorizacion'						AS SplitCategorizacion	
									,A.TC_Categorizacion						AS Categorizacion

							FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
							WHERE	A.TF_Inicio_Vigencia						>= @L_InicioVigencia 
							AND		A.TF_Fin_Vigencia							<= @L_FinVigencia
							AND		A.TB_DocumentoSinExpediente					=  COALESCE(@L_AplicaParaExpediente,A.TB_DocumentoSinExpediente)							
			
							ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
						END			
				END
			ELSE
				BEGIN
					IF @L_CodGenerarVotoAutomatico IS NOT NULL 
						BEGIN
							SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
									,A.TC_Descripcion							AS Descripcion		
									,A.TF_Inicio_Vigencia						AS FechaInicio
									,A.TF_Fin_Vigencia							AS FechaFin			
									,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
									,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
									,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
									,A.TC_Nombre								AS Nombre			
									,A.TC_UsuarioRed							AS UsuarioRed
									,A.TF_Creado								AS Creado			
									,A.TB_EjecucionMasiva						AS EjecucionMasiva
									,A.TB_Notifica								AS Notifica			
									,A.TN_Ordenamiento							AS Ordenamiento
									,A.TF_Actualizacion							AS Actualizacion   
									,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
									,A.TB_PaseFallo								AS PaseFallo
									,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
									,'SplitCategorizacion'						AS SplitCategorizacion	
									,A.TC_Categorizacion						AS Categorizacion

							FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
							WHERE	A.TF_Inicio_Vigencia						>= @L_InicioVigencia 
							AND		A.TF_Fin_Vigencia							<= @L_FinVigencia						
							AND	    A.TB_GenerarVotoAutomatico					=  COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)

							ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
						END
					ELSE
						BEGIN
							SELECT	 A.TC_CodFormatoJuridico					AS Codigo			
									,A.TC_Descripcion							AS Descripcion		
									,A.TF_Inicio_Vigencia						AS FechaInicio
									,A.TF_Fin_Vigencia							AS FechaFin			
									,A.TN_CodGrupoFormatoJuridico				AS CodigoGrupo
									,A.TU_IDArchivoFSActual						AS ArchivoFSActual	
									,A.TU_IDArchivoFSVersionado					AS ArchivoFSVersionado
									,A.TC_Nombre								AS Nombre			
									,A.TC_UsuarioRed							AS UsuarioRed
									,A.TF_Creado								AS Creado			
									,A.TB_EjecucionMasiva						AS EjecucionMasiva
									,A.TB_Notifica								AS Notifica			
									,A.TN_Ordenamiento							AS Ordenamiento
									,A.TF_Actualizacion							AS Actualizacion   
									,A.TB_GenerarVotoAutomatico					AS GenerarVotoAutomatico
									,A.TB_PaseFallo								AS PaseFallo
									,COALESCE(A.TB_DocumentoSinExpediente , 0)	AS AplicaParaExpediente
									,'SplitCategorizacion'						AS SplitCategorizacion	
									,A.TC_Categorizacion						AS Categorizacion

							FROM	Catalogo.FormatoJuridico					A WITH(NOLOCK)	
			
							WHERE	A.TF_Inicio_Vigencia						>= @L_InicioVigencia 
							AND		A.TF_Fin_Vigencia							<= @L_FinVigencia															

							ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
						END
				END	
	END
END
GO
