SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<11-05-2020>
-- Description:					<Traducción de la Variable del PJEditor relacionadas con la identificacion de las partes para LibreOffice>
-- ====================================================================================================================================================================================
-- <Modificacion>				<30/03/2021><Jose Miguel Avendaño><Se modifica para que retorne correctamente los 10 digitos de las cedulas de identidad>
-- <Modificacion>				<20/01/2022><Aida Elena Siles R><Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_IdentificacionIntervinientes]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Parte1					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto,
@L_Parte1				AS VARCHAR(MAX)	= @Parte1;
	DECLARE		@L_Partes				TABLE (nombre VARCHAR(MAX));

	INSERT INTO @L_Partes
SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte1, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT STUFF((SELECT		', ' + Identificacion
		FROM	(
				SELECT		E.TC_Identificacion							AS Identificacion
				FROM		Expediente.Interviniente					A WITH(NOLOCK)
				INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
				ON			A.TU_CodInterviniente						= B.TU_CodInterviniente 
				INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
				ON			D.TU_CodPersona								= B.TU_CodPersona
				INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
				ON			E.TU_CodPersona								= D.TU_CodPersona
				AND			E.TC_Identificacion							IS NOT NULL
				AND			(
							CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) IN (
																										SELECT	nombre
																										FROM	@L_Partes
																										)
				OR			CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre) IN (
																										SELECT	nombre
																										FROM	@L_Partes
																										)
					)
				LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
				ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente  
				WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
				AND			F.TC_CodContexto							= @L_Contexto
				UNION ALL				
				SELECT		E.TC_Identificacion							AS Identificacion
				FROM		Expediente.Interviniente					A WITH(NOLOCK)
				INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
				ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
				INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
				ON			B.TU_CodPersona								= E.TU_CodPersona 
				AND			E.TC_Identificacion							IS NOT NULL
				LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
				ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente 
				INNER JOIN	Persona.PersonaJuridica						G WITH(NOLOCK) 
				ON			E.TU_CodPersona								= G.TU_CodPersona
				AND			G.TC_Nombre									IN (
																			SELECT	nombre
																			FROM	@L_Partes
																			)
				WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
				AND			F.TC_CodContexto							= @L_Contexto
			)
		AS	TABLA
		WHERE		Identificacion IS NOT NULL
		ORDER BY	Identificacion DESC
		FOR XML PATH ('')), 1, 2, '')
	END
	ELSE
	BEGIN
		SELECT STUFF((SELECT		', ' + Identificacion
		FROM	(
				SELECT		E.TC_Identificacion							AS Identificacion
				FROM		Expediente.Interviniente					A WITH(NOLOCK)
				INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
				ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
				INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
				ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
				INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
				ON			D.TU_CodPersona								= B.TU_CodPersona
				INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
				ON			E.TU_CodPersona								= D.TU_CodPersona
				AND			E.TC_Identificacion							IS NOT NULL
				AND			(
							CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) IN (
																										SELECT	nombre
																										FROM	@L_Partes
																										)
				OR			CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre) IN (
																										SELECT	nombre
																										FROM	@L_Partes
																										)
					)
				LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
				ON			F.TU_CodLegajo								= LI.TU_CodLegajo 
				WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
				AND			F.TC_CodContexto							= @L_Contexto
				UNION ALL				
				SELECT		E.TC_Identificacion							AS Identificacion
				FROM		Expediente.Interviniente					A WITH(NOLOCK)
				INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
				ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
				INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
				ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
				INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
				ON			B.TU_CodPersona								= E.TU_CodPersona 
				AND			E.TC_Identificacion							IS NOT NULL
				LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
				ON			F.TU_CodLegajo								= LI.TU_CodLegajo
				INNER JOIN	Persona.PersonaJuridica						G WITH(NOLOCK) 
				ON			E.TU_CodPersona								= G.TU_CodPersona
				AND			G.TC_Nombre									IN (
																			SELECT	nombre
																			FROM	@L_Partes
																			)
				WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
				AND			F.TC_CodContexto							= @L_Contexto
			)
		AS	TABLA
		WHERE		Identificacion IS NOT NULL
		ORDER BY	Identificacion DESC
		FOR XML PATH ('')), 1, 2, '')
	END
END
GO
