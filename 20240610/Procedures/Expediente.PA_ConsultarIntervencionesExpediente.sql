SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<06/11/2019>
-- Descripción :			<Permite consultar la información de las intervenciones del expediente indicado> 
-- =================================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero Soto><02/12/2019><Se modifica consulta para incorporar valor de Tipo Persona (Fisico/Juridico)>
-- =================================================================================================================================================
-- Modificado por:          <Jose Gabriel Cordero Soto><24/04/2020><Se ajusta segundo nombre para que no omita si esta nulo (validación)>
-- =================================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero Soto><11/05/2020><Se ajusta consulta y se contemplan varios registros omitidos y se agrega el tipo de participacion>
-- =================================================================================================================================================
-- Modificado por:			<Roger Lara><25/10/2020><Se ajusta consulta para no consultar los intervinientes de los legajos>
-- =================================================================================================================================================
-- Modificado por:			<Josu‚ Quirós Batista><12/01/2022><Se agrega el TU_CodInterviniente al resultado que se obtiene al ejecutar la consulta.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervencionesExpediente]
@NumeroExpediente VARCHAR(14) 
AS
BEGIN
	DECLARE @L_NumeroExpediente					VARCHAR(14) = @NumeroExpediente

	SELECT 		   
			   I.TC_NumeroExpediente			AS Numero,	
			   'splitPersona'					AS splitPersona,
			   P.TC_Identificacion				AS Identificacion, 			   
			   CASE P.TC_CodTipoPersona
				WHEN 'F' THEN Upper(PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + ISNULL(PF.TC_SegundoApellido,''))					
				WHEN 'J' THEN Upper(PJ.TC_Nombre)
			   END				   		   		AS NombreCompleto,
			   'splitTipoIntervencion'			AS splitTipoIntervencion,
			   TI.TC_Descripcion				AS Descripcion,
			   TI.TN_CodTipoIntervencion		AS Codigo,
			   'splitOtros'						AS splitOtros,
			   I.TU_CodInterviniente			As	CodigoInterviniente,
			   P.TC_CodTipoPersona				AS TipoPersona,
		       TIP.TC_Formato					AS TipoFormato,
			   I.TC_TipoParticipacion			AS TipoParticipacion

	FROM	   Expediente.Intervencion			AS I 
	LEFT JOIN Expediente.Interviniente			AS EI  WITH(NOLOCK)
	ON		   EI.TU_CodInterviniente			= I.TU_CodInterviniente
	LEFT JOIN Catalogo.TipoIntervencion		AS TI  WITH(NOLOCK)
	ON		   EI.TN_CodTipoIntervencion        = TI.TN_CodTipoIntervencion
	INNER JOIN Persona.Persona					AS P   WITH(NOLOCK)
	ON		   I.TU_CodPersona					= P.TU_CodPersona
	INNER JOIN Catalogo.TipoIdentificacion		AS TIP WITH(NOLOCK)
	ON		   TIP.TN_CodTipoIdentificacion		= P.TN_CodTipoIdentificacion
	LEFT JOIN  Persona.PersonaFisica			AS PF  WITH(NOLOCK)
	ON		   P.TU_CodPersona					= PF.TU_CodPersona
	LEFT JOIN  Persona.PersonaJuridica			AS PJ  WITH(NOLOCK)
	ON		   P.TU_CodPersona					= PJ.TU_CodPersona

	WHERE	   TC_NumeroExpediente = @NumeroExpediente
    And				I.TU_CodInterviniente			NOT IN (SELECT TU_CodInterviniente FROM 
															Expediente.LegajoIntervencion WITH (Nolock)
															WHERE TU_CodInterviniente = I.TU_CodInterviniente)
	GROUP BY   I.TC_NumeroExpediente, TC_Identificacion, P.TC_CodTipoPersona, PF.TC_Nombre, PF.TC_PrimerApellido, PF.TC_SegundoApellido, 
			   PJ.TC_Nombre, TI.TC_Descripcion, TI.TN_CodTipoIntervencion, I.TU_CodInterviniente, P.TC_CodTipoPersona, TIP.TC_Formato, I.TC_TipoParticipacion
	
	ORDER BY   TI.TC_Descripcion
END
GO
