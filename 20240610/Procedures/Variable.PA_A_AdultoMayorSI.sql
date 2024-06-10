SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<14/05/2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas para Identifica si el interviniente es 
--								persona adulta mayor para LibreOffice>
-- NOTA IMPORTANTE:				Como parametro para @Salida indicar 1: Salida corta (SI), 2: Salida larga
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <11/01/2022> <Se agrega parámetro CodLegajo y lógica para legajo>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_AdultoMayorSI]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				AS VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Salida					AS INTEGER
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)			= @NumeroExpediente,
				@L_CodLegajo			AS VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)		= @Contexto,
				@L_Salida				AS INTEGER			= @Salida,
				@L_FecNacimientoMinima	AS DATETIME;

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SET @L_FecNacimientoMinima = (	SELECT		MIN(D.TF_FechaNacimiento)
										FROM		Expediente.Interviniente		A WITH(NOLOCK)
										INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
										ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
										INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
										ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
										INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
										ON			D.TU_CodPersona					= B.TU_CodPersona
										AND			D.TF_FechaNacimiento			IS NOT NULL
										LEFT JOIN	Expediente.ExpedienteDetalle	F WITH(NOLOCK) 
										ON			B.TC_NumeroExpediente			= F.TC_NumeroExpediente  
										WHERE		F.TC_NumeroExpediente			= @L_NumeroExpediente
										AND			F.TC_CodContexto				= @L_Contexto
										AND			B.TU_CodInterviniente			NOT IN (SELECT	LI.TU_CodInterviniente
																							FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																							WHERE	LI.TU_CodInterviniente = B.TU_CodInterviniente))
	END
	ELSE
	BEGIN
		SET @L_FecNacimientoMinima = (	SELECT		MIN(D.TF_FechaNacimiento)
										FROM		Expediente.Interviniente		A WITH(NOLOCK)
										INNER JOIN	Expediente.Intervencion			B WITH(NOLOCK)
										ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
										INNER JOIN  Expediente.LegajoIntervencion	LI WITH(NOLOCK)
										ON			B.TU_CodInterviniente			= LI.TU_CodInterviniente
										INNER JOIN	Catalogo.TipoIntervencion		C WITH(NOLOCK) 
										ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
										INNER JOIN	Persona.PersonaFisica			D WITH(NOLOCK) 
										ON			D.TU_CodPersona					= B.TU_CodPersona
										AND			D.TF_FechaNacimiento			IS NOT NULL
										LEFT JOIN	Expediente.LegajoDetalle		F WITH(NOLOCK) 
										ON			F.TU_CodLegajo					= LI.TU_CodLegajo  
										WHERE		F.TU_CodLegajo					= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
										AND			F.TC_CodContexto				= @L_Contexto)
	END

	SELECT		
		CASE 
			WHEN (DATEDIFF(YEAR,	@L_FecNacimientoMinima,	GETDATE()) > 65) And @L_Salida = 1 THEN 'SI'
			WHEN (DATEDIFF(YEAR,	@L_FecNacimientoMinima,	GETDATE()) > 65) And @L_Salida = 2 THEN 'En este proceso una de las partes es una persona adulta mayor, por lo que se solicita se atienda la gestión de manera prioritaria, eficiente y eficaz'
		END AS AdultoMayorSI
END
GO
