SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Expediente].[PA_ConsultarAvisoExpedienteDiscapacidad]
	@Numero	CHAR(14)
AS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis ALonso Leiva Tames>
-- Fecha de creación:		<04/12/2020>
-- Descripción :			<Consultar Avisos Persona Discapacitadad Expediente> 
-- =================================================================================================================================================



DECLARE @L_Numero				AS CHAR(14)	= @Numero

SELECT 
	COUNT(1)  'ExisteNotificacion'
FROM 
	Expediente.Intervencion										A WITH (NOLOCK)
		INNER JOIN Expediente.Interviniente						B WITH (NOLOCK) on 
					A.TU_CodInterviniente = B.TU_CodInterviniente 
		INNER JOIN Expediente.IntervinienteDiscapacidad D WITH (NOLOCK) on
					D.TU_CodInterviniente = B.TU_CodInterviniente
		INNER JOIN Persona.Persona								P WITH (NOLOCK) on 
					A.TU_CodPersona = P.TU_CodPersona 
		INNER JOIN Persona.PersonaFisica						F WITH (NOLOCK) on 
					P.TU_CodPersona = F.TU_CodPersona
WHERE
	A.TF_Inicio_Vigencia <=  GETDATE() AND 
	(A.TF_Fin_Vigencia IS NULL OR A.TF_Fin_Vigencia >= GETDATE()) AND 
	A.TC_NumeroExpediente = @L_Numero
GO
