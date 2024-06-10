SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.1>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<28/09/2020>
-- Descripción:			<Permite listar los documentos asociados al resultado del recurso del expediente>
-- ==================================================================================================================================================================================
-- Modificacion:			<19/10/2022> <Aaron Rios Retana> <HU 272357- Se modifica para retornar un número de resolución en caso de ser una resolución>
CREATE PROCEDURE	[Expediente].[PA_ConsultarResultadoRecursoArchivos]
	@CodResultadoRecurso						UNIQUEIDENTIFIER		
AS
BEGIN
	--Variables
	DECLARE	@L_CodResultadoRecurso	   	    UNIQUEIDENTIFIER		=    @CodResultadoRecurso

	--Selección
	SELECT      AE.TU_CodArchivo																									AS  Codigo,
				A.TC_Descripcion																									AS	Descripcion,				
				A.TF_FechaCrea																										AS  FechaCrea,
				R.TU_CodResolucion																									AS	CodigoResolucion,
				'splitFuncionario'																									AS  splitFuncionario,
				A.TC_UsuarioCrea																									AS  UsuarioRed,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(F.TC_Nombre)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')						AS	Nombre,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(F.TC_PrimerApellido)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')				AS	PrimerApellido,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(ISNULL(F.TC_SegundoApellido, ''))), CHAR(9), ''), CHAR(10),''), CHAR(13), '')	AS	SegundoApellido,
				'splitFormatoArchivo'																								AS  splitFormatoArchivo,
				A.TN_CodFormatoArchivo																								AS  Codigo,
				FA.TC_Descripcion																									AS  Descripcion
				

	FROM	    Expediente.ResultadoRecursosArchivos	AS	RSA WITH(NOLOCK) 
	INNER JOIN  Expediente.ArchivoExpediente			AS  AE	WITH(NOLOCK)
	ON			RSA.TU_CodArchivo						=   AE.TU_CodArchivo
	INNER JOIN  Archivo.Archivo							AS  A   WITH(NOLOCK)
	ON			A.TU_CodArchivo							=   AE.TU_CodArchivo
	INNER JOIN  Catalogo.FormatoArchivo					AS  FA  WITH(NOLOCK)
	ON			A.TN_CodFormatoArchivo					= FA.TN_CodFormatoArchivo
	INNER JOIN	Catalogo.Funcionario					AS	F	WITH(NOLOCK)
	ON			F.TC_UsuarioRed							= A.TC_UsuarioCrea
	LEFT  JOIN  Expediente.Resolucion					AS	R	WITH(NOLOCK)
	ON			R.TU_CodArchivo							=	AE.TU_CodArchivo

	WHERE		RSA.TU_CodResultadoRecurso			=	@L_CodResultadoRecurso
END
GO
