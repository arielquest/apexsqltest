SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===================================================================================================================================================================
-- Autor:		   <Jeffry hernanadez>
-- Fecha Creación: <24/02/2016>
-- Descripcion:	   <Consulta de un archivo completo>
-- ===================================================================================================================================================================
-- Modificación:	<20/09/2018> <Isaac Dobles Mata> <Se cambia nombre a PA_ConsultarArchivoExpedienteCompleto y se modifica para adaptarse a tabla ArchivoExpediente>
-- Modificación:	<07/01/2019> <Jonathan Aguilar Navarro> <Se agrega el numero de expediente como parametro de consulta>
-- Modificación:	<03/06/2019> <Isaac Dobles Mata> <Se modifica para ajustarse a estructura nueva de expedientes y legajos>
-- Modificación:	<29/07/2019> <Jonathan Aguilar Navarro> <Se modifica para que no tome en cuenta los archivos asociados a un legajo>
-- Modificación:	<23/08/2019> <Isaac Dobles Mata> <Se modifica para manejar los documentos de un legajo>
-- Modificación:	<15/04/2020> <Isaac Dobles Mata> <Se modifica la consulta para que devuelva consecutivo de Historial Procesal>
-- Modificación:	<29/05/2020> <Isaac Dobles Mata> <Se modifica para ingresar variables internas>
-- Modificación		<Ronny Ram¡rez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar problema de no uso de ¡ndices 
--													por el mal uso de COALESCE en el WHERE>
-- ===================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarArchivoExpedienteCompleto] 
	@CodigoArchivo				uniqueidentifier,	
	@NumeroExpediente			varchar(14)
AS

BEGIN

	Declare 
	@L_TU_CodArchivo					uniqueidentifier    = @CodigoArchivo,       
	@L_TC_NumeroExpediente				varchar(14)         = @NumeroExpediente

	IF @L_TU_CodArchivo IS NULL AND @L_TC_NumeroExpediente IS NOT NULL
	BEGIN
		SELECT	
			A.TU_CodArchivo			AS	Codigo,							
			A.TC_Descripcion		AS	Descripcion,			
			A.TF_FechaCrea			AS	FechaCrea, 
			AE.TN_Consecutivo		AS	ConsecutivoHistorialProcesal,
			
			'Split'					AS	Split,
			AE.TN_CodGrupoTrabajo	AS	Codigo,							
			C.TC_Descripcion		AS	Descripcion,

			'Split'					AS	Split,
			B.TC_UsuarioRed			AS	UsuarioRed,						
			B.TC_Nombre				AS	Nombre,
			B.TC_PrimerApellido		AS	PrimerApellido,					
			B.TC_SegundoApellido	AS	SegundoApellido,
			B.TC_CodPlaza			AS	CodigoPlaza,					
			B.TF_Inicio_Vigencia	AS	FechaActivacion,
			B.TF_Fin_Vigencia		AS	FechaDesactivacion,	
			
			'Split'					AS	Split,
			A.TN_CodEstado			AS	Estado
										
		FROM		Archivo.Archivo A					WITH(NOLOCK)
		INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
		ON			A.TU_CodArchivo						=	AE.TU_CodArchivo
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
		ON			X.TU_CodArchivo					=	A.TU_CodArchivo 
		INNER JOIN	Catalogo.Funcionario				B WITH(NOLOCK) 
		ON			A.TC_UsuarioCrea				=	B.TC_UsuarioRed
		INNER JOIN	Catalogo.GrupoTrabajo				C WITH(NOLOCK) 
		ON			AE.TN_CodGrupoTrabajo			=	C.TN_CodGrupoTrabajo

		WHERE	A.TU_CodArchivo			=	COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
		AND		AE.TB_Eliminado			=	0	
		AND		AE.TC_NumeroExpediente	=	COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)
		OPTION(RECOMPILE)
	END
	ELSE
	BEGIN
		SELECT	
			A.TU_CodArchivo			AS	Codigo,							
			A.TC_Descripcion		AS	Descripcion,			
			A.TF_FechaCrea			AS	FechaCrea, 
			AE.TN_Consecutivo		AS	ConsecutivoHistorialProcesal,						
			
			'Split'					AS	Split,
			AE.TN_CodGrupoTrabajo	AS	Codigo,							
			C.TC_Descripcion		AS	Descripcion,

			'Split'					AS	Split,
			B.TC_UsuarioRed			AS	UsuarioRed,						
			B.TC_Nombre				AS	Nombre,
			B.TC_PrimerApellido		AS	PrimerApellido,					
			B.TC_SegundoApellido	AS	SegundoApellido,
			B.TC_CodPlaza			AS	CodigoPlaza,					
			B.TF_Inicio_Vigencia	AS	FechaActivacion,
			B.TF_Fin_Vigencia		AS	FechaDesactivacion,	
			
			'Split'					AS	Split,
			A.TN_CodEstado			AS	Estado
										
		FROM		Archivo.Archivo						A WITH(NOLOCK)
		INNER JOIN	Expediente.ArchivoExpediente		AE WITH(NOLOCK)
		ON			A.TU_CodArchivo					=	AE.TU_CodArchivo
		INNER JOIN	Catalogo.Funcionario				B WITH(NOLOCK) 
		ON			A.TC_UsuarioCrea				=	B.TC_UsuarioRed
		INNER JOIN	Catalogo.GrupoTrabajo				C WITH(NOLOCK) 
		ON			AE.TN_CodGrupoTrabajo			=	C.TN_CodGrupoTrabajo

		WHERE	A.TU_CodArchivo			=	COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
		AND		AE.TB_Eliminado			=	0	
		AND		AE.TC_NumeroExpediente	=	COALESCE(@L_TC_NumeroExpediente, AE.TC_NumeroExpediente)
		OPTION(RECOMPILE)
	END 
END
GO
