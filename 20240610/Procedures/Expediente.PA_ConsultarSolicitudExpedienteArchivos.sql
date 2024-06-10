SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<14/04/2020>
-- Descripción:			<Permite listar los documentos asociados al resultado de la solicitud del expediente>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><14/04/2020><Se realiza ajuste en nombre de alias en campos de retorno en consulta>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><15/04/2020><Se ajusta los campos a mostrar, donde se agrega un SplitOtros y mas datos del Archivo y codigo y descripcion del Formato>
-- ==================================================================================================================================================================================
-- Modificado por:      <Ronny Ramírez R.><28/09/2020><Se agregan datos de Nombre y apellidos del usuario que crea> 
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarSolicitudExpedienteArchivos]
	@CodResultadoSolicitud						UNIQUEIDENTIFIER		
AS
BEGIN
	--Variables
	DECLARE	@L_CodResultadoSolicitud	   	    UNIQUEIDENTIFIER		=    @CodResultadoSolicitud

	--Selección
	SELECT      AE.TU_CodArchivo						AS  Codigo,
				'splitOtros'							AS  splitOtros,
				A.TU_CodArchivo							AS  CodigoArchivo,
				A.TC_Descripcion						AS	DescripcionArchivo,
				A.TC_UsuarioCrea						AS  UsuarioCreaArchivo,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(F.TC_Nombre)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')						AS	Nombre,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(F.TC_PrimerApellido)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')				AS	PrimerApellido,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(ISNULL(F.TC_SegundoApellido, ''))), CHAR(9), ''), CHAR(10),''), CHAR(13), '')	AS	SegundoApellido,
				A.TF_FechaCrea							AS  FechaCreacionArchivo,
				A.TN_CodFormatoArchivo					AS  FormatoArchivo,
				FA.TC_Descripcion						AS  DescripcionFormatoArchivo

	FROM	    Expediente.ResultadoSolicitudArchivos	AS	RSA WITH(NOLOCK) 
	INNER JOIN  Expediente.ArchivoExpediente			AS  AE	WITH(NOLOCK)
	ON			RSA.TU_CodArchivo						=   AE.TU_CodArchivo
	INNER JOIN  Archivo.Archivo							AS  A   WITH(NOLOCK)
	ON			A.TU_CodArchivo							=   AE.TU_CodArchivo
	INNER JOIN  Catalogo.FormatoArchivo					AS  FA  WITH(NOLOCK)
	ON			A.TN_CodFormatoArchivo					= FA.TN_CodFormatoArchivo
	INNER JOIN	Catalogo.Funcionario					F WITH(NOLOCK)
	ON			F.TC_UsuarioRed							= A.TC_UsuarioCrea

	WHERE		RSA.TU_CodResultadoSolicitud			=	@L_CodResultadoSolicitud
END
GO
