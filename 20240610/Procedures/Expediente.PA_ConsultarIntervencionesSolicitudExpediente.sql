SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<24/03/2020>
-- Descripción:			<Permite consultar los intervinientes asociados a SolicitudExpediente.>
-- ==================================================================================================================================================================================
-- Modificar por:       <Jose Gabriel Cordero Soto><24/03/2020><Se agrega codigo solicitud en consulta de retorno>
-- Modificar por:       <Jose Gabriel Cordero Soto><25/03/2020><Se agrega el campo de tipo participación>
-- Modificado por:      <Jose Gabriel Cordero Soto><20/04/2020><Se ajusta nombramiento de parametros recibidos para coincidir con nombre en campo de tabla, objetivo seguir el estandar>
-- Modificado por:      <Jose Gabriel Cordero Soto><22/04/2020><Se agrega código de intervención para que sea devuelto en la consulta>
-- Modificado por:		<Jonathan Aguilar Navarro> <26/02/2021> <Se cambia a por un LEFT JOIN contra la tabla Interviniente, ya que los representantes no tiene registro en esa tabla>
-- Modificado por:		<Roger Lara Hernandez> <20/01/2022> <Se agrega CodigoPersona al select>
-- =================================================================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ConsultarIntervencionesSolicitudExpediente]
	@CodSolicitudExpediente				UNIQUEIDENTIFIER,
	@NumeroExpediente					VARCHAR(14)		
AS
BEGIN
	--Variables
	DECLARE	@L_CodSolicitudExpediente	UNIQUEIDENTIFIER	= @CodSolicitudExpediente
	DECLARE	@L_NumeroExpediente			VARCHAR(14)			= @NumeroExpediente

	--Lógica
	SELECT	SE.TU_CodSolicitudExpediente					AS Codigo,			
			'splitOtros'									AS splitOtros,
			I.TU_CodInterviniente							AS CodInterviniente,
			I.TC_TipoParticipacion							AS TipoParticipacion,
			CASE P.TC_CodTipoPersona
				WHEN 'F' THEN PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + ISNULL(PF.TC_SegundoApellido,'')
				WHEN 'J' THEN PJ.TC_Nombre
 			END												AS NombrePersona,
			P.TC_Identificacion								AS Identificacion,
			P.TC_CodTipoPersona								AS TipoPersona,
			P.TU_CodPersona									AS CodigoPersona,
			TII.TN_CodTipoIntervencion						AS CodigoIntervencion,
			TII.TC_Descripcion								AS TipoIntervencion,			
			TI.TN_CodTipoIdentificacion						AS CodigoTipoIdentificacion,
			TI.TC_Descripcion								AS DescripcionTipoIdentificacion,
			TI.TB_EsIgnorado								AS Ignorado,
			TI.TB_Nacional									AS Nacional,
			TI.TB_EsJuridico								AS Juridico,
			TI.TC_Formato									AS FormatoTipoIdentificacion

			FROM		Expediente.SolicitudExpediente		AS SE	WITH(NOLOCK)
			INNER JOIN  Expediente.IntervencionSolicitud    AS INS  WITH(NOLOCK)
			ON			SE.TU_CodSolicitudExpediente		= INS.TU_CodSolicitudExpediente
			INNER JOIN  Expediente.Intervencion 			AS I	WITH(NOLOCK)
			ON			I.TU_CodInterviniente				= INS.TU_CodInterviniente
			LEFT JOIN  Expediente.Interviniente            AS EI	WITH(NOLOCK)
			ON			EI.TU_CodInterviniente				= INS.TU_CodInterviniente
			LEFT JOIN  Catalogo.TipoIntervencion			AS TII	WITH(NOLOCK)
			ON			TII.TN_CodTipoIntervencion			= EI.TN_CodTipoIntervencion
			INNER JOIN  Persona.Persona						AS P	WITH(NOLOCK)
			ON			P.TU_CodPersona						= I.TU_CodPersona
			LEFT JOIN   Persona.PersonaFisica				AS PF   WITH(NOLOCK)
			ON			P.TU_CodPersona						= PF.TU_CodPersona
			LEFT JOIN   Persona.PersonaJuridica				AS PJ   WITH(NOLOCK)
			ON			P.TU_CodPersona						= PJ.TU_CodPersona
			INNER JOIN  Catalogo.TipoIdentificacion			AS TI   WITH(NOLOCK)
			ON			P.TN_CodTipoIdentificacion			= TI.TN_CodTipoIdentificacion

			WHERE		SE.TC_NumeroExpediente				= @L_NumeroExpediente 
			AND			SE.TU_CodSolicitudExpediente		= @L_CodSolicitudExpediente 
			ORDER BY	NombrePersona						ASC


END
GO
