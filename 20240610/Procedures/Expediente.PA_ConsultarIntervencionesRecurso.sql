SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<17/01/2020>
-- Descripción:				<Consulta las intervenciones asociadas a un recurso>
-- =======================================================================================================================================
-- Modificación:			<28/01/2020><Jose Gabriel Cordero Soto><Se agrega tipo de persona en consulta>
-- Modificación:			<30/01/2020><Jose Gabriel Cordero Soto><Se agrega tipo de particpacion de la intervencion>
-- Modificación				<Jonathan Aguilar Navarro> <12/08/2020> <Se agregar el formato del tipo de identificación a la consulta y se modifica para
--							que se muestre el tipo de intervención de la parte y no el seleccionado en el recurso.>
-- Modificación:			<Jose Gabriel Cordero Soto><14/08/2020><Se ajusta consulta para contemplar los representantes en la consulta de intervenciones>
-- Modificación:			<20/02/2021> <Aida Elena Siles R> <Se realiza corrección nombre intervención cuando solo tiene el primer apellido>
-- =======================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervencionesRecurso]
@CodRecurso			uniqueidentifier
AS
BEGIN
	Declare @L_CodRecurso uniqueidentifier			=   @CodRecurso

	SELECT	I.TF_Inicio_Vigencia					AS  FechaActivacion,
			'splitTipoIntervencion'					AS  splitTipoIntervencion,			
			TI.TN_CodTipoIntervencion				AS  Codigo,
			UPPER(TI.TC_Descripcion)				AS	Descripcion,			
			'splitTipoIdentificacion'				AS  splitTipoIdentificacion,						
			TIP.TN_CodTipoIdentificacion			AS  Codigo, 
			UPPER(TIP.TC_Descripcion)				AS  Descripcion,
			TIP.TC_Formato							AS  Formato,
			'splitPersona'							AS  splitPersona,						
			P.TU_CodPersona							AS  CodigoPersona,
			P.TC_Identificacion						AS  Identificacion,	
			P.TC_CodTipoPersona						AS  TipoPersona,
			ISNULL(CASE P.TC_CodTipoPersona
				WHEN 'F' THEN IIF(PF.TC_SegundoApellido IS NULL, UPPER(PF.TC_Nombre + ' ' + PF.TC_PrimerApellido), UPPER(PF.TC_Nombre + ' ' + PF.TC_PrimerApellido + ' ' + PF.TC_SegundoApellido))					
				WHEN 'J' THEN UPPER(PJ.TC_Nombre)
			END, 'IGNORADO')						AS	 NombreCompleto,
			I.TC_TipoParticipacion					AS	 TipoParticipacion,
			I.TU_CodInterviniente					AS  CodigoInterviniente

	FROM		Expediente.RecursoExpediente		R 
	INNER JOIN	Expediente.IntervencionRecurso		IR WITH (NOLOCK)	
	ON			IR.TU_CodRecurso				    = R.TU_CodRecurso
	INNER JOIN	Expediente.Intervencion				I WITH (NOLOCK)	
	ON			I.TU_CodInterviniente			    = IR.TU_CodInterviniente	
	LEFT JOIN	Expediente.Interviniente			H WITH (NOLOCK)	
	ON			H.TU_CodInterviniente			    = I.TU_CodInterviniente	
	LEFT JOIN	Catalogo.TipoIntervencion			TI WITH (NOLOCK)	
	ON			TI.TN_CodTipoIntervencion			= H.TN_CodTipoIntervencion
	INNER JOIN	Persona.Persona						P WITH (NOLOCK)	
	ON			P.TU_CodPersona						=  I.TU_CodPersona
	INNER JOIN	Catalogo.TipoIdentificacion			TIP WITH (NOLOCK)	
	ON			P.TN_CodTipoIdentificacion			=  TIP.TN_CodTipoIdentificacion
	LEFT JOIN	Persona.PersonaFisica				PF WITH (NOLOCK)	
	ON			PF.TU_CodPersona					=  P.TU_CodPersona
	LEFT JOIN	Persona.PersonaJuridica				PJ WITH (NOLOCK)	
	ON			PJ.TU_CodPersona					=  P.TU_CodPersona
 
	WHERE		R.TU_CodRecurso						= @L_CodRecurso

	ORDER BY    NombreCompleto

END
GO
