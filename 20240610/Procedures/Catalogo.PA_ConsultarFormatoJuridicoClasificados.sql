SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Versión:			1.0
-- Autor:			<Jeffry Hernández>
-- Fecha Creación:	<19/07/2017>
-- Descripción:		<Consulta los registros de FormatoJurídico asociados a Materia y TipoOficina o a Clase y Proceso según los parámetros indicados>
-- ====================================================================================================================================================================================
-- Modificacion:	<09/11/2017> <Jeffry Hernández> <Se separa en los siguientes escenarios: Activos, Inactivos y Todos>
-- Modificacion:	<22/11/2017> <Jeffry Hernández> <Se agrega parámetro @IndicaConsultaExpediente para indicar si se consulta desde Expediente o desde Catálogos>
-- Modificación:	<24/09/2018> <Jonathan Aguilar Navarro> <Se agrega el parametro @AplicaParaExpediente y se agurega a la consulta>
-- Modificación:	<29/05/2019> <Isaac Dobles Mata> <Se ajusta para que consulte la tabla Catalogo.FormatoJuridicoProceso>
-- Modificación:	<18/03/2021> <Ronny Ramírez R.> <Se agrega nuevo campo TB_GenerarVotoAutomatico a la consulta>
-- Modificación:	<23/03/2021> <Jose Gabriel Cordero Soto> <Se agrega parametro de filtrado para generar voto automatico en no o si>
-- Modificación:	<11/05/2021> <Aida Elena Siles R> <Se agrega join con la tabla Catalogo.FormatoJuriComunicacionContexto>
-- Modificación:	<05/08/2022> <Jose Gabriel Cordero Soto> <Se ajusta consutla con respecto a los procesos dado que al filtrar no comparaba por tipo de oficina y materia>
-- Modificación:	<22/08/2022> <Jefferson Parker Cortes> <Se ajusta los valores que recibe como parametros>
-- ====================================================================================================================================================================================
CREATE         PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoClasificados] 
    @Activos					Bit = Null,
	@CodClase					Int = Null,
	@CodProceso					Smallint = Null,
	@CodMateria					Varchar(5) = Null,
	@CodTipoOficina				Smallint = Null,
	@CodGenerarVotoAutomatico	Smallint = Null,
	@IndicaConsultaExpediente	Bit,
	@AplicaParaExpediente       Bit 	
AS
BEGIN
     --**************************************************************************************************
	--SECCION PARA DECLARACIONES
	--DEFINICION DE VARIABLES LOCALES PARA MEJORAR RENDIMIENTO DE CONSULTA
	DECLARE		@L_Activos						BIT								= @Activos,
				@L_CodClase						INT								= @CodClase,
				@L_CodProceso					SMALLINT						= @CodProceso,
				@L_CodMateria					VARCHAR(5)						= @CodMateria,
				@L_CodTipoOficina				SMALLINT						= @CodTipoOficina,
				@L_CodGenerarVotoAutomatico		SMALLINT						= @CodGenerarVotoAutomatico,
				@L_IndicaConsultaExpediente		BIT								= @IndicaConsultaExpediente,
				@L_AplicaParaExpediente         BIT								= @AplicaParaExpediente

	--DECLARACION DE TABLA TEMPORAL
	DECLARE @FormatosAsociados	AS TABLE
	(
		TC_CodFormatoJuridico VARCHAR(8)
	)

	--**************************************************************************************************
	--CONSULTA FINAL
    
	--Se consulta desde expediente 
	IF(@L_IndicaConsultaExpediente = 1)
	BEGIN		
	        --Se insertan los asociados a la materia y tipo de oficina del expediente
			INSERT INTO		@FormatosAsociados
			SELECT DISTINCT A.TC_CodFormatoJuridico		
			FROM			Catalogo.FormatoJuridicoTipoOficina				A	WITH(NOLOCK)
			INNER JOIN		Catalogo.FormatoJuridico						B	WITH(NOLOCK)
			on				B.TC_CodFormatoJuridico							=	A.TC_CodFormatoJuridico		
			
			WHERE  			TN_CodTipoOficina								=	@L_CodTipoOficina
			AND				TC_CodMateria									=	@L_CodMateria
			AND				B.TB_GenerarVotoAutomatico						=	COALESCE (@L_CodGenerarVotoAutomatico, B.TB_GenerarVotoAutomatico)
			AND				B.TB_DocumentoSinExpediente						=	COALESCE (@L_AplicaParaExpediente, B.TB_DocumentoSinExpediente)
		
		    --Se añaden también los asociados a la clase de asunto y proceso del expediente			
			INSERT INTO		@FormatosAsociados
			SELECT DISTINCT A.TC_CodFormatoJuridico							AS	Codigo		
			FROM			Catalogo.FormatoJuridicoProceso					A	WITH(NOLOCK)
			LEFT  JOIN		@FormatosAsociados								B	
			ON				B.TC_CodFormatoJuridico							=	A.TC_CodFormatoJuridico
			INNER JOIN		Catalogo.FormatoJuridico						C	WITH(NOLOCK)
			on				C.TC_CodFormatoJuridico							=	A.TC_CodFormatoJuridico

			WHERE			B.TC_CodFormatoJuridico							IS	NULL	
			AND				TN_CodClase										=	@L_CodClase	
			AND				TN_CodProceso									=	@L_CodProceso 					
			AND				TN_CodTipoOficina								=	@L_CodTipoOficina
			AND				TC_CodMateria									=	@L_CodMateria
			AND				C.TB_GenerarVotoAutomatico						=	COALESCE (@L_CodGenerarVotoAutomatico, C.TB_GenerarVotoAutomatico)
			AND				C.TB_DocumentoSinExpediente						= 	COALESCE (@L_AplicaParaExpediente, C.TB_DocumentoSinExpediente)
	END

	ELSE
	BEGIN 
		
			IF(@L_CodClase													IS NULL		AND
			   @L_CodProceso												IS NULL		AND 
			  (@L_CodTipoOficina											IS NOT NULL	OR 
			   @L_CodMateria IS NOT NULL))
			BEGIN 
			    --Se obtienen los asociados a la materia y tipo de oficina recibidas por parámetro								
				INSERT INTO @FormatosAsociados

				SELECT DISTINCT A.TC_CodFormatoJuridico						CodigoFormato		
				FROM			Catalogo.FormatoJuridicoTipoOficina			A	WITH(NOLOCK)
				INNER JOIN		Catalogo.FormatoJuridico					B	WITH(NOLOCK)
				ON				B.TC_CodFormatoJuridico						=  A.TC_CodFormatoJuridico				
				WHERE  		   (B.TF_Fin_Vigencia							>= GETDATE() Or B.TF_Fin_Vigencia   Is	Null) 
				AND				B.TF_Inicio_Vigencia						<= GETDATE()
				AND				A.TN_CodTipoOficina							=  COALESCE (@L_CodTipoOficina, TN_CodTipoOficina)
				AND				A.TC_CodMateria								=  COALESCE (@L_CodMateria, TC_CodMateria)	
				AND				B.TB_GenerarVotoAutomatico					=  COALESCE (@L_CodGenerarVotoAutomatico, B.TB_GenerarVotoAutomatico)
				AND				B.TB_DocumentoSinExpediente					=  COALESCE (@L_AplicaParaExpediente, B.TB_DocumentoSinExpediente)
			END

			--Se obtienen los asociados a la clase de asunto y procedimiento  recibidos por parámetro			
			INSERT INTO @FormatosAsociados

			SELECT DISTINCT		A.TC_CodFormatoJuridico						Codigo		
			FROM				Catalogo.FormatoJuridicoProceso				A	WITH(NOLOCK)   
			LEFT JOIN			@FormatosAsociados							B 
			ON					B.TC_CodFormatoJuridico						=	A.TC_CodFormatoJuridico
			INNER JOIN			Catalogo.FormatoJuridico					C	WITH(NOLOCK)
			ON					C.TC_CodFormatoJuridico						=	A.TC_CodFormatoJuridico
			INNER JOIN			Catalogo.FormatoJuridicoTipoOficina			D   WITH(NOLOCK)
			ON					D.TC_CodFormatoJuridico						=   A.TC_CodFormatoJuridico
			AND					D.TC_CodMateria								=   A.TC_CodMateria
			AND					D.TN_CodTipoOficina							=   A.TN_CodTipoOficina
			WHERE				B.TC_CodFormatoJuridico						IS  NULL	
			AND				   (C.TF_Fin_Vigencia							>=  GETDATE() Or C.TF_Fin_Vigencia   Is	Null) 
			AND    			    C.TF_Inicio_Vigencia						<=	GETDATE()
			AND					A.TN_CodClase								=   COALESCE (@L_CodClase, TN_CodClase)	
			AND					A.TN_CodProceso								=	COALESCE (@L_CodProceso, TN_CodProceso)
			AND					A.TN_CodTipoOficina							=	COALESCE (@L_CodTipoOficina, A.TN_CodTipoOficina)
			AND					A.TC_CodMateria								=	COALESCE (@L_CodMateria, A.TC_CodMateria)	
			AND					C.TB_GenerarVotoAutomatico					=	COALESCE (@L_CodGenerarVotoAutomatico, C.TB_GenerarVotoAutomatico)
			AND					C.TB_DocumentoSinExpediente					=	COALESCE (@L_AplicaParaExpediente,C.TB_DocumentoSinExpediente)					
			
	END

	IF(@L_Activos = 1)
	BEGIN 
	SELECT	 
			 A.TC_CodFormatoJuridico	AS Codigo			
			,TC_Descripcion				AS Descripcion		,TF_Inicio_Vigencia			AS FechaInicio
			,TF_Fin_Vigencia			AS FechaFin			,TN_CodGrupoFormatoJuridico	AS CodigoGrupo
			,TU_IDArchivoFSActual		AS ArchivoFSActual	,TU_IDArchivoFSVersionado	AS ArchivoFSVersionado
			,TC_Nombre					AS Nombre			,TC_UsuarioRed				AS UsuarioRed
			,TF_Creado					AS Creado			,TB_EjecucionMasiva			AS EjecucionMasiva
			,TB_Notifica				AS Notifica			,TN_Ordenamiento			AS Ordenamiento
			,TF_Actualizacion			AS Actualizacion	,A.TB_GenerarVotoAutomatico	AS GenerarVotoAutomatico
			,'Split'					AS Split			,TC_Categorizacion			AS Categorizacion	
	
			FROM		Catalogo.FormatoJuridico				 A	WITH(NOLOCK)
			INNER JOIN  @FormatosAsociados						 B 
			ON          B.TC_CodFormatoJuridico					 =	A.TC_CodFormatoJuridico
			WHERE	   (A.TF_Fin_Vigencia						 >= GETDATE() Or A.TF_Fin_Vigencia   Is	Null) 
			AND			A.TF_Inicio_Vigencia					 <=	GETDATE()
			AND			A.TB_GenerarVotoAutomatico				 =	COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
			AND			A.TB_DocumentoSinExpediente				 =	COALESCE (@L_AplicaParaExpediente, A.TB_DocumentoSinExpediente)

			ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
	END
	ELSE

		IF(@L_Activos = 0)
		BEGIN 
		SELECT	 
				 A.TC_CodFormatoJuridico	AS Codigo			
				,TC_Descripcion				AS Descripcion		,TF_Inicio_Vigencia			AS FechaInicio
				,TF_Fin_Vigencia			AS FechaFin			,TN_CodGrupoFormatoJuridico	AS CodigoGrupo
				,TU_IDArchivoFSActual		AS ArchivoFSActual	,TU_IDArchivoFSVersionado	AS ArchivoFSVersionado
				,TC_Nombre					AS Nombre			,TC_UsuarioRed				AS UsuarioRed
				,TF_Creado					AS Creado			,TB_EjecucionMasiva			AS EjecucionMasiva
				,TB_Notifica				AS Notifica			,TN_Ordenamiento			AS Ordenamiento
				,TF_Actualizacion			AS Actualizacion	,A.TB_GenerarVotoAutomatico	AS GenerarVotoAutomatico
				,'Split'					AS Split			,TC_Categorizacion			AS Categorizacion	
	
				FROM		Catalogo.FormatoJuridico			A	WITH(NOLOCK)
				INNER JOIN  @FormatosAsociados					B 
				ON          B.TC_CodFormatoJuridico				=	A.TC_CodFormatoJuridico
				
				WHERE   TF_Fin_Vigencia							<	GETDATE()  
				OR      TF_Inicio_Vigencia						>	GETDATE()
				AND		A.TB_GenerarVotoAutomatico				=	COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
				AND		A.TB_DocumentoSinExpediente				=	COALESCE (@L_AplicaParaExpediente, A.TB_DocumentoSinExpediente)
							
				ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento

		END
		ELSE
			IF(@L_Activos IS NULL)
			BEGIN 
			SELECT	 
					 A.TC_CodFormatoJuridico	AS Codigo			
					,TC_Descripcion				AS Descripcion		,A.TF_Inicio_Vigencia		AS FechaInicio
					,TF_Fin_Vigencia			AS FechaFin			,TN_CodGrupoFormatoJuridico	AS CodigoGrupo
					,TU_IDArchivoFSActual		AS ArchivoFSActual	,TU_IDArchivoFSVersionado	AS ArchivoFSVersionado
					,TC_Nombre					AS Nombre			,TC_UsuarioRed				AS UsuarioRed
					,TF_Creado					AS Creado			,TB_EjecucionMasiva			AS EjecucionMasiva
					,TB_Notifica				AS Notifica			,TN_Ordenamiento			AS Ordenamiento
					,TF_Actualizacion			AS Actualizacion	,A.TB_GenerarVotoAutomatico	AS GenerarVotoAutomatico
					,IIF((C.TC_CodFormatoJuridico IS NULL), 0, 1)								AS EmiteComunicacionAutomatica
					,'Split'					AS Split			,TC_Categorizacion			AS Categorizacion	
	
					FROM		Catalogo.FormatoJuridico					A WITH(NOLOCK)
					INNER JOIN  @FormatosAsociados							B 
					On          B.TC_CodFormatoJuridico						= A.TC_CodFormatoJuridico
					LEFT JOIN	Catalogo.FormatoJuriComunicacionContexto	C WITH(NOLOCK)
					ON			A.TC_CodFormatoJuridico						= C.TC_CodFormatoJuridico
					AND			A.TB_GenerarVotoAutomatico		=	COALESCE (@L_CodGenerarVotoAutomatico, A.TB_GenerarVotoAutomatico)
					AND			A.TB_DocumentoSinExpediente		=	COALESCE (@L_AplicaParaExpediente, A.TB_DocumentoSinExpediente)
									
					ORDER BY CASE WHEN TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, TN_Ordenamiento
			END
END
GO
