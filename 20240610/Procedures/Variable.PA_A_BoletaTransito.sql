SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño Rosales>
-- Create date:					<08/06/2020>
-- Description:					<Traducción de la Variable del PJEditor relacionadas con los numeros de boleta de transito para LibreOffice>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_BoletaTransito]                 
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@TiposIntervencion		As VarChar(MAX)
AS
BEGIN
	Declare		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto,
				@L_TiposIntervencion	VARCHAR(MAX)	=	@TiposIntervencion;
	Declare		@L_Tipos				TABLE (Tipo int);

	If LEN(@L_TiposIntervencion) = 0
		INSERT Into @L_Tipos
		Select	TN_CodTipoIntervencion
		From	Catalogo.TipoIntervencion With(NoLock)
	Else
		INSERT Into @L_Tipos
		Select	convert(int,RTRIM(LTRIM(Value)))
		From	STRING_SPLIT(@L_TiposIntervencion, ',')

	
	Select		C.TN_NumeroBoleta							As Boleta
	FROM		Expediente.Interviniente					A With(NoLock)
	INNER JOIN	Expediente.Intervencion						B With(Nolock)
	ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
	AND			A.TN_CodTipoIntervencion					In (
																SELECT	Tipo
																FROM	@L_Tipos
																)
	INNER JOIN	Expediente.IntervinienteBoletaTransito		C With(NoLock) 
	ON			A.TU_CodInterviniente						= C.TU_CodInterviniente  
	INNER JOIN	Persona.PersonaFisica						D With(NoLock) 
	ON			D.TU_CodPersona								= B.TU_CodPersona
	LEFT JOIN	Expediente.ExpedienteDetalle				F With(NoLock) 
	ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente
	WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
	AND			F.TC_CodContexto							= @L_Contexto			
END
GO
