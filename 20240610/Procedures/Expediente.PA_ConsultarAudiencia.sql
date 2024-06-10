SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<04/02/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Audiencia.>
-- ==================================================================================================================================================================================
-- Modificado:			<Jose Gabriel Cordero Soto><12/02/2020><Se ajusta consulta para que retorne resultados si es valor de Estado es DEFAULT>
-- Modificado:			<Jonathan Aguilar Navarro><13/03/2020><Se aagrega el codigo de la audiencia a la consulta>
-- Modificado:			<Andrew Allen Dawson><17/03/2020><Se modifica el campo Duración por Duración total para que coincida con el nombre de la propiedad de la entidad Audiencia.>
-- Modificado:			<Andrew Allen Dawson><17/03/2020><Se agrega el campo TN_EstadoPublicacion en la consulta>
-- Modificado:			<Jose Gabriel Cordero Soto><20/04/2020><Se agrega el cambio en el nombre de FechaCrea>
-- Modificado:			<Andrew Allen Dawson><20/10/2020><Se Modifica el inner join con catalogo.Funcionario>
-- Modificado:			<Andrew Allen Dawson><21/10/2020><Se Agrega el campo TN_CantidadArchivos>
-- Modificado:			<Richard Zúñiga SeguraZ<19/04/2021><ME 027-2021 - Se Agrega el Expediente, Carpeta, EstadoPublicacion e Idaco_Original>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAudiencia]
	@Audiencia			BIGINT		,	
	@NumeroExpediente	varchar(14) ,
	@Estado				char(1) 		
as
BEGIN
	--Variables
	DECLARE		@L_TN_CodAudiencia			BIGINT			= @Audiencia
	DECLARE		@L_TC_NumeroExpediente		varchar(14)		= @NumeroExpediente
	DECLARE		@L_TC_Estado				char(1)			= @Estado

	--SI Valor es valor por defecto se convierte a NULL
	IF(@L_TC_Estado = '0' OR LEN(@L_TC_Estado) = 0)
		SET @L_TC_Estado = null

	--Lógica
	SELECT		AU.TN_CodAudiencia			AS	Codigo,
				AU.TC_NumeroExpediente		AS	NumeroExpediente,
				AU.TC_Descripcion			AS	Descripcion,
				AU.TC_NombreArchivo			AS	NombreArchivo,
				AU.TC_Duracion				AS	DuracionTotal,
				AU.TF_FechaCrea				AS	FechaCrea,
				AU.TN_EstadoPublicacion		AS	EstadoPublicacion,
				AU.TN_CantidadArchivos		AS	CantidadArchivos,	
				AU.IDACO_ORIGINAL			AS	Idaco_Original,
				'Split'						AS  Split,
				TA.TN_CodTipoAudiencia		AS	Codigo,
				TA.TC_Descripcion			AS	Descripcion,
				'Split'						AS  Split,
				CO.TC_CodContexto			AS	Codigo,
				CO.TC_Descripcion			AS	Descripcion,
				'Split'						As	Split,		
				FU.TC_UsuarioRed			As	UsuarioRed,				
				FU.TC_Nombre				As	Nombre,					
				FU.TC_PrimerApellido		As	PrimerApellido,			
				FU.TC_SegundoApellido		As	SegundoApellido,		
				FU.TC_CodPlaza				As	CodigoPlaza,			
				FU.TF_Inicio_Vigencia		As	FechaActivacion,		
				FU.TF_Fin_Vigencia			As	FechaDesactivacion,		
				'Split'						AS	Split,
				AU.TC_NumeroExpediente		AS	Numero,
				E.CARPETA					AS	CarpetaGestion,
				'Split'						AS	Split,
				AU.TC_Estado				AS	Estado,
				AU.Sistema					AS	Sistema,
				AU.TN_EstadoPublicacion		AS	EstadoPublicacion
				
	FROM		Expediente.Audiencia		AU	WITH (NOLOCK)
	JOIN		Catalogo.TipoAudiencia		TA	WITH (NOLOCK)
	ON			AU.TN_CodTipoAudiencia		=	TA.TN_CodTipoAudiencia
	JOIN		Catalogo.Contexto			AS	CO WITH (NOLOCK)
	ON			AU.TC_CodContextoCrea		=	CO.TC_CodContexto
	LEFT JOIN	Catalogo.Funcionario		As	FU WITH (NOLOCK)
	On			AU.TC_UsuarioRedCrea		=	FU.TC_UsuarioRed
	JOIN		Expediente.Expediente		E	WITH (NOLOCK)
	ON			E.TC_NumeroExpediente		=	AU.TC_NumeroExpediente
	WHERE		AU.TN_CodAudiencia			=	coalesce(@L_TN_CodAudiencia,AU.TN_CodAudiencia)
	AND			AU.TC_NumeroExpediente		=	coalesce(@L_TC_NumeroExpediente,AU.TC_NumeroExpediente)
END
GO
