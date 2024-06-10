SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<24-04-2020>
-- Description:					<Traducción de la Variable del PJEditor relacionadas con la direccion del lugar de trabajo de las partes para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <14/01/2022> <Se agrega parámetro CodLegajo y lógica para legajo.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_DirLugTrabajoInterviniente]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				AS VARCHAR(40),
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
		--EXPEDIENTE
		SELECT		E.TC_Direccion								AS Direccion
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion					C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
		ON			D.TU_CodPersona								= B.TU_CodPersona
		INNER JOIN	Persona.Domicilio							E WITH(NOLOCK) 
		ON			E.TU_CodPersona								= D.TU_CodPersona
		AND			E.TN_CodTipoDomicilio						= 1
		AND			E.TC_Direccion								IS NOT NULL
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
		AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente 
																		FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																		WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
		UNION ALL				
		SELECT		H.TC_Direccion								AS Direccion
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
		ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
		INNER JOIN  Catalogo.TipoIntervencion					D WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion 
		INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
		ON			B.TU_CodPersona								= E.TU_CodPersona 
		LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente 
		INNER JOIN	Persona.PersonaJuridica						G WITH(NOLOCK) 
		ON			E.TU_CodPersona								= G.TU_CodPersona
		INNER JOIN	Persona.Domicilio							H WITH(NOLOCK) 
		ON			H.TU_CodPersona								= G.TU_CodPersona
		AND			G.TC_Nombre									IN (
																	SELECT	nombre
																	FROM	@L_Partes
																	)
		AND			H.TN_CodTipoDomicilio						= 1
		AND			H.TC_Direccion								IS NOT NULL
		WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
		AND			F.TC_CodContexto							= @L_Contexto
		AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente
																		FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																		WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
	END
	ELSE
	BEGIN
		--LEGAJO
		SELECT		E.TC_Direccion								AS Direccion
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion					C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
		ON			D.TU_CodPersona								= B.TU_CodPersona
		INNER JOIN	Persona.Domicilio							E WITH(NOLOCK) 
		ON			E.TU_CodPersona								= D.TU_CodPersona
		AND			E.TN_CodTipoDomicilio						= 1
		AND			E.TC_Direccion								IS NOT NULL
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
		SELECT		H.TC_Direccion								AS Direccion
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
		ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
		INNER JOIN  Catalogo.TipoIntervencion					D WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion 
		INNER JOIN	Persona.Persona								E WITH(NOLOCK) 
		ON			B.TU_CodPersona								= E.TU_CodPersona 
		LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
		ON			F.TU_CodLegajo 								=  LI.TU_CodLegajo
		INNER JOIN	Persona.PersonaJuridica						G WITH(NOLOCK) 
		ON			E.TU_CodPersona								= G.TU_CodPersona
		INNER JOIN	Persona.Domicilio							H WITH(NOLOCK) 
		ON			H.TU_CodPersona								= G.TU_CodPersona
		AND			G.TC_Nombre									IN (
																	SELECT	nombre
																	FROM	@L_Partes
																	)
		AND			H.TN_CodTipoDomicilio						= 1
		AND			H.TC_Direccion								IS NOT NULL
		WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			F.TC_CodContexto							= @L_Contexto
	END	
END
GO
