SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=========================================================================================================================================================
-- Autor:		   <Fabian Sequeira>
-- Fecha Creación: <12/04/2021>
-- Descripcion:	   <Consulta de archivos por representacion>
----=======================================================================================================================================================
-- Modificación:   <20/04/2021> <Aida Elena Siles R> <Se agrega parámetro codarchivo para filtrar búsqueda>
----=======================================================================================================================================================
-- Modificación:   <22/04/2021> <Daniel Ruiz Hernández> <Se agrega nombre del usuario y datos del representante>
-- Modificación:   <13/05/2021> <Fabian Sequeira> <Se agrega contexto de la carpeta>
----=======================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ConsultarArchivosRepresentacion]
	@Cod_Representacion				UNIQUEIDENTIFIER,	 
	@CodArchivo						UNIQUEIDENTIFIER = NULL
AS

BEGIN
	--Variables
	DECLARE	@L_CodRepresentacion	UNIQUEIDENTIFIER	=  @Cod_Representacion,
			@L_CodArchivo			UNIQUEIDENTIFIER	=  @CodArchivo
	
		SELECT		
		A.TU_CodArchivo										AS	Codigo,							
		A.TC_Descripcion									AS	Descripcion,			
		A.TF_FechaCrea										AS	FechaCrea,
		'Split'												AS	Split,
		A.TC_UsuarioCrea									AS	UsuarioRed,	
		C.TC_Nombre											AS  Nombre,
		C.TC_PrimerApellido									AS	PrimerApellido,
		C.TC_SegundoApellido								AS	SegundoApellido,
		'Split'												AS	Split,
		A.TN_CodEstado										AS	Estado,
		AR.TU_CodRepresentacion								AS  CodigoRepresentacion,
		B.TC_NRD											AS  NRD,
		ISNULL(E.TC_Nombre,'') + ' ' + 
		isnull(E.TC_PrimerApellido,'') + ' ' + 
		ISNULL(E.TC_SegundoApellido, '')					AS NombreRepresentante,
		F.TN_CodTipoIdentificacion							AS TipoIdentificacionCodigo,
		F.TC_Descripcion									AS TipoIdentificacionDescripcion,
		D.TC_CodTipoPersona									AS CodigoTipoPersona, 
		G.TC_CodContexto									AS ContextoCarpeta

		FROM		Archivo.Archivo							A WITH(NOLOCK)
		INNER JOIN	DefensaPublica.ArchivoRepresentacion	AR WITH(NOLOCK)
		ON			A.TU_CodArchivo							= AR.TU_CodArchivo	
		INNER JOIN	DefensaPublica.Representacion			B WITH(NOLOCK)
		ON			AR.TU_CodRepresentacion					= B.TU_CodRepresentacion
		LEFT JOIN	Catalogo.Funcionario					C WITH(NOLOCK)
		ON			A.TC_UsuarioCrea						= C.TC_UsuarioRed
		LEFT JOIN	Persona.Persona							D WITH(NOLOCK)
		ON			B.TU_CodPersona							= D.TU_CodPersona
		LEFT JOIN	Persona.PersonaFisica					E WITH(NOLOCK)
		ON			D.TU_CodPersona							= E.TU_CodPersona	
		LEFT JOIN	Catalogo.TipoIdentificacion				F WITH(NOLOCK)
		ON			D.TN_CodTipoIdentificacion				= F.TN_CodTipoIdentificacion
		INNER JOIN	DefensaPublica.Carpeta					G WITH(NOLOCK)
		ON			B.TC_NRD								= G.TC_NRD

		WHERE		AR.TU_CodRepresentacion					= COALESCE(@L_CodRepresentacion, AR.TU_CodRepresentacion)
		AND			AR.TU_CodArchivo						= COALESCE(@L_CodArchivo, AR.TU_CodArchivo)	
END														
GO
