SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<25-06-2021>
-- Description:					<Traducción de la Variable del PJEditor relacionadas con las vulnerabilidades de las partes para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:                <Isaac Santiago Méndez Castillo> <15-07-2021> <Se modifica SP para funcionamiento para todas aquellas partes que no tengan caracteristicas>
-- Modificación:                <Aida Elena Siles R> <20/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_VulnerabilidadesInterviniente]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Parte1					AS VARCHAR(MAX),
	@Parte2					AS VARCHAR(MAX),
	@Parte3					AS VARCHAR(MAX),
	@Parte4					AS VARCHAR(MAX),
	@Parte5					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto,
@L_Parte1				AS VARCHAR(MAX)	= @Parte1,
				@L_Parte2				AS VARCHAR(MAX)	= @Parte2,
				@L_Parte3				AS VARCHAR(MAX)	= @Parte3,
				@L_Parte4				AS VARCHAR(MAX)	= @Parte4,
@L_Parte5				AS VARCHAR(MAX)	= @Parte5;
	DECLARE		@L_Partes				TABLE (nombre VARCHAR(MAX));

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
		SELECT STUFF((SELECT		', ' + Vulnerabilidades
		FROM		(
						SELECT		G.TC_Descripcion						AS Vulnerabilidades
						FROM		Expediente.Interviniente				A WITH(NOLOCK)
						INNER JOIN	Expediente.Intervencion					B WITH(NOLOCK)
						ON			A.TU_CodInterviniente					= B.TU_CodInterviniente
						INNER JOIN	Catalogo.TipoIntervencion				C WITH(NOLOCK) 
						ON			A.TN_CodTipoIntervencion				= C.TN_CodTipoIntervencion   
						INNER JOIN	Persona.PersonaFisica					D WITH(NOLOCK) 
						ON			D.TU_CodPersona							= B.TU_CodPersona
						AND			(
									CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) IN (
																												SELECT	nombre
																												FROM	@L_Partes
																												)
						Or			CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre) IN (
																												SELECT	nombre
																												FROM	@L_Partes
																												)
									)
						LEFT JOIN	Expediente.ExpedienteDetalle			E WITH(NOLOCK) 
						ON			B.TC_NumeroExpediente					= E.TC_NumeroExpediente  
						INNER JOIN	Expediente.IntervinienteVulnerabilidad	F WITH(NOLOCK)
						On			A.TU_CodInterviniente					= F.TU_CodInterviniente
						INNER JOIN	Catalogo.Vulnerabilidad					G WITH(NOLOCK)
						ON			F.TN_CodVulnerabilidad					= G.TN_CodVulnerabilidad
						WHERE		(E.TC_NumeroExpediente					= @L_NumeroExpediente
						AND			(E.TC_CodContexto						= @L_Contexto)
						AND			B.TU_CodInterviniente					NOT IN (SELECT	TU_CodInterviniente 
																					FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																					WHERE	TU_CodInterviniente = B.TU_CodInterviniente))
								
					)
		AS			TABLA
		WHERE		Vulnerabilidades IS NOT NULL
		ORDER BY	Vulnerabilidades DESC
		FOR XML PATH ('')), 1, 2, '')
	END
	ELSE
	BEGIN
		SELECT STUFF((SELECT		', ' + Vulnerabilidades
		FROM		(
						SELECT		G.TC_Descripcion						AS Vulnerabilidades
						FROM		Expediente.Interviniente				A WITH(NOLOCK)
						INNER JOIN	Expediente.Intervencion					B WITH(NOLOCK)
						ON			A.TU_CodInterviniente					= B.TU_CodInterviniente
						INNER JOIN  Expediente.LegajoIntervencion			LI WITH(NOLOCK)
						ON			LI.TU_CodInterviniente					= B.TU_CodInterviniente
						INNER JOIN	Catalogo.TipoIntervencion				C WITH(NOLOCK) 
						ON			A.TN_CodTipoIntervencion				= C.TN_CodTipoIntervencion   
						INNER JOIN	Persona.PersonaFisica					D WITH(NOLOCK) 
						ON			D.TU_CodPersona							= B.TU_CodPersona
						AND			(
									CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) IN (
																												SELECT	nombre
																												FROM	@L_Partes
																												)
						Or			CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre) IN (
																												SELECT	nombre
																												FROM	@L_Partes
																												)
									)
						LEFT JOIN	Expediente.LegajoDetalle				E WITH(NOLOCK) 
						ON			E.TU_CodLegajo							= LI.TU_CodLegajo
						INNER JOIN	Expediente.IntervinienteVulnerabilidad	F WITH(NOLOCK)
						On			A.TU_CodInterviniente					= F.TU_CodInterviniente
						INNER JOIN	Catalogo.Vulnerabilidad					G WITH(NOLOCK)
						ON			F.TN_CodVulnerabilidad					= G.TN_CodVulnerabilidad
						WHERE		(E.TU_CodLegajo							= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
						AND			(E.TC_CodContexto						= @L_Contexto))
								
					)
		AS			TABLA
		WHERE		Vulnerabilidades IS NOT NULL
		ORDER BY	Vulnerabilidades DESC
		FOR XML PATH ('')), 1, 2, '')
	END	
END
GO
