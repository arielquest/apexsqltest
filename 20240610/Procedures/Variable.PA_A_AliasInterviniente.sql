SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<24-04-2020>
-- Description:					<Traducción de la Variable del PJEditor relacionadas con los alias para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<13/01/2022> <Aida Elena Siles R> <Se agrega parámetro CodLeajo y lógica para los legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_AliasInterviniente]                 
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				AS VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Parte1					AS VARCHAR(MAX),
	@Parte2					AS VARCHAR(MAX),
	@Parte3					AS VARCHAR(MAX),
	@Parte4					AS VARCHAR(MAX),
	@Parte5					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_Contexto             AS VARCHAR(4)   = @Contexto,
				@L_Parte1				AS VARCHAR(MAX)	= @Parte1,
				@L_Parte2				AS VARCHAR(MAX)	= @Parte2,
				@L_Parte3				AS VARCHAR(MAX)	= @Parte3,
				@L_Parte4				AS VARCHAR(MAX)	= @Parte4,
				@L_Parte5				AS VARCHAR(MAX)	= @Parte5;
	DECLARE		@L_Partes				TABLE (nombre VARCHAR(MAX));
	DECLARE		@L_CodLegajo			AS VARCHAR(40)	= @CodLegajo;

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte1, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte2, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte3, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte4, ',')

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
	FROM	STRING_SPLIT(@L_Parte5, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		A.TC_Alias						AS Alias
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		AND			A.TC_Alias						IS NOT NULL
		INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
		ON			D.TU_CodPersona					= B.TU_CodPersona
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
		LEFT JOIN	Expediente.ExpedienteDetalle	E WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente			= E.TC_NumeroExpediente  
		WHERE		(E.TC_NumeroExpediente			= @L_NumeroExpediente
		AND			(E.TC_CodContexto				= @L_Contexto)
		AND			B.TU_CodInterviniente			NOT IN (SELECT	TU_CodInterviniente
															FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
															WHERE	TU_CodInterviniente = B.TU_CodInterviniente))
	END
	ELSE
	BEGIN
		SELECT		A.TC_Alias						AS Alias
		FROM		Expediente.Interviniente		A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
		ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
		AND			A.TC_Alias						IS NOT NULL
		INNER JOIN	Expediente.LegajoIntervencion	LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente			= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
		ON			D.TU_CodPersona					= B.TU_CodPersona
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
		LEFT JOIN	Expediente.LegajoDetalle		E WITH(NOLOCK) 
		ON			E.TU_CodLegajo					= LI.TU_CodLegajo
		WHERE		(E.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			(E.TC_CodContexto				= @L_Contexto))
	END

	
END
GO
