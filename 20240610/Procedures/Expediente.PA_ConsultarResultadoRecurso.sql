SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--=================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<07/02/2020>
-- Descripción:			<Permite consultar los registro en la tabla: ResultadoRecurso.>
-- ==================================================================================================================================================================================
-- Modificación:		<Jose Gabriel Cordero Soto><13/08/2021><Se agrega información sobre el resultado del recurso de expediente>
-- Modificación:		<Aaron Rios Retana><01/09/2022><Bug 269091 - Se obtiene los escritos relacionados al resultado del recurso de expediente>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarResultadoRecurso]
@CodRecurso			UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodRecurso				 UNIQUEIDENTIFIER	=  @CodRecurso
	
	--Lógica
	SELECT		
				RR.TF_FechaCreacion					 AS FechaCreacion,
				RR.TF_FechaEnvio					 AS FechaEnvio,
				RR.TF_FechaRecepcion				 AS FechaRecepcion,				
				'splitOtros'						 AS	splitOtros,
				RR.TC_CodContextoOrigen				 AS CodigoContextoOrigen,
				C.TC_Descripcion					 AS DescripcionContextoOrigen,				
				RRA.TU_CodResultadoRecurso			 AS CodigoResultadoRecurso,
				RRA.TC_NumeroExpediente				 AS NumeroExpediente,
				RR.TN_CodEstadoItineracion			 AS CodigoEstadoItineracion,
				EI.TC_Descripcion					 AS DescripcionEstadoItineracion,
				A.TU_CodArchivo						 AS CodigoArchivo,			
				A.TC_Descripcion					 AS DescripcionArchivo,
				RR.TC_UsuarioRed					 AS UsuarioRed,
				F.TC_Nombre							 AS NombreFuncionario,
				F.TC_PrimerApellido					 AS PrimerApellidoFuncionario,
				F.TC_SegundoApellido				 AS SegundoApellidoFuncionario,
				Y.TN_CodResultadoLegajo				 AS CodigoTipoResultadoRecurso,
				Y.TC_Descripcion					 AS DescripcionTipoResultadoRecurso	
			
	FROM		Expediente.ResultadoRecurso			 RR WITH (NOLOCK)
	INNER JOIN  Expediente.ResultadoRecursosArchivos RRA WITH (NOLOCK)
	ON			RR.TU_CodResultadoRecurso			 = RRA.TU_CodResultadoRecurso
	INNER JOIN  Expediente.ArchivoExpediente		 AE WITH(NOLOCK)
	ON			RRA.TC_NumeroExpediente				 = AE.TC_NumeroExpediente
	AND			RRA.TU_CodArchivo					 = AE.TU_CodArchivo
	INNER JOIN  Archivo.Archivo						 A  WITH(NOLOCK)
	ON			A.TU_CodArchivo						 = AE.TU_CodArchivo	
	INNER JOIN  Expediente.RecursoExpediente		 RE WITH(NOLOCK)
	ON			RE.TU_CodResultadoRecurso			 = RR.TU_CodResultadoRecurso	
	INNER JOIN  Catalogo.EstadoItineracion			 EI WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion			 = RR.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Funcionario				 F WITH(NOLOCK)
	ON			F.TC_UsuarioRed						 = RR.TC_UsuarioRed
	INNER JOIN	Catalogo.Contexto				     C WITH(NOLOCK)
	ON			C.TC_CodContexto					 = RR.TC_CodContextoOrigen
	LEFT JOIN	Catalogo.ResultadoLegajo			 Y WITH(NOLOCK)
	ON			Y.TN_CodResultadoLegajo				 = RR.TN_CodResultadoLegajo

	WHERE		RE.TU_CodRecurso					 = @L_TU_CodRecurso

	UNION

	SELECT		
				RR.TF_FechaCreacion					 AS FechaCreacion,
				RR.TF_FechaEnvio					 AS FechaEnvio,
				RR.TF_FechaRecepcion				 AS FechaRecepcion,				
				'splitOtros'						 AS	splitOtros,
				RR.TC_CodContextoOrigen				 AS CodigoContextoOrigen,
				C.TC_Descripcion					 AS DescripcionContextoOrigen,				
				RRE.TU_CodResultadoRecurso			 AS CodigoResultadoRecurso,
				EE.TC_NumeroExpediente				 AS NumeroExpediente,
				RR.TN_CodEstadoItineracion			 AS CodigoEstadoItineracion,
				EI.TC_Descripcion					 AS DescripcionEstadoItineracion,
				EE.TC_IDARCHIVO						 AS CodigoArchivo,			
				EE.TC_Descripcion					 AS DescripcionArchivo,
				RR.TC_UsuarioRed					 AS UsuarioRed,
				F.TC_Nombre							 AS NombreFuncionario,
				F.TC_PrimerApellido					 AS PrimerApellidoFuncionario,
				F.TC_SegundoApellido				 AS SegundoApellidoFuncionario,
				Y.TN_CodResultadoLegajo				 AS CodigoTipoResultadoRecurso,
				Y.TC_Descripcion					 AS DescripcionTipoResultadoRecurso	
			
	FROM		Expediente.ResultadoRecurso			 RR WITH (NOLOCK)
	INNER JOIN  Expediente.ResultadoRecursoEscrito	 RRE WITH (NOLOCK)
	ON			RR.TU_CodResultadoRecurso			 = RRE.TU_CodResultadoRecurso
	INNER JOIN  Expediente.EscritoExpediente		 EE WITH(NOLOCK)
	ON			RRE.TU_CodEscrito 					 = EE.TU_CodEscrito
	INNER JOIN  Expediente.RecursoExpediente		 RE WITH(NOLOCK)
	ON			RE.TU_CodResultadoRecurso			 = RR.TU_CodResultadoRecurso	
	INNER JOIN  Catalogo.EstadoItineracion			 EI WITH(NOLOCK)
	ON			EI.TN_CodEstadoItineracion			 = RR.TN_CodEstadoItineracion
	INNER JOIN  Catalogo.Funcionario				 F WITH(NOLOCK)
	ON			F.TC_UsuarioRed						 = RR.TC_UsuarioRed
	INNER JOIN	Catalogo.Contexto				     C WITH(NOLOCK)
	ON			C.TC_CodContexto					 = RR.TC_CodContextoOrigen
	LEFT JOIN	Catalogo.ResultadoLegajo			 Y WITH(NOLOCK)
	ON			Y.TN_CodResultadoLegajo				 = RR.TN_CodResultadoLegajo

	WHERE		RE.TU_CodRecurso					 = @L_TU_CodRecurso
END
GO
