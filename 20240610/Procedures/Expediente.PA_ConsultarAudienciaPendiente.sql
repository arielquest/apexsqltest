SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Richard Zúñiga Segura>
-- Fecha de creación:	<27/04/2021>
-- Descripción:			<Permite consultar las audiencias que están pendientes de convertir a streaming.>
-- ==================================================================================================================================================================================
-- ==================================================================================================================================================================================
-- Versión:				<1.1>
-- Creado por:			<Aarón Ríos Retana>
-- Fecha de creación:	<27/04/2021>
-- Descripción:			<ME0032-2021: Se corrige para poder mostrar las audiencias creadas en otros contextos en un expediente itinerado>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAudienciaPendiente]
	@Contexto	varchar(4),
	@FECHA datetime
AS
BEGIN
	--Variables
	DECLARE	@L_Contexto				varchar(4)	=	@Contexto
	DECLARE	@L_EstadoPublicacion	int			=	1
	DECLARE	@L_Sincronizado			char(1)		=	'S'
	DECLARE	@L_CodConfiguracion		varchar(23) =	'U_Direccion_FTP_Oficina'
	DECLARE	@L_Fecha				datetime	=	@FECHA

	--Lógica
SELECT		TOP 50
				AU.TN_CodAudiencia					AS	Codigo,
				AU.TC_Descripcion					AS	Descripcion,
				AU.TC_NombreArchivo					AS	NombreArchivo,
				AU.TC_Duracion						AS	DuracionTotal,
				AU.TF_FechaCrea						AS	FechaCrea,
				AU.TN_CantidadArchivos				AS	CantidadArchivos,	
				AU.TC_CodContextoCrea			    AS	Despacho_Crea,
				AU.IDACO_ORIGINAL					AS	Idaco_Original,
				F.TC_Valor							AS	URLPublicacion,
				'Split'								AS  Split,
				TA.TN_CodTipoAudiencia				AS	Codigo,
				TA.TC_Descripcion					AS	Descripcion,
				'Split'								AS  Split,
				CO.TC_CodContexto					AS	Codigo,
				CO.TC_Descripcion					AS	Descripcion,
				1									AS	UtilizaSiagpj,
				'Split'								AS	Split,
				AU.TC_NumeroExpediente				AS	Numero,
				E.CARPETA							AS	CarpetaGestion,
				'Split'								AS	Split,
				AU.TC_Estado						AS	Estado,
				AU.Sistema							AS	Sistema,
				AU.TN_EstadoPublicacion				AS	EstadoPublicacion
				
	FROM		Expediente.Expediente				E	WITH (NOLOCK)
	JOIN		Expediente.Audiencia				AU	WITH (NOLOCK)
	ON			E.TC_NumeroExpediente = AU.TC_NumeroExpediente 
	JOIN		Catalogo.TipoAudiencia				TA WITH (NOLOCK)
	ON			AU.TN_CodTipoAudiencia = TA.TN_CodTipoAudiencia 
	JOIN		Catalogo.Contexto					CO WITH (NOLOCK)
	ON			E.TC_CodContexto = CO.TC_CodContexto 
	INNER JOIN	Configuracion.ConfiguracionValor	F
	ON			E.TC_CodContexto				=	F.TC_CodContexto
	WHERE		AU.TN_EstadoPublicacion				=	@L_EstadoPublicacion
	AND			AU.TC_Estado						=	@L_Sincronizado
	AND			E.TC_CodContexto 					=	@L_Contexto
	AND			F.TC_CodConfiguracion				=	@L_CodConfiguracion
	AND			AU.TF_FechaCrea						>=	@L_FECHA
END
GO
