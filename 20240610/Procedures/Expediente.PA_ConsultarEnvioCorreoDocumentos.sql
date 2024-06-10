SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<22/10/2021>
-- Descripción :			<Permite Consultar los documentos asociados a un envio de correo>
-- =================================================================================================================================================
-- Modificación :			<28/01/2022 Daniel Ruiz Hern ndez Se agrega consulta de escritos>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarEnvioCorreoDocumentos]
--ALTER PROCEDURE [Expediente].[PA_ConsultarEnvioCorreoDocumentos]
	@CodigoEnvioCorreo	uniqueidentifier
AS
BEGIN
	--Variables
	DECLARE			@L_CodigoEnvioCorreo		uniqueidentifier	= @CodigoEnvioCorreo;
	
	SELECT		A.TU_CodEnvioCorreo				CodigoEnvioCorreo,
				'Split'							Split,
				A.TU_CodArchivo					Codigo,
				A.TN_Tamanio					Tamanio,
				B.TC_Descripcion				Descripcion
	FROM		Expediente.EnvioCorreoDocumento	A WITH(NOLOCK)
	INNER JOIN	Archivo.Archivo					B WITH(NOLOCK)
	ON			A.TU_CodArchivo					= B.TU_CodArchivo
	WHERE		A.TU_CodEnvioCorreo				= @L_CodigoEnvioCorreo

	UNION

	SELECT		A.TU_CodEnvioCorreo				CodigoEnvioCorreo,
				'Split'							Split,
				A.TU_CodArchivo					Codigo,
				A.TN_Tamanio					Tamanio,
				B.TC_Descripcion				Descripcion
	FROM		Expediente.EnvioCorreoDocumento	A WITH(NOLOCK)
	INNER JOIN	Expediente.EscritoExpediente	B WITH(NOLOCK)
	ON			A.TU_CodArchivo					= B.TC_IDARCHIVO
	WHERE		A.TU_CodEnvioCorreo				= @L_CodigoEnvioCorreo



END
GO
