SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<22/04/2021>
-- Descripción:			<Permite consultar un registro en la tabla: Archivo.>
-- Modificado por:		<Esteban Cordero Benavides>
-- Fecha de creación:	<06/09/2021>
-- Descripción:			<Elimina la consulta de la columna IDDOC.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE	[Archivo].[PA_ConsultarArchivo]
	@CodArchivo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo
	--Lógica
	SELECT	A.TC_Descripcion			Descripcion,									
			A.TF_FechaCrea				FechaCrea,
			A.TN_CodEstado				Estado,						
			'Split'                     Split,
			A.TC_CodContextoCrea		CodContextoCrea,
			A.TN_CodFormatoArchivo		CodFormatoArchivo,
			A.TC_UsuarioCrea			UsuarioCrea,
			A.TC_CodFormatoJuridico		CodFormatoJuridico,
			A.TB_GenerarVotoAutomatico	GenerarVotoAutomatico
	FROM	Archivo.Archivo				A WITH (NOLOCK)
	WHERE	TU_CodArchivo				= @L_TU_CodArchivo
END
GO
