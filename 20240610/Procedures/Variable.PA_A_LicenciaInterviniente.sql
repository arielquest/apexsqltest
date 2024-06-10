SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<21-12-2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas con el tipo de licencia de las partes para LibreOffice>
-- ====================================================================================================================================================================================
-- Modificación:				<17/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_LicenciaInterviniente]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto;


	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT		G.TC_Descripcion							AS TipoLicencia
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
		ON			E.TU_CodPersona								= B.TU_CodPersona
		INNER JOIN	Persona.Licencia							C WITH(NOLOCK)
		ON			C.TU_CodPersona								= E.TU_CodPersona
		INNER JOIN	Catalogo.TipoLicencia						G WITH(NOLOCK)
		ON			G.TN_CodTipoLicencia						= C.TN_CodTipoLicencia
		LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
		ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente  
		WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
		AND			F.TC_CodContexto							= @L_Contexto
		AND			A.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente
																		FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																		WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
	END
	ELSE
	BEGIN
		SELECT		G.TC_Descripcion							AS TipoLicencia
		FROM		Expediente.Interviniente					A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
		ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Expediente.LegajoIntervencion				LI WITH(NOLOCK)
		ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
		INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
		ON			E.TU_CodPersona								= B.TU_CodPersona
		INNER JOIN	Persona.Licencia							C WITH(NOLOCK)
		ON			C.TU_CodPersona								= E.TU_CodPersona
		INNER JOIN	Catalogo.TipoLicencia						G WITH(NOLOCK)
		ON			G.TN_CodTipoLicencia						= C.TN_CodTipoLicencia
		LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
		ON			F.TU_CodLegajo								= LI.TU_CodLegajo
		WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND			F.TC_CodContexto							= @L_Contexto
	END
END
GO
