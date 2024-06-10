SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Expediente].[PA_ConsultarAvisoExpedienteIndigena]
	@Numero	CHAR(14)
AS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis ALonso Leiva Tames>
-- Fecha de creación:		<04/12/2020>
-- Descripción :			<Consultar Avisos Persona Indigena Expediente> 
-- =================================================================================================================================================



DECLARE @L_Numero				AS CHAR(14)	= @Numero
DECLARE @L_CodVulenrabilidad	AS INT
DECLARE @L_TN_CodEtnia			AS INT

SELECT 
	@L_CodVulenrabilidad = TN_CodVulnerabilidad 
FROM 
	Catalogo.Vulnerabilidad 
WHERE 
	TC_Descripcion = 'Persona indigente' AND 
	TF_Inicio_Vigencia <= GETDATE() AND 
	(TF_Fin_Vigencia IS NULL OR TF_Fin_Vigencia >= GETDATE())


SELECT 
	@L_TN_CodEtnia = TN_CodEtnia  
FROM 
	Catalogo.Etnia
WHERE 
	TC_Descripcion = 'Persona Indígena' AND 
	TF_Inicio_Vigencia <= GETDATE() AND 
	(TF_Fin_Vigencia IS NULL OR TF_Fin_Vigencia >= GETDATE())


SELECT 
	COUNT(1)  'ExisteNotificacion'
FROM 
	Expediente.Intervencion										A WITH (NOLOCK)
		INNER JOIN Expediente.Interviniente						B WITH (NOLOCK) on 
					A.TU_CodInterviniente = B.TU_CodInterviniente 
		LEFT JOIN Expediente.IntervinienteVulnerabilidad		V WITH (NOLOCK) on 
					A.TU_CodInterviniente = V.TU_CodInterviniente AND V.TN_CodVulnerabilidad = @L_CodVulenrabilidad
		INNER JOIN Persona.Persona								P WITH (NOLOCK) on 
					A.TU_CodPersona = P.TU_CodPersona 
		INNER JOIN Persona.PersonaFisica						F WITH (NOLOCK) on 
					P.TU_CodPersona = F.TU_CodPersona
WHERE
	A.TF_Inicio_Vigencia <=  GETDATE() AND 
	(A.TF_Fin_Vigencia IS NULL OR A.TF_Fin_Vigencia >= GETDATE()) AND 
	F.TN_CodEtnia = @L_TN_CodEtnia AND 
	A.TC_NumeroExpediente = @L_Numero
GO
