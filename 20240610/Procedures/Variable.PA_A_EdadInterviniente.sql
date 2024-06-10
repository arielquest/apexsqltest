SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<08-05-2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas con la edad de las partes para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <14/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_EdadInterviniente]
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
		SELECT		DATEDIFF(YEAR, D.TF_FechaNacimiento, GETDATE()) AS Edad
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion					C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= C.TN_CodTipoIntervencion   
		INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
		ON			D.TU_CodPersona								= B.TU_CodPersona
		AND			D.TF_FechaNacimiento						IS NOT NULL
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
		AND			B.TU_CodInterviniente						NOT IN (SELECT	LI.TU_CodInterviniente
																		FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																		WHERE	LI.TU_CodInterviniente = B.TU_CodInterviniente)
	END
	ELSE
	BEGIN
		SELECT		DATEDIFF(YEAR, D.TF_FechaNacimiento, GETDATE()) AS Edad
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Expediente.LegajoIntervencion				LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Catalogo.TipoIntervencion					C WITH(NOLOCK) 
		ON			A.TN_CodTipoIntervencion					= C.TN_CodTipoIntervencion
		INNER JOIN	Persona.PersonaFisica						D WITH(NOLOCK) 
		ON			D.TU_CodPersona								= B.TU_CodPersona
		AND			D.TF_FechaNacimiento						IS NOT NULL
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
		WHERE		LI.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			F.TC_CodContexto							= @L_Contexto
	END
END
GO
