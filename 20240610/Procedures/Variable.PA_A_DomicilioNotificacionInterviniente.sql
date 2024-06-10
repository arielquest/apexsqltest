SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris Ramírez>
-- Create date:					<04-06-2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas con el Domicilio de notificación del interviniente para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<Aida Elena Siles R> <14/01/2022> <Se agrega lógica para Legajos>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_DomicilioNotificacionInterviniente]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Parte					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)	 = @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto;
DECLARE		@L_Partes				TABLE (nombre VARCHAR(MAX));

	INSERT INTO @L_Partes
	SELECT	RTRIM(LTRIM(Value))
FROM	STRING_SPLIT(@Parte, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT STUFF((SELECT		' - ' + DomicilioNotificacion
		FROM		(
						SELECT		CONCAT(B.TC_Descripcion, ':', A.TC_Valor, ' -- ', E.TC_Direccion) AS DomicilioNotificacion
						FROM		Expediente.IntervencionMedioComunicacion	A WITH(NOLOCK)
						INNER JOIN	Catalogo.TipoMedioComunicacion				B WITH(NOLOCK)
						ON			B.TN_CodMedio								= A.TN_CodMedio
						INNER JOIN	Expediente.Intervencion						C WITH(NOLOCK)
						ON			C.TU_CodInterviniente						= A.TU_CodInterviniente
						INNER JOIN	Expediente.Expediente						D WITH(NOLOCK)
						ON			D.TC_NumeroExpediente						= C.TC_NumeroExpediente
						INNER JOIN	Persona.Domicilio							E WITH(NOLOCK)
						ON			E.TU_CodPersona								= C.TU_CodPersona
						INNER JOIN	Persona.PersonaFisica						F WITH(NOLOCK)
						ON			F.TU_CodPersona								= C.TU_CodPersona
						AND			(
									CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido) In (
																												SELECT 	nombre
																												FROM 	@L_Partes
																												)
						OR 			CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', F.TC_Nombre) In (
																												SELECT 	nombre
																												FROM 	@L_Partes
																												)
									)
						WHERE		C.TC_NumeroExpediente						= @L_NumeroExpediente
						AND			D.TC_CodContexto							= @L_Contexto	
						UNION ALL
						SELECT		CONCAT(B.TC_Descripcion, ':', A.TC_Valor, ' -- ', E.TC_Direccion) AS DomicilioNotificacion
						FROM		Expediente.IntervencionMedioComunicacion	A WITH(NOLOCK)
						INNER JOIN	Catalogo.TipoMedioComunicacion				B WITH(NOLOCK)
						ON			B.TN_CodMedio								= A.TN_CodMedio
						INNER JOIN	Expediente.Intervencion						C WITH(NOLOCK)
						ON			C.TU_CodInterviniente						= A.TU_CodInterviniente
						INNER JOIN	Expediente.Expediente						D WITH(NOLOCK)
						ON			D.TC_NumeroExpediente						= C.TC_NumeroExpediente
						INNER JOIN	Persona.Domicilio							E WITH(NOLOCK)
						ON			E.TU_CodPersona								= C.TU_CodPersona
						INNER JOIN	Persona.PersonaJuridica						F WITH(NOLOCK)
						ON			F.TU_CodPersona								= C.TU_CodPersona
						AND			F.TC_Nombre									IN (
																					SELECT	nombre
																					FROM	@L_Partes
																					)
						WHERE		C.TC_NumeroExpediente						= @L_NumeroExpediente
						AND			D.TC_CodContexto							= @L_Contexto
						AND			C.TU_CodInterviniente						NOT IN (SELECT	LI.TU_CodInterviniente
																						FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																						WHERE	LI.TU_CodInterviniente = C.TU_CodInterviniente)
					)
		AS			TABLA
		WHERE		DomicilioNotificacion IS NOT NULL
		ORDER BY	DomicilioNotificacion DESC
		FOR XML PATH ('')), 1, 3, '')
	END
	ELSE
	BEGIN
		SELECT STUFF((SELECT		' - ' + DomicilioNotificacion
		FROM		(
						SELECT		CONCAT(B.TC_Descripcion, ':', A.TC_Valor, ' -- ', E.TC_Direccion) AS DomicilioNotificacion
						FROM		Expediente.IntervencionMedioComunicacion	A WITH(NOLOCK)
						INNER JOIN	Catalogo.TipoMedioComunicacion				B WITH(NOLOCK)
						ON			B.TN_CodMedio								= A.TN_CodMedio
						INNER JOIN	Expediente.Intervencion						C WITH(NOLOCK)
						ON			C.TU_CodInterviniente						= A.TU_CodInterviniente
						INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
						ON			LI.TU_CodInterviniente						= C.TU_CodInterviniente
						INNER JOIN	Expediente.Legajo							D WITH(NOLOCK)
						ON			D.TU_CodLegajo								= LI.TU_CodLegajo
						INNER JOIN	Persona.Domicilio							E WITH(NOLOCK)
						ON			E.TU_CodPersona								= C.TU_CodPersona
						INNER JOIN	Persona.PersonaFisica						F WITH(NOLOCK)
						ON			F.TU_CodPersona								= C.TU_CodPersona
						AND			(
									CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido) In (
																												SELECT 	nombre
																												FROM 	@L_Partes
																												)
						OR 			CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', F.TC_Nombre) In (
																												SELECT 	nombre
																												FROM 	@L_Partes
																												)
									)
						WHERE		LI.TU_CodLegajo								= @L_CodLegajo
						AND			D.TC_CodContexto							= @L_Contexto	
						UNION ALL
						SELECT		CONCAT(B.TC_Descripcion, ':', A.TC_Valor, ' -- ', E.TC_Direccion) AS DomicilioNotificacion
						FROM		Expediente.IntervencionMedioComunicacion	A WITH(NOLOCK)
						INNER JOIN	Catalogo.TipoMedioComunicacion				B WITH(NOLOCK)
						ON			B.TN_CodMedio								= A.TN_CodMedio
						INNER JOIN	Expediente.Intervencion						C WITH(NOLOCK)
						ON			C.TU_CodInterviniente						= A.TU_CodInterviniente
						INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
						ON			LI.TU_CodInterviniente						= C.TU_CodInterviniente
						INNER JOIN	Expediente.Legajo							D WITH(NOLOCK)
						ON			D.TU_CodLegajo								= LI.TU_CodLegajo
						INNER JOIN	Persona.Domicilio							E WITH(NOLOCK)
						ON			E.TU_CodPersona								= C.TU_CodPersona
						INNER JOIN	Persona.PersonaJuridica						F WITH(NOLOCK)
						ON			F.TU_CodPersona								= C.TU_CodPersona
						AND			F.TC_Nombre									IN (
																					SELECT	nombre
																					FROM	@L_Partes
																					)
						WHERE		LI.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
						AND			D.TC_CodContexto							= @L_Contexto				
					)
		AS			TABLA
		WHERE		DomicilioNotificacion IS NOT NULL
		ORDER BY	DomicilioNotificacion DESC
		FOR XML PATH ('')), 1, 3, '')
	END	
END
GO
