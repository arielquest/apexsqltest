SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:		   <Donald Vargas>
-- Fecha Creación: <24/02/2016>
-- Descripcion:	   <Consulta de archivos por expediente>
-- Devuelve lista de archivos por expediente
-- =================================================================================================================================================
-- Modificación:    <Donald Vargas> <25/04/2016> <Se cambia el campo TN_CodTipoArchivo por TN_CodFormatoArchivo>
-- Modificación:    <Donald Vargas> <05/05/2016> <Se agrega los campos de grupo de trabajo y estado>
-- Modificación:	<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación:	<Andrés Díaz> <2017-11-21> <Se cambia el parámetro @CodLegajo a requerido. Se tabula todo el procedimiento.>
-- Modificación:	<Jonathan Aguilar Navarro><30/04/2018><Se modifica TC_CodOficinaCrea por TC_CodContextoCrea y se cambio Oficina por contexto>
-- Modificación:	<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:	<Johan Acosta Ibañez><14/08/2018><Se modifica para que filtre por Fechas y la consulta permita paginación>
-- Modificación:	<Isaac Dobles Mata><20/09/2018><Se cambia nombre a PA_ConsultarArchivoExpediente y se ajusta para consultar tabla Archivo.ArchivoExpediente >
-- Modificación:	<Jonathan Aguilar Navarro><07/01/2019><Se agrega el numero de expediente como parametro de consulta>
-- Modificación:	<Jonathan Aguilar Navarro><29/07/2019><Se modifica la consulta para que excluya los archivos de LegajoArchivo>
-- Modificación:	<Isaac Dobles Mata><15/04/2020><Se modifica la consulta para que devuelva consecutivo de Historial Procesal>
-- Modificación:	<Isaac Dobles Mata><29/05/2020><Se agregan variables locales>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivoExpediente] 
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
						COUNT(*) OVER()					AS Total

			FROM		Archivo.Archivo				A WITH(NOLOCK)

			INNER JOIN	Expediente.ArchivoExpediente	AE WITH(NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo

			INNER JOIN	
			(
				SELECT		AE.TU_CodArchivo
				FROM		Expediente.ArchivoExpediente AE
				WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
				EXCEPT
				SELECT		LA.TU_CodArchivo
				FROM		Expediente.LegajoArchivo LA
				WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
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
			ORDER BY	A.TF_FechaCrea					Asc
			Offset		@L_TF_Indice_Pagina * @L_TF_Cantidad_Pagina Rows
			Fetch Next	@L_TF_Cantidad_Pagina Rows Only;
	END
	ELSE
	BEGIN
			SELECT		A.TU_CodArchivo					AS Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaCrea					AS FechaCrea, 
						AE.TN_Consecutivo				AS ConsecutivoHistorialProcesal,
						'Split'							As	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							As	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							As	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							As	Split,

						G.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,
						G.TC_Descripcion				AS DescripcionGrupoTrabajo,
						G.TF_Inicio_Vigencia			AS FechaActivacionGrupoTrabajo,
						G.TF_Fin_Vigencia				AS FechaDesactivacionGrupoTrabajo,
						A.TN_CodEstado					AS Estado,
						COUNT(*) OVER()					AS	Total
				
			FROM		Archivo.Archivo				A WITH(NOLOCK)

			INNER JOIN  Expediente.ArchivoExpediente	AE WITH (NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo

			INNER JOIN	
			(
				SELECT		AE.TU_CodArchivo
				FROM		Expediente.ArchivoExpediente AE
				WHERE		AE.TC_NumeroExpediente = @L_TC_NumeroExpediente
				EXCEPT
				SELECT		LA.TU_CodArchivo
				FROM		Expediente.LegajoArchivo LA
				WHERE		LA.TC_NumeroExpediente = @L_TC_NumeroExpediente
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
			AND			(A.TF_FechaCrea					>= @L_TF_FechaInicio 
			AND			A.TF_FechaCrea					<= @L_TF_FechaFin)	
			ORDER BY	A.TF_FechaCrea					Asc
			Offset		@L_TF_Indice_Pagina * @L_TF_Cantidad_Pagina Rows
			Fetch Next	@L_TF_Cantidad_Pagina			Rows Only;
	END
END
GO
