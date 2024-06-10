SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<08/06/2016>
-- Descripción :			<Permite Consultar las resoluciones de expediente> 
--Modificacion				<21/07/2016><Gerardo Lopez><Cambiar oficinafuncionario en campo responsable por puesto trabajo>
-- =========================================================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =========================================================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <06/07/2018> <Se elimina de la consulta los campos [TU_CodLegajo], 
--							[TC_CodOficina],[TN_CodEstadoResolucion] [TN_CodEnvioJurisprudencia], [TB_TribunalColegiado], [TC_NumeroResolucion], [TB_Recurrente]
--							y los JOIN correspondiente>
-- Modificacion				<Jonathan Aguilar Navarro> <12/07/2018> <Se agrega el parametro @CodArchivo para dar la posbilidad>
--							de consultar por ese parametro.
-- Modificación:			<30/07/2018> <Gerardo Lopez> <Agregar campos para envio jurisprudencia> 
-- Modificación				<Jonathan Aguilar Navarro> <22/08/2018> <Se modificar el sp para obtener la información del número de resolución asociado al registro de resolución>
-- Modificación				<Jonathan Aguilar Navarro> <05/09/2018> <Se modificar el sp para obtener la información del Categoría de la Resolución>
-- Modificación				<Isaac Dobles Mata> <26/09/2018> <Se modifica para tomar en cuenta consulta a tablas Archivo y ArchivoExpediente, se agrega código de legajo como parámetro>
-- Modificación:			<Jonathan Aguilar Navarro> <30/10/2018> <Se agrega a la consulta la posibilidad de consultar por codigo de legajo> 
-- Modificación:			<Jonathan Aguilar Navarro> <06/08/2019> <Se modifica el parametro de consulta CodLegajo por NumeroExpediente, y se quita el JOIN con LegajoArchivo>
-- Modificación:			<Kirvin Bennett Mathurin> <21/07/2020> <Se agrega a la consulta la posibilidad de consultar por codigo de legajo> 
-- Modificación:			<Kirvin Bennett Mathurin> <30/07/2020> <Se incluye que retorne el número de expediente> 
-- Modificación				<Jonathan Aguilar Navarro> <07/10/2020> <Se agrega el parámetro del estado del archivo>
-- Modificación				<Jonathan Aguilar Navarro> <21/10/2020> <Se modifica para obtener los datos del contexto con la tabla Expediente.Resolucion>
-- Modificación				<Jonathan Aguilar Navarro> <25/03/2021> <Se modifica para agregar a la consulta el codigo del libro de sentencia>
-- Modificación				<Aida Elena Siles R> <13/08/2021> <Se agrega a la consulta el nombre completo del redactor>
-- Modificación				<Jefferson Parker Cortes> <26/10/2022> <Se agrega filtro entre archivo y resolucion para retornar solo resoluciones con documentos terminados expediente>
-- Modificación				<Jefferson Parker Cortes> <07/11/2022> <Se agrega filtro entre archivo y resolucion para retornar solo resoluciones con documentos terminados en legajos>
-- Modificación:			<Josué Quirós Batista> <10/03/2023> <Se agrega un join con Expediente.Legajo en el condicional @L_CodLegajo IS NOT NULL.>
-- Modificación				<Ronny Ramírez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE en el WHERE>
--============================================================================================================================================================================================
CREATE      PROCEDURE [Expediente].[PA_ConsultarResolucion]
@CodResolucion				UNIQUEIDENTIFIER,
@CodArchivo					UNIQUEIDENTIFIER,
@NumeroExpediente			VARCHAR(14)		,
@CodLegajo					UNIQUEIDENTIFIER,
@Estado						TINYINT			

AS
BEGIN
DECLARE @L_CodResolucion		UNIQUEIDENTIFIER = @CodResolucion,
		@L_CodArchivo			UNIQUEIDENTIFIER = @CodArchivo,
		@L_NumeroExpediente		VARCHAR(14)		 = @NumeroExpediente,
		@L_CodLegajo			UNIQUEIDENTIFIER = @CodLegajo,
		@L_Estado				TINYINT			 = @Estado	


IF (@L_CodResolucion IS NOT NULL)
	SELECT	R.TU_CodResolucion						AS CodigoResolucion,			
			R.TF_FechaCreacion						AS FechaCreacion,
			R.TF_FechaResolucion					AS FechaResolucion, 
			R.TC_PorTanto							AS PorTanto,				
			R.TC_Resumen							AS Resumen, 
			R.TU_CodArchivo							AS CodigoArchivo,
			R.TB_Relevante                          AS EsRelevante,
			R.TB_DatoSensible                       AS DatoSensible,
			R.TC_DescripcionSensible                AS DescripcionSensible,
			R.TF_FechaEnvioSAS                      AS FechaEnvioSAS,
			R.TC_UsuarioRedSAS                      AS UsuarioRedSAS,
			R.TC_NumeroExpediente					AS NumeroExpediente,
			'split'									AS split,
			TR.TN_CodTipoResolucion					AS Codigo,		
			TR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			RR.TN_CodResultadoResolucion			AS Codigo,	
			RR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			CR.TN_CodCategoriaResolucion			AS Codigo,	
			CR.TC_Descripcion						AS Descripcion,
			'split'									AS split, 
			 F.TC_UsuarioRed                        AS UsuarioRed,
			 F.TC_Nombre                            AS Nombre,
			 F.TC_PrimerApellido                    AS PrimerApellido,
			 F.TC_SegundoApellido                   AS SegundoApellido,
			'split'									AS split,
			 R.TU_RedactorResponsable				AS Codigo,
			'split'									AS split,
			AR.TU_CodArchivo						AS Codigo,				
			AR.TC_Descripcion						AS Descripcion, 
			AR.TN_CodEstado							AS EstadoDocumento,					  
			R.TC_EstadoEnvioSAS			            AS EstadoEnvioSAS,
			G.TC_AnnoSentencia						AS AnnoSentencia,
			G.TC_NumeroResolucion					AS ConsecutivoResolucion,
			G.TU_CodResolucion						AS CodigoResolucion,
			G.TC_Estado								AS Estado,
			G.TU_CodLibroSentencia					AS CodigoLibroSentencia,					
			H.TC_CodContexto						AS CodigoContexto,
			H.TC_Descripcion						AS DescripcionContexto,
			J.TC_Nombre								AS NombreRedactor,
			J.TC_PrimerApellido						AS PrimerApellidoRedactor,
			J.TC_SegundoApellido					AS SegundoApellidoRedactor
			
	FROM		Expediente.Resolucion				R WITH(NOLOCK)
	INNER JOIN	Catalogo.TipoResolucion				TR WITH(NOLOCK) 
	ON			R.TN_CodTipoResolucion				= TR.TN_CodTipoResolucion 
	LEFT JOIN	Catalogo.ResultadoResolucion		RR WITH(NOLOCK) 
	ON			R.TN_CodResultadoResolucion			= RR.TN_CodResultadoResolucion
	LEFT JOIN	Catalogo.CategoriaResolucion		CR WITH(NOLOCK) 
	ON			R.TN_CodCategoriaResolucion			= CR.TN_CodCategoriaResolucion
	LEFT JOIN	Archivo.Archivo						AR WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AR.TU_CodArchivo	
	INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AE.TU_CodArchivo	
	LEFT JOIN	Catalogo.Funcionario				F WITH(NOLOCK)
	ON			R.TC_UsuarioRedSAS                  = F.TC_UsuarioRed
	LEFT JOIN	Expediente.LibroSentencia			G WITH(NOLOCK)
	ON			G.TU_CodResolucion					= R.TU_CodResolucion
	LEFT JOIN	Catalogo.Contexto					H WITH(NOLOCK)
	ON			H.TC_CodContexto					= R.TC_CodContexto
	LEFT JOIN   Catalogo.PuestoTrabajoFuncionario	I WITH(NOLOCK)
	ON			R.TU_RedactorResponsable			= I.TU_CodPuestoFuncionario
	LEFT JOIN   Catalogo.Funcionario				J WITH(NOLOCK)
	ON			I.TC_UsuarioRed						= J.TC_UsuarioRed
	
	WHERE		R.TU_CodResolucion					= CASE 
														WHEN @L_CodResolucion IS NULL THEN	R.TU_CodResolucion  
														ELSE @L_CodResolucion 
													  END 
	AND			AR.TN_CodEstado						= COALESCE(@L_Estado, AR.TN_CodEstado)
	OPTION(RECOMPILE);

IF (@L_CodArchivo IS NOT NULL)
	SELECT	R.TU_CodResolucion						AS CodigoResolucion,			
			R.TF_FechaCreacion						AS FechaCreacion,
			R.TF_FechaResolucion					AS FechaResolucion, 
			R.TC_PorTanto							AS PorTanto,				
			R.TC_Resumen							AS Resumen,
			R.TU_CodArchivo							AS CodigoArchivo,			 
			R.TB_Relevante                          AS EsRelevante,
			R.TB_DatoSensible                       AS DatoSensible,
			R.TC_DescripcionSensible                AS DescripcionSensible,
			R.TF_FechaEnvioSAS                      AS FechaEnvioSAS,
			R.TC_UsuarioRedSAS                      AS UsuarioRedSAS,
			R.TC_NumeroExpediente					AS NumeroExpediente,
			'split'									AS split,
			TR.TN_CodTipoResolucion					AS Codigo,		
			TR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			RR.TN_CodResultadoResolucion			AS Codigo,	
			RR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			CR.TN_CodCategoriaResolucion			AS Codigo,	
			CR.TC_Descripcion						AS Descripcion,
			'split'									AS split, 
			 F.TC_UsuarioRed                        AS UsuarioRed,
			 F.TC_Nombre                            AS Nombre,
			 F.TC_PrimerApellido                    AS PrimerApellido,
			 F.TC_SegundoApellido                   AS SegundoApellido,
			'split'									AS split,
			 R.TU_RedactorResponsable				AS Codigo,
			'split'									AS split,
			AR.TU_CodArchivo						AS Codigo,				
			AR.TC_Descripcion						AS Descripcion, 
			AR.TN_CodEstado							AS EstadoDocumento,		  
			R.TC_EstadoEnvioSAS			            AS EstadoEnvioSAS,
			G.TC_AnnoSentencia						AS AnnoSentencia,
			G.TC_NumeroResolucion					AS ConsecutivoResolucion,
			G.TU_CodResolucion						AS CodigoResolucion,
			G.TC_Estado								AS Estado,
			G.TU_CodLibroSentencia					AS CodigoLibroSentencia,
			H.TC_CodContexto						AS CodigoContexto,
			H.TC_Descripcion						AS DescripcionContexto,
			J.TC_Nombre								AS NombreRedactor,
			J.TC_PrimerApellido						AS PrimerApellidoRedactor,
			J.TC_SegundoApellido					AS SegundoApellidoRedactor
				 
	FROM		Expediente.Resolucion				R WITH(NOLOCK)
	INNER JOIN	Catalogo.TipoResolucion				TR WITH(NOLOCK) 
	ON			R.TN_CodTipoResolucion				= TR.TN_CodTipoResolucion 
	LEFT JOIN	Catalogo.ResultadoResolucion		RR WITH(NOLOCK) 
	ON			R.TN_CodResultadoResolucion			= RR.TN_CodResultadoResolucion
	LEFT JOIN	Catalogo.CategoriaResolucion		CR WITH(NOLOCK) 
	ON			R.TN_CodCategoriaResolucion			= CR.TN_CodCategoriaResolucion
	LEFT JOIN	Archivo.Archivo						AR WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AR.TU_CodArchivo	
	INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AE.TU_CodArchivo
	LEFT JOIN	Catalogo.Funcionario				F WITH(NOLOCK)
	ON			R.TC_UsuarioRedSAS                  = F.TC_UsuarioRed
	LEFT JOIN	Expediente.LibroSentencia			G WITH(NOLOCK)
	ON			G.TU_CodResolucion					= R.TU_CodResolucion
	LEFT JOIN	Catalogo.Contexto					H WITH(NOLOCK)
	ON			H.TC_CodContexto					= R.TC_CodContexto
	LEFT JOIN   Catalogo.PuestoTrabajoFuncionario	I WITH(NOLOCK)
	ON			R.TU_RedactorResponsable			= I.TU_CodPuestoFuncionario
	LEFT JOIN   Catalogo.Funcionario				J WITH(NOLOCK)
	ON			I.TC_UsuarioRed						= J.TC_UsuarioRed
	
	WHERE		R.TU_CodArchivo						= CASE 
														WHEN @L_CodArchivo IS NULL THEN	R.TU_CodArchivo
														ELSE @L_CodArchivo 
													  END 
	AND			AR.TN_CodEstado						= COALESCE(@L_Estado, AR.TN_CodEstado)
	OPTION(RECOMPILE);

if (@L_NumeroExpediente IS NOT NULL)
	SELECT	R.TU_CodResolucion						AS CodigoResolucion,			
			R.TF_FechaCreacion						AS FechaCreacion,
			R.TF_FechaResolucion					AS FechaResolucion, 
			R.TC_PorTanto							AS PorTanto,				
			R.TC_Resumen							AS Resumen,
			R.TU_CodArchivo							AS CodigoArchivo,			 
			R.TB_Relevante                          AS EsRelevante,
			R.TB_DatoSensible                       AS DatoSensible,
			R.TC_DescripcionSensible                AS DescripcionSensible,
			R.TF_FechaEnvioSAS                      AS FechaEnvioSAS,
			R.TC_UsuarioRedSAS                      AS UsuarioRedSAS,
			R.TC_NumeroExpediente					AS NumeroExpediente,
			'split'									AS split,
			TR.TN_CodTipoResolucion					AS Codigo,		
			TR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			RR.TN_CodResultadoResolucion			AS Codigo,	
			RR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			CR.TN_CodCategoriaResolucion			AS Codigo,	
			CR.TC_Descripcion						AS Descripcion,
			'split'									AS split, 
			 F.TC_UsuarioRed                        AS UsuarioRed,
			 F.TC_Nombre                            AS Nombre,
			 F.TC_PrimerApellido                    AS PrimerApellido,
			 F.TC_SegundoApellido                   AS SegundoApellido,
			'split'									AS split,
			 R.TU_RedactorResponsable				AS Codigo,
			'split'									AS split,
			AR.TU_CodArchivo						AS Codigo,				
			AR.TC_Descripcion						AS Descripcion, 
			AR.TN_CodEstado							AS EstadoDocumento,		  
			R.TC_EstadoEnvioSAS			            AS EstadoEnvioSAS,
			G.TC_AnnoSentencia						AS AnnoSentencia,
			G.TC_NumeroResolucion					AS ConsecutivoResolucion,
			G.TU_CodResolucion						AS CodigoResolucion,
			G.TC_Estado								AS Estado,
			G.TU_CodLibroSentencia					AS CodigoLibroSentencia,
			H.TC_CodContexto						AS CodigoContexto,
			H.TC_Descripcion						AS DescripcionContexto,
			J.TC_Nombre								AS NombreRedactor,
			J.TC_PrimerApellido						AS PrimerApellidoRedactor,
			J.TC_SegundoApellido					AS SegundoApellidoRedactor
				 
	FROM		Expediente.Resolucion				R WITH(NOLOCK)
	INNER JOIN	Catalogo.TipoResolucion				TR WITH(NOLOCK) 
	ON			R.TN_CodTipoResolucion				= TR.TN_CodTipoResolucion 
	LEFT JOIN	Catalogo.ResultadoResolucion		RR WITH(NOLOCK) 
	ON			R.TN_CodResultadoResolucion			= RR.TN_CodResultadoResolucion
	LEFT JOIN	Catalogo.CategoriaResolucion		CR WITH(NOLOCK) 
	ON			R.TN_CodCategoriaResolucion			= CR.TN_CodCategoriaResolucion
	LEFT JOIN	Archivo.Archivo						AR WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AR.TU_CodArchivo
	AND			AR.TN_CodEstado						= 4 -- 4 ES IGUAL A TERMINADO--
	INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AE.TU_CodArchivo
	LEFT JOIN	Catalogo.Funcionario				F WITH(NOLOCK)
	ON			R.TC_UsuarioRedSAS                  = F.TC_UsuarioRed
	LEFT JOIN	Expediente.LibroSentencia			G WITH(NOLOCK)
	ON			G.TU_CodResolucion					= R.TU_CodResolucion
	LEFT JOIN	Catalogo.Contexto					H WITH(NOLOCK)
	ON			H.TC_CodContexto					= R.TC_CodContexto
	LEFT JOIN   Catalogo.PuestoTrabajoFuncionario	I WITH(NOLOCK)
	ON			R.TU_RedactorResponsable			= I.TU_CodPuestoFuncionario
	LEFT JOIN   Catalogo.Funcionario				J WITH(NOLOCK)
	ON			I.TC_UsuarioRed						= J.TC_UsuarioRed

	WHERE	R.TC_NumeroExpediente					= CASE 
														WHEN @L_NumeroExpediente IS NULL THEN	R.TC_NumeroExpediente
														ELSE @L_NumeroExpediente 
													  END 
	AND AR.TN_CodEstado								= COALESCE(@L_Estado, AR.TN_CodEstado)
	OPTION(RECOMPILE);

if (@L_CodLegajo IS NOT NULL)
	SELECT	R.TU_CodResolucion						AS CodigoResolucion,			
			R.TF_FechaCreacion						AS FechaCreacion,
			R.TF_FechaResolucion					AS FechaResolucion, 
			R.TC_PorTanto							AS PorTanto,				
			R.TC_Resumen							AS Resumen,
			R.TU_CodArchivo							AS CodigoArchivo,			 
			R.TB_Relevante                          AS EsRelevante,
			R.TB_DatoSensible                       AS DatoSensible,
			R.TC_DescripcionSensible                AS DescripcionSensible,
			R.TF_FechaEnvioSAS                      AS FechaEnvioSAS,
			R.TC_UsuarioRedSAS                      AS UsuarioRedSAS,
			R.TC_NumeroExpediente					AS NumeroExpediente,
			'split'									AS split,
			TR.TN_CodTipoResolucion					AS Codigo,		
			TR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			RR.TN_CodResultadoResolucion			AS Codigo,	
			RR.TC_Descripcion						AS Descripcion,
			'split'									AS split,
			CR.TN_CodCategoriaResolucion			AS Codigo,	
			CR.TC_Descripcion						AS Descripcion,
			'split'									AS split, 
			 F.TC_UsuarioRed                        AS UsuarioRed,
			 F.TC_Nombre                            AS Nombre,
			 F.TC_PrimerApellido                    AS PrimerApellido,
			 F.TC_SegundoApellido                   AS SegundoApellido,
			'split'									AS split,
			 R.TU_RedactorResponsable				AS Codigo,
			'split'									AS split,
			AR.TU_CodArchivo						AS Codigo,				
			AR.TC_Descripcion						AS Descripcion, 
			AR.TN_CodEstado							AS EstadoDocumento,		  
			R.TC_EstadoEnvioSAS			            AS EstadoEnvioSAS,
			G.TC_AnnoSentencia						AS AnnoSentencia,
			G.TC_NumeroResolucion					AS ConsecutivoResolucion,
			G.TU_CodResolucion						AS CodigoResolucion,
			G.TC_Estado								AS Estado,
			G.TU_CodLibroSentencia					AS CodigoLibroSentencia,
			H.TC_CodContexto						AS CodigoContexto,
			H.TC_Descripcion						AS DescripcionContexto,
			J.TC_Nombre								AS NombreRedactor,
			J.TC_PrimerApellido						AS PrimerApellidoRedactor,
			J.TC_SegundoApellido					AS SegundoApellidoRedactor
				 
	FROM		Expediente.Resolucion				R WITH(NOLOCK)
	INNER JOIN	Catalogo.TipoResolucion				TR WITH(NOLOCK) 
	ON			R.TN_CodTipoResolucion				= TR.TN_CodTipoResolucion 
	INNER JOIN  Expediente.Legajo					L WITH(NOLOCK)
	On			L.TC_NumeroExpediente				= R.TC_NumeroExpediente
	LEFT JOIN	Catalogo.ResultadoResolucion		RR WITH(NOLOCK) 
	ON			R.TN_CodResultadoResolucion			= RR.TN_CodResultadoResolucion
	LEFT JOIN	Catalogo.CategoriaResolucion		CR WITH(NOLOCK) 
	ON			R.TN_CodCategoriaResolucion			= CR.TN_CodCategoriaResolucion
	LEFT JOIN	Archivo.Archivo						AR WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AR.TU_CodArchivo
	AND			AR.TN_CodEstado						= 4 -- 4 ES IGUAL A TERMINADO--
	INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
	ON			R.TU_CodArchivo						= AE.TU_CodArchivo
	LEFT JOIN	Catalogo.Funcionario				F WITH(NOLOCK)
	ON			R.TC_UsuarioRedSAS                  = F.TC_UsuarioRed
	LEFT JOIN	Expediente.LibroSentencia			G WITH(NOLOCK)
	ON			G.TU_CodResolucion					= R.TU_CodResolucion
	LEFT JOIN	Catalogo.Contexto					H WITH(NOLOCK)
	ON			H.TC_CodContexto					= R.TC_CodContexto
	INNER JOIN	Expediente.LegajoArchivo			LA WITH(NOLOCK) 
	ON			R.TU_CodArchivo						= LA.TU_CodArchivo
	LEFT JOIN   Catalogo.PuestoTrabajoFuncionario	I WITH(NOLOCK)
	ON			R.TU_RedactorResponsable			= I.TU_CodPuestoFuncionario
	LEFT JOIN   Catalogo.Funcionario				J WITH(NOLOCK)
	ON			I.TC_UsuarioRed						= J.TC_UsuarioRed
	
	WHERE		L.TU_CodLegajo						= @L_CodLegajo
	AND			AR.TN_CodEstado						= COALESCE(@L_Estado, AR.TN_CodEstado)
	OPTION(RECOMPILE);
End
GO
