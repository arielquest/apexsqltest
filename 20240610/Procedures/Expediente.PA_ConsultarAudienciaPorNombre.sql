SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<16/09/2020>
-- Descripción :			<Consulta las audiencias con el mismo nombre de archivo proporcionado. >
-- =================================================================================================================================================
 CREATE PROCEDURE [Expediente].[PA_ConsultarAudienciaPorNombre]
	@NombreArchivo			varchar(255)
AS 

BEGIN

	DECLARE		@L_NombreArchivo VARCHAR(255)	=		@NombreArchivo

	SELECT A.[TN_CodAudiencia]				AS Codigo
			,A.[TC_Descripcion]				AS Descripcion
			,A.[TC_NombreArchivo]			AS NombreArchivo
			,A.[TC_Duracion]				AS Duracion
			,A.[TF_FechaCrea]				AS FechaCrea
			,A.[TN_EstadoPublicacion]		AS EstadoPublicacion
			,''								AS split
			,A.[TC_NumeroExpediente]		AS Numero
			,''								AS split
			,A.[TC_UsuarioRedCrea]			AS UsuarioRed
			,F.[TC_Nombre]					AS Nombre
			,F.[TC_PrimerApellido]			AS PrimerApellido
			,F.[TC_SegundoApellido]			AS SegundoApellido
			,''								AS split
			,A.[TC_CodContextoCrea]			AS Codigo
			,C.[TC_Descripcion]				AS Descripcion
			,''								AS split
			,TA.[TN_CodTipoAudiencia]		AS Codigo
			,TA.TC_Descripcion				AS Descripcion
			,''								AS split
			,A.[TC_Estado]					AS Estado
	FROM [Expediente].[Audiencia] A
	JOIN	Catalogo.TipoAudiencia			TA
	ON		TA.TN_CodTipoAudiencia			= A.TN_CodTipoAudiencia
	JOIN	Catalogo.Funcionario			F
	ON		F.TC_UsuarioRed					= A.TC_UsuarioRedCrea
	JOIN	Catalogo.Contexto				C
	ON		C.TC_CodContexto				= A.TC_CodContextoCrea
	WHERE TC_NombreArchivo = @NombreArchivo

END
GO
