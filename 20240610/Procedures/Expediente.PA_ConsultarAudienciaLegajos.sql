SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Andrew Allen Dawson>
-- Fecha de creación:	<02/06/2020>
-- Descripción:			<Permite consultar las audiencias asociadas a un legajo.>
-- ==================================================================================================================================================================================
-- Modificación:		<25/03/2020> <Aida E Siles> <Se agrega el nombre completo del funcionario>
-- Modificación:		<27/03/2020> <Aida E Siles> <Se corrige el nombre ContextoCrea por Codigo y NumeroExpediente por Numero para obtener el dato correctamente en el AD>
-- Modificación:		<29/09/2020> <Andrew Allen Dawson> <Se cambia de inner a left el join con Catalogo.Funcionario>
-- Modificación:		<19/10/2020> <Andrew Allen Dawson> <Agrega el campo [TN_CantidadArchivos]>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAudienciaLegajos]
   @CodLegajo UNIQUEIDENTIFIER
 
	AS 
    BEGIN

--Variables.
	DECLARE @L_CodLegajo UNIQUEIDENTIFIER = @CodLegajo

--Lógica.
	SELECT	A.[TN_CodAudiencia]				AS Codigo
			,A.[TC_Estado]					AS Estado
			,A.[TC_Descripcion]				AS Descripcion
			,A.[TC_NombreArchivo]			AS NombreArchivo
			,A.[TC_Duracion]				AS Duracion
			,A.[TF_FechaCrea]				AS FechaCrea
			,A.[TN_EstadoPublicacion]		AS EstadoPublicacion
			,A.[TC_Estado]					AS Estado
			,A.[TN_CantidadArchivos]		AS CantidadArchivos
			,''								AS split
			,AJ.[TU_CodLegajo]				AS Codigo
			,''								AS split
			,A.[TC_NumeroExpediente]		AS Numero
			,''								AS split
			,A.[TC_UsuarioRedCrea]			AS UsuarioRed
			,F.[TC_Nombre]					AS Nombre
			,F.[TC_PrimerApellido]			AS PrimerApellido
			,F.[TC_SegundoApellido]			AS SegundoApellido
			,''								AS split
			,A.[TC_CodContextoCrea]			AS Codigo
			,''								AS split
			,TA.[TN_CodTipoAudiencia]		AS Codigo
			,TA.TC_Descripcion				AS Descripcion
	FROM		[Expediente].[AudienciaLegajo]	AJ 
	JOIN		[Expediente].[Audiencia]		A
	ON			A.TN_CodAudiencia				= AJ.TN_CodAudiencia
	JOIN		Catalogo.TipoAudiencia			TA
	ON			TA.TN_CodTipoAudiencia			= A.TN_CodTipoAudiencia
	LEFT JOIN	Catalogo.Funcionario			F
	ON			F.TC_UsuarioRed					= A.TC_UsuarioRedCrea
	WHERE		AJ.[TU_CodLegajo]				= @L_CodLegajo

	END
GO
