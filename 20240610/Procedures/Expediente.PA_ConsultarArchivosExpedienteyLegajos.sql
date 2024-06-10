SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Josué Quirós Batista>
-- Fecha de creación:		<11/10/2021>
-- Descripción :			<Consulta los archivos asociados al expediente principal y, además, los asociados a sus legajos.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivosExpedienteyLegajos] 
	@Codigo				uniqueidentifier	= NULL, 	
	@Descripcion		varchar(255)		= NULL,
	@CodContextoCrea	varchar(4)			= NULL,
	@CodFormatoArchivo	smallint			= NULL, 
	@UsuarioCrea		varchar(30)			= NULL,
	@CodGrupoTrabajo	smallint			= NULL,
	@CodEstado			tinyint				= NULL,
	@FechaInicio		DateTime2			= NULL,
	@FechaFin			DateTime2			= NULL,
	@IndicePagina		smallint			= Null,
	@CantidadPagina		smallint			= Null,
	@NumeroExpediente	varchar(14)
AS
BEGIN

	
	Declare 
	@L_TU_CodArchivo				uniqueidentifier		= @Codigo,    
	@L_TC_Descripcion				varchar(255)            = @Descripcion,
	@L_TC_CodContextoCrea			varchar(4)				= @CodContextoCrea, 
	@L_TN_CodFormatoArchivo			smallint				= @CodFormatoArchivo,    
	@L_TC_UsuarioCrea				varchar(30)				= @UsuarioCrea,    
	@L_TN_CodGrupoTrabajo			smallint				= @CodGrupoTrabajo,    
	@L_TN_CodEstado					tinyint					= @CodEstado, 
	@L_TF_FechaInicio				DateTime2				= @FechaInicio,    
	@L_TF_FechaFin					DateTime2				= @FechaFin,    
	@L_TF_Indice_Pagina             smallint				= @IndicePagina,    
	@L_TF_Cantidad_Pagina           smallint				= @CantidadPagina,
	@L_TC_NumeroExpediente          varchar(14)				= @NumeroExpediente

	If (@L_TF_Indice_Pagina Is Null Or @L_TF_Cantidad_Pagina Is Null)
	Begin
		SET @L_TF_Indice_Pagina = 0;
		SET @L_TF_Cantidad_Pagina = 32767;
	End

	IF (@L_TF_FechaInicio IS NULL AND @L_TF_FechaFin IS NULL)
	BEGIN
			SELECT		A.TU_CodArchivo					AS Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaCrea					AS FechaCrea,
						AE.TN_Consecutivo				AS ConsecutivoHistorialProcesal,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						G.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,
						G.TC_Descripcion				AS DescripcionGrupoTrabajo,
						G.TF_Inicio_Vigencia			AS FechaActivacionGrupoTrabajo,
						G.TF_Fin_Vigencia				AS FechaDesactivacionGrupoTrabajo,
						A.TN_CodEstado					AS Estado,
						COUNT(*) OVER()					AS Total,

						NULL							As CodArchivoEscrito,
						NULL							As PuestoTrabajoCreador,
						NULL							As EstadoEscrito,
						NULL							As CodTipoEscrito,
						NULL							As FechIngresoOficina,
						NULL							As FechaEnvio,
						NULL							As FechaRegistro,
						NULL							As VariasGestiones,
						NULL							As TFParticion


			FROM		Archivo.Archivo				A WITH(NOLOCK)

			INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo

			INNER JOIN	
			(
				SELECT		AE.TU_CodArchivo
				FROM		Expediente.ArchivoExpediente AE
				WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
			) AS X
			ON			X.TU_CodArchivo = A.TU_CodArchivo 		

			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			A.TC_CodContextoCrea			= D.TC_CodContexto
	
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			A.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
	
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed
	
			INNER JOIN	Catalogo.GrupoTrabajo			G WITH(NOLOCK)
			ON			AE.TN_CodGrupoTrabajo			= G.TN_CodGrupoTrabajo

			WHERE		A.TU_CodArchivo					= ISNULL(@L_TU_CodArchivo, A.TU_CodArchivo)
			AND			(A.TC_Descripcion				LIKE '%' + ISNULL(@L_TC_Descripcion ,A.TC_Descripcion) + '%' OR @L_TC_Descripcion IS NULL)
			AND			A.TC_CodContextoCrea			= ISNULL(@L_TC_CodContextoCrea, A.TC_CodContextoCrea)
			AND			A.TN_CodFormatoArchivo			= ISNULL(@L_TN_CodFormatoArchivo, A.TN_CodFormatoArchivo)
			AND			A.TC_UsuarioCrea				LIKE '%' + ISNULL(@L_TC_UsuarioCrea ,A.TC_UsuarioCrea) + '%'
			AND			AE.TN_CodGrupoTrabajo			= ISNULL(@L_TN_CodGrupoTrabajo, AE.TN_CodGrupoTrabajo)
			AND			A.TN_CodEstado					= ISNULL(@L_TN_CodEstado, A.TN_CodEstado)
			AND			AE.TC_NumeroExpediente			= ISNULL(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)
			
			UNION 

			SELECT		A.TC_IDARCHIVO					AS Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaEnvio 				AS FechaCrea,
						A.TN_Consecutivo				AS ConsecutivoHistorialProcesal,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						A.TN_CodTipoEscrito				AS Codigo,
						NULL							AS Descripcion,
						NULL							AS FechaActivacion,
						NULL							AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						G.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,
						G.TC_Descripcion				AS DescripcionGrupoTrabajo,
						G.TF_Inicio_Vigencia			AS FechaActivacionGrupoTrabajo,
						G.TF_Fin_Vigencia				AS FechaDesactivacionGrupoTrabajo,
						0								AS Estado,
						COUNT(*) OVER()					AS Total,

						A.TC_IDARCHIVO					As CodArchivoEscrito,
						A.TC_CodPuestoTrabajo			As PuestoTrabajoCreador,
						A.TC_EstadoEscrito				As EstadoEscrito,
						A.TN_CodTipoEscrito  			As CodTipoEscrito,
						A.TF_FechaIngresoOficina		As FechIngresoOficina,
						A.TF_FechaEnvio					As FechaEnvio,
						A.TF_FechaRegistro				As FechaRegistro,
						A.TB_VariasGestiones			As VariasGestiones,
						A.TF_Particion					As TFParticion

			FROM		Expediente.EscritoExpediente 				A WITH(NOLOCK)

			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			A.TC_CodContexto  			   = D.TC_CodContexto

			Outer Apply (Select Top 1 TU_CodPuestoFuncionario, TC_CodPuestoTrabajo, TC_UsuarioRed
						 From  Catalogo.PuestoTrabajoFuncionario 
						 Where TC_CodPuestoTrabajo							= A.TC_CodPuestoTrabajo 
						 And   (TF_Fin_Vigencia IS NULL OR TF_Fin_Vigencia  >= GetDate()) 
						 Order by TF_Inicio_Vigencia Desc
					    ) OA	
	
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			F.TC_UsuarioRed				    = OA.TC_UsuarioRed
	
			INNER JOIN	Catalogo.GrupoTrabajoPuesto		GTP WITH(NOLOCK)
			ON			GTP.TC_CodPuestoTrabajo			= OA.TC_CodPuestoTrabajo
			And			GTP.TC_CodContexto			    = A.TC_CodContexto
			
			INNER JOIN	Catalogo.GrupoTrabajo			G WITH(NOLOCK)
			ON			G.TN_CodGrupoTrabajo			= GTP.TN_CodGrupoTrabajo

			WHERE		A.TC_IDARCHIVO					= ISNULL(@L_TU_CodArchivo, A.TC_IDARCHIVO)
			AND			(A.TC_Descripcion				LIKE '%' + ISNULL(@L_TC_Descripcion ,A.TC_Descripcion) + '%' OR NULL IS NULL)
			AND			A.TC_CodContexto				= ISNULL(@L_TC_CodContextoCrea, A.TC_CodContexto)
			AND			A.TC_NumeroExpediente			= ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)

			ORDER BY	A.TF_FechaCrea					Asc
			Offset		@L_TF_Indice_Pagina * @L_TF_Cantidad_Pagina Rows
			Fetch Next	@L_TF_Cantidad_Pagina Rows Only;
	END
END
GO
