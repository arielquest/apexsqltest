SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<24/04/2020>
-- Descripción:			<Permite consultar un registro en la tabla: IntervencionArchivo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarIntervencionArchivo]
	@CodArchivo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo
	--Lógica
	SELECT		A.TU_CodArchivo						AS CodigoArchivo,
				'split'								AS split,
				D.TN_CodTipoIntervencion			AS Codigo,
				D.TC_Descripcion					AS Descripcion,
				'split'								AS split,
				H.TN_CodTipoIdentificacion			AS Codigo,
				H.TC_Descripcion					AS Descripcion,
				H.TC_Formato						AS Formato,
				'split'								AS split,
				E.TU_CodPersona						AS CodigoPersona,
				E.TC_Identificacion					AS Identificacion,
				E.TC_CodTipoPersona					AS TipoPersona,
				ISNULL(CASE E.TC_CodTipoPersona
				WHEN 'F' THEN Upper(F.TC_Nombre + ' ' +F.TC_PrimerApellido + ' ' +F.TC_SegundoApellido)					
				WHEN 'J' THEN Upper(G.TC_Nombre)
				END, 'IGNORADO')					AS	 NombreCompleto,
				B.TC_TipoParticipacion				AS TipoParticipacion,
				A.TU_CodInterviniente				AS CodigoInterviniente

	FROM		Expediente.IntervencionArchivo		A WITH (NOLOCK)
	INNER JOIN  Expediente.Intervencion				B WITH (NOLOCK)
	ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
	LEFT JOIN	Expediente.Interviniente			C WITH (NOLOCK)
	ON			A.TU_CodInterviniente				= C.TU_CodInterviniente
	LEFT JOIN	Catalogo.TipoIntervencion			D WITH (NOLOCK)
	ON			C.TN_CodTipoIntervencion			= D.TN_CodTipoIntervencion
	INNER JOIN	Persona.Persona						E WITH (NOLOCK)
	ON			B.TU_CodPersona						= E.TU_CodPersona
	LEFT JOIN   Persona.PersonaFisica				F WITH (NOLOCK)
	ON			B.TU_CodPersona						= F.TU_CodPersona
	LEFT JOIN	Persona.PersonaJuridica				G WITH (NOLOCK)
	ON			B.TU_CodPersona						= G.TU_CodPersona
	INNER JOIN	Catalogo.TipoIdentificacion			H WITH (NOLOCK)
	ON			E.TN_CodTipoIdentificacion			= H.TN_CodTipoIdentificacion
	WHERE		TU_CodArchivo						= @L_TU_CodArchivo
END
GO
