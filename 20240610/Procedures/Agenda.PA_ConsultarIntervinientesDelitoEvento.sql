SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<02/12/2020>
-- Descripción:			<Permite consultar los intervinientes de un evento con sus delitos>
-- ==================================================================================================================================================================================

CREATE PROCEDURE [Agenda].[PA_ConsultarIntervinientesDelitoEvento] 
	@CodigoEvento Uniqueidentifier
As
Begin

		Declare			@L_CodigoEvento	Uniqueidentifier =	@CodigoEvento;

	Set NoCount On;

		Select			I.TF_Prescripcion				As	FechaPrescripcion,
						'SplitIntervencion'				As	SplitIntervencion,
						C.TF_Inicio_Vigencia			As	FechaActivacion,		  
						C.TF_Fin_Vigencia				As	FechaDesactivacion, 
						C.TF_Actualizacion				As	FechaModificacion,
						'SplitTI'						As	SplitTI,
						B.TU_CodInterviniente			As	CodigoInterviniente,		  
						B.TF_ComisionDelito				As	FechaComisionDelito, 
						B.TC_Caracteristicas			As	Caracteristicas,		      
						B.TC_Alias						As	Alias, 
						B.TB_Droga						As	Droga, 
						B.TB_Rebeldia					As	Rebeldia,
						'SplitTIn' As SplitTIn,
						D.TN_CodTipoIntervencion		As	Codigo,
						D.TC_Descripcion				As	Descripcion,		
						'SplitPF' As SplitPF,
						F.TU_CodPersona					As	CodigoPersona,
						F.TC_Nombre						As	Nombre,
						F.TC_PrimerApellido				As	PrimerApellido,
						F.TC_SegundoApellido			As	SegundoApellido,
						F.TF_FechaNacimiento			As  FechaNacimiento,			 
						E.TC_Identificacion				As	Identificacion,
						F.TB_EsIgnorado					As	EsIgnorado,	
						'SplitPJ' As SplitPJ,
						G.TU_CodPersona					As	CodigoPersona,
						G.TC_Nombre						As	Nombre,
						E.TC_Identificacion				As	Identificacion,					
						'SplitOtros'					As	SplitOtros,
						H.TN_CodTipoIdentificacion		As	CodigoTipoIdentificacion,
						H.TC_Descripcion				As	DescripcionTipoIdentificacion,
						D.TC_Intervencion 				As	Intervencion,
						C.TC_TipoParticipacion			As  TipoParticipacion,
						C.TC_NumeroExpediente			As  Numero,
						J.TN_CodDelito					As	CodDelito,
						J.TC_Descripcion				As	DescripcionDelito,
						K.TN_CodCategoriaDelito			As	CodCategoriaDelito,
						K.TC_Descripcion				As	DescripcionCategoria
		From			Agenda.IntervinienteEvento		As  A With(Nolock)
		Inner Join		Expediente.Interviniente		As	B With(Nolock)
		On				B.TU_CodInterviniente			=	A.TU_CodInterviniente
		Inner Join		Expediente.Intervencion			As	C With(Nolock)
		On				C.TU_CodInterviniente			=	B.TU_CodInterviniente
		Inner Join		Catalogo.TipoIntervencion		As	D With(Nolock) 
		On				B.TN_CodTipoIntervencion		=	D.TN_CodTipoIntervencion
		Inner Join		Persona.Persona					As	E With(Nolock) 
		On				E.TU_CodPersona					=	C.TU_CodPersona
		Left Outer Join	Persona.PersonaFisica			As	F With(Nolock) 
		On				F.TU_CodPersona					=	E.TU_CodPersona
		Left Outer Join	Persona.PersonaJuridica			As	G With(Nolock) 
		On				G.TU_CodPersona					=	E.TU_CodPersona
		Left Outer Join	Catalogo.TipoIdentificacion		As	H With(Nolock) 
		On				H.TN_CodTipoIdentificacion		=	E.TN_CodTipoIdentificacion	
		Left Outer Join	Expediente.IntervinienteDelito 	As	I With(Nolock) 
		On				I.TU_CodInterviniente			=	A.TU_CodInterviniente	
		Left Outer Join	Catalogo.Delito					As	J With(Nolock)	 
		On				J.TN_CodDelito					=	I.TN_CodDelito
		Left Outer Join	Catalogo.CategoriaDelito		As	K 
		On				K.TN_CodCategoriaDelito			=	J.TN_CodCategoriaDelito
		Where			A.TU_CodEvento					=	@L_CodigoEvento			

	Set NoCount Off;
End
GO
