SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<08-05-2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas con el estado civil de las partes para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_EstadoCivilInterviniente]
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@Parte1					As VarChar(MAX),
	@Parte2					As VarChar(MAX),
	@Parte3					As VarChar(MAX),
	@Parte4					As VarChar(MAX),
	@Parte5					As VarChar(MAX)
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto;
	Declare		@L_Partes				TABLE (nombre VarChar(MAX));
		
	INSERT Into @L_Partes
	Select	RTRIM(LTRIM(Value))
	From	STRING_SPLIT(@Parte1, ',')

	INSERT Into @L_Partes
	Select	RTRIM(LTRIM(Value))
	From	STRING_SPLIT(@Parte2, ',')

	INSERT Into @L_Partes
	Select	RTRIM(LTRIM(Value))
	From	STRING_SPLIT(@Parte3, ',')

	INSERT Into @L_Partes
	Select	RTRIM(LTRIM(Value))
	From	STRING_SPLIT(@Parte4, ',')

	INSERT Into @L_Partes
	Select	RTRIM(LTRIM(Value))
	From	STRING_SPLIT(@Parte5, ',')

	Select		E.TC_Descripcion				As EstadoCivil
	FROM		Expediente.Interviniente		A With(NoLock)
	INNER JOIN	Expediente.Intervencion			B With(Nolock)
	ON			A.TU_CodInterviniente			= B.TU_CodInterviniente
	INNER JOIN	Catalogo.TipoIntervencion		C With(NoLock) 
	ON			A.TN_CodTipoIntervencion		= C.TN_CodTipoIntervencion   
	INNER JOIN	Persona.PersonaFisica			D With(NoLock) 
	ON			D.TU_CodPersona					= B.TU_CodPersona
	AND			D.TN_CodEstadoCivil				IS NOT NULL
	AND			(
				CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) In (
																							Select	nombre
																							From	@L_Partes
																							)
	Or			CONCAT(D.TC_PrimerApellido, ' ', D.TC_SegundoApellido, ' ', D.TC_Nombre) In (
																							Select	nombre
																							From	@L_Partes
																							)
				)
	INNER JOIN	Catalogo.EstadoCivil			E With(NoLock)
	ON			D.TN_CodEstadoCivil				= E.TN_CodEstadoCivil
	LEFT JOIN	Expediente.ExpedienteDetalle	F With(NoLock) 
	ON			B.TC_NumeroExpediente			= F.TC_NumeroExpediente  
	WHERE		F.TC_NumeroExpediente			= @L_NumeroExpediente
	AND			F.TC_CodContexto				= @L_Contexto
END
GO
