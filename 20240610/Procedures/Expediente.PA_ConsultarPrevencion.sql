SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<15/03/2021>
-- Descripción:			<Permite consultar un registro en la tabla: Prevencion.>
-- ==================================================================================================================================================================================
-- Modificación:		<Ronny Ramírez R.> <16/03/2021> <Se agrega campo para indicar si la prevención se encuentra activa o no>
-- Modificación:		<Luis ALonso Leiva Tames> <19/03/2021> <Se agrega campo codigo de la tabla prevención>
-- Modificación:		<Ronny Ramírez R.> <20/05/2021> <Se aplica corrección a nombre de propiedad que tiene el código del interviniente para que calce con la entidad>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarPrevencion]
	@Codigo				UNIQUEIDENTIFIER	= NULL,
	@NumeroExpediente	VARCHAR(14)			= NULL,
	@CodigoContexto		VARCHAR(4)			= NULL,
	@CodInterviniente	UNIQUEIDENTIFIER	= NULL, 
	@CodTipoPrevencion  INT					= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodPrevencion				UNIQUEIDENTIFIER		=	@Codigo,
			@L_TC_NumeroExpediente			VARCHAR(14)				=	@NumeroExpediente,
			@L_TC_CodigoContexto			VARCHAR(4)				=	@CodigoContexto,
			@L_TU_CodInterviniente			UNIQUEIDENTIFIER		=	@CodInterviniente,
			@L_CodTipoPrevencion			INT						=	@CodTipoPrevencion
	--Lógica
	SELECT	
			A.TU_CodPrevencion				AS	Codigo,
			A.TN_Monto						AS	Monto,
			A.TB_Activa						AS	Activa,
			'SplitExpediente'				AS	SplitExpediente,
			A.TC_NumeroExpediente			AS	Numero,
			'SplitContextoDetalle'			AS	SplitContextoDetalle,
			A.TC_CodContexto				AS	Codigo,
			'SplitInterviniente'			AS	SplitInterviniente,
			A.TU_CodInterviniente			AS	CodigoInterviniente,
			'SplitPersonaFisica'			AS	SplitPersonaFisica,
			C.TU_CodPersona					AS	CodigoPersona,
			C.TC_Nombre						AS	Nombre,
			C.TC_PrimerApellido				AS	PrimerApellido,
			C.TC_SegundoApellido			AS	SegundoApellido,			 
			P.TC_Identificacion				AS	Identificacion,
			'SplitPersonaJuridica'			AS	SplitPersonaJuridica,
			D.TU_CodPersona					AS	CodigoPersona,
			D.TC_Nombre						AS	Nombre,
			D.TC_NombreComercial			AS  NombreComercial,
			P.TC_Identificacion				AS	Identificacion,
			'SplitTipoPrevencion'			AS	SplitTipoPrevencion,
			A.TN_CodTipoPrevencion			AS	Codigo,
			B.TC_Descripcion				AS	Descripcion
	FROM			Expediente.Prevencion		A	WITH (NOLOCK)
	INNER JOIN		Catalogo.TipoPrevencion		B	WITH (NOLOCK)
	ON				B.TN_CodTipoPrevencion		=	A.TN_CodTipoPrevencion
	INNER JOIN		Expediente.Intervencion		Z	WITH (NOLOCK)
	ON				Z.TU_CodInterviniente		=	A.TU_CodInterviniente
	INNER JOIN		Persona.Persona				P	WITH (NOLOCK)
	On				Z.TU_CodPersona				=	P.TU_CodPersona
	LEFT OUTER JOIN	Persona.PersonaFisica		C	WITH (NOLOCK) 
	On				C.TU_CodPersona				=	P.TU_CodPersona
	LEFT OUTER JOIN	Persona.PersonaJuridica		D	WITH (NOLOCK) 
	On				D.TU_CodPersona				=	P.TU_CodPersona
	WHERE		A.TU_CodPrevencion				=	Coalesce(@L_TU_CodPrevencion, A.TU_CodPrevencion)
	AND			A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
	AND			A.TC_CodContexto				=	@L_TC_CodigoContexto
	AND			A.TU_CodInterviniente			=	Coalesce(@L_TU_CodInterviniente, A.TU_CodInterviniente)
	AND			A.TN_CodTipoPrevencion			=	Coalesce(@L_CodTipoPrevencion, A.TN_CodTipoPrevencion)
	order by C.TC_Nombre asc
END
GO
